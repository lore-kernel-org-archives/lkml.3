Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbaCKIaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 04:30:15 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:52120 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbaCKIaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 04:30:10 -0400
X-Original-SENDERIP: 10.177.220.200
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Tue, 11 Mar 2014 17:30:09 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Dave Jones <davej@redhat.com>, Christoph Lameter <cl@linux.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
        David Rientjes <rientjes@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: oops in slab/leaks_show
Message-ID: <20140311083009.GA32004@lge.com>
References: <20140307025703.GA30770@redhat.com>
 <alpine.DEB.2.10.1403071117230.21846@nuc>
 <20140311003459.GA25657@lge.com>
 <20140311010135.GA25845@lge.com>
 <20140311012455.GA5151@redhat.com>
 <20140311025811.GA601@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140311025811.GA601@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 11:58:11AM +0900, Joonsoo Kim wrote:
> On Mon, Mar 10, 2014 at 09:24:55PM -0400, Dave Jones wrote:
> > On Tue, Mar 11, 2014 at 10:01:35AM +0900, Joonsoo Kim wrote:
> >  > On Tue, Mar 11, 2014 at 09:35:00AM +0900, Joonsoo Kim wrote:
> >  > > On Fri, Mar 07, 2014 at 11:18:30AM -0600, Christoph Lameter wrote:
> >  > > > Joonsoo recently changed the handling of the freelist in SLAB. CCing him.
> >  > > > 
> >  > > > > I pretty much always use SLUB for my fuzzing boxes, but thought I'd give SLAB a try
> >  > > > > for a change.. It blew up when something tried to read /proc/slab_allocators
> >  > > > > (Just cat it, and you should see the oops below)
> >  > > 
> >  > > Hello, Dave.
> >  > > 
> >  > > Today, I did a test on v3.13 which contains all my changes on the handling of
> >  > > the freelist in SLAB and couldn't trigger oops by just 'cat /proc/slab_allocators'.
> >  > > 
> >  > > So I look at the code and find that there is race window if there is multiple users
> >  > > doing 'cat /proc/slab_allocators'. Did your test do that?
> >  > 
> >  > Opps, sorry. I am misunderstanding something. Maybe there is no race.
> >  > Anyway, How do you test it?
> > 
> > 1. build kernel with CONFIG_SLAB=y.
> > 2. boot kernel
> > 3. cat /proc/slab_allocators
> 
> Okay. I reproduce it with CONFIG_DEBUG_PAGEALLOC=y.
> 
> I look at the code and find that the problem doesn't come from my patches.
> I think that it is long-lived bug. Let me explain it.
> 
> 'cat /proc/slab_allocators' checks all allocated objects for all slabs.
> The problem is that it considers objects in cpu slab caches as allocated objects.
> These objects in cpu slab caches are unmapped if CONFIG_DEBUG_PAGEALLOC=y, so when we
> try to access it to get the caller information, oops would be triggered.
> 
> I will think more deeply how to fix this problem.
> If I am missing something, please let me know.

Here is the fix for this problem.
Thanks for reporting it.

---------8<---------------------
>From ff6fe77fb764ca5bf8705bf53d07d38e4111e84c Mon Sep 17 00:00:00 2001
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Date: Tue, 11 Mar 2014 14:14:25 +0900
Subject: [PATCH] slab: remove kernel_map_pages() optimization in slab
 poisoning

If CONFIG_DEBUG_PAGEALLOC enables, slab poisoning functionality uses
kernel_map_pages(), instead of real poisoning, to detect memory corruption
with low overhead. But, in that case, slab leak detector trigger oops.
Reason is that slab leak detector accesses all active objects, especially
including objects in cpu slab caches to get the caller information.
These objects are already unmapped via kernel_map_pages() to detect memory
corruption, so oops could be triggered.

Following is oops message reported from Dave.

