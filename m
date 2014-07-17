Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbaGQTsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 15:48:14 -0400
Received: from tetsuo.zabbo.net ([50.193.208.193]:39723 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752510AbaGQTsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 15:48:13 -0400
Date: Thu, 17 Jul 2014 12:48:12 -0700
From: Zach Brown <zab@zabbo.net>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, linux-abi@vger.kernel.org,
        linux-crypto@vger.kernel.org, beck@openbsd.org
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Message-ID: <20140717194812.GC24196@lenny.home.zabbo.net>
References: <1405588695-12014-1-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405588695-12014-1-git-send-email-tytso@mit.edu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> SYNOPSIS
> 	#include <linux/random.h>
> 
> 	int getrandom(void *buf, size_t buflen, unsigned int flags);

I certainly like the idea of getting entropy without having to worry
about fds.

> 	If the GRND_RANDOM flags bit is not set, then the /dev/raundom

(raundom typo)

> RETURN VALUE
>        On success, the number of bytes that was returned is returned.

The description talks about filling the buffer, maybe say 'the number of
bytes filled is returned'?  

> +DECLARE_COMPLETION(urandom_initialized);

static?

> +SYSCALL_DEFINE3(getrandom, char __user *, buf, size_t, count,
> +		unsigned int, flags)
> +{
> +	int r;
> +

Michael Kerrisk wants you to return -EINVAL on unknown flags :)

http://lwn.net/Articles/588444/

> +	if (count > 256)
> +		return -EINVAL;

I'd vote for not having the limit.  It seems easy enough to iterate over
the buffer.  We'd need to clamp the count to ssize_t, though.

> +	if (flags & GRND_RANDOM) {
> +		return _random_read(!(flags & GRND_BLOCK), buf, count);
> +	}

Do we want it to block by default and have the flag be _NONBLOCK?  Feels
more.. familiar.

> +	if (flags & GRND_BLOCK) {
> +		r = wait_for_completion_interruptible(&urandom_initialized);
> +		if (r)
> +			return r;

I can *never* remember the rules for -ERESTARTSYS.  The syscall callers
take care of this?

> +	return urandom_read(NULL, buf, count, NULL);

I wonder if we want to refactor the entry points a bit more instead of
directly calling the device read functions.  get_random_bytes() and
urandom_read() both have their own uninitialied use warning message and
tracing.  Does the syscall want its own little extraction function as
well?

- z
