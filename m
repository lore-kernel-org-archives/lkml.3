Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab3LSONS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 09:13:18 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.138]:25852 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753476Ab3LSONP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 09:13:15 -0500
X-Env-Sender: anthony.olech.opensource@diasemi.com
X-Msg-Ref: server-15.tower-180.messagelabs.com!1387462391!28454105!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
To: Guenter Roeck <linux@roeck-us.net>,
        "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
CC: Jean Delvare <khali@linux-fr.org>,
        "open list:HARDWARE MONITORING" <lm-sensors@lm-sensors.org>,
        Anton Vorontsov <anton@enomsg.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: RE: [lm-sensors] [PATCH V1] fix adc to voltage calculation in
 da9052 power driver
Thread-Topic: [lm-sensors] [PATCH V1] fix adc to voltage calculation in
 da9052 power driver
Thread-Index: AQHO/BX4D47Jr6rAM0azknGXH6yv+5pbj3kw
Date: Thu, 19 Dec 2013 14:13:09 +0000
Message-ID: <24DF37198A1E704D9811D8F72B87EB51847AC2C3@NB-EX-MBX02.diasemi.com>
References: <201312181524.rBIFOv96017094@swsrvapps-02.lan>
 <20131218163234.714a166c@endymion.delvare>
 <24DF37198A1E704D9811D8F72B87EB51847ABF61@NB-EX-MBX02.diasemi.com>
 <20131218172402.GA18892@roeck-us.net>
In-Reply-To: <20131218172402.GA18892@roeck-us.net>
Accept-Language: en-GB, de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.24.126]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Guenter Roeck [mailto:groeck7@gmail.com] On Behalf Of Guenter
> Roeck
> Sent: 18 December 2013 17:24
> To: Opensource [Anthony Olech]
> Cc: Jean Delvare; open list:HARDWARE MONITORING; Anton Vorontsov;
> David Woodhouse; open list; David Dajun Chen
> Subject: Re: [lm-sensors] [PATCH V1] fix adc to voltage calculation in da9052
> power driver
> On Wed, Dec 18, 2013 at 03:45:32PM +0000, Opensource [Anthony Olech]
> wrote:
> > > -----Original Message-----
> > > From: Jean Delvare [mailto:khali@linux-fr.org]
> > > Sent: 18 December 2013 15:33
> > > To: Opensource [Anthony Olech]
> > > Cc: Anton Vorontsov; David Woodhouse; David Dajun Chen; open list;
> > > open list:HARDWARE MONITORING
> > > Subject: Re: [lm-sensors] [PATCH V1] fix adc to voltage calculation
> > > in da9052 power driver On Wed, 18 Dec 2013 15:21:13 +0000, Anthony
> > > Olech wrote:
> > > > The ADC resolution of the PMIC is 10-bits, this means that the
> > > > maximum possible value is 1023 and not the 1024 as in the code.
> > > The conversion from register value to mV depends on the ADC's LSB,
> > > not its range. So the maximum value which can be represented is
> irrelevant.
> > thanks for the speedy response, but the converted value returned by
> > the function does depend on the scaling.
> > For example take the two cases where value in 0x1F0, then the
> > erroneous previous calculation yields 3469 and the new corrected
> > calculation yields 3470
> > So please apply the patch as it truly fixes an error.
> AFAICS the previous calculation should return 3468. Replacing the division by
> 512 with DIV_ROUND_CLOSEST would return 3469, and the new calculation
> would return 3470.
> Still, an ADC would typically have an LSB. Question here is what that LSB is (in
> mV), or in other words what the maximim voltage represented by 0x3ff is.
> Current assumption is that it is 1.9531 mV or 2000/1024, which admittedly is
> odd. It might be 2000/1023 = 1.9550 mV, or it might be 2 mV.

the maximum voltage represented by 0x3ff is 2000 mV, so the existing code is
incorrect and the patch is to correct the error.

many thanks for your comment,

Tony Olech
 
> Thanks,
> Guenter
> > many thanks
> > Tony Olech
> > > > Signed-off-by: Anthony Olech
> > > > <anthony.olech.opensource@diasemi.com>
> > > > This patch is relative to linux-next repository tag next-20131218
> > > >  drivers/power/da9052-battery.c |    2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-) diff --git
> > > > a/drivers/power/da9052-battery.c b/drivers/power/da9052-battery.c
> > > > index f8f4c0f..8f0f259 100644
> > > > --- a/drivers/power/da9052-battery.c
> > > > +++ b/drivers/power/da9052-battery.c
> > > > @@ -178,7 +178,7 @@ struct da9052_battery {  static inline int
> > > > volt_reg_to_mV(int value)  {
> > > > -	return ((value * 1000) / 512) + 2500;
> > > > +	return DIV_ROUND_CLOSEST(value * 2000, 1023) + 2500;
> > > >  }
> > > >  static inline int ichg_reg_to_mA(int value)
> > > Jean Delvare 
