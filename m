Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab3LSOzg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 09:55:36 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:43740 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab3LSOze convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 09:55:34 -0500
Date: Thu, 19 Dec 2013 15:54:54 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Anthony Olech <anthony.olech.opensource@diasemi.com>
Cc: Guenter Roeck <linux@roeck-us.net>, lm-sensors@lm-sensors.org,
        Anton Vorontsov <anton@enomsg.org>,
        "David Woodhouse" <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [lm-sensors] [PATCH V1] fix adc to voltage calculation in 
 da9052 power driver
Message-ID: <20131219155454.40100f4d@endymion.delvare>
In-Reply-To: <24DF37198A1E704D9811D8F72B87EB51847AC2C3@NB-EX-MBX02.diasemi.com>
References: <201312181524.rBIFOv96017094@swsrvapps-02.lan>
	<20131218163234.714a166c@endymion.delvare>
	<24DF37198A1E704D9811D8F72B87EB51847ABF61@NB-EX-MBX02.diasemi.com>
	<20131218172402.GA18892@roeck-us.net>
	<24DF37198A1E704D9811D8F72B87EB51847AC2C3@NB-EX-MBX02.diasemi.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anthony,

On Thu, 19 Dec 2013 14:13:09 +0000, Opensource [Anthony Olech] wrote:
> > -----Original Message-----
> > From: Guenter Roeck [mailto:groeck7@gmail.com] On Behalf Of Guenter
> > Roeck
> > Sent: 18 December 2013 17:24
> > To: Opensource [Anthony Olech]
> > Cc: Jean Delvare; open list:HARDWARE MONITORING; Anton Vorontsov;
> > David Woodhouse; open list; David Dajun Chen
> > Subject: Re: [lm-sensors] [PATCH V1] fix adc to voltage calculation in da9052
> > power driver
> > On Wed, Dec 18, 2013 at 03:45:32PM +0000, Opensource [Anthony Olech]
> > wrote:
> > > > -----Original Message-----
> > > > From: Jean Delvare [mailto:khali@linux-fr.org]
> > > > Sent: 18 December 2013 15:33
> > > > To: Opensource [Anthony Olech]
> > > > Cc: Anton Vorontsov; David Woodhouse; David Dajun Chen; open list;
> > > > open list:HARDWARE MONITORING
> > > > Subject: Re: [lm-sensors] [PATCH V1] fix adc to voltage calculation
> > > > in da9052 power driver On Wed, 18 Dec 2013 15:21:13 +0000, Anthony
> > > > Olech wrote:
> > > > > The ADC resolution of the PMIC is 10-bits, this means that the
> > > > > maximum possible value is 1023 and not the 1024 as in the code.
> > > > The conversion from register value to mV depends on the ADC's LSB,
> > > > not its range. So the maximum value which can be represented is
> > irrelevant.
> > > thanks for the speedy response, but the converted value returned by
> > > the function does depend on the scaling.
> > > For example take the two cases where value in 0x1F0, then the
> > > erroneous previous calculation yields 3469 and the new corrected
> > > calculation yields 3470
> > > So please apply the patch as it truly fixes an error.
> > AFAICS the previous calculation should return 3468. Replacing the division by
> > 512 with DIV_ROUND_CLOSEST would return 3469, and the new calculation
> > would return 3470.
> > Still, an ADC would typically have an LSB. Question here is what that LSB is (in
> > mV), or in other words what the maximim voltage represented by 0x3ff is.
> > Current assumption is that it is 1.9531 mV or 2000/1024, which admittedly is
> > odd. It might be 2000/1023 = 1.9550 mV, or it might be 2 mV.
> 
> the maximum voltage represented by 0x3ff is 2000 mV, so the existing code is
> incorrect and the patch is to correct the error.

What makes you think so? The datasheet is not public so unfortunately I
cannot check it myself. Please quote the parts of the datasheet which
you think are relevant to convince us.

I and Guenter are only speaking by experience. Product briefs often
mention the ADC range as an informative value and this is not something
you can rely on. For example 8-bit ADC are often referred to as having
a 2 V, 3 V or 4 V range, while when you look at the datasheet, they
have a 8 mV, 12 mV or 16 mV LSB, which means their actual range is
2.048 V, 3.072 V and 4.096 V respectively.

Additionally, due to the limited resolution, each ADC value represents
a range of input values, rather than an input value. 0x00 doesn't mean
"0 mV", is typically means "less than whatever 1 LSB represents". Some
datasheets are very clear on that, see for example the ADT7490
datasheet, page 16, table 7, "10−Bit ADC Output Code vs. V IN". This
means that what the drivers report (register value * LSB) is off by 0.5
LSB on average. All drivers do that and this is considered OK.

This also means that the top value of the range is never reported.
Consider an 8-bit ADC with a LSB of 16 mV, it's range is 4.096 V but
the top value (0xff) really means "4.080 V <= input value". Which
the driver will report as 4.080 V by convention.

BTW, you (and we) probably shouldn't waste too much energy on this.
ADCs are only accurate to some degree anyway. If you take the
components connected to the input into consideration, the accuracy gets
even worse. For example, if the input voltage must be scaled down to
fit in the ADC's range, you need at least one resistor, which in best
cases will have a 1% accurate value (known as tolerance.) That's ten
times the LSB of your 10-bit ADC, at which point / 1023 or / 1024
really makes no practical difference. Sub-percent tolerant resistors are
expensive and rare in consumer electronics in my experience.

-- 
Jean Delvare
