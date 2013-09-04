Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760311Ab3IDTLK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 15:11:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56935 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756594Ab3IDTLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 15:11:08 -0400
Date: Wed, 4 Sep 2013 20:11:04 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH] dcache: Translating dentry into pathname without taking
 rename_lock
Message-ID: <20130904191104.GK13318@ZenIV.linux.org.uk>
References: <1378321523-40893-1-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378321523-40893-1-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 03:05:23PM -0400, Waiman Long wrote:
>  
>  static int prepend_name(char **buffer, int *buflen, struct qstr *name)
>  {
> -	return prepend(buffer, buflen, name->name, name->len);
> +	/*
> +	 * With RCU path tracing, it may race with rename. Use
> +	 * ACCESS_ONCE() to make sure that it is either the old or
> +	 * the new name pointer. The length does not really matter as
> +	 * the sequence number check will eventually catch any ongoing
> +	 * rename operation.
> +	 */
> +	const char *dname = ACCESS_ONCE(name->name);
> +	int   dlen = name->len;
> +
> +	if (unlikely(!dname || !dlen))
> +		return -EINVAL;
> +	return prepend(buffer, buflen, dname, dlen);

NAK.  A race with d_move() can very well leave you with dname pointing into
an object of length smaller than dlen.  You *can* copy it byte-by-byte
and rely on NUL-termination, but you can't rely on length being accurate -
not without having excluded d_move().
