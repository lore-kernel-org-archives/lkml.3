Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721AbaLSQ5s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 11:57:48 -0500
Received: from imap.thunk.org ([74.207.234.97]:36248 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbaLSQ5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 11:57:46 -0500
Date: Fri, 19 Dec 2014 11:57:39 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Michael Kerrisk <mtk.manpages@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] urandom: handle signals immediately
Message-ID: <20141219165739.GA11655@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Heinrich Schuchardt <xypron.glpk@gmx.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org
References: <54707352.8050208@gmx.de>
 <1417252349-808-1-git-send-email-xypron.glpk@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417252349-808-1-git-send-email-xypron.glpk@gmx.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 29, 2014 at 10:12:29AM +0100, Heinrich Schuchardt wrote:
> Without the patch device /dev/urandom only considers signals when a
> rescheduling of the thread is requested. This may imply that
> signals will not be handled for time intervals in excess of 30s.

Sorry, I didn't see your e-mail for a while; it got lost in my inbox
due to my being travelling for Thanksgiving weeksend.

I'm not sure where you are getting 30 seconds from, but you're right
that it would be better to check signal_pending() on each loop.  That
being said, your patch isn't right.

> +		/*
> +		 * getrandom must not be interrupted by a signal while
> +		 * reading up to 256 bytes.
> +		 */
> +		if (signal_pending(current) && ret > 256)
> +			break;
> +		if (need_resched())
>  			schedule();
> -		}

This means that we can reschedule even for small requests, and that's
no good; getrandom *must* be atomic.  You also need to return
-ERESTARTSYS if we get interrupted with no bytes.  So this needs to be
something like this:

		if (ret > 256) {
			if (signal_pending(current)) {
				if (ret == 0)
					ret = -ERESTARTSYS;
				break;
			}
			if (need_resched())
				schedule();
		}

Cheers,

					- Ted
