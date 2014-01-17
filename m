Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbaAQW1s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 17:27:48 -0500
Received: from mail.sensor-technik.de ([80.150.181.156]:47305 "EHLO
	mail.sensor-technik.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbaAQW1p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 17:27:45 -0500
X-IronPort-AV: E=Sophos;i="4.95,676,1384297200"; 
   d="scan'208";a="527429"
From: Waibel Georg <Georg.Waibel@sensor-technik.de>
To: Gerhard Sittig <gsi@denx.de>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: AW: [PATCH 1/1] iMX gpio: Allow reading back of pin status if
 configured as gpio output
Thread-Topic: [PATCH 1/1] iMX gpio: Allow reading back of pin status if
 configured as gpio output
Thread-Index: Ac8Tjf3aVV6M/uKQT66xiOgnnC2hVQACO1mAAA5hlrw=
Date: Fri, 17 Jan 2014 22:27:10 +0000
Message-ID: <E1C9442006A9AE48A7A4B85E0D01C4D474F13C@stwexdb.stww2k.local>
References: <E1C9442006A9AE48A7A4B85E0D01C4D474F059@stwexdb.stww2k.local>,<20140117161513.GC20094@book.gsilab.sittig.org>
In-Reply-To: <20140117161513.GC20094@book.gsilab.sittig.org>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.25.2.8]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-TBoneOriginalFrom: Waibel Georg <Georg.Waibel@sensor-technik.de>
X-TBoneOriginalTo: Gerhard Sittig <gsi@denx.de>
X-TBoneOriginalCC: Linus Walleij <linus.walleij@linaro.org>, Alexandre Courbot
	<gnurou@gmail.com>, "linux-gpio@vger.kernel.org"
	<linux-gpio@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
X-TBoneDomainSigned: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Jan 17, 2014 at 14:11 +0000, Waibel Georg wrote:
> >
> > From cb384950a1153e856ec03109a5156e660a89bf6d Mon Sep 17 00:00:00 2001
> > From: Georg Waibel <georg.waibel@sensor-technik.de>
> > Date: Fri, 17 Jan 2014 14:51:38 +0100
> > Subject: [PATCH 1/1] iMX gpio: Allow reading back of pin status if configured
> >  as gpio output
> >
> > Register PSR was used to read the pin status in the mxc_gpio driver. This
> > register reflects the pin status if a pin is configured as gpio input.
> > If a pin is configured as an gpio output register PSR is not updated and
> > returns 0 instead of the actual pin status. Thus attempting to read back the
> > status of an gpio output pin via PSR returns a wrong value.
> >
> > Reading register DR instead of PSR fixes this issue:
> > - If pin is gpio output: DR returns the value written to DR by software
> > - If pin is gpio input: DR returns the value of register PSR und thus the
> >   pin status
> 
> Got curious because of your specific wording.  In the output
> case, does the DR value reflect what you drive to the pin, or
> what the pin's status is?  Because this need not be identical in
> the open collector case (or other "weak" scenarios like bus
> keeper, and what else HW development came up with).
> 
> If DR always reflects the pin's status, then the patch would be
> OK but the commit message would need an update.  If DR does not
> appropriately reflect the pin's status, then the patch would be
> an improvement (would fix the totem-pole case), but still would
> be wrong or incomplete in the open-collector case.


Hi Gerhard,

actually I did not take the open-collector case into account. 
I checked the iMX6q reference manual and came to this conclusion:

In the output case, reading register DR returns the value I have written 
to DR, not the actual pad state. Thus may patch only works for the 
push-pull (totem-pole) output case, not for open-drain.

However, there is a solution to read back the pin status regardless of 
its input or output configuration. Its the SION (Software Input On Bit)
in the IOMUXC MUX control register. If SION is set, the pad status can be 
read back through register PSR. Thats exactly what I intended to do. 
Bit SION can be set in the device tree (IOMUXC: CONFIG filed in the 
fsl,pins binding, bit 30).
I will verify this on my iMX6 hardware next week.

Seems there is no need for my patch at all.

Thanks for your hint.
Regards
Georg

