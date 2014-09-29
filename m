Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067AbaI2JDw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 05:03:52 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:39679 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894AbaI2JDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 05:03:49 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 2/6] ALSA: ctxfi: removed typecast to (struct hw *)
Date: Mon, 29 Sep 2014 14:33:22 +0530
Message-Id: <1411981406-10611-2-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1411981406-10611-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1411981406-10611-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the previous patch of the series has converted the void * to
struct hw * . Now this patch removes the typecasting to (struct hw *)
which is not needed any more.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 sound/pci/ctxfi/ctatc.c      |  2 +-
 sound/pci/ctxfi/ctresource.c | 26 +++++++++-----------------
 sound/pci/ctxfi/ctsrc.c      |  6 +++---
 3 files changed, 13 insertions(+), 21 deletions(-)

diff --git a/sound/pci/ctxfi/ctatc.c b/sound/pci/ctxfi/ctatc.c
index 04e54cc..e536ab9 100644
--- a/sound/pci/ctxfi/ctatc.c
+++ b/sound/pci/ctxfi/ctatc.c
@@ -1235,7 +1235,7 @@ static int ct_atc_destroy(struct ct_atc *atc)
 	}
 
 	if (atc->hw)
-		destroy_hw_obj((struct hw *)atc->hw);
+		destroy_hw_obj(atc->hw);
 
 	/* Destroy device virtual memory manager object */
 	if (atc->vm) {
diff --git a/sound/pci/ctxfi/ctresource.c b/sound/pci/ctxfi/ctresource.c
index f14cbea..5aac63f 100644
--- a/sound/pci/ctxfi/ctresource.c
+++ b/sound/pci/ctxfi/ctresource.c
@@ -152,11 +152,10 @@ rsc_init(struct rsc *rsc, u32 idx, enum RSCTYP type, u32 msr, struct hw *hw)
 
 	switch (type) {
 	case SRC:
-		err = ((struct hw *)hw)->src_rsc_get_ctrl_blk(&rsc->ctrl_blk);
+		err = hw->src_rsc_get_ctrl_blk(&rsc->ctrl_blk);
 		break;
 	case AMIXER:
-		err = ((struct hw *)hw)->
-				amixer_rsc_get_ctrl_blk(&rsc->ctrl_blk);
+		err = hw->amixer_rsc_get_ctrl_blk(&rsc->ctrl_blk);
 		break;
 	case SRCIMP:
 	case SUM:
@@ -180,12 +179,10 @@ int rsc_uninit(struct rsc *rsc)
 	if ((NULL != rsc->hw) && (NULL != rsc->ctrl_blk)) {
 		switch (rsc->type) {
 		case SRC:
-			((struct hw *)rsc->hw)->
-				src_rsc_put_ctrl_blk(rsc->ctrl_blk);
+			rsc->hw->src_rsc_put_ctrl_blk(rsc->ctrl_blk);
 			break;
 		case AMIXER:
-			((struct hw *)rsc->hw)->
-				amixer_rsc_put_ctrl_blk(rsc->ctrl_blk);
+			rsc->hw->amixer_rsc_put_ctrl_blk(rsc->ctrl_blk);
 			break;
 		case SUM:
 		case DAIO:
@@ -207,10 +204,9 @@ int rsc_uninit(struct rsc *rsc)
 }
 
 int rsc_mgr_init(struct rsc_mgr *mgr, enum RSCTYP type,
-		 unsigned int amount, struct hw *hw_obj)
+		 unsigned int amount, struct hw *hw)
 {
 	int err = 0;
-	struct hw *hw = hw_obj;
 
 	mgr->type = NUM_RSCTYP;
 
@@ -265,20 +261,16 @@ int rsc_mgr_uninit(struct rsc_mgr *mgr)
 	if ((NULL != mgr->hw) && (NULL != mgr->ctrl_blk)) {
 		switch (mgr->type) {
 		case SRC:
-			((struct hw *)mgr->hw)->
-				src_mgr_put_ctrl_blk(mgr->ctrl_blk);
+			mgr->hw->src_mgr_put_ctrl_blk(mgr->ctrl_blk);
 			break;
 		case SRCIMP:
-			((struct hw *)mgr->hw)->
-				srcimp_mgr_put_ctrl_blk(mgr->ctrl_blk);
+			mgr->hw->srcimp_mgr_put_ctrl_blk(mgr->ctrl_blk);
 			break;
 		case AMIXER:
-			((struct hw *)mgr->hw)->
-				amixer_mgr_put_ctrl_blk(mgr->ctrl_blk);
+			mgr->hw->amixer_mgr_put_ctrl_blk(mgr->ctrl_blk);
 			break;
 		case DAIO:
-			((struct hw *)mgr->hw)->
-				daio_mgr_put_ctrl_blk(mgr->ctrl_blk);
+			mgr->hw->daio_mgr_put_ctrl_blk(mgr->ctrl_blk);
 			break;
 		case SUM:
 			break;
diff --git a/sound/pci/ctxfi/ctsrc.c b/sound/pci/ctxfi/ctsrc.c
index 342008f..d3ef213 100644
--- a/sound/pci/ctxfi/ctsrc.c
+++ b/sound/pci/ctxfi/ctsrc.c
@@ -558,7 +558,7 @@ int src_mgr_create(struct hw *hw, struct src_mgr **rsrc_mgr)
 		goto error1;
 
 	spin_lock_init(&src_mgr->mgr_lock);
-	conj_mask = ((struct hw *)hw)->src_dirty_conj_mask();
+	conj_mask = hw->src_dirty_conj_mask();
 
 	src_mgr->get_src = get_src_rsc;
 	src_mgr->put_src = put_src_rsc;
@@ -569,9 +569,9 @@ int src_mgr_create(struct hw *hw, struct src_mgr **rsrc_mgr)
 
 	/* Disable all SRC resources. */
 	for (i = 0; i < 256; i++)
-		((struct hw *)hw)->src_mgr_dsb_src(src_mgr->mgr.ctrl_blk, i);
+		hw->src_mgr_dsb_src(src_mgr->mgr.ctrl_blk, i);
 
-	((struct hw *)hw)->src_mgr_commit_write(hw, src_mgr->mgr.ctrl_blk);
+	hw->src_mgr_commit_write(hw, src_mgr->mgr.ctrl_blk);
 
 	*rsrc_mgr = src_mgr;
 
-- 
1.8.1.2

