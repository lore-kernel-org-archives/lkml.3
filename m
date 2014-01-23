Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172AbaAWE5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 23:57:53 -0500
Received: from mail.fpasia.hk ([202.130.89.98]:39230 "EHLO fpa01n0.fpasia.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311AbaAWE5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 23:57:51 -0500
Message-ID: <52E0A19E.1040009@gtsys.com.hk>
Date: Thu, 23 Jan 2014 12:59:10 +0800
From: Chris Ruehl <chris.ruehl@gtsys.com.hk>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131104 Icedove/17.0.10
MIME-Version: 1.0
To: Peter Chen <peter.chen@freescale.com>
CC: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: Regression on next-20140116 [Was: [PATCH 3/3 v4] usb: chipidea:
 hw_phymode_configure moved before ci_usb_phy_init]
References: <1386057710-3848-1-git-send-email-chris.ruehl@gtsys.com.hk> <1386057710-3848-3-git-send-email-chris.ruehl@gtsys.com.hk> <20140122094951.GO26766@pengutronix.de> <20140122214133.GP26766@pengutronix.de> <20140123012240.GA8679@shlinux1.ap.freescale.net>
In-Reply-To: <20140123012240.GA8679@shlinux1.ap.freescale.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 23, 2014 09:22 AM, Peter Chen wrote:
> On Wed, Jan 22, 2014 at 10:41:33PM +0100, Uwe Kleine-König wrote:
>> Hello,
>>
>> On Wed, Jan 22, 2014 at 10:49:51AM +0100, Uwe Kleine-König wrote:
>>> On Tue, Dec 03, 2013 at 04:01:50PM +0800, Chris Ruehl wrote:
>>>> usb: chipidea: hw_phymode_configure moved before ci_usb_phy_init
>>>> hw_phymode_configure configures the PORTSC registers and allow the
>>>> following phy_inits to operate on the right parameters. This fix a problem
>>>> where the UPLI (ISP1504) could not detected, because the Viewport was not
>>>> available and read the viewport return 0's only.
>>> This patch (or a later revision of it to be more exact) made it into
>>> mainline as cd0b42c2a6d2.
>>>
>>> On an i.MX27 based machine I'm hitting an oops (see below) on
>>> next-20140116 + a few patches. (I didn't switch to 3.13+ yet, as I think
>>> not everything I need has landed there.) The oops goes away (and still
>>> better, lsusb reports my connected devices instead of "unable to
>>> initialize libusb: -99") when I do at least one of the following:
>>>
>>>   - set CONFIG_USB_CHIPIDEA=y instead of =m
>>>   - revert commit
>>>        cd0b42c2a6d2 (usb: chipidea: put hw_phymode_configure before ci_usb_phy_init)
>> I debugged that a bit further and the problem is that
>> hw_phymode_configure depends on the phy's clk being enabled (i.e.
>> usb_ipg_gate) and this is only enforced in ci_usb_phy_init (via
>> usb_phy_init -> usb_gen_phy_init). When CONFIG_USB_CHIPIDEA=y the init
>> call to disable all unused clocks wasn't run yet and so the clock is
>> still on as this is the boot default.
> Hi Uwe,
> I am a little puzzled at your platform
>
> - Which phy you have used? ulpi phy ,internal phy or other external phy?
> - If you use ulpi phy, why you still need to use nop phy driver?
>   Besides, according to chris patch, the ulpi can only be visited after
> hw_phymode_configure?
> - Do you have some hardware related operation at phy's probe? If it exists,
> why not move it to phy->init?
>
> Peter
Peter,
I think thats my fault, I send Uwe my patches which call the phy-ulpi 
from the nop driver
in order to get the ISP1504 running with my board.

Its obversely wrong to call an other driver from the nop
see:  [PATCH 3/3] usb: phy-generic: Add ULPI VBUS support and the 
concerns from
Heikki (mail-list linux-usb)

Uwe we may work together on this.

Chris

>> Considering that it's already late today and that I don't know the
>> chipidea driver I'm sure there are people who can come up with a better
>> patch with less effort than me. Any volunteers?
>>
>> Best regards
>> Uwe
>>
>> -- 
>> Pengutronix e.K.                           | Uwe Kleine-König            |
>> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
>>
>>

