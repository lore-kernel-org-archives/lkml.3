Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbaIOQmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 12:42:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753889AbaIOQmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 12:42:21 -0400
Date: Mon, 15 Sep 2014 18:39:35 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roman Pen <r.peniaev@gmail.com>
Cc: Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] init: fix race between rootfs mount and firmware
	loading
Message-ID: <20140915163935.GB22768@redhat.com>
References: <1410792308-21577-1-git-send-email-r.peniaev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410792308-21577-1-git-send-email-r.peniaev@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15, Roman Pen wrote:
>
> +static DECLARE_COMPLETION(rootfs_mounted);
> +
> +void wait_for_rootfs(void)
> +{
> +	/* Avoid waiting for ourselves */
> +	if (is_global_init(current))
> +		pr_warn("it is not a good idea to wait for rootfs mount from init task\n");
> +	else
> +		wait_for_completion(&rootfs_mounted);
> +}
> +
> +static inline void wake_up_rootfs_waiters(void)
> +{
> +	complete(&rootfs_mounted);
> +}

Probably you need complete_all() ?

Otherwise wait_for_rootfs() can return only once, the next call will block
forever. And perhaps it would be better to use another primitive, even if
UINT_MAX/2 should be enough.

Oleg.

