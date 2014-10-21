Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066AbaJUIFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:05:45 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:16575 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727AbaJUIFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:05:36 -0400
From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <dwmw2@infradead.org>, <linux-mtd@lists.infradead.org>,
        <nicolas.ferre@atmel.com>
CC: <linux-kernel@vger.kernel.org>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 1/2] jffs2: fix wrong offset in an error msg from __jff2_dbg_prewrite_paranoia_check
Date: Tue, 21 Oct 2014 10:04:59 +0200
Message-ID: <bd8e2f299311d2e07d48377333a802a7bd944d20.1413878259.git.cyrille.pitchen@atmel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <cover.1413878259.git.cyrille.pitchen@atmel.com>
References: <cover.1413878259.git.cyrille.pitchen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a none 0xff character is found in the flash buffer, an error message is
printed. This error message claims to provide the offset of the FIRST corrupted
byte but due to a missing break in the for loop, the former code always prints
the offset of the byte immediately after the end of the tested buffer.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 fs/jffs2/debug.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/jffs2/debug.c b/fs/jffs2/debug.c
index 1090eb6..07bd5bc 100644
--- a/fs/jffs2/debug.c
+++ b/fs/jffs2/debug.c
@@ -141,12 +141,11 @@ __jffs2_dbg_prewrite_paranoia_check(struct jffs2_sb_info *c,
 		return;
 	}
 
-	ret = 0;
 	for (i = 0; i < len; i++)
 		if (buf[i] != 0xff)
-			ret = 1;
+			break;
 
-	if (ret) {
+	if (i != len) {
 		JFFS2_ERROR("argh, about to write node to %#08x on flash, but there are data already there. The first corrupted byte is at %#08x offset.\n",
 			ofs, ofs + i);
 		__jffs2_dbg_dump_buffer(buf, len, ofs);
-- 
1.8.2.2

