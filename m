Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbaJ0TDW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:03:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52694 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbaJ0TDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:03:16 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 038/105] Drivers: hv: vmbus: Cleanup hv_post_message()
Date: Mon, 27 Oct 2014 11:56:13 -0700
Message-Id: <1414436240-13879-39-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/hv/hv.c           | 27 +++++++++++++++------------
 drivers/hv/hyperv_vmbus.h |  4 ++++
 2 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index f0c5e07..0e3c124 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -138,6 +138,8 @@ int hv_init(void)
 	memset(hv_context.synic_event_page, 0, sizeof(void *) * NR_CPUS);
 	memset(hv_context.synic_message_page, 0,
 	       sizeof(void *) * NR_CPUS);
+	memset(hv_context.post_msg_page, 0,
+	       sizeof(void *) * NR_CPUS);
 	memset(hv_context.vp_index, 0,
 	       sizeof(int) * NR_CPUS);
 	memset(hv_context.event_dpc, 0,
@@ -217,26 +219,18 @@ int hv_post_message(union hv_connection_id connection_id,
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
@@ -244,8 +238,7 @@ int hv_post_message(union hv_connection_id connection_id,
 	status = do_hypercall(HVCALL_POST_MESSAGE, aligned_msg, NULL)
 		& 0xFFFF;
 
-	kfree((void *)addr);
-
+	put_cpu();
 	return status;
 }
 
@@ -294,6 +287,14 @@ int hv_synic_alloc(void)
 			pr_err("Unable to allocate SYNIC event page\n");
 			goto err;
 		}
+
+		hv_context.post_msg_page[cpu] =
+			(void *)get_zeroed_page(GFP_ATOMIC);
+
+		if (hv_context.post_msg_page[cpu] == NULL) {
+			pr_err("Unable to allocate post msg page\n");
+			goto err;
+		}
 	}
 
 	return 0;
@@ -308,6 +309,8 @@ void hv_synic_free_cpu(int cpu)
 		free_page((unsigned long)hv_context.synic_event_page[cpu]);
 	if (hv_context.synic_message_page[cpu])
 		free_page((unsigned long)hv_context.synic_message_page[cpu]);
+	if (hv_context.post_msg_page[cpu])
+		free_page((unsigned long)hv_context.post_msg_page[cpu]);
 }
 
 void hv_synic_free(void)
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index e055176..9fa0cab 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -510,6 +510,10 @@ struct hv_context {
 	 * basis.
 	 */
 	struct tasklet_struct *event_dpc[NR_CPUS];
+	/*
+	 * buffer to post messages to the host.
+	 */
+	void *post_msg_page[NR_CPUS];
 };
 
 extern struct hv_context hv_context;
-- 
1.9.1

