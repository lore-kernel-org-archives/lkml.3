Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932843Ab3ICMUU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 08:20:20 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:64098 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324Ab3ICMUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 08:20:11 -0400
Date: Tue, 3 Sep 2013 14:20:05 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] RCU changes for v3.12
Message-ID: <20130903122005.GA24683@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest RCU git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-rcu-for-linus

   HEAD: 7d992feb7694a21ee81f22894b455dadd5d1c110 Merge branch 'rcu/next' of git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu into core/rcu

Main RCU changes this cycle were:

   * Full-system idle detection.  This is for use by Frederic
     Weisbecker's adaptive-ticks mechanism.  Its purpose is
     to allow the timekeeping CPU to shut off its tick when
     all other CPUs are idle.

   * Miscellaneous fixes.

   * Improved rcutorture test coverage.

   * Updated RCU documentation.

 Thanks,

	Ingo

------------------>
Borislav Petkov (1):
      rcu: Expedite grace periods during suspend/resume

James Hogan (1):
      rcu: Select IRQ_WORK from TREE_PREEMPT_RCU

Paul E. McKenney (23):
      rcu: Fix rcu_barrier() documentation
      rcu: Simplify debug-objects fixups
      debugobjects: Make debug_object_activate() return status
      rcu: Make call_rcu() leak callbacks for debug-object errors
      rcu: Avoid redundant grace-period kthread wakeups
      rcu: Eliminate unused APIs intended for adaptive ticks
      nohz_full: Add testing information to documentation
      nohz_full: Add Kconfig parameter for scalable detection of all-idle state
      nohz_full: Add rcu_dyntick data for scalable detection of all-idle state
      nohz_full: Add per-CPU idle-state tracking
      nohz_full: Add full-system idle states and variables
      nohz_full: Add full-system-idle arguments to API
      rcu: Update RTFP documentation
      doc: Fix memory-barrier control-dependency example
      rcu: Add duplicate-callback tests to rcutorture
      rcu: Increase rcutorture test coverage
      rcu: Sort rcutorture module parameters
      rcu: Remove unused variable from rcu_torture_writer()
      rcu: Make rcutorture emit online failures if verbose
      rcu: Simplify _rcu_barrier() processing
      jiffies: Avoid undefined behavior from signed overflow
      nohz_full: Add full-system-idle state machine
      nohz_full: Force RCU's grace-period kthreads onto timekeeping CPU

Steven Rostedt (Red Hat) (4):
      tracing: Add __tracepoint_string() to export string pointers
      rcu: Add const annotation to char * for RCU tracepoints and functions
      rcu: Simplify RCU_STATE_INITIALIZER() macro
      rcu: Have the RCU tracepoints use the tracepoint_string infrastructure

Tejun Heo (1):
      rculist: list_first_or_null_rcu() should use list_entry_rcu()


 Documentation/RCU/RTFP.txt        | 858 ++++++++++++++++++++++++--------------
 Documentation/RCU/rcubarrier.txt  |  12 +-
 Documentation/RCU/torture.txt     |  10 +
 Documentation/memory-barriers.txt |  10 +-
 Documentation/timers/NO_HZ.txt    |  44 +-
 include/asm-generic/vmlinux.lds.h |   7 +-
 include/linux/debugobjects.h      |   6 +-
 include/linux/ftrace_event.h      |  34 ++
 include/linux/jiffies.h           |   8 +-
 include/linux/rculist.h           |   5 +-
 include/linux/rcupdate.h          |  26 +-
 include/trace/events/rcu.h        |  82 ++--
 init/Kconfig                      |   1 +
 kernel/rcu.h                      |  12 +-
 kernel/rcupdate.c                 | 102 +----
 kernel/rcutiny.c                  |   2 +-
 kernel/rcutiny_plugin.h           |   2 +-
 kernel/rcutorture.c               | 396 ++++++++----------
 kernel/rcutree.c                  | 255 ++++++-----
 kernel/rcutree.h                  |  19 +-
 kernel/rcutree_plugin.h           | 460 +++++++++++++++++++-
 kernel/time/Kconfig               |  50 +++
 kernel/trace/trace.h              |   3 +
 kernel/trace/trace_printk.c       |  19 +
 lib/debugobjects.c                |  20 +-
 25 files changed, 1610 insertions(+), 833 deletions(-)

diff --git a/Documentation/RCU/RTFP.txt b/Documentation/RCU/RTFP.txt
index 7f40c72..273e654d 100644
--- a/Documentation/RCU/RTFP.txt
+++ b/Documentation/RCU/RTFP.txt
@@ -39,7 +39,7 @@ in read-mostly situations.  This algorithm does take pains to avoid
 write-side contention and parallelize the other write-side overheads by
 providing a fine-grained locking design, however, it would be interesting
 to see how much of the performance advantage reported in 1990 remains
-in 2004.
+today.
 
 At about this same time, Adams [Adams91] described ``chaotic relaxation'',
 where the normal barriers between successive iterations of convergent
@@ -86,9 +86,9 @@ DYNIX/ptx kernel.  The corresponding conference paper appeared in 1998
 [McKenney98].
 
 In 1999, the Tornado and K42 groups described their "generations"
-mechanism, which quite similar to RCU [Gamsa99].  These operating systems
-made pervasive use of RCU in place of "existence locks", which greatly
-simplifies locking hierarchies.
+mechanism, which is quite similar to RCU [Gamsa99].  These operating
+systems made pervasive use of RCU in place of "existence locks", which
+greatly simplifies locking hierarchies and helps avoid deadlocks.
 
 2001 saw the first RCU presentation involving Linux [McKenney01a]
 at OLS.  The resulting abundance of RCU patches was presented the
@@ -106,8 +106,11 @@ these techniques still impose significant read-side overhead in the
 form of memory barriers.  Researchers at Sun worked along similar lines
 in the same timeframe [HerlihyLM02].  These techniques can be thought
 of as inside-out reference counts, where the count is represented by the
-number of hazard pointers referencing a given data structure (rather than
-the more conventional counter field within the data structure itself).
+number of hazard pointers referencing a given data structure rather than
+the more conventional counter field within the data structure itself.
+The key advantage of inside-out reference counts is that they can be
+stored in immortal variables, thus allowing races between access and
+deletion to be avoided.
 
 By the same token, RCU can be thought of as a "bulk reference count",
 where some form of reference counter covers all reference by a given CPU
@@ -179,7 +182,25 @@ tree using software transactional memory to protect concurrent updates
 (strange, but true!) [PhilHoward2011RCUTMRBTree], yet another variant of
 RCU-protected resizeable hash tables [Triplett:2011:RPHash], the 3.0 RCU
 trainwreck [PaulEMcKenney2011RCU3.0trainwreck], and Neil Brown's "Meet the
-Lockers" LWN article [NeilBrown2011MeetTheLockers].
+Lockers" LWN article [NeilBrown2011MeetTheLockers].  Some academic
+work looked at debugging uses of RCU [Seyster:2011:RFA:2075416.2075425].
+
+In 2012, Josh Triplett received his Ph.D. with his dissertation
+covering RCU-protected resizable hash tables and the relationship
+between memory barriers and read-side traversal order:  If the updater
+is making changes in the opposite direction from the read-side traveral
+order, the updater need only execute a memory-barrier instruction,
+but if in the same direction, the updater needs to wait for a grace
+period between the individual updates [JoshTriplettPhD].  Also in 2012,
+after seventeen years of attempts, an RCU paper made it into a top-flight
+academic journal, IEEE Transactions on Parallel and Distributed Systems
+[MathieuDesnoyers2012URCU].  A group of researchers in Spain applied
+user-level RCU to crowd simulation [GuillermoVigueras2012RCUCrowd], and
+another group of researchers in Europe produced a formal description of
+RCU based on separation logic [AlexeyGotsman2012VerifyGraceExtended],
+which was published in the 2013 European Symposium on Programming
+[AlexeyGotsman2013ESOPRCU].
+
 
 
 Bibtex Entries
@@ -193,13 +214,12 @@ Bibtex Entries
 ,volume="5"
 ,number="3"
 ,pages="354-382"
-,note="Available:
-\url{http://portal.acm.org/citation.cfm?id=320619&dl=GUIDE,}
-[Viewed December 3, 2007]"
 ,annotation={
 	Use garbage collector to clean up data after everyone is done with it.
 	.
 	Oldest use of something vaguely resembling RCU that I have found.
+	http://portal.acm.org/citation.cfm?id=320619&dl=GUIDE,
+	[Viewed December 3, 2007]
 }
 }
 
@@ -309,7 +329,7 @@ for Programming Languages and Operating Systems}"
 ,doi = {http://doi.acm.org/10.1145/42392.42399}
 ,publisher = {ACM}
 ,address = {New York, NY, USA}
-,annotation= {
+,annotation={
 	At the top of page 307: "Conflicts with deposits and withdrawals
 	are necessary if the reported total is to be up to date.  They
 	could be avoided by having total return a sum that is slightly
@@ -346,8 +366,9 @@ for Programming Languages and Operating Systems}"
 }
 }
 
-@Book{Adams91
-,Author="Gregory R. Adams"
+# Was Adams91, see also syncrefs.bib.
+@Book{Andrews91textbook
+,Author="Gregory R. Andrews"
 ,title="Concurrent Programming, Principles, and Practices"
 ,Publisher="Benjamin Cummins"
 ,Year="1991"
@@ -398,39 +419,39 @@ for Programming Languages and Operating Systems}"
 }
 }
 
