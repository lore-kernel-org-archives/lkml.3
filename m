Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbbABRKc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 12:10:32 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:33056 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbbABRKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 12:10:31 -0500
Date: Fri, 2 Jan 2015 17:10:30 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: isofs: Fix bug in the way to check if the year is a
 leap year
Message-ID: <20150102171030.GR22149@ZenIV.linux.org.uk>
References: <1420214928-7104-1-git-send-email-oscar.forner.martinez@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420214928-7104-1-git-send-email-oscar.forner.martinez@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2015 at 04:08:48PM +0000, Oscar Forner Martinez wrote:
> The way to check if the year is a leap year was incomplete.
> It was checking only if the year can be divided by 4, that is
> necessary but not a sufficient condition. It has to check as well
> if the year can not be divided by 100 or if the year can be
> divided by 400.

... which is utterly pointless since the possible values of 'year' are
quite limited here.

> Signed-off-by: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>
> ---
>  fs/isofs/util.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/isofs/util.c b/fs/isofs/util.c
> index 01e1ee7..d2dd602 100644
> --- a/fs/isofs/util.c
> +++ b/fs/isofs/util.c
> @@ -38,7 +38,7 @@ int iso_date(char * p, int flag)
>  			days += (year+1) / 4;
>  		for (i = 1; i < month; i++)
>  			days += monlen[i-1];
> -		if (((year+2) % 4) == 0 && month > 2)
> +		if (((year+2) % 4) == 0 && month > 2 && ((((year+2) % 100) != 0) || (((year+2) % 400) == 0)))

... *and* completely wrong, since 'year' at that point is "years since
the epoch (1970)".  So your extra condition would first trigger in 2068.
What do you think that "+ 2" was about?  Black magic?

FWIW, ISO9660 (9.1.5) says that the date is stored as series of 8bit values,
interpreted as
	* year - 1900
	* month (1 to 12)
	* day of month (1 to 31)
	* hour (0 to 23)
	* minute (0 to 59)
	* second (0 to 59)
	* offset from GMT in quarters of hour (-48 to 52)

So the only relevant years are 1900 and 2100.  It refuses to accept anything
prior to 1970 anyway and the damn thing returns signed 32bit (seconds since
Jan 1, 1970).  Remember what's the maximal date that can be represented by
that?  Right, it's in 2038...

Incidentally, iso_date() is broken - it trusts the month to be within 1..12,
which might not be true for a corrupted image.  And while we are at it,
having that monlen[12] array on stack means initializing it every sodding
time.  And I really, really doubt that we don't have that sucker already
done better... <greps>

Aha:
/*
 * mktime64 - Converts date to seconds.
 * Converts Gregorian date to seconds since 1970-01-01 00:00:00.
 * Assumes input in normal date format, i.e. 1980-12-31 23:59:59
 * => year=1980, mon=12, day=31, hour=23, min=59, sec=59.
 *
 * [For the Julian calendar (which was used in Russia before 1917,
 * Britain & colonies before 1752, anywhere else before 1582,
 * and is still in use by some communities) leave out the
 * -year/100+year/400 terms, and add 10.]
 *
 * This algorithm was first published by Gauss (I think).
 */

So this
                int monlen[12] = {31,28,31,30,31,30,31,31,30,31,30,31};

                days = year * 365;
                if (year > 2)
                        days += (year+1) / 4;
                for (i = 1; i < month; i++)
                        days += monlen[i-1];
                if (((year+2) % 4) == 0 && month > 2)
                        days++;
                days += day - 1;
                crtime = ((((days * 24) + hour) * 60 + minute) * 60)
                        + second;
should become simply
		crtime = mktime64(year+1970, month, day, hour, minute, second);

