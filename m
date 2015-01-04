Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbbADHQJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 02:16:09 -0500
Received: from mga14.intel.com ([192.55.52.115]:16528 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbbADHP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 02:15:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,694,1413270000"; 
   d="scan'208";a="646039968"
From: Feng Tang <feng.tang@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>, John Stultz <john.stultz@linaro.org>
Cc: Colin Cross <ccross@android.com>, Heesub Shin <heesub.shin@samsung.com>,
        Mitchel Humpherys <mitchelh@codeaurora.org>,
        linux-kernel@vger.kernel.org, Feng Tang <feng.tang@intel.com>
Subject: [PATCH 2/2] staging: android: ion: Add pss info for each ion_client
Date: Sun,  4 Jan 2015 15:11:52 +0800
Message-Id: <1420355512-31129-2-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1420355512-31129-1-git-send-email-feng.tang@intel.com>
References: <1420355512-31129-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In real ION buffer usage, many of the ion buffer are shared
by several clients(imported and exported), and current ion
debugfs only provides size of all buffers a client may use.
This patch will considers the sharing and adds a "pss" info
for each ion_client, which will help on profiling the ion
memory usage.

Actually we can do more aggressively in android world, in
which the "surfaceflinger" is a main proxy to help other
apps to do the ion buffer allocation, and we can consider
this and extract "surfaceflinger" related size out. And
this could be the next step.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 drivers/staging/android/ion/ion.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 3d378ef..0b8fd56 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -1386,18 +1386,25 @@ static const struct file_operations ion_fops = {
 };
 
 static size_t ion_debug_heap_total(struct ion_client *client,
-				   unsigned int id)
+				   unsigned int id, size_t *psize)
 {
 	size_t size = 0;
 	struct rb_node *n;
 
+	*psize = 0;
+
 	mutex_lock(&client->lock);
 	for (n = rb_first(&client->handles); n; n = rb_next(n)) {
 		struct ion_handle *handle = rb_entry(n,
 						     struct ion_handle,
 						     node);
-		if (handle->buffer->heap->id == id)
+		if (handle->buffer->heap->id == id) {
 			size += handle->buffer->size;
+			if (handle->buffer->handle_count)
+				*psize += handle->buffer->size /
+					handle->buffer->handle_count;
+		}
+
 	}
 	mutex_unlock(&client->lock);
 	return size;
@@ -1411,13 +1418,15 @@ static int ion_debug_heap_show(struct seq_file *s, void *unused)
 	size_t total_size = 0;
 	size_t total_orphaned_size = 0;
 
-	seq_printf(s, "%16.s %16.s %16.s\n", "client", "pid", "size");
+	seq_printf(s, "%16.s %16.s %16.s %16.s\n",
+			"client", "pid", "size", "psize");
 	seq_puts(s, "----------------------------------------------------\n");
 
 	for (n = rb_first(&dev->clients); n; n = rb_next(n)) {
 		struct ion_client *client = rb_entry(n, struct ion_client,
 						     node);
-		size_t size = ion_debug_heap_total(client, heap->id);
+		size_t psize;
+		size_t size = ion_debug_heap_total(client, heap->id, &psize);
 
 		if (!size)
 			continue;
@@ -1425,11 +1434,11 @@ static int ion_debug_heap_show(struct seq_file *s, void *unused)
 			char task_comm[TASK_COMM_LEN];
 
 			get_task_comm(task_comm, client->task);
-			seq_printf(s, "%16.s %16u %16zu\n", task_comm,
-				   client->pid, size);
+			seq_printf(s, "%16.s %16u %16zu %16zu\n", task_comm,
+				   client->pid, size, psize);
 		} else {
-			seq_printf(s, "%16.s %16u %16zu\n", client->name,
-				   client->pid, size);
+			seq_printf(s, "%16.s %16u %16zu %16zu\n", client->name,
+				   client->pid, size, psize);
 		}
 	}
 	seq_puts(s, "----------------------------------------------------\n");
-- 
1.7.9.5

