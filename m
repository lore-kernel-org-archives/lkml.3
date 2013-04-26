Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239Ab3DZGYq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 02:24:46 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:49980 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753652Ab3DZGYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 02:24:44 -0400
Date: Fri, 26 Apr 2013 14:24:36 +0800
From: Han Pingtian <hanpt@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Christoph Lameter <cl@linux.com>, mhocko@suse.cz, penberg@kernel.org,
        rientjes@google.com, linux-mm@kvack.org
Subject: Re: OOM-killer and strange RSS value in 3.9-rc7
Message-ID: <20130426062436.GB4441@localhost.localdomain>
Mail-Followup-To: LKML <linux-kernel@vger.kernel.org>,
	Christoph Lameter <cl@linux.com>, mhocko@suse.cz,
	penberg@kernel.org, rientjes@google.com, linux-mm@kvack.org
References: <20130417094750.GB2672@localhost.localdomain>
 <20130417141909.GA24912@dhcp22.suse.cz>
 <20130418101541.GC2672@localhost.localdomain>
 <20130418175513.GA12581@dhcp22.suse.cz>
 <20130423131558.GH8001@dhcp22.suse.cz>
 <20130424044848.GI2672@localhost.localdomain>
 <20130424094732.GB31960@dhcp22.suse.cz>
 <0000013e3cb0340d-00f360e3-076b-478e-b94c-ddd4476196ce-000000@email.amazonses.com>
 <20130425060705.GK2672@localhost.localdomain>
 <0000013e427023d7-9456c313-8654-420c-b85a-cb79cc3c4ffc-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000013e427023d7-9456c313-8654-420c-b85a-cb79cc3c4ffc-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042606-7182-0000-0000-00000669C3F6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 06:24:05PM +0000, Christoph Lameter wrote:
> On Thu, 25 Apr 2013, Han Pingtian wrote:
> 
> > > A dump of the other fields in /sys/kernel/slab/kmalloc*/* would also be
> > > useful.
> > >
> > I have dumpped all /sys/kernel/slab/kmalloc*/* in kmalloc.tar.xz and
> > will attach it to this mail.
> 
> Ok that looks like a lot of objects were freed from slab pages but the
> slab pages were not freed.
> 
> looking at kmalloc-8192 we have
> 
> Total capacity of the slab cache is 27k objects but only 508 are in use.
> 
> Looks like slab pages are not freed when all objects in them have been
> released.
> 
> The relevant portion of code that do the freeing are in
> 
> mm/slub.c::unfreeze_partials()
> 
> 		if (unlikely(!new.inuse && n->nr_partial > s->min_partial)) {
>                         page->next = discard_page;
>                         discard_page = page;
>                 } else {
>                         add_partial(n, page, DEACTIVATE_TO_TAIL);
>                         stat(s, FREE_ADD_PARTIAL);
>                 }
> 
> 
> ..
> 
>        while (discard_page) {
>                 page = discard_page;
>                 discard_page = discard_page->next;
> 
>                 stat(s, DEACTIVATE_EMPTY);
>                 discard_slab(s, page);
>                 stat(s, FREE_SLAB);
>         }
> 
> and mm/slub.c::__slab_free()
> 
>      if (unlikely(!new.inuse && n->nr_partial > s->min_partial))
>                 goto slab_empty;
> 
> 
> Could you verify the values of nr_partial and min_partial and verify that
> the free paths are actually used?

Could you give me some hints about how to verify them? Only I can do is
adding two printk() statements to print the vaules in those two
functions:

--------------------------------------------------------------------------------
diff --git a/mm/slub.c b/mm/slub.c
index 4aec537..d08d62d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1915,6 +1915,9 @@ static void unfreeze_partials(struct kmem_cache *s,
                                new.freelist, new.counters,
                                "unfreezing slab"));
 
+               if (strcmp(s->name, "kmalloc-8192") == 0) {
+                       printk(KERN_INFO "In unfreeze_partials(); kmalloc-8192: n->nr_partial=%lu, s->min_partial
+                }
                if (unlikely(!new.inuse && n->nr_partial > s->min_partial)) {
                        page->next = discard_page;
                        discard_page = page;
@@ -2536,6 +2539,10 @@ static void __slab_free(struct kmem_cache *s, struct page *page,
                 return;
         }
 
+       if (strcmp(s->name, "kmalloc-8192") == 0) {
+               printk(KERN_INFO "In __slab_free(); kmalloc-8192: n->nr_partial=%lu, s->min_partial=%lu\n", n->nr
+       }
+
        if (unlikely(!new.inuse && n->nr_partial > s->min_partial))
                goto slab_empty;

--------------------------------------------------------------------------------

And looks like only printk() in __slab_free() is invoked. I got about 6764 
lines of something like this:

--------------------------------------------------------------------------------
Apr 26 01:04:05 riblp3 kernel: [    6.969775] In __slab_free(); kmalloc-8192: n->nr_partial=2, s->min_partial=6
Apr 26 01:04:05 riblp3 kernel: [    6.970154] In __slab_free(); kmalloc-8192: n->nr_partial=3, s->min_partial=6
Apr 26 01:04:05 riblp3 kernel: [    6.979489] In __slab_free(); kmalloc-8192: n->nr_partial=4, s->min_partial=6
Apr 26 01:04:05 riblp3 kernel: [    6.979823] In __slab_free(); kmalloc-8192: n->nr_partial=5, s->min_partial=6
Apr 26 01:04:05 riblp3 kernel: [    9.500383] In __slab_free(); kmalloc-8192: n->nr_partial=7, s->min_partial=6
Apr 26 01:04:05 riblp3 kernel: [    9.509736] In __slab_free(); kmalloc-8192: n->nr_partial=7, s->min_partial=6
Apr 26 01:04:08 riblp3 kernel: [   42.314395] In __slab_free(); kmalloc-8192: n->nr_partial=100, s->min_partial=6
Apr 26 01:04:08 riblp3 kernel: [   42.410333] In __slab_free(); kmalloc-8192: n->nr_partial=100, s->min_partial=6
Apr 26 01:04:09 riblp3 kernel: [   43.411851] In __slab_free(); kmalloc-8192: n->nr_partial=339, s->min_partial=6
Apr 26 01:04:09 riblp3 kernel: [   43.411980] In __slab_free(); kmalloc-8192: n->nr_partial=338, s->min_partial=6
Apr 26 01:04:09 riblp3 kernel: [   43.412083] In __slab_free(); kmalloc-8192: n->nr_partial=337, s->min_partial=6
--------------------------------------------------------------------------------
The s->min_partial is always "6" and most of n->nr_partial is bigger than 
its partner of the same line.

Thanks.

