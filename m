Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbaKYKlw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:41:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58503 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbaKYKlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:41:42 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thorsten Knabe <linux@thorsten-knabe.de>,
        Richard Weinberger <richard@nod.at>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 099/254] um: ubd: Fix for processes stuck in D state forever
Date: Tue, 25 Nov 2014 10:37:29 +0000
Message-Id: <1416912004-5928-100-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Knabe <linux@thorsten-knabe.de>

commit 2a2361228c5e6d8c1733f00653481de918598e50 upstream.

Starting with Linux 3.12 processes get stuck in D state forever in
UserModeLinux under sync heavy workloads. This bug was introduced by
commit 805f11a0d5 (um: ubd: Add REQ_FLUSH suppport).
Fix bug by adding a check if FLUSH request was successfully submitted to
the I/O thread and keeping the FLUSH request on the request queue on
submission failures.

Fixes: 805f11a0d5 (um: ubd: Add REQ_FLUSH suppport)
Signed-off-by: Thorsten Knabe <linux@thorsten-knabe.de>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/um/drivers/ubd_kern.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 3716e6952554..e8ab93c3e638 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -1277,7 +1277,7 @@ static void do_ubd_request(struct request_queue *q)
 
 	while(1){
 		struct ubd *dev = q->queuedata;
-		if(dev->end_sg == 0){
+		if(dev->request == NULL){
 			struct request *req = blk_fetch_request(q);
 			if(req == NULL)
 				return;
@@ -1299,7 +1299,8 @@ static void do_ubd_request(struct request_queue *q)
 				return;
 			}
 			prepare_flush_request(req, io_req);
-			submit_request(io_req, dev);
+			if (submit_request(io_req, dev) == false)
+				return;
 		}
 
 		while(dev->start_sg < dev->end_sg){
-- 
2.1.0

