Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869AbaKGPoa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 10:44:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51722 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbaKGPo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 10:44:28 -0500
Message-ID: <545CE8DA.2050004@suse.cz>
Date: Fri, 07 Nov 2014 16:44:26 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Norbert Preining <preining@logic.at>
CC: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org
Subject: Re: khugepaged / firefox going wild in 3.18-rc
References: <20141104232027.GO13232@auth.logic.tuwien.ac.at> <alpine.DEB.2.10.1411041559170.2720@chino.kir.corp.google.com> <20141105001026.GQ13232@auth.logic.tuwien.ac.at> <20141105001243.GR13232@auth.logic.tuwien.ac.at> <alpine.DEB.2.10.1411041615270.5391@chino.kir.corp.google.com> <545B68C9.2060107@suse.cz> <20141106123904.GU11838@auth.logic.tuwien.ac.at> <545B71A8.6030209@suse.cz> <20141107130717.GF11838@auth.logic.tuwien.ac.at> <545CCB49.2010405@suse.cz> <20141107135723.GH11838@auth.logic.tuwien.ac.at>
In-Reply-To: <20141107135723.GH11838@auth.logic.tuwien.ac.at>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2014 02:57 PM, Norbert Preining wrote:
> Hi Vlastimil,
> 
> On Fri, 07 Nov 2014, Vlastimil Babka wrote:
>> Great, that's good news if I understand correctly, but ...
> 
> no "but ..."
> 
>> I suggested the commit to you for revert 1 day ago, and you say you
>> can't reproduce it for 2 days already? That's a bit suspicious. Did
> 
> No, you suggested it yesterday during the day, and here in Japan the
> next day is already over, so my feeling is two days ;-)
>
> So all fine ;-)

Ah, good, just wanted to be sure.
 
>> I'll prepare a debugging patch and send with instructions. Meanwhile
>> you could send the /proc/zoneinfo contents? :)
> 
> When? Running which kernel? Anyway, with the current kernel (reverted
> commit as before) I get the attached zoneinfo.

It doesn't matter which kernel. Thanks, but I didn't find anything
suspicious there... expected some oddly aligned zones, but it all seemed
to be aligned to pageblock boundaries.

> Thanks, and waiting for your patches ;-)

Tracing patch attached. You should apply this to the broken kernel, i.e.
without the revert, and have tracing enabled, i.e. CONFIG_FTRACE. There
should be /sys/kernel/debug/tracing directory.
To avoid overhead and noise, I would just run this kernel as usual, and
only when khugepaged/firefox/whatever starts misbehaving, do the following:

cd /sys/kernel/debug/tracing
echo 1 > tracing_on
echo 1 > events/compaction/enable
cat trace_pipe | tee /tmp/trace  #(or somewhere else)

You should see events scrolling on the screen, including the misbehaving
processes. After a minute or something, ctrl+c and send me the trace file.

Thanks a lot!
Vlastimil 


> Norbert
> 

------8<------
>From 59c93237ad2fb2317e61c8f00ea73d93ff8a2813 Mon Sep 17 00:00:00 2001
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 7 Nov 2014 16:12:14 +0100
Subject: [PATCH] compaction: detailed free scanner tracing

---
 include/trace/events/compaction.h | 51 +++++++++++++++++++++++++++++++++------
 mm/compaction.c                   |  9 +++++--
 2 files changed, 50 insertions(+), 10 deletions(-)

diff --git a/include/trace/events/compaction.h b/include/trace/events/compaction.h
index c6814b9..db83ea4 100644
--- a/include/trace/events/compaction.h
+++ b/include/trace/events/compaction.h
@@ -12,38 +12,73 @@
 DECLARE_EVENT_CLASS(mm_compaction_isolate_template,
 
 	TP_PROTO(unsigned long nr_scanned,
-		unsigned long nr_taken),
+		unsigned long nr_taken,
+		unsigned long last_pfn),
 
