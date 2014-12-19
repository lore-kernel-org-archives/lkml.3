Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbaLST2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 14:28:24 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:54311 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbaLST2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 14:28:19 -0500
Date: Fri, 19 Dec 2014 11:28:08 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Valdis.Kletnieks@vt.edu,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Jean Delvare <jdelvare@suse.de>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>
Subject: Re: [PATCH v2 1/2] i8k: Autodetect maximal fan speed and fan RPM
 multiplier
Message-ID: <20141219192808.GA8493@roeck-us.net>
References: <1418155621-21644-1-git-send-email-pali.rohar@gmail.com>
 <1419012268-20805-1-git-send-email-pali.rohar@gmail.com>
 <20141219183237.GA6767@roeck-us.net>
 <201412191951.25562@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201412191951.25562@pali>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020203.54947C52.028C,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 4
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

On Fri, Dec 19, 2014 at 07:51:25PM +0100, Pali Rohár wrote:
> On Friday 19 December 2014 19:32:37 Guenter Roeck wrote:
> > > -static int i8k_fan_mult;
> > > -static int i8k_pwm_mult;
> > > -static int i8k_fan_max = I8K_FAN_HIGH;
> > > +static int i8k_fan_mult[2];
> > > +static int i8k_pwm_mult[2];
> > > +static int i8k_fan_max[2];
> > 
> > The rationale for this change is not explained in the commit
> > log.
> > 
> > Do you have any indication that those values would ever be
> > different for the two fans, ie that you actually need arrays
> > here ?
> > 
> 
> I do not know... But if we decide to use only single value for 
> multiplier and max value which fan to use for autodetection?
> 
That does not answer my question. That you can not decide which
fan to use for auto-detection does not mean that the result of
that auto-detection would be different for different fans.

> > > @@ -271,8 +274,25 @@ static int i8k_get_fan_speed(int fan)
> > > 
> > >  {
> > >  
> > >  	struct smm_regs regs = { .eax = I8K_SMM_GET_SPEED, };
> > > 
> > > +	if (fan < 0 || fan >= ARRAY_SIZE(i8k_fan_mult))
> > > +		return -EINVAL;
> > > +
> > 
> > This range check (and probably others) is still unnecessary.
> > 
> > Guenter
> > 
> 
> No, it is necessary. Function i8k_get_fan_speed is called from 
> ioctl callback with value which comes from userspace. If 
> userspace specify fan out of that array we can get kernel panic.
> 
Yes, but just because you introduced an array for various variables,
and you still have the unnecessary check for other callers.

If you want to return -EINVAL for bad ioctl parameters, add a range
check check there. But that would be a separate patch.

Guenter

> > >  	regs.ebx = fan & 0xff;
> > > 
> > > -	return i8k_smm(&regs) ? : (regs.eax & 0xffff) *
> > > i8k_fan_mult; +	return i8k_smm(&regs) ? : (regs.eax &
> > > 0xffff) * i8k_fan_mult[fan]; +}
> 
> -- 
> Pali Rohár
> pali.rohar@gmail.com


