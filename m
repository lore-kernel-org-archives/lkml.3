Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760666AbaGYOLG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:11:06 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:57267 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752507AbaGYOLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:11:03 -0400
Message-ID: <53D26572.3030404@itdev.co.uk>
Date: Fri, 25 Jul 2014 15:10:58 +0100
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Yufeng Shen <miletus@google.com>, Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Sekhar Nori <nsekhar@ti.com>
Subject: Re: [PATCH 00/15] atmel_mxt_ts - device tree, bootloader, etc
References: <1404399697-26484-1-git-send-email-nick.dyer@itdev.co.uk> <53CECAEC.8080905@wwwdotorg.org> <53CFD50C.4040509@itdev.co.uk> <53CFEF6E.2060905@wwwdotorg.org> <53D10E78.4010908@itdev.co.uk> <53D17845.4020507@wwwdotorg.org>
In-Reply-To: <53D17845.4020507@wwwdotorg.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/07/14 22:19, Stephen Warren wrote:
>> mxt-app [device] --save fail.xcfg
> 
> That command always experiences a timeout error, but still seems to dump
> something out. Is this timeout error an issue? I'm a little hesitant to
> modify the COMMSCONFIG settings until I know load/save are really working.
>
> root@localhost:~/obp-utils# ./mxt-app -d i2c-dev:1-004b --save
> ~/mxt-save-no-movement.xml
> Version:1.16-65-g0a4c
> Registered i2c-dev adapter:1 address:0x4b
> Opening config file /root/mxt-save-no-movement.xml...
> REPORTALL command issued
> Timeout

The timeout is benign. In the mode that we're using it here, it is unable
to query the chip to query the configuration checksum, hence in the file it
says "CHECKSUM=0x000000". This won't affect --load/--save.

> I've uploaded 2 logs to:
> 
> http://avon.wwwdotorg.org/downloads/mxt-logs/
> (note there's no directory indexing, so manually add the filenames below to
> the URL)
> 
> mxt-save-no-movement.xml
> 
> This is with the whole series applied. Neither mouse movement nor clicks
> works. I tried mxt-app --reset and it made no difference to the dump results.
> 
> mxt-save-move-ok-no-clicking.xml
> 
> This is with "Input: atmel_mxt_ts - use deep sleep mode when stopped"
> reverted; mouse movement works, but clicking doesn't.

Great, this has identified the issue with mouse movement (touch).

The config programmed into the NVRAM on your touch controller has the first
byte of the T9 touchscreen object set to zero. This is the CTRL byte which
enables/disables the touch object and what it reports. It is relying on
this to enable the touchscreen on resume:

https://github.com/dtor/input/blob/9d8dc3e529/drivers/input/touchscreen/atmel_mxt_ts.c#L2005-L2006

My "use deep sleep mode when stopped" patch stops the driver writing to the
T9.CTRL byte, so whatever config you have in NVRAM for that byte will be
used (ie zero, disabled). Going forward, deep sleep is more generic.
Indeed, newer chips do not have T9 at all, or they might be using other
touch objects. The deep sleep mode is a lower power state to be in, and is
what Atmel recommends.

However, it does mean changing the maxtouch cfg - you can write the 0x83 to
the first byte of T9 and save it to NVRAM, by doing:

mxt-app [device] -W -T9 83
mxt-app [device] --backup

It should still work fine with the older driver, it will just be enabled
for an additional short time during bootup before the first call to
mxt_input_open().

About the clicking - what does getevent -lp show? It should show the
BTN_LEFT key. If that is working correctly, then the driver isn't parsing
the messages correctly, it would be useful if you could add a
mxt_dump_message() call to mxt_input_button() and capture some dmesg output
of pressing the button.

Thanks for your patience in debugging this.
