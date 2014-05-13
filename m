Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297AbaEMT21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 15:28:27 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:56727 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbaEMT2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 15:28:19 -0400
Date: Tue, 13 May 2014 15:28:14 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        cgroups@vger.kernel.org
Subject: [GIT PULL] more cgroup fixes for v3.15-rc5
Message-ID: <20140513192814.GC28815@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Three more patches to fix cgroup_freezer breakage due to the recent
cgroup internal locking changes - an operation cgroup_freezer was
using now requires sleepable context and cgroup_freezer was invoking
that while holding a spin lock.  cgroup_freezer was using an overly
elaborate hierarchical locking scheme.

While it's possible to convert the hierarchical spinlocks directly to
mutexes, this patch simplifies the overall locking so that it uses a
global mutex.  This has the added benefit of avoiding iterating
potentially huge number of tasks under a spinlock.  While the patch is
on the larger side in the devel cycle, the changes made are mostly
straight-forward and the locking logic is a lot simpler afterwards.

The following changes since commit 36c38fb7144aa941dc072ba8f58b2dbe509c0345:

  blkcg: use trylock on blkcg_pol_mutex in blkcg_reset_stats() (2014-05-05 13:48:18 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.15-fixes

for you to fetch changes up to 36e9d2ebcc15d029b33f42a36146ab5a5bcfcfe7:

  cgroup: fix rcu_read_lock() leak in update_if_frozen() (2014-05-13 11:28:30 -0400)

Thanks.

----------------------------------------------------------------
Tejun Heo (3):
      cgroup: introduce task_css_is_root()
      cgroup_freezer: replace freezer->lock with freezer_mutex
      cgroup: fix rcu_read_lock() leak in update_if_frozen()

 include/linux/cgroup.h  |  15 +++++++
 kernel/cgroup.c         |   2 +-
 kernel/cgroup_freezer.c | 116 ++++++++++++++++++++----------------------------
 3 files changed, 65 insertions(+), 68 deletions(-)

-- 
tejun
