Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab3GIIGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 04:06:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49505 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582Ab3GIIGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 04:06:05 -0400
Date: Tue, 9 Jul 2013 10:05:14 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, eranian@google.com,
        ak@linux.intel.com
Subject: Re: [PATCH] perf: Update event buffer tail when overwriting old
 events
Message-ID: <20130709080513.GG25631@dyad.programming.kicks-ass.net>
References: <1370498286-12801-1-git-send-email-zheng.z.yan@intel.com>
 <20130708121557.GA17211@twins.programming.kicks-ass.net>
 <51DBB645.5070201@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51DBB645.5070201@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 09, 2013 at 03:05:41PM +0800, Yan, Zheng wrote:

> Thank you for your help. I ran the same test, the results for regular case
> are much better. But it still has about 1% overhead, probably because we
> enlarge the ring_buffer structure, make it less cache friendly.
> 
>       origin    with the patch
> AVG    1000      1013
> STDEV  13.4      15.0

And this is the !overwrite case, right? I don't suppose you cured the logic
Namhyung Kim pointed out? That should affect the overwrite case I suppose since
it won't switch to perf_event_output_overwrite().

tip/master:

struct ring_buffer {
        atomic_t                   refcount;             /*     0     4 */

        /* XXX 4 bytes hole, try to pack */

        struct callback_head       callback_head;        /*     8    16 */
        int                        nr_pages;             /*    24     4 */
        int                        overwrite;            /*    28     4 */
        atomic_t                   poll;                 /*    32     4 */

        /* XXX 4 bytes hole, try to pack */

        local_t                    head;                 /*    40     8 */
        local_t                    nest;                 /*    48     8 */
        local_t                    events;               /*    56     8 */
        /* --- cacheline 1 boundary (64 bytes) --- */
        local_t                    wakeup;               /*    64     8 */
        local_t                    lost;                 /*    72     8 */
        long int                   watermark;            /*    80     8 */
        spinlock_t                 event_lock;           /*    88    56 */
        /* --- cacheline 2 boundary (128 bytes) was 16 bytes ago --- */
        struct list_head           event_list;           /*   144    16 */
        atomic_t                   mmap_count;           /*   160     4 */

        /* XXX 4 bytes hole, try to pack */

        long unsigned int          mmap_locked;          /*   168     8 */
        struct user_struct *       mmap_user;            /*   176     8 */
        struct perf_event_mmap_page * user_page;         /*   184     8 */
        /* --- cacheline 3 boundary (192 bytes) --- */
        void *                     data_pages[0];        /*   192     0 */

        /* size: 192, cachelines: 3, members: 18 */
        /* sum members: 180, holes: 3, sum holes: 12 */
};

tip/master + patch:

struct ring_buffer {
        atomic_t                   refcount;             /*     0     4 */

        /* XXX 4 bytes hole, try to pack */

        struct callback_head       callback_head;        /*     8    16 */
        int                        nr_pages;             /*    24     4 */
        int                        overwrite;            /*    28     4 */
        atomic_t                   poll;                 /*    32     4 */

        /* XXX 4 bytes hole, try to pack */

        local_t                    tail;                 /*    40     8 */
        local_t                    next_tail;            /*    48     8 */
        local_t                    head;                 /*    56     8 */
        /* --- cacheline 1 boundary (64 bytes) --- */
        local_t                    nest;                 /*    64     8 */
        local_t                    events;               /*    72     8 */
        local_t                    wakeup;               /*    80     8 */
        local_t                    lost;                 /*    88     8 */
        long int                   watermark;            /*    96     8 */
        spinlock_t                 event_lock;           /*   104    56 */
        /* --- cacheline 2 boundary (128 bytes) was 32 bytes ago --- */
        struct list_head           event_list;           /*   160    16 */
        atomic_t                   mmap_count;           /*   176     4 */

        /* XXX 4 bytes hole, try to pack */

        long unsigned int          mmap_locked;          /*   184     8 */
        /* --- cacheline 3 boundary (192 bytes) --- */
        struct user_struct *       mmap_user;            /*   192     8 */
        struct perf_event_mmap_page * user_page;         /*   200     8 */
        void *                     data_pages[0];        /*   208     0 */

        /* size: 208, cachelines: 4, members: 20 */
        /* sum members: 196, holes: 3, sum holes: 12 */
        /* last cacheline: 16 bytes */
};

tip/master + patch^2:

struct ring_buffer {
        atomic_t                   refcount;             /*     0     4 */
        atomic_t                   mmap_count;           /*     4     4 */
        union {
                int                overwrite;            /*           4 */
                struct callback_head callback_head;      /*          16 */
        };                                               /*     8    16 */
        int                        nr_pages;             /*    24     4 */
        atomic_t                   poll;                 /*    28     4 */
        local_t                    tail;                 /*    32     8 */
        local_t                    next_tail;            /*    40     8 */
        local_t                    head;                 /*    48     8 */
        local_t                    nest;                 /*    56     8 */
        /* --- cacheline 1 boundary (64 bytes) --- */
        local_t                    events;               /*    64     8 */
        local_t                    wakeup;               /*    72     8 */
        local_t                    lost;                 /*    80     8 */
        long int                   watermark;            /*    88     8 */
        spinlock_t                 event_lock;           /*    96    56 */
        /* --- cacheline 2 boundary (128 bytes) was 24 bytes ago --- */
        struct list_head           event_list;           /*   152    16 */
        long unsigned int          mmap_locked;          /*   168     8 */
        struct user_struct *       mmap_user;            /*   176     8 */
        struct perf_event_mmap_page * user_page;         /*   184     8 */
        /* --- cacheline 3 boundary (192 bytes) --- */
        void *                     data_pages[0];        /*   192     0 */

        /* size: 192, cachelines: 3, members: 19 */
};


---
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4641,7 +4641,7 @@ static void perf_event_output_overwrite(
 static void
 perf_event_set_overflow(struct perf_event *event, struct ring_buffer *rb)
 {
-	if (event->overflow_handler != perf_event_output ||
+	if (event->overflow_handler != perf_event_output &&
 	    event->overflow_handler != perf_event_output_overwrite)
 		return;
 
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -10,13 +10,16 @@
 
 struct ring_buffer {
 	atomic_t			refcount;
-	struct rcu_head			rcu_head;
+	atomic_t			mmap_count;
+	union {
+		int			overwrite;	/* can overwrite itself */
+		struct rcu_head		rcu_head;
+	};
 #ifdef CONFIG_PERF_USE_VMALLOC
 	struct work_struct		work;
 	int				page_order;	/* allocation order  */
 #endif
 	int				nr_pages;	/* nr of data pages  */
-	int				overwrite;	/* can overwrite itself */
 
 	atomic_t			poll;		/* POLL_ for wakeups */
 
@@ -33,7 +36,6 @@ struct ring_buffer {
 	spinlock_t			event_lock;
 	struct list_head		event_list;
 
-	atomic_t			mmap_count;
 	unsigned long			mmap_locked;
 	struct user_struct		*mmap_user;
 

