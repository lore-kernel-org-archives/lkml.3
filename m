Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725AbaKAWja (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:39:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59989 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750786AbaKAWj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:26 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Tejun Heo" <tj@kernel.org>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.196823889@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 003/102] percpu: perform tlb flush after
 pcpu_map_pages() failure
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 849f5169097e1ba35b90ac9df76b5bb6f9c0aabd upstream.

If pcpu_map_pages() fails midway, it unmaps the already mapped pages.
Currently, it doesn't flush tlb after the partial unmapping.  This may
be okay in most cases as the established mapping hasn't been used at
that point but it can go wrong and when it goes wrong it'd be
extremely difficult to track down.

Flush tlb after the partial unmapping.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/percpu-vm.c | 1 +
 1 file changed, 1 insertion(+)

--- a/mm/percpu-vm.c
+++ b/mm/percpu-vm.c
@@ -273,6 +273,7 @@ err:
 		__pcpu_unmap_pages(pcpu_chunk_addr(chunk, tcpu, page_start),
 				   page_end - page_start);
 	}
+	pcpu_post_unmap_tlb_flush(chunk, page_start, page_end);
 	return err;
 }
 

