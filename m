Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbaKRPE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:04:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57226 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932081AbaKROJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:42 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 084/206] xen-blkback: fix leak on grant map error path
Date: Tue, 18 Nov 2014 15:07:19 +0100
Message-Id: <e8dbfec28946937e04c901fec26f1f0676d46ce6.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roger Pau Monné <roger.pau@citrix.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 61cecca865280bef4f8a9748d0a9afa5df351ac2 upstream.

Fix leaking a page when a grant mapping has failed.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Reported-and-Tested-by: Tao Chen <boby.chen@huawei.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/block/xen-blkback/blkback.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 6620b73d0490..6beaaf83680e 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -755,6 +755,7 @@ again:
 			BUG_ON(new_map_idx >= segs_to_map);
 			if (unlikely(map[new_map_idx].status != 0)) {
 				pr_debug(DRV_PFX "invalid buffer -- could not remap it\n");
+				put_free_pages(blkif, &pages[seg_idx]->page, 1);
 				pages[seg_idx]->handle = BLKBACK_INVALID_HANDLE;
 				ret |= 1;
 				goto next;
-- 
2.1.3

