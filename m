Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbaIOTmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:42:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55533 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550AbaIOTlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:41:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Vrabel <david.vrabel@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 3.14 070/114] xen/events/fifo: reset control block and local HEADs on resume
Date: Mon, 15 Sep 2014 12:26:10 -0700
Message-Id: <20140915192643.632232495@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192641.428509513@linuxfoundation.org>
References: <20140915192641.428509513@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Vrabel <david.vrabel@citrix.com>

commit c12784c3d14a2110468ec4d1383f60cfd2665576 upstream.

When using the FIFO-based event channel ABI, if the control block or
the local HEADs are not reset after resuming the guest may see stale
HEAD values and will fail to traverse the FIFO correctly.

This may prevent one or more VCPUs from receiving any events following
a resume.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/events/events_fifo.c |   48 ++++++++++++++++++++++-----------------
 1 file changed, 28 insertions(+), 20 deletions(-)

--- a/drivers/xen/events/events_fifo.c
+++ b/drivers/xen/events/events_fifo.c
@@ -99,6 +99,25 @@ static unsigned evtchn_fifo_nr_channels(
 	return event_array_pages * EVENT_WORDS_PER_PAGE;
 }
 
+static int init_control_block(int cpu,
+                              struct evtchn_fifo_control_block *control_block)
+{
+	struct evtchn_fifo_queue *q = &per_cpu(cpu_queue, cpu);
+	struct evtchn_init_control init_control;
+	unsigned int i;
+
+	/* Reset the control block and the local HEADs. */
+	clear_page(control_block);
+	for (i = 0; i < EVTCHN_FIFO_MAX_QUEUES; i++)
+		q->head[i] = 0;
+
+	init_control.control_gfn = virt_to_mfn(control_block);
+	init_control.offset      = 0;
+	init_control.vcpu        = cpu;
+
+	return HYPERVISOR_event_channel_op(EVTCHNOP_init_control, &init_control);
+}
+
 static void free_unused_array_pages(void)
 {
 	unsigned i;
@@ -327,7 +346,6 @@ static void evtchn_fifo_resume(void)
 
 	for_each_possible_cpu(cpu) {
 		void *control_block = per_cpu(cpu_control_block, cpu);
-		struct evtchn_init_control init_control;
 		int ret;
 
 		if (!control_block)
@@ -344,12 +362,7 @@ static void evtchn_fifo_resume(void)
 			continue;
 		}
 
-		init_control.control_gfn = virt_to_mfn(control_block);
-		init_control.offset = 0;
-		init_control.vcpu = cpu;
-
-		ret = HYPERVISOR_event_channel_op(EVTCHNOP_init_control,
-						  &init_control);
+		ret = init_control_block(cpu, control_block);
 		if (ret < 0)
 			BUG();
 	}
@@ -377,30 +390,25 @@ static const struct evtchn_ops evtchn_op
 	.resume            = evtchn_fifo_resume,
 };
 
-static int evtchn_fifo_init_control_block(unsigned cpu)
+static int evtchn_fifo_alloc_control_block(unsigned cpu)
 {
-	struct page *control_block = NULL;
-	struct evtchn_init_control init_control;
+	void *control_block = NULL;
 	int ret = -ENOMEM;
 
-	control_block = alloc_page(GFP_KERNEL|__GFP_ZERO);
+	control_block = (void *)__get_free_page(GFP_KERNEL);
 	if (control_block == NULL)
 		goto error;
 
-	init_control.control_gfn = virt_to_mfn(page_address(control_block));
-	init_control.offset      = 0;
-	init_control.vcpu        = cpu;
-
-	ret = HYPERVISOR_event_channel_op(EVTCHNOP_init_control, &init_control);
+	ret = init_control_block(cpu, control_block);
 	if (ret < 0)
 		goto error;
 
-	per_cpu(cpu_control_block, cpu) = page_address(control_block);
+	per_cpu(cpu_control_block, cpu) = control_block;
 
 	return 0;
 
   error:
-	__free_page(control_block);
+	free_page((unsigned long)control_block);
 	return ret;
 }
 
@@ -414,7 +422,7 @@ static int evtchn_fifo_cpu_notification(
 	switch (action) {
 	case CPU_UP_PREPARE:
 		if (!per_cpu(cpu_control_block, cpu))
-			ret = evtchn_fifo_init_control_block(cpu);
+			ret = evtchn_fifo_alloc_control_block(cpu);
 		break;
 	default:
 		break;
@@ -431,7 +439,7 @@ int __init xen_evtchn_fifo_init(void)
 	int cpu = get_cpu();
 	int ret;
 
-	ret = evtchn_fifo_init_control_block(cpu);
+	ret = evtchn_fifo_alloc_control_block(cpu);
 	if (ret < 0)
 		goto out;
 


