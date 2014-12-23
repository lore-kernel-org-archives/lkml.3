Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbaLWNwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 08:52:30 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:38577 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbaLWNw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 08:52:28 -0500
Date: Tue, 23 Dec 2014 05:52:10 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Valdis.Kletnieks@vt.edu,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Jean Delvare <jdelvare@suse.de>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>
Subject: Re: [PATCH v4] i8k: Autodetect maximal fan speed and fan RPM
 multiplier
Message-ID: <20141223135210.GA6245@roeck-us.net>
References: <1419153618-6930-1-git-send-email-pali.rohar@gmail.com>
 <1419182630-20211-1-git-send-email-pali.rohar@gmail.com>
 <549724B2.4050209@roeck-us.net>
 <201412221607.34978@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201412221607.34978@pali>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020201.549973BE.023F,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On Mon, Dec 22, 2014 at 04:07:34PM +0100, Pali Rohár wrote:
> On Sunday 21 December 2014 20:51:14 Guenter Roeck wrote:
> > On 12/21/2014 09:23 AM, Pali Rohár wrote:
> > > This patch adds new function i8k_get_fan_nominal_speed() for
> > > doing SMM call which will return nominal fan RPM for
> > > specified fan speed. It returns nominal RPM value at which
> > > fan operate when speed (0, 1, 2, 3) is set. It looks like
> > > RPM value is not accurate, but still provides very useful
> > > information.
> > > 
> > > First it can be used to validate if certain fan speed could
> > > be accepted by SMM for setting fan speed and we can use
> > > this routine to detect maximal fan speed.
> > > 
> > > Second it returns RPM value, so we can check if value looks
> > > correct with multiplier 30 or multiplier 1 (until now only
> > > these two multiplier were used). If RPM value with
> > > multiplier 30 is too high, then multiplier 1 is used.
> > > 
> > > In case when SMM reports that new function is not supported
> > > we will fallback to old hardcoded values. Maximal fan speed
> > > would be 2 and RPM multiplier 30.
> > > 
> > > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> > > Tested-by: Pali Rohár <pali.rohar@gmail.com>
> > 
> > Auto-detection of both multiplier and maximum speed tested
> > working on M140 (after removing its configuration entry).
> > 
> > On Studio 1555, multiplier auto-detection works, but fan_max
> > auto-detection fails. A speed value of '3' is accepted, but
> > it does not set the fan speed to its maximum. Also, after
> > setting the speed value to '3', reading it back returns to
> > old value. No idea what it does or is expected to do. Reading
> > the nominal speed does return a valid value.
> > 
> > Given that, I think we should not try to auto-detect fan_max,
> > but keep the current code (meaning either use 2 or 3
> > depending on the configuration data, with 2 as default if
> > nothing else is known).
> > 
> > Thanks,
> > Guenter
> 
> Ok. In this case I will remove max fan speed detection code and 
> we will use config data for those some machines which support 
> TURBO speed. If multiplier detection on Studio is working fine, I 
> can send another patch which remove config data for Studio 
> (because default multiplier is 2).
> 
> Can you check which nominal value Studio returns for speed 3? 
> Maybe it is some special?
> 
It was a bit higher than the value returned for speed 2. Nothing special
as far as I could see, only that setting a value of 3 did not modify the
fan speed.

Note that I won't be able to test further in the next two weeks;
I am about 6,000 miles away from my Dell laptops right now.

Guenter