-	TP_ARGS(nr_scanned, nr_taken),
+	TP_ARGS(nr_scanned, nr_taken, last_pfn),
 
 	TP_STRUCT__entry(
 		__field(unsigned long, nr_scanned)
 		__field(unsigned long, nr_taken)
+		__field(unsigned long, last_pfn)
 	),
 
 	TP_fast_assign(
 		__entry->nr_scanned = nr_scanned;
 		__entry->nr_taken = nr_taken;
+		__entry->last_pfn = last_pfn;
 	),
 
-	TP_printk("nr_scanned=%lu nr_taken=%lu",
+	TP_printk("nr_scanned=%lu nr_taken=%lu last_pfn=%lu",
 		__entry->nr_scanned,
-		__entry->nr_taken)
+		__entry->nr_taken,
+		__entry->last_pfn)
 );
 
 DEFINE_EVENT(mm_compaction_isolate_template, mm_compaction_isolate_migratepages,
 
 	TP_PROTO(unsigned long nr_scanned,
-		unsigned long nr_taken),
+		unsigned long nr_taken,
+		unsigned long last_pfn),
 
-	TP_ARGS(nr_scanned, nr_taken)
+	TP_ARGS(nr_scanned, nr_taken, last_pfn)
 );
 
 DEFINE_EVENT(mm_compaction_isolate_template, mm_compaction_isolate_freepages,
 	TP_PROTO(unsigned long nr_scanned,
-		unsigned long nr_taken),
+		unsigned long nr_taken,
+		unsigned long last_pfn),
 
-	TP_ARGS(nr_scanned, nr_taken)
+	TP_ARGS(nr_scanned, nr_taken, last_pfn)
+);
+
+TRACE_EVENT(mm_compaction_isolate_freepages_loop,
+	TP_PROTO(unsigned long low_pfn,
+		unsigned long block_start_pfn,
+		unsigned long isolate_start_pfn,
+		unsigned long block_end_pfn),
+
+	TP_ARGS(low_pfn, block_start_pfn, isolate_start_pfn, block_end_pfn),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, low_pfn)
+		__field(unsigned long, block_start_pfn)
+		__field(unsigned long, isolate_start_pfn)
+		__field(unsigned long, block_end_pfn)
+	),
+
+	TP_fast_assign(
+		__entry->low_pfn = low_pfn;
+		__entry->block_start_pfn = block_start_pfn;
+		__entry->isolate_start_pfn = isolate_start_pfn;
+		__entry->block_end_pfn = block_end_pfn;
+	),
+
+	TP_printk("low=%lu block_start=%lu isolate_start=%lu block_end=%lu",
+		__entry->low_pfn,
+		__entry->block_start_pfn,
+		__entry->isolate_start_pfn,
+		__entry->block_end_pfn)
 );
 
 TRACE_EVENT(mm_compaction_migratepages,
diff --git a/mm/compaction.c b/mm/compaction.c
index ec74cf0..4931b21 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -426,7 +426,8 @@ isolate_fail:
 	/* Record how far we have got within the block */
 	*start_pfn = blockpfn;
 
-	trace_mm_compaction_isolate_freepages(nr_scanned, total_isolated);
+	trace_mm_compaction_isolate_freepages(nr_scanned, total_isolated,
+								blockpfn);
 
 	/*
 	 * If strict isolation is requested by CMA then check that all the
@@ -734,7 +735,8 @@ isolate_success:
 	if (low_pfn == end_pfn)
 		update_pageblock_skip(cc, valid_page, nr_isolated, true);
 
-	trace_mm_compaction_isolate_migratepages(nr_scanned, nr_isolated);
+	trace_mm_compaction_isolate_migratepages(nr_scanned, nr_isolated,
+								low_pfn);
 
 	count_compact_events(COMPACTMIGRATE_SCANNED, nr_scanned);
 	if (nr_isolated)
@@ -838,6 +840,9 @@ static void isolate_freepages(struct compact_control *cc)
 				isolate_start_pfn = block_start_pfn) {
 		unsigned long isolated;
 
+		trace_mm_compaction_isolate_freepages_loop(low_pfn,
+			block_start_pfn, isolate_start_pfn, block_end_pfn);
+
 		/*
 		 * This can iterate a massively long zone without finding any
 		 * suitable migration targets, so periodically check if we need
-- 
2.1.2



