Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130Ab3DVOm2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:42:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51545 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754850Ab3DVOaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:30:03 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jason Cooper" <jason@lakedaemon.net>,
        "Russell King" <rmk+kernel@arm.linux.org.uk>,
        "Illia Ragozin" <illia.ragozin@grapecom.com>
Date: Mon, 22 Apr 2013 15:25:59 +0100
Message-ID: <lsq.1366640759.992301562@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [48/75] ARM: 7696/1: Fix kexec by setting outer_cache.inv_all for
 Feroceon
In-Reply-To: <lsq.1366640759.151900666@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.44-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/mm/cache-feroceon-l2.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/mm/cache-feroceon-l2.c
+++ b/arch/arm/mm/cache-feroceon-l2.c
@@ -342,6 +342,7 @@ void __init feroceon_l2_init(int __l2_wt
 	outer_cache.inv_range = feroceon_l2_inv_range;
 	outer_cache.clean_range = feroceon_l2_clean_range;
 	outer_cache.flush_range = feroceon_l2_flush_range;
+	outer_cache.inv_all = l2_inv_all;
 
 	enable_l2();
 

