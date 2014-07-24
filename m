Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312AbaGXNED (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 09:04:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32134 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759358AbaGXND7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 09:03:59 -0400
Date: Thu, 24 Jul 2014 14:57:51 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] perf report: Honor column width setting
Message-ID: <20140724125751.GC7652@krava.brq.redhat.com>
References: <1404883694-5342-1-git-send-email-namhyung@kernel.org>
 <1404883694-5342-5-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404883694-5342-5-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 02:28:12PM +0900, Namhyung Kim wrote:
> Set column width and do not change it if user gives -w/--column-widths
> option.  It'll truncate longer symbols than the width if exists.

SNIP

> --- a/tools/perf/util/sort.c
> +++ b/tools/perf/util/sort.c
> @@ -70,7 +70,9 @@ static int hist_entry__thread_snprintf(struct hist_entry *he, char *bf,
>  				       size_t size, unsigned int width)
>  {
>  	const char *comm = thread__comm_str(he->thread);
> -	return repsep_snprintf(bf, size, "%-*s:%5d", width - 6,
> +
> +	width = max(7U, width) - 6;
> +	return repsep_snprintf(bf, size, "%-*.*s:%5d", width, width,
>  			       comm ?: "", he->thread->tid);
>  }

also we now print out all sort headers left alligned, which is wrong for
sort_thread header: "Command:  Pid' that mirrors value strings with ':'
being aligned

maybe something like in attached patch..?

thanks,
jirka


---
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index f89714329c0f..fbbe86b7f63c 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -78,6 +78,7 @@ static int hist_entry__thread_snprintf(struct hist_entry *he, char *bf,
 
 struct sort_entry sort_thread = {
 	.se_header	= "Command:  Pid",
+	.se_header_right= true,
 	.se_cmp		= sort__thread_cmp,
 	.se_snprintf	= hist_entry__thread_snprintf,
 	.se_width_idx	= HISTC_THREAD,
@@ -1212,13 +1213,17 @@ static int __sort__hpp_header(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
 {
 	struct hpp_sort_entry *hse;
 	size_t len = fmt->user_len;
+	const char *fmt_str = "%-*.*s";
 
 	hse = container_of(fmt, struct hpp_sort_entry, hpp);
 
 	if (!len)
 		len = hists__col_len(&evsel->hists, hse->se->se_width_idx);
 
-	return scnprintf(hpp->buf, hpp->size, "%-*.*s", len, len, hse->se->se_header);
+	if (hse->se->se_header_right)
+		fmt_str = "%*.*s";
+
+	return scnprintf(hpp->buf, hpp->size, fmt_str, len, len, hse->se->se_header);
 }
 
 static int __sort__hpp_width(struct perf_hpp_fmt *fmt,
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 041f0c9cea2b..16a07b9b16c2 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -197,6 +197,7 @@ struct sort_entry {
 	struct list_head list;
 
 	const char *se_header;
+	bool se_header_right;
 
 	int64_t (*se_cmp)(struct hist_entry *, struct hist_entry *);
 	int64_t (*se_collapse)(struct hist_entry *, struct hist_entry *);
