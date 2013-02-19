Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932690Ab3BSMDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 07:03:00 -0500
Received: from mout.gmx.net ([212.227.15.18]:51726 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932473Ab3BSMC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 07:02:57 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+MaFFD2pGMQGNmU8dS87Q9C3+zFND8x7NzTGZZRl
	qgkm1vROfCTmDt
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Devendra Naga <devendra.aaru@gmail.com>, Peter Huewe <peterhuewe@gmx.de>,
        "Robert P. J. Day" <rpjday@crashcourse.ca>,
        Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] staging/sep: Check pointers before dereferencing (fix smatch warning)
Date: Tue, 19 Feb 2013 13:07:28 +0100
Message-Id: <1361275648-6259-2-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1361275648-6259-1-git-send-email-peterhuewe@gmx.de>
References: <1361275648-6259-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

smatch complains about two dereferenced before check issues:

sep_main.c:2898 sep_free_dma_tables_and_dcb() warn: variable dereferenced before check
'dma_ctx' (see line 2885)
sep_main.c:2898 sep_free_dma_tables_and_dcb() warn: variable dereferenced before check
'*dma_ctx' (see line 2885)

-> Move the checks to the top, but keep the semantics.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/sep/sep_main.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/sep/sep_main.c b/drivers/staging/sep/sep_main.c
index 366d56b..f5b7341 100644
--- a/drivers/staging/sep/sep_main.c
+++ b/drivers/staging/sep/sep_main.c
@@ -2880,6 +2880,8 @@ static int sep_free_dma_tables_and_dcb(struct sep_device *sep, bool isapplet,
 
 	dev_dbg(&sep->pdev->dev, "[PID%d] sep_free_dma_tables_and_dcb\n",
 					current->pid);
+	if (!dma_ctx || !*dma_ctx) /* nothing to be done here*/
+		return 0;
 
 	if (((*dma_ctx)->secure_dma == false) && (isapplet == true)) {
 		dev_dbg(&sep->pdev->dev, "[PID%d] handling applet\n",
@@ -2895,8 +2897,7 @@ static int sep_free_dma_tables_and_dcb(struct sep_device *sep, bool isapplet,
 		 * Go over each DCB and see if
 		 * tail pointer must be updated
 		 */
-		for (i = 0; dma_ctx && *dma_ctx &&
-			i < (*dma_ctx)->nr_dcb_creat; i++, dcb_table_ptr++) {
+		for (i = 0; i < (*dma_ctx)->nr_dcb_creat; i++, dcb_table_ptr++) {
 			if (dcb_table_ptr->out_vr_tail_pt) {
 				pt_hold = (unsigned long)dcb_table_ptr->
 					out_vr_tail_pt;
-- 
1.7.8.6

