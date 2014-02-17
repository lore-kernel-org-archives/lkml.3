Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbaBQV67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:58:59 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:34851 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbaBQV6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:58:52 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Greg KH <gregkh@linuxfoundation.org>, Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 01/14] staging: binder: Fix death notifications
Date: Mon, 17 Feb 2014 13:58:29 -0800
Message-Id: <1392674322-9036-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392674322-9036-1-git-send-email-john.stultz@linaro.org>
References: <1392674322-9036-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arve Hjønnevåg <arve@android.com>

The change (008fa749e0fe5b2fffd20b7fe4891bb80d072c6a) that moved the
node release code to a separate function broke death notifications in
some cases. When it encountered a reference without a death
notification request, it would skip looking at the remaining
references, and therefore fail to send death notifications for them.

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Colin Cross <ccross@android.com>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Arve Hjønnevåg <arve@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/binder.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index eaec1da..1432d95 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -2904,7 +2904,7 @@ static int binder_node_release(struct binder_node *node, int refs)
 		refs++;
 
 		if (!ref->death)
-			goto out;
+			continue;
 
 		death++;
 
@@ -2917,7 +2917,6 @@ static int binder_node_release(struct binder_node *node, int refs)
 			BUG();
 	}
 
-out:
 	binder_debug(BINDER_DEBUG_DEAD_BINDER,
 		     "node %d now dead, refs %d, death %d\n",
 		     node->debug_id, refs, death);
-- 
1.8.3.2

