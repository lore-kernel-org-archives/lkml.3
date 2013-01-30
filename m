Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab3A3P4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 10:56:41 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:17699 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112Ab3A3P4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 10:56:39 -0500
Date: Wed, 30 Jan 2013 10:55:29 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bob Liu <lliubbo@gmail.com>, sjenning@linux.vnet.ibm.com,
        dan.magenheimer@oracle.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, ngupta@vflare.org,
        minchan@kernel.org, mgorman@suse.de, fschmaus@gmail.com,
        andor.daam@googlemail.com, ilendir@googlemail.com
Subject: Re: [PATCH 2/8] mm: frontswap: lazy initialization to allow tmem
 backends to build/run as modules
Message-ID: <20130130155520.GA1272@konrad-lan.dumpdata.com>
References: <1352919432-9699-1-git-send-email-konrad.wilk@oracle.com>
 <1352919432-9699-3-git-send-email-konrad.wilk@oracle.com>
 <20121116151619.aa60acff.akpm@linux-foundation.org>
 <CAA_GA1crg1ngNx2MAv-fJbgKYqSKmkapZHq=8F4QcNgFja1A-w@mail.gmail.com>
 <20121119142516.b2936a7c.akpm@linux-foundation.org>
 <20121127212617.GA13890@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121127212617.GA13890@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 04:26:17PM -0500, Konrad Rzeszutek Wilk wrote:
