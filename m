Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab3BCPGc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:06:32 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34493 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754730Ab3BCO5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:57:39 -0500
Message-Id: <20130203144652.358569139@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:48:18 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Ilija Hadzic <ihadzic@research.bell-labs.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 094/128] drm/radeon: fix a rare case of double kfree
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilija Hadzic <ihadzic@research.bell-labs.com>

commit 1da80cfa8727abf404fcee44d04743febea54069 upstream.

If one (but not both) allocations of p->chunks[].kpage[]
in radeon_cs_parser_init fail, the error path will free
the successfully allocated page, but leave a stale pointer
value in the kpage[] field. This will later cause a
double-free when radeon_cs_parser_fini is called.
This patch fixes the issue by forcing both pointers to NULL
after kfree in the error path.

The circumstances under which the problem happens are very
rare. The card must be AGP and the system must run out of
kmalloc area just at the right time so that one allocation
succeeds, while the other fails.

Signed-off-by: Ilija Hadzic <ihadzic@research.bell-labs.com>
Cc: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[bwh: Backported to 3.2: s/p->chunk_ib_idx/i/]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/radeon_cs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_cs.c
+++ b/drivers/gpu/drm/radeon/radeon_cs.c
@@ -168,6 +168,8 @@ int radeon_cs_parser_init(struct radeon_
 			if (p->chunks[i].kpage[0] == NULL || p->chunks[i].kpage[1] == NULL) {
 				kfree(p->chunks[i].kpage[0]);
 				kfree(p->chunks[i].kpage[1]);
+				p->chunks[i].kpage[0] = NULL;
+				p->chunks[i].kpage[1] = NULL;
 				return -ENOMEM;
 			}
 			p->chunks[i].kpage_idx[0] = -1;


