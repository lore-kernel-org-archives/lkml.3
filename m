Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab3F0PRz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 11:17:55 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:40031 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893Ab3F0PRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 11:17:54 -0400
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>, Michal Hocko <mhocko@suse.cz>,
        Fengguang Wu <fengguang.wu@intel.com>, Bob Liu <lliubbo@gmail.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [RESEND][PATCH] zswap: fix Kconfig to depend on CRYPTO=y
Date: Thu, 27 Jun 2013 10:17:43 -0500
Message-Id: <1372346263-6005-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062715-7182-0000-0000-0000078CD682
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig entry for zswap currently allows CRYPTO=m to satisfy the
zswap dependency.  However zswap is boolean (i.e. built-in) and has
symbol dependencies on CRYPTO.  Additionally, because the CRYPTO dependency
is satisfied with =m, the additional selects zswap does can also
be satisfied with =m, which leads to additional linking errors.

>From the report:
=====
tree:   git://git.kernel.org/pub/scm/linux/kernel/git/mhocko/mm.git since-3.9
head:   57cefddb141d6c9d0ab4f5a8589dd017f796a3f7
commit: 563f51c95b552e0d663df5bdf6cfc8e8a72d3ec6 [494/499] zswap: add to mm/
config: x86_64-randconfig-x004-0619 (attached as .config)

All error/warnings:

   mm/built-in.o: In function `zswap_frontswap_invalidate_area':
>> zswap.c:(.text+0x3a705): undefined reference to `zbud_free'
   mm/built-in.o: In function `zswap_free_entry':
>> zswap.c:(.text+0x3a76b): undefined reference to `zbud_free'
>> zswap.c:(.text+0x3a789): undefined reference to `zbud_get_pool_size'
on and on...
=====

This patch makes CRYPTO a built-in dependency of ZSWAP.  This has the
side effect of also making the selects built-in.

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
---

Andrew, please merge this into your mmotm ASAP as it fixes a demonstrable
build break.

 mm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index 949e8de..81763ae 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -490,7 +490,7 @@ config ZBUD
 
 config ZSWAP
 	bool "Compressed cache for swap pages (EXPERIMENTAL)"
-	depends on FRONTSWAP && CRYPTO
+	depends on FRONTSWAP && CRYPTO=y
 	select CRYPTO_LZO
 	select ZBUD
 	default n
-- 
1.8.3.1

