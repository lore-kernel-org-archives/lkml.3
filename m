Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbaCLMQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 08:16:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50333 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbaCLMQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 08:16:33 -0400
Date: Wed, 12 Mar 2014 05:15:48 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-753fbd23f5e59ea9dc0cabe0a684d32100a4af02@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, peterz@infradead.org,
        xen-devel@lists.xenproject.org, tglx@linutronix.de,
        david.vrabel@citrix.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, peterz@infradead.org,
        xen-devel@lists.xenproject.org, tglx@linutronix.de,
        david.vrabel@citrix.com
In-Reply-To: <20140304203100.978031089@linutronix.de>
References: <20140304203100.978031089@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] xen: Validate online cpus in set_affinity
Git-Commit-ID: 753fbd23f5e59ea9dc0cabe0a684d32100a4af02
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  753fbd23f5e59ea9dc0cabe0a684d32100a4af02
Gitweb:     http://git.kernel.org/tip/753fbd23f5e59ea9dc0cabe0a684d32100a4af02
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 4 Mar 2014 20:43:40 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 12 Mar 2014 13:07:41 +0100

xen: Validate online cpus in set_affinity

The user space interface does not filter out offline cpus. It merily
verifies that the mask contains at least one online cpu. So the
selector in the irq chip implementation needs to make sure to pick
only an online cpu because otherwise:

     Offline Core 1
     Set affinity to 0xe
     Selector will pick first set bit, i.e. core 1

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: David Vrabel <david.vrabel@citrix.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Xen <xen-devel@lists.xenproject.org>
Link: http://lkml.kernel.org/r/20140304203100.978031089@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/xen/events/events_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index 8b91c256..c3458f5 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -1324,7 +1324,7 @@ static int rebind_irq_to_cpu(unsigned irq, unsigned tcpu)
 static int set_affinity_irq(struct irq_data *data, const struct cpumask *dest,
 			    bool force)
 {
-	unsigned tcpu = cpumask_first(dest);
+	unsigned tcpu = cpumask_first_and(dest, cpu_online_mask);
 
 	return rebind_irq_to_cpu(data->irq, tcpu);
 }
