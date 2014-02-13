Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbaBMTx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:53:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34708 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbaBMTx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:53:26 -0500
Date: Thu, 13 Feb 2014 11:53:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: <gregkh@linuxfoundation.org>, <cl@linux-foundation.org>,
        <penberg@kernel.org>, <linux-kernel@vger.kernel.org>,
        <devel@openvz.org>
Subject: Re: [PATCH 1/2] kobject: don't block for each kobject_uevent
Message-Id: <20140213115325.0afcef6b57b63a2ce407c76b@linux-foundation.org>
In-Reply-To: <ca22d856315916d3e8c74666da7079b9ae42e646.1391942582.git.vdavydov@parallels.com>
References: <ca22d856315916d3e8c74666da7079b9ae42e646.1391942582.git.vdavydov@parallels.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Feb 2014 14:56:15 +0400 Vladimir Davydov <vdavydov@parallels.com> wrote:

> Currently kobject_uevent has somewhat unpredictable semantics. The point
> is, since it may call a usermode helper and wait for it to execute
> (UMH_WAIT_EXEC), it is impossible to say for sure what lock dependencies
> it will introduce for the caller - strictly speaking it depends on what
> fs the binary is located on and the set of locks fork may take. There
> are quite a few kobject_uevent's users that do not take this into
> account and call it with various mutexes taken, e.g. rtnl_mutex,
> net_mutex, which might potentially lead to a deadlock.
> 
> Since there is actually no reason to wait for the usermode helper to
> execute there, let's make kobject_uevent start the helper asynchronously
> with the aid of the UMH_NO_WAIT flag.
> 
> Personally, I'm interested in this, because I really want kobject_uevent
> to be called under the slab_mutex in the slub implementation as it used
> to be some time ago, because it greatly simplifies synchronization and
> automatically fixes a kmemcg-related race. However, there was a deadlock
> detected on an attempt to call kobject_uevent under the slab_mutex (see
> https://lkml.org/lkml/2012/1/14/45), which was reported to be fixed by
> releasing the slab_mutex for kobject_uevent. Unfortunately, there was no
> information about who exactly blocked on the slab_mutex causing the
> usermode helper to stall, neither have I managed to find this out or
> reproduce the issue.
> 
> BTW, this is not the first attempt to make kobject_uevent use
> UMH_NO_WAIT. Previous one was made by commit f520360d93c, but it was
> wrong (it passed arguments allocated on stack to async thread) so it was
> reverted (commit 05f54c13cd0c). It targeted on speeding up the boot
> process though.

Am not a huge fan of this patch.  My test box gets an early oops in

initcalls
->...
  ->register_pernet_operations
    ->rtnetlink_net_init
      ->__netlink_kernel_create
        ->sock_create_lite
          ->sock_alloc
            ->new_inode_pseudo
              ->alloc_inode+0xe

I expect that sock_mnt->mnt_sb is null.  Or perhaps sb->s_op.  Perhaps
sockfs hasn't mounted yet.

The oops doesn't happen on mainline - it only happens on linux-next. 
So there may be some interaction there, but it may only be timing
related.

config: http://ozlabs.org/~akpm/stuff/config-akpm2
