Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab3H1Pxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 11:53:43 -0400
Received: from smtp-out-189.synserver.de ([212.40.185.189]:1043 "EHLO
	smtp-out-189.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816Ab3H1Pxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 11:53:42 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 13912
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@kernel.org>
Cc: Bard Liao <bardliao@realtek.com>, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] regmap: debugfs: Fix continued read from registers file
Date: Wed, 28 Aug 2013 17:55:07 +0200
Message-Id: <1377705307-24187-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regmap_debugfs_get_dump_start() function maps from a file offset to the
register that can be found at that position in the file. This is done using a
look-up table. Commit d6814a7d ("regmap: debugfs: Suppress cache for partial
register files") added a check to bypass the look-up table for partial register
files, since the offsets in that table are only correct for the full register
file. The check incorrectly uses the file offset instead of the register base
address and returns it. This will cause the file offset to be interpreted as a
register address which will result in a incorrect output from the registers file
for all reads except at position 0.

The issue can easily be reproduced by doing small reads the registers file, e.g.
`dd if=registers bs=10 count=5`.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/base/regmap/regmap-debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index 5349575..6c2652a 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -85,8 +85,8 @@ static unsigned int regmap_debugfs_get_dump_start(struct regmap *map,
 	unsigned int reg_offset;
 
 	/* Suppress the cache if we're using a subrange */
-	if (from)
-		return from;
+	if (base)
+		return base;
 
 	/*
 	 * If we don't have a cache build one so we don't have to do a
-- 
1.8.0

