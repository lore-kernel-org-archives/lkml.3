Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450Ab3HGKVB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:21:01 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:2456 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932129Ab3HGKVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:21:00 -0400
X-IronPort-AV: E=Sophos;i="4.89,832,1367942400"; 
   d="scan'208";a="8143903"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 0/8] rcu: Ensure rcu read site is deadlock-immunity
Date: Wed, 7 Aug 2013 18:24:56 +0800
Message-Id: <1375871104-10688-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/07 18:19:35,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/07 18:19:35,
	Serialize complete at 2013/08/07 18:19:35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although all articles declare that rcu read site is deadlock-immunity.
It is not true for rcu-preempt, it will be deadlock if rcu read site
overlaps with scheduler lock.

ec433f0c, 10f39bb1 and 016a8d5b just partially solve it. But rcu read site
is still not deadlock-immunity. And the problem described in 016a8d5b
is still existed(rcu_read_unlock_special() calls wake_up).

The problem is fixed in patch5.

Lai Jiangshan (8):
  rcu: add a warn to rcu_preempt_note_context_switch()
  rcu: rcu_read_unlock_special() can be nested in irq/softirq 10f39bb1
  rcu: keep irqs disabled in rcu_read_unlock_special()
  rcu: delay task rcu state cleanup in exit_rcu()
  rcu: eliminate rcu read site deadlock
  rcu: call rcu_read_unlock_special() in rcu_preempt_check_callbacks()
  rcu: add # of deferred _special() statistics
  rcu: remove irq work for rsp_wakeup()

 include/linux/rcupdate.h |    2 +-
 kernel/rcupdate.c        |    2 +-
 kernel/rcutree.c         |   17 +--------
 kernel/rcutree.h         |    2 +-
 kernel/rcutree_plugin.h  |   82 ++++++++++++++++++++++++++++++++++-----------
 kernel/rcutree_trace.c   |    1 +
 6 files changed, 68 insertions(+), 38 deletions(-)

-- 
1.7.4.4

