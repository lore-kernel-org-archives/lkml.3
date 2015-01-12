Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429AbbALTAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:00:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58042 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934AbbALS3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:29:55 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Arnd Bergmann <arnd@arndb.de>, Anton Vorontsov <cbouatmailru@gmail.com>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Rob Herring <rob.herring@calxeda.com>,
        Tony Lindgren <tony@atomide.com>, Tony Luck <tony.luck@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 125/216] pstore-ram: Fix hangs by using write-combine mappings
Date: Mon, 12 Jan 2015 18:28:23 +0000
Message-Id: <1421087394-2712-13-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring <robherring2@gmail.com>

commit 7ae9cb81933515dc7db1aa3c47ef7653717e3090 upstream.

Currently trying to use pstore on at least ARMs can hang as we're
mapping the peristent RAM with pgprot_noncached().

On ARMs, pgprot_noncached() will actually make the memory strongly
ordered, and as the atomic operations pstore uses are implementation
defined for strongly ordered memory, they may not work. So basically
atomic operations have undefined behavior on ARM for device or strongly
ordered memory types.

Let's fix the issue by using write-combine variants for mappings. This
corresponds to normal, non-cacheable memory on ARM. For many other
architectures, this change does not change the mapping type as by
default we have:

#define pgprot_writecombine pgprot_noncached

The reason why pgprot_noncached() was originaly used for pstore
is because Colin Cross <ccross@android.com> had observed lost
debug prints right before a device hanging write operation on some
systems. For the platforms supporting pgprot_noncached(), we can
add a an optional configuration option to support that. But let's
get pstore working first before adding new features.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Colin Cross <ccross@android.com>
Cc: Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Rob Herring <rob.herring@calxeda.com>
[tony@atomide.com: updated description]
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/pstore/ram_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index 34a1e5aa848c..d55fef2e21ed 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -392,7 +392,7 @@ static void *persistent_ram_vmap(phys_addr_t start, size_t size)
 	page_start = start - offset_in_page(start);
 	page_count = DIV_ROUND_UP(size + offset_in_page(start), PAGE_SIZE);
 
-	prot = pgprot_noncached(PAGE_KERNEL);
+	prot = pgprot_writecombine(PAGE_KERNEL);
 
 	pages = kmalloc(sizeof(struct page *) * page_count, GFP_KERNEL);
 	if (!pages) {
@@ -422,7 +422,7 @@ static void *persistent_ram_iomap(phys_addr_t start, size_t size)
 	buffer_start_add = buffer_start_add_locked;
 	buffer_size_add = buffer_size_add_locked;
 
-	return ioremap(start, size);
+	return ioremap_wc(start, size);
 }
 
 static int persistent_ram_buffer_map(phys_addr_t start, phys_addr_t size,
-- 
2.1.4

