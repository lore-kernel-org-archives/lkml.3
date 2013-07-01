Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab3GAOSA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 10:18:00 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:43562 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab3GAOR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 10:17:58 -0400
Date: Mon, 1 Jul 2013 07:17:54 -0700
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [GIT PULL] workqueue changes for v3.11-rc1
Message-ID: <20130701141754.GD11408@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Surprisingly, Lai and I didn't break too many things implementing
custom pools and stuff last time around and there aren't any follow-up
changes necessary at this point.

The only change in this pull request is Viresh's patches to make some
per-cpu workqueues to behave as unbound workqueues dependent on a boot
param whose default can be configured via a config option.  This leads
to higher processing overhead / lower bandwidth as more work items are
bounced across CPUs; however, it can lead to noticeable powersave in
certain configurations - ~10% w/ idlish constant workload on a
big.LITTLE configuration according to Viresh.

This is because per-cpu workqueues interfere with how the scheduler
perceives whether or not each CPU is idle by forcing pinned tasks on
them, which makes the scheduler's power-aware scheduling decisions
less effective.

Its effectiveness is likely less pronounced on homogenous
configurations and this type of optimization can probably be made
automatic; however, the changes are pretty minimal and the affected
workqueues are clearly marked, so it's an easy gain for some
configurations for the time being with pretty unintrusive changes.

The above changes are available in the following branch

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.11

for you to fetch changes up to a85f1a41f020bc2c97611060bcfae6f48a1db28d:

  fbcon: queue work on power efficient wq (2013-05-14 10:50:07 -0700)

----------------------------------------------------------------
Viresh Kumar (5):
      workqueues: Introduce new flag WQ_POWER_EFFICIENT for power oriented workqueues
      workqueue: Add system wide power_efficient workqueues
      PHYLIB: queue work on system_power_efficient_wq
      block: queue work on power efficient wq
      fbcon: queue work on power efficient wq

 Documentation/kernel-parameters.txt | 15 +++++++++++++++
 block/blk-core.c                    |  3 ++-
 block/blk-ioc.c                     |  3 ++-
 block/genhd.c                       | 12 ++++++++----
 drivers/net/phy/phy.c               |  9 +++++----
 drivers/video/console/fbcon.c       |  2 +-
 include/linux/workqueue.h           | 35 +++++++++++++++++++++++++++++++++++
 kernel/power/Kconfig                | 20 ++++++++++++++++++++
 kernel/workqueue.c                  | 26 +++++++++++++++++++++++++-
 9 files changed, 113 insertions(+), 12 deletions(-)

Thanks.

-- 
tejun
