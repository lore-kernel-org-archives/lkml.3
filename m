Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245AbbAYSpF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:45:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57882 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826AbbAYSKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Chen <alex.chen@huawei.com>, Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.18 096/183] dm: fix missed error code if .end_io isnt implemented by target_type
Date: Sun, 25 Jan 2015 10:06:58 -0800
Message-Id: <20150125180814.334232874@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -899,7 +899,7 @@ static void disable_write_same(struct ma
 
 static void clone_endio(struct bio *bio, int error)
 {
-	int r = 0;
+	int r = error;
 	struct dm_target_io *tio = container_of(bio, struct dm_target_io, clone);
 	struct dm_io *io = tio->io;
 	struct mapped_device *md = tio->io->md;


