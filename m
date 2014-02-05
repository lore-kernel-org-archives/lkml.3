Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbaBEWRd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 17:17:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38617 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbaBEWR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 17:17:28 -0500
Date: Wed, 5 Feb 2014 14:17:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andi Kleen <andi@firstfloor.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Bob Liu <bob.liu@oracle.com>, Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, Greg Thelen <gthelen@google.com>,
        Hugh Dickins <hughd@google.com>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Luigi Semenzato <semenzato@google.com>, Mel Gorman <mgorman@suse.de>,
        Metin Doslu <metin@citusdata.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Ozgun Erdogan <ozgun@citusdata.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Roman Gushchin <klamm@yandex-team.ru>, Ryan Mallon <rmallon@gmail.com>,
        Tejun Heo <tj@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 01/10] mm: vmstat: fix UP zone state accounting
Message-Id: <20140205141726.e474d52258e0a09418ba1018@linux-foundation.org>
In-Reply-To: <1391475222-1169-2-git-send-email-hannes@cmpxchg.org>
References: <1391475222-1169-1-git-send-email-hannes@cmpxchg.org>
	<1391475222-1169-2-git-send-email-hannes@cmpxchg.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  3 Feb 2014 19:53:33 -0500 Johannes Weiner <hannes@cmpxchg.org> wrote:

> Fengguang Wu's build testing spotted problems with inc_zone_state()
> and dec_zone_state() on UP configurations in out-of-tree patches.
> 
> inc_zone_state() is declared but not defined, dec_zone_state() is
> missing entirely.
> 
> Just like with *_zone_page_state(), they can be defined like their
> preemption-unsafe counterparts on UP.

um,

In file included from include/linux/mm.h:876,
                 from include/linux/suspend.h:8,
                 from arch/x86/kernel/asm-offsets.c:12:
include/linux/vmstat.h: In function '__inc_zone_page_state':
include/linux/vmstat.h:228: error: implicit declaration of function '__inc_zone_state'
include/linux/vmstat.h: In function '__dec_zone_page_state':
include/linux/vmstat.h:234: error: implicit declaration of function '__dec_zone_state'
include/linux/vmstat.h: At top level:
include/linux/vmstat.h:245: warning: conflicting types for '__inc_zone_state'
include/linux/vmstat.h:245: error: static declaration of '__inc_zone_state' follows non-static declaration
include/linux/vmstat.h:228: note: previous implicit declaration of '__inc_zone_state' was here
include/linux/vmstat.h:251: warning: conflicting types for '__dec_zone_state'
include/linux/vmstat.h:251: error: static declaration of '__dec_zone_state' follows non-static declaration
include/linux/vmstat.h:234: note: previous implicit declaration of '__dec_zone_state' was here

I shuffled them around:

--- a/include/linux/vmstat.h~mm-vmstat-fix-up-zone-state-accounting-fix
+++ a/include/linux/vmstat.h
@@ -214,6 +214,18 @@ static inline void __mod_zone_page_state
 	zone_page_state_add(delta, zone, item);
 }
 
+static inline void __inc_zone_state(struct zone *zone, enum zone_stat_item item)
+{
+	atomic_long_inc(&zone->vm_stat[item]);
+	atomic_long_inc(&vm_stat[item]);
+}
+
+static inline void __dec_zone_state(struct zone *zone, enum zone_stat_item item)
+{
+	atomic_long_dec(&zone->vm_stat[item]);
+	atomic_long_dec(&vm_stat[item]);
+}
+
 static inline void __inc_zone_page_state(struct page *page,
 			enum zone_stat_item item)
 {
@@ -234,18 +246,6 @@ static inline void __dec_zone_page_state
 #define dec_zone_page_state __dec_zone_page_state
 #define mod_zone_page_state __mod_zone_page_state
 
-static inline void __inc_zone_state(struct zone *zone, enum zone_stat_item item)
-{
-	atomic_long_inc(&zone->vm_stat[item]);
-	atomic_long_inc(&vm_stat[item]);
-}
-
-static inline void __dec_zone_state(struct zone *zone, enum zone_stat_item item)
-{
-	atomic_long_dec(&zone->vm_stat[item]);
-	atomic_long_dec(&vm_stat[item]);
-}
-
 #define inc_zone_state __inc_zone_state
 #define dec_zone_state __dec_zone_state
 
_

