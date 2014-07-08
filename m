Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485AbaGHTPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:15:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54271 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755763AbaGHTIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:42 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "=?UTF-8?q?Christian=20K=C3=B6nig?=" <christian.koenig@amd.com>,
        "Alex Deucher" <alexander.deucher@amd.com>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.559974520@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 072/125] drm/radeon: stop poisoning the GART TLB
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

commit 0986c1a55ca64b44ee126a2f719a6e9f28cbe0ed upstream.

When we set the valid bit on invalid GART entries they are
loaded into the TLB when an adjacent entry is loaded. This
poisons the TLB with invalid entries which are sometimes
not correctly removed on TLB flush.

For stable inclusion the patch probably needs to be modified a bit.

Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[bwh: Backported to 3.2: R600_PTE_GART is not defined and we list all the
 flags indvidually]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/gpu/drm/radeon/rs600.c
+++ b/drivers/gpu/drm/radeon/rs600.c
@@ -529,8 +529,11 @@ int rs600_gart_set_page(struct radeon_de
 		return -EINVAL;
 	}
 	addr = addr & 0xFFFFFFFFFFFFF000ULL;
-	addr |= R600_PTE_VALID | R600_PTE_SYSTEM | R600_PTE_SNOOPED;
-	addr |= R600_PTE_READABLE | R600_PTE_WRITEABLE;
+	if (addr == rdev->dummy_page.addr)
+		addr |= R600_PTE_SYSTEM | R600_PTE_SNOOPED;
+	else
+		addr |= (R600_PTE_VALID | R600_PTE_SYSTEM | R600_PTE_SNOOPED |
+			 R600_PTE_READABLE | R600_PTE_WRITEABLE);
 	writeq(addr, ptr + (i * 8));
 	return 0;
 }

