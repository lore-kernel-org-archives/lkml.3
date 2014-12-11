Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933432AbaLKQ3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 11:29:39 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:35181 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbaLKQ3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 11:29:38 -0500
Date: Thu, 11 Dec 2014 08:29:33 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH v5 1/3] hwmon: ina2xx: make shunt resistance configurable
 at run-time
Message-ID: <20141211162933.GA4769@roeck-us.net>
References: <1418207937-11648-1-git-send-email-bgolaszewski@baylibre.com>
 <1418207937-11648-2-git-send-email-bgolaszewski@baylibre.com>
 <548856AF.8090805@roeck-us.net>
 <CAMpxmJXp2NT+rie2d2+Z7hixKMyS+xcRNdKRNZaUSJD-aTUVVg@mail.gmail.com>
 <20141210183146.GA22847@roeck-us.net>
 <CAMpxmJXVPbp+XJQ9oVpAB3ejRx7Czb0KTC0HtfL9zed4Z_rOQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMpxmJXVPbp+XJQ9oVpAB3ejRx7Czb0KTC0HtfL9zed4Z_rOQA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020203.5489C671.044A,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On Thu, Dec 11, 2014 at 11:26:07AM +0100, Bartosz Golaszewski wrote:
> 2014-12-10 19:31 GMT+01:00 Guenter Roeck <linux@roeck-us.net>:
> > I don't really want it at all ;-). Seems to me all those options are broken
> > one way or another. The only real solution would be to re-instantiate the
> > driver if the chip was removed and re-inserted, and to provide parameters
> > either with platform data or with devicetree data.
> 
> I see your point, but as Benoit mentioned in one of the previous
> messages, in case of our platform it would be impossible to have an
> exhaustive list of possible shunt values.
> 
> > On a side note, data->rshunt is not really needed anymore with your current
> > code. The only reason for storing it in data is to use it in
> > ina2xx_calibration_val(), but you could as well pass it in as parameter
> > to that function. Even better would be to have a function such as
> > ina2xx_calibrate() and let it handle the write to the calibration register.
> > Also, I would suggest to move the above code into its own show function.
> > It is probably not a good idea to have a single function for all those
> > conversions in the first place, and converting from 'calibration' to
> > rshunt goes a bit beyond the original intent to convert from one representation
> > to the other.
> 
> I agree about having separate functions for this parameter and about
> not needing data->rshunt in my current code, but we still aren't clear
> about whether to read the value from the register or to store it in
> memory.
> 
Let's take the value from the register.

> > That still doesn't really solve the structural problem of having to deal with
> > an uninitialized chip which doesn't like to be uninitialized. But then on the
> > other side I guess that is really a problem with your platform, not a driver
> > problem.
> 
> This might be a stupid idea, but what about reading the calibration
> register first in ina2xx_update_device() and, in case it's value is 0
> (POR value according to the datasheet), reinitializing the chip?
> 
Not that stupid. Without programming the calibration register, the chip
will not report power and current. Expecting user space to "fix" the
situation if that happens seems to be at least as stupid as doing it in
the kernel (and, for example, the 'sensors' command won't be able to fix
it, nor any other program not running as root).

So it might make sense to move the chip initialization into an _init function,
call it from _probe, and call it from _update if, as you say, the calibration
register returns 0. The init function should initialize both the configuration
register and the calibration register. Make sure you update
data->reg[INA2XX_CALIBRATION] when you do that. In the latter case (update
function detects that chip is not initialized), you might also want to add
a dev_warn() as this is an unexpected situation.

Thanks,
Guenter
