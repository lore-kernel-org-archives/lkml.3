Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbbABWDz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 17:03:55 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:34063 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbbABWDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 17:03:54 -0500
Date: Fri, 2 Jan 2015 22:03:52 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs: isofs: Fix bug in the way to check if the year is a
 leap year
Message-ID: <20150102220352.GW22149@ZenIV.linux.org.uk>
References: <1420214928-7104-1-git-send-email-oscar.forner.martinez@gmail.com>
 <20150102171030.GR22149@ZenIV.linux.org.uk>
 <CADZ0XgJMzsgSBZEJdQ5FqEWVB+Y_ZHD0Vy5HFy-hbWVjwqy7KA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADZ0XgJMzsgSBZEJdQ5FqEWVB+Y_ZHD0Vy5HFy-hbWVjwqy7KA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2015 at 09:26:35PM +0000, Oscar Forner Martinez wrote:

> I did not know that function.

Neither did I ;-)  What I'd done was

; git grep -n -w date.*seconds
drivers/rtc/rtc-lib.c:117: * Convert Gregorian date to seconds since 01-01-1970 00:00:00.
fs/fat/misc.c:192:/* Convert a FAT time/date pair to a UNIX date (seconds since 1 1 70). */
fs/ncpfs/dir.c:1193:/* Convert a MS-DOS time/date pair to a UNIX date (seconds since 1 1 70). */
fs/nfs/nfs4proc.c:6868:                 clp->cl_implid->date.seconds,
fs/nfs/nfs4proc.c:6869:                 clp->cl_implid->date.nseconds);
fs/nfs/nfs4xdr.c:5532:          p = xdr_decode_hyper(p, &res->impl_id->date.seconds);
fs/nfs/nfs4xdr.c:5533:          res->impl_id->date.nseconds = be32_to_cpup(p);
fs/nfs/super.c:762:                        impl_id->date.seconds, impl_id->date.nseconds);
kernel/time/time.c:308: * mktime64 - Converts date to seconds.
kernel/time/time.c:309: * Converts Gregorian date to seconds since 1970-01-01 00:00:00.
scripts/analyze_suspend.py:165:                 utcoffset = int((datetime.now() - datetime.utcnow()).total_seconds())
;

and that was it.  While we are at it, drivers/rtc hit is a wrapper around
mktime64(), fs/nfs ones are obviously noise from quick and dirty search
pattern and so's scripts/analyze_suspend.py one.  fs/fat/misc.c and
fs/ncpfs/dir.c ones, though, are really asking for being converted to
mktime64().

While we are grepping, git grep -n '\<31\>.*\<28\>.*\<31\>' also finds
something interesting -
arch/m68k/bvme6000/rtc.c:34:{0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
arch/m68k/mvme16x/rtc.c:33:{0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
drivers/char/ds1302.c:153:    {0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
drivers/char/genrtc.c:83:{31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
drivers/char/rtc.c:212:{0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
are all about the same thing - open-coded
rtc_month_days(), if not open-coded rtc_valid_tm().  Might be worth looking
into...  And another hit (arch/powerpc/kernel/time.c:to_tm()) is downright
obscene:
        /* Number of months in days left */
        if (leapyear(tm->tm_year))
                days_in_month(FEBRUARY) = 29;
        for (i = 1; day >= days_in_month(i); i++)
                day -= days_in_month(i);
        days_in_month(FEBRUARY) = 28;
(whadday mean, "locking"?)  Almost certainly wants to switch to time_to_tm()...
