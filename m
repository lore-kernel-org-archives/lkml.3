Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933136Ab3CYUDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 16:03:31 -0400
Received: from carbon.coolservecorp.net ([184.82.167.18]:55849 "EHLO
	carbon.coolservecorp.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932801Ab3CYUDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 16:03:30 -0400
X-Greylist: delayed 1102 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Mar 2013 16:03:30 EDT
Message-ID: <5150A8FF.7010301@grapecom.com>
Date: Mon, 25 Mar 2013 21:43:59 +0200
From: Elijah Ragozin <illia.ragozin@grapecom.com>
Organization: Grapecom
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Russell King <linux@arm.linux.org.uk>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/1] ARM Feroceon: fix kexec by setting outer_cache.inv_all
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - carbon.coolservecorp.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - grapecom.com
X-Get-Message-Sender-Via: carbon.coolservecorp.net: authenticated_id: illia.ragozin+grapecom.com/only user confirmed/virtual account not confirmed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
  arch/arm/mm/cache-feroceon-l2.c | 1 +
  1 file changed, 1 insertion(+)

diff --git a/arch/arm/mm/cache-feroceon-l2.c 
b/arch/arm/mm/cache-feroceon-l2.c
index e0b0e7a..09f8851 100644
--- a/arch/arm/mm/cache-feroceon-l2.c
+++ b/arch/arm/mm/cache-feroceon-l2.c
@@ -342,6 +342,7 @@ void __init feroceon_l2_init(int __l2_wt_override)
      outer_cache.inv_range = feroceon_l2_inv_range;
      outer_cache.clean_range = feroceon_l2_clean_range;
      outer_cache.flush_range = feroceon_l2_flush_range;
+    outer_cache.inv_all = l2_inv_all;

      enable_l2();

-- 
1.8.1.4


