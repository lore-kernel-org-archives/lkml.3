Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbaKLBXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:23:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58645 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbaKLBXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:23:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thorsten Knabe <linux@thorsten-knabe.de>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 3.17 069/319] um: ubd: Fix for processes stuck in D state forever
Date: Wed, 12 Nov 2014 10:13:27 +0900
Message-Id: <20141112011004.011938120@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/um/drivers/ubd_kern.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -1277,7 +1277,7 @@ static void do_ubd_request(struct reques
 
 	while(1){
 		struct ubd *dev = q->queuedata;
-		if(dev->end_sg == 0){
+		if(dev->request == NULL){
 			struct request *req = blk_fetch_request(q);
 			if(req == NULL)
 				return;
@@ -1299,7 +1299,8 @@ static void do_ubd_request(struct reques
 				return;
 			}
 			prepare_flush_request(req, io_req);
-			submit_request(io_req, dev);
+			if (submit_request(io_req, dev) == false)
+				return;
 		}
 
 		while(dev->start_sg < dev->end_sg){


