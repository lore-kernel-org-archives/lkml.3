Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761886AbaGRNnx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:43:53 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17592 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030695AbaGRNLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:11:54 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 164/170] drm/radeon: stop poisoning the GART TLB
Date: Fri, 18 Jul 2014 14:12:49 +0200
Message-Id: <38984e6831c65bb27c5d8169f6aa825513301b4b.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 0986c1a55ca64b44ee126a2f719a6e9f28cbe0ed upstream.

When we set the valid bit on invalid GART entries they are
loaded into the TLB when an adjacent entry is loaded. This
poisons the TLB with invalid entries which are sometimes
not correctly removed on TLB flush.

For stable inclusion the patch probably needs to be modified a bit.

Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/radeon/rs600.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/rs600.c b/drivers/gpu/drm/radeon/rs600.c
index 6acba8017b9a..e0daa4fdb073 100644
--- a/drivers/gpu/drm/radeon/rs600.c
+++ b/drivers/gpu/drm/radeon/rs600.c
@@ -582,8 +582,10 @@ int rs600_gart_set_page(struct radeon_device *rdev, int i, uint64_t addr)
 		return -EINVAL;
 	}
 	addr = addr & 0xFFFFFFFFFFFFF000ULL;
-	addr |= R600_PTE_VALID | R600_PTE_SYSTEM | R600_PTE_SNOOPED;
-	addr |= R600_PTE_READABLE | R600_PTE_WRITEABLE;
+	if (addr != rdev->dummy_page.addr)
+		addr |= R600_PTE_VALID | R600_PTE_READABLE |
+			R600_PTE_WRITEABLE;
+	addr |= R600_PTE_SYSTEM | R600_PTE_SNOOPED;
 	writeq(addr, ptr + (i * 8));
 	return 0;
 }
-- 
2.0.0

