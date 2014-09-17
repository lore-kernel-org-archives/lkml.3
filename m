Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558AbaIQRta (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 13:49:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756231AbaIQRt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 13:49:29 -0400
Date: Wed, 17 Sep 2014 19:46:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roman Pen <r.peniaev@gmail.com>
Cc: Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [v2 PATCH 1/1] init: fix race between rootfs mount and
	firmware loading
Message-ID: <20140917174647.GC19308@redhat.com>
References: <CACZ9PQXJzoczS7gN5UCFygTHrLW5Rtjew5BF-txfL=cryE331w@mail.gmail.com> <1410960495-9198-1-git-send-email-r.peniaev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410960495-9198-1-git-send-email-r.peniaev@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17, Roman Pen wrote:
>
> +void wait_for_rootfs(void)
> +{
> +	/* Avoid waiting for ourselves */
> +	if (is_global_init(current))
> +		pr_warn("init: it is not a good idea to wait for the rootfs mount from the init task\n");
> +	else
> +		wait_event(rootfs_waitq, rootfs_mounted);
> +}

Well, this pr_warn() doesn't look very useful, how about

	if (WARN_ON((is_global_init(current))))
		return;

? this will show the caller.

> +static inline void wake_up_rootfs_waiters(void)
> +{
> +	rootfs_mounted = true;
> +	/* wake_up guarantees write memory barrier if and only if
> +	   there is a task to be woken up, it is not always true
> +	   for our case. */

Yes, but this doesn't matter. wait_event() takes care,

> +	smp_wmb();

so please remove this wmb() and the comment.

Oleg.

