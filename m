Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505Ab3ENNHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 09:07:33 -0400
Received: from intranet.asianux.com ([58.214.24.6]:30785 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab3ENNHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 09:07:32 -0400
X-Spam-Score: -100.8
Message-ID: <519236E0.4020301@asianux.com>
Date: Tue, 14 May 2013 21:06:40 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: tj@kernel.org
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel/workqueue.c: kfree issue, need check flag 'WQ_UNBOUND'
 when processing failure.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When failure occurs in __alloc_workqueue_key(), if 'flags' has
'WQ_UNBOUND', the destroy_workqueue() will not release 'wq'.

In this situation, we need release it, or will cause memory leak.

And also simplify the related code.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/workqueue.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 1ae6028..bf644d4 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4167,12 +4167,13 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 
 	return wq;
 
-err_free_wq:
-	free_workqueue_attrs(wq->unbound_attrs);
-	kfree(wq);
-	return NULL;
 err_destroy:
 	destroy_workqueue(wq);
+	if (flags & WQ_UNBOUND) {
+err_free_wq:
+		free_workqueue_attrs(wq->unbound_attrs);
+		kfree(wq);
+	}
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(__alloc_workqueue_key);
-- 
1.7.7.6
