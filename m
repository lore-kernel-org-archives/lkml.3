Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab3IKI7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 04:59:18 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:37904 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab3IKI7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 04:59:15 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-40-523030e19d22
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Bob Liu <bob.liu@oracle.com>, Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dave Hansen <dave.hansen@intel.com>, Minchan Kim <minchan@kernel.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 0/5] mm: migrate zbud pages
Date: Wed, 11 Sep 2013 10:58:59 +0200
Message-id: <1378889944-23192-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgluLIzCtJLcpLzFFi42I5/e/4Vd2HBgZBBg3zjS3mrF/DZrFxxnpW
	i65TU1ksPr18wGjx+oWhxdmmN+wWl3fNYbO4t+Y/q8XaI3fZLSa/e8Zosezre3aLQ/tWsTvw
	eCze85LJY9OqTjaPTZ8msXucmPGbxePBoc0sHh+f3mLx6NuyitFj8+lqj8+b5AI4o7hsUlJz
	MstSi/TtErgy/jU1sxRslqq4vm8qewPjTNEuRg4OCQETidOr7LoYOYFMMYkL99azdTFycQgJ
	LGWU2PLrPguE08ck8XTebRaQKjYBY4nNy5ewgdgiAn2MEpMuW4AUMQucYZK4tuQ/O0hCWEBP
	4vu/LUwgNouAqsTkxz1gDbwC7hKfDu9jhtisIDFnks0ERu4FjAyrGEVTS5MLipPScw31ihNz
	i0vz0vWS83M3MUJC78sOxsXHrA4xCnAwKvHw3pDTDxJiTSwrrsw9xCjBwawkwvtK1CBIiDcl
	sbIqtSg/vqg0J7X4ECMTB6dUA+Ok+feKT11d8Ucq4NSLB1daA/sfmYt9MpddG5VzWu1QXnbz
	uYKPzTW3vk9V2TvBQM5+0t/GQ176LjOydv6tm6SW6ug66UuIfJr/1FdX+qU2MSwSM4pwF25c
	P6nLclNQQ/lN4Xmnq6ZpN5iaXF3sm6h31UHv7twnW9XO/pS6taI3zuLfl8tfNaSUWIozEg21
	mIuKEwGPLxGOGwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Currently zbud pages are not movable and they cannot be allocated from CMA
(Contiguous Memory Allocator) region. These patches add migration of zbud pages.

The zbud migration code utilizes mapping so many exceptions to migrate
code were added. This can be replaced for example with pin page
control subsystem:
http://article.gmane.org/gmane.linux.kernel.mm/105308
In such case the zbud migration code (zbud_migrate_page()) can be safely
re-used.


Patch "[PATCH 3/5] mm: use mapcount for identifying zbud pages" introduces
PageZbud() function which identifies zbud pages by page->_mapcount.
Dave Hansen proposed aliasing PG_zbud=PG_slab but in such case patch
would be more intrusive.

Any ideas for a better solution are welcome.


Patch "[PATCH 4/5] mm: use indirect zbud handle and radix tree" changes zbud
handle to support migration. Now the handle is an index in radix tree and
zbud_map() maps it to a proper virtual address. This exposes race conditions,
some of them are discussed already here:
http://article.gmane.org/gmane.linux.kernel.mm/105988

Races are fixed by adding internal map count for each zbud handle.
The map count is increased on each zbud_map() call.

Some races between writeback and invalidate still exist. In such case a message
can be seen in logs:
  zbud: error: could not lookup handle 13810 in tree
Patches from discussion above may resolve this.

I have considered using "pgoff_t offset" as handle but it prevented storing
duplicate pages in zswap.


This patch set is based on v3.11.


Changes since v1:
-----------------
1. Rebased against v3.11.
2. Updated documentation of zbud_reclaim_page() to match usage of zbud page
   reference counters.
3. Split from patch 2/4 trivial change of scope of freechunks var to separate
   patch (3/5) (suggested by Seth Jennings).


Changes and relation to patches "reclaiming zbud pages on migration and
compaction":
-----------------
This is continuation of my previous work: reclaiming zbud pages on migration
and compaction. However current solution is completely different so I am not
attaching previous changelog.
Previous patches can be found here:
 * [RFC PATCH v2 0/4] mm: reclaim zbud pages on migration and compaction
   http://article.gmane.org/gmane.linux.kernel.mm/105153
 * [RFC PATCH 0/4] mm: reclaim zbud pages on migration and compaction
   http://article.gmane.org/gmane.linux.kernel.mm/104801

One patch from previous work is re-used along with minor changes:
"[PATCH 1/4] zbud: use page ref counter for zbud pages"
 * Add missing spin_unlock in zbud_reclaim_page().
 * Decrease pool->pages_nr in zbud_free(), not when putting page. This also
removes the need of holding lock while call to put_zbud_page().


Best regards,
Krzysztof Kozlowski


Krzysztof Kozlowski (5):
  zbud: use page ref counter for zbud pages
  zbud: make freechunks a block local variable
  mm: use mapcount for identifying zbud pages
  mm: use indirect zbud handle and radix tree
  mm: migrate zbud pages

 include/linux/mm.h   |   23 ++
 include/linux/zbud.h |    3 +-
 mm/compaction.c      |    7 +
 mm/migrate.c         |   17 +-
 mm/zbud.c            |  573 ++++++++++++++++++++++++++++++++++++++++----------
 mm/zswap.c           |   28 ++-
 6 files changed, 537 insertions(+), 114 deletions(-)

-- 
1.7.9.5

