Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab3JHN36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:29:58 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:55753 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab3JHN35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:29:57 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-cd-525408d37cc1
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Bob Liu <bob.liu@oracle.com>, Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dave Hansen <dave.hansen@intel.com>, Minchan Kim <minchan@kernel.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v3 0/6] mm: migrate zbud pages
Date: Tue, 08 Oct 2013 15:29:34 +0200
Message-id: <1381238980-2491-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42I5/e/4Nd3LHCFBBr2nRCzmrF/DZrFxxnpW
	i65TU1ksPr18wGjx+oWhxdmmN+wWl3fNYbO4t+Y/q8XaI3fZLSa/e8Zosezre3aLQ/tWsVvM
	a3/J6sDrsXjPSyaPTas62Tw2fZrE7nFixm8WjweHNrN4fHx6i8Wjb8sqRo/Np6s9Pm+SC+CM
	4rJJSc3JLEst0rdL4Mq482QbW8F98YoX/w8zNTB+EOpi5OSQEDCR+Hn9BxOELSZx4d56ti5G
	Lg4hgaWMEm/OfGWCcPqYJL4dbAerYhMwlti8fAkbiC0i0McoMemyBUgRs8A/JokJOy6DFQkL
	6Em8XvUFrIhFQFViQd8zRhCbV8BNYsK0F0BxDqB1ChJzJtlMYORewMiwilE0tTS5oDgpPddQ
	rzgxt7g0L10vOT93EyMkDL/sYFx8zOoQowAHoxIPr8DhoCAh1sSy4srcQ4wSHMxKIrx8/4OD
	hHhTEiurUovy44tKc1KLDzEycXBKNTAWsDB9/Ms2WZE32H3uMf9TX+32yG2+2xbM0XX3wJdo
	n2sdzrvnc+numboudW1GhHJNbneH0tt1oadmOy/zZOc/sSqb95uufUVybDXHreBVfwo+Zhp2
	+nl09on7rZ956NuM7zynDwcu+r+39NfKU17OB3Q6/TiCGjp+cS/xqdAN/FqklsVjm6DEUpyR
	aKjFXFScCADpHjzxIQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is third version of patches adding migration of zbud pages with changes
after discussions with Seth:
http://article.gmane.org/gmane.linux.kernel.mm/107695

In patch [PATCH 5/6] I removed the red-black tree in zswap and instead added
a radix tree in zbud. This also lead to removal of the "handle" concept and
to usage of offset as radix tree's index.

This particular change (5/6) still needs some improvements:
1. Accept storing of duplicated pages (as it was in original zswap).
2. Use RCU for radix tree reads and updates.
3. Optimize locking in zbud_free_all().
4. Iterate over LRU list instead of radix tree in zbud_free_all().


Description of patches:
-----------------
Currently zbud pages are not movable and they cannot be allocated from CMA
(Contiguous Memory Allocator) region. These patches add migration of zbud pages.

The zbud migration code utilizes mapping so many exceptions to migrate
code were added. This can be replaced for example with pin page
control subsystem:
http://article.gmane.org/gmane.linux.kernel.mm/105308
In such case the zbud migration code (zbud_migrate_page()) can be safely
re-used.

 * [PATCH 1/6] adds a reference counter to zbud pages.
 * [PATCH 2/6] is a trivial change of scope of local variable.
 * [PATCH 3/6] introduces PageZbud() function which identifies zbud pages by
   page->_mapcount. Dave Hansen proposed aliasing PG_zbud=PG_slab but in such
   case patch would be more intrusive.
   Any ideas for a better solution are welcome.
 * [PATCH 4/6] replaces direct initialization of zbud_header with memset.
 * [PATCH 5/6] replaces zswap's red-black tree with a new radix tree in zbud.
   Offset is used as index to this tree.
 * [PATCH 6/6] implements migration of zbud pages.


This patch set is based on v3.12-rc4-19-g8b5ede6.


Changes since v2:
-----------------
1. Rebased against v3.12-rc4-19-g8b5ede6.
2. Replace zswap's red-black tree with a new radix tree in zbud. Use
   offset as tree's index. Many zbud API changes.
3. Add patch 4/6.

Changes since v1:
-----------------
1. Rebased against v3.11.
2. Updated documentation of zbud_reclaim_page() to match usage of zbud page
   reference counters.
3. Split from patch 2/4 trivial change of scope of freechunks var to separate
   patch (3/5) (suggested by Seth Jennings).


Best regards,
Krzysztof Kozlowski


Krzysztof Kozlowski (6):
  zbud: use page ref counter for zbud pages
  zbud: make freechunks a block local variable
  mm: use mapcount for identifying zbud pages
  zbud: memset zbud_header to 0 during init
  zswap: replace tree in zswap with radix tree in zbud
  mm: migrate zbud pages

 include/linux/mm.h   |   23 ++
 include/linux/zbud.h |   28 ++-
 mm/compaction.c      |    7 +
 mm/migrate.c         |   17 +-
 mm/zbud.c            |  644 +++++++++++++++++++++++++++++++++++++++-----------
 mm/zswap.c           |  419 ++++++--------------------------
 6 files changed, 643 insertions(+), 495 deletions(-)

-- 
1.7.9.5

