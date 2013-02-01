Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422843Ab3BANN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:13:58 -0500
Received: from mail.kernel.org ([198.145.19.201]:45448 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964772Ab3BANNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:13:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ilija Hadzic <ihadzic@research.bell-labs.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 70/89] drm/radeon: fix a rare case of double kfree
Date: Fri,  1 Feb 2013 14:08:25 +0100
Message-Id: <20130201130212.532993677@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_cs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_cs.c
+++ b/drivers/gpu/drm/radeon/radeon_cs.c
@@ -273,6 +273,8 @@ int radeon_cs_parser_init(struct radeon_
 			    p->chunks[p->chunk_ib_idx].kpage[1] == NULL) {
 				kfree(p->chunks[p->chunk_ib_idx].kpage[0]);
 				kfree(p->chunks[p->chunk_ib_idx].kpage[1]);
+				p->chunks[p->chunk_ib_idx].kpage[0] = NULL;
+				p->chunks[p->chunk_ib_idx].kpage[1] = NULL;
 				return -ENOMEM;
 			}
 		}


