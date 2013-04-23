Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232Ab3DWVy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 17:54:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34242 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757734Ab3DWVyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:54:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Illia Ragozin <illia.ragozin@grapecom.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 12/26] ARM: 7696/1: Fix kexec by setting outer_cache.inv_all for Feroceon
Date: Tue, 23 Apr 2013 14:53:52 -0700
Message-Id: <20130423215334.633950133@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130423215333.344045754@linuxfoundation.org>
References: <20130423215333.344045754@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mm/cache-feroceon-l2.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/mm/cache-feroceon-l2.c
+++ b/arch/arm/mm/cache-feroceon-l2.c
@@ -343,6 +343,7 @@ void __init feroceon_l2_init(int __l2_wt
 	outer_cache.inv_range = feroceon_l2_inv_range;
 	outer_cache.clean_range = feroceon_l2_clean_range;
 	outer_cache.flush_range = feroceon_l2_flush_range;
+	outer_cache.inv_all = l2_inv_all;
 
 	enable_l2();
 


