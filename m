Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457AbaIRRoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 13:44:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117AbaIRRoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 13:44:11 -0400
Date: Thu, 18 Sep 2014 19:41:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roman Pen <r.peniaev@gmail.com>
Cc: Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [v3 PATCH 1/1] init: fix race between rootfs mount and
	firmware loading
Message-ID: <20140918174127.GB340@redhat.com>
References: <20140917174647.GC19308@redhat.com> <1411047228-2576-1-git-send-email-r.peniaev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411047228-2576-1-git-send-email-r.peniaev@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18, Roman Pen wrote:
>
> +void wait_for_rootfs(void)
> +{
> +	/* Avoid waiting for ourselves */
> +	if (WARN_ON(is_global_init(current)))
> +		return;
> +	else
> +		wait_event(rootfs_waitq, rootfs_mounted);
> +}

Ah, wait, the is_global_init() check doesn't look right in any case.

What if /sbin/init does sys_init_module() and this module does
request_firmware() ?

I think we should only warn if init is going to wait,

	/* Avoid waiting for ourselves */
	if (rootfs_mounted || WARN_ON(is_global_init(current)))
		return;

	__wait_event(rootfs_waitq, rootfs_mounted);


> +EXPORT_SYMBOL(wait_for_rootfs);

Why?

Oleg.

