Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825Ab3LKQ6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 11:58:24 -0500
Received: from smtp.citrix.com ([66.165.176.89]:17047 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996Ab3LKQ6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 11:58:22 -0500
X-IronPort-AV: E=Sophos;i="4.93,872,1378857600"; 
   d="scan'208";a="83302514"
Message-ID: <52A899AB.3010506@citrix.com>
Date: Wed, 11 Dec 2013 16:58:19 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        <linux-acpi@vger.kernel.org>,
        xen-devel <xen-devel@lists.xenproject.org>,
        Dietmar Hahn <dietmar.hahn@ts.fujitsu.com>
Subject: vunmap() on large regions may trigger soft lockup warnings
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Dietmar Hahn reported an issue where calling vunmap() on a large (50 GB)
region would trigger soft lockup warnings.

The following patch would resolve this (by adding a cond_resched() call
to vunmap_pmd_range()). Almost calls of vunmap(), unmap_kernel_range()
are from process context (as far as I could tell) except for an ACPI
driver (drivers/acpi/apei/ghes.c) calls unmap_kernel_range_noflush()
from an interrupt and NMI contexts.

Can you advise on a preferred solution?

For example, an unmap_kernel_page() function (callable from atomic
context) could be provided since the GHES driver only maps/unmaps a
single page.

8<-------------------------
mm/vmalloc: avoid soft lockup warnings when vunmap()'ing large ranges

From: David Vrabel <david.vrabel@citrix.com>

If vunmap() is used to unmap a large (e.g., 50 GB) region, it may take
sufficiently long that it triggers soft lockup warnings.

Add a cond_resched() into vunmap_pmd_range() so the calling task may
be resheduled after unmapping each PMD entry.  This is how
zap_pmd_range() fixes the same problem for userspace mappings.

Reported-by: Dietmar Hahn <dietmar.hahn@ts.fujitsu.com>
Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
 mm/vmalloc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 0fdf968..b1b5b39 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -75,6 +75,7 @@ static void vunmap_pmd_range(pud_t *pud, unsigned long
addr, unsigned long end)
 		if (pmd_none_or_clear_bad(pmd))
 			continue;
 		vunmap_pte_range(pmd, addr, next);
+		cond_resched();
 	} while (pmd++, addr = next, addr != end);
 }

-- 
1.7.2.5
