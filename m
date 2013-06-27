Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab3F0UAc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 16:00:32 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:33064 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845Ab3F0UAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 16:00:25 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v3 25/45] [SCSI] fcoe: Use get/put_online_cpus_atomic() to
 prevent CPU offline
To: tglx@linutronix.de, peterz@infradead.org, tj@kernel.org, oleg@redhat.com,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org, walken@google.com,
        vincent.guittot@linaro.org, laijs@cn.fujitsu.com,
        David.Laight@aculab.com
Cc: rostedt@goodmis.org, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, sbw@mit.edu, fweisbec@gmail.com,
        zhong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        srivatsa.bhat@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-arch@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Love <robert.w.love@intel.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>, devel@open-fcoe.org,
        linux-scsi@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Fri, 28 Jun 2013 01:26:55 +0530
Message-ID: <20130627195655.29830.44202.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130627195136.29830.10445.stgit@srivatsabhat.in.ibm.com>
References: <20130627195136.29830.10445.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062719-3864-0000-0000-000008D5E6CB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once stop_machine() is gone from the CPU offline path, we won't be able
to depend on disabling preemption to prevent CPUs from going offline
from under us.

Use the get/put_online_cpus_atomic() APIs to prevent CPUs from going
offline, while invoking from atomic context.

Cc: Robert Love <robert.w.love@intel.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: devel@open-fcoe.org
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 drivers/scsi/fcoe/fcoe.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 32ae6c6..eaa390e 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1484,6 +1484,7 @@ static int fcoe_rcv(struct sk_buff *skb, struct net_device *netdev,
 	 * was originated, otherwise select cpu using rx exchange id
 	 * or fcoe_select_cpu().
 	 */
+	get_online_cpus_atomic();
 	if (ntoh24(fh->fh_f_ctl) & FC_FC_EX_CTX)
 		cpu = ntohs(fh->fh_ox_id) & fc_cpu_mask;
 	else {
@@ -1493,8 +1494,10 @@ static int fcoe_rcv(struct sk_buff *skb, struct net_device *netdev,
 			cpu = ntohs(fh->fh_rx_id) & fc_cpu_mask;
 	}
 
-	if (cpu >= nr_cpu_ids)
+	if (cpu >= nr_cpu_ids) {
+		put_online_cpus_atomic();
 		goto err;
+	}
 
 	fps = &per_cpu(fcoe_percpu, cpu);
 	spin_lock(&fps->fcoe_rx_list.lock);
@@ -1514,6 +1517,7 @@ static int fcoe_rcv(struct sk_buff *skb, struct net_device *netdev,
 		spin_lock(&fps->fcoe_rx_list.lock);
 		if (!fps->thread) {
 			spin_unlock(&fps->fcoe_rx_list.lock);
+			put_online_cpus_atomic();
 			goto err;
 		}
 	}
@@ -1535,6 +1539,7 @@ static int fcoe_rcv(struct sk_buff *skb, struct net_device *netdev,
 	if (fps->thread->state == TASK_INTERRUPTIBLE)
 		wake_up_process(fps->thread);
 	spin_unlock(&fps->fcoe_rx_list.lock);
+	put_online_cpus_atomic();
 
 	return 0;
 err:

