Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab3LMW2x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:28:53 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:36939 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280Ab3LMW2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:28:30 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 091/115] ion: update idr to avoid deprecated apis
Date: Fri, 13 Dec 2013 14:25:05 -0800
Message-Id: <1386973529-4884-92-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

Use idr_alloc instead if idr_pre_get/idr_get_new_above, and
remove idr_remove_all.

Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 8d568ca..199ab9a 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -432,22 +432,16 @@ static bool ion_handle_validate(struct ion_client *client, struct ion_handle *ha
 
 static int ion_handle_add(struct ion_client *client, struct ion_handle *handle)
 {
-	int rc;
+	int id;
 	struct rb_node **p = &client->handles.rb_node;
 	struct rb_node *parent = NULL;
 	struct ion_handle *entry;
 
-	do {
-		int id;
-		rc = idr_pre_get(&client->idr, GFP_KERNEL);
-		if (!rc)
-			return -ENOMEM;
-		rc = idr_get_new_above(&client->idr, handle, 1, &id);
-		handle->id = id;
-	} while (rc == -EAGAIN);
+	id = idr_alloc(&client->idr, handle, 1, 0, GFP_KERNEL);
+	if (id < 0)
+		return id;
 
-	if (rc < 0)
-		return rc;
+	handle->id = id;
 
 	while (*p) {
 		parent = *p;
@@ -786,7 +780,6 @@ void ion_client_destroy(struct ion_client *client)
 		ion_handle_destroy(&handle->ref);
 	}
 
-	idr_remove_all(&client->idr);
 	idr_destroy(&client->idr);
 
 	down_write(&dev->lock);
-- 
1.8.3.2

