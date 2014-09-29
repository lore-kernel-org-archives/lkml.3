Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbaI2JDy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 05:03:54 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:61933 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbaI2JDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 05:03:52 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 3/6] ALSA: ctxfi: added reference of snd_card
Date: Mon, 29 Sep 2014 14:33:23 +0530
Message-Id: <1411981406-10611-3-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1411981406-10611-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1411981406-10611-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

added a pointer of snd_card in some of the structures to get a
reference of the card from other functions.
these references of snd_card will be initialised in the next patch
of this series and as of now these snd_card will be used to print the
the device information when we convert the pr_* macros to dev_* in a
later patch of this series.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 sound/pci/ctxfi/ctamixer.h   |  3 +++
 sound/pci/ctxfi/ctdaio.c     | 34 ++++++++++++++++------------------
 sound/pci/ctxfi/ctdaio.h     |  2 ++
 sound/pci/ctxfi/cthardware.h |  2 ++
 sound/pci/ctxfi/ctsrc.h      |  3 +++
 5 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/sound/pci/ctxfi/ctamixer.h b/sound/pci/ctxfi/ctamixer.h
index 6fa5eff..72f42f2 100644
--- a/sound/pci/ctxfi/ctamixer.h
+++ b/sound/pci/ctxfi/ctamixer.h
@@ -21,6 +21,7 @@
 
 #include "ctresource.h"
 #include <linux/spinlock.h>
