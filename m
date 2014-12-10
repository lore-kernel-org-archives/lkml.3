Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035AbaLJQlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 11:41:24 -0500
Received: from mail-qg0-f42.google.com ([209.85.192.42]:39968 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbaLJQlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 11:41:23 -0500
Date: Wed, 10 Dec 2014 11:41:19 -0500
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>,
        NeilBrown <neilb@suse.de>
Subject: [GIT PULL] workqueue changes for v3.19-rc1
Message-ID: <20141210164119.GC6294@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Work items which may be involved in memory reclaim path may be
executed by the rescuer under memory pressure.  When a rescuer gets
activated, it processes whatever are on the pending list and then goes
back to sleep until the manager kicks it again which involves 100ms
delay.  This is problematic for self-requeueing work items or the ones
running on ordered workqueues as there always is only one work item on
the pending list when the rescuer kicks in.  The execution of that
work item produces more to execute but the rescuer won't see them
until after the said 100ms has passed, so such workqueues would only
execute one work item every 100ms under prolonged memory pressure,
which BTW may be being prolonged due to the slow execution.

Neil wrote up a patch which fixes this issue by keeping the rescuer
working as long as the target workqueue is busy but doesn't have
enough workers.

Thanks.

The following changes since commit cac7f2429872d3733dc3f9915857b1691da2eb2f:

  Linux 3.18-rc2 (2014-10-26 16:48:41 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.19

for you to fetch changes up to 008847f66c38712f2819cd956969519006ebc11d:

  workqueue: allow rescuer thread to do more work. (2014-12-08 12:39:16 -0500)

----------------------------------------------------------------
NeilBrown (1):
      workqueue: allow rescuer thread to do more work.

Tejun Heo (2):
      workqueue: cosmetic update in rescuer_thread()
      workqueue: invert the order between pool->lock and wq_mayday_lock

 kernel/workqueue.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

-- 
tejun
