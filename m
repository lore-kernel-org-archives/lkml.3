Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079AbaFTTf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 15:35:29 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:55944 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756919AbaFTTfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 15:35:25 -0400
Date: Fri, 20 Jun 2014 15:35:21 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 5/5] cgroup: fix a race between cgroup_mount() and
 cgroup_kill_sb()
Message-ID: <20140620193521.GB28324@mtj.dyndns.org>
References: <53994943.60703@huawei.com>
 <539949A1.90301@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <539949A1.90301@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

Sorry about the long delay.

On Thu, Jun 12, 2014 at 02:33:05PM +0800, Li Zefan wrote:
> We've converted cgroup to kernfs so cgroup won't be intertwined with
> vfs objects and locking, but there are dark areas.
> 
> Run two instances of this script concurrently:
> 
>     for ((; ;))
>     {
>     	mount -t cgroup -o cpuacct xxx /cgroup
>     	umount /cgroup
>     }
> 
> After a while, I saw two mount processes were stuck at retrying, because
> they were waiting for a subsystem to become free, but the root associated
> with this subsystem never got freed.
> 
> This can happen, if thread A is in the process of killing superblock but
> hasn't called percpu_ref_kill(), and at this time thread B is mounting
> the same cgroup root and finds the root in the root list and performs
> percpu_ref_try_get().
> 
> To fix this, we increase the refcnt of the superblock instead of increasing
> the percpu refcnt of cgroup root.

Ah, right.  Gees, I'm really hating the fact that we have ->mount but
not ->umount.  However, can't we make it a bit simpler by just
introducing a mutex protecting looking up and refing up an existing
root and a sb going away?  The only problem is that the refcnt being
killed isn't atomic w.r.t. new live ref coming up, right?  Why not
just add a mutex around them so that they can't race?

Thanks.

-- 
tejun
