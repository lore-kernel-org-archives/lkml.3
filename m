Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbaAZDMn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 22:12:43 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:40745 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbaAZDMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 22:12:42 -0500
Date: Sat, 25 Jan 2014 19:12:35 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
cc: Mel Gorman <mgorman@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch for-3.14] mm, mempolicy: fix mempolicy printing in
 numa_maps
Message-ID: <alpine.DEB.2.02.1401251902180.3140@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a result of commit 5606e3877ad8 ("mm: numa: Migrate on reference 
policy"), /proc/<pid>/numa_maps prints the mempolicy for any <pid> as 
"prefer:N" for the local node, N, of the process reading the file.

This should only be printed when the mempolicy of <pid> is MPOL_PREFERRED 
for node N.

If the process is actually only using the default mempolicy for local node 
allocation, make sure "default" is printed as expected.

Reported-by: Robert Lippert <rlippert@google.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 This affects all 3.7+ kernels and is intended for stable but will need to
 be rebased after it's merged since mpol_to_str() has subsequently
 changed.  I'll rebase and propose it separately.

 mm/mempolicy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2926,7 +2926,7 @@ void mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol)
 	unsigned short mode = MPOL_DEFAULT;
 	unsigned short flags = 0;
 
-	if (pol && pol != &default_policy) {
+	if (pol && pol != &default_policy && !(pol->flags & MPOL_F_MORON)) {
 		mode = pol->mode;
 		flags = pol->flags;
 	}
