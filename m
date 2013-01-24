Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab3AXDe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:34:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44448 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109Ab3AXDbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:31:49 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ilija Hadzic <ihadzic@research.bell-labs.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 67/74] drm/radeon: fix a bogus kfree
Date: Thu, 24 Jan 2013 01:27:19 -0200
Message-Id: <1358998046-613-68-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilija Hadzic <ihadzic@research.bell-labs.com>

commit a6b7e1a02b77ab8fe8775d20a88c53d8ba55482e upstream.

parser->chunks[.].kpage[.] is not always kmalloc-ed
by the parser initialization, so parser_fini should
not try to kfree it if it didn't allocate it.

This patch fixes a kernel oops that can be provoked
in UMS mode.

Signed-off-by: Ilija Hadzic <ihadzic@research.bell-labs.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/radeon/r600_cs.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r600_cs.c b/drivers/gpu/drm/radeon/r600_cs.c
index 1119e31..c05e88a 100644
--- a/drivers/gpu/drm/radeon/r600_cs.c
+++ b/drivers/gpu/drm/radeon/r600_cs.c
@@ -2330,8 +2330,10 @@ static void r600_cs_parser_fini(struct radeon_cs_parser *parser, int error)
 	kfree(parser->relocs);
 	for (i = 0; i < parser->nchunks; i++) {
 		kfree(parser->chunks[i].kdata);
-		kfree(parser->chunks[i].kpage[0]);
-		kfree(parser->chunks[i].kpage[1]);
+		if (parser->rdev && (parser->rdev->flags & RADEON_IS_AGP)) {
+			kfree(parser->chunks[i].kpage[0]);
+			kfree(parser->chunks[i].kpage[1]);
+		}
 	}
 	kfree(parser->chunks);
 	kfree(parser->chunks_array);
-- 
1.7.9.5

