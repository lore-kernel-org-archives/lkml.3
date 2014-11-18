Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbaKRPGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:06:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57087 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932071AbaKROJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:40 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Thorsten Knabe <linux@thorsten-knabe.de>,
        Richard Weinberger <richard@nod.at>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 076/206] um: ubd: Fix for processes stuck in D state forever
Date: Tue, 18 Nov 2014 15:07:11 +0100
Message-Id: <63550e4be59837925cc1bee167bee83a90ce974c.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thorsten Knabe <linux@thorsten-knabe.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
2.1.3

