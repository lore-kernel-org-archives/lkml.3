Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbaJFV0N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 17:26:13 -0400
Received: from mail.kernel.org ([198.145.19.201]:57696 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825AbaJFV0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 17:26:11 -0400
Date: Mon, 6 Oct 2014 18:26:06 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fu Wei <fu.wei@linaro.org>, Robert Richter <rric@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 1/1] rasd: Use perf_evlist__open() instead of open coded
Message-ID: <20141006212606.GF14113@kernel.org>
References: <CAFrcx1kufO2yj7--UiL841Yp5Es5=WqjL__Yzg=-+nPV5XoohA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFrcx1kufO2yj7--UiL841Yp5Es5=WqjL__Yzg=-+nPV5XoohA@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heya, please check if this is OK.

This was while looking the set of methods used by rasd, trying to reduce
it to the bare minimum.

Perhaps even that cpu_map__new() one can be ditched, leaving to use the
default of a NULL cpumap that will end up being one with -1, i.e. all
cpus.

- Arnaldo

>From 8dc34bd2824c7843182f4fc6deabaf573e42e806 Mon Sep 17 00:00:00 2001
From: Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Mon, 6 Oct 2014 15:43:42 -0300
Subject: [PATCH] rasd: Use perf_evlist__open() instead of open coded
 equivalent

Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 src/rasd.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/src/rasd.c b/src/rasd.c
index 06ccdcdd9d56..fb33fca131fa 100644
--- a/src/rasd.c
+++ b/src/rasd.c
@@ -241,7 +241,6 @@ static void daemonize(void)
 
 int main()
 {
-	struct perf_evsel *c;
 	struct thread_map *threads;
 	struct cpu_map *cpus;
 	int i;
@@ -278,12 +277,9 @@ int main()
 	perf_evlist__set_maps(evlist, cpus, threads);
 
 	/* Open events */
-	evlist__for_each(evlist, c) {
-		/* On all online cpus by default, system wide tracing */
-		if (perf_evsel__open(c, evlist->cpus, NULL) < 0)
-			err("opening tracepoint, are you root?");
-	}
-	perf_evlist__set_id_pos(evlist);
+	/* On all online cpus by default, system wide tracing */
+	if (perf_evlist__open(evlist) < 0)
+		err("opening tracepoint, are you root?");
 
 	/* mmap buffers */
 	if (perf_evlist__mmap(evlist, 4 /* opts->mmap_pages */, false) < 0)
-- 
1.9.3

