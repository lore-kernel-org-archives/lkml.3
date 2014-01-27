Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbaA0LEA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 06:04:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34559 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbaA0LDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 06:03:35 -0500
Date: Mon, 27 Jan 2014 11:03:30 +0000
From: Mel Gorman <mgorman@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch for-3.14] mm, mempolicy: fix mempolicy printing in
 numa_maps
Message-ID: <20140127110330.GH4963@suse.de>
References: <alpine.DEB.2.02.1401251902180.3140@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401251902180.3140@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 25, 2014 at 07:12:35PM -0800, David Rientjes wrote:
> As a result of commit 5606e3877ad8 ("mm: numa: Migrate on reference 
> policy"), /proc/<pid>/numa_maps prints the mempolicy for any <pid> as 
> "prefer:N" for the local node, N, of the process reading the file.
> 
> This should only be printed when the mempolicy of <pid> is MPOL_PREFERRED 
> for node N.
> 
> If the process is actually only using the default mempolicy for local node 
> allocation, make sure "default" is printed as expected.
> 
> Reported-by: Robert Lippert <rlippert@google.com>
> Signed-off-by: David Rientjes <rientjes@google.com>

Hmm, it is using a preferred policy but I see your point as expectations
of an application parsing numa_maps have been broken.  The patch makes
non-obvious assumptions about how and when MPOL_F_MORON gets set which
could change in the future and be missed. Use this instead? It might need
to be changed again if there is a need to control whether automatic numa
balancing can be enabled or disabled on a per-process basis.

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index c2ccec0..c1a2573 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -120,6 +120,14 @@ static struct mempolicy default_policy = {
 
 static struct mempolicy preferred_node_policy[MAX_NUMNODES];
 
+/* Returns true if the policy is the default policy */
+static bool mpol_is_default(struct mempolicy *pol)
+{
+	return !pol ||
+		pol == &default_policy ||
+		pol == &preferred_node_policy[numa_node_id()];
+}
+
 static struct mempolicy *get_task_policy(struct task_struct *p)
 {
 	struct mempolicy *pol = p->mempolicy;
@@ -2856,7 +2864,7 @@ void mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol)
 	unsigned short mode = MPOL_DEFAULT;
 	unsigned short flags = 0;
 
-	if (pol && pol != &default_policy) {
+	if (!mpol_is_default(pol)) {
 		mode = pol->mode;
 		flags = pol->flags;
 	}
