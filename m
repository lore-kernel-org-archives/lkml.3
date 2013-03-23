Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462Ab3CWP3y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 11:29:54 -0400
Received: from relay3.sgi.com ([192.48.152.1]:50501 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751151Ab3CWP3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 11:29:52 -0400
Date: Sat, 23 Mar 2013 10:29:48 -0500
From: Russ Anderson <rja@sgi.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
Subject: Re: [patch] mm: speedup in __early_pfn_to_nid
Message-ID: <20130323152948.GA3036@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20130318155619.GA18828@sgi.com>
 <20130321105516.GC18484@gmail.com>
 <alpine.DEB.2.02.1303211139110.3775@chino.kir.corp.google.com>
 <20130322072532.GC10608@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130322072532.GC10608@gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 08:25:32AM +0100, Ingo Molnar wrote:
> 
> * David Rientjes <rientjes@google.com> wrote:
> 
> > On Thu, 21 Mar 2013, Ingo Molnar wrote:
> > 
> > > > Index: linux/mm/page_alloc.c
> > > > ===================================================================
> > > > --- linux.orig/mm/page_alloc.c	2013-03-18 10:52:11.510988843 -0500
> > > > +++ linux/mm/page_alloc.c	2013-03-18 10:52:14.214931348 -0500
> > > > @@ -4161,10 +4161,19 @@ int __meminit __early_pfn_to_nid(unsigne
> > > >  {
> > > >  	unsigned long start_pfn, end_pfn;
> > > >  	int i, nid;
> > > > +	static unsigned long last_start_pfn, last_end_pfn;
> > > > +	static int last_nid;
> > > 
> > > Please move these globals out of function local scope, to make it more 
> > > apparent that they are not on-stack. I only noticed it in the second pass.
> > 
> > The way they're currently defined places these in meminit.data as 
> > appropriate; if they are moved out, please make sure to annotate their 
> > definitions with __meminitdata.
> 
> I'm fine with having them within the function as well in this special 
> case, as long as a heavy /* NOTE: ... */ warning is put before them - 
> which explains why these SMP-unsafe globals are safe.
> 
> ( That warning will also act as a visual delimiter that breaks the 
>   normally confusing and misleading 'globals mixed amongst stack 
>   variables' pattern. )

Thanks Ingo.  Here is an updated patch with heavy warning added.

As for the wrapper function, I was unable to find an obvious
way to add a wrapper without significanly changing both
versions of __early_pfn_to_nid().  It seems cleaner to add
the change in both versions.  I'm sure someone will point 
out if this conclusion is wrong.  :-)



------------------------------------------------------------
When booting on a large memory system, the kernel spends
considerable time in memmap_init_zone() setting up memory zones.
Analysis shows significant time spent in __early_pfn_to_nid().

The routine memmap_init_zone() checks each PFN to verify the
nid is valid.  __early_pfn_to_nid() sequentially scans the list of
pfn ranges to find the right range and returns the nid.  This does
not scale well.  On a 4 TB (single rack) system there are 308
memory ranges to scan.  The higher the PFN the more time spent
sequentially spinning through memory ranges.

Since memmap_init_zone() increments pfn, it will almost always be
looking for the same range as the previous pfn, so check that
range first.  If it is in the same range, return that nid.
If not, scan the list as before.

A 4 TB (single rack) UV1 system takes 512 seconds to get through
the zone code.  This performance optimization reduces the time
by 189 seconds, a 36% improvement.

A 2 TB (single rack) UV2 system goes from 212.7 seconds to 99.8 seconds,
a 112.9 second (53%) reduction.

Signed-off-by: Russ Anderson <rja@sgi.com>
---
 arch/ia64/mm/numa.c |   15 ++++++++++++++-
 mm/page_alloc.c     |   15 ++++++++++++++-
 2 files changed, 28 insertions(+), 2 deletions(-)

Index: linux/mm/page_alloc.c
===================================================================
--- linux.orig/mm/page_alloc.c	2013-03-19 16:09:03.736450861 -0500
+++ linux/mm/page_alloc.c	2013-03-22 17:07:43.895405617 -0500
@@ -4161,10 +4161,23 @@ int __meminit __early_pfn_to_nid(unsigne
 {
 	unsigned long start_pfn, end_pfn;
 	int i, nid;
+	/*
+	   NOTE: The following SMP-unsafe globals are only used early
+	   in boot when the kernel is running single-threaded.
+	 */
+	static unsigned long last_start_pfn, last_end_pfn;
+	static int last_nid;
+
+	if (last_start_pfn <= pfn && pfn < last_end_pfn)
+		return last_nid;
 
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid)
-		if (start_pfn <= pfn && pfn < end_pfn)
+		if (start_pfn <= pfn && pfn < end_pfn) {
+			last_start_pfn = start_pfn;
+			last_end_pfn = end_pfn;
+			last_nid = nid;
 			return nid;
+		}
 	/* This is a memory hole */
 	return -1;
 }
Index: linux/arch/ia64/mm/numa.c
===================================================================
--- linux.orig/arch/ia64/mm/numa.c	2013-02-25 15:49:44.000000000 -0600
+++ linux/arch/ia64/mm/numa.c	2013-03-22 16:09:44.662268239 -0500
@@ -61,13 +61,26 @@ paddr_to_nid(unsigned long paddr)
 int __meminit __early_pfn_to_nid(unsigned long pfn)
 {
 	int i, section = pfn >> PFN_SECTION_SHIFT, ssec, esec;
+	/*
+	   NOTE: The following SMP-unsafe globals are only used early
+	   in boot when the kernel is running single-threaded.
+	*/
+	static unsigned long last_start_pfn, last_end_pfn;
+	static int last_nid;
+
+	if (section >= last_ssec && section < last_esec)
+		return last_nid;
 
 	for (i = 0; i < num_node_memblks; i++) {
 		ssec = node_memblk[i].start_paddr >> PA_SECTION_SHIFT;
 		esec = (node_memblk[i].start_paddr + node_memblk[i].size +
 			((1L << PA_SECTION_SHIFT) - 1)) >> PA_SECTION_SHIFT;
-		if (section >= ssec && section < esec)
+		if (section >= ssec && section < esec) {
+			last_ssec = ssec;
+			last_esec = esec;
+			last_nid = node_memblk[i].nid
 			return node_memblk[i].nid;
+		}
 	}
 
 	return -1;

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
