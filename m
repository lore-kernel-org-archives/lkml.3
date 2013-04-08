Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964900Ab3DHKA2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:00:28 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:14677 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S964886Ab3DHKAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 06:00:24 -0400
X-IronPort-AV: E=Sophos;i="4.87,431,1363104000"; 
   d="scan'208";a="7014992"
From: Lin Feng <linfeng@cn.fujitsu.com>
To: akpm@linux-foundation.org
Cc: cl@linux.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        yinghai@kernel.org, catalin.marinas@arm.com, will.deacon@arm.com,
        arnd@arndb.de, tony@atomide.com, ben@decadent.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-mm@kvack.org, isimatu.yasuaki@jp.fujitsu.com,
        Lin Feng <linfeng@cn.fujitsu.com>
Subject: [PATCH 1/2] mm: vmemmap: x86: add vmemmap_verify check for hot-add node case
Date: Mon, 8 Apr 2013 17:56:39 +0800
Message-Id: <1365415000-10389-2-git-send-email-linfeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1365415000-10389-1-git-send-email-linfeng@cn.fujitsu.com>
References: <1365415000-10389-1-git-send-email-linfeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/08 17:53:53,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/08 17:54:15,
	Serialize complete at 2013/04/08 17:54:15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In hot add node(memory) case, vmemmap pages are always allocated from other
node, but the current logic just skip vmemmap_verify check.
So we should also issue "potential offnode page_structs" warning messages
if we are the case.

Cc: Christoph Lameter <cl@linux.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>
---
 arch/x86/mm/init_64.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 474e28f..e2a7277 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1318,6 +1318,8 @@ vmemmap_populate(struct page *start_page, unsigned long size, int node)
 			if (!p)
 				return -ENOMEM;
 
+			vmemmap_verify((pte_t *)p, node, addr, addr + PAGE_SIZE);
+
 			addr_end = addr + PAGE_SIZE;
 			p_end = p + PAGE_SIZE;
 		} else {
@@ -1347,8 +1349,8 @@ vmemmap_populate(struct page *start_page, unsigned long size, int node)
 
 				addr_end = addr + PMD_SIZE;
 				p_end = p + PMD_SIZE;
-			} else
-				vmemmap_verify((pte_t *)pmd, node, addr, next);
+			}
+			vmemmap_verify((pte_t *)pmd, node, addr, next);
 		}
 
 	}
-- 
1.8.0.1