It blew up when something tried to read /proc/slab_allocators
(Just cat it, and you should see the oops below)

  Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
  Modules linked in: fuse hidp snd_seq_dummy tun rfcomm bnep llc2 af_key can_raw ipt_ULOG can_bcm nfnetlink scsi_transport_iscsi nfc caif_socket caif af_802154 phonet af_rxrpc can pppoe pppox ppp_generic
  +slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 xfs coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel
  +libcrc32c usb_debug microcode snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic pcspkr btusb bluetooth 6lowpan_iphc rfkill snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm
  +snd_timer e1000e snd ptp shpchp soundcore pps_core serio_raw
  CPU: 1 PID: 9386 Comm: trinity-c33 Not tainted 3.14.0-rc5+ #131
  task: ffff8801aa46e890 ti: ffff880076924000 task.ti: ffff880076924000
  RIP: 0010:[<ffffffffaa1a8f4a>]  [<ffffffffaa1a8f4a>] handle_slab+0x8a/0x180
  RSP: 0018:ffff880076925de0  EFLAGS: 00010002
  RAX: 0000000000001000 RBX: 0000000000000000 RCX: 000000005ce85ce7
  RDX: ffffea00079be100 RSI: 0000000000001000 RDI: ffff880107458000
  RBP: ffff880076925e18 R08: 0000000000000001 R09: 0000000000000000
  R10: 0000000000000000 R11: 000000000000000f R12: ffff8801e6f84000
  R13: ffffea00079be100 R14: ffff880107458000 R15: ffff88022bb8d2c0
  FS:  00007fb769e45740(0000) GS:ffff88024d040000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: ffff8801e6f84ff8 CR3: 00000000a22db000 CR4: 00000000001407e0
  DR0: 0000000002695000 DR1: 0000000002695000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000070602
  Stack:
   ffff8802339dcfc0 ffff88022bb8d2c0 ffff880107458000 ffff88022bb8d2c0
   ffff8802339dd008 ffff8802339dcfc0 ffffea00079be100 ffff880076925e68
   ffffffffaa1ad9be ffff880203fe4f00 ffff88022bb8d318 0000000076925e98
  Call Trace:
   [<ffffffffaa1ad9be>] leaks_show+0xce/0x240
   [<ffffffffaa1e6c0e>] seq_read+0x28e/0x490
   [<ffffffffaa23008d>] proc_reg_read+0x3d/0x80
   [<ffffffffaa1c026b>] vfs_read+0x9b/0x160
   [<ffffffffaa1c0d88>] SyS_read+0x58/0xb0
   [<ffffffffaa7420aa>] tracesys+0xd4/0xd9
  Code: f5 00 00 00 0f 1f 44 00 00 48 63 c8 44 3b 0c 8a 0f 84 e3 00 00 00 83 c0 01 44 39 c0 72 eb 41 f6 47 1a 01 0f 84 e9 00 00 00 89 f0 <4d> 8b 4c 04 f8 4d 85 c9 0f 84 88 00 00 00 49 8b 7e 08 4d 8d 46
  RIP  [<ffffffffaa1a8f4a>] handle_slab+0x8a/0x180
   RSP <ffff880076925de0>
  CR2: ffff8801e6f84ff8

There are two solutions to fix the problem. One is to disable
CONFIG_DEBUG_SLAB_LEAK if CONFIG_DEBUG_PAGEALLOC=y. The other is to remove
kernel_map_pages() optimization in slab poisoning. I think that
second one is better, since we can use all functionality with some more
overhead. slab poisoning is already heavy operation, so adding more
overhead doesn't weaken their value.

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/slab.c b/mm/slab.c
index b264214..a35aeea 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1739,41 +1739,6 @@ static void kmem_rcu_free(struct rcu_head *head)
 }
 
 #if DEBUG
