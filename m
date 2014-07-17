Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563AbaGQV5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 17:57:17 -0400
Received: from tetsuo.zabbo.net ([50.193.208.193]:39746 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856AbaGQV5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 17:57:15 -0400
Date: Thu, 17 Jul 2014 14:57:14 -0700
From: Zach Brown <zab@zabbo.net>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, linux-api@vger.kernel.org,
        beck@openbsd.org
Subject: Re: [PATCH, RFC -v2] random: introduce getrandom(2) system call
Message-ID: <20140717215714.GF24196@lenny.home.zabbo.net>
References: <1405633100-4889-1-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405633100-4889-1-git-send-email-tytso@mit.edu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 05:38:20PM -0400, Theodore Ts'o wrote:
> The getrandom(2) system call was requested by the LibreSSL Portable
> developers.  It is analoguous to the getentropy(2) system call in
> OpenBSD.

> +SYSCALL_DEFINE3(getrandom, char __user *, buf, size_t, count,
> +		unsigned int, flags)
> +{
> +	int r;
> +
> +	if (flags & ~(GRND_NONBLOCK|GRND_RANDOM))
> +		return -EINVAL;
> +
> +	if (count > INT_MAX)
> +		count = INT_MAX;
> +
> +	if (flags & GRND_RANDOM)
> +		return _random_read(flags & GRND_NONBLOCK, buf, count);
> +	if (flags & GRND_NONBLOCK) {
> +		if (!completion_done(&urandom_initialized))
> +			return -EAGAIN;
> +	} else {
> +		r = wait_for_completion_interruptible(&urandom_initialized);
> +		if (r)
> +			return r;
> +	}
> +	return urandom_read(NULL, buf, count, NULL);
> +}

I like how tiny this ends up being.  Feel free to add my rb:.

Reviewed-by: Zach Brown <zab@zabbo.net>

- z
