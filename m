Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbaG2RGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 13:06:15 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:21145 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750708AbaG2RGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 13:06:13 -0400
Message-ID: <53D7D47E.5060906@itdev.co.uk>
Date: Tue, 29 Jul 2014 18:06:06 +0100
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>, Yufeng Shen <miletus@chromium.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        benson Leung <bleung@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Olof Johansson <olofj@chromium.org>, Sekhar Nori <nsekhar@ti.com>
Subject: Re: [PATCH 00/15] atmel_mxt_ts - device tree, bootloader, etc
References: <1404399697-26484-1-git-send-email-nick.dyer@itdev.co.uk>	<53CECAEC.8080905@wwwdotorg.org>	<53CFD50C.4040509@itdev.co.uk>	<53CFEF6E.2060905@wwwdotorg.org>	<53D10E78.4010908@itdev.co.uk>	<53D17845.4020507@wwwdotorg.org>	<53D26572.3030404@itdev.co.uk>	<53D2B8D0.5090000@wwwdotorg.org>	<CAPDwgkNrBRJRR6WtoPSfs8Yq=ui-Ptjju4mJ=9h=95YVFuxw7g@mail.gmail.com>	<53D6BF50.3070306@wwwdotorg.org>	<53D6DFE7.3040901@wwwdotorg.org> <CAPDwgkPL1utj3DFoFbOCcJsASpf+12nvKg1KcseV_MhEz66eiw@mail.gmail.com> <53D7C8CC.1050201@wwwdotorg.org>
In-Reply-To: <53D7C8CC.1050201@wwwdotorg.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/07/14 17:16, Stephen Warren wrote:
> I then tried updating the firmware. This didn't work at all.
> 
> First I tried via mxt-app:
> 
>> root@localhost:~# ./obp-utils/mxt-app -d i2c-dev:1-004b --flash
>> 130.1_1.0.170.bin
>> Version:1.16-65-g0a4c
>> Opening firmware file 130.1_1.0.170.bin
>> Registered i2c-dev adapter:1 address:0x4b
>> Chip detected
>> Current firmware version: 1.0.AA
>> Skipping version check
>> Resetting in bootloader mode
>> Registered i2c-dev adapter:1 address:0x25
>> Error Remote I/O error (121) reading from i2c
>> Bootloader read failure
>> Bootloader not found
> 
> Then I power-cycled and tried via the atmel_mxt_ts modules' sysfs files:
> 
>> root@localhost:~# echo 1 >
>> /sys/devices/soc0/7000c400.i2c/i2c-1/1-004b/update_fw
>> [   38.495420] atmel_mxt_ts 1-004b: mxt_bootloader_read: i2c recv failed
>> (-121)
>> [   38.506208] atmel_mxt_ts 1-004b: mxt_bootloader_read: i2c recv failed
>> (-121)
>> [   38.513836] atmel_mxt_ts 1-004b: The firmware update failed(-121)
>> -bash: echo: write error: Remote I/O error

OK - that's the same error in both cases, it has tried to switch the device
into bootloader mode, however it is not responding on the bootloader I2C
address.

Couple of things to check:
- is the device in deep sleep mode when you run the mxt-app command? can
you try doing "mxt-app [device] -W -T7 FFFF" which will make sure it is
definitely not sleeping first.
- if you do "mxt-app [device] -i" straight after the --flash failure, does
it respond (which would mean it hasn't actioned the reset-into-bootloader
command)

> I also found that removing the module (even without attempting a FW update)
> yields:
> 
> After attempted FW update via sysfs:
> 
>> root@localhost:~# rmmod ./atmel_mxt_ts.ko
>> [   81.995672] Unable to handle kernel NULL pointer dereference at virtual address 00000364

Not good. It's trying to free an input device which isn't registered at
that point. In a later patch in my series I add a guard around that
(mxt_free_input_device):
https://github.com/ndyer/linux/commit/bb4800ff8c185
