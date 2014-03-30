Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbaCaAab (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:30:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36255 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752883AbaC3XY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:24:59 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Li Zefan" <lizefan@huawei.com>,
        "Wanpeng Li" <liwanp@linux.vnet.ibm.com>,
        "Pekka Enberg" <penberg@kernel.org>,
        "Christoph Lameter" <cl@linux.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.223795276@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 014/200] slub: Fix calculation of cpu slabs
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zefan <lizefan@huawei.com>

commit 8afb1474db4701d1ab80cd8251137a3260e6913e upstream.

  /sys/kernel/slab/:t-0000048 # cat cpu_slabs
  231 N0=16 N1=215
  /sys/kernel/slab/:t-0000048 # cat slabs
  145 N0=36 N1=109

See, the number of slabs is smaller than that of cpu slabs.

The bug was introduced by commit 49e2258586b423684f03c278149ab46d8f8b6700
("slub: per cpu cache for partial pages").

We should use page->pages instead of page->pobjects when calculating
the number of cpu partial slabs. This also fixes the mapping of slabs
and nodes.

As there's no variable storing the number of total/active objects in
cpu partial slabs, and we don't have user interfaces requiring those
statistics, I just add WARN_ON for those cases.

Acked-by: Christoph Lameter <cl@linux.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/slub.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4483,7 +4483,13 @@ static ssize_t show_slab_objects(struct
 			page = c->partial;
 
 			if (page) {
-				x = page->pobjects;
+				node = page_to_nid(page);
+				if (flags & SO_TOTAL)
+					WARN_ON_ONCE(1);
+				else if (flags & SO_OBJECTS)
+					WARN_ON_ONCE(1);
+				else
+					x = page->pages;
 				total += x;
 				nodes[node] += x;
 			}

