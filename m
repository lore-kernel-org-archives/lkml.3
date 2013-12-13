Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab3LMRth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 12:49:37 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:40737 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab3LMRtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 12:49:36 -0500
Date: Fri, 13 Dec 2013 12:49:32 -0500
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <axboe@kernel.dk>
Cc: tomaz.solc@tablix.org, aaron.lu@intel.com, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Writeback threads and freezable
Message-ID: <20131213174932.GA27070@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.

This is discovered while investigating bug 62801 - "EliteBoot hangs at
dock, suspend, undock, resume".

 https://bugzilla.kernel.org/show_bug.cgi?id=62801

The laptop locks up during resume if undocked while suspended.  The
dock contains a hard drive and the drive removal path and resume path
get stuck.  This got bisected to 839a8e8660b6 ("writeback: replace
custom worker pool implementation with unbound workqueue") by the
reporter.  The problem can be reproduced by just removing mounted
harddrive while a machine is suspended.  I first thought it was some
dumb mistake but it turns out to be something fundamental.

So, here's the lock up.

* Resume starts and libata resume is kicked off.

* libata EH determines that the device is gone.  Eventually it invokes
  device_del() through a work item.

* device_del() tries to delete the block device which invokes
  writeback_inodes_sb() on the mounted filesystem which in turn
  schedules and flushes bdi work item.  Note that at this point, the
  kworker is holding multiple driver layer locks.

Now, if the rest of dpm resume races with the above and gets stuck
behind one of the locks libata device removal path is holding, it
deadlocks because thaw_workqueues() is called only after dpm resume is
complete.  libata device removal waits for the scheduled writeback
work item to finish which in turn is waiting for the workqueue to be
thawed, and dpm resume can't make it to thaw_workqueues() because it's
stuck behind one of the mutexes held by the libata device removal
path.

I think the issues already existed before 839a8e8660b6 ("writeback:
replace custom worker pool implementation with unbound workqueue")
although the patch seems to have exposed it a lot more.  The issue
probably was a lot less visible because, if the bdi had a flusher
spawned, kthread_stop() overrides freezer and if not the device has
been idle & clean for some time and unlikely to require any action on
shutdown, but the forker thread was still freezable and I think it
should be possible to trigger some condition where forker action is
waited upon during shutdown sequence.

The fundamental problem, really, is that device drivers make use of
kthreads and/or workqueues in their operation and freezable kthreads
and workqueues essentially behave as a giant lock.  If any
suspend/resume operation somehow ends up depending on a freezable
kthread or workqueue, which can happen through quite convoluted and
long dependency chain, there are possibilities for deadlock even if
those operations themselves aren't interlocked.  In this case, libata
resume finishes fine and device removal is run completely
asynchronously but the dependency chain is still completed through
driver layer locks.

I've always thought that using freezer for kernel threads / workqueues
is something fundamentally undesirable, exactly because freezer acts
as a giant lock and we don't have any meangingful debug support around
it.  Even in leaf drivers proper where the dependency isn't
complicated, this has ample possibility to lead to surprise lockups.

I'm unsure why bdi should be freezable.  It's not like corking things
at bdi can reliably prevent block layer from issuing further commands
down to drivers.  Maybe there are things which directly hook into bdi
and depend on it being frozen, I don't know, but it just seems
dangerous to inject a large locking dependency into the chain from
such high level construct.

I'm not completely sure what to do.  We can make an exception for
bdi_wq and thaw it early but that breaks the guarantee that bdi is
frozen between device suspend and resume invocations and we might as
well just remove WQ_FREEZABLE from it.  I don't know.

Ideas?

Thanks.

-- 
tejun
