Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab3AUWTU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 17:19:20 -0500
Received: from zimbra.linbit.com ([212.69.161.123]:39732 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab3AUWTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 17:19:19 -0500
X-Greylist: delayed 489 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Jan 2013 17:19:18 EST
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com
Subject: [GIT PULL] drbd regression fix
Date: Mon, 21 Jan 2013 23:11:02 +0100
Message-ID: <30887993.uQFo99UF9h@quad>
User-Agent: KMail/4.8.5 (Linux/3.2.0-35-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Here is a single fix I want to hand in for Linux-3.8.

The following changes since commit d2ec180c23a5a1bfe34d8638b0342a47c00cf70f:

  drbd: update Kconfig to match current dependencies (2012-12-06 13:08:29 +0100)

are available in the git repository at:

  git://git.drbd.org/linux-drbd for-jens

for you to fetch changes up to 2681f7f6ce6c7416eb619d0fb19422bcc68bd9e1:

  drbd: fix potential protocol error and resulting disconnect/reconnect (2013-01-21 22:58:36 +0100)

----------------------------------------------------------------
Lars Ellenberg (1):
      drbd: fix potential protocol error and resulting disconnect/reconnect

 drivers/block/drbd/drbd_req.c   |    2 +-
 drivers/block/drbd/drbd_req.h   |    1 +
 drivers/block/drbd/drbd_state.c |    7 +++++++
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index f58a4a4..2b8303a 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -168,7 +168,7 @@ static void wake_all_senders(struct drbd_tconn *tconn) {
 }
 
 /* must hold resource->req_lock */
-static void start_new_tl_epoch(struct drbd_tconn *tconn)
+void start_new_tl_epoch(struct drbd_tconn *tconn)
 {
 	/* no point closing an epoch, if it is empty, anyways. */
 	if (tconn->current_tle_writes == 0)
diff --git a/drivers/block/drbd/drbd_req.h b/drivers/block/drbd/drbd_req.h
index 016de6b..c08d229 100644
--- a/drivers/block/drbd/drbd_req.h
+++ b/drivers/block/drbd/drbd_req.h
@@ -267,6 +267,7 @@ struct bio_and_error {
 	int error;
 };
 
+extern void start_new_tl_epoch(struct drbd_tconn *tconn);
 extern void drbd_req_destroy(struct kref *kref);
 extern void _req_may_be_done(struct drbd_request *req,
 		struct bio_and_error *m);
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 53bf618..0fe220c 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -931,6 +931,7 @@ __drbd_set_state(struct drbd_conf *mdev, union drbd_state ns,
 	enum drbd_state_rv rv = SS_SUCCESS;
 	enum sanitize_state_warnings ssw;
 	struct after_state_chg_work *ascw;
+	bool did_remote, should_do_remote;
 
 	os = drbd_read_state(mdev);
 
@@ -981,11 +982,17 @@ __drbd_set_state(struct drbd_conf *mdev, union drbd_state ns,
 	    (os.disk != D_DISKLESS && ns.disk == D_DISKLESS))
 		atomic_inc(&mdev->local_cnt);
 
+	did_remote = drbd_should_do_remote(mdev->state);
 	mdev->state.i = ns.i;
+	should_do_remote = drbd_should_do_remote(mdev->state);
 	mdev->tconn->susp = ns.susp;
 	mdev->tconn->susp_nod = ns.susp_nod;
 	mdev->tconn->susp_fen = ns.susp_fen;
 
+	/* put replicated vs not-replicated requests in seperate epochs */
+	if (did_remote != should_do_remote)
+		start_new_tl_epoch(mdev->tconn);
+
 	if (os.disk == D_ATTACHING && ns.disk >= D_NEGOTIATING)
 		drbd_print_uuids(mdev, "attached to UUIDs");
 