-
-#ifdef CONFIG_DEBUG_PAGEALLOC
-static void store_stackinfo(struct kmem_cache *cachep, unsigned long *addr,
-			    unsigned long caller)
-{
-	int size = cachep->object_size;
-
-	addr = (unsigned long *)&((char *)addr)[obj_offset(cachep)];
-
-	if (size < 5 * sizeof(unsigned long))
-		return;
-
-	*addr++ = 0x12345678;
-	*addr++ = caller;
-	*addr++ = smp_processor_id();
-	size -= 3 * sizeof(unsigned long);
-	{
-		unsigned long *sptr = &caller;
-		unsigned long svalue;
-
-		while (!kstack_end(sptr)) {
-			svalue = *sptr++;
-			if (kernel_text_address(svalue)) {
-				*addr++ = svalue;
-				size -= sizeof(unsigned long);
-				if (size <= sizeof(unsigned long))
-					break;
-			}
-		}
-
-	}
-	*addr++ = 0x87654321;
-}
-#endif
-
 static void poison_obj(struct kmem_cache *cachep, void *addr, unsigned char val)
 {
 	int size = cachep->object_size;
@@ -1914,18 +1879,9 @@ static void slab_destroy_debugcheck(struct kmem_cache *cachep,
 	for (i = 0; i < cachep->num; i++) {
 		void *objp = index_to_obj(cachep, page, i);
 
-		if (cachep->flags & SLAB_POISON) {
-#ifdef CONFIG_DEBUG_PAGEALLOC
-			if (cachep->size % PAGE_SIZE == 0 &&
-					OFF_SLAB(cachep))
-				kernel_map_pages(virt_to_page(objp),
-					cachep->size / PAGE_SIZE, 1);
-			else
-				check_poison_obj(cachep, objp);
-#else
+		if (cachep->flags & SLAB_POISON)
 			check_poison_obj(cachep, objp);
-#endif
-		}
+
 		if (cachep->flags & SLAB_RED_ZONE) {
 			if (*dbg_redzone1(cachep, objp) != RED_INACTIVE)
 				slab_error(cachep, "start of a freed object "
@@ -2227,14 +2183,6 @@ __kmem_cache_create (struct kmem_cache *cachep, unsigned long flags)
 		else
 			size += BYTES_PER_WORD;
 	}
-#if FORCED_DEBUG && defined(CONFIG_DEBUG_PAGEALLOC)
-	if (size >= kmalloc_size(INDEX_NODE + 1)
-	    && cachep->object_size > cache_line_size()
-	    && ALIGN(size, cachep->align) < PAGE_SIZE) {
-		cachep->obj_offset += PAGE_SIZE - ALIGN(size, cachep->align);
-		size = PAGE_SIZE;
-	}
-#endif
 #endif
 
 	/*
@@ -2273,15 +2221,6 @@ __kmem_cache_create (struct kmem_cache *cachep, unsigned long flags)
 	if (flags & CFLGS_OFF_SLAB) {
 		/* really off slab. No need for manual alignment */
 		freelist_size = cachep->num * sizeof(unsigned int);
-
-#ifdef CONFIG_PAGE_POISONING
-		/* If we're going to use the generic kernel_map_pages()
-		 * poisoning, then it's going to smash the contents of
-		 * the redzone and userword anyhow, so switch them off.
-		 */
-		if (size % PAGE_SIZE == 0 && flags & SLAB_POISON)
-			flags &= ~(SLAB_RED_ZONE | SLAB_STORE_USER);
-#endif
 	}
 
 	cachep->colour_off = cache_line_size();
@@ -2581,10 +2520,6 @@ static void cache_init_objs(struct kmem_cache *cachep,
 				slab_error(cachep, "constructor overwrote the"
 					   " start of an object");
 		}
-		if ((cachep->size % PAGE_SIZE) == 0 &&
-			    OFF_SLAB(cachep) && cachep->flags & SLAB_POISON)
-			kernel_map_pages(virt_to_page(objp),
-					 cachep->size / PAGE_SIZE, 0);
 #else
 		if (cachep->ctor)
 			cachep->ctor(objp);
@@ -2797,19 +2732,9 @@ static void *cache_free_debugcheck(struct kmem_cache *cachep, void *objp,
 	BUG_ON(objnr >= cachep->num);
 	BUG_ON(objp != index_to_obj(cachep, page, objnr));
 
-	if (cachep->flags & SLAB_POISON) {
-#ifdef CONFIG_DEBUG_PAGEALLOC
-		if ((cachep->size % PAGE_SIZE)==0 && OFF_SLAB(cachep)) {
-			store_stackinfo(cachep, objp, caller);
-			kernel_map_pages(virt_to_page(objp),
-					 cachep->size / PAGE_SIZE, 0);
-		} else {
-			poison_obj(cachep, objp, POISON_FREE);
-		}
-#else
+	if (cachep->flags & SLAB_POISON)
 		poison_obj(cachep, objp, POISON_FREE);
-#endif
-	}
+
 	return objp;
 }
 
@@ -2933,15 +2858,7 @@ static void *cache_alloc_debugcheck_after(struct kmem_cache *cachep,
 	if (!objp)
 		return objp;
 	if (cachep->flags & SLAB_POISON) {
-#ifdef CONFIG_DEBUG_PAGEALLOC
-		if ((cachep->size % PAGE_SIZE) == 0 && OFF_SLAB(cachep))
-			kernel_map_pages(virt_to_page(objp),
-					 cachep->size / PAGE_SIZE, 1);
-		else
-			check_poison_obj(cachep, objp);
-#else
 		check_poison_obj(cachep, objp);
-#endif
 		poison_obj(cachep, objp, POISON_INUSE);
 	}
 	if (cachep->flags & SLAB_STORE_USER)
-- 
1.7.9.5

