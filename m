Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700AbaGQTdi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 15:33:38 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:59240 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753017AbaGQTdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 15:33:36 -0400
X-Sasl-enc: XSaFltjJDPj6PhRtFBgeKy7QHWc0Hl0zECbK++YFenAc 1405625611
Date: Thu, 17 Jul 2014 12:33:30 -0700
From: Greg KH <greg@kroah.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, linux-abi@vger.kernel.org,
        linux-crypto@vger.kernel.org, beck@openbsd.org
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Message-ID: <20140717193330.GB4703@kroah.com>
References: <1405588695-12014-1-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405588695-12014-1-git-send-email-tytso@mit.edu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 05:18:15AM -0400, Theodore Ts'o wrote:
> +SYSCALL_DEFINE3(getrandom, char __user *, buf, size_t, count,
> +		unsigned int, flags)
> +{
> +	int r;
> +
> +	if (count > 256)
> +		return -EINVAL;
> +
> +	if (flags & GRND_RANDOM) {
> +		return _random_read(!(flags & GRND_BLOCK), buf, count);
> +	}
> +	if (flags & GRND_BLOCK) {
> +		r = wait_for_completion_interruptible(&urandom_initialized);
> +		if (r)
> +			return r;
> +	} else if (!completion_done(&urandom_initialized))
> +		return -EAGAIN;
> +	return urandom_read(NULL, buf, count, NULL);
> +}

You should fail if any other bits are set that you don't understand in
the flags value, to make it easier for newer kernels with more flags to
fail properly on old kernel releases.

thanks,

greg k-h
