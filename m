Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282Ab3EGNkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:40:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42035 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201Ab3EGNk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:40:28 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Illia Ragozin <illia.ragozin@grapecom.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 006/118] ARM: 7696/1: Fix kexec by setting outer_cache.inv_all for Feroceon
Date: Tue,  7 May 2013 14:37:32 +0100
Message-Id: <1367933964-1564-7-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Illia Ragozin <illia.ragozin@grapecom.com>

commit cd272d1ea71583170e95dde02c76166c7f9017e6 upstream.

On Feroceon the L2 cache becomes non-coherent with the CPU
when the L1 caches are disabled. Thus the L2 needs to be invalidated
after both L1 caches are disabled.

On kexec before the starting the code for relocation the kernel,
the L1 caches are disabled in cpu_froc_fin (cpu_v7_proc_fin for Feroceon),
but after L2 cache is never invalidated, because inv_all is not set
in cache-feroceon-l2.c.
So kernel relocation and decompression may has (and usually has) errors.
Setting the function enables L2 invalidation and fixes the issue.

Signed-off-by: Illia Ragozin <illia.ragozin@grapecom.com>
Acked-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mm/cache-feroceon-l2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mm/cache-feroceon-l2.c b/arch/arm/mm/cache-feroceon-l2.c
index dd3d591..48bc3c0 100644
--- a/arch/arm/mm/cache-feroceon-l2.c
+++ b/arch/arm/mm/cache-feroceon-l2.c
@@ -343,6 +343,7 @@ void __init feroceon_l2_init(int __l2_wt_override)
 	outer_cache.inv_range = feroceon_l2_inv_range;
 	outer_cache.clean_range = feroceon_l2_clean_range;
 	outer_cache.flush_range = feroceon_l2_flush_range;
+	outer_cache.inv_all = l2_inv_all;
 
 	enable_l2();
 
-- 
1.8.1.2

