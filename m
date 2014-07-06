Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbaGFMDY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 08:03:24 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:39337 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbaGFMDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 08:03:22 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Karsten Keil <isdn@linux-pingi.de>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] isdn: hisax: l3ni1.c:  Fix for possible null pointer dereference
Date: Sun,  6 Jul 2014 14:04:37 +0200
Message-Id: <1404648277-12419-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/isdn/hisax/l3ni1.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/isdn/hisax/l3ni1.c b/drivers/isdn/hisax/l3ni1.c
index 0df6691..8dc791b 100644
--- a/drivers/isdn/hisax/l3ni1.c
+++ b/drivers/isdn/hisax/l3ni1.c
@@ -2059,13 +2059,17 @@ static int l3ni1_cmd_global(struct PStack *st, isdn_ctrl *ic)
 			memcpy(p, ic->parm.ni1_io.data, ic->parm.ni1_io.datalen); /* copy data */
 			l = (p - temp) + ic->parm.ni1_io.datalen; /* total length */
 
-			if (ic->parm.ni1_io.timeout > 0)
-				if (!(pc = ni1_new_l3_process(st, -1)))
-				{ free_invoke_id(st, id);
+			if (ic->parm.ni1_io.timeout > 0) {
+				pc = ni1_new_l3_process(st, -1);
+				if (!pc) {
+					free_invoke_id(st, id);
 					return (-2);
 				}
-			pc->prot.ni1.ll_id = ic->parm.ni1_io.ll_id; /* remember id */
-			pc->prot.ni1.proc = ic->parm.ni1_io.proc; /* and procedure */
+				/* remember id */
+				pc->prot.ni1.ll_id = ic->parm.ni1_io.ll_id;
+				/* and procedure */
+				pc->prot.ni1.proc = ic->parm.ni1_io.proc;
+			}
 
 			if (!(skb = l3_alloc_skb(l)))
 			{ free_invoke_id(st, id);
-- 
1.7.10.4

