Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbaJ0TCs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:02:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52625 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbaJ0TCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:02:46 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thorsten Knabe <linux@thorsten-knabe.de>,
        Richard Weinberger <richard@nod.at>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 092/105] um: ubd: Fix for processes stuck in D state forever
Date: Mon, 27 Oct 2014 11:57:07 -0700
Message-Id: <1414436240-13879-93-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/um/drivers/ubd_kern.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 3716e69..e8ab93c 100644
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
1.9.1

