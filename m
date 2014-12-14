Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbaLNUpl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:45:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52903 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaLNUVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:21:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        ji_ang <ji_ang@163.com>, Anton Vorontsov <anton.vorontsov@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 02/34] mm/vmpressure.c: fix race in vmpressure_work_fn()
Date: Sun, 14 Dec 2014 12:20:40 -0800
Message-Id: <20141214201803.863278780@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141214201803.791392744@linuxfoundation.org>
References: <20141214201803.791392744@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Morton <akpm@linux-foundation.org>

commit 91b57191cfd152c02ded0745250167d0263084f8 upstream.

In some android devices, there will be a "divide by zero" exception.
vmpr->scanned could be zero before spin_lock(&vmpr->sr_lock).

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=88051

[akpm@linux-foundation.org: neaten]
Reported-by: ji_ang <ji_ang@163.com>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/vmpressure.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -165,6 +165,7 @@ static void vmpressure_work_fn(struct wo
 	unsigned long scanned;
 	unsigned long reclaimed;
 
+	spin_lock(&vmpr->sr_lock);
 	/*
 	 * Several contexts might be calling vmpressure(), so it is
 	 * possible that the work was rescheduled again before the old
@@ -173,11 +174,12 @@ static void vmpressure_work_fn(struct wo
 	 * here. No need for any locks here since we don't care if
 	 * vmpr->reclaimed is in sync.
 	 */
-	if (!vmpr->scanned)
+	scanned = vmpr->scanned;
+	if (!scanned) {
+		spin_unlock(&vmpr->sr_lock);
 		return;
+	}
 
-	spin_lock(&vmpr->sr_lock);
-	scanned = vmpr->scanned;
 	reclaimed = vmpr->reclaimed;
 	vmpr->scanned = 0;
 	vmpr->reclaimed = 0;


