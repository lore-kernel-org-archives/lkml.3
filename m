Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298Ab3DCTri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 15:47:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33449 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932193Ab3DCTrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 15:47:36 -0400
Date: Wed, 3 Apr 2013 21:47:33 +0200
From: Jan Kara <jack@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, akpm@linux-foundation.org, jack@suse.cz,
        david@fromorbit.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET v2] workqueue, writeback: better worker information
 in task dumps
Message-ID: <20130403194733.GA21037@quack.suse.cz>
References: <1365017072-32213-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365017072-32213-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 03-04-13 12:24:29, Tejun Heo wrote:
> Hello,
> 
> Andrew, this one depends on the debug info unification patch and
> should be routed through -mm too.  The writeback folks seem to be okay
> with the proposed changes although nobody explicitly acked it yet
> (please do so).  Please route these together with the previous set
> through -mm.  Thanks.
  Ah, I didn't really feel confident enough about the kthread magic to give
my Reviewed-by but feel free to add

  Acked-by: Jan Kara <jack@suse.cz>

to these patches.

								Honza
> 
> This is v2.  Changes from v1 are,
> 
> * Rebased on top of the v2 of "arch: unify task dump debug info"
>   patchset.
> 
> One of the problems that arise when converting dedicated custom
> threadpool to workqueue is that the shared worker pool used by
> workqueue anonimizes each worker making it more difficult to identify
> what the worker was doing on which target from the output of sysrq-t
> or debug dump from oops, BUG() and friends.
> 
> For example, after writeback is converted to use workqueue instead of
> priviate thread pool, there's no easy to tell which backing device a
> writeback work item was working on at the time of task dump, which,
> according to our writeback brethren, is important in tracking down
> issues with a lot of mounted file systems on a lot of different
> devices.
> 
> This patchset implements a way for a work function to mark its
> execution instance so that task dump of the worker task includes
> information to indicate what the work item was doing.
> 
> An example WARN dump would look like the following.
> 
>  WARNING: at /work/os/work/fs/fs-writeback.c:1015 bdi_writeback_workfn+0x2b4/0x3c0()
>  Modules linked in:
>  CPU: 0 Pid: 28 Comm: kworker/u18:0 Not tainted 3.9.0-rc1-work+ #24
>  Hardware name: empty empty/S3992, BIOS 080011  10/26/2007
>  Workqueue: writeback bdi_writeback_workfn (flush-8:16)
>   ffffffff820a3a98 ffff88015b927cb8 ffffffff81c61855 ffff88015b927cf8
>   ffffffff8108f500 0000000000000000 ffff88007a171948 ffff88007a1716b0
>   ffff88015b49df00 ffff88015b8d3940 0000000000000000 ffff88015b927d08
>  Call Trace:
>   [<ffffffff81c61855>] dump_stack+0x19/0x1b
>   [<ffffffff8108f500>] warn_slowpath_common+0x70/0xa0
>   ...
> 
> This patchset contains the following three patches.
> 
>  0001-kthread-implement-probe_kthread_data.patch
>  0002-workqueue-include-workqueue-info-when-printing-debug.patch
>  0003-writeback-set-worker-desc-to-identify-writeback-work.patch
> 
> 0001 adds a speculative accessor for kthread_data.
> 
> 0002 implements worker description.
> 
> 0003 updates writeback to set its flusher name as worker description.
> 
> This patchset is on top of
> 
>   akpm as of 2013/04/03
> + [PATCHSET v2] arch: unify task dump debug info
> 
> and available in the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-wb-better-dbg
> 
> diffstat follows.  Thanks.
> 
>  fs/fs-writeback.c           |    1 
>  include/linux/kthread.h     |    1 
>  include/linux/workqueue.h   |    5 ++
>  kernel/kthread.c            |   19 ++++++++++
>  kernel/printk.c             |    2 +
>  kernel/sched/core.c         |    1 
>  kernel/workqueue.c          |   79 ++++++++++++++++++++++++++++++++++++++++++++
>  kernel/workqueue_internal.h |   12 ++++++
>  8 files changed, 119 insertions(+), 1 deletion(-)
> 
> --
> tejun
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
