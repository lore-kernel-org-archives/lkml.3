Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932870AbaJGX2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:28:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39740 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932269AbaJGXUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:20:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 3.14 37/37] mm: dont pointlessly use BUG_ON() for sanity check
Date: Tue,  7 Oct 2014 16:19:54 -0700
Message-Id: <20141007231828.192941716@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141007231827.043235686@linuxfoundation.org>
References: <20141007231827.043235686@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 50f5aa8a9b248fa4262cf379863ec9a531b49737 upstream.

BUG_ON() is a big hammer, and should be used _only_ if there is some
major corruption that you cannot possibly recover from, making it
imperative that the current process (and possibly the whole machine) be
terminated with extreme prejudice.

The trivial sanity check in the vmacache code is *not* such a fatal
error.  Recovering from it is absolutely trivial, and using BUG_ON()
just makes it harder to debug for no actual advantage.

To make matters worse, the placement of the BUG_ON() (only if the range
check matched) actually makes it harder to hit the sanity check to begin
with, so _if_ there is a bug (and we just got a report from Srivatsa
Bhat that this can indeed trigger), it is harder to debug not just
because the machine is possibly dead, but because we don't have better
coverage.

BUG_ON() must *die*.  Maybe we should add a checkpatch warning for it,
because it is simply just about the worst thing you can ever do if you
hit some "this cannot happen" situation.

Reported-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/vmacache.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/vmacache.c
+++ b/mm/vmacache.c
@@ -81,10 +81,12 @@ struct vm_area_struct *vmacache_find(str
 	for (i = 0; i < VMACACHE_SIZE; i++) {
 		struct vm_area_struct *vma = current->vmacache[i];
 
-		if (vma && vma->vm_start <= addr && vma->vm_end > addr) {
-			BUG_ON(vma->vm_mm != mm);
+		if (!vma)
+			continue;
+		if (WARN_ON_ONCE(vma->vm_mm != mm))
+			break;
+		if (vma->vm_start <= addr && vma->vm_end > addr)
 			return vma;
-		}
 	}
 
 	return NULL;


