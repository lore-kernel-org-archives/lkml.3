Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933065Ab3HGT5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 15:57:36 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:44171 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932713Ab3HGT5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 15:57:35 -0400
Date: Wed, 7 Aug 2013 12:57:33 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] idr: Use this_cpu_ptr() for percpu_ida
Message-ID: <20130807195733.GB11612@kmo-pixel>
References: <1375896905-6074-1-git-send-email-kmo@daterainc.com>
 <1375896905-6074-5-git-send-email-kmo@daterainc.com>
 <0000014059ec4c34-1bb53d48-c9ee-4e71-81b8-253026431c5c-000000@email.amazonses.com>
 <20130807183345.GA11612@kmo-pixel>
 <000001405a4b39ef-0715410a-5061-41e9-9414-86559f16570d-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001405a4b39ef-0715410a-5061-41e9-9414-86559f16570d-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 07:40:15PM +0000, Christoph Lameter wrote:
> On Wed, 7 Aug 2013, Kent Overstreet wrote:
> 
> > I was breaking it apart because I was using this_cpu elsewhere too - for
> > the bitmap of which cpus have non empty freelists.
> 
> this_cpu can be retrieved with smp_processor_id().
> 
> > Or is this_cpu_ptr() doing something smarter than per_cpu_ptr(ptr,
> > smp_processer_id())? There's so many variants I'm not 100% sure they're
> > the same.
> 
> Yes it is. It uses a sepecial register that contains the offset of this
> cpus per cpu area instead of going through the table of all processor
> offsets. Its less code.

Alright, well here's a fixup patch - untested for the moment though.

One thing that was bugging me - I was never able to figure out for sure
if smp_processor_id() returns a number in the range [0, nr_cpu_ids), at
least I couldn't find where it was documented - could you tell me if
that's true?

>From e2b8016de49c28c0ccbe7849d7254f005c7e2e77 Mon Sep 17 00:00:00 2001
From: Kent Overstreet <kmo@daterainc.com>
Date: Wed, 7 Aug 2013 12:52:58 -0700
Subject: [PATCH] idr: Use this_cpu_ptr() for percpu_ida


diff --git a/lib/idr.c b/lib/idr.c
index fb374c3..320ffea 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -748,12 +748,10 @@ int percpu_ida_alloc(struct percpu_ida *pool, gfp_t gfp)
 	DEFINE_WAIT(wait);
 	struct percpu_ida_cpu *tags;
 	unsigned long flags;
-	unsigned this_cpu;
 	int tag;
 
 	local_irq_save(flags);
-	this_cpu = smp_processor_id();
-	tags = per_cpu_ptr(pool->tag_cpu, this_cpu);
+	tags = this_cpu_ptr(pool->tag_cpu);
 
 	/* Fastpath */
 	tag = alloc_local_tag(pool, tags);
@@ -782,7 +780,8 @@ int percpu_ida_alloc(struct percpu_ida *pool, gfp_t gfp)
 		if (tags->nr_free) {
 			tag = tags->freelist[--tags->nr_free];
 			if (tags->nr_free)
-				set_bit(this_cpu, pool->cpus_have_tags);
+				set_bit(smp_processor_id(),
+					pool->cpus_have_tags);
 		}
 
 		spin_unlock(&pool->ida.lock);
@@ -794,8 +793,7 @@ int percpu_ida_alloc(struct percpu_ida *pool, gfp_t gfp)
 		schedule();
 
 		local_irq_save(flags);
-		this_cpu = smp_processor_id();
-		tags = per_cpu_ptr(pool->tag_cpu, this_cpu);
+		tags = this_cpu_ptr(pool->tag_cpu);
 	}
 
 	finish_wait(&pool->wait, &wait);
@@ -814,13 +812,12 @@ void percpu_ida_free(struct percpu_ida *pool, unsigned tag)
 {
 	struct percpu_ida_cpu *tags;
 	unsigned long flags;
-	unsigned nr_free, this_cpu;
+	unsigned nr_free;
 
 	BUG_ON(tag >= pool->nr_tags);
 
 	local_irq_save(flags);
-	this_cpu = smp_processor_id();
-	tags = per_cpu_ptr(pool->tag_cpu, this_cpu);
+	tags = this_cpu_ptr(pool->tag_cpu);
 
 	spin_lock(&tags->lock);
 	tags->freelist[tags->nr_free++] = tag;
@@ -829,7 +826,8 @@ void percpu_ida_free(struct percpu_ida *pool, unsigned tag)
 	spin_unlock(&tags->lock);
 
 	if (nr_free == 1) {
-		set_bit(this_cpu, pool->cpus_have_tags);
+		set_bit(smp_processor_id(),
+			pool->cpus_have_tags);
 		wake_up(&pool->wait);
 	}
 
