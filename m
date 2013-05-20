Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419Ab3ETQ0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 12:26:41 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:58956 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755910Ab3ETQ0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 12:26:35 -0400
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Hansen <dave@sr71.net>, Joe Perches <joe@perches.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Hugh Dickens <hughd@google.com>, Paul Mackerras <paulus@samba.org>,
        Heesub Shin <heesub.shin@samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCHv12 4/4] zswap: add documentation
Date: Mon, 20 May 2013 11:26:08 -0500
Message-Id: <1369067168-12291-5-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <1369067168-12291-1-git-send-email-sjenning@linux.vnet.ibm.com>
References: <1369067168-12291-1-git-send-email-sjenning@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052016-5806-0000-0000-00002139F0CF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the documentation file for the zswap functionality

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
Acked-by: Rik van Riel <riel@redhat.com>
---
 Documentation/vm/zswap.txt | 68 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)
 create mode 100644 Documentation/vm/zswap.txt

diff --git a/Documentation/vm/zswap.txt b/Documentation/vm/zswap.txt
new file mode 100644
index 0000000..7e492d8
--- /dev/null
+++ b/Documentation/vm/zswap.txt
@@ -0,0 +1,68 @@
+Overview:
+
+Zswap is a lightweight compressed cache for swap pages. It takes pages that are
+in the process of being swapped out and attempts to compress them into a
+dynamically allocated RAM-based memory pool.  zswap basically trades CPU cycles
+for potentially reduced swap I/O.  This trade-off can also result in a
+significant performance improvement if reads from the compressed cache are
+faster than reads from a swap device.
+
+NOTE: Zswap is a new feature as of v3.11 and interacts heavily with memory
+reclaim.  This interaction has not be fully explored on the large set of
+potential configurations and workloads that exist.  For this reason, zswap
+is a work in progress and should be considered experimental.
+
+Some potential benefits:
+* Desktop/laptop users with limited RAM capacities can mitigate the
+    performance impact of swapping.
+* Overcommitted guests that share a common I/O resource can
+    dramatically reduce their swap I/O pressure, avoiding heavy handed I/O
+    throttling by the hypervisor. This allows more work to get done with less
+    impact to the guest workload and guests sharing the I/O subsystem
+* Users with SSDs as swap devices can extend the life of the device by
+    drastically reducing life-shortening writes.
+
+Zswap evicts pages from compressed cache on an LRU basis to the backing swap
+device when the compressed pool reaches it size limit.  This requirement had
+been identified in prior community discussions.
+
+To enabled zswap, the "enabled" attribute must be set to 1 at boot time.  e.g.
+zswap.enabled=1
+
+Design:
+
+Zswap receives pages for compression through the Frontswap API and is able to
+evict pages from its own compressed pool on an LRU basis and write them back to
+the backing swap device in the case that the compressed pool is full.
+
+Zswap makes use of zbud for the managing the compressed memory pool.  Each
+allocation in zbud is not directly accessible by address.  Rather, a handle is
+return by the allocation routine and that handle must be mapped before being
+accessed.  The compressed memory pool grows on demand and shrinks as compressed
+pages are freed.  The pool is not preallocated.
+
+When a swap page is passed from frontswap to zswap, zswap maintains a mapping
+of the swap entry, a combination of the swap type and swap offset, to the zbud
+handle that references that compressed swap page.  This mapping is achieved
+with a red-black tree per swap type.  The swap offset is the search key for the
+tree nodes.
+
+During a page fault on a PTE that is a swap entry, frontswap calls the zswap
+load function to decompress the page into the page allocated by the page fault
+handler.
+
+Once there are no PTEs referencing a swap page stored in zswap (i.e. the count
+in the swap_map goes to 0) the swap code calls the zswap invalidate function,
+via frontswap, to free the compressed entry.
+
+Zswap seeks to be simple in its policies.  Sysfs attributes allow for one user
+controlled policies:
+* max_pool_percent - The maximum percentage of memory that the compressed
+    pool can occupy.
+
+Zswap allows the compressor to be selected at kernel boot time by setting the
+“compressor” attribute.  The default compressor is lzo.  e.g.
+zswap.compressor=deflate
+
+A debugfs interface is provided for various statistic about pool size, number
+of pages stored, and various counters for the reasons pages are rejected.
-- 
1.8.2.3

