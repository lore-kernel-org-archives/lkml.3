Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab3LRRYL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 12:24:11 -0500
Received: from mail-pd0-f196.google.com ([209.85.192.196]:65181 "EHLO
	mail-pd0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388Ab3LRRYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 12:24:06 -0500
Date: Wed, 18 Dec 2013 09:24:02 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        "open list:HARDWARE MONITORING" <lm-sensors@lm-sensors.org>,
        Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [lm-sensors] [PATCH V1] fix adc to voltage calculation in da9052
 power driver
Message-ID: <20131218172402.GA18892@roeck-us.net>
References: <201312181524.rBIFOv96017094@swsrvapps-02.lan>
 <20131218163234.714a166c@endymion.delvare>
 <24DF37198A1E704D9811D8F72B87EB51847ABF61@NB-EX-MBX02.diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24DF37198A1E704D9811D8F72B87EB51847ABF61@NB-EX-MBX02.diasemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 03:45:32PM +0000, Opensource [Anthony Olech] wrote:
> > -----Original Message-----
> > From: Jean Delvare [mailto:khali@linux-fr.org]
> > Sent: 18 December 2013 15:33
> > To: Opensource [Anthony Olech]
> > Cc: Anton Vorontsov; David Woodhouse; David Dajun Chen; open list; open
> > list:HARDWARE MONITORING
> > Subject: Re: [lm-sensors] [PATCH V1] fix adc to voltage calculation in da9052
> > power driver
> > On Wed, 18 Dec 2013 15:21:13 +0000, Anthony Olech wrote:
> > > The ADC resolution of the PMIC is 10-bits, this means that the maximum
> > > possible value is 1023 and not the 1024 as in the code.
> > The conversion from register value to mV depends on the ADC's LSB, not its
> > range. So the maximum value which can be represented is irrelevant.
> 
> thanks for the speedy response, but the converted value returned by the function
> does depend on the scaling.
> 
> For example take the two cases where value in 0x1F0, then the erroneous previous
> calculation yields 3469 and the new corrected calculation yields 3470
> 
> So please apply the patch as it truly fixes an error.
> 
AFAICS the previous calculation should return 3468. Replacing the division by
512 with DIV_ROUND_CLOSEST would return 3469, and the new calculation would
return 3470.

Still, an ADC would typically have an LSB. Question here is what that LSB is
(in mV), or in other words what the maximim voltage represented by 0x3ff is.
Current assumption is that it is 1.9531 mV or 2000/1024, which admittedly
is odd. It might be 2000/1023 = 1.9550 mV, or it might be 2 mV.

Thanks,
Guenter

> many thanks
> 
> Tony Olech
> 
> > > Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
> > > ---
> > > This patch is relative to linux-next repository tag next-20131218
> > >  drivers/power/da9052-battery.c |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > diff --git a/drivers/power/da9052-battery.c
> > > b/drivers/power/da9052-battery.c index f8f4c0f..8f0f259 100644
> > > --- a/drivers/power/da9052-battery.c
> > > +++ b/drivers/power/da9052-battery.c
> > > @@ -178,7 +178,7 @@ struct da9052_battery {
> > >  static inline int volt_reg_to_mV(int value)  {
> > > -	return ((value * 1000) / 512) + 2500;
> > > +	return DIV_ROUND_CLOSEST(value * 2000, 1023) + 2500;
> > >  }
> > >  static inline int ichg_reg_to_mA(int value)
> > --
> > Jean Delvare
> 
> _______________________________________________
> lm-sensors mailing list
> lm-sensors@lm-sensors.org
> http://lists.lm-sensors.org/mailman/listinfo/lm-sensors
> 
