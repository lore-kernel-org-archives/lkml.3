Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab3BNFQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 00:16:52 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:48235 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990Ab3BNFQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 00:16:51 -0500
From: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "khilman@deeprootsystems.com" <khilman@deeprootsystems.com>
Subject: RE: [PATCH RFC] davinci: poll for sleep completion in resume
 routine.
Thread-Topic: [PATCH RFC] davinci: poll for sleep completion in resume
 routine.
Thread-Index: AQHN/5XxpHn9OjBrUkS7PDbkGefup5h4eXOAgABmwlA=
Date: Thu, 14 Feb 2013 05:16:36 +0000
Message-ID: <A4887BF146CD57468F700B415D2F470158374E@DBDE01.ent.ti.com>
References: <1359624393-5898-1-git-send-email-manishv.b@ti.com>
 <511C65B3.7060109@ti.com>
In-Reply-To: <511C65B3.7060109@ti.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1E5HAnD002745

Hi Sekhar,

On Thu, Feb 14, 2013 at 09:48:59, Nori, Sekhar wrote:
> Manish,
> 
> On 1/31/2013 2:56 PM, Vishwanathrao Badarkhe, Manish wrote:
> > As per OMAP-L138 TRM, Software must poll for SLEEPCOMPLETE bit until 
> > it is set to 1 before clearing SLEEPENABLE bit in DEEPSLEEP register 
> > in resume routine.
> > Modifications are as per datasheet:
> > http://www.ti.com/lit/ug/spruh77a/spruh77a.pdf
> > See sections 10.10.2.2 and 11.5.21 for more detailed explanation.
> 
> Polling for SLEEPCOMPLETE is not required in RTC controlled wake-up which is the mode currently supported (see section 10.10.2.1 of the TRM). Polling for SLEEPCOMPLETE is required for external controlled wake-up which to my knowledge has never been tested. If you have tested this with external controlled wakep-up, then I can consider this patch.
> Else, I would like to take it only after externally controlled wake-up is fully tested/supported instead of taking bits and pieces.

Yes, for RTC controlled wakeup, this polling is not required as per section 10.10.2.1.
But if we see in section 10.10.2.2 (Exiting Deep Sleep Mode) step 2, When sleep count 
completes SLEEPCOMPLETE bit gets sets in DEEPSLEEP register till that it's not safe to 
release clock to devices. So If we donâ€™t poll for SLEEPCOMPLETE, this delay will not
come into picture which we actually set while entering deep sleep in case of RTC 
controlled wakeup (Section 10.10.2.1 step 9). 
Please let me know, whether these understanding is correct?

For external controlled wakeup, we need to do hardware modifications and hence, Yet to 
be tested external controlled wakeup functionality.

Thanks, 
Manish Badarkhe

> > 
> > Tested on da850-evm.
> > 
> > Signed-off-by: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com>
> > ---
> > :100644 100644 d4e9316... 976f096... M	arch/arm/mach-davinci/sleep.S
> >  arch/arm/mach-davinci/sleep.S |    8 ++++++++
> >  1 files changed, 8 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/arm/mach-davinci/sleep.S 
> > b/arch/arm/mach-davinci/sleep.S index d4e9316..976f096 100644
> > --- a/arch/arm/mach-davinci/sleep.S
> > +++ b/arch/arm/mach-davinci/sleep.S
> > @@ -35,6 +35,7 @@
> >  #define PLL_LOCK_CYCLES		(PLL_LOCK_TIME * 25)
> >  
> >  #define DEEPSLEEP_SLEEPENABLE_BIT	BIT(31)
> > +#define DEEPSLEEP_SLEEPCOMPLETE_BIT 	BIT(30)
> >  
> >  	.text
> >  /*
> > @@ -110,6 +111,13 @@ ENTRY(davinci_cpu_suspend)
> >  
> >  	/* Wake up from sleep */
> >  
> > +	/* wait for sleep complete */
> > +sleep_complete:
> > +	ldr 	ip, [r4]
> > +	and 	ip, ip, #DEEPSLEEP_SLEEPCOMPLETE_BIT
> > +	cmp 	ip, #DEEPSLEEP_SLEEPCOMPLETE_BIT
> > +	bne 	sleep_complete
> > +
> >  	/* Clear sleep enable */
> >  	ldr	ip, [r4]
> >  	bic	ip, ip, #DEEPSLEEP_SLEEPENABLE_BIT
> > 
> 


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
