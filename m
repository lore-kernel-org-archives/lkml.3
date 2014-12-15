Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbaLOOjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:39:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38884 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbaLOO27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:28:59 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ian Campbell <ian.campbell@citrix.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 132/168] of/fdt: memblock_reserve /memreserve/ regions in the case of partial overlap
Date: Mon, 15 Dec 2014 14:26:26 +0000
Message-Id: <1418653622-21105-133-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Campbell <ian.campbell@citrix.com>

commit 094cb98179f19b75acf9ff471daabf3948ce98e6 upstream.

memblock_is_region_reserved() returns true in the case of a partial
overlap, meaning that the current code fails to reserve the
non-overlapping portion.

This call was introduced as part of d1552ce449eb "of/fdt: move
memreserve and dtb memory reservations into core" which went into
v3.16.

I observed this causing a Midway system with a buggy fdt (the header
declares itself to be larger than it really is) failing to boot
because the over-inflated size of the fdt was causing it to seem to
run into the swapper_pg_dir region, meaning the DT wasn't reserved.
The symptoms were failing to find an disks or network and failing to
boot.

However given the ambiguity of whether things like the initrd are
covered by /memreserve/ and similar I think it is best to also
register the region rather than just ignoring it.

Since memblock_reserve() handles overlaps just fine lets just warn and
carry on.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/of/fdt.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index f2da1750a597..5c437ca532b3 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -960,8 +960,6 @@ void __init __weak early_init_dt_add_memory_arch(u64 base, u64 size)
 int __init __weak early_init_dt_reserve_memory_arch(phys_addr_t base,
 					phys_addr_t size, bool nomap)
 {
-	if (memblock_is_region_reserved(base, size))
-		return -EBUSY;
 	if (nomap)
 		return memblock_remove(base, size);
 	return memblock_reserve(base, size);
-- 
2.1.3

