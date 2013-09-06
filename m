Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357Ab3IFSI5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 14:08:57 -0400
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:45658 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab3IFSIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 14:08:55 -0400
From: Linn Crosetto <linn@hp.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        luto@amacapital.net, daniel.vetter@ffwll.ch, airlied@redhat.com,
        yinghai@kernel.org, jacob.shin@amd.com, penberg@kernel.org,
        js1304@gmail.com, akpm@linux-foundation.org, matt.fleming@intel.com
Cc: linux-kernel@vger.kernel.org, Linn Crosetto <linn@hp.com>
Subject: [PATCH 3/3] x86: fix early_iounmap() sparse warnings in setup.c
Date: Fri,  6 Sep 2013 12:06:57 -0600
Message-Id: <1378490817-23272-4-git-send-email-linn@hp.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1378490817-23272-1-git-send-email-linn@hp.com>
References: <5223CA9C.5020505@zytor.com>
 <1378490817-23272-1-git-send-email-linn@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace calls to early_iounmap() with early_memunmap() for pointers
mapped with early_memremap() to eliminate the following sparse warnings:

arch/x86/kernel/setup.c:355:31: warning: incorrect type in argument 1 (different address spaces)
arch/x86/kernel/setup.c:441:31: warning: incorrect type in argument 1 (different address spaces)
arch/x86/kernel/setup.c:470:31: warning: incorrect type in argument 1 (different address spaces)
arch/x86/kernel/setup.c:491:31: warning: incorrect type in argument 1 (different address spaces)

Signed-off-by: Linn Crosetto <linn@hp.com>
---
 arch/x86/kernel/setup.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f0de629..3081fc6 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -352,7 +352,7 @@ static void __init relocate_initrd(void)
 		mapaddr = ramdisk_image & PAGE_MASK;
 		p = early_memremap(mapaddr, clen+slop);
 		memcpy(q, p+slop, clen);
-		early_iounmap(p, clen+slop);
+		early_memunmap(p, clen+slop);
 		q += clen;
 		ramdisk_image += clen;
 		ramdisk_size  -= clen;
@@ -438,7 +438,7 @@ static void __init parse_setup_data(void)
 		data_len = data->len + sizeof(struct setup_data);
 		data_type = data->type;
 		pa_next = data->next;
-		early_iounmap(data, map_len);
+		early_memunmap(data, map_len);
 
 		switch (data_type) {
 		case SETUP_E820_EXT:
@@ -467,7 +467,7 @@ static void __init e820_reserve_setup_data(void)
 			 E820_RAM, E820_RESERVED_KERN);
 		found = 1;
 		pa_data = data->next;
-		early_iounmap(data, sizeof(*data));
+		early_memunmap(data, sizeof(*data));
 	}
 	if (!found)
 		return;
@@ -488,7 +488,7 @@ static void __init memblock_x86_reserve_range_setup_data(void)
 		data = early_memremap(pa_data, sizeof(*data));
 		memblock_reserve(pa_data, sizeof(*data) + data->len);
 		pa_data = data->next;
-		early_iounmap(data, sizeof(*data));
+		early_memunmap(data, sizeof(*data));
 	}
 }
 
-- 
1.7.11.3

