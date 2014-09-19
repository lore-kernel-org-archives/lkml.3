Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399AbaISTsc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 15:48:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932080AbaISTsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 15:48:31 -0400
Date: Fri, 19 Sep 2014 21:45:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roman Pen <r.peniaev@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ming Lei <ming.lei@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [v4 PATCH 1/1] init: fix race between rootfs mount and
	firmware loading
Message-ID: <20140919194547.GB4402@redhat.com>
References: <20140918174127.GB340@redhat.com> <1411130664-10195-1-git-send-email-r.peniaev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411130664-10195-1-git-send-email-r.peniaev@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19, Roman Pen wrote:
>
> +void wait_for_rootfs(void)
> +{
> +	/* Here we try to protect from a few things:
> +	 * 1. Avoid waiting for ourselves, when init thread has not
> +	 *    mounted rootfs yet.
> +	 * 2. Avoid warning if call chain was initiated from userspace
> +	 *    /sbin/init. For example when /sbin/init loads the driver,
> +	 *    which, in turn, wants to access rootfs (e.g. firmware loading),
> +	 *    thus it has to be sure, that rootfs has been successfully
> +	 *    mounted.
> +	 */
> +	if (rootfs_mounted || WARN_ON(is_global_init(current)))
> +		return;
> +	else
> +		wait_event(rootfs_waitq, rootfs_mounted);
> +}

Well, in this case __wait_event() makes more sense, we already checked
rootfs_mounted, but this is minor.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>


But I hope that Greg can take a look too. I do not understand the problem
space enough, so I am not sure this is the "right" fix. Say, perhaps we
should change the drivers which abuse request_firmware(), or do something
else.

Oleg.

