Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932818AbaLJSb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 13:31:56 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:43829 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932479AbaLJSbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 13:31:55 -0500
Date: Wed, 10 Dec 2014 10:31:46 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH v5 1/3] hwmon: ina2xx: make shunt resistance configurable
 at run-time
Message-ID: <20141210183146.GA22847@roeck-us.net>
References: <1418207937-11648-1-git-send-email-bgolaszewski@baylibre.com>
 <1418207937-11648-2-git-send-email-bgolaszewski@baylibre.com>
 <548856AF.8090805@roeck-us.net>
 <CAMpxmJXp2NT+rie2d2+Z7hixKMyS+xcRNdKRNZaUSJD-aTUVVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMpxmJXp2NT+rie2d2+Z7hixKMyS+xcRNdKRNZaUSJD-aTUVVg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020204.54889196.03AC,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 2
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 05:46:43PM +0100, Bartosz Golaszewski wrote:
> 2014-12-10 15:20 GMT+01:00 Guenter Roeck <linux@roeck-us.net>:
> >> +       case INA2XX_CALIBRATION:
> >> +               if (data->regs[reg] == 0)
> >> +                       val = 0;
> >> +               else
> >> +                       val = data->config->calibration_factor
> >> +                                               / data->regs[reg];
> >> +               break;
> >
> >
> > This doesn't really make sense. What you want to show is rshunt, not the
> > above.
> > I think it would be better to write a separate show function to display it.
> 
> Hi Guenter,
> 
> this is the only way to display values read from the chip. It also
> tells the user what the actual programmed value is. In fact it was
> your suggestion (https://lkml.org/lkml/2014/11/30/233) and I agree
> that it's a better alternative. Are you sure you don't want it done
> this way?
> 
I don't really want it at all ;-). Seems to me all those options are broken
one way or another. The only real solution would be to re-instantiate the
driver if the chip was removed and re-inserted, and to provide parameters
either with platform data or with devicetree data.

On a side note, data->rshunt is not really needed anymore with your current
code. The only reason for storing it in data is to use it in
ina2xx_calibration_val(), but you could as well pass it in as parameter
to that function. Even better would be to have a function such as
ina2xx_calibrate() and let it handle the write to the calibration register.
Also, I would suggest to move the above code into its own show function.
It is probably not a good idea to have a single function for all those
conversions in the first place, and converting from 'calibration' to
rshunt goes a bit beyond the original intent to convert from one representation
to the other.  

That still doesn't really solve the structural problem of having to deal with
an uninitialized chip which doesn't like to be uninitialized. But then on the
other side I guess that is really a problem with your platform, not a driver
problem.

Guenter