> On Mon, Nov 19, 2012 at 02:25:16PM -0800, Andrew Morton wrote:
> > On Mon, 19 Nov 2012 08:53:46 +0800
> > Bob Liu <lliubbo@gmail.com> wrote:
> > 
> > > On Sat, Nov 17, 2012 at 7:16 AM, Andrew Morton
> > > <akpm@linux-foundation.org> wrote:
> > > > On Wed, 14 Nov 2012 13:57:06 -0500
> > > > Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > > >
> > > >> From: Dan Magenheimer <dan.magenheimer@oracle.com>
> > > >>
> > > >> With the goal of allowing tmem backends (zcache, ramster, Xen tmem) to be
> > > >> built/loaded as modules rather than built-in and enabled by a boot parameter,
> > > >> this patch provides "lazy initialization", allowing backends to register to
> > > >> frontswap even after swapon was run. Before a backend registers all calls
> > > >> to init are recorded and the creation of tmem_pools delayed until a backend
> > > >> registers or until a frontswap put is attempted.
> > > >>
> > > >>
> > > >> ...
> > > >>
> > > >> --- a/mm/frontswap.c
> > > >> +++ b/mm/frontswap.c
> > > >> @@ -80,6 +80,18 @@ static inline void inc_frontswap_succ_stores(void) { }
> > > >>  static inline void inc_frontswap_failed_stores(void) { }
> > > >>  static inline void inc_frontswap_invalidates(void) { }
> > > >>  #endif
> > > >> +
> > > >> +/*
> > > >> + * When no backend is registered all calls to init are registered and
> > > >
> > > > What is "init"?  Spell it out fully, please.
> > > >
> > > 
> > > I think it's frontswap_init().
> > > swapon will call frontswap_init() and in it we need to call init
> > > function of backends with some parameters
> > > like swap_type.
> > 
> > Well, let's improve that comment please.
> > 
> > > >> + * remembered but fail to create tmem_pools. When a backend registers with
> > > >> + * frontswap the previous calls to init are executed to create tmem_pools
> > > >> + * and set the respective poolids.
> > > >
> > > > Again, seems really hacky.  Why can't we just change callers so they
> > > > call things in the correct order?
> > > >
> > > 
> > > I don't think so, because it asynchronous.
> > > 
> > > The original idea was to make backends like zcache/tmem modularization.
> > > So that it's more convenient and flexible to use and testing.
> > > 
> > > But currently callers like swapon only invoke frontswap_init() once,
> > > it fail if backend not registered.
> > > We have no way to notify swap to call frontswap_init() again when
> > > backend registered in some random time
> > >  in future.
> > 
> > We could add such a way?
> 
> Hey Andrew,
> 
> Sorry for the late email. Right at as you posted your questions I went on vacation :-)
> Let me respond to your email and rebase the patch per your comments/ideas this week.

"This week" turned rather into a large couple of months :-(

Please see inline patch that tries to address the comments you made.

In regards to making swap and frontswap be synchronous and support
module loading - that is a tricky thing. If we wanted the swap system to
call the 'frontswap_init' outside of 'swapon' call, one way to do this would
be to have a notifier chain - which the swap API would subscribe too. The
frontswap API upon being called frontswap_register_ops (so a backend module
has loaded) could kick of the notifier and the swap API would immediately call
frontswap_init.

Something like this:

	swap API starts, makes a call to:
		register_frontswap_notifier(&swap_fnc), wherein

		.notifier_call = swap_notifier just does:

		swap_notifier(void) {

		struct swap_info_struct *p = NULL;
		spin_lock(&swap_lock);                                                  
        	for (type = swap_list.head; type >= 0; type = swap_info[type]->next) { 
                	p = swap_info[type]; 
			frontswap_init(p->type);
		};
		spin_unlock(&swap_lock);
		}

	swapon /dev/XX , makes a call to frontswap_init. Frontswap_init
		ignores it since there are no backend.

	I/Os on the swap device, the calls to frontswap_store/load are
		all returning as there are no backend.

	modprobe zcache -> calls frontswap_register_ops().
		frontswap_register_ops-> kicks the notifier.


As opposed to what this patchset does it by not exposing a notifier but
just queing up which p->type's to call (by having a atomic bitmap) when a
backend has registered.
In this patchset we end up with:

	swap API inits..

	swapon /dev/XX, makes a call to frontswap_init. Frontswap_init
		ignores it since there are no backend, but saves away
		the proper parameters

	I/Os on the swap device, the calls to frontswap_store/load are
		all returning fast as there are no backend.

	modprobe zcache -> calls frontswap_register_ops().
		processes the frontswap_init on the queued up swap_file.
		enables backend_registered, and all I/Os now flow to the
		backend.

The difference here is that we would not queue anymore. My thinking is
go with the queue system, then also implement proper unloading mechanism
(by perhaps have a dummy frontswap_ops or an atomic or static_key
gates to inhibit further frontswap API calls), drain all the swap pages
from the backend to the "regular" swap disk (by using Seth's patchset)
and then allowing the backend to unload.

And then if we decide that bitmap queue is not appropiate (b/c the
swap system can now have more than 32 entries), then revisit this?


>From ebc1f49f6593d4105f4927839bcfdb5162206ac4 Mon Sep 17 00:00:00 2001
From: Dan Magenheimer <dan.magenheimer@oracle.com>
Date: Wed, 14 Nov 2012 18:57:06 +0000
Subject: [PATCH 2/8] mm: frontswap: lazy initialization to allow tmem
 backends to build/run as modules

With the goal of allowing tmem backends (zcache, ramster, Xen tmem) to be
built/loaded as modules rather than built-in and enabled by a boot parameter,
this patch provides "lazy initialization", allowing backends to register to
frontswap even after swapon was run. Before a backend registers all calls
to init are recorded and the creation of tmem_pools delayed until a backend
registers or until a frontswap put is attempted.

Signed-off-by: Stefan Hengelein <ilendir@googlemail.com>
Signed-off-by: Florian Schmaus <fschmaus@gmail.com>
Signed-off-by: Andor Daam <andor.daam@googlemail.com>
Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
[v1: Fixes per Seth Jennings suggestions]
[v2: Removed FRONTSWAP_HAS_.. ]
[v3: Fix up per Bob Liu <lliubbo@gmail.com> recommendations]
[v4: Fix up per Andrew's comments]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 mm/frontswap.c | 95 +++++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 85 insertions(+), 10 deletions(-)

diff --git a/mm/frontswap.c b/mm/frontswap.c
index 2890e67..c05a9db 100644
--- a/mm/frontswap.c
+++ b/mm/frontswap.c
@@ -80,6 +80,46 @@ static inline void inc_frontswap_succ_stores(void) { }
 static inline void inc_frontswap_failed_stores(void) { }
 static inline void inc_frontswap_invalidates(void) { }
 #endif
+
+/*
+ * Due to the asynchronous nature of the backends loading potentially
+ * _after_ the swap system has been activated, we have chokepoints
+ * on all frontswap functions to not call the backend until the backend
+ * has registered.
+ *
+ * Specifically when no backend is registered (nobody called
+ * frontswap_register_ops) all calls to frontswap_init (which is done via
+ * swapon -> enable_swap_info -> frontswap_init) are registered and remembered
+ * (via the setting of need_init bitmap) but fail to create tmem_pools. When a
+ * backend registers with frontswap at some later point the previous
+ * calls to frontswap_init are executed (by iterating over the need_init
+ * bitmap) to create tmem_pools and set the respective poolids. All of that is
+ * guarded by us using atomic bit operations on the 'need_init' bitmap.
+ *
+ * This would not guards us against the user deciding to call swapoff right as
+ * we are calling the backend to initialize (so swapon is in action).
+ * Fortunatly for us, the swapon_mutex has been taked by the callee so we are
+ * OK. The other scenario where calls to frontswap_store (called via
+ * swap_writepage) is racing with frontswap_invalidate_area (called via
+ * swapoff) is again guarded by the swap subsystem.
+ *
+ * While no backend is registered all calls to frontswap_[store|load|
+ * invalidate_area|invalidate_page] are ignored or fail.
+ *
+ * The time between the backend being registered and the swap file system
+ * calling the backend (via the frontswap_* functions) is indeterminate as
+ * backend_registered is not atomic_t (or a value guarded by a spinlock).
+ * That is OK as we are comfortable missing some of these calls to the newly
+ * registered backend.
+ *
+ * Obviously the opposite (unloading the backend) must be done after all
+ * the frontswap_[store|load|invalidate_area|invalidate_page] start
+ * ignorning or failing the requests - at which point backend_registered
+ * would have to be made in some fashion atomic.
+ */
+static DECLARE_BITMAP(need_init, MAX_SWAPFILES);
+static bool backend_registered __read_mostly;
+
 /*
  * Register operations for frontswap, returning previous thus allowing
  * detection of multiple backends and possible nesting.
@@ -87,9 +127,22 @@ static inline void inc_frontswap_invalidates(void) { }
 struct frontswap_ops frontswap_register_ops(struct frontswap_ops *ops)
 {
 	struct frontswap_ops old = frontswap_ops;
+	int i;
 
 	frontswap_ops = *ops;
 	frontswap_enabled = true;
+
+	for (i = 0; i < MAX_SWAPFILES; i++) {
+		if (test_and_clear_bit(i, need_init))
+			(*frontswap_ops.init)(i);
+	}
+	/*
+	 * We MUST have backend_registered set _after_ the frontswap_init's
+	 * have been called. Otherwise __frontswap_store might fail. Hence
+	 * the barrier to make sure compiler does not re-order us.
+	 */
+	barrier();
+	backend_registered = true;
 	return old;
 }
 EXPORT_SYMBOL(frontswap_register_ops);
