Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267AbaCQBpz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 21:45:55 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:61604 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070AbaCQBpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 21:45:52 -0400
X-AuditID: 9c93016f-b7b09ae000000557-10-532653ce82c2
From: Namhyung Kim <namhyung@kernel.org>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@redhat.com, jolsa@redhat.com, jmario@redhat.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] perf: Speed up thread map generation
In-Reply-To: <1394808224-113774-1-git-send-email-dzickus@redhat.com> (Don
	Zickus's message of "Fri, 14 Mar 2014 10:43:44 -0400")
References: <1394808224-113774-1-git-send-email-dzickus@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
Date: Mon, 17 Mar 2014 10:45:49 +0900
Message-ID: <87ob15tx6a.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Don,

On Fri, 14 Mar 2014 10:43:44 -0400, Don Zickus wrote:
> When trying to capture perf data on a system running spejbb2013,
> perf hung for about 15 minutes.  This is because it took that
> long to gather about 10,000 thread maps and process them.
>
> I don't think a user wants to wait that long.
>
> Instead, recognize that thread maps are roughly equivalent to
> pid maps and just quickly copy those instead.
>
> To do this, I synthesize 'fork' events, this eventually calls
> thread__fork() and copies the maps over.
>
> The overhead goes from 15 minutes down to about a few seconds.

[SNIP]
> @@ -416,6 +453,10 @@ int perf_event__synthesize_threads(struct perf_tool *tool,
>  	if (mmap_event == NULL)
>  		goto out_free_comm;
>  
> +	fork_event = malloc(sizeof(fork_event->fork) + machine->id_hdr_size);
> +	if (fork_event == NULL)
> +		goto out_free_mmap;
> +
>  	if (machine__is_default_guest(machine))
>  		return 0;

Not related to this patch, but this will causes a memory leak..
So I think below patch is needed on top (not sure it's also needed for
perf_event__synthesize_thread_map() too).


>From 3c4b49b4f540c7d49ee78364b02faa0bfce59c67 Mon Sep 17 00:00:00 2001
From: Namhyung Kim <namhyung@kernel.org>
Date: Mon, 17 Mar 2014 10:23:06 +0900
Subject: [PATCH] perf tools: Fix a possible memory leak

Checking default guest machine should be done before allocating event
structures otherwise it'll leak memory.

Cc: Don Zickus <dzickus@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/event.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 3e580be0f6fb..eab930d28159 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -445,6 +445,9 @@ int perf_event__synthesize_threads(struct perf_tool *tool,
 	union perf_event *comm_event, *mmap_event, *fork_event;
 	int err = -1;
 
+	if (machine__is_default_guest(machine))
+		return 0;
+
 	comm_event = malloc(sizeof(comm_event->comm) + machine->id_hdr_size);
 	if (comm_event == NULL)
 		goto out;
@@ -457,9 +460,6 @@ int perf_event__synthesize_threads(struct perf_tool *tool,
 	if (fork_event == NULL)
 		goto out_free_mmap;
 
-	if (machine__is_default_guest(machine))
-		return 0;
-
 	snprintf(proc_path, sizeof(proc_path), "%s/proc", machine->root_dir);
 	proc = opendir(proc_path);
 
-- 
1.7.11.7

