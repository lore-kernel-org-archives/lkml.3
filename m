Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759743Ab3EGEcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:32:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27877 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932592Ab3EGEZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:54 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=RdLuJAapXcEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=v6ICz8kHwl4A:10 a=KcYuL2koAAAA:8 a=VwQbUJbxAAAA:8 a=0e1NNH2jAAAA:8 a=drOt6m5kAAAA:8 a=q5ThxW_8AAAA:8 a=9V02YcW-AAAA:8 a=XBlwJMhfCmAz5__TAC4A:9 a=iODT8GO6d3wA:10 a=P3EuRnbGbpEA:10 a=hAwTiGD2l9QA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035853.454551269@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Illia Ragozin <illia.ragozin@grapecom.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [075/126] ARM: 7696/1: Fix kexec by setting outer_cache.inv_all for Feroceon
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0075-ARM-7696-1-Fix-kexec-by-setting-outer_cache.inv_all-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Illia Ragozin <illia.ragozin@grapecom.com>

[ Upstream commit cd272d1ea71583170e95dde02c76166c7f9017e6 ]

On Feroceon the L2 cache becomes non-coherent with the CPU
when the L1 caches are disabled. Thus the L2 needs to be invalidated
after both L1 caches are disabled.

On kexec before the starting the code for relocation the kernel,
the L1 caches are disabled in cpu_froc_fin (cpu_v7_proc_fin for Feroceon),
but after L2 cache is never invalidated, because inv_all is not set
in cache-feroceon-l2.c.
So kernel relocation and decompression may has (and usually has) errors.
Setting the function enables L2 invalidation and fixes the issue.

Cc: <stable@vger.kernel.org>
Signed-off-by: Illia Ragozin <illia.ragozin@grapecom.com>
Acked-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/mm/cache-feroceon-l2.c |    1 +
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
1.7.10.4


