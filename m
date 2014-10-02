Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbaJBOQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 10:16:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718AbaJBOQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 10:16:34 -0400
Date: Thu, 2 Oct 2014 16:15:59 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/2] perf tools: Add option to copy events when queueing
Message-ID: <20141002141559.GJ9764@krava.brq.redhat.com>
References: <1412245929-27579-1-git-send-email-yarygin@linux.vnet.ibm.com>
 <1412245929-27579-2-git-send-email-yarygin@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412245929-27579-2-git-send-email-yarygin@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 02:32:08PM +0400, Alexander Yarygin wrote:

SNIP

> +		if (!oe->buffer) {
> +			if (oe->copy_on_queue) {
> +				oe->cur_alloc_size -= new_event->header.size;
> +				free(new_event);
> +			}
>  			return NULL;
> +		}
>  
>  		pr("alloc size %" PRIu64 "B (+%zu), max %" PRIu64 "B\n",
>  		   oe->cur_alloc_size, size, oe->max_alloc_size);
> @@ -90,15 +110,19 @@ static struct ordered_event *alloc_event(struct ordered_events *oe)
>  		pr("allocation limit reached %" PRIu64 "B\n", oe->max_alloc_size);
>  	}
>  
> +	new->event = new_event;
> +
>  	return new;
>  }
>  
>  struct ordered_event *
> -ordered_events__new(struct ordered_events *oe, u64 timestamp)
> +ordered_events__new(struct ordered_events *oe, u64 timestamp,
> +		    union perf_event *event)
>  {
>  	struct ordered_event *new;
>  
> -	new = alloc_event(oe);
> +	new = alloc_event(oe, event);
> +
>  	if (new) {
>  		new->timestamp = timestamp;
>  		queue_event(oe, new);
> @@ -111,6 +135,10 @@ void ordered_events__delete(struct ordered_events *oe, struct ordered_event *eve
>  {
>  	list_move(&event->list, &oe->cache);
>  	oe->nr_events--;
> +	if (oe->copy_on_queue) {
> +		oe->cur_alloc_size -= event->event->header.size;
> +		free(event->event);
> +	}
>  }
>  
>  static int __ordered_events__flush(struct perf_session *s,
> @@ -240,6 +268,11 @@ void ordered_events__free(struct ordered_events *oe)
>  
>  		event = list_entry(oe->to_free.next, struct ordered_event, list);
>  		list_del(&event->list);
> +		if (oe->copy_on_queue) {
> +			oe->cur_alloc_size -= event->event->header.size;
> +			free(event->event);
> +		}
> +
>  		free(event);

looks ok.. but I was wondering if we could move those repeating
bits in function.. something like below (untested, just compiled)

thanks,
jirka


---
diff --git a/tools/perf/util/ordered-events.c b/tools/perf/util/ordered-events.c
index f7383ccc6690..583dcefc92fb 100644
--- a/tools/perf/util/ordered-events.c
+++ b/tools/perf/util/ordered-events.c
@@ -58,23 +58,41 @@ static void queue_event(struct ordered_events *oe, struct ordered_event *new)
 	}
 }
 
+static union perf_event *__dup_event(struct ordered_events *oe, union perf_event *event)
+{
+	union perf_event *new_event = NULL;
+
+	if (oe->cur_alloc_size < oe->max_alloc_size) {
+		new_event = memdup(event, event->header.size);
+		if (new_event)
+			oe->cur_alloc_size += event->header.size;
+	}
+
+	return new_event;
+}
+
+static union perf_event *dup_event(struct ordered_events *oe, union perf_event *event)
+{
+	return oe->copy_on_queue ? __dup_event(oe, event) : event;
+}
+
+static void free_dup_event(struct ordered_events *oe, union perf_event *event)
+{
+	if (oe->copy_on_queue) {
+		oe->cur_alloc_size -= event->header.size;
+		free(event);
+	}
+}
+
 #define MAX_SAMPLE_BUFFER	(64 * 1024 / sizeof(struct ordered_event))
 static struct ordered_event *alloc_event(struct ordered_events *oe,
 					 union perf_event *event)
 {
 	struct list_head *cache = &oe->cache;
 	struct ordered_event *new = NULL;
-	union perf_event *new_event = NULL;
-
-	if (oe->copy_on_queue) {
-		if (oe->cur_alloc_size < oe->max_alloc_size) {
-			new_event = memdup(event, event->header.size);
-			if (new_event)
-				oe->cur_alloc_size += event->header.size;
-		}
-	} else
-		new_event = event;
+	union perf_event *new_event;
 
+	new_event = dup_event(oe, event);
 	if (!new_event)
 		return NULL;
 
@@ -90,10 +108,7 @@ static struct ordered_event *alloc_event(struct ordered_events *oe,
 
 		oe->buffer = malloc(size);
 		if (!oe->buffer) {
-			if (oe->copy_on_queue) {
-				oe->cur_alloc_size -= new_event->header.size;
-				free(new_event);
-			}
+			free_dup_event(oe, new_event);
 			return NULL;
 		}
 
@@ -135,10 +150,7 @@ void ordered_events__delete(struct ordered_events *oe, struct ordered_event *eve
 {
 	list_move(&event->list, &oe->cache);
 	oe->nr_events--;
-	if (oe->copy_on_queue) {
-		oe->cur_alloc_size -= event->event->header.size;
-		free(event->event);
-	}
+	free_dup_event(oe, event->event);
 }
 
 static int __ordered_events__flush(struct perf_session *s,
@@ -268,11 +280,7 @@ void ordered_events__free(struct ordered_events *oe)
 
 		event = list_entry(oe->to_free.next, struct ordered_event, list);
 		list_del(&event->list);
-		if (oe->copy_on_queue) {
-			oe->cur_alloc_size -= event->event->header.size;
-			free(event->event);
-		}
-
+		free_dup_event(oe, event->event);
 		free(event);
 	}
 }