-@conference{Pu95a,
-Author = "Calton Pu and Tito Autrey and Andrew Black and Charles Consel and
+@conference{Pu95a
+,Author = "Calton Pu and Tito Autrey and Andrew Black and Charles Consel and
 Crispin Cowan and Jon Inouye and Lakshmi Kethana and Jonathan Walpole and
-Ke Zhang",
-Title = "Optimistic Incremental Specialization: Streamlining a Commercial
-Operating System",
-Booktitle = "15\textsuperscript{th} ACM Symposium on
-Operating Systems Principles (SOSP'95)",
-address = "Copper Mountain, CO",
-month="December",
-year="1995",
-pages="314-321",
-annotation="
+Ke Zhang"
+,Title = "Optimistic Incremental Specialization: Streamlining a Commercial
+,Operating System"
+,Booktitle = "15\textsuperscript{th} ACM Symposium on
+,Operating Systems Principles (SOSP'95)"
+,address = "Copper Mountain, CO"
+,month="December"
+,year="1995"
+,pages="314-321"
+,annotation={
 	Uses a replugger, but with a flag to signal when people are
 	using the resource at hand.  Only one reader at a time.
-"
-}
-
-@conference{Cowan96a,
-Author = "Crispin Cowan and Tito Autrey and Charles Krasic and
-Calton Pu and Jonathan Walpole",
-Title = "Fast Concurrent Dynamic Linking for an Adaptive Operating System",
-Booktitle = "International Conference on Configurable Distributed Systems
-(ICCDS'96)",
-address = "Annapolis, MD",
-month="May",
-year="1996",
-pages="108",
-isbn="0-8186-7395-8",
-annotation="
+}
+}
+
+@conference{Cowan96a
+,Author = "Crispin Cowan and Tito Autrey and Charles Krasic and
+,Calton Pu and Jonathan Walpole"
+,Title = "Fast Concurrent Dynamic Linking for an Adaptive Operating System"
+,Booktitle = "International Conference on Configurable Distributed Systems
+(ICCDS'96)"
+,address = "Annapolis, MD"
+,month="May"
+,year="1996"
+,pages="108"
+,isbn="0-8186-7395-8"
+,annotation={
 	Uses a replugger, but with a counter to signal when people are
 	using the resource at hand.  Allows multiple readers.
-"
+}
 }
 
 @techreport{Slingwine95
@@ -493,14 +514,13 @@ Problems"
 ,Year="1998"
 ,pages="509-518"
 ,Address="Las Vegas, NV"
-,note="Available:
-\url{http://www.rdrop.com/users/paulmck/RCU/rclockpdcsproof.pdf}
-[Viewed December 3, 2007]"
 ,annotation={
 	Describes and analyzes RCU mechanism in DYNIX/ptx.  Describes
 	application to linked list update and log-buffer flushing.
 	Defines 'quiescent state'.  Includes both measured and analytic
 	evaluation.
+	http://www.rdrop.com/users/paulmck/RCU/rclockpdcsproof.pdf
+	[Viewed December 3, 2007]
 }
 }
 
@@ -514,13 +534,12 @@ Operating System Design and Implementation}"
 ,Year="1999"
 ,pages="87-100"
 ,Address="New Orleans, LA"
-,note="Available:
-\url{http://www.usenix.org/events/osdi99/full_papers/gamsa/gamsa.pdf}
-[Viewed August 30, 2006]"
 ,annotation={
 	Use of RCU-like facility in K42/Tornado.  Another independent
 	invention of RCU.
 	See especially pages 7-9 (Section 5).
+	http://www.usenix.org/events/osdi99/full_papers/gamsa/gamsa.pdf
+	[Viewed August 30, 2006]
 }
 }
 
@@ -611,9 +630,9 @@ Orran Krieger and Rusty Russell and Dipankar Sarma and Maneesh Soni"
 ,note="Available:
 \url{http://marc.theaimsgroup.com/?l=linux-kernel&m=100259266316456&w=2}
 [Viewed June 23, 2004]"
-,annotation="
+,annotation={
 	Memory-barrier and Alpha thread.  100 messages, not too bad...
-"
+}
 }
 
 @unpublished{Spraul01
@@ -624,10 +643,10 @@ Orran Krieger and Rusty Russell and Dipankar Sarma and Maneesh Soni"
 ,note="Available:
 \url{http://marc.theaimsgroup.com/?l=linux-kernel&m=100264675012867&w=2}
 [Viewed June 23, 2004]"
-,annotation="
+,annotation={
 	Suggested burying memory barriers in Linux's list-manipulation
 	primitives.
-"
+}
 }
 
 @unpublished{LinusTorvalds2001a
@@ -638,6 +657,8 @@ Orran Krieger and Rusty Russell and Dipankar Sarma and Maneesh Soni"
 ,note="Available:
 \url{http://lkml.org/lkml/2001/10/13/105}
 [Viewed August 21, 2004]"
+,annotation={
+}
 }
 
 @unpublished{Blanchard02a
@@ -657,10 +678,10 @@ Orran Krieger and Rusty Russell and Dipankar Sarma and Maneesh Soni"
 ,Month="June"
 ,Year="2002"
 ,pages="289-300"
-,annotation="
+,annotation={
 	Measured scalability of Linux 2.4 kernel's directory-entry cache
 	(dcache), and measured some scalability enhancements.
-"
+}
 }
 
 @Conference{McKenney02a
@@ -674,10 +695,10 @@ Andrea Arcangeli and Andi Kleen and Orran Krieger and Rusty Russell"
 ,note="Available:
 \url{http://www.linux.org.uk/~ajh/ols2002_proceedings.pdf.gz}
 [Viewed June 23, 2004]"
-,annotation="
+,annotation={
 	Presented and compared a number of RCU implementations for the
 	Linux kernel.
-"
+}
 }
 
 @unpublished{Sarma02a
@@ -688,9 +709,9 @@ Andrea Arcangeli and Andi Kleen and Orran Krieger and Rusty Russell"
 ,note="Available:
 \url{http://marc.theaimsgroup.com/?l=linux-kernel&m=102645767914212&w=2}
 [Viewed June 23, 2004]"
-,annotation="
+,annotation={
 	Compare fastwalk and RCU for dcache.  RCU won.
-"
+}
 }
 
 @unpublished{Barbieri02
@@ -701,9 +722,9 @@ Andrea Arcangeli and Andi Kleen and Orran Krieger and Rusty Russell"
 ,note="Available:
 \url{http://marc.theaimsgroup.com/?l=linux-kernel&m=103082050621241&w=2}
 [Viewed: June 23, 2004]"
-,annotation="
+,annotation={
 	Suggested RCU for vfs\_shared\_cred.
-"
+}
 }
 
 @unpublished{Dickins02a
@@ -722,10 +743,10 @@ Andrea Arcangeli and Andi Kleen and Orran Krieger and Rusty Russell"
 ,note="Available:
 \url{http://marc.theaimsgroup.com/?l=linux-kernel&m=103462075416638&w=2}
 [Viewed June 23, 2004]"
-,annotation="
+,annotation={
 	Performance of dcache RCU on kernbench for 16x NUMA-Q and 1x,
 	2x, and 4x systems.  RCU does no harm, and helps on 16x.
-"
+}
 }
 
 @unpublished{LinusTorvalds2003a
@@ -736,14 +757,14 @@ Andrea Arcangeli and Andi Kleen and Orran Krieger and Rusty Russell"
 ,note="Available:
 \url{http://lkml.org/lkml/2003/3/9/205}
 [Viewed March 13, 2006]"
-,annotation="
+,annotation={
 	Linus suggests replacing brlock with RCU and/or seqlocks:
 	.
 	'It's entirely possible that the current user could be replaced
 	by RCU and/or seqlocks, and we could get rid of brlocks entirely.'
 	.
 	Steve Hemminger responds by replacing them with RCU.
-"
+}
 }
 
 @article{Appavoo03a
@@ -758,9 +779,9 @@ B. Rosenburg and M. Stumm and J. Xenidis"
 ,volume="42"
 ,number="1"
 ,pages="60-76"
-,annotation="
+,annotation={
 	Use of RCU to enable hot-swapping for autonomic behavior in K42.
-"
+}
 }
 
 @unpublished{Seigh03
@@ -769,9 +790,9 @@ B. Rosenburg and M. Stumm and J. Xenidis"
 ,Year="2003"
 ,Month="March"
 ,note="email correspondence"
-,annotation="
+,annotation={
 	Described the relationship of the VM/XA passive serialization to RCU.
-"
+}
 }
 
 @Conference{Arcangeli03
@@ -785,14 +806,12 @@ Dipankar Sarma"
 ,year="2003"
 ,month="June"
 ,pages="297-310"
-,note="Available:
-\url{http://www.rdrop.com/users/paulmck/RCU/rcu.FREENIX.2003.06.14.pdf}
-[Viewed November 21, 2007]"
-,annotation="
+,annotation={
 	Compared updated RCU implementations for the Linux kernel, and
 	described System V IPC use of RCU, including order-of-magnitude
 	performance improvements.
-"
+	http://www.rdrop.com/users/paulmck/RCU/rcu.FREENIX.2003.06.14.pdf
+}
 }
 
 @Conference{Soules03a
@@ -820,10 +839,10 @@ Michal Ostrowski and Bryan Rosenburg and Jimi Xenidis"
 ,note="Available:
 \url{http://www.linuxjournal.com/article/6993}
 [Viewed November 14, 2007]"
-,annotation="
+,annotation={
 	Reader-friendly intro to RCU, with the infamous old-man-and-brat
 	cartoon.
-"
+}
 }
 
 @unpublished{Sarma03a
@@ -832,7 +851,9 @@ Michal Ostrowski and Bryan Rosenburg and Jimi Xenidis"
 ,month="December"
 ,year="2003"
 ,note="Message ID: 20031222180114.GA2248@in.ibm.com"
-,annotation="dipankar/ct.2004.03.27/RCUll.2003.12.22.patch"
+,annotation={
+	dipankar/ct.2004.03.27/RCUll.2003.12.22.patch
+}
 }
 
 @techreport{Friedberg03a
@@ -844,11 +865,11 @@ Michal Ostrowski and Bryan Rosenburg and Jimi Xenidis"
 ,number="US Patent 6,662,184"
 ,month="December"
 ,pages="112"
-,annotation="
+,annotation={
 	Applies RCU to a wildcard-search Patricia tree in order to permit
 	synchronization-free lookup.  RCU is used to retain removed nodes
 	for a grace period before freeing them.
-"
+}
 }
 
 @article{McKenney04a
@@ -860,12 +881,11 @@ Michal Ostrowski and Bryan Rosenburg and Jimi Xenidis"
 ,volume="1"
 ,number="118"
 ,pages="38-46"
-,note="Available:
-\url{http://www.linuxjournal.com/node/7124}
-[Viewed December 26, 2010]"
-,annotation="
+,annotation={
 	Reader friendly intro to dcache and RCU.
-"
+	http://www.linuxjournal.com/node/7124
+	[Viewed December 26, 2010]
+}
 }
 
 @Conference{McKenney04b
@@ -879,10 +899,10 @@ Michal Ostrowski and Bryan Rosenburg and Jimi Xenidis"
 \url{http://www.linux.org.au/conf/2004/abstracts.html#90}
 \url{http://www.rdrop.com/users/paulmck/RCU/lockperf.2004.01.17a.pdf}
 [Viewed June 23, 2004]"
-,annotation="
+,annotation={
 	Compares performance of RCU to that of other locking primitives
 	over a number of CPUs (x86, Opteron, Itanium, and PPC).
-"
+}
 }
 
 @unpublished{Sarma04a
@@ -891,7 +911,9 @@ Michal Ostrowski and Bryan Rosenburg and Jimi Xenidis"
 ,month="March"
 ,year="2004"
 ,note="\url{http://marc.theaimsgroup.com/?l=linux-kernel&m=108003746402892&w=2}"
-,annotation="Head of thread: dipankar/2004.03.23/rcu-low-lat.1.patch"
+,annotation={
+	Head of thread: dipankar/2004.03.23/rcu-low-lat.1.patch
+}
 }
 
 @unpublished{Sarma04b
@@ -900,7 +922,9 @@ Michal Ostrowski and Bryan Rosenburg and Jimi Xenidis"
 ,month="March"
 ,year="2004"
 ,note="\url{http://marc.theaimsgroup.com/?l=linux-kernel&m=108016474829546&w=2}"
-,annotation="dipankar/rcuth.2004.03.24/rcu-throttle.patch"
+,annotation={
+	dipankar/rcuth.2004.03.24/rcu-throttle.patch
+}
 }
 
 @unpublished{Spraul04a
@@ -911,9 +935,9 @@ Michal Ostrowski and Bryan Rosenburg and Jimi Xenidis"
 ,note="Available:
 \url{http://marc.theaimsgroup.com/?l=linux-kernel&m=108546407726602&w=2}
 [Viewed June 23, 2004]"
-,annotation="
+,annotation={
 	Hierarchical-bitmap patch for RCU infrastructure.
-"
+}
 }
 
 @unpublished{Steiner04a
@@ -950,10 +974,12 @@ Realtime Applications"
 ,year="2004"
 ,month="June"
 ,pages="182-191"
-,annotation="
+,annotation={
 	Describes and compares a number of modifications to the Linux RCU
 	implementation that make it friendly to realtime applications.
-"
+	https://www.usenix.org/conference/2004-usenix-annual-technical-conference/making-rcu-safe-deep-sub-millisecond-response
+	[Viewed July 26, 2012]
+}
 }
 
 @phdthesis{PaulEdwardMcKenneyPhD
@@ -964,14 +990,13 @@ in Operating System Kernels"
 ,school="OGI School of Science and Engineering at
 Oregon Health and Sciences University"
 ,year="2004"
-,note="Available:
-\url{http://www.rdrop.com/users/paulmck/RCU/RCUdissertation.2004.07.14e1.pdf}
-[Viewed October 15, 2004]"
-,annotation="
+,annotation={
 	Describes RCU implementations and presents design patterns
 	corresponding to common uses of RCU in several operating-system
 	kernels.
-"
+	http://www.rdrop.com/users/paulmck/RCU/RCUdissertation.2004.07.14e1.pdf
+	[Viewed October 15, 2004]
+}
 }
 
 @unpublished{PaulEMcKenney2004rcu:dereference
@@ -982,9 +1007,9 @@ Oregon Health and Sciences University"
 ,note="Available:
 \url{http://lkml.org/lkml/2004/8/6/237}
 [Viewed June 8, 2010]"
-,annotation="
+,annotation={
 	Introduce rcu_dereference().
-"
+}
 }
 
 @unpublished{JimHouston04a
@@ -995,11 +1020,11 @@ Oregon Health and Sciences University"
 ,note="Available:
 \url{http://lkml.org/lkml/2004/8/30/87}
 [Viewed February 17, 2005]"
-,annotation="
+,annotation={
 	Uses active code in rcu_read_lock() and rcu_read_unlock() to
 	make RCU happen, allowing RCU to function on CPUs that do not
 	receive a scheduling-clock interrupt.
-"
+}
 }
 
 @unpublished{TomHart04a
@@ -1010,9 +1035,9 @@ Oregon Health and Sciences University"
 ,note="Available:
 \url{http://www.cs.toronto.edu/~tomhart/masters_thesis.html}
 [Viewed October 15, 2004]"
-,annotation="
+,annotation={
 	Proposes comparing RCU to lock-free methods for the Linux kernel.
-"
+}
 }
 
 @unpublished{Vaddagiri04a
@@ -1023,9 +1048,9 @@ Oregon Health and Sciences University"
 ,note="Available:
 \url{http://marc.theaimsgroup.com/?t=109395731700004&r=1&w=2}
 [Viewed October 18, 2004]"
-,annotation="
+,annotation={
 	Srivatsa's RCU patch for tcp_ehash lookup.
-"
+}
 }
 
 @unpublished{Thirumalai04a
@@ -1036,9 +1061,9 @@ Oregon Health and Sciences University"
 ,note="Available:
 \url{http://marc.theaimsgroup.com/?t=109144217400003&r=1&w=2}
 [Viewed October 18, 2004]"
-,annotation="
+,annotation={
 	Ravikiran's lockfree FD patch.
-"
+}
 }
 
 @unpublished{Thirumalai04b
@@ -1049,9 +1074,9 @@ Oregon Health and Sciences University"
 ,note="Available:
 \url{http://marc.theaimsgroup.com/?l=linux-kernel&m=109152521410459&w=2}
 [Viewed October 18, 2004]"
-,annotation="
+,annotation={
 	Ravikiran's lockfree FD patch.
-"
+}
 }
 
 @unpublished{PaulEMcKenney2004rcu:assign:pointer
@@ -1062,9 +1087,9 @@ Oregon Health and Sciences University"
 ,note="Available:
 \url{http://lkml.org/lkml/2004/10/23/241}
 [Viewed June 8, 2010]"
-,annotation="
+,annotation={
 	Introduce rcu_assign_pointer().
-"
+}
 }
 
 @unpublished{JamesMorris04a
@@ -1073,12 +1098,12 @@ Oregon Health and Sciences University"
 ,day="15"
 ,month="November"
 ,year="2004"
-,note="Available:
-\url{http://marc.theaimsgroup.com/?l=linux-kernel&m=110054979416004&w=2}
-[Viewed December 10, 2004]"
-,annotation="
+,note="\url{http://marc.theaimsgroup.com/?l=linux-kernel&m=110054979416004&w=2}"
+,annotation={
 	James Morris posts Kaigai Kohei's patch to LKML.
-"
+	[Viewed December 10, 2004]
+	Kaigai's patch is at https://lkml.org/lkml/2004/9/27/52
+}
 }
 
 @unpublished{JamesMorris04b
@@ -1089,9 +1114,9 @@ Oregon Health and Sciences University"
 ,note="Available:
 \url{http://www.livejournal.com/users/james_morris/2153.html}
 [Viewed December 10, 2004]"
-,annotation="
+,annotation={
 	RCU helps SELinux performance.  ;-)  Made LWN.
-"
+}
 }
 
 @unpublished{PaulMcKenney2005RCUSemantics
@@ -1103,9 +1128,9 @@ Oregon Health and Sciences University"
 ,note="Available:
 \url{http://www.rdrop.com/users/paulmck/RCU/rcu-semantics.2005.01.30a.pdf}
 [Viewed December 6, 2009]"
-,annotation="
+,annotation={
 	Early derivation of RCU semantics.
-"
+}
 }
 
 @unpublished{PaulMcKenney2005e
@@ -1117,10 +1142,10 @@ Oregon Health and Sciences University"
 ,note="Available:
 \url{http://lkml.org/lkml/2005/3/17/199}
 [Viewed September 5, 2005]"
-,annotation="
+,annotation={
 	First posting showing how RCU can be safely adapted for
 	preemptable RCU read side critical sections.
-"
+}
 }
 
 @unpublished{EsbenNeilsen2005a
@@ -1132,12 +1157,12 @@ Oregon Health and Sciences University"
 ,note="Available:
 \url{http://lkml.org/lkml/2005/3/18/122}
 [Viewed March 30, 2006]"
-,annotation="
+,annotation={
 	Esben Neilsen suggests read-side suppression of grace-period
 	processing for crude-but-workable realtime RCU.  The downside
-	is indefinite grace periods...But this is OK for experimentation
+	is indefinite grace periods...  But this is OK for experimentation
 	and testing.
-"
+}
 }
 
 @unpublished{TomHart05a
@@ -1149,10 +1174,10 @@ Data Structures"
 ,note="Available:
 \url{ftp://ftp.cs.toronto.edu/csrg-technical-reports/515/}
 [Viewed March 4, 2005]"
-,annotation="
+,annotation={
 	Comparison of RCU, QBSR, and EBSR.  RCU wins for read-mostly
 	workloads.  ;-)
-"
+}
 }
 
 @unpublished{JonCorbet2005DeprecateSyncKernel
@@ -1164,10 +1189,10 @@ Data Structures"
 ,note="Available:
 \url{http://lwn.net/Articles/134484/}
 [Viewed May 3, 2005]"
-,annotation="
+,annotation={
 	Jon Corbet describes deprecation of synchronize_kernel()
 	in favor of synchronize_rcu() and synchronize_sched().
-"
+}
 }
 
 @unpublished{PaulMcKenney05a
@@ -1178,10 +1203,10 @@ Data Structures"
 ,note="Available:
 \url{http://lkml.org/lkml/2005/5/9/185}
 [Viewed May 13, 2005]"
-,annotation="
+,annotation={
 	First publication of working lock-based deferred free patches
 	for the CONFIG_PREEMPT_RT environment.
-"
+}
 }
 
 @conference{PaulMcKenney05b
@@ -1194,10 +1219,10 @@ Data Structures"
 ,note="Available:
 \url{http://www.rdrop.com/users/paulmck/RCU/realtimeRCU.2005.04.23a.pdf}
 [Viewed May 13, 2005]"
-,annotation="
+,annotation={
 	Realtime turns into making RCU yet more realtime friendly.
 	http://lca2005.linux.org.au/Papers/Paul%20McKenney/Towards%20Hard%20Realtime%20Response%20from%20the%20Linux%20Kernel/LKS.2005.04.22a.pdf
-"
+}
 }
 
 @unpublished{PaulEMcKenneyHomePage
@@ -1208,9 +1233,9 @@ Data Structures"
 ,note="Available:
 \url{http://www.rdrop.com/users/paulmck/}
 [Viewed May 25, 2005]"
-,annotation="
+,annotation={
 	Paul McKenney's home page.
-"
+}
 }
 
 @unpublished{PaulEMcKenneyRCUPage
@@ -1221,9 +1246,9 @@ Data Structures"
 ,note="Available:
 \url{http://www.rdrop.com/users/paulmck/RCU}
 [Viewed May 25, 2005]"
-,annotation="
+,annotation={
 	Paul McKenney's RCU page.
-"
+}
 }
 
 @unpublished{JosephSeigh2005a
@@ -1232,10 +1257,10 @@ Data Structures"
 ,month="July"
 ,year="2005"
 ,note="Personal communication"
-,annotation="
+,annotation={
 	Joe Seigh announcing his atomic-ptr-plus project.
 	http://sourceforge.net/projects/atomic-ptr-plus/
-"
+}
 }
 
 @unpublished{JosephSeigh2005b
@@ -1247,9 +1272,9 @@ Data Structures"
 ,note="Available:
 \url{http://sourceforge.net/projects/atomic-ptr-plus/}
 [Viewed August 8, 2005]"
-,annotation="
+,annotation={
 	Joe Seigh's atomic-ptr-plus project.
-"
+}
 }
 
 @unpublished{PaulMcKenney2005c
@@ -1261,9 +1286,9 @@ Data Structures"
 ,note="Available:
 \url{http://lkml.org/lkml/2005/8/1/155}
 [Viewed March 14, 2006]"
-,annotation="
+,annotation={
 	First operating counter-based realtime RCU patch posted to LKML.
-"
+}
 }
 
 @unpublished{PaulMcKenney2005d
@@ -1275,11 +1300,11 @@ Data Structures"
 ,note="Available:
 \url{http://lkml.org/lkml/2005/8/8/108}
 [Viewed March 14, 2006]"
-,annotation="
+,annotation={
 	First operating counter-based realtime RCU patch posted to LKML,
 	but fixed so that various unusual combinations of configuration
 	parameters all function properly.
-"
+}
 }
 
 @unpublished{PaulMcKenney2005rcutorture
@@ -1291,9 +1316,25 @@ Data Structures"
 ,note="Available:
 \url{http://lkml.org/lkml/2005/10/1/70}
 [Viewed March 14, 2006]"
-,annotation="
+,annotation={
 	First rcutorture patch.
-"
+}
+}
+
+@unpublished{DavidSMiller2006HashedLocking
+,Author="David S. Miller"
+,Title="Re: [{PATCH}, {RFC}] {RCU} : {OOM} avoidance and lower latency"
+,month="January"
+,day="6"
+,year="2006"
+,note="Available:
+\url{https://lkml.org/lkml/2006/1/7/22}
+[Viewed February 29, 2012]"
+,annotation={
+	David Miller's view on hashed arrays of locks: used to really
+	like it, but time he saw an opportunity for this technique,
+	something else always proved superior.  Partitioning or RCU.  ;-)
+}
 }
 
 @conference{ThomasEHart2006a
@@ -1309,10 +1350,10 @@ Distributed Processing Symposium"
 ,note="Available:
 \url{http://www.rdrop.com/users/paulmck/RCU/hart_ipdps06.pdf}
 [Viewed April 28, 2008]"
-,annotation="
+,annotation={
 	Compares QSBR, HPBR, EBR, and lock-free reference counting.
 	http://www.cs.toronto.edu/~tomhart/perflab/ipdps06.tgz
-"
+}
 }
 
 @unpublished{NickPiggin2006radixtree
@@ -1324,9 +1365,9 @@ Distributed Processing Symposium"
 ,note="Available:
 \url{http://lkml.org/lkml/2006/6/20/238}
 [Viewed March 25, 2008]"
-,annotation="
+,annotation={
 	RCU-protected radix tree.
-"
+}
 }
 
 @Conference{PaulEMcKenney2006b
@@ -1341,9 +1382,9 @@ Suparna Bhattacharya"
 \url{http://www.linuxsymposium.org/2006/view_abstract.php?content_key=184}
 \url{http://www.rdrop.com/users/paulmck/RCU/OLSrtRCU.2006.08.11a.pdf}
 [Viewed January 1, 2007]"
-,annotation="
+,annotation={
 	Described how to improve the -rt implementation of realtime RCU.
-"
+}
 }
 
 @unpublished{WikipediaRCU
@@ -1354,12 +1395,11 @@ Canis Rufus and Zoicon5 and Anome and Hal Eisen"
 ,month="July"
 ,day="8"
 ,year="2006"
-,note="Available:
-\url{http://en.wikipedia.org/wiki/Read-copy-update}
-[Viewed August 21, 2006]"
-,annotation="
+,note="\url{http://en.wikipedia.org/wiki/Read-copy-update}"
+,annotation={
 	Wikipedia RCU page as of July 8 2006.
-"
+	[Viewed August 21, 2006]
+}
 }
 
 @Conference{NickPiggin2006LocklessPageCache
@@ -1372,9 +1412,9 @@ Canis Rufus and Zoicon5 and Anome and Hal Eisen"
 ,note="Available:
 \url{http://www.linuxsymposium.org/2006/view_abstract.php?content_key=184}
 [Viewed January 11, 2009]"
-,annotation="
+,annotation={
 	Uses RCU-protected radix tree for a lockless page cache.
-"
+}
 }
 
 @unpublished{PaulEMcKenney2006c
@@ -1388,9 +1428,9 @@ Canis Rufus and Zoicon5 and Anome and Hal Eisen"
 Revised:
 \url{http://www.rdrop.com/users/paulmck/RCU/srcu.2007.01.14a.pdf}
 [Viewed August 21, 2006]"
-,annotation="
+,annotation={
 	LWN article introducing SRCU.
-"
+}
 }
 
 @unpublished{RobertOlsson2006a
@@ -1399,12 +1439,11 @@ Revised:
 ,month="August"
 ,day="18"
 ,year="2006"
-,note="Available:
-\url{http://www.nada.kth.se/~snilsson/publications/TRASH/trash.pdf}
-[Viewed March 4, 2011]"
-,annotation="
+,note="\url{http://www.nada.kth.se/~snilsson/publications/TRASH/trash.pdf}"
+,annotation={
 	RCU-protected dynamic trie-hash combination.
-"
+	[Viewed March 4, 2011]
+}
 }
 
 @unpublished{ChristophHellwig2006RCU2SRCU
@@ -1426,10 +1465,10 @@ Revised:
 ,note="Available:
 \url{http://www.rdrop.com/users/paulmck/RCU/linuxusage.html}
 [Viewed January 14, 2007]"
-,annotation="
+,annotation={
 	Paul McKenney's RCU page showing graphs plotting Linux-kernel
 	usage of RCU.
-"
+}
 }
 
 @unpublished{PaulEMcKenneyRCUusageRawDataPage
@@ -1440,10 +1479,10 @@ Revised:
 ,note="Available:
 \url{http://www.rdrop.com/users/paulmck/RCU/linuxusage/rculocktab.html}
 [Viewed January 14, 2007]"
-,annotation="
+,annotation={
 	Paul McKenney's RCU page showing Linux usage of RCU in tabular
 	form, with links to corresponding cscope databases.
-"
+}
 }
 
 @unpublished{GauthamShenoy2006RCUrwlock
@@ -1455,13 +1494,13 @@ Revised:
 ,note="Available:
 \url{http://lkml.org/lkml/2006/10/26/73}
 [Viewed January 26, 2009]"
-,annotation="
+,annotation={
 	RCU-based reader-writer lock that allows readers to proceed with
 	no memory barriers or atomic instruction in absence of writers.
 	If writer do show up, readers must of course wait as required by
 	the semantics of reader-writer locking.  This is a recursive
 	lock.
-"
+}
 }
 
 @unpublished{JensAxboe2006SlowSRCU
@@ -1474,11 +1513,11 @@ Revised:
 ,note="Available:
 \url{http://lkml.org/lkml/2006/11/17/56}
 [Viewed May 28, 2007]"
-,annotation="
+,annotation={
 	SRCU's grace periods are too slow for Jens, even after a
 	factor-of-three speedup.
 	Sped-up version of SRCU at http://lkml.org/lkml/2006/11/17/359.
-"
+}
 }
 
 @unpublished{OlegNesterov2006QRCU
@@ -1491,10 +1530,10 @@ Revised:
 ,note="Available:
 \url{http://lkml.org/lkml/2006/11/19/69}
 [Viewed May 28, 2007]"
-,annotation="
+,annotation={
 	First cut of QRCU.  Expanded/corrected versions followed.
 	Used to be OlegNesterov2007QRCU, now time-corrected.
-"
+}
 }
 
 @unpublished{OlegNesterov2006aQRCU
@@ -1506,10 +1545,10 @@ Revised:
 ,note="Available:
 \url{http://lkml.org/lkml/2006/11/29/330}
 [Viewed November 26, 2008]"
-,annotation="
+,annotation={
 	Expanded/corrected version of QRCU.
 	Used to be OlegNesterov2007aQRCU, now time-corrected.
-"
+}
 }
 
 @unpublished{EvgeniyPolyakov2006RCUslowdown
@@ -1521,10 +1560,10 @@ Revised:
 ,note="Available:
 \url{http://www.ioremap.net/node/41}
 [Viewed October 28, 2008]"
-,annotation="
+,annotation={
 	Using RCU as a pure delay leads to a 2.5x slowdown in skbs in
 	the Linux kernel.
-"
+}
 }
 
 @inproceedings{ChrisMatthews2006ClusteredObjectsRCU
@@ -1541,7 +1580,8 @@ Revised:
 ,annotation={
 	Uses K42's RCU-like functionality to manage clustered-object
 	lifetimes.
-}}
+}
+}
 
 @article{DilmaDaSilva2006K42
 ,author = {Silva, Dilma Da and Krieger, Orran and Wisniewski, Robert W. and Waterland, Amos and Tam, David and Baumann, Andrew}
@@ -1557,7 +1597,8 @@ Revised:
 ,address = {New York, NY, USA}
 ,annotation={
 	Describes relationship of K42 generations to RCU.
-}}
+}
+}
 
 # CoreyMinyard2007list_splice_rcu
 @unpublished{CoreyMinyard2007list:splice:rcu
@@ -1569,9 +1610,9 @@ Revised:
 ,note="Available:
 \url{http://lkml.org/lkml/2007/1/3/112}
 [Viewed May 28, 2007]"
-,annotation="
+,annotation={
 	Patch for list_splice_rcu().
-"
+}
 }
 
 @unpublished{PaulEMcKenney2007rcubarrier
@@ -1583,9 +1624,9 @@ Revised:
 ,note="Available:
 \url{http://lwn.net/Articles/217484/}
 [Viewed November 22, 2007]"
-,annotation="
+,annotation={
 	LWN article introducing the rcu_barrier() primitive.
-"
+}
 }
 
 @unpublished{PeterZijlstra2007SyncBarrier
@@ -1597,10 +1638,10 @@ Revised:
 ,note="Available:
 \url{http://lkml.org/lkml/2007/1/28/34}
 [Viewed March 27, 2008]"
-,annotation="
+,annotation={
 	RCU-like implementation for frequent updaters and rare readers(!).
 	Subsumed into QRCU.  Maybe...
-"
+}
 }
 
 @unpublished{PaulEMcKenney2007BoostRCU
@@ -1609,14 +1650,13 @@ Revised:
 ,month="February"
 ,day="5"
 ,year="2007"
-,note="Available:
-\url{http://lwn.net/Articles/220677/}
-Revised:
-\url{http://www.rdrop.com/users/paulmck/RCU/RCUbooststate.2007.04.16a.pdf}
-[Viewed September 7, 2007]"
-,annotation="
+,note="\url{http://lwn.net/Articles/220677/}"
+,annotation={
 	LWN article introducing RCU priority boosting.
-"
+	Revised:
+	http://www.rdrop.com/users/paulmck/RCU/RCUbooststate.2007.04.16a.pdf
+	[Viewed September 7, 2007]
+}
 }
 
 @unpublished{PaulMcKenney2007QRCUpatch
@@ -1628,9 +1668,9 @@ Revised:
 ,note="Available:
 \url{http://lkml.org/lkml/2007/2/25/18}
 [Viewed March 27, 2008]"
-,annotation="
+,annotation={
 	Patch for QRCU supplying lock-free fast path.
-"
+}
 }
 
 @article{JonathanAppavoo2007K42RCU
@@ -1647,7 +1687,8 @@ Revised:
 ,address = {New York, NY, USA}
 ,annotation={
 	Role of RCU in K42.
-}}
+}
+}
 
 @conference{RobertOlsson2007Trash
 ,Author="Robert Olsson and Stefan Nilsson"
@@ -1658,9 +1699,9 @@ Revised:
 ,note="Available:
 \url{http://ieeexplore.ieee.org/xpl/freeabs_all.jsp?arnumber=4281239}
 [Viewed October 1, 2010]"
-,annotation="
+,annotation={
 	RCU-protected dynamic trie-hash combination.
-"
+}
 }
 
 @conference{PeterZijlstra2007ConcurrentPagecacheRCU
@@ -1673,10 +1714,10 @@ Revised:
 ,note="Available:
 \url{http://ols.108.redhat.com/2007/Reprints/zijlstra-Reprint.pdf}
 [Viewed April 14, 2008]"
-,annotation="
+,annotation={
 	Page-cache modifications permitting RCU readers and concurrent
 	updates.
-"
+}
 }
 
 @unpublished{PaulEMcKenney2007whatisRCU
@@ -1701,11 +1742,11 @@ Revised:
 ,note="Available:
 \url{http://lwn.net/Articles/243851/}
 [Viewed September 8, 2007]"
-,annotation="
+,annotation={
 	LWN article describing Promela and spin, and also using Oleg
 	Nesterov's QRCU as an example (with Paul McKenney's fastpath).
 	Merged patch at: http://lkml.org/lkml/2007/2/25/18
-"
+}
 }
 
 @unpublished{PaulEMcKenney2007WG21DDOatomics
@@ -1714,12 +1755,12 @@ Revised:
 ,month="August"
 ,day="3"
 ,year="2007"
-,note="Preprint:
+,note="Available:
 \url{http://open-std.org/jtc1/sc22/wg21/docs/papers/2008/n2664.htm}
 [Viewed December 7, 2009]"
-,annotation="
+,annotation={
 	RCU for C++, parts 1 and 2.
-"
+}
 }
 
 @unpublished{PaulEMcKenney2007WG21DDOannotation
@@ -1728,12 +1769,12 @@ Revised:
 ,month="September"
 ,day="18"
 ,year="2008"
-,note="Preprint:
+,note="Available:
 \url{http://open-std.org/jtc1/sc22/wg21/docs/papers/2008/n2782.htm}
 [Viewed December 7, 2009]"
-,annotation="
+,annotation={
 	RCU for C++, part 2, updated many times.
-"
+}
 }
 
 @unpublished{PaulEMcKenney2007PreemptibleRCUPatch
@@ -1745,10 +1786,10 @@ Revised:
 ,note="Available:
 \url{http://lkml.org/lkml/2007/9/10/213}
 [Viewed October 25, 2007]"
-,annotation="
+,annotation={
 	Final patch for preemptable RCU to -rt.  (Later patches were
 	to mainline, eventually incorporated.)
-"
+}
 }
 
 @unpublished{PaulEMcKenney2007PreemptibleRCU
@@ -1760,9 +1801,9 @@ Revised:
 ,note="Available:
 \url{http://lwn.net/Articles/253651/}
 [Viewed October 25, 2007]"
-,annotation="
+,annotation={
 	LWN article describing the design of preemptible RCU.
-"
+}
 }
 
 @article{ThomasEHart2007a
@@ -1783,6 +1824,7 @@ Revised:
 }
 }
 
+# MathieuDesnoyers2007call_rcu_schedNeeded
 @unpublished{MathieuDesnoyers2007call:rcu:schedNeeded
 ,Author="Mathieu Desnoyers"
 ,Title="Re: [patch 1/2] {Linux} Kernel Markers - Support Multiple Probes"
@@ -1792,9 +1834,9 @@ Revised:
 ,note="Available:
 \url{http://lkml.org/lkml/2007/12/20/244}
 [Viewed March 27, 2008]"
-,annotation="
+,annotation={
 	Request for call_rcu_sched() and rcu_barrier_sched().
-"
+}
 }
 
 
@@ -1815,11 +1857,11 @@ Revised:
 ,note="Available:
 \url{http://lwn.net/Articles/262464/}
 [Viewed December 27, 2007]"
-,annotation="
+,annotation={
 	Lays out the three basic components of RCU: (1) publish-subscribe,
 	(2) wait for pre-existing readers to complete, and (2) maintain
 	multiple versions.
-"
+}
 }
 
 @unpublished{PaulEMcKenney2008WhatIsRCUUsage
@@ -1831,7 +1873,7 @@ Revised:
 ,note="Available:
 \url{http://lwn.net/Articles/263130/}
 [Viewed January 4, 2008]"
-,annotation="
+,annotation={
 	Lays out six uses of RCU:
 	1. RCU is a Reader-Writer Lock Replacement
 	2. RCU is a Restricted Reference-Counting Mechanism
@@ -1839,7 +1881,7 @@ Revised:
 	4. RCU is a Poor Man's Garbage Collector
 	5. RCU is a Way of Providing Existence Guarantees
 	6. RCU is a Way of Waiting for Things to Finish
-"
+}
 }
 
 @unpublished{PaulEMcKenney2008WhatIsRCUAPI
@@ -1851,10 +1893,10 @@ Revised:
 ,note="Available:
 \url{http://lwn.net/Articles/264090/}
 [Viewed January 10, 2008]"
-,annotation="
+,annotation={
 	Gives an overview of the Linux-kernel RCU API and a brief annotated RCU
 	bibliography.
-"
+}
 }
 
 #
@@ -1872,10 +1914,10 @@ Revised:
 ,note="Available:
 \url{http://lkml.org/lkml/2008/1/29/208}
 [Viewed March 27, 2008]"
-,annotation="
+,annotation={
 	Patch that prevents preemptible RCU from unnecessarily waking
 	up dynticks-idle CPUs.
-"
+}
 }
 
 @unpublished{PaulEMcKenney2008LKMLDependencyOrdering
@@ -1887,9 +1929,9 @@ Revised:
 ,note="Available:
 \url{http://lkml.org/lkml/2008/2/2/255}
 [Viewed October 18, 2008]"
-,annotation="
+,annotation={
 	Explanation of compilers violating dependency ordering.
-"
+}
 }
 
 @Conference{PaulEMcKenney2008Beijing
@@ -1916,24 +1958,26 @@ lot of {Linux} into your technology!!!"
 ,note="Available:
 \url{http://lwn.net/Articles/279077/}
 [Viewed April 24, 2008]"
-,annotation="
+,annotation={
 	Describes use of Promela and Spin to validate (and fix!) the
 	dynticks/RCU interface.
-"
+}
 }
 
 @article{DinakarGuniguntala2008IBMSysJ
 ,author="D. Guniguntala and P. E. McKenney and J. Triplett and J. Walpole"
 ,title="The read-copy-update mechanism for supporting real-time applications on shared-memory multiprocessor systems with {Linux}"
 ,Year="2008"
-,Month="April-June"
+,Month="May"
 ,journal="IBM Systems Journal"
 ,volume="47"
 ,number="2"
 ,pages="221-236"
-,annotation="
+,annotation={
 	RCU, realtime RCU, sleepable RCU, performance.
-"
+	http://www.research.ibm.com/journal/sj/472/guniguntala.pdf
+	[Viewed April 24, 2008]
+}
 }
 
 @unpublished{LaiJiangshan2008NewClassicAlgorithm
@@ -1945,11 +1989,11 @@ lot of {Linux} into your technology!!!"
 ,note="Available:
 \url{http://lkml.org/lkml/2008/6/2/539}
 [Viewed December 10, 2008]"
-,annotation="
+,annotation={
 	Updated RCU classic algorithm.  Introduced multi-tailed list
 	for RCU callbacks and also pulling common code into
 	__call_rcu().
-"
+}
 }
 
 @article{PaulEMcKenney2008RCUOSR
@@ -1966,6 +2010,7 @@ lot of {Linux} into your technology!!!"
 ,address="New York, NY, USA"
 ,annotation={
 	Linux changed RCU to a far greater degree than RCU has changed Linux.
+	http://portal.acm.org/citation.cfm?doid=1400097.1400099
 }
 }
 
@@ -1978,10 +2023,10 @@ lot of {Linux} into your technology!!!"
 ,note="Available:
 \url{http://lkml.org/lkml/2008/8/21/336}
 [Viewed December 8, 2008]"
-,annotation="
+,annotation={
 	State-based RCU.  One key thing that this patch does is to
 	separate the dynticks handling of NMIs and IRQs.
-"
+}
 }
 
 @unpublished{ManfredSpraul2008dyntickIRQNMI
@@ -1993,12 +2038,13 @@ lot of {Linux} into your technology!!!"
 ,note="Available:
 \url{http://lkml.org/lkml/2008/9/6/86}
 [Viewed December 8, 2008]"
-,annotation="
+,annotation={
 	Manfred notes a fix required to my attempt to separate irq
 	and NMI processing for hierarchical RCU's dynticks interface.
-"
+}
 }
 
+# Was PaulEMcKenney2011cyclicRCU
 @techreport{PaulEMcKenney2008cyclicRCU
 ,author="Paul E. McKenney"
 ,title="Efficient Support of Consistent Cyclic Search With Read-Copy Update"
@@ -2008,11 +2054,11 @@ lot of {Linux} into your technology!!!"
 ,number="US Patent 7,426,511"
 ,month="September"
 ,pages="23"
-,annotation="
+,annotation={
 	Maintains an additional level of indirection to allow
 	readers to confine themselves to the desired snapshot of the
 	data structure.  Only permits one update at a time.
-"
+}
 }
 
 @unpublished{PaulEMcKenney2008HierarchicalRCU
@@ -2021,13 +2067,12 @@ lot of {Linux} into your technology!!!"
 ,month="November"
 ,day="3"
 ,year="2008"
-,note="Available:
-\url{http://lwn.net/Articles/305782/}
-[Viewed November 6, 2008]"
-,annotation="
+,note="\url{http://lwn.net/Articles/305782/}"
+,annotation={
 	RCU with combining-tree-based grace-period detection,
 	permitting it to handle thousands of CPUs.
-"
+	[Viewed November 6, 2008]
+}
 }
 
 @unpublished{PaulEMcKenney2009BloatwatchRCU
@@ -2039,10 +2084,10 @@ lot of {Linux} into your technology!!!"
 ,note="Available:
 \url{http://lkml.org/lkml/2009/1/14/449}
 [Viewed January 15, 2009]"
-,annotation="
+,annotation={
 	Small-footprint implementation of RCU for uniprocessor
 	embedded applications -- and also for exposition purposes.
-"
+}
 }
 
 @conference{PaulEMcKenney2009MaliciousURCU
@@ -2055,9 +2100,9 @@ lot of {Linux} into your technology!!!"
 ,note="Available:
 \url{http://www.rdrop.com/users/paulmck/RCU/urcutorture.2009.01.22a.pdf}
 [Viewed February 2, 2009]"
-,annotation="
+,annotation={
 	Realtime RCU and torture-testing RCU uses.
-"
+}
 }
 
 @unpublished{MathieuDesnoyers2009URCU
@@ -2066,16 +2111,14 @@ lot of {Linux} into your technology!!!"
 ,month="February"
 ,day="5"
 ,year="2009"
-,note="Available:
-\url{http://lkml.org/lkml/2009/2/5/572}
-\url{http://lttng.org/urcu}
-[Viewed February 20, 2009]"
-,annotation="
+,note="\url{http://lttng.org/urcu}"
+,annotation={
 	Mathieu Desnoyers's user-space RCU implementation.
 	git://lttng.org/userspace-rcu.git
 	http://lttng.org/cgi-bin/gitweb.cgi?p=userspace-rcu.git
 	http://lttng.org/urcu
-"
+	http://lkml.org/lkml/2009/2/5/572
+}
 }
 
 @unpublished{PaulEMcKenney2009LWNBloatWatchRCU
@@ -2087,9 +2130,24 @@ lot of {Linux} into your technology!!!"
 ,note="Available:
 \url{http://lwn.net/Articles/323929/}
 [Viewed March 20, 2009]"
-,annotation="
+,annotation={
 	Uniprocessor assumptions allow simplified RCU implementation.
-"
+}
+}
+
+@unpublished{EvgeniyPolyakov2009EllipticsNetwork
+,Author="Evgeniy Polyakov"
+,Title="The Elliptics Network"
+,month="April"
+,day="17"
+,year="2009"
+,note="Available:
+\url{http://www.ioremap.net/projects/elliptics}
+[Viewed April 30, 2009]"
+,annotation={
+	Distributed hash table with transactions, using elliptic
+	hash functions to distribute data.
+}
 }
 
 @unpublished{PaulEMcKenney2009expeditedRCU
@@ -2101,9 +2159,9 @@ lot of {Linux} into your technology!!!"
 ,note="Available:
 \url{http://lkml.org/lkml/2009/6/25/306}
 [Viewed August 16, 2009]"
-,annotation="
+,annotation={
 	First posting of expedited RCU to be accepted into -tip.
-"
+}
 }
 
 @unpublished{PaulEMcKenney2009fastRTRCU
@@ -2115,21 +2173,21 @@ lot of {Linux} into your technology!!!"
 ,note="Available:
 \url{http://lkml.org/lkml/2009/7/23/294}
 [Viewed August 15, 2009]"
-,annotation="
+,annotation={
 	First posting of simple and fast preemptable RCU.
-"
+}
 }
 
-@InProceedings{JoshTriplett2009RPHash
+@unpublished{JoshTriplett2009RPHash
 ,Author="Josh Triplett"
 ,Title="Scalable concurrent hash tables via relativistic programming"
 ,month="September"
 ,year="2009"
-,booktitle="Linux Plumbers Conference 2009"
-,annotation="
+,note="Linux Plumbers Conference presentation"
+,annotation={
 	RP fun with hash tables.
-	See also JoshTriplett2010RPHash
-"
+	Superseded by JoshTriplett2010RPHash
+}
 }
 
 @phdthesis{MathieuDesnoyersPhD
@@ -2154,9 +2212,9 @@ lot of {Linux} into your technology!!!"
 ,note="Available:
 \url{http://wiki.cs.pdx.edu/rp/}
 [Viewed December 9, 2009]"
-,annotation="
+,annotation={
 	Main Relativistic Programming Wiki.
-"
+}
 }
 
 @conference{PaulEMcKenney2009DeterministicRCU
@@ -2180,9 +2238,9 @@ lot of {Linux} into your technology!!!"
 ,note="Available:
 \url{http://paulmck.livejournal.com/14639.html}
 [Viewed June 4, 2010]"
-,annotation="
+,annotation={
 	Day-one bug in Tree RCU that took forever to track down.
-"
+}
 }
 
 @unpublished{MathieuDesnoyers2009defer:rcu
@@ -2193,10 +2251,10 @@ lot of {Linux} into your technology!!!"
 ,note="Available:
 \url{http://lkml.org/lkml/2009/10/18/129}
 [Viewed December 29, 2009]"
-,annotation="
+,annotation={
 	Mathieu proposed defer_rcu() with fixed-size per-thread pool
 	of RCU callbacks.
-"
+}
 }
 
 @unpublished{MathieuDesnoyers2009VerifPrePub
@@ -2205,10 +2263,10 @@ lot of {Linux} into your technology!!!"
 ,month="December"
 ,year="2009"
 ,note="Submitted to IEEE TPDS"
-,annotation="
+,annotation={
 	OOMem model for Mathieu's user-level RCU mechanical proof of
 	correctness.
-"
+}
 }
 
 @unpublished{MathieuDesnoyers2009URCUPrePub
@@ -2216,15 +2274,15 @@ lot of {Linux} into your technology!!!"
 ,Title="User-Level Implementations of Read-Copy Update"
 ,month="December"
 ,year="2010"
-,url=\url{http://www.computer.org/csdl/trans/td/2012/02/ttd2012020375-abs.html}
-,annotation="
+,url={\url{http://www.computer.org/csdl/trans/td/2012/02/ttd2012020375-abs.html}}
+,annotation={
 	RCU overview, desiderata, semi-formal semantics, user-level RCU
 	usage scenarios, three classes of RCU implementation, wait-free
 	RCU updates, RCU grace-period batching, update overhead,
 	http://www.rdrop.com/users/paulmck/RCU/urcu-main-accepted.2011.08.30a.pdf
 	http://www.rdrop.com/users/paulmck/RCU/urcu-supp-accepted.2011.08.30a.pdf
 	Superseded by MathieuDesnoyers2012URCU.
-"
+}
 }
 
 @inproceedings{HariKannan2009DynamicAnalysisRCU
@@ -2240,7 +2298,8 @@ lot of {Linux} into your technology!!!"
 ,address = {New York, NY, USA}
 ,annotation={
 	Uses RCU to protect metadata used in dynamic analysis.
-}}
+}
+}
 
 @conference{PaulEMcKenney2010SimpleOptRCU
 ,Author="Paul E. McKenney"
@@ -2252,10 +2311,10 @@ lot of {Linux} into your technology!!!"
 ,note="Available:
 \url{http://www.rdrop.com/users/paulmck/RCU/SimplicityThruOptimization.2010.01.21f.pdf}
 [Viewed October 10, 2010]"
-,annotation="
+,annotation={
 	TREE_PREEMPT_RCU optimizations greatly simplified the old
 	PREEMPT_RCU implementation.
-"
+}
 }
 
 @unpublished{PaulEMcKenney2010LockdepRCU
@@ -2264,12 +2323,11 @@ lot of {Linux} into your technology!!!"
 ,month="February"
 ,year="2010"
 ,day="1"
-,note="Available:
-\url{https://lwn.net/Articles/371986/}
-[Viewed June 4, 2010]"
-,annotation="
+,note="\url{https://lwn.net/Articles/371986/}"
+,annotation={
 	CONFIG_PROVE_RCU, or at least an early version.
-"
+	[Viewed June 4, 2010]
+}
 }
 
 @unpublished{AviKivity2010KVM2RCU
@@ -2280,10 +2338,10 @@ lot of {Linux} into your technology!!!"
 ,note="Available:
 \url{http://www.mail-archive.com/kvm@vger.kernel.org/msg28640.html}
 [Viewed March 20, 2010]"
-,annotation="
+,annotation={
 	Use of RCU permits KVM to increase the size of guest OSes from
 	16 CPUs to 64 CPUs.
-"
+}
 }
 
 @unpublished{HerbertXu2010RCUResizeHash
@@ -2297,7 +2355,19 @@ lot of {Linux} into your technology!!!"
 ,annotation={
 	Use a pair of list_head structures to support RCU-protected
 	resizable hash tables.
-}}
+}
+}
+
+@mastersthesis{AbhinavDuggal2010Masters
+,author="Abhinav Duggal"
+,title="Stopping Data Races Using Redflag"
+,school="Stony Brook University"
+,year="2010"
+,annotation={
+	Data-race detector incorporating RCU.
+	http://www.filesystems.org/docs/abhinav-thesis/abhinav_thesis.pdf
+}
+}
 
 @article{JoshTriplett2010RPHash
 ,author="Josh Triplett and Paul E. McKenney and Jonathan Walpole"
@@ -2310,7 +2380,8 @@ lot of {Linux} into your technology!!!"
 ,annotation={
 	RP fun with hash tables.
 	http://portal.acm.org/citation.cfm?id=1842733.1842750
-}}
+}
+}
 
 @unpublished{PaulEMcKenney2010RCUAPI
 ,Author="Paul E. McKenney"
@@ -2318,12 +2389,11 @@ lot of {Linux} into your technology!!!"
 ,month="December"
 ,day="8"
 ,year="2010"
-,note="Available:
-\url{http://lwn.net/Articles/418853/}
-[Viewed December 8, 2010]"
-,annotation="
+,note="\url{http://lwn.net/Articles/418853/}"
+,annotation={
 	Includes updated software-engineering features.
-"
+	[Viewed December 8, 2010]
+}
 }
 
 @mastersthesis{AndrejPodzimek2010masters
@@ -2338,7 +2408,8 @@ lot of {Linux} into your technology!!!"
 	Reviews RCU implementations and creates a few for OpenSolaris.
 	Drives quiescent-state detection from RCU read-side primitives,
 	in a manner roughly similar to that of Jim Houston.
-}}
+}
+}
 
 @unpublished{LinusTorvalds2011Linux2:6:38:rc1:NPigginVFS
 ,Author="Linus Torvalds"
@@ -2358,7 +2429,8 @@ lot of {Linux} into your technology!!!"
 	of the most expensive parts of path component lookup, which was the
 	d_lock on every component lookup. So I'm seeing improvements of 30-50%
 	on some seriously pathname-lookup intensive loads."
-}}
+}
+}
 
 @techreport{JoshTriplett2011RPScalableCorrectOrdering
 ,author = {Josh Triplett and Philip W. Howard and Paul E. McKenney and Jonathan Walpole}
@@ -2392,12 +2464,12 @@ lot of {Linux} into your technology!!!"
 ,number="US Patent 7,953,778"
 ,month="May"
 ,pages="34"
-,annotation="
+,annotation={
 	Maintains an array of generation numbers to track in-flight
 	updates and keeps an additional level of indirection to allow
 	readers to confine themselves to the desired snapshot of the
 	data structure.
-"
+}
 }
 
 @inproceedings{Triplett:2011:RPHash
@@ -2408,7 +2480,7 @@ lot of {Linux} into your technology!!!"
 ,year = {2011}
 ,pages = {145--158}
 ,numpages = {14}
-,url={http://www.usenix.org/event/atc11/tech/final_files/atc11_proceedings.pdf}
+,url={http://www.usenix.org/event/atc11/tech/final_files/Triplett.pdf}
 ,publisher = {The USENIX Association}
 ,address = {Portland, OR USA}
 }
@@ -2419,27 +2491,58 @@ lot of {Linux} into your technology!!!"
 ,month="July"
 ,day="27"
 ,year="2011"
-,note="Available:
-\url{http://lwn.net/Articles/453002/}
-[Viewed July 27, 2011]"
-,annotation="
+,note="\url{http://lwn.net/Articles/453002/}"
+,annotation={
 	Analysis of the RCU trainwreck in Linux kernel 3.0.
-"
+	[Viewed July 27, 2011]
+}
 }
 
 @unpublished{NeilBrown2011MeetTheLockers
 ,Author="Neil Brown"
-,Title="Meet the Lockers"
+,Title="Meet the {Lockers}"
 ,month="August"
 ,day="3"
 ,year="2011"
 ,note="Available:
 \url{http://lwn.net/Articles/453685/}
 [Viewed September 2, 2011]"
-,annotation="
+,annotation={
 	The Locker family as an analogy for locking, reference counting,
 	RCU, and seqlock.
-"
+}
+}
+
+@inproceedings{Seyster:2011:RFA:2075416.2075425
+,author = {Seyster, Justin and Radhakrishnan, Prabakar and Katoch, Samriti and Duggal, Abhinav and Stoller, Scott D. and Zadok, Erez}
+,title = {Redflag: a framework for analysis of Kernel-level concurrency}
+,booktitle = {Proceedings of the 11th international conference on Algorithms and architectures for parallel processing - Volume Part I}
+,series = {ICA3PP'11}
+,year = {2011}
+,isbn = {978-3-642-24649-4}
+,location = {Melbourne, Australia}
+,pages = {66--79}
+,numpages = {14}
+,url = {http://dl.acm.org/citation.cfm?id=2075416.2075425}
+,acmid = {2075425}
+,publisher = {Springer-Verlag}
+,address = {Berlin, Heidelberg}
+}
+
+@phdthesis{JoshTriplettPhD
+,author="Josh Triplett"
+,title="Relativistic Causal Ordering: A Memory Model for Scalable Concurrent Data Structures"
+,school="Portland State University"
+,year="2012"
+,annotation={
+	RCU-protected hash tables, barriers vs. read-side traversal order.
+	.
+	If the updater is making changes in the opposite direction from
+	the read-side traveral order, the updater need only execute a
+	memory-barrier instruction, but if in the same direction, the
+	updater needs to wait for a grace period between the individual
+	updates.
+}
 }
 
 @article{MathieuDesnoyers2012URCU
@@ -2459,5 +2562,150 @@ lot of {Linux} into your technology!!!"
 	RCU updates, RCU grace-period batching, update overhead,
 	http://www.rdrop.com/users/paulmck/RCU/urcu-main-accepted.2011.08.30a.pdf
 	http://www.rdrop.com/users/paulmck/RCU/urcu-supp-accepted.2011.08.30a.pdf
+	http://www.computer.org/cms/Computer.org/dl/trans/td/2012/02/extras/ttd2012020375s.pdf
+}
+}
+
+@inproceedings{AustinClements2012RCULinux:mmapsem
+,author = {Austin Clements and Frans Kaashoek and Nickolai Zeldovich}
+,title = {Scalable Address Spaces Using {RCU} Balanced Trees}
+,booktitle = {Architectural Support for Programming Languages and Operating Systems (ASPLOS 2012)}
+,month = {March}
+,year = {2012}
+,pages = {199--210}
+,numpages = {12}
+,publisher = {ACM}
+,address = {London, UK}
+,url="http://people.csail.mit.edu/nickolai/papers/clements-bonsai.pdf"
+}
+
+@unpublished{PaulEMcKenney2012ELCbattery
+,Author="Paul E. McKenney"
+,Title="Making {RCU} Safe For Battery-Powered Devices"
+,month="February"
+,day="15"
+,year="2012"
+,note="Available:
+\url{http://www.rdrop.com/users/paulmck/RCU/RCUdynticks.2012.02.15b.pdf}
+[Viewed March 1, 2012]"
+,annotation={
+	RCU_FAST_NO_HZ, round 2.
+}
+}
+
+@article{GuillermoVigueras2012RCUCrowd
+,author = {Vigueras, Guillermo and Ordu\~{n}a, Juan M. and Lozano, Miguel}
+,day = {25}
+,doi = {10.1007/s11227-012-0766-x}
+,issn = {0920-8542}
+,journal = {The Journal of Supercomputing}
+,keywords = {linux, simulation}
+,month = apr
+,posted-at = {2012-05-03 09:12:04}
+,priority = {2}
+,title = {{A Read-Copy Update based parallel server for distributed crowd simulations}}
+,url = {http://dx.doi.org/10.1007/s11227-012-0766-x}
+,year = {2012}
+}
+
+
+@unpublished{JonCorbet2012ACCESS:ONCE
+,Author="Jon Corbet"
+,Title="{ACCESS\_ONCE()}"
+,month="August"
+,day="1"
+,year="2012"
+,note="\url{http://lwn.net/Articles/508991/}"
+,annotation={
+	A couple of simple specific compiler optimizations that motivate
+	ACCESS_ONCE().
+}
+}
+
+@unpublished{AlexeyGotsman2012VerifyGraceExtended
+,Author="Alexey Gotsman and Noam Rinetzky and Hongseok Yang"
+,Title="Verifying Highly Concurrent Algorithms with Grace (extended version)"
+,month="July"
+,day="10"
+,year="2012"
+,note="\url{http://software.imdea.org/~gotsman/papers/recycling-esop13-ext.pdf}"
+,annotation={
+	Separation-logic formulation of RCU uses.
+}
+}
+
+@unpublished{PaulMcKenney2012RCUUsage
+,Author="Paul E. McKenney and Silas Boyd-Wickizer and Jonathan Walpole"
+,Title="{RCU} Usage In the Linux Kernel: One Decade Later"
+,month="September"
+,day="17"
+,year="2012"
+,url=http://rdrop.com/users/paulmck/techreports/survey.2012.09.17a.pdf
+,note="Technical report paulmck.2012.09.17"
+,annotation={
+	Overview of the first variant of no-CBs CPUs for RCU.
+}
+}
+
+@unpublished{JonCorbet2012NOCB
+,Author="Jon Corbet"
+,Title="Relocating RCU callbacks"
+,month="October"
+,day="31"
+,year="2012"
+,note="\url{http://lwn.net/Articles/522262/}"
+,annotation={
+	Overview of the first variant of no-CBs CPUs for RCU.
+}
+}
+
+@phdthesis{JustinSeyster2012PhD
+,author="Justin Seyster"
+,title="Runtime Verification of Kernel-Level Concurrency Using Compiler-Based Instrumentation"
+,school="Stony Brook University"
+,year="2012"
+,annotation={
+	Looking for data races, including those involving RCU.
+	Proposal:
+	http://www.fsl.cs.sunysb.edu/docs/jseyster-proposal/redflag.pdf
+	Dissertation:
+	http://www.fsl.cs.sunysb.edu/docs/jseyster-dissertation/redflag.pdf
+}
+}
+
+@unpublished{PaulEMcKenney2013RCUUsage
+,Author="Paul E. McKenney and Silas Boyd-Wickizer and Jonathan Walpole"
+,Title="{RCU} Usage in the {Linux} Kernel: One Decade Later"
+,month="February"
+,day="24"
+,year="2013"
+,note="\url{http://rdrop.com/users/paulmck/techreports/RCUUsage.2013.02.24a.pdf}"
+,annotation={
+	Usage of RCU within the Linux kernel.
+}
+}
+
+@inproceedings{AlexeyGotsman2013ESOPRCU
+,author = {Alexey Gotsman and Noam Rinetzky and Hongseok Yang}
+,title = {Verifying concurrent memory reclamation algorithms with grace}
+,booktitle = {ESOP'13: European Symposium on Programming}
+,year = {2013}
+,pages = {249--269}
+,publisher = {Springer}
+,address = {Rome, Italy}
+,annotation={
+	http://software.imdea.org/~gotsman/papers/recycling-esop13.pdf
+}
+}
+
+@unpublished{PaulEMcKenney2013NoTinyPreempt
+,Author="Paul E. McKenney"
+,Title="Simplifying RCU"
+,month="March"
+,day="6"
+,year="2013"
+,note="\url{http://lwn.net/Articles/541037/}"
+,annotation={
+	Getting rid of TINY_PREEMPT_RCU.
 }
 }
diff --git a/Documentation/RCU/rcubarrier.txt b/Documentation/RCU/rcubarrier.txt
index 2e319d1..b10cfe7 100644
--- a/Documentation/RCU/rcubarrier.txt
+++ b/Documentation/RCU/rcubarrier.txt
@@ -70,10 +70,14 @@ in realtime kernels in order to avoid excessive scheduling latencies.
 
 rcu_barrier()
 
-We instead need the rcu_barrier() primitive. This primitive is similar
-to synchronize_rcu(), but instead of waiting solely for a grace
-period to elapse, it also waits for all outstanding RCU callbacks to
-complete. Pseudo-code using rcu_barrier() is as follows:
+We instead need the rcu_barrier() primitive.  Rather than waiting for
+a grace period to elapse, rcu_barrier() waits for all outstanding RCU
+callbacks to complete.  Please note that rcu_barrier() does -not- imply
+synchronize_rcu(), in particular, if there are no RCU callbacks queued
+anywhere, rcu_barrier() is within its rights to return immediately,
+without waiting for a grace period to elapse.
+
+Pseudo-code using rcu_barrier() is as follows:
 
    1. Prevent any new RCU callbacks from being posted.
    2. Execute rcu_barrier().
diff --git a/Documentation/RCU/torture.txt b/Documentation/RCU/torture.txt
index d8a5023..dac02a6 100644
--- a/Documentation/RCU/torture.txt
+++ b/Documentation/RCU/torture.txt
@@ -42,6 +42,16 @@ fqs_holdoff	Holdoff time (in microseconds) between consecutive calls
 fqs_stutter	Wait time (in seconds) between consecutive bursts
 		of calls to force_quiescent_state().
 
+gp_normal	Make the fake writers use normal synchronous grace-period
+		primitives.
+
+gp_exp		Make the fake writers use expedited synchronous grace-period
+		primitives.  If both gp_normal and gp_exp are set, or
+		if neither gp_normal nor gp_exp are set, then randomly
+		choose the primitive so that about 50% are normal and
+		50% expedited.  By default, neither are set, which
+		gives best overall test coverage.
+
 irqreader	Says to invoke RCU readers from irq level.  This is currently
 		done via timers.  Defaults to "1" for variants of RCU that
 		permit this.  (Or, more accurately, variants of RCU that do
diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index fa5d8a9..c8c42e6 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -531,9 +531,10 @@ dependency barrier to make it work correctly.  Consider the following bit of
 code:
 
 	q = &a;
-	if (p)
+	if (p) {
+		<data dependency barrier>
 		q = &b;
-	<data dependency barrier>
+	}
 	x = *q;
 
 This will not have the desired effect because there is no actual data
@@ -542,9 +543,10 @@ attempting to predict the outcome in advance.  In such a case what's actually
 required is:
 
 	q = &a;
-	if (p)
+	if (p) {
+		<read barrier>
 		q = &b;
-	<read barrier>
+	}
 	x = *q;
 
 
diff --git a/Documentation/timers/NO_HZ.txt b/Documentation/timers/NO_HZ.txt
index 8869758..cca122f 100644
--- a/Documentation/timers/NO_HZ.txt
+++ b/Documentation/timers/NO_HZ.txt
@@ -24,8 +24,8 @@ There are three main ways of managing scheduling-clock interrupts
 	workloads, you will normally -not- want this option.
 
 These three cases are described in the following three sections, followed
-by a third section on RCU-specific considerations and a fourth and final
-section listing known issues.
+by a third section on RCU-specific considerations, a fourth section
+discussing testing, and a fifth and final section listing known issues.
 
 
 NEVER OMIT SCHEDULING-CLOCK TICKS
@@ -121,14 +121,15 @@ boot parameter specifies the adaptive-ticks CPUs.  For example,
 "nohz_full=1,6-8" says that CPUs 1, 6, 7, and 8 are to be adaptive-ticks
 CPUs.  Note that you are prohibited from marking all of the CPUs as
 adaptive-tick CPUs:  At least one non-adaptive-tick CPU must remain
-online to handle timekeeping tasks in order to ensure that system calls
-like gettimeofday() returns accurate values on adaptive-tick CPUs.
-(This is not an issue for CONFIG_NO_HZ_IDLE=y because there are no
-running user processes to observe slight drifts in clock rate.)
-Therefore, the boot CPU is prohibited from entering adaptive-ticks
-mode.  Specifying a "nohz_full=" mask that includes the boot CPU will
-result in a boot-time error message, and the boot CPU will be removed
-from the mask.
+online to handle timekeeping tasks in order to ensure that system
+calls like gettimeofday() returns accurate values on adaptive-tick CPUs.
+(This is not an issue for CONFIG_NO_HZ_IDLE=y because there are no running
+user processes to observe slight drifts in clock rate.)  Therefore, the
+boot CPU is prohibited from entering adaptive-ticks mode.  Specifying a
+"nohz_full=" mask that includes the boot CPU will result in a boot-time
+error message, and the boot CPU will be removed from the mask.  Note that
+this means that your system must have at least two CPUs in order for
+CONFIG_NO_HZ_FULL=y to do anything for you.
 
 Alternatively, the CONFIG_NO_HZ_FULL_ALL=y Kconfig parameter specifies
 that all CPUs other than the boot CPU are adaptive-ticks CPUs.  This
@@ -232,6 +233,29 @@ scheduler will decide where to run them, which might or might not be
 where you want them to run.
 
 
+TESTING
+
+So you enable all the OS-jitter features described in this document,
+but do not see any change in your workload's behavior.  Is this because
+your workload isn't affected that much by OS jitter, or is it because
+something else is in the way?  This section helps answer this question
+by providing a simple OS-jitter test suite, which is available on branch
+master of the following git archive:
+
+git://git.kernel.org/pub/scm/linux/kernel/git/frederic/dynticks-testing.git
+
+Clone this archive and follow the instructions in the README file.
+This test procedure will produce a trace that will allow you to evaluate
+whether or not you have succeeded in removing OS jitter from your system.
+If this trace shows that you have removed OS jitter as much as is
+possible, then you can conclude that your workload is not all that
+sensitive to OS jitter.
+
+Note: this test requires that your system have at least two CPUs.
+We do not currently have a good way to remove OS jitter from single-CPU
+systems.
+
+
 KNOWN ISSUES
 
 o	Dyntick-idle slows transitions to and from idle slightly.
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 69732d2..83e2c31 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -122,8 +122,12 @@
 #define TRACE_PRINTKS() VMLINUX_SYMBOL(__start___trace_bprintk_fmt) = .;      \
 			 *(__trace_printk_fmt) /* Trace_printk fmt' pointer */ \
 			 VMLINUX_SYMBOL(__stop___trace_bprintk_fmt) = .;
+#define TRACEPOINT_STR() VMLINUX_SYMBOL(__start___tracepoint_str) = .;	\
+			 *(__tracepoint_str) /* Trace_printk fmt' pointer */ \
+			 VMLINUX_SYMBOL(__stop___tracepoint_str) = .;
 #else
 #define TRACE_PRINTKS()
+#define TRACEPOINT_STR()
 #endif
 
 #ifdef CONFIG_FTRACE_SYSCALLS
@@ -190,7 +194,8 @@
 	VMLINUX_SYMBOL(__stop___verbose) = .;				\
 	LIKELY_PROFILE()		       				\
 	BRANCH_PROFILE()						\
-	TRACE_PRINTKS()
+	TRACE_PRINTKS()							\
+	TRACEPOINT_STR()
 
 /*
  * Data section helpers
diff --git a/include/linux/debugobjects.h b/include/linux/debugobjects.h
index 0e5f578..98ffcbd 100644
--- a/include/linux/debugobjects.h
+++ b/include/linux/debugobjects.h
@@ -63,7 +63,7 @@ struct debug_obj_descr {
 extern void debug_object_init      (void *addr, struct debug_obj_descr *descr);
 extern void
 debug_object_init_on_stack(void *addr, struct debug_obj_descr *descr);
-extern void debug_object_activate  (void *addr, struct debug_obj_descr *descr);
+extern int debug_object_activate  (void *addr, struct debug_obj_descr *descr);
 extern void debug_object_deactivate(void *addr, struct debug_obj_descr *descr);
 extern void debug_object_destroy   (void *addr, struct debug_obj_descr *descr);
 extern void debug_object_free      (void *addr, struct debug_obj_descr *descr);
@@ -85,8 +85,8 @@ static inline void
 debug_object_init      (void *addr, struct debug_obj_descr *descr) { }
 static inline void
 debug_object_init_on_stack(void *addr, struct debug_obj_descr *descr) { }
-static inline void
-debug_object_activate  (void *addr, struct debug_obj_descr *descr) { }
+static inline int
+debug_object_activate  (void *addr, struct debug_obj_descr *descr) { return 0; }
 static inline void
 debug_object_deactivate(void *addr, struct debug_obj_descr *descr) { }
 static inline void
diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 120d57a..5eaa746 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -359,6 +359,40 @@ do {									\
 		__trace_printk(ip, fmt, ##args);			\
 } while (0)
 
+/**
+ * tracepoint_string - register constant persistent string to trace system
+ * @str - a constant persistent string that will be referenced in tracepoints
+ *
+ * If constant strings are being used in tracepoints, it is faster and
+ * more efficient to just save the pointer to the string and reference
+ * that with a printf "%s" instead of saving the string in the ring buffer
+ * and wasting space and time.
+ *
+ * The problem with the above approach is that userspace tools that read
+ * the binary output of the trace buffers do not have access to the string.
+ * Instead they just show the address of the string which is not very
+ * useful to users.
+ *
+ * With tracepoint_string(), the string will be registered to the tracing
+ * system and exported to userspace via the debugfs/tracing/printk_formats
+ * file that maps the string address to the string text. This way userspace
+ * tools that read the binary buffers have a way to map the pointers to
+ * the ASCII strings they represent.
+ *
+ * The @str used must be a constant string and persistent as it would not
+ * make sense to show a string that no longer exists. But it is still fine
+ * to be used with modules, because when modules are unloaded, if they
+ * had tracepoints, the ring buffers are cleared too. As long as the string
+ * does not change during the life of the module, it is fine to use
+ * tracepoint_string() within a module.
+ */
+#define tracepoint_string(str)						\
+	({								\
+		static const char *___tp_str __tracepoint_string = str; \
+		___tp_str;						\
+	})
+#define __tracepoint_string	__attribute__((section("__tracepoint_str")))
+
 #ifdef CONFIG_PERF_EVENTS
 struct perf_event;
 
diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index 97ba4e7..d235e88 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -101,13 +101,13 @@ static inline u64 get_jiffies_64(void)
 #define time_after(a,b)		\
 	(typecheck(unsigned long, a) && \
 	 typecheck(unsigned long, b) && \
-	 ((long)(b) - (long)(a) < 0))
+	 ((long)((b) - (a)) < 0))
 #define time_before(a,b)	time_after(b,a)
 
 #define time_after_eq(a,b)	\
 	(typecheck(unsigned long, a) && \
 	 typecheck(unsigned long, b) && \
-	 ((long)(a) - (long)(b) >= 0))
+	 ((long)((a) - (b)) >= 0))
 #define time_before_eq(a,b)	time_after_eq(b,a)
 
 /*
@@ -130,13 +130,13 @@ static inline u64 get_jiffies_64(void)
 #define time_after64(a,b)	\
 	(typecheck(__u64, a) &&	\
 	 typecheck(__u64, b) && \
-	 ((__s64)(b) - (__s64)(a) < 0))
+	 ((__s64)((b) - (a)) < 0))
 #define time_before64(a,b)	time_after64(b,a)
 
 #define time_after_eq64(a,b)	\
 	(typecheck(__u64, a) && \
 	 typecheck(__u64, b) && \
-	 ((__s64)(a) - (__s64)(b) >= 0))
+	 ((__s64)((a) - (b)) >= 0))
 #define time_before_eq64(a,b)	time_after_eq64(b,a)
 
 #define time_in_range64(a, b, c) \
diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index f4b1001..4106721 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -267,8 +267,9 @@ static inline void list_splice_init_rcu(struct list_head *list,
  */
 #define list_first_or_null_rcu(ptr, type, member) \
 	({struct list_head *__ptr = (ptr); \
-	  struct list_head __rcu *__next = list_next_rcu(__ptr); \
-	  likely(__ptr != __next) ? container_of(__next, type, member) : NULL; \
+	  struct list_head *__next = ACCESS_ONCE(__ptr->next); \
+	  likely(__ptr != __next) ? \
+		list_entry_rcu(__next, type, member) : NULL; \
 	})
 
 /**
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 4b14bdc..f1f1bc3 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -52,7 +52,7 @@ extern int rcutorture_runnable; /* for sysctl */
 #if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
 extern void rcutorture_record_test_transition(void);
 extern void rcutorture_record_progress(unsigned long vernum);
-extern void do_trace_rcu_torture_read(char *rcutorturename,
+extern void do_trace_rcu_torture_read(const char *rcutorturename,
 				      struct rcu_head *rhp,
 				      unsigned long secs,
 				      unsigned long c_old,
@@ -65,7 +65,7 @@ static inline void rcutorture_record_progress(unsigned long vernum)
 {
 }
 #ifdef CONFIG_RCU_TRACE
-extern void do_trace_rcu_torture_read(char *rcutorturename,
+extern void do_trace_rcu_torture_read(const char *rcutorturename,
 				      struct rcu_head *rhp,
 				      unsigned long secs,
 				      unsigned long c_old,
@@ -229,13 +229,9 @@ extern void rcu_irq_exit(void);
 #ifdef CONFIG_RCU_USER_QS
 extern void rcu_user_enter(void);
 extern void rcu_user_exit(void);
-extern void rcu_user_enter_after_irq(void);
-extern void rcu_user_exit_after_irq(void);
 #else
 static inline void rcu_user_enter(void) { }
 static inline void rcu_user_exit(void) { }
-static inline void rcu_user_enter_after_irq(void) { }
-static inline void rcu_user_exit_after_irq(void) { }
 static inline void rcu_user_hooks_switch(struct task_struct *prev,
 					 struct task_struct *next) { }
 #endif /* CONFIG_RCU_USER_QS */
@@ -1015,4 +1011,22 @@ static inline bool rcu_is_nocb_cpu(int cpu) { return false; }
 #endif /* #else #ifdef CONFIG_RCU_NOCB_CPU */
 
 
+/* Only for use by adaptive-ticks code. */
+#ifdef CONFIG_NO_HZ_FULL_SYSIDLE
+extern bool rcu_sys_is_idle(void);
+extern void rcu_sysidle_force_exit(void);
+#else /* #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
+
+static inline bool rcu_sys_is_idle(void)
+{
+	return false;
+}
+
+static inline void rcu_sysidle_force_exit(void)
+{
+}
+
+#endif /* #else #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
+
+
 #endif /* __LINUX_RCUPDATE_H */
diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index 59ebcc8..ee2376c 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -19,12 +19,12 @@
  */
 TRACE_EVENT(rcu_utilization,
 
-	TP_PROTO(char *s),
+	TP_PROTO(const char *s),
 
 	TP_ARGS(s),
 
 	TP_STRUCT__entry(
-		__field(char *, s)
+		__field(const char *, s)
 	),
 
 	TP_fast_assign(
@@ -51,14 +51,14 @@ TRACE_EVENT(rcu_utilization,
  */
 TRACE_EVENT(rcu_grace_period,
 
-	TP_PROTO(char *rcuname, unsigned long gpnum, char *gpevent),
+	TP_PROTO(const char *rcuname, unsigned long gpnum, const char *gpevent),
 
 	TP_ARGS(rcuname, gpnum, gpevent),
 
 	TP_STRUCT__entry(
-		__field(char *, rcuname)
+		__field(const char *, rcuname)
 		__field(unsigned long, gpnum)
-		__field(char *, gpevent)
+		__field(const char *, gpevent)
 	),
 
 	TP_fast_assign(
@@ -89,21 +89,21 @@ TRACE_EVENT(rcu_grace_period,
  */
 TRACE_EVENT(rcu_future_grace_period,
 
-	TP_PROTO(char *rcuname, unsigned long gpnum, unsigned long completed,
+	TP_PROTO(const char *rcuname, unsigned long gpnum, unsigned long completed,
 		 unsigned long c, u8 level, int grplo, int grphi,
-		 char *gpevent),
+		 const char *gpevent),
 
 	TP_ARGS(rcuname, gpnum, completed, c, level, grplo, grphi, gpevent),
 
 	TP_STRUCT__entry(
-		__field(char *, rcuname)
+		__field(const char *, rcuname)
 		__field(unsigned long, gpnum)
 		__field(unsigned long, completed)
 		__field(unsigned long, c)
 		__field(u8, level)
 		__field(int, grplo)
 		__field(int, grphi)
-		__field(char *, gpevent)
+		__field(const char *, gpevent)
 	),
 
 	TP_fast_assign(
@@ -132,13 +132,13 @@ TRACE_EVENT(rcu_future_grace_period,
  */
 TRACE_EVENT(rcu_grace_period_init,
 
-	TP_PROTO(char *rcuname, unsigned long gpnum, u8 level,
+	TP_PROTO(const char *rcuname, unsigned long gpnum, u8 level,
 		 int grplo, int grphi, unsigned long qsmask),
 
 	TP_ARGS(rcuname, gpnum, level, grplo, grphi, qsmask),
 
 	TP_STRUCT__entry(
-		__field(char *, rcuname)
+		__field(const char *, rcuname)
 		__field(unsigned long, gpnum)
 		__field(u8, level)
 		__field(int, grplo)
@@ -168,12 +168,12 @@ TRACE_EVENT(rcu_grace_period_init,
  */
 TRACE_EVENT(rcu_preempt_task,
 
-	TP_PROTO(char *rcuname, int pid, unsigned long gpnum),
+	TP_PROTO(const char *rcuname, int pid, unsigned long gpnum),
 
 	TP_ARGS(rcuname, pid, gpnum),
 
 	TP_STRUCT__entry(
-		__field(char *, rcuname)
+		__field(const char *, rcuname)
 		__field(unsigned long, gpnum)
 		__field(int, pid)
 	),
@@ -195,12 +195,12 @@ TRACE_EVENT(rcu_preempt_task,
  */
 TRACE_EVENT(rcu_unlock_preempted_task,
 
-	TP_PROTO(char *rcuname, unsigned long gpnum, int pid),
+	TP_PROTO(const char *rcuname, unsigned long gpnum, int pid),
 
 	TP_ARGS(rcuname, gpnum, pid),
 
 	TP_STRUCT__entry(
-		__field(char *, rcuname)
+		__field(const char *, rcuname)
 		__field(unsigned long, gpnum)
 		__field(int, pid)
 	),
@@ -224,14 +224,14 @@ TRACE_EVENT(rcu_unlock_preempted_task,
  */
 TRACE_EVENT(rcu_quiescent_state_report,
 
-	TP_PROTO(char *rcuname, unsigned long gpnum,
+	TP_PROTO(const char *rcuname, unsigned long gpnum,
 		 unsigned long mask, unsigned long qsmask,
 		 u8 level, int grplo, int grphi, int gp_tasks),
 
 	TP_ARGS(rcuname, gpnum, mask, qsmask, level, grplo, grphi, gp_tasks),
 
 	TP_STRUCT__entry(
-		__field(char *, rcuname)
+		__field(const char *, rcuname)
 		__field(unsigned long, gpnum)
 		__field(unsigned long, mask)
 		__field(unsigned long, qsmask)
@@ -268,15 +268,15 @@ TRACE_EVENT(rcu_quiescent_state_report,
  */
 TRACE_EVENT(rcu_fqs,
 
-	TP_PROTO(char *rcuname, unsigned long gpnum, int cpu, char *qsevent),
+	TP_PROTO(const char *rcuname, unsigned long gpnum, int cpu, const char *qsevent),
 
 	TP_ARGS(rcuname, gpnum, cpu, qsevent),
 
 	TP_STRUCT__entry(
-		__field(char *, rcuname)
+		__field(const char *, rcuname)
 		__field(unsigned long, gpnum)
 		__field(int, cpu)
-		__field(char *, qsevent)
+		__field(const char *, qsevent)
 	),
 
 	TP_fast_assign(
@@ -308,12 +308,12 @@ TRACE_EVENT(rcu_fqs,
  */
 TRACE_EVENT(rcu_dyntick,
 
-	TP_PROTO(char *polarity, long long oldnesting, long long newnesting),
+	TP_PROTO(const char *polarity, long long oldnesting, long long newnesting),
 
 	TP_ARGS(polarity, oldnesting, newnesting),
 
 	TP_STRUCT__entry(
-		__field(char *, polarity)
+		__field(const char *, polarity)
 		__field(long long, oldnesting)
 		__field(long long, newnesting)
 	),
@@ -352,12 +352,12 @@ TRACE_EVENT(rcu_dyntick,
  */
 TRACE_EVENT(rcu_prep_idle,
 
-	TP_PROTO(char *reason),
+	TP_PROTO(const char *reason),
 
 	TP_ARGS(reason),
 
 	TP_STRUCT__entry(
-		__field(char *, reason)
+		__field(const char *, reason)
 	),
 
 	TP_fast_assign(
@@ -376,13 +376,13 @@ TRACE_EVENT(rcu_prep_idle,
  */
 TRACE_EVENT(rcu_callback,
 
-	TP_PROTO(char *rcuname, struct rcu_head *rhp, long qlen_lazy,
+	TP_PROTO(const char *rcuname, struct rcu_head *rhp, long qlen_lazy,
 		 long qlen),
 
 	TP_ARGS(rcuname, rhp, qlen_lazy, qlen),
 
 	TP_STRUCT__entry(
-		__field(char *, rcuname)
+		__field(const char *, rcuname)
 		__field(void *, rhp)
 		__field(void *, func)
 		__field(long, qlen_lazy)
@@ -412,13 +412,13 @@ TRACE_EVENT(rcu_callback,
  */
 TRACE_EVENT(rcu_kfree_callback,
 
-	TP_PROTO(char *rcuname, struct rcu_head *rhp, unsigned long offset,
+	TP_PROTO(const char *rcuname, struct rcu_head *rhp, unsigned long offset,
 		 long qlen_lazy, long qlen),
 
 	TP_ARGS(rcuname, rhp, offset, qlen_lazy, qlen),
 
 	TP_STRUCT__entry(
-		__field(char *, rcuname)
+		__field(const char *, rcuname)
 		__field(void *, rhp)
 		__field(unsigned long, offset)
 		__field(long, qlen_lazy)
@@ -447,12 +447,12 @@ TRACE_EVENT(rcu_kfree_callback,
  */
 TRACE_EVENT(rcu_batch_start,
 
-	TP_PROTO(char *rcuname, long qlen_lazy, long qlen, long blimit),
+	TP_PROTO(const char *rcuname, long qlen_lazy, long qlen, long blimit),
 
 	TP_ARGS(rcuname, qlen_lazy, qlen, blimit),
 
 	TP_STRUCT__entry(
-		__field(char *, rcuname)
+		__field(const char *, rcuname)
 		__field(long, qlen_lazy)
 		__field(long, qlen)
 		__field(long, blimit)
@@ -477,12 +477,12 @@ TRACE_EVENT(rcu_batch_start,
  */
 TRACE_EVENT(rcu_invoke_callback,
 
-	TP_PROTO(char *rcuname, struct rcu_head *rhp),
+	TP_PROTO(const char *rcuname, struct rcu_head *rhp),
 
 	TP_ARGS(rcuname, rhp),
 
 	TP_STRUCT__entry(
-		__field(char *, rcuname)
+		__field(const char *, rcuname)
 		__field(void *, rhp)
 		__field(void *, func)
 	),
@@ -506,12 +506,12 @@ TRACE_EVENT(rcu_invoke_callback,
  */
 TRACE_EVENT(rcu_invoke_kfree_callback,
 
-	TP_PROTO(char *rcuname, struct rcu_head *rhp, unsigned long offset),
+	TP_PROTO(const char *rcuname, struct rcu_head *rhp, unsigned long offset),
 
 	TP_ARGS(rcuname, rhp, offset),
 
 	TP_STRUCT__entry(
-		__field(char *, rcuname)
+		__field(const char *, rcuname)
 		__field(void *, rhp)
 		__field(unsigned long, offset)
 	),
@@ -539,13 +539,13 @@ TRACE_EVENT(rcu_invoke_kfree_callback,
  */
 TRACE_EVENT(rcu_batch_end,
 
-	TP_PROTO(char *rcuname, int callbacks_invoked,
+	TP_PROTO(const char *rcuname, int callbacks_invoked,
 		 bool cb, bool nr, bool iit, bool risk),
 
 	TP_ARGS(rcuname, callbacks_invoked, cb, nr, iit, risk),
 
 	TP_STRUCT__entry(
-		__field(char *, rcuname)
+		__field(const char *, rcuname)
 		__field(int, callbacks_invoked)
 		__field(bool, cb)
 		__field(bool, nr)
@@ -577,13 +577,13 @@ TRACE_EVENT(rcu_batch_end,
  */
 TRACE_EVENT(rcu_torture_read,
 
-	TP_PROTO(char *rcutorturename, struct rcu_head *rhp,
+	TP_PROTO(const char *rcutorturename, struct rcu_head *rhp,
 		 unsigned long secs, unsigned long c_old, unsigned long c),
 
 	TP_ARGS(rcutorturename, rhp, secs, c_old, c),
 
 	TP_STRUCT__entry(
-		__field(char *, rcutorturename)
+		__field(const char *, rcutorturename)
 		__field(struct rcu_head *, rhp)
 		__field(unsigned long, secs)
 		__field(unsigned long, c_old)
@@ -623,13 +623,13 @@ TRACE_EVENT(rcu_torture_read,
  */
 TRACE_EVENT(rcu_barrier,
 
-	TP_PROTO(char *rcuname, char *s, int cpu, int cnt, unsigned long done),
+	TP_PROTO(const char *rcuname, const char *s, int cpu, int cnt, unsigned long done),
 
 	TP_ARGS(rcuname, s, cpu, cnt, done),
 
 	TP_STRUCT__entry(
-		__field(char *, rcuname)
-		__field(char *, s)
+		__field(const char *, rcuname)
+		__field(const char *, s)
 		__field(int, cpu)
 		__field(int, cnt)
 		__field(unsigned long, done)
diff --git a/init/Kconfig b/init/Kconfig
index fed81b5..cc917d3 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -470,6 +470,7 @@ config TREE_RCU
 config TREE_PREEMPT_RCU
 	bool "Preemptible tree-based hierarchical RCU"
 	depends on PREEMPT
+	select IRQ_WORK
 	help
 	  This option selects the RCU implementation that is
 	  designed for very large SMP systems with hundreds or
diff --git a/kernel/rcu.h b/kernel/rcu.h
index 7f8e759..7713196 100644
--- a/kernel/rcu.h
+++ b/kernel/rcu.h
@@ -67,12 +67,15 @@
 
 extern struct debug_obj_descr rcuhead_debug_descr;
 
-static inline void debug_rcu_head_queue(struct rcu_head *head)
+static inline int debug_rcu_head_queue(struct rcu_head *head)
 {
-	debug_object_activate(head, &rcuhead_debug_descr);
+	int r1;
+
+	r1 = debug_object_activate(head, &rcuhead_debug_descr);
 	debug_object_active_state(head, &rcuhead_debug_descr,
 				  STATE_RCU_HEAD_READY,
 				  STATE_RCU_HEAD_QUEUED);
+	return r1;
 }
 
 static inline void debug_rcu_head_unqueue(struct rcu_head *head)
@@ -83,8 +86,9 @@ static inline void debug_rcu_head_unqueue(struct rcu_head *head)
 	debug_object_deactivate(head, &rcuhead_debug_descr);
 }
 #else	/* !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
-static inline void debug_rcu_head_queue(struct rcu_head *head)
+static inline int debug_rcu_head_queue(struct rcu_head *head)
 {
+	return 0;
 }
 
 static inline void debug_rcu_head_unqueue(struct rcu_head *head)
@@ -94,7 +98,7 @@ static inline void debug_rcu_head_unqueue(struct rcu_head *head)
 
 extern void kfree(const void *);
 
-static inline bool __rcu_reclaim(char *rn, struct rcu_head *head)
+static inline bool __rcu_reclaim(const char *rn, struct rcu_head *head)
 {
 	unsigned long offset = (unsigned long)head->func;
 
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index cce6ba8..33eb462 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -212,43 +212,6 @@ static inline void debug_rcu_head_free(struct rcu_head *head)
 }
 
 /*
- * fixup_init is called when:
- * - an active object is initialized
- */
-static int rcuhead_fixup_init(void *addr, enum debug_obj_state state)
-{
-	struct rcu_head *head = addr;
-
-	switch (state) {
-	case ODEBUG_STATE_ACTIVE:
-		/*
-		 * Ensure that queued callbacks are all executed.
-		 * If we detect that we are nested in a RCU read-side critical
-		 * section, we should simply fail, otherwise we would deadlock.
-		 * In !PREEMPT configurations, there is no way to tell if we are
-		 * in a RCU read-side critical section or not, so we never
-		 * attempt any fixup and just print a warning.
-		 */
-#ifndef CONFIG_PREEMPT
-		WARN_ON_ONCE(1);
-		return 0;
-#endif
-		if (rcu_preempt_depth() != 0 || preempt_count() != 0 ||
-		    irqs_disabled()) {
-			WARN_ON_ONCE(1);
-			return 0;
-		}
-		rcu_barrier();
-		rcu_barrier_sched();
-		rcu_barrier_bh();
-		debug_object_init(head, &rcuhead_debug_descr);
-		return 1;
-	default:
-		return 0;
-	}
-}
-
-/*
  * fixup_activate is called when:
  * - an active object is activated
  * - an unknown object is activated (might be a statically initialized object)
@@ -268,69 +231,8 @@ static int rcuhead_fixup_activate(void *addr, enum debug_obj_state state)
 		debug_object_init(head, &rcuhead_debug_descr);
 		debug_object_activate(head, &rcuhead_debug_descr);
 		return 0;
-
-	case ODEBUG_STATE_ACTIVE:
-		/*
-		 * Ensure that queued callbacks are all executed.
-		 * If we detect that we are nested in a RCU read-side critical
-		 * section, we should simply fail, otherwise we would deadlock.
-		 * In !PREEMPT configurations, there is no way to tell if we are
-		 * in a RCU read-side critical section or not, so we never
-		 * attempt any fixup and just print a warning.
-		 */
-#ifndef CONFIG_PREEMPT
-		WARN_ON_ONCE(1);
-		return 0;
-#endif
-		if (rcu_preempt_depth() != 0 || preempt_count() != 0 ||
-		    irqs_disabled()) {
-			WARN_ON_ONCE(1);
-			return 0;
-		}
-		rcu_barrier();
-		rcu_barrier_sched();
-		rcu_barrier_bh();
-		debug_object_activate(head, &rcuhead_debug_descr);
-		return 1;
 	default:
-		return 0;
-	}
-}
-
-/*
- * fixup_free is called when:
- * - an active object is freed
- */
-static int rcuhead_fixup_free(void *addr, enum debug_obj_state state)
-{
-	struct rcu_head *head = addr;
-
-	switch (state) {
-	case ODEBUG_STATE_ACTIVE:
-		/*
-		 * Ensure that queued callbacks are all executed.
-		 * If we detect that we are nested in a RCU read-side critical
-		 * section, we should simply fail, otherwise we would deadlock.
-		 * In !PREEMPT configurations, there is no way to tell if we are
-		 * in a RCU read-side critical section or not, so we never
-		 * attempt any fixup and just print a warning.
-		 */
-#ifndef CONFIG_PREEMPT
-		WARN_ON_ONCE(1);
-		return 0;
-#endif
-		if (rcu_preempt_depth() != 0 || preempt_count() != 0 ||
-		    irqs_disabled()) {
-			WARN_ON_ONCE(1);
-			return 0;
-		}
-		rcu_barrier();
-		rcu_barrier_sched();
-		rcu_barrier_bh();
-		debug_object_free(head, &rcuhead_debug_descr);
 		return 1;
-	default:
-		return 0;
 	}
 }
 
@@ -369,15 +271,13 @@ EXPORT_SYMBOL_GPL(destroy_rcu_head_on_stack);
 
 struct debug_obj_descr rcuhead_debug_descr = {
 	.name = "rcu_head",
-	.fixup_init = rcuhead_fixup_init,
 	.fixup_activate = rcuhead_fixup_activate,
-	.fixup_free = rcuhead_fixup_free,
 };
 EXPORT_SYMBOL_GPL(rcuhead_debug_descr);
 #endif /* #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD */
 
 #if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU) || defined(CONFIG_RCU_TRACE)
-void do_trace_rcu_torture_read(char *rcutorturename, struct rcu_head *rhp,
+void do_trace_rcu_torture_read(const char *rcutorturename, struct rcu_head *rhp,
 			       unsigned long secs,
 			       unsigned long c_old, unsigned long c)
 {
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index aa34411..9ed6075 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -264,7 +264,7 @@ void rcu_check_callbacks(int cpu, int user)
  */
 static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp)
 {
-	char *rn = NULL;
+	const char *rn = NULL;
 	struct rcu_head *next, *list;
 	unsigned long flags;
 	RCU_TRACE(int cb_count = 0);
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 0cd385a..280d06c 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -36,7 +36,7 @@ struct rcu_ctrlblk {
 	RCU_TRACE(unsigned long gp_start); /* Start time for stalls. */
 	RCU_TRACE(unsigned long ticks_this_gp); /* Statistic for stalls. */
 	RCU_TRACE(unsigned long jiffies_stall); /* Jiffies at next stall. */
-	RCU_TRACE(char *name);		/* Name of RCU type. */
+	RCU_TRACE(const char *name);	/* Name of RCU type. */
 };
 
 /* Definition for rcupdate control block. */
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index f4871e5..be63101 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -52,72 +52,78 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com> and Josh Triplett <josh@freedesktop.org>");
 
-static int nreaders = -1;	/* # reader threads, defaults to 2*ncpus */
-static int nfakewriters = 4;	/* # fake writer threads */
-static int stat_interval = 60;	/* Interval between stats, in seconds. */
-				/*  Zero means "only at end of test". */
-static bool verbose;		/* Print more debug info. */
-static bool test_no_idle_hz = true;
-				/* Test RCU support for tickless idle CPUs. */
-static int shuffle_interval = 3; /* Interval between shuffles (in sec)*/
-static int stutter = 5;		/* Start/stop testing interval (in sec) */
-static int irqreader = 1;	/* RCU readers from irq (timers). */
-static int fqs_duration;	/* Duration of bursts (us), 0 to disable. */
-static int fqs_holdoff;		/* Hold time within burst (us). */
-static int fqs_stutter = 3;	/* Wait time between bursts (s). */
-static int n_barrier_cbs;	/* Number of callbacks to test RCU barriers. */
-static int onoff_interval;	/* Wait time between CPU hotplugs, 0=disable. */
-static int onoff_holdoff;	/* Seconds after boot before CPU hotplugs. */
-static int shutdown_secs;	/* Shutdown time (s).  <=0 for no shutdown. */
-static int stall_cpu;		/* CPU-stall duration (s).  0 for no stall. */
-static int stall_cpu_holdoff = 10; /* Time to wait until stall (s).  */
-static int test_boost = 1;	/* Test RCU prio boost: 0=no, 1=maybe, 2=yes. */
-static int test_boost_interval = 7; /* Interval between boost tests, seconds. */
-static int test_boost_duration = 4; /* Duration of each boost test, seconds. */
-static char *torture_type = "rcu"; /* What RCU implementation to torture. */
-
-module_param(nreaders, int, 0444);
-MODULE_PARM_DESC(nreaders, "Number of RCU reader threads");
-module_param(nfakewriters, int, 0444);
-MODULE_PARM_DESC(nfakewriters, "Number of RCU fake writer threads");
-module_param(stat_interval, int, 0644);
-MODULE_PARM_DESC(stat_interval, "Number of seconds between stats printk()s");
-module_param(verbose, bool, 0444);
-MODULE_PARM_DESC(verbose, "Enable verbose debugging printk()s");
-module_param(test_no_idle_hz, bool, 0444);
-MODULE_PARM_DESC(test_no_idle_hz, "Test support for tickless idle CPUs");
-module_param(shuffle_interval, int, 0444);
-MODULE_PARM_DESC(shuffle_interval, "Number of seconds between shuffles");
-module_param(stutter, int, 0444);
-MODULE_PARM_DESC(stutter, "Number of seconds to run/halt test");
-module_param(irqreader, int, 0444);
-MODULE_PARM_DESC(irqreader, "Allow RCU readers from irq handlers");
+static int fqs_duration;
 module_param(fqs_duration, int, 0444);
-MODULE_PARM_DESC(fqs_duration, "Duration of fqs bursts (us)");
+MODULE_PARM_DESC(fqs_duration, "Duration of fqs bursts (us), 0 to disable");
+static int fqs_holdoff;
 module_param(fqs_holdoff, int, 0444);
 MODULE_PARM_DESC(fqs_holdoff, "Holdoff time within fqs bursts (us)");
+static int fqs_stutter = 3;
 module_param(fqs_stutter, int, 0444);
 MODULE_PARM_DESC(fqs_stutter, "Wait time between fqs bursts (s)");
+static bool gp_exp;
+module_param(gp_exp, bool, 0444);
+MODULE_PARM_DESC(gp_exp, "Use expedited GP wait primitives");
+static bool gp_normal;
+module_param(gp_normal, bool, 0444);
+MODULE_PARM_DESC(gp_normal, "Use normal (non-expedited) GP wait primitives");
+static int irqreader = 1;
+module_param(irqreader, int, 0444);
+MODULE_PARM_DESC(irqreader, "Allow RCU readers from irq handlers");
+static int n_barrier_cbs;
 module_param(n_barrier_cbs, int, 0444);
 MODULE_PARM_DESC(n_barrier_cbs, "# of callbacks/kthreads for barrier testing");
-module_param(onoff_interval, int, 0444);
-MODULE_PARM_DESC(onoff_interval, "Time between CPU hotplugs (s), 0=disable");
+static int nfakewriters = 4;
+module_param(nfakewriters, int, 0444);
+MODULE_PARM_DESC(nfakewriters, "Number of RCU fake writer threads");
+static int nreaders = -1;
+module_param(nreaders, int, 0444);
+MODULE_PARM_DESC(nreaders, "Number of RCU reader threads");
+static int object_debug;
+module_param(object_debug, int, 0444);
+MODULE_PARM_DESC(object_debug, "Enable debug-object double call_rcu() testing");
+static int onoff_holdoff;
 module_param(onoff_holdoff, int, 0444);
 MODULE_PARM_DESC(onoff_holdoff, "Time after boot before CPU hotplugs (s)");
+static int onoff_interval;
+module_param(onoff_interval, int, 0444);
+MODULE_PARM_DESC(onoff_interval, "Time between CPU hotplugs (s), 0=disable");
+static int shuffle_interval = 3;
+module_param(shuffle_interval, int, 0444);
+MODULE_PARM_DESC(shuffle_interval, "Number of seconds between shuffles");
+static int shutdown_secs;
 module_param(shutdown_secs, int, 0444);
-MODULE_PARM_DESC(shutdown_secs, "Shutdown time (s), zero to disable.");
+MODULE_PARM_DESC(shutdown_secs, "Shutdown time (s), <= zero to disable.");
+static int stall_cpu;
 module_param(stall_cpu, int, 0444);
 MODULE_PARM_DESC(stall_cpu, "Stall duration (s), zero to disable.");
+static int stall_cpu_holdoff = 10;
 module_param(stall_cpu_holdoff, int, 0444);
 MODULE_PARM_DESC(stall_cpu_holdoff, "Time to wait before starting stall (s).");
+static int stat_interval = 60;
+module_param(stat_interval, int, 0644);
+MODULE_PARM_DESC(stat_interval, "Number of seconds between stats printk()s");
+static int stutter = 5;
+module_param(stutter, int, 0444);
+MODULE_PARM_DESC(stutter, "Number of seconds to run/halt test");
+static int test_boost = 1;
 module_param(test_boost, int, 0444);
 MODULE_PARM_DESC(test_boost, "Test RCU prio boost: 0=no, 1=maybe, 2=yes.");
-module_param(test_boost_interval, int, 0444);
-MODULE_PARM_DESC(test_boost_interval, "Interval between boost tests, seconds.");
+static int test_boost_duration = 4;
 module_param(test_boost_duration, int, 0444);
 MODULE_PARM_DESC(test_boost_duration, "Duration of each boost test, seconds.");
+static int test_boost_interval = 7;
+module_param(test_boost_interval, int, 0444);
+MODULE_PARM_DESC(test_boost_interval, "Interval between boost tests, seconds.");
+static bool test_no_idle_hz = true;
+module_param(test_no_idle_hz, bool, 0444);
+MODULE_PARM_DESC(test_no_idle_hz, "Test support for tickless idle CPUs");
+static char *torture_type = "rcu";
 module_param(torture_type, charp, 0444);
-MODULE_PARM_DESC(torture_type, "Type of RCU to torture (rcu, rcu_bh, srcu)");
+MODULE_PARM_DESC(torture_type, "Type of RCU to torture (rcu, rcu_bh, ...)");
+static bool verbose;
+module_param(verbose, bool, 0444);
+MODULE_PARM_DESC(verbose, "Enable verbose debugging printk()s");
 
 #define TORTURE_FLAG "-torture:"
 #define PRINTK_STRING(s) \
@@ -267,7 +273,7 @@ rcutorture_shutdown_notify(struct notifier_block *unused1,
  * Absorb kthreads into a kernel function that won't return, so that
  * they won't ever access module text or data again.
  */
-static void rcutorture_shutdown_absorb(char *title)
+static void rcutorture_shutdown_absorb(const char *title)
 {
 	if (ACCESS_ONCE(fullstop) == FULLSTOP_SHUTDOWN) {
 		pr_notice(
@@ -337,7 +343,7 @@ rcu_random(struct rcu_random_state *rrsp)
 }
 
 static void
-rcu_stutter_wait(char *title)
+rcu_stutter_wait(const char *title)
 {
 	while (stutter_pause_test || !rcutorture_runnable) {
 		if (rcutorture_runnable)
@@ -360,13 +366,14 @@ struct rcu_torture_ops {
 	int (*completed)(void);
 	void (*deferred_free)(struct rcu_torture *p);
 	void (*sync)(void);
+	void (*exp_sync)(void);
 	void (*call)(struct rcu_head *head, void (*func)(struct rcu_head *rcu));
 	void (*cb_barrier)(void);
 	void (*fqs)(void);
 	int (*stats)(char *page);
 	int irq_capable;
 	int can_boost;
-	char *name;
+	const char *name;
 };
 
 static struct rcu_torture_ops *cur_ops;
@@ -443,81 +450,27 @@ static void rcu_torture_deferred_free(struct rcu_torture *p)
 	call_rcu(&p->rtort_rcu, rcu_torture_cb);
 }
 
-static struct rcu_torture_ops rcu_ops = {
-	.init		= NULL,
-	.readlock	= rcu_torture_read_lock,
-	.read_delay	= rcu_read_delay,
-	.readunlock	= rcu_torture_read_unlock,
-	.completed	= rcu_torture_completed,
-	.deferred_free	= rcu_torture_deferred_free,
-	.sync		= synchronize_rcu,
-	.call		= call_rcu,
-	.cb_barrier	= rcu_barrier,
-	.fqs		= rcu_force_quiescent_state,
-	.stats		= NULL,
-	.irq_capable	= 1,
-	.can_boost	= rcu_can_boost(),
-	.name		= "rcu"
-};
-
-static void rcu_sync_torture_deferred_free(struct rcu_torture *p)
-{
-	int i;
-	struct rcu_torture *rp;
-	struct rcu_torture *rp1;
-
-	cur_ops->sync();
-	list_add(&p->rtort_free, &rcu_torture_removed);
-	list_for_each_entry_safe(rp, rp1, &rcu_torture_removed, rtort_free) {
-		i = rp->rtort_pipe_count;
-		if (i > RCU_TORTURE_PIPE_LEN)
-			i = RCU_TORTURE_PIPE_LEN;
-		atomic_inc(&rcu_torture_wcount[i]);
-		if (++rp->rtort_pipe_count >= RCU_TORTURE_PIPE_LEN) {
-			rp->rtort_mbtest = 0;
-			list_del(&rp->rtort_free);
-			rcu_torture_free(rp);
-		}
-	}
-}
-
 static void rcu_sync_torture_init(void)
 {
 	INIT_LIST_HEAD(&rcu_torture_removed);
 }
 
-static struct rcu_torture_ops rcu_sync_ops = {
+static struct rcu_torture_ops rcu_ops = {
 	.init		= rcu_sync_torture_init,
 	.readlock	= rcu_torture_read_lock,
 	.read_delay	= rcu_read_delay,
 	.readunlock	= rcu_torture_read_unlock,
 	.completed	= rcu_torture_completed,
-	.deferred_free	= rcu_sync_torture_deferred_free,
+	.deferred_free	= rcu_torture_deferred_free,
 	.sync		= synchronize_rcu,
-	.call		= NULL,
-	.cb_barrier	= NULL,
-	.fqs		= rcu_force_quiescent_state,
-	.stats		= NULL,
-	.irq_capable	= 1,
-	.can_boost	= rcu_can_boost(),
-	.name		= "rcu_sync"
-};
-
-static struct rcu_torture_ops rcu_expedited_ops = {
-	.init		= rcu_sync_torture_init,
-	.readlock	= rcu_torture_read_lock,
-	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
-	.readunlock	= rcu_torture_read_unlock,
-	.completed	= rcu_no_completed,
-	.deferred_free	= rcu_sync_torture_deferred_free,
-	.sync		= synchronize_rcu_expedited,
-	.call		= NULL,
-	.cb_barrier	= NULL,
+	.exp_sync	= synchronize_rcu_expedited,
+	.call		= call_rcu,
+	.cb_barrier	= rcu_barrier,
 	.fqs		= rcu_force_quiescent_state,
 	.stats		= NULL,
 	.irq_capable	= 1,
 	.can_boost	= rcu_can_boost(),
-	.name		= "rcu_expedited"
+	.name		= "rcu"
 };
 
 /*
@@ -546,13 +499,14 @@ static void rcu_bh_torture_deferred_free(struct rcu_torture *p)
 }
 
 static struct rcu_torture_ops rcu_bh_ops = {
-	.init		= NULL,
+	.init		= rcu_sync_torture_init,
 	.readlock	= rcu_bh_torture_read_lock,
 	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
 	.readunlock	= rcu_bh_torture_read_unlock,
 	.completed	= rcu_bh_torture_completed,
 	.deferred_free	= rcu_bh_torture_deferred_free,
 	.sync		= synchronize_rcu_bh,
+	.exp_sync	= synchronize_rcu_bh_expedited,
 	.call		= call_rcu_bh,
 	.cb_barrier	= rcu_barrier_bh,
 	.fqs		= rcu_bh_force_quiescent_state,
@@ -561,38 +515,6 @@ static struct rcu_torture_ops rcu_bh_ops = {
 	.name		= "rcu_bh"
 };
 
-static struct rcu_torture_ops rcu_bh_sync_ops = {
-	.init		= rcu_sync_torture_init,
-	.readlock	= rcu_bh_torture_read_lock,
-	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
-	.readunlock	= rcu_bh_torture_read_unlock,
-	.completed	= rcu_bh_torture_completed,
-	.deferred_free	= rcu_sync_torture_deferred_free,
-	.sync		= synchronize_rcu_bh,
-	.call		= NULL,
-	.cb_barrier	= NULL,
-	.fqs		= rcu_bh_force_quiescent_state,
-	.stats		= NULL,
-	.irq_capable	= 1,
-	.name		= "rcu_bh_sync"
-};
-
-static struct rcu_torture_ops rcu_bh_expedited_ops = {
-	.init		= rcu_sync_torture_init,
-	.readlock	= rcu_bh_torture_read_lock,
-	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
-	.readunlock	= rcu_bh_torture_read_unlock,
-	.completed	= rcu_bh_torture_completed,
-	.deferred_free	= rcu_sync_torture_deferred_free,
-	.sync		= synchronize_rcu_bh_expedited,
-	.call		= NULL,
-	.cb_barrier	= NULL,
-	.fqs		= rcu_bh_force_quiescent_state,
-	.stats		= NULL,
-	.irq_capable	= 1,
-	.name		= "rcu_bh_expedited"
-};
-
 /*
  * Definitions for srcu torture testing.
  */
@@ -667,6 +589,11 @@ static int srcu_torture_stats(char *page)
 	return cnt;
 }
 
+static void srcu_torture_synchronize_expedited(void)
+{
+	synchronize_srcu_expedited(&srcu_ctl);
+}
+
 static struct rcu_torture_ops srcu_ops = {
 	.init		= rcu_sync_torture_init,
 	.readlock	= srcu_torture_read_lock,
@@ -675,45 +602,13 @@ static struct rcu_torture_ops srcu_ops = {
 	.completed	= srcu_torture_completed,
 	.deferred_free	= srcu_torture_deferred_free,
 	.sync		= srcu_torture_synchronize,
+	.exp_sync	= srcu_torture_synchronize_expedited,
 	.call		= srcu_torture_call,
 	.cb_barrier	= srcu_torture_barrier,
 	.stats		= srcu_torture_stats,
 	.name		= "srcu"
 };
 
-static struct rcu_torture_ops srcu_sync_ops = {
-	.init		= rcu_sync_torture_init,
-	.readlock	= srcu_torture_read_lock,
-	.read_delay	= srcu_read_delay,
-	.readunlock	= srcu_torture_read_unlock,
-	.completed	= srcu_torture_completed,
-	.deferred_free	= rcu_sync_torture_deferred_free,
-	.sync		= srcu_torture_synchronize,
-	.call		= NULL,
-	.cb_barrier	= NULL,
-	.stats		= srcu_torture_stats,
-	.name		= "srcu_sync"
-};
-
-static void srcu_torture_synchronize_expedited(void)
-{
-	synchronize_srcu_expedited(&srcu_ctl);
-}
-
-static struct rcu_torture_ops srcu_expedited_ops = {
-	.init		= rcu_sync_torture_init,
-	.readlock	= srcu_torture_read_lock,
-	.read_delay	= srcu_read_delay,
-	.readunlock	= srcu_torture_read_unlock,
-	.completed	= srcu_torture_completed,
-	.deferred_free	= rcu_sync_torture_deferred_free,
-	.sync		= srcu_torture_synchronize_expedited,
-	.call		= NULL,
-	.cb_barrier	= NULL,
-	.stats		= srcu_torture_stats,
-	.name		= "srcu_expedited"
-};
-
 /*
  * Definitions for sched torture testing.
  */
@@ -742,6 +637,8 @@ static struct rcu_torture_ops sched_ops = {
 	.completed	= rcu_no_completed,
 	.deferred_free	= rcu_sched_torture_deferred_free,
 	.sync		= synchronize_sched,
+	.exp_sync	= synchronize_sched_expedited,
+	.call		= call_rcu_sched,
 	.cb_barrier	= rcu_barrier_sched,
 	.fqs		= rcu_sched_force_quiescent_state,
 	.stats		= NULL,
@@ -749,35 +646,6 @@ static struct rcu_torture_ops sched_ops = {
 	.name		= "sched"
 };
 
-static struct rcu_torture_ops sched_sync_ops = {
-	.init		= rcu_sync_torture_init,
-	.readlock	= sched_torture_read_lock,
-	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
-	.readunlock	= sched_torture_read_unlock,
-	.completed	= rcu_no_completed,
-	.deferred_free	= rcu_sync_torture_deferred_free,
-	.sync		= synchronize_sched,
-	.cb_barrier	= NULL,
-	.fqs		= rcu_sched_force_quiescent_state,
-	.stats		= NULL,
-	.name		= "sched_sync"
-};
-
-static struct rcu_torture_ops sched_expedited_ops = {
-	.init		= rcu_sync_torture_init,
-	.readlock	= sched_torture_read_lock,
-	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
-	.readunlock	= sched_torture_read_unlock,
-	.completed	= rcu_no_completed,
-	.deferred_free	= rcu_sync_torture_deferred_free,
-	.sync		= synchronize_sched_expedited,
-	.cb_barrier	= NULL,
-	.fqs		= rcu_sched_force_quiescent_state,
-	.stats		= NULL,
-	.irq_capable	= 1,
-	.name		= "sched_expedited"
-};
-
 /*
  * RCU torture priority-boost testing.  Runs one real-time thread per
  * CPU for moderate bursts, repeatedly registering RCU callbacks and
@@ -927,9 +795,10 @@ rcu_torture_fqs(void *arg)
 static int
 rcu_torture_writer(void *arg)
 {
+	bool exp;
 	int i;
-	long oldbatch = rcu_batches_completed();
 	struct rcu_torture *rp;
+	struct rcu_torture *rp1;
 	struct rcu_torture *old_rp;
 	static DEFINE_RCU_RANDOM(rand);
 
@@ -954,10 +823,33 @@ rcu_torture_writer(void *arg)
 				i = RCU_TORTURE_PIPE_LEN;
 			atomic_inc(&rcu_torture_wcount[i]);
 			old_rp->rtort_pipe_count++;
-			cur_ops->deferred_free(old_rp);
+			if (gp_normal == gp_exp)
+				exp = !!(rcu_random(&rand) & 0x80);
+			else
+				exp = gp_exp;
+			if (!exp) {
+				cur_ops->deferred_free(old_rp);
+			} else {
+				cur_ops->exp_sync();
+				list_add(&old_rp->rtort_free,
+					 &rcu_torture_removed);
+				list_for_each_entry_safe(rp, rp1,
+							 &rcu_torture_removed,
+							 rtort_free) {
+					i = rp->rtort_pipe_count;
+					if (i > RCU_TORTURE_PIPE_LEN)
+						i = RCU_TORTURE_PIPE_LEN;
+					atomic_inc(&rcu_torture_wcount[i]);
+					if (++rp->rtort_pipe_count >=
+					    RCU_TORTURE_PIPE_LEN) {
+						rp->rtort_mbtest = 0;
+						list_del(&rp->rtort_free);
+						rcu_torture_free(rp);
+					}
+				 }
+			}
 		}
 		rcutorture_record_progress(++rcu_torture_current_version);
-		oldbatch = cur_ops->completed();
 		rcu_stutter_wait("rcu_torture_writer");
 	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
 	VERBOSE_PRINTK_STRING("rcu_torture_writer task stopping");
@@ -983,10 +875,18 @@ rcu_torture_fakewriter(void *arg)
 		schedule_timeout_uninterruptible(1 + rcu_random(&rand)%10);
 		udelay(rcu_random(&rand) & 0x3ff);
 		if (cur_ops->cb_barrier != NULL &&
-		    rcu_random(&rand) % (nfakewriters * 8) == 0)
+		    rcu_random(&rand) % (nfakewriters * 8) == 0) {
 			cur_ops->cb_barrier();
-		else
+		} else if (gp_normal == gp_exp) {
+			if (rcu_random(&rand) & 0x80)
+				cur_ops->sync();
+			else
+				cur_ops->exp_sync();
+		} else if (gp_normal) {
 			cur_ops->sync();
+		} else {
+			cur_ops->exp_sync();
+		}
 		rcu_stutter_wait("rcu_torture_fakewriter");
 	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
 
@@ -1364,7 +1264,7 @@ rcu_torture_stutter(void *arg)
 }
 
 static inline void
-rcu_torture_print_module_parms(struct rcu_torture_ops *cur_ops, char *tag)
+rcu_torture_print_module_parms(struct rcu_torture_ops *cur_ops, const char *tag)
 {
 	pr_alert("%s" TORTURE_FLAG
 		 "--- %s: nreaders=%d nfakewriters=%d "
@@ -1534,7 +1434,13 @@ rcu_torture_onoff(void *arg)
 					 torture_type, cpu);
 			starttime = jiffies;
 			n_online_attempts++;
-			if (cpu_up(cpu) == 0) {
+			ret = cpu_up(cpu);
+			if (ret) {
+				if (verbose)
+					pr_alert("%s" TORTURE_FLAG
+						 "rcu_torture_onoff task: online %d failed: errno %d\n",
+						 torture_type, cpu, ret);
+			} else {
 				if (verbose)
 					pr_alert("%s" TORTURE_FLAG
 						 "rcu_torture_onoff task: onlined %d\n",
@@ -1934,6 +1840,62 @@ rcu_torture_cleanup(void)
 		rcu_torture_print_module_parms(cur_ops, "End of test: SUCCESS");
 }
 
+#ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
+static void rcu_torture_leak_cb(struct rcu_head *rhp)
+{
+}
+
+static void rcu_torture_err_cb(struct rcu_head *rhp)
+{
+	/*
+	 * This -might- happen due to race conditions, but is unlikely.
+	 * The scenario that leads to this happening is that the
+	 * first of the pair of duplicate callbacks is queued,
+	 * someone else starts a grace period that includes that
+	 * callback, then the second of the pair must wait for the
+	 * next grace period.  Unlikely, but can happen.  If it
+	 * does happen, the debug-objects subsystem won't have splatted.
+	 */
+	pr_alert("rcutorture: duplicated callback was invoked.\n");
+}
+#endif /* #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD */
+
+/*
+ * Verify that double-free causes debug-objects to complain, but only
+ * if CONFIG_DEBUG_OBJECTS_RCU_HEAD=y.  Otherwise, say that the test
+ * cannot be carried out.
+ */
+static void rcu_test_debug_objects(void)
+{
+#ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
+	struct rcu_head rh1;
+	struct rcu_head rh2;
+
+	init_rcu_head_on_stack(&rh1);
+	init_rcu_head_on_stack(&rh2);
+	pr_alert("rcutorture: WARN: Duplicate call_rcu() test starting.\n");
+
+	/* Try to queue the rh2 pair of callbacks for the same grace period. */
+	preempt_disable(); /* Prevent preemption from interrupting test. */
+	rcu_read_lock(); /* Make it impossible to finish a grace period. */
+	call_rcu(&rh1, rcu_torture_leak_cb); /* Start grace period. */
+	local_irq_disable(); /* Make it harder to start a new grace period. */
+	call_rcu(&rh2, rcu_torture_leak_cb);
+	call_rcu(&rh2, rcu_torture_err_cb); /* Duplicate callback. */
+	local_irq_enable();
+	rcu_read_unlock();
+	preempt_enable();
+
+	/* Wait for them all to get done so we can safely return. */
+	rcu_barrier();
+	pr_alert("rcutorture: WARN: Duplicate call_rcu() test complete.\n");
+	destroy_rcu_head_on_stack(&rh1);
+	destroy_rcu_head_on_stack(&rh2);
+#else /* #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD */
+	pr_alert("rcutorture: !CONFIG_DEBUG_OBJECTS_RCU_HEAD, not testing duplicate call_rcu()\n");
+#endif /* #else #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD */
+}
+
 static int __init
 rcu_torture_init(void)
 {
@@ -1941,11 +1903,9 @@ rcu_torture_init(void)
 	int cpu;
 	int firsterr = 0;
 	int retval;
-	static struct rcu_torture_ops *torture_ops[] =
-		{ &rcu_ops, &rcu_sync_ops, &rcu_expedited_ops,
-		  &rcu_bh_ops, &rcu_bh_sync_ops, &rcu_bh_expedited_ops,
-		  &srcu_ops, &srcu_sync_ops, &srcu_expedited_ops,
-		  &sched_ops, &sched_sync_ops, &sched_expedited_ops, };
+	static struct rcu_torture_ops *torture_ops[] = {
+		&rcu_ops, &rcu_bh_ops, &srcu_ops, &sched_ops,
+	};
 
 	mutex_lock(&fullstop_mutex);
 
@@ -2163,6 +2123,8 @@ rcu_torture_init(void)
 		firsterr = retval;
 		goto unwind;
 	}
+	if (object_debug)
+		rcu_test_debug_objects();
 	rcutorture_record_test_transition();
 	mutex_unlock(&fullstop_mutex);
 	return 0;
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 068de3a..32618b3 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -53,18 +53,38 @@
 #include <linux/delay.h>
 #include <linux/stop_machine.h>
 #include <linux/random.h>
+#include <linux/ftrace_event.h>
+#include <linux/suspend.h>
 
 #include "rcutree.h"
 #include <trace/events/rcu.h>
 
 #include "rcu.h"
 
+/*
+ * Strings used in tracepoints need to be exported via the
+ * tracing system such that tools like perf and trace-cmd can
+ * translate the string address pointers to actual text.
+ */
+#define TPS(x)	tracepoint_string(x)
+
 /* Data structures. */
 
 static struct lock_class_key rcu_node_class[RCU_NUM_LVLS];
 static struct lock_class_key rcu_fqs_class[RCU_NUM_LVLS];
 
-#define RCU_STATE_INITIALIZER(sname, sabbr, cr) { \
+/*
+ * In order to export the rcu_state name to the tracing tools, it
+ * needs to be added in the __tracepoint_string section.
+ * This requires defining a separate variable tp_<sname>_varname
+ * that points to the string being used, and this will allow
+ * the tracing userspace tools to be able to decipher the string
+ * address to the matching string.
+ */
+#define RCU_STATE_INITIALIZER(sname, sabbr, cr) \
+static char sname##_varname[] = #sname; \
+static const char *tp_##sname##_varname __used __tracepoint_string = sname##_varname; \
+struct rcu_state sname##_state = { \
 	.level = { &sname##_state.node[0] }, \
 	.call = cr, \
 	.fqs_state = RCU_GP_IDLE, \
@@ -75,16 +95,13 @@ static struct lock_class_key rcu_fqs_class[RCU_NUM_LVLS];
 	.orphan_donetail = &sname##_state.orphan_donelist, \
 	.barrier_mutex = __MUTEX_INITIALIZER(sname##_state.barrier_mutex), \
 	.onoff_mutex = __MUTEX_INITIALIZER(sname##_state.onoff_mutex), \
-	.name = #sname, \
+	.name = sname##_varname, \
 	.abbr = sabbr, \
-}
-
-struct rcu_state rcu_sched_state =
-	RCU_STATE_INITIALIZER(rcu_sched, 's', call_rcu_sched);
-DEFINE_PER_CPU(struct rcu_data, rcu_sched_data);
+}; \
+DEFINE_PER_CPU(struct rcu_data, sname##_data)
 
-struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh, 'b', call_rcu_bh);
-DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
+RCU_STATE_INITIALIZER(rcu_sched, 's', call_rcu_sched);
+RCU_STATE_INITIALIZER(rcu_bh, 'b', call_rcu_bh);
 
 static struct rcu_state *rcu_state;
 LIST_HEAD(rcu_struct_flavors);
@@ -178,7 +195,7 @@ void rcu_sched_qs(int cpu)
 	struct rcu_data *rdp = &per_cpu(rcu_sched_data, cpu);
 
 	if (rdp->passed_quiesce == 0)
-		trace_rcu_grace_period("rcu_sched", rdp->gpnum, "cpuqs");
+		trace_rcu_grace_period(TPS("rcu_sched"), rdp->gpnum, TPS("cpuqs"));
 	rdp->passed_quiesce = 1;
 }
 
@@ -187,7 +204,7 @@ void rcu_bh_qs(int cpu)
 	struct rcu_data *rdp = &per_cpu(rcu_bh_data, cpu);
 
 	if (rdp->passed_quiesce == 0)
-		trace_rcu_grace_period("rcu_bh", rdp->gpnum, "cpuqs");
+		trace_rcu_grace_period(TPS("rcu_bh"), rdp->gpnum, TPS("cpuqs"));
 	rdp->passed_quiesce = 1;
 }
 
@@ -198,16 +215,20 @@ void rcu_bh_qs(int cpu)
  */
 void rcu_note_context_switch(int cpu)
 {
-	trace_rcu_utilization("Start context switch");
+	trace_rcu_utilization(TPS("Start context switch"));
 	rcu_sched_qs(cpu);
 	rcu_preempt_note_context_switch(cpu);
-	trace_rcu_utilization("End context switch");
+	trace_rcu_utilization(TPS("End context switch"));
 }
 EXPORT_SYMBOL_GPL(rcu_note_context_switch);
 
 DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
 	.dynticks_nesting = DYNTICK_TASK_EXIT_IDLE,
 	.dynticks = ATOMIC_INIT(1),
+#ifdef CONFIG_NO_HZ_FULL_SYSIDLE
+	.dynticks_idle_nesting = DYNTICK_TASK_NEST_VALUE,
+	.dynticks_idle = ATOMIC_INIT(1),
+#endif /* #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
 };
 
 static long blimit = 10;	/* Maximum callbacks per rcu_do_batch. */
@@ -226,7 +247,10 @@ module_param(jiffies_till_next_fqs, ulong, 0644);
 
 static void rcu_start_gp_advanced(struct rcu_state *rsp, struct rcu_node *rnp,
 				  struct rcu_data *rdp);
-static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *));
+static void force_qs_rnp(struct rcu_state *rsp,
+			 int (*f)(struct rcu_data *rsp, bool *isidle,
+				  unsigned long *maxj),
+			 bool *isidle, unsigned long *maxj);
 static void force_quiescent_state(struct rcu_state *rsp);
 static int rcu_pending(int cpu);
 
@@ -345,11 +369,11 @@ static struct rcu_node *rcu_get_root(struct rcu_state *rsp)
 static void rcu_eqs_enter_common(struct rcu_dynticks *rdtp, long long oldval,
 				bool user)
 {
-	trace_rcu_dyntick("Start", oldval, rdtp->dynticks_nesting);
+	trace_rcu_dyntick(TPS("Start"), oldval, rdtp->dynticks_nesting);
 	if (!user && !is_idle_task(current)) {
 		struct task_struct *idle = idle_task(smp_processor_id());
 
-		trace_rcu_dyntick("Error on entry: not idle task", oldval, 0);
+		trace_rcu_dyntick(TPS("Error on entry: not idle task"), oldval, 0);
 		ftrace_dump(DUMP_ORIG);
 		WARN_ONCE(1, "Current pid: %d comm: %s / Idle pid: %d comm: %s",
 			  current->pid, current->comm,
@@ -411,6 +435,7 @@ void rcu_idle_enter(void)
 
 	local_irq_save(flags);
 	rcu_eqs_enter(false);
+	rcu_sysidle_enter(&__get_cpu_var(rcu_dynticks), 0);
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(rcu_idle_enter);
@@ -428,27 +453,6 @@ void rcu_user_enter(void)
 {
 	rcu_eqs_enter(1);
 }
-
-/**
- * rcu_user_enter_after_irq - inform RCU that we are going to resume userspace
- * after the current irq returns.
- *
- * This is similar to rcu_user_enter() but in the context of a non-nesting
- * irq. After this call, RCU enters into idle mode when the interrupt
- * returns.
- */
-void rcu_user_enter_after_irq(void)
-{
-	unsigned long flags;
-	struct rcu_dynticks *rdtp;
-
-	local_irq_save(flags);
-	rdtp = &__get_cpu_var(rcu_dynticks);
-	/* Ensure this irq is interrupting a non-idle RCU state.  */
-	WARN_ON_ONCE(!(rdtp->dynticks_nesting & DYNTICK_TASK_MASK));
-	rdtp->dynticks_nesting = 1;
-	local_irq_restore(flags);
-}
 #endif /* CONFIG_RCU_USER_QS */
 
 /**
@@ -479,9 +483,10 @@ void rcu_irq_exit(void)
 	rdtp->dynticks_nesting--;
 	WARN_ON_ONCE(rdtp->dynticks_nesting < 0);
 	if (rdtp->dynticks_nesting)
-		trace_rcu_dyntick("--=", oldval, rdtp->dynticks_nesting);
+		trace_rcu_dyntick(TPS("--="), oldval, rdtp->dynticks_nesting);
 	else
 		rcu_eqs_enter_common(rdtp, oldval, true);
+	rcu_sysidle_enter(rdtp, 1);
 	local_irq_restore(flags);
 }
 
@@ -501,11 +506,11 @@ static void rcu_eqs_exit_common(struct rcu_dynticks *rdtp, long long oldval,
 	smp_mb__after_atomic_inc();  /* See above. */
 	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
 	rcu_cleanup_after_idle(smp_processor_id());
-	trace_rcu_dyntick("End", oldval, rdtp->dynticks_nesting);
+	trace_rcu_dyntick(TPS("End"), oldval, rdtp->dynticks_nesting);
 	if (!user && !is_idle_task(current)) {
 		struct task_struct *idle = idle_task(smp_processor_id());
 
-		trace_rcu_dyntick("Error on exit: not idle task",
+		trace_rcu_dyntick(TPS("Error on exit: not idle task"),
 				  oldval, rdtp->dynticks_nesting);
 		ftrace_dump(DUMP_ORIG);
 		WARN_ONCE(1, "Current pid: %d comm: %s / Idle pid: %d comm: %s",
@@ -550,6 +555,7 @@ void rcu_idle_exit(void)
 
 	local_irq_save(flags);
 	rcu_eqs_exit(false);
+	rcu_sysidle_exit(&__get_cpu_var(rcu_dynticks), 0);
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(rcu_idle_exit);
@@ -565,28 +571,6 @@ void rcu_user_exit(void)
 {
 	rcu_eqs_exit(1);
 }
-
-/**
- * rcu_user_exit_after_irq - inform RCU that we won't resume to userspace
- * idle mode after the current non-nesting irq returns.
- *
- * This is similar to rcu_user_exit() but in the context of an irq.
- * This is called when the irq has interrupted a userspace RCU idle mode
- * context. When the current non-nesting interrupt returns after this call,
- * the CPU won't restore the RCU idle mode.
- */
-void rcu_user_exit_after_irq(void)
-{
-	unsigned long flags;
-	struct rcu_dynticks *rdtp;
-
-	local_irq_save(flags);
-	rdtp = &__get_cpu_var(rcu_dynticks);
-	/* Ensure we are interrupting an RCU idle mode. */
-	WARN_ON_ONCE(rdtp->dynticks_nesting & DYNTICK_TASK_NEST_MASK);
-	rdtp->dynticks_nesting += DYNTICK_TASK_EXIT_IDLE;
-	local_irq_restore(flags);
-}
 #endif /* CONFIG_RCU_USER_QS */
 
 /**
@@ -620,9 +604,10 @@ void rcu_irq_enter(void)
 	rdtp->dynticks_nesting++;
 	WARN_ON_ONCE(rdtp->dynticks_nesting == 0);
 	if (oldval)
-		trace_rcu_dyntick("++=", oldval, rdtp->dynticks_nesting);
+		trace_rcu_dyntick(TPS("++="), oldval, rdtp->dynticks_nesting);
 	else
 		rcu_eqs_exit_common(rdtp, oldval, true);
+	rcu_sysidle_exit(rdtp, 1);
 	local_irq_restore(flags);
 }
 
@@ -746,9 +731,11 @@ static int rcu_is_cpu_rrupt_from_idle(void)
  * credit them with an implicit quiescent state.  Return 1 if this CPU
  * is in dynticks idle mode, which is an extended quiescent state.
  */
-static int dyntick_save_progress_counter(struct rcu_data *rdp)
+static int dyntick_save_progress_counter(struct rcu_data *rdp,
+					 bool *isidle, unsigned long *maxj)
 {
 	rdp->dynticks_snap = atomic_add_return(0, &rdp->dynticks->dynticks);
+	rcu_sysidle_check_cpu(rdp, isidle, maxj);
 	return (rdp->dynticks_snap & 0x1) == 0;
 }
 
@@ -758,7 +745,8 @@ static int dyntick_save_progress_counter(struct rcu_data *rdp)
  * idle state since the last call to dyntick_save_progress_counter()
  * for this same CPU, or by virtue of having been offline.
  */
-static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
+static int rcu_implicit_dynticks_qs(struct rcu_data *rdp,
+				    bool *isidle, unsigned long *maxj)
 {
 	unsigned int curr;
 	unsigned int snap;
@@ -775,7 +763,7 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
 	 * of the current RCU grace period.
 	 */
 	if ((curr & 0x1) == 0 || UINT_CMP_GE(curr, snap + 2)) {
-		trace_rcu_fqs(rdp->rsp->name, rdp->gpnum, rdp->cpu, "dti");
+		trace_rcu_fqs(rdp->rsp->name, rdp->gpnum, rdp->cpu, TPS("dti"));
 		rdp->dynticks_fqs++;
 		return 1;
 	}
@@ -795,7 +783,7 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
 		return 0;  /* Grace period is not old enough. */
 	barrier();
 	if (cpu_is_offline(rdp->cpu)) {
-		trace_rcu_fqs(rdp->rsp->name, rdp->gpnum, rdp->cpu, "ofl");
+		trace_rcu_fqs(rdp->rsp->name, rdp->gpnum, rdp->cpu, TPS("ofl"));
 		rdp->offline_fqs++;
 		return 1;
 	}
@@ -1032,7 +1020,7 @@ static unsigned long rcu_cbs_completed(struct rcu_state *rsp,
  * rcu_nocb_wait_gp().
  */
 static void trace_rcu_future_gp(struct rcu_node *rnp, struct rcu_data *rdp,
-				unsigned long c, char *s)
+				unsigned long c, const char *s)
 {
 	trace_rcu_future_grace_period(rdp->rsp->name, rnp->gpnum,
 				      rnp->completed, c, rnp->level,
@@ -1058,9 +1046,9 @@ rcu_start_future_gp(struct rcu_node *rnp, struct rcu_data *rdp)
 	 * grace period is already marked as needed, return to the caller.
 	 */
 	c = rcu_cbs_completed(rdp->rsp, rnp);
-	trace_rcu_future_gp(rnp, rdp, c, "Startleaf");
+	trace_rcu_future_gp(rnp, rdp, c, TPS("Startleaf"));
 	if (rnp->need_future_gp[c & 0x1]) {
-		trace_rcu_future_gp(rnp, rdp, c, "Prestartleaf");
+		trace_rcu_future_gp(rnp, rdp, c, TPS("Prestartleaf"));
 		return c;
 	}
 
@@ -1074,7 +1062,7 @@ rcu_start_future_gp(struct rcu_node *rnp, struct rcu_data *rdp)
 	if (rnp->gpnum != rnp->completed ||
 	    ACCESS_ONCE(rnp->gpnum) != ACCESS_ONCE(rnp->completed)) {
 		rnp->need_future_gp[c & 0x1]++;
-		trace_rcu_future_gp(rnp, rdp, c, "Startedleaf");
+		trace_rcu_future_gp(rnp, rdp, c, TPS("Startedleaf"));
 		return c;
 	}
 
@@ -1102,7 +1090,7 @@ rcu_start_future_gp(struct rcu_node *rnp, struct rcu_data *rdp)
 	 * recorded, trace and leave.
 	 */
 	if (rnp_root->need_future_gp[c & 0x1]) {
-		trace_rcu_future_gp(rnp, rdp, c, "Prestartedroot");
+		trace_rcu_future_gp(rnp, rdp, c, TPS("Prestartedroot"));
 		goto unlock_out;
 	}
 
@@ -1111,9 +1099,9 @@ rcu_start_future_gp(struct rcu_node *rnp, struct rcu_data *rdp)
 
 	/* If a grace period is not already in progress, start one. */
 	if (rnp_root->gpnum != rnp_root->completed) {
-		trace_rcu_future_gp(rnp, rdp, c, "Startedleafroot");
+		trace_rcu_future_gp(rnp, rdp, c, TPS("Startedleafroot"));
 	} else {
-		trace_rcu_future_gp(rnp, rdp, c, "Startedroot");
+		trace_rcu_future_gp(rnp, rdp, c, TPS("Startedroot"));
 		rcu_start_gp_advanced(rdp->rsp, rnp_root, rdp);
 	}
 unlock_out:
@@ -1137,7 +1125,8 @@ static int rcu_future_gp_cleanup(struct rcu_state *rsp, struct rcu_node *rnp)
 	rcu_nocb_gp_cleanup(rsp, rnp);
 	rnp->need_future_gp[c & 0x1] = 0;
 	needmore = rnp->need_future_gp[(c + 1) & 0x1];
-	trace_rcu_future_gp(rnp, rdp, c, needmore ? "CleanupMore" : "Cleanup");
+	trace_rcu_future_gp(rnp, rdp, c,
+			    needmore ? TPS("CleanupMore") : TPS("Cleanup"));
 	return needmore;
 }
 
@@ -1205,9 +1194,9 @@ static void rcu_accelerate_cbs(struct rcu_state *rsp, struct rcu_node *rnp,
 
 	/* Trace depending on how much we were able to accelerate. */
 	if (!*rdp->nxttail[RCU_WAIT_TAIL])
-		trace_rcu_grace_period(rsp->name, rdp->gpnum, "AccWaitCB");
+		trace_rcu_grace_period(rsp->name, rdp->gpnum, TPS("AccWaitCB"));
 	else
-		trace_rcu_grace_period(rsp->name, rdp->gpnum, "AccReadyCB");
+		trace_rcu_grace_period(rsp->name, rdp->gpnum, TPS("AccReadyCB"));
 }
 
 /*
@@ -1273,7 +1262,7 @@ static void __note_gp_changes(struct rcu_state *rsp, struct rcu_node *rnp, struc
 
 		/* Remember that we saw this grace-period completion. */
 		rdp->completed = rnp->completed;
-		trace_rcu_grace_period(rsp->name, rdp->gpnum, "cpuend");
+		trace_rcu_grace_period(rsp->name, rdp->gpnum, TPS("cpuend"));
 	}
 
 	if (rdp->gpnum != rnp->gpnum) {
@@ -1283,7 +1272,7 @@ static void __note_gp_changes(struct rcu_state *rsp, struct rcu_node *rnp, struc
 		 * go looking for one.
 		 */
 		rdp->gpnum = rnp->gpnum;
-		trace_rcu_grace_period(rsp->name, rdp->gpnum, "cpustart");
+		trace_rcu_grace_period(rsp->name, rdp->gpnum, TPS("cpustart"));
 		rdp->passed_quiesce = 0;
 		rdp->qs_pending = !!(rnp->qsmask & rdp->grpmask);
 		zero_cpu_stall_ticks(rdp);
@@ -1315,6 +1304,7 @@ static int rcu_gp_init(struct rcu_state *rsp)
 	struct rcu_data *rdp;
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
+	rcu_bind_gp_kthread();
 	raw_spin_lock_irq(&rnp->lock);
 	rsp->gp_flags = 0; /* Clear all flags: New grace period. */
 
@@ -1326,7 +1316,7 @@ static int rcu_gp_init(struct rcu_state *rsp)
 
 	/* Advance to a new grace period and initialize state. */
 	rsp->gpnum++;
-	trace_rcu_grace_period(rsp->name, rsp->gpnum, "start");
+	trace_rcu_grace_period(rsp->name, rsp->gpnum, TPS("start"));
 	record_gp_stall_check_time(rsp);
 	raw_spin_unlock_irq(&rnp->lock);
 
@@ -1379,16 +1369,25 @@ static int rcu_gp_init(struct rcu_state *rsp)
 int rcu_gp_fqs(struct rcu_state *rsp, int fqs_state_in)
 {
 	int fqs_state = fqs_state_in;
+	bool isidle = false;
+	unsigned long maxj;
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
 	rsp->n_force_qs++;
 	if (fqs_state == RCU_SAVE_DYNTICK) {
 		/* Collect dyntick-idle snapshots. */
-		force_qs_rnp(rsp, dyntick_save_progress_counter);
+		if (is_sysidle_rcu_state(rsp)) {
+			isidle = 1;
+			maxj = jiffies - ULONG_MAX / 4;
+		}
+		force_qs_rnp(rsp, dyntick_save_progress_counter,
+			     &isidle, &maxj);
+		rcu_sysidle_report_gp(rsp, isidle, maxj);
 		fqs_state = RCU_FORCE_QS;
 	} else {
 		/* Handle dyntick-idle and offline CPUs. */
-		force_qs_rnp(rsp, rcu_implicit_dynticks_qs);
+		isidle = 0;
+		force_qs_rnp(rsp, rcu_implicit_dynticks_qs, &isidle, &maxj);
 	}
 	/* Clear flag to prevent immediate re-entry. */
 	if (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS) {
@@ -1448,7 +1447,7 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 	rcu_nocb_gp_set(rnp, nocb);
 
 	rsp->completed = rsp->gpnum; /* Declare grace period done. */
-	trace_rcu_grace_period(rsp->name, rsp->completed, "end");
+	trace_rcu_grace_period(rsp->name, rsp->completed, TPS("end"));
 	rsp->fqs_state = RCU_GP_IDLE;
 	rdp = this_cpu_ptr(rsp->rda);
 	rcu_advance_cbs(rsp, rnp, rdp);  /* Reduce false positives below. */
@@ -1558,10 +1557,12 @@ rcu_start_gp_advanced(struct rcu_state *rsp, struct rcu_node *rnp,
 
 	/*
 	 * We can't do wakeups while holding the rnp->lock, as that
-	 * could cause possible deadlocks with the rq->lock. Deter
-	 * the wakeup to interrupt context.
+	 * could cause possible deadlocks with the rq->lock. Defer
+	 * the wakeup to interrupt context.  And don't bother waking
+	 * up the running kthread.
 	 */
-	irq_work_queue(&rsp->wakeup_work);
+	if (current != rsp->gp_kthread)
+		irq_work_queue(&rsp->wakeup_work);
 }
 
 /*
@@ -1857,7 +1858,7 @@ static void rcu_cleanup_dying_cpu(struct rcu_state *rsp)
 	RCU_TRACE(mask = rdp->grpmask);
 	trace_rcu_grace_period(rsp->name,
 			       rnp->gpnum + 1 - !!(rnp->qsmask & mask),
-			       "cpuofl");
+			       TPS("cpuofl"));
 }
 
 /*
@@ -2044,7 +2045,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
  */
 void rcu_check_callbacks(int cpu, int user)
 {
-	trace_rcu_utilization("Start scheduler-tick");
+	trace_rcu_utilization(TPS("Start scheduler-tick"));
 	increment_cpu_stall_ticks();
 	if (user || rcu_is_cpu_rrupt_from_idle()) {
 
@@ -2077,7 +2078,7 @@ void rcu_check_callbacks(int cpu, int user)
 	rcu_preempt_check_callbacks(cpu);
 	if (rcu_pending(cpu))
 		invoke_rcu_core();
-	trace_rcu_utilization("End scheduler-tick");
+	trace_rcu_utilization(TPS("End scheduler-tick"));
 }
 
 /*
@@ -2087,7 +2088,10 @@ void rcu_check_callbacks(int cpu, int user)
  *
  * The caller must have suppressed start of new grace periods.
  */
-static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
+static void force_qs_rnp(struct rcu_state *rsp,
+			 int (*f)(struct rcu_data *rsp, bool *isidle,
+				  unsigned long *maxj),
+			 bool *isidle, unsigned long *maxj)
 {
 	unsigned long bit;
 	int cpu;
@@ -2110,9 +2114,12 @@ static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
 		cpu = rnp->grplo;
 		bit = 1;
 		for (; cpu <= rnp->grphi; cpu++, bit <<= 1) {
-			if ((rnp->qsmask & bit) != 0 &&
-			    f(per_cpu_ptr(rsp->rda, cpu)))
-				mask |= bit;
+			if ((rnp->qsmask & bit) != 0) {
+				if ((rnp->qsmaskinit & bit) != 0)
+					*isidle = 0;
+				if (f(per_cpu_ptr(rsp->rda, cpu), isidle, maxj))
+					mask |= bit;
+			}
 		}
 		if (mask != 0) {
 
@@ -2208,10 +2215,10 @@ static void rcu_process_callbacks(struct softirq_action *unused)
 
 	if (cpu_is_offline(smp_processor_id()))
 		return;
-	trace_rcu_utilization("Start RCU core");
+	trace_rcu_utilization(TPS("Start RCU core"));
 	for_each_rcu_flavor(rsp)
 		__rcu_process_callbacks(rsp);
-	trace_rcu_utilization("End RCU core");
+	trace_rcu_utilization(TPS("End RCU core"));
 }
 
 /*
@@ -2287,6 +2294,13 @@ static void __call_rcu_core(struct rcu_state *rsp, struct rcu_data *rdp,
 }
 
 /*
+ * RCU callback function to leak a callback.
+ */
+static void rcu_leak_callback(struct rcu_head *rhp)
+{
+}
+
+/*
  * Helper function for call_rcu() and friends.  The cpu argument will
  * normally be -1, indicating "currently running CPU".  It may specify
  * a CPU only if that CPU is a no-CBs CPU.  Currently, only _rcu_barrier()
@@ -2300,7 +2314,12 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	struct rcu_data *rdp;
 
 	WARN_ON_ONCE((unsigned long)head & 0x3); /* Misaligned rcu_head! */
-	debug_rcu_head_queue(head);
+	if (debug_rcu_head_queue(head)) {
+		/* Probable double call_rcu(), so leak the callback. */
+		ACCESS_ONCE(head->func) = rcu_leak_callback;
+		WARN_ONCE(1, "__call_rcu(): Leaked duplicate callback\n");
+		return;
+	}
 	head->func = func;
 	head->next = NULL;
 
@@ -2720,7 +2739,7 @@ static int rcu_cpu_has_callbacks(int cpu, bool *all_lazy)
  * Helper function for _rcu_barrier() tracing.  If tracing is disabled,
  * the compiler is expected to optimize this away.
  */
-static void _rcu_barrier_trace(struct rcu_state *rsp, char *s,
+static void _rcu_barrier_trace(struct rcu_state *rsp, const char *s,
 			       int cpu, unsigned long done)
 {
 	trace_rcu_barrier(rsp->name, s, cpu,
@@ -2785,9 +2804,20 @@ static void _rcu_barrier(struct rcu_state *rsp)
 	 * transition.  The "if" expression below therefore rounds the old
 	 * value up to the next even number and adds two before comparing.
 	 */
-	snap_done = ACCESS_ONCE(rsp->n_barrier_done);
+	snap_done = rsp->n_barrier_done;
 	_rcu_barrier_trace(rsp, "Check", -1, snap_done);
-	if (ULONG_CMP_GE(snap_done, ((snap + 1) & ~0x1) + 2)) {
+
+	/*
+	 * If the value in snap is odd, we needed to wait for the current
+	 * rcu_barrier() to complete, then wait for the next one, in other
+	 * words, we need the value of snap_done to be three larger than
+	 * the value of snap.  On the other hand, if the value in snap is
+	 * even, we only had to wait for the next rcu_barrier() to complete,
+	 * in other words, we need the value of snap_done to be only two
+	 * greater than the value of snap.  The "(snap + 3) & ~0x1" computes
+	 * this for us (thank you, Linus!).
+	 */
+	if (ULONG_CMP_GE(snap_done, (snap + 3) & ~0x1)) {
 		_rcu_barrier_trace(rsp, "EarlyExit", -1, snap_done);
 		smp_mb(); /* caller's subsequent code after above check. */
 		mutex_unlock(&rsp->barrier_mutex);
@@ -2930,6 +2960,7 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
 	rdp->blimit = blimit;
 	init_callback_list(rdp);  /* Re-enable callbacks on this CPU. */
 	rdp->dynticks->dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
+	rcu_sysidle_init_percpu_data(rdp->dynticks);
 	atomic_set(&rdp->dynticks->dynticks,
 		   (atomic_read(&rdp->dynticks->dynticks) & ~0x1) + 1);
 	raw_spin_unlock(&rnp->lock);		/* irqs remain disabled. */
@@ -2952,7 +2983,7 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
 			rdp->completed = rnp->completed;
 			rdp->passed_quiesce = 0;
 			rdp->qs_pending = 0;
-			trace_rcu_grace_period(rsp->name, rdp->gpnum, "cpuonl");
+			trace_rcu_grace_period(rsp->name, rdp->gpnum, TPS("cpuonl"));
 		}
 		raw_spin_unlock(&rnp->lock); /* irqs already disabled. */
 		rnp = rnp->parent;
@@ -2982,7 +3013,7 @@ static int rcu_cpu_notify(struct notifier_block *self,
 	struct rcu_node *rnp = rdp->mynode;
 	struct rcu_state *rsp;
 
-	trace_rcu_utilization("Start CPU hotplug");
+	trace_rcu_utilization(TPS("Start CPU hotplug"));
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
@@ -3011,7 +3042,26 @@ static int rcu_cpu_notify(struct notifier_block *self,
 	default:
 		break;
 	}
-	trace_rcu_utilization("End CPU hotplug");
+	trace_rcu_utilization(TPS("End CPU hotplug"));
+	return NOTIFY_OK;
+}
+
+static int rcu_pm_notify(struct notifier_block *self,
+			 unsigned long action, void *hcpu)
+{
+	switch (action) {
+	case PM_HIBERNATION_PREPARE:
+	case PM_SUSPEND_PREPARE:
+		if (nr_cpu_ids <= 256) /* Expediting bad for large systems. */
+			rcu_expedited = 1;
+		break;
+	case PM_POST_HIBERNATION:
+	case PM_POST_SUSPEND:
+		rcu_expedited = 0;
+		break;
+	default:
+		break;
+	}
 	return NOTIFY_OK;
 }
 
@@ -3256,6 +3306,7 @@ void __init rcu_init(void)
 	 * or the scheduler are operational.
 	 */
 	cpu_notifier(rcu_cpu_notify, 0);
+	pm_notifier(rcu_pm_notify, 0);
 	for_each_online_cpu(cpu)
 		rcu_cpu_notify(NULL, CPU_UP_PREPARE, (void *)(long)cpu);
 }
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index b383258..5f97eab 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -88,6 +88,14 @@ struct rcu_dynticks {
 				    /* Process level is worth LLONG_MAX/2. */
 	int dynticks_nmi_nesting;   /* Track NMI nesting level. */
 	atomic_t dynticks;	    /* Even value for idle, else odd. */
+#ifdef CONFIG_NO_HZ_FULL_SYSIDLE
+	long long dynticks_idle_nesting;
+				    /* irq/process nesting level from idle. */
+	atomic_t dynticks_idle;	    /* Even value for idle, else odd. */
+				    /*  "Idle" excludes userspace execution. */
+	unsigned long dynticks_idle_jiffies;
+				    /* End of last non-NMI non-idle period. */
+#endif /* #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
 #ifdef CONFIG_RCU_FAST_NO_HZ
 	bool all_lazy;		    /* Are all CPU's CBs lazy? */
 	unsigned long nonlazy_posted;
@@ -445,7 +453,7 @@ struct rcu_state {
 						/*  for CPU stalls. */
 	unsigned long gp_max;			/* Maximum GP duration in */
 						/*  jiffies. */
-	char *name;				/* Name of structure. */
+	const char *name;			/* Name of structure. */
 	char abbr;				/* Abbreviated name. */
 	struct list_head flavors;		/* List of RCU flavors. */
 	struct irq_work wakeup_work;		/* Postponed wakeups */
@@ -545,6 +553,15 @@ static void rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp);
 static void rcu_spawn_nocb_kthreads(struct rcu_state *rsp);
 static void rcu_kick_nohz_cpu(int cpu);
 static bool init_nocb_callback_list(struct rcu_data *rdp);
+static void rcu_sysidle_enter(struct rcu_dynticks *rdtp, int irq);
+static void rcu_sysidle_exit(struct rcu_dynticks *rdtp, int irq);
+static void rcu_sysidle_check_cpu(struct rcu_data *rdp, bool *isidle,
+				  unsigned long *maxj);
+static bool is_sysidle_rcu_state(struct rcu_state *rsp);
+static void rcu_sysidle_report_gp(struct rcu_state *rsp, int isidle,
+				  unsigned long maxj);
+static void rcu_bind_gp_kthread(void);
+static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp);
 
 #endif /* #ifndef RCU_TREE_NONCORE */
 
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 769e12e..130c97b 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -28,7 +28,7 @@
 #include <linux/gfp.h>
 #include <linux/oom.h>
 #include <linux/smpboot.h>
-#include <linux/tick.h>
+#include "time/tick-internal.h"
 
 #define RCU_KTHREAD_PRIO 1
 
@@ -110,9 +110,7 @@ static void __init rcu_bootup_announce_oddness(void)
 
 #ifdef CONFIG_TREE_PREEMPT_RCU
 
-struct rcu_state rcu_preempt_state =
-	RCU_STATE_INITIALIZER(rcu_preempt, 'p', call_rcu);
-DEFINE_PER_CPU(struct rcu_data, rcu_preempt_data);
+RCU_STATE_INITIALIZER(rcu_preempt, 'p', call_rcu);
 static struct rcu_state *rcu_state = &rcu_preempt_state;
 
 static int rcu_preempted_readers_exp(struct rcu_node *rnp);
@@ -169,7 +167,7 @@ static void rcu_preempt_qs(int cpu)
 	struct rcu_data *rdp = &per_cpu(rcu_preempt_data, cpu);
 
 	if (rdp->passed_quiesce == 0)
-		trace_rcu_grace_period("rcu_preempt", rdp->gpnum, "cpuqs");
+		trace_rcu_grace_period(TPS("rcu_preempt"), rdp->gpnum, TPS("cpuqs"));
 	rdp->passed_quiesce = 1;
 	current->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
 }
@@ -388,7 +386,7 @@ void rcu_read_unlock_special(struct task_struct *t)
 		np = rcu_next_node_entry(t, rnp);
 		list_del_init(&t->rcu_node_entry);
 		t->rcu_blocked_node = NULL;
-		trace_rcu_unlock_preempted_task("rcu_preempt",
+		trace_rcu_unlock_preempted_task(TPS("rcu_preempt"),
 						rnp->gpnum, t->pid);
 		if (&t->rcu_node_entry == rnp->gp_tasks)
 			rnp->gp_tasks = np;
@@ -412,7 +410,7 @@ void rcu_read_unlock_special(struct task_struct *t)
 		 */
 		empty_exp_now = !rcu_preempted_readers_exp(rnp);
 		if (!empty && !rcu_preempt_blocked_readers_cgp(rnp)) {
-			trace_rcu_quiescent_state_report("preempt_rcu",
+			trace_rcu_quiescent_state_report(TPS("preempt_rcu"),
 							 rnp->gpnum,
 							 0, rnp->qsmask,
 							 rnp->level,
@@ -1250,12 +1248,12 @@ static int rcu_boost_kthread(void *arg)
 	int spincnt = 0;
 	int more2boost;
 
-	trace_rcu_utilization("Start boost kthread@init");
+	trace_rcu_utilization(TPS("Start boost kthread@init"));
 	for (;;) {
 		rnp->boost_kthread_status = RCU_KTHREAD_WAITING;
-		trace_rcu_utilization("End boost kthread@rcu_wait");
+		trace_rcu_utilization(TPS("End boost kthread@rcu_wait"));
 		rcu_wait(rnp->boost_tasks || rnp->exp_tasks);
-		trace_rcu_utilization("Start boost kthread@rcu_wait");
+		trace_rcu_utilization(TPS("Start boost kthread@rcu_wait"));
 		rnp->boost_kthread_status = RCU_KTHREAD_RUNNING;
 		more2boost = rcu_boost(rnp);
 		if (more2boost)
@@ -1264,14 +1262,14 @@ static int rcu_boost_kthread(void *arg)
 			spincnt = 0;
 		if (spincnt > 10) {
 			rnp->boost_kthread_status = RCU_KTHREAD_YIELDING;
-			trace_rcu_utilization("End boost kthread@rcu_yield");
+			trace_rcu_utilization(TPS("End boost kthread@rcu_yield"));
 			schedule_timeout_interruptible(2);
-			trace_rcu_utilization("Start boost kthread@rcu_yield");
+			trace_rcu_utilization(TPS("Start boost kthread@rcu_yield"));
 			spincnt = 0;
 		}
 	}
 	/* NOTREACHED */
-	trace_rcu_utilization("End boost kthread@notreached");
+	trace_rcu_utilization(TPS("End boost kthread@notreached"));
 	return 0;
 }
 
@@ -1419,7 +1417,7 @@ static void rcu_cpu_kthread(unsigned int cpu)
 	int spincnt;
 
 	for (spincnt = 0; spincnt < 10; spincnt++) {
-		trace_rcu_utilization("Start CPU kthread@rcu_wait");
+		trace_rcu_utilization(TPS("Start CPU kthread@rcu_wait"));
 		local_bh_disable();
 		*statusp = RCU_KTHREAD_RUNNING;
 		this_cpu_inc(rcu_cpu_kthread_loops);
@@ -1431,15 +1429,15 @@ static void rcu_cpu_kthread(unsigned int cpu)
 			rcu_kthread_do_work();
 		local_bh_enable();
 		if (*workp == 0) {
-			trace_rcu_utilization("End CPU kthread@rcu_wait");
+			trace_rcu_utilization(TPS("End CPU kthread@rcu_wait"));
 			*statusp = RCU_KTHREAD_WAITING;
 			return;
 		}
 	}
 	*statusp = RCU_KTHREAD_YIELDING;
-	trace_rcu_utilization("Start CPU kthread@rcu_yield");
+	trace_rcu_utilization(TPS("Start CPU kthread@rcu_yield"));
 	schedule_timeout_interruptible(2);
-	trace_rcu_utilization("End CPU kthread@rcu_yield");
+	trace_rcu_utilization(TPS("End CPU kthread@rcu_yield"));
 	*statusp = RCU_KTHREAD_WAITING;
 }
 
@@ -2202,7 +2200,7 @@ static void rcu_nocb_wait_gp(struct rcu_data *rdp)
 	 * Wait for the grace period.  Do so interruptibly to avoid messing
 	 * up the load average.
 	 */
-	trace_rcu_future_gp(rnp, rdp, c, "StartWait");
+	trace_rcu_future_gp(rnp, rdp, c, TPS("StartWait"));
 	for (;;) {
 		wait_event_interruptible(
 			rnp->nocb_gp_wq[c & 0x1],
@@ -2210,9 +2208,9 @@ static void rcu_nocb_wait_gp(struct rcu_data *rdp)
 		if (likely(d))
 			break;
 		flush_signals(current);
-		trace_rcu_future_gp(rnp, rdp, c, "ResumeWait");
+		trace_rcu_future_gp(rnp, rdp, c, TPS("ResumeWait"));
 	}
-	trace_rcu_future_gp(rnp, rdp, c, "EndWait");
+	trace_rcu_future_gp(rnp, rdp, c, TPS("EndWait"));
 	smp_mb(); /* Ensure that CB invocation happens after GP end. */
 }
 
@@ -2375,3 +2373,425 @@ static void rcu_kick_nohz_cpu(int cpu)
 		smp_send_reschedule(cpu);
 #endif /* #ifdef CONFIG_NO_HZ_FULL */
 }
+
+
+#ifdef CONFIG_NO_HZ_FULL_SYSIDLE
+
+/*
+ * Define RCU flavor that holds sysidle state.  This needs to be the
+ * most active flavor of RCU.
+ */
+#ifdef CONFIG_PREEMPT_RCU
+static struct rcu_state *rcu_sysidle_state = &rcu_preempt_state;
+#else /* #ifdef CONFIG_PREEMPT_RCU */
+static struct rcu_state *rcu_sysidle_state = &rcu_sched_state;
+#endif /* #else #ifdef CONFIG_PREEMPT_RCU */
+
+static int full_sysidle_state;		/* Current system-idle state. */
+#define RCU_SYSIDLE_NOT		0	/* Some CPU is not idle. */
+#define RCU_SYSIDLE_SHORT	1	/* All CPUs idle for brief period. */
+#define RCU_SYSIDLE_LONG	2	/* All CPUs idle for long enough. */
+#define RCU_SYSIDLE_FULL	3	/* All CPUs idle, ready for sysidle. */
+#define RCU_SYSIDLE_FULL_NOTED	4	/* Actually entered sysidle state. */
+
+/*
+ * Invoked to note exit from irq or task transition to idle.  Note that
+ * usermode execution does -not- count as idle here!  After all, we want
+ * to detect full-system idle states, not RCU quiescent states and grace
+ * periods.  The caller must have disabled interrupts.
+ */
+static void rcu_sysidle_enter(struct rcu_dynticks *rdtp, int irq)
+{
+	unsigned long j;
+
+	/* Adjust nesting, check for fully idle. */
+	if (irq) {
+		rdtp->dynticks_idle_nesting--;
+		WARN_ON_ONCE(rdtp->dynticks_idle_nesting < 0);
+		if (rdtp->dynticks_idle_nesting != 0)
+			return;  /* Still not fully idle. */
+	} else {
+		if ((rdtp->dynticks_idle_nesting & DYNTICK_TASK_NEST_MASK) ==
+		    DYNTICK_TASK_NEST_VALUE) {
+			rdtp->dynticks_idle_nesting = 0;
+		} else {
+			rdtp->dynticks_idle_nesting -= DYNTICK_TASK_NEST_VALUE;
+			WARN_ON_ONCE(rdtp->dynticks_idle_nesting < 0);
+			return;  /* Still not fully idle. */
+		}
+	}
+
+	/* Record start of fully idle period. */
+	j = jiffies;
+	ACCESS_ONCE(rdtp->dynticks_idle_jiffies) = j;
+	smp_mb__before_atomic_inc();
+	atomic_inc(&rdtp->dynticks_idle);
+	smp_mb__after_atomic_inc();
+	WARN_ON_ONCE(atomic_read(&rdtp->dynticks_idle) & 0x1);
+}
+
+/*
+ * Unconditionally force exit from full system-idle state.  This is
+ * invoked when a normal CPU exits idle, but must be called separately
+ * for the timekeeping CPU (tick_do_timer_cpu).  The reason for this
+ * is that the timekeeping CPU is permitted to take scheduling-clock
+ * interrupts while the system is in system-idle state, and of course
+ * rcu_sysidle_exit() has no way of distinguishing a scheduling-clock
+ * interrupt from any other type of interrupt.
+ */
+void rcu_sysidle_force_exit(void)
+{
+	int oldstate = ACCESS_ONCE(full_sysidle_state);
+	int newoldstate;
+
+	/*
+	 * Each pass through the following loop attempts to exit full
+	 * system-idle state.  If contention proves to be a problem,
+	 * a trylock-based contention tree could be used here.
+	 */
+	while (oldstate > RCU_SYSIDLE_SHORT) {
+		newoldstate = cmpxchg(&full_sysidle_state,
+				      oldstate, RCU_SYSIDLE_NOT);
+		if (oldstate == newoldstate &&
+		    oldstate == RCU_SYSIDLE_FULL_NOTED) {
+			rcu_kick_nohz_cpu(tick_do_timer_cpu);
+			return; /* We cleared it, done! */
+		}
+		oldstate = newoldstate;
+	}
+	smp_mb(); /* Order initial oldstate fetch vs. later non-idle work. */
+}
+
+/*
+ * Invoked to note entry to irq or task transition from idle.  Note that
+ * usermode execution does -not- count as idle here!  The caller must
+ * have disabled interrupts.
+ */
+static void rcu_sysidle_exit(struct rcu_dynticks *rdtp, int irq)
+{
+	/* Adjust nesting, check for already non-idle. */
+	if (irq) {
+		rdtp->dynticks_idle_nesting++;
+		WARN_ON_ONCE(rdtp->dynticks_idle_nesting <= 0);
+		if (rdtp->dynticks_idle_nesting != 1)
+			return; /* Already non-idle. */
+	} else {
+		/*
+		 * Allow for irq misnesting.  Yes, it really is possible
+		 * to enter an irq handler then never leave it, and maybe
+		 * also vice versa.  Handle both possibilities.
+		 */
+		if (rdtp->dynticks_idle_nesting & DYNTICK_TASK_NEST_MASK) {
+			rdtp->dynticks_idle_nesting += DYNTICK_TASK_NEST_VALUE;
+			WARN_ON_ONCE(rdtp->dynticks_idle_nesting <= 0);
+			return; /* Already non-idle. */
+		} else {
+			rdtp->dynticks_idle_nesting = DYNTICK_TASK_EXIT_IDLE;
+		}
+	}
+
+	/* Record end of idle period. */
+	smp_mb__before_atomic_inc();
+	atomic_inc(&rdtp->dynticks_idle);
+	smp_mb__after_atomic_inc();
+	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks_idle) & 0x1));
+
+	/*
+	 * If we are the timekeeping CPU, we are permitted to be non-idle
+	 * during a system-idle state.  This must be the case, because
+	 * the timekeeping CPU has to take scheduling-clock interrupts
+	 * during the time that the system is transitioning to full
+	 * system-idle state.  This means that the timekeeping CPU must
+	 * invoke rcu_sysidle_force_exit() directly if it does anything
+	 * more than take a scheduling-clock interrupt.
+	 */
+	if (smp_processor_id() == tick_do_timer_cpu)
+		return;
+
+	/* Update system-idle state: We are clearly no longer fully idle! */
+	rcu_sysidle_force_exit();
+}
+
+/*
+ * Check to see if the current CPU is idle.  Note that usermode execution
+ * does not count as idle.  The caller must have disabled interrupts.
+ */
+static void rcu_sysidle_check_cpu(struct rcu_data *rdp, bool *isidle,
+				  unsigned long *maxj)
+{
+	int cur;
+	unsigned long j;
+	struct rcu_dynticks *rdtp = rdp->dynticks;
+
+	/*
+	 * If some other CPU has already reported non-idle, if this is
+	 * not the flavor of RCU that tracks sysidle state, or if this
+	 * is an offline or the timekeeping CPU, nothing to do.
+	 */
+	if (!*isidle || rdp->rsp != rcu_sysidle_state ||
+	    cpu_is_offline(rdp->cpu) || rdp->cpu == tick_do_timer_cpu)
+		return;
+	if (rcu_gp_in_progress(rdp->rsp))
+		WARN_ON_ONCE(smp_processor_id() != tick_do_timer_cpu);
+
+	/* Pick up current idle and NMI-nesting counter and check. */
+	cur = atomic_read(&rdtp->dynticks_idle);
+	if (cur & 0x1) {
+		*isidle = false; /* We are not idle! */
+		return;
+	}
+	smp_mb(); /* Read counters before timestamps. */
+
+	/* Pick up timestamps. */
+	j = ACCESS_ONCE(rdtp->dynticks_idle_jiffies);
+	/* If this CPU entered idle more recently, update maxj timestamp. */
+	if (ULONG_CMP_LT(*maxj, j))
+		*maxj = j;
+}
+
+/*
+ * Is this the flavor of RCU that is handling full-system idle?
+ */
+static bool is_sysidle_rcu_state(struct rcu_state *rsp)
+{
+	return rsp == rcu_sysidle_state;
+}
+
+/*
+ * Bind the grace-period kthread for the sysidle flavor of RCU to the
+ * timekeeping CPU.
+ */
+static void rcu_bind_gp_kthread(void)
+{
+	int cpu = ACCESS_ONCE(tick_do_timer_cpu);
+
+	if (cpu < 0 || cpu >= nr_cpu_ids)
+		return;
+	if (raw_smp_processor_id() != cpu)
+		set_cpus_allowed_ptr(current, cpumask_of(cpu));
+}
+
+/*
+ * Return a delay in jiffies based on the number of CPUs, rcu_node
+ * leaf fanout, and jiffies tick rate.  The idea is to allow larger
+ * systems more time to transition to full-idle state in order to
+ * avoid the cache thrashing that otherwise occur on the state variable.
+ * Really small systems (less than a couple of tens of CPUs) should
+ * instead use a single global atomically incremented counter, and later
+ * versions of this will automatically reconfigure themselves accordingly.
+ */
+static unsigned long rcu_sysidle_delay(void)
+{
+	if (nr_cpu_ids <= CONFIG_NO_HZ_FULL_SYSIDLE_SMALL)
+		return 0;
+	return DIV_ROUND_UP(nr_cpu_ids * HZ, rcu_fanout_leaf * 1000);
+}
+
+/*
+ * Advance the full-system-idle state.  This is invoked when all of
+ * the non-timekeeping CPUs are idle.
+ */
+static void rcu_sysidle(unsigned long j)
+{
+	/* Check the current state. */
+	switch (ACCESS_ONCE(full_sysidle_state)) {
+	case RCU_SYSIDLE_NOT:
+
+		/* First time all are idle, so note a short idle period. */
+		ACCESS_ONCE(full_sysidle_state) = RCU_SYSIDLE_SHORT;
+		break;
+
+	case RCU_SYSIDLE_SHORT:
+
+		/*
+		 * Idle for a bit, time to advance to next state?
+		 * cmpxchg failure means race with non-idle, let them win.
+		 */
+		if (ULONG_CMP_GE(jiffies, j + rcu_sysidle_delay()))
+			(void)cmpxchg(&full_sysidle_state,
+				      RCU_SYSIDLE_SHORT, RCU_SYSIDLE_LONG);
+		break;
+
+	case RCU_SYSIDLE_LONG:
+
+		/*
+		 * Do an additional check pass before advancing to full.
+		 * cmpxchg failure means race with non-idle, let them win.
+		 */
+		if (ULONG_CMP_GE(jiffies, j + rcu_sysidle_delay()))
+			(void)cmpxchg(&full_sysidle_state,
+				      RCU_SYSIDLE_LONG, RCU_SYSIDLE_FULL);
+		break;
+
+	default:
+		break;
+	}
+}
+
+/*
+ * Found a non-idle non-timekeeping CPU, so kick the system-idle state
+ * back to the beginning.
+ */
+static void rcu_sysidle_cancel(void)
+{
+	smp_mb();
+	ACCESS_ONCE(full_sysidle_state) = RCU_SYSIDLE_NOT;
+}
+
+/*
+ * Update the sysidle state based on the results of a force-quiescent-state
+ * scan of the CPUs' dyntick-idle state.
+ */
+static void rcu_sysidle_report(struct rcu_state *rsp, int isidle,
+			       unsigned long maxj, bool gpkt)
+{
+	if (rsp != rcu_sysidle_state)
+		return;  /* Wrong flavor, ignore. */
+	if (gpkt && nr_cpu_ids <= CONFIG_NO_HZ_FULL_SYSIDLE_SMALL)
+		return;  /* Running state machine from timekeeping CPU. */
+	if (isidle)
+		rcu_sysidle(maxj);    /* More idle! */
+	else
+		rcu_sysidle_cancel(); /* Idle is over. */
+}
+
+/*
+ * Wrapper for rcu_sysidle_report() when called from the grace-period
+ * kthread's context.
+ */
+static void rcu_sysidle_report_gp(struct rcu_state *rsp, int isidle,
+				  unsigned long maxj)
+{
+	rcu_sysidle_report(rsp, isidle, maxj, true);
+}
+
+/* Callback and function for forcing an RCU grace period. */
+struct rcu_sysidle_head {
+	struct rcu_head rh;
+	int inuse;
+};
+
+static void rcu_sysidle_cb(struct rcu_head *rhp)
+{
+	struct rcu_sysidle_head *rshp;
+
+	/*
+	 * The following memory barrier is needed to replace the
+	 * memory barriers that would normally be in the memory
+	 * allocator.
+	 */
+	smp_mb();  /* grace period precedes setting inuse. */
+
+	rshp = container_of(rhp, struct rcu_sysidle_head, rh);
+	ACCESS_ONCE(rshp->inuse) = 0;
+}
+
+/*
+ * Check to see if the system is fully idle, other than the timekeeping CPU.
+ * The caller must have disabled interrupts.
+ */
+bool rcu_sys_is_idle(void)
+{
+	static struct rcu_sysidle_head rsh;
+	int rss = ACCESS_ONCE(full_sysidle_state);
+
+	if (WARN_ON_ONCE(smp_processor_id() != tick_do_timer_cpu))
+		return false;
+
+	/* Handle small-system case by doing a full scan of CPUs. */
+	if (nr_cpu_ids <= CONFIG_NO_HZ_FULL_SYSIDLE_SMALL) {
+		int oldrss = rss - 1;
+
+		/*
+		 * One pass to advance to each state up to _FULL.
+		 * Give up if any pass fails to advance the state.
+		 */
+		while (rss < RCU_SYSIDLE_FULL && oldrss < rss) {
+			int cpu;
+			bool isidle = true;
+			unsigned long maxj = jiffies - ULONG_MAX / 4;
+			struct rcu_data *rdp;
+
+			/* Scan all the CPUs looking for nonidle CPUs. */
+			for_each_possible_cpu(cpu) {
+				rdp = per_cpu_ptr(rcu_sysidle_state->rda, cpu);
+				rcu_sysidle_check_cpu(rdp, &isidle, &maxj);
+				if (!isidle)
+					break;
+			}
+			rcu_sysidle_report(rcu_sysidle_state,
+					   isidle, maxj, false);
+			oldrss = rss;
+			rss = ACCESS_ONCE(full_sysidle_state);
+		}
+	}
+
+	/* If this is the first observation of an idle period, record it. */
+	if (rss == RCU_SYSIDLE_FULL) {
+		rss = cmpxchg(&full_sysidle_state,
+			      RCU_SYSIDLE_FULL, RCU_SYSIDLE_FULL_NOTED);
+		return rss == RCU_SYSIDLE_FULL;
+	}
+
+	smp_mb(); /* ensure rss load happens before later caller actions. */
+
+	/* If already fully idle, tell the caller (in case of races). */
+	if (rss == RCU_SYSIDLE_FULL_NOTED)
+		return true;
+
+	/*
+	 * If we aren't there yet, and a grace period is not in flight,
+	 * initiate a grace period.  Either way, tell the caller that
+	 * we are not there yet.  We use an xchg() rather than an assignment
+	 * to make up for the memory barriers that would otherwise be
+	 * provided by the memory allocator.
+	 */
+	if (nr_cpu_ids > CONFIG_NO_HZ_FULL_SYSIDLE_SMALL &&
+	    !rcu_gp_in_progress(rcu_sysidle_state) &&
+	    !rsh.inuse && xchg(&rsh.inuse, 1) == 0)
+		call_rcu(&rsh.rh, rcu_sysidle_cb);
+	return false;
+}
+
+/*
+ * Initialize dynticks sysidle state for CPUs coming online.
+ */
+static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp)
+{
+	rdtp->dynticks_idle_nesting = DYNTICK_TASK_NEST_VALUE;
+}
+
+#else /* #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
+
+static void rcu_sysidle_enter(struct rcu_dynticks *rdtp, int irq)
+{
+}
+
+static void rcu_sysidle_exit(struct rcu_dynticks *rdtp, int irq)
+{
+}
+
+static void rcu_sysidle_check_cpu(struct rcu_data *rdp, bool *isidle,
+				  unsigned long *maxj)
+{
+}
+
+static bool is_sysidle_rcu_state(struct rcu_state *rsp)
+{
+	return false;
+}
+
+static void rcu_bind_gp_kthread(void)
+{
+}
+
+static void rcu_sysidle_report_gp(struct rcu_state *rsp, int isidle,
+				  unsigned long maxj)
+{
+}
+
+static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp)
+{
+}
+
+#endif /* #else #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 70f27e8..3381f09 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -134,6 +134,56 @@ config NO_HZ_FULL_ALL
 	 Note the boot CPU will still be kept outside the range to
 	 handle the timekeeping duty.
 
+config NO_HZ_FULL_SYSIDLE
+	bool "Detect full-system idle state for full dynticks system"
+	depends on NO_HZ_FULL
+	default n
+	help
+	 At least one CPU must keep the scheduling-clock tick running for
+	 timekeeping purposes whenever there is a non-idle CPU, where
+	 "non-idle" also includes dynticks CPUs as long as they are
+	 running non-idle tasks.  Because the underlying adaptive-tick
+	 support cannot distinguish between all CPUs being idle and
+	 all CPUs each running a single task in dynticks mode, the
+	 underlying support simply ensures that there is always a CPU
+	 handling the scheduling-clock tick, whether or not all CPUs
+	 are idle.  This Kconfig option enables scalable detection of
+	 the all-CPUs-idle state, thus allowing the scheduling-clock
+	 tick to be disabled when all CPUs are idle.  Note that scalable
+	 detection of the all-CPUs-idle state means that larger systems
+	 will be slower to declare the all-CPUs-idle state.
+
+	 Say Y if you would like to help debug all-CPUs-idle detection.
+
+	 Say N if you are unsure.
+
+config NO_HZ_FULL_SYSIDLE_SMALL
+	int "Number of CPUs above which large-system approach is used"
+	depends on NO_HZ_FULL_SYSIDLE
+	range 1 NR_CPUS
+	default 8
+	help
+	 The full-system idle detection mechanism takes a lazy approach
+	 on large systems, as is required to attain decent scalability.
+	 However, on smaller systems, scalability is not anywhere near as
+	 large a concern as is energy efficiency.  The sysidle subsystem
+	 therefore uses a fast but non-scalable algorithm for small
+	 systems and a lazier but scalable algorithm for large systems.
+	 This Kconfig parameter defines the number of CPUs in the largest
+	 system that will be considered to be "small".
+
+	 The default value will be fine in most cases.	Battery-powered
+	 systems that (1) enable NO_HZ_FULL_SYSIDLE, (2) have larger
+	 numbers of CPUs, and (3) are suffering from battery-lifetime
+	 problems due to long sysidle latencies might wish to experiment
+	 with larger values for this Kconfig parameter.  On the other
+	 hand, they might be even better served by disabling NO_HZ_FULL
+	 entirely, given that NO_HZ_FULL is intended for HPC and
+	 real-time workloads that at present do not tend to be run on
+	 battery-powered systems.
+
+	 Take the default if you are unsure.
+
 config NO_HZ
 	bool "Old Idle dynticks config"
 	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index afaae41..fe39acd 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1022,6 +1022,9 @@ extern struct list_head ftrace_events;
 extern const char *__start___trace_bprintk_fmt[];
 extern const char *__stop___trace_bprintk_fmt[];
 
+extern const char *__start___tracepoint_str[];
+extern const char *__stop___tracepoint_str[];
+
 void trace_printk_init_buffers(void);
 void trace_printk_start_comm(void);
 int trace_keep_overwrite(struct tracer *tracer, u32 mask, int set);
diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
index a9077c1..2900817 100644
--- a/kernel/trace/trace_printk.c
+++ b/kernel/trace/trace_printk.c
@@ -244,12 +244,31 @@ static const char **find_next(void *v, loff_t *pos)
 {
 	const char **fmt = v;
 	int start_index;
+	int last_index;
 
 	start_index = __stop___trace_bprintk_fmt - __start___trace_bprintk_fmt;
 
 	if (*pos < start_index)
 		return __start___trace_bprintk_fmt + *pos;
 
+	/*
+	 * The __tracepoint_str section is treated the same as the
+	 * __trace_printk_fmt section. The difference is that the
+	 * __trace_printk_fmt section should only be used by trace_printk()
+	 * in a debugging environment, as if anything exists in that section
+	 * the trace_prink() helper buffers are allocated, which would just
+	 * waste space in a production environment.
+	 *
+	 * The __tracepoint_str sections on the other hand are used by
+	 * tracepoints which need to map pointers to their strings to
+	 * the ASCII text for userspace.
+	 */
+	last_index = start_index;
+	start_index = __stop___tracepoint_str - __start___tracepoint_str;
+
+	if (*pos < last_index + start_index)
+		return __start___tracepoint_str + (*pos - last_index);
+
 	return find_next_mod_format(start_index, v, fmt, pos);
 }
 
diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index 37061ed..bf2c8b1 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -381,19 +381,21 @@ void debug_object_init_on_stack(void *addr, struct debug_obj_descr *descr)
  * debug_object_activate - debug checks when an object is activated
  * @addr:	address of the object
  * @descr:	pointer to an object specific debug description structure
+ * Returns 0 for success, -EINVAL for check failed.
  */
-void debug_object_activate(void *addr, struct debug_obj_descr *descr)
+int debug_object_activate(void *addr, struct debug_obj_descr *descr)
 {
 	enum debug_obj_state state;
 	struct debug_bucket *db;
 	struct debug_obj *obj;
 	unsigned long flags;
+	int ret;
 	struct debug_obj o = { .object = addr,
 			       .state = ODEBUG_STATE_NOTAVAILABLE,
 			       .descr = descr };
 
 	if (!debug_objects_enabled)
-		return;
+		return 0;
 
 	db = get_bucket((unsigned long) addr);
 
@@ -405,23 +407,26 @@ void debug_object_activate(void *addr, struct debug_obj_descr *descr)
 		case ODEBUG_STATE_INIT:
 		case ODEBUG_STATE_INACTIVE:
 			obj->state = ODEBUG_STATE_ACTIVE;
+			ret = 0;
 			break;
 
 		case ODEBUG_STATE_ACTIVE:
 			debug_print_object(obj, "activate");
 			state = obj->state;
 			raw_spin_unlock_irqrestore(&db->lock, flags);
-			debug_object_fixup(descr->fixup_activate, addr, state);
-			return;
+			ret = debug_object_fixup(descr->fixup_activate, addr, state);
+			return ret ? -EINVAL : 0;
 
 		case ODEBUG_STATE_DESTROYED:
 			debug_print_object(obj, "activate");
+			ret = -EINVAL;
 			break;
 		default:
+			ret = 0;
 			break;
 		}
 		raw_spin_unlock_irqrestore(&db->lock, flags);
-		return;
+		return ret;
 	}
 
 	raw_spin_unlock_irqrestore(&db->lock, flags);
@@ -431,8 +436,11 @@ void debug_object_activate(void *addr, struct debug_obj_descr *descr)
 	 * true or not.
 	 */
 	if (debug_object_fixup(descr->fixup_activate, addr,
-			   ODEBUG_STATE_NOTAVAILABLE))
+			   ODEBUG_STATE_NOTAVAILABLE)) {
 		debug_print_object(&o, "activate");
+		return -EINVAL;
+	}
+	return 0;
 }
 
 /**