+#include <sound/core.h>
 
 /* Define the descriptor of a summation node resource */
 struct sum {
@@ -35,6 +36,7 @@ struct sum_desc {
 
 struct sum_mgr {
 	struct rsc_mgr mgr;	/* Basic resource manager info */
+	struct snd_card *card;	/* pointer to this card */
 	spinlock_t mgr_lock;
 
 	 /* request one sum resource */
@@ -79,6 +81,7 @@ struct amixer_desc {
 
 struct amixer_mgr {
 	struct rsc_mgr mgr;	/* Basic resource manager info */
+	struct snd_card *card;	/* pointer to this card */
 	spinlock_t mgr_lock;
 
 	 /* request one amixer resource */
diff --git a/sound/pci/ctxfi/ctdaio.c b/sound/pci/ctxfi/ctdaio.c
index 7541641..3d47fd8 100644
--- a/sound/pci/ctxfi/ctdaio.c
+++ b/sound/pci/ctxfi/ctdaio.c
@@ -140,19 +140,19 @@ static int dao_rsc_reinit(struct dao *dao, const struct dao_desc *desc);
 
 static int dao_spdif_get_spos(struct dao *dao, unsigned int *spos)
 {
-	((struct hw *)dao->hw)->dao_get_spos(dao->ctrl_blk, spos);
+	dao->hw->dao_get_spos(dao->ctrl_blk, spos);
 	return 0;
 }
 
 static int dao_spdif_set_spos(struct dao *dao, unsigned int spos)
 {
-	((struct hw *)dao->hw)->dao_set_spos(dao->ctrl_blk, spos);
+	dao->hw->dao_set_spos(dao->ctrl_blk, spos);
 	return 0;
 }
 
 static int dao_commit_write(struct dao *dao)
 {
-	((struct hw *)dao->hw)->dao_commit_write(dao->hw,
+	dao->hw->dao_commit_write(dao->hw,
 		daio_device_index(dao->daio.type, dao->hw), dao->ctrl_blk);
 	return 0;
 }
@@ -277,16 +277,14 @@ static struct dao_rsc_ops dao_ops = {
 static int dai_set_srt_srcl(struct dai *dai, struct rsc *src)
 {
 	src->ops->master(src);
-	((struct hw *)dai->hw)->dai_srt_set_srcm(dai->ctrl_blk,
-						src->ops->index(src));
+	dai->hw->dai_srt_set_srcm(dai->ctrl_blk, src->ops->index(src));
 	return 0;
 }
 
 static int dai_set_srt_srcr(struct dai *dai, struct rsc *src)
 {
 	src->ops->master(src);
-	((struct hw *)dai->hw)->dai_srt_set_srco(dai->ctrl_blk,
-						src->ops->index(src));
+	dai->hw->dai_srt_set_srco(dai->ctrl_blk, src->ops->index(src));
 	return 0;
 }
 
@@ -297,25 +295,25 @@ static int dai_set_srt_msr(struct dai *dai, unsigned int msr)
 	for (rsr = 0; msr > 1; msr >>= 1)
 		rsr++;
 
-	((struct hw *)dai->hw)->dai_srt_set_rsr(dai->ctrl_blk, rsr);
+	dai->hw->dai_srt_set_rsr(dai->ctrl_blk, rsr);
 	return 0;
 }
 
 static int dai_set_enb_src(struct dai *dai, unsigned int enb)
 {
-	((struct hw *)dai->hw)->dai_srt_set_ec(dai->ctrl_blk, enb);
+	dai->hw->dai_srt_set_ec(dai->ctrl_blk, enb);
 	return 0;
 }
 
 static int dai_set_enb_srt(struct dai *dai, unsigned int enb)
 {
-	((struct hw *)dai->hw)->dai_srt_set_et(dai->ctrl_blk, enb);
+	dai->hw->dai_srt_set_et(dai->ctrl_blk, enb);
 	return 0;
 }
 
 static int dai_commit_write(struct dai *dai)
 {
-	((struct hw *)dai->hw)->dai_commit_write(dai->hw,
+	dai->hw->dai_commit_write(dai->hw,
 		daio_device_index(dai->daio.type, dai->hw), dai->ctrl_blk);
 	return 0;
 }
@@ -336,7 +334,7 @@ static int daio_rsc_init(struct daio *daio,
 	int err;
 	unsigned int idx_l, idx_r;
 
-	switch (((struct hw *)hw)->chip_type) {
+	switch (hw->chip_type) {
 	case ATC20K1:
 		idx_l = idx_20k1[desc->type].left;
 		idx_r = idx_20k1[desc->type].right;
@@ -360,7 +358,7 @@ static int daio_rsc_init(struct daio *daio,
 	if (desc->type <= DAIO_OUT_MAX) {
 		daio->rscl.ops = daio->rscr.ops = &daio_out_rsc_ops;
 	} else {
-		switch (((struct hw *)hw)->chip_type) {
+		switch (hw->chip_type) {
 		case ATC20K1:
 			daio->rscl.ops = daio->rscr.ops = &daio_in_rsc_ops_20k1;
 			break;
@@ -445,7 +443,7 @@ static int dao_rsc_uninit(struct dao *dao)
 		kfree(dao->imappers);
 		dao->imappers = NULL;
 	}
-	((struct hw *)dao->hw)->dao_put_ctrl_blk(dao->ctrl_blk);
+	dao->hw->dao_put_ctrl_blk(dao->ctrl_blk);
 	dao->hw = dao->ctrl_blk = NULL;
 	daio_rsc_uninit(&dao->daio);
 
@@ -502,7 +500,7 @@ error1:
 
 static int dai_rsc_uninit(struct dai *dai)
 {
-	((struct hw *)dai->hw)->dai_put_ctrl_blk(dai->ctrl_blk);
+	dai->hw->dai_put_ctrl_blk(dai->ctrl_blk);
 	dai->hw = dai->ctrl_blk = NULL;
 	daio_rsc_uninit(&dai->daio);
 	return 0;
@@ -729,10 +727,10 @@ int daio_mgr_create(struct hw *hw, struct daio_mgr **rdaio_mgr)
 	daio_mgr->commit_write = daio_mgr_commit_write;
 
 	for (i = 0; i < 8; i++) {
-		((struct hw *)hw)->daio_mgr_dsb_dao(daio_mgr->mgr.ctrl_blk, i);
-		((struct hw *)hw)->daio_mgr_dsb_dai(daio_mgr->mgr.ctrl_blk, i);
+		hw->daio_mgr_dsb_dao(daio_mgr->mgr.ctrl_blk, i);
+		hw->daio_mgr_dsb_dai(daio_mgr->mgr.ctrl_blk, i);
 	}
-	((struct hw *)hw)->daio_mgr_commit_write(hw, daio_mgr->mgr.ctrl_blk);
+	hw->daio_mgr_commit_write(hw, daio_mgr->mgr.ctrl_blk);
 
 	*rdaio_mgr = daio_mgr;
 
diff --git a/sound/pci/ctxfi/ctdaio.h b/sound/pci/ctxfi/ctdaio.h
index e4817de..0ebbf35 100644
--- a/sound/pci/ctxfi/ctdaio.h
+++ b/sound/pci/ctxfi/ctdaio.h
@@ -23,6 +23,7 @@
 #include "ctimap.h"
 #include <linux/spinlock.h>
 #include <linux/list.h>
+#include <sound/core.h>
 
 /* Define the descriptor of a daio resource */
 enum DAIOTYP {
@@ -98,6 +99,7 @@ struct daio_desc {
 
 struct daio_mgr {
 	struct rsc_mgr mgr;	/* Basic resource manager info */
+	struct snd_card *card;	/* pointer to this card */
 	spinlock_t mgr_lock;
 	spinlock_t imap_lock;
 	struct list_head imappers;
diff --git a/sound/pci/ctxfi/cthardware.h b/sound/pci/ctxfi/cthardware.h
index c5ded6a..54cc9cb 100644
--- a/sound/pci/ctxfi/cthardware.h
+++ b/sound/pci/ctxfi/cthardware.h
@@ -20,6 +20,7 @@
 
 #include <linux/types.h>
 #include <linux/pci.h>
+#include <sound/core.h>
 
 enum CHIPTYP {
 	ATC20K1,
@@ -184,6 +185,7 @@ struct hw {
 	void *irq_callback_data;
 
 	struct pci_dev *pci;	/* the pci kernel structure of this card */
+	struct snd_card *card;	/* pointer to this card */
 	int irq;
 	unsigned long io_base;
 	void __iomem *mem_base;
diff --git a/sound/pci/ctxfi/ctsrc.h b/sound/pci/ctxfi/ctsrc.h
index 6d95afb..da7573c 100644
--- a/sound/pci/ctxfi/ctsrc.h
+++ b/sound/pci/ctxfi/ctsrc.h
@@ -23,6 +23,7 @@
 #include "ctimap.h"
 #include <linux/spinlock.h>
 #include <linux/list.h>
+#include <sound/core.h>
 
 #define SRC_STATE_OFF	0x0
 #define SRC_STATE_INIT	0x4
@@ -85,6 +86,7 @@ struct src_desc {
 /* Define src manager object */
 struct src_mgr {
 	struct rsc_mgr mgr;	/* Basic resource manager info */
+	struct snd_card *card;	/* pointer to this card */
 	spinlock_t mgr_lock;
 
 	 /* request src resource */
@@ -123,6 +125,7 @@ struct srcimp_desc {
 
 struct srcimp_mgr {
 	struct rsc_mgr mgr;	/* Basic resource manager info */
+	struct snd_card *card;	/* pointer to this card */
 	spinlock_t mgr_lock;
 	spinlock_t imap_lock;
 	struct list_head imappers;
-- 
1.8.1.2

