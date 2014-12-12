Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966227AbaLLGt3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:49:29 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52598 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751206AbaLLGsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:48:39 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "K. Y. Srinivasan" <kys@microsoft.com>,
        "Sitsofe Wheeler" <sitsofe@yahoo.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.309658305@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 024/164] Drivers: hv: vmbus: Cleanup hv_post_message()
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit b29ef3546aecb253a5552b198cef23750d56e1e4 upstream.

Minimize failures in this function by pre-allocating the buffer
for posting messages. The hypercall for posting the message can fail
for a number of reasons:

        1. Transient resource related issues
        2. Buffer alignment
        3. Buffer cannot span a page boundry

We address issues 2 and 3 by preallocating a per-cpu page for the buffer.
Transient resource related failures are handled by retrying by the callers
of this function.

This patch is based on the investigation
done by Dexuan Cui <decui@microsoft.com>.

I would like to thank Sitsofe Wheeler <sitsofe@yahoo.com>
for reporting the issue and helping in debuggging.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reported-by: Sitsofe Wheeler <sitsofe@yahoo.com>
Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2:
 - s/NR_CPUS/MAX_NUM_CPUS/
 - Adjust context, indentation
 - Also free the page in hv_synic_init() error path]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hv/hv.c           | 27 +++++++++++++++------------
 drivers/hv/hyperv_vmbus.h |  4 ++++
 2 files changed, 19 insertions(+), 12 deletions(-)

--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -158,6 +158,8 @@ int hv_init(void)
 	memset(hv_context.synic_event_page, 0, sizeof(void *) * MAX_NUM_CPUS);
 	memset(hv_context.synic_message_page, 0,
 	       sizeof(void *) * MAX_NUM_CPUS);
+	memset(hv_context.post_msg_page, 0,
+	       sizeof(void *) * MAX_NUM_CPUS);
 
 	if (!query_hypervisor_presence())
 		goto cleanup;
@@ -258,26 +260,18 @@ u16 hv_post_message(union hv_connection_
 		  enum hv_message_type message_type,
 		  void *payload, size_t payload_size)
 {
-	struct aligned_input {
-		u64 alignment8;
-		struct hv_input_post_message msg;
-	};
 
 	struct hv_input_post_message *aligned_msg;
 	u16 status;
-	unsigned long addr;
 
 	if (payload_size > HV_MESSAGE_PAYLOAD_BYTE_COUNT)
 		return -EMSGSIZE;
 
-	addr = (unsigned long)kmalloc(sizeof(struct aligned_input), GFP_ATOMIC);
-	if (!addr)
-		return -ENOMEM;
-
 	aligned_msg = (struct hv_input_post_message *)
-			(ALIGN(addr, HV_HYPERCALL_PARAM_ALIGN));
+			hv_context.post_msg_page[get_cpu()];
 
 	aligned_msg->connectionid = connection_id;
+	aligned_msg->reserved = 0;
 	aligned_msg->message_type = message_type;
 	aligned_msg->payload_size = payload_size;
 	memcpy((void *)aligned_msg->payload, payload, payload_size);
@@ -285,8 +279,7 @@ u16 hv_post_message(union hv_connection_
 	status = do_hypercall(HVCALL_POST_MESSAGE, aligned_msg, NULL)
 		& 0xFFFF;
 
-	kfree((void *)addr);
-
+	put_cpu();
 	return status;
 }
 
@@ -347,6 +340,14 @@ void hv_synic_init(void *irqarg)
 		goto cleanup;
 	}
 
+	hv_context.post_msg_page[cpu] =
+		(void *)get_zeroed_page(GFP_ATOMIC);
+
+	if (hv_context.post_msg_page[cpu] == NULL) {
+		pr_err("Unable to allocate post msg page\n");
+		goto cleanup;
+	}
+
 	/* Setup the Synic's message page */
 	rdmsrl(HV_X64_MSR_SIMP, simp.as_uint64);
 	simp.simp_enabled = 1;
@@ -388,6 +389,8 @@ cleanup:
 
 	if (hv_context.synic_message_page[cpu])
 		free_page((unsigned long)hv_context.synic_message_page[cpu]);
+	if (hv_context.post_msg_page[cpu])
+		free_page((unsigned long)hv_context.post_msg_page[cpu]);
 	return;
 }
 
@@ -426,4 +429,5 @@ void hv_synic_cleanup(void *arg)
 
 	free_page((unsigned long)hv_context.synic_message_page[cpu]);
 	free_page((unsigned long)hv_context.synic_event_page[cpu]);
+	free_page((unsigned long)hv_context.post_msg_page[cpu]);
 }
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -485,6 +485,10 @@ struct hv_context {
 
 	void *synic_message_page[MAX_NUM_CPUS];
 	void *synic_event_page[MAX_NUM_CPUS];
+	/*
+	 * buffer to post messages to the host.
+	 */
+	void *post_msg_page[MAX_NUM_CPUS];
 };
 
 extern struct hv_context hv_context;

