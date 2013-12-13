Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab3LMW2N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:28:13 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:53090 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab3LMW2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:28:07 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 077/115] ion: index client->handles rbtree by buffer
Date: Fri, 13 Dec 2013 14:24:51 -0800
Message-Id: <1386973529-4884-78-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

The only remaining users of the client->handles rbtree are
iterating through it like a list.  Keep the rbtree, but change
its index to be the buffer address instead of the handle address,
which makes ion_handle_lookup a fast rbtree search.

Signed-off-by: Colin Cross <ccross@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index ece1a4c..ef0b2d7 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -388,13 +388,16 @@ static int ion_handle_put(struct ion_handle *handle)
 static struct ion_handle *ion_handle_lookup(struct ion_client *client,
 					    struct ion_buffer *buffer)
 {
-	struct rb_node *n;
-
-	for (n = rb_first(&client->handles); n; n = rb_next(n)) {
-		struct ion_handle *handle = rb_entry(n, struct ion_handle,
-						   node);
-		if (handle->buffer == buffer)
-			return handle;
+	struct rb_node *n = client->handles.rb_node;
+
+	while (n) {
+		struct ion_handle *entry = rb_entry(n, struct ion_handle, node);
+		if (buffer < entry->buffer)
+			n = n->rb_left;
+		else if (buffer > entry->buffer)
+			n = n->rb_right;
+		else
+			return entry;
 	}
 	return ERR_PTR(-EINVAL);
 }
@@ -432,9 +435,9 @@ static int ion_handle_add(struct ion_client *client, struct ion_handle *handle)
 		parent = *p;
 		entry = rb_entry(parent, struct ion_handle, node);
 
-		if (handle < entry)
+		if (handle->buffer < entry->buffer)
 			p = &(*p)->rb_left;
-		else if (handle > entry)
+		else if (handle->buffer > entry->buffer)
 			p = &(*p)->rb_right;
 		else
 			WARN(1, "%s: buffer already found.", __func__);
-- 
1.8.3.2

