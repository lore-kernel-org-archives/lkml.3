Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933205AbaAFWl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:41:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48507 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933170AbaAFWly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:41:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Josh Durgin <josh.durgin@inktank.com>, Alex Elder <elder@linaro.org>
Subject: [PATCH 3.10 117/129] rbd: ignore unmapped snapshots that no longer exist
Date: Mon,  6 Jan 2014 14:39:06 -0800
Message-Id: <20140106223902.943058978@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Durgin <josh.durgin@inktank.com>

commit efadc98aab674153709cc357ba565f04e3164fcd upstream.

This prevents erroring out while adding a device when a snapshot
unrelated to the current mapping is deleted between reading the
snapshot context and reading the snapshot names. If the mapped
snapshot name is not found an error still occurs as usual.

Signed-off-by: Josh Durgin <josh.durgin@inktank.com>
Reviewed-by: Alex Elder <elder@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/rbd.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -4055,8 +4055,13 @@ static u64 rbd_v2_snap_id_by_name(struct
 
 		snap_id = snapc->snaps[which];
 		snap_name = rbd_dev_v2_snap_name(rbd_dev, snap_id);
-		if (IS_ERR(snap_name))
-			break;
+		if (IS_ERR(snap_name)) {
+			/* ignore no-longer existing snapshots */
+			if (PTR_ERR(snap_name) == -ENOENT)
+				continue;
+			else
+				break;
+		}
 		found = !strcmp(name, snap_name);
 		kfree(snap_name);
 	}