@@ -119,10 +172,17 @@ void __frontswap_init(unsigned type)
 {
 	struct swap_info_struct *sis = swap_info[type];
 
-	BUG_ON(sis == NULL);
-	if (sis->frontswap_map == NULL)
-		return;
-	frontswap_ops.init(type);
+	if (backend_registered) {
+		BUG_ON(sis == NULL);
+		if (sis->frontswap_map == NULL)
+			return;
+		(*frontswap_ops.init)(type);
+	}
+	else {
+		BUG_ON(type > MAX_SWAPFILES);
+		set_bit(type, need_init);
+	}
+
 }
 EXPORT_SYMBOL(__frontswap_init);
 
@@ -147,6 +207,11 @@ int __frontswap_store(struct page *page)
 	struct swap_info_struct *sis = swap_info[type];
 	pgoff_t offset = swp_offset(entry);
 
+	if (!backend_registered) {
+		inc_frontswap_failed_stores();
+		return ret;
+	}
+
 	BUG_ON(!PageLocked(page));
 	BUG_ON(sis == NULL);
 	if (frontswap_test(sis, offset))
@@ -186,6 +251,9 @@ int __frontswap_load(struct page *page)
 	struct swap_info_struct *sis = swap_info[type];
 	pgoff_t offset = swp_offset(entry);
 
+	if (!backend_registered)
+		return ret;
+
 	BUG_ON(!PageLocked(page));
 	BUG_ON(sis == NULL);
 	if (frontswap_test(sis, offset))
@@ -209,6 +277,9 @@ void __frontswap_invalidate_page(unsigned type, pgoff_t offset)
 {
 	struct swap_info_struct *sis = swap_info[type];
 
+	if (!backend_registered)
+		return;
+
 	BUG_ON(sis == NULL);
 	if (frontswap_test(sis, offset)) {
 		frontswap_ops.invalidate_page(type, offset);
@@ -226,12 +297,15 @@ void __frontswap_invalidate_area(unsigned type)
 {
 	struct swap_info_struct *sis = swap_info[type];
 
-	BUG_ON(sis == NULL);
-	if (sis->frontswap_map == NULL)
-		return;
-	frontswap_ops.invalidate_area(type);
-	atomic_set(&sis->frontswap_pages, 0);
-	memset(sis->frontswap_map, 0, sis->max / sizeof(long));
+	if (backend_registered) {
+		BUG_ON(sis == NULL);
+		if (sis->frontswap_map == NULL)
+			return;
+		(*frontswap_ops.invalidate_area)(type);
+		atomic_set(&sis->frontswap_pages, 0);
+		memset(sis->frontswap_map, 0, sis->max / sizeof(long));
+	}
+	clear_bit(type, need_init);
 }
 EXPORT_SYMBOL(__frontswap_invalidate_area);
 
@@ -364,6 +438,7 @@ static int __init init_frontswap(void)
 	debugfs_create_u64("invalidates", S_IRUGO,
 				root, &frontswap_invalidates);
 #endif
+	frontswap_enabled = 1;
 	return 0;
 }
 
-- 
1.7.11.7

