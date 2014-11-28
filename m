Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbaK1JkH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 04:40:07 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:39998 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751463AbaK1JkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 04:40:01 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="44143281"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH 0/2] tiny_rcu: simplify tiny_rcu
Date: Fri, 28 Nov 2014 17:43:31 +0800
Message-ID: <1417167813-11963-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Paul

These two patches use the special feture of the UP system:
	In UP, quiescent state == grace period.

For rcu_bh, rcu_process_callbacks() == a bh == QS == GP
so we can pass rcu_bh-QS and advance GP(and callbacks) in
rcu_process_callbacks(). After doing so, rcu_bh_qs() is useless
since its work is handled by rcu_process_callbacks().

For rcu_sched, context-switch = QS = GP, thus we can force a
context-switch when call_rcu_sched() is happened on idle_task.
After doing so, rcu_idle/irq_enter/exit() are useless.

These patches remove the useless code to simplify the tiny_rcu.

We can change rcu_bh_qs() rcu_idle/irq_enter/exit() to static-inline-functions
to reduce the binary size after these two patches accepted.

Thanks,
Lai

Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

Lai Jiangshan (2):
  record rcu_bh quiescent state in RCU_SOFTIRQ
  tiny_rcu: resched when call_rcu() on idle_task

 kernel/rcu/rcu.h         |    6 ++
 kernel/rcu/tiny.c        |  134 ++++++++--------------------------------------
 kernel/rcu/tiny_plugin.h |    2 +-
 kernel/rcu/tree.c        |    6 --
 4 files changed, 29 insertions(+), 119 deletions(-)

-- 
1.7.4.4

