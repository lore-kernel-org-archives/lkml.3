Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbbALSjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:39:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58388 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212AbbALSar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:30:47 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Chen <alex.chen@huawei.com>, Mike Snitzer <snitzer@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 184/216] dm: fix missed error code if .end_io isn't implemented by target_type
Date: Mon, 12 Jan 2015 18:29:22 +0000
Message-Id: <1421087394-2712-72-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: zhendong chen <alex.chen@huawei.com>

commit 5164bece1673cdf04782f8ed3fba70743700f5da upstream.

In bio-based DM's clone_endio(), when target_type doesn't implement
.end_io (e.g. linear) r will be always be initialized 0.  So if a
WRITE SAME bio fails WRITE SAME will not be disabled as intended.

Fix this by initializing r to error, rather than 0, in clone_endio().

Signed-off-by: Alex Chen <alex.chen@huawei.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Fixes: 7eee4ae2db ("dm: disable WRITE SAME if it fails")
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 32b958dbc499..00a6cff2fffd 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -776,7 +776,7 @@ static void disable_write_same(struct mapped_device *md)
 
 static void clone_endio(struct bio *bio, int error)
 {
-	int r = 0;
+	int r = error;
 	struct dm_target_io *tio = container_of(bio, struct dm_target_io, clone);
 	struct dm_io *io = tio->io;
 	struct mapped_device *md = tio->io->md;
-- 
2.1.4

