Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751204AbaHWOEw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 10:04:52 -0400
Received: from mail.thorsten-knabe.de ([212.60.139.226]:50053 "EHLO
	mail.thorsten-knabe.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaHWOEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 10:04:51 -0400
X-Greylist: delayed 1019 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Aug 2014 10:04:49 EDT
Message-ID: <53F89B7A.1040406@thorsten-knabe.de>
Date: Sat, 23 Aug 2014 15:47:38 +0200
From: Thorsten Knabe <linux@thorsten-knabe.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: linux-kernel@vger.kernel.org, Thomas Meyer <thomas@m3y3r.de>,
        Valdis.Kletnieks@vt.edu, linux@thorsten-knabe.de
Subject: [PATCH] UML: UBD: Fix for processes stuck in D state forever in UserModeLinux
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Report: Content analysis details:   (-0.4 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
  0.8 DKIM_ADSP_ALL          No valid author signature, domain signs all mail
 -0.7 RP_MATCHES_RCVD        Envelope sender domain matches handover relay domain
 -0.5 BAYES_05               BODY: Bayes spam probability is 1 to 5%
                             [score: 0.0126]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thorsten Knabe <linux@thorsten-knabe.de>

UML: UBD: Fix for processes stuck in D state forever in UserModeLinux.

Starting with Linux 3.12 processes get stuck in D state forever in
UserModeLinux under sync heavy workloads. This bug was introduced by
commit 805f11a0d5 (um: ubd: Add REQ_FLUSH suppport).
Fix bug by adding a check if FLUSH request was successfully submitted to
the I/O thread and keeping the FLUSH request on the request queue on
submission failures.

Fixes: 805f11a0d5 (um: ubd: Add REQ_FLUSH suppport)
Signed-off-by: Thorsten Knabe <linux@thorsten-knabe.de>
---
Patch applies to 3.16.1.

diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 3716e69..b7d2840 100644
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
___
 |        | /                 E-Mail: linux@thorsten-knabe.de
 |horsten |/\nabe                WWW: http://linux.thorsten-knabe.de
