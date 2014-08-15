Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490AbaHOUPj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 16:15:39 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:59965 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaHOUPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 16:15:38 -0400
Date: Fri, 15 Aug 2014 16:15:34 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH percpu/for-3.17-fixes 2/2] percpu: perform tlb flush after
 pcpu_map_pages() failure
Message-ID: <20140815201534.GB24716@mtj.dyndns.org>
References: <20140815201438.GA24716@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140815201438.GA24716@mtj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This one is most likely harmless but best to be safe.  Applied to
percpu/for-3.17-fixes.

Thanks.
------ 8< ------
>From 849f5169097e1ba35b90ac9df76b5bb6f9c0aabd Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Fri, 15 Aug 2014 16:06:10 -0400

If pcpu_map_pages() fails midway, it unmaps the already mapped pages.
Currently, it doesn't flush tlb after the partial unmapping.  This may
be okay in most cases as the established mapping hasn't been used at
that point but it can go wrong and when it goes wrong it'd be
extremely difficult to track down.

Flush tlb after the partial unmapping.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: stable@vger.kernel.org
---
 mm/percpu-vm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
index 8d9bb2c..5110816 100644
--- a/mm/percpu-vm.c
+++ b/mm/percpu-vm.c
@@ -272,6 +272,7 @@ err:
 		__pcpu_unmap_pages(pcpu_chunk_addr(chunk, tcpu, page_start),
 				   page_end - page_start);
 	}
+	pcpu_post_unmap_tlb_flush(chunk, page_start, page_end);
 	return err;
 }
 
-- 
1.9.3

