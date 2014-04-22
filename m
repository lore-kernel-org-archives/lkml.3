Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbaDVHVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 03:21:17 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52432 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaDVHVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 03:21:15 -0400
Date: Tue, 22 Apr 2014 09:21:12 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        len.brown@intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v2] kernel/power/hibernate.c: use 'u64' instead of
 's64' to avoid warning
Message-ID: <20140422072112.GB14108@amd.pavel.ucw.cz>
References: <5355C5F0.6020606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5355C5F0.6020606@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-04-22 09:29:20, Chen Gang wrote:
> For do_div(), it need 'u64' type, which means the outside must be sure
> of 'start' is not bigger than 'stop', or it will report warning.
> 
> Even if 'start' was really bigger than 'stop', it would print incorrect
> information, but for kernel, it still can continue, so use WARN_ON() is
> enough.
> 
> The related warning (with allmodconfig for unicore32):
> 
>     CC      kernel/power/hibernate.o
>   kernel/power/hibernate.c: In function ‘swsusp_show_speed’:
>   kernel/power/hibernate.c:237: warning: comparison of distinct pointer types lacks a cast
> 
> 

Certainly better, but

> -	s64 elapsed_centisecs64;
> +	u64 elapsed_centisecs64;
>  	int centisecs;
>  	int k;
>  	int kps;
>  
>  	elapsed_centisecs64 = timeval_to_ns(stop) - timeval_to_ns(start);
> +	WARN_ON((s64)elapsed_centisecs64 < 0);
>  	do_div(elapsed_centisecs64, NSEC_PER_SEC / 100);
>  	centisecs = elapsed_centisecs64;

...do we need to do the WARN_ON()? Only result of underflow will be
very long elapsed time reported... that does not sound too
bad. ... and it will be quite obvious what went wrong.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
