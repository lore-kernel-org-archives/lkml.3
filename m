Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbaJJUHO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 16:07:14 -0400
Received: from mail.kernel.org ([198.145.19.201]:39948 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbaJJUHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 16:07:13 -0400
Date: Fri, 10 Oct 2014 17:07:08 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Jean Pihet <jean.pihet@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fu Wei <fu.wei@linaro.org>, Robert Richter <rric@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/1] rasd: Use perf_evlist__open() instead of open coded
Message-ID: <20141010200708.GB18775@kernel.org>
References: <CAFrcx1kufO2yj7--UiL841Yp5Es5=WqjL__Yzg=-+nPV5XoohA@mail.gmail.com>
 <20141006212606.GF14113@kernel.org>
 <CAFrcx1=swP-3E_pxWEcozFJhL+5YaUBPavQX=OfMtc8h4e=bDg@mail.gmail.com>
 <20141007133236.GG14113@kernel.org>
 <20141007140433.GG30146@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141007140433.GG30146@pd.tnic>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 07, 2014 at 04:04:33PM +0200, Borislav Petkov escreveu:
> On Tue, Oct 07, 2014 at 10:32:36AM -0300, Arnaldo Carvalho de Melo wrote:
> > Hopefully we will completely remove the need to set up any thread or cpu
> > map, as what you want is syswide tracing, right?
> 
> Yeah, I was questioning the need to open at least one thread even for
> system-wide tracing.

Ok, so what is now at my perf/hists branch at:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git

should do the trick, the patch below makes rasd.c use it. I'll try
building rasd.c with it and checking if it works.

Never having tried this, what are the requisites to test it? Some
specific hardware and a kernel with the right tracepoint? I guess some
recent 3.17-rc kernel is all that I need?

- Arnaldo

---

[PATCH] rasd: Use perf_evlist__open() instead of open coded equivalent

Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 src/rasd.c | 23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff --git a/src/rasd.c b/src/rasd.c
index 06ccdcdd9d56..d3df9868388c 100644
--- a/src/rasd.c
+++ b/src/rasd.c
@@ -241,9 +241,6 @@ static void daemonize(void)
 
 int main()
 {
-	struct perf_evsel *c;
-	struct thread_map *threads;
-	struct cpu_map *cpus;
 	int i;
 
 	/* Run the process as a daemon */
@@ -266,24 +263,10 @@ int main()
 	if (read_config_file())
 		err("error reading config file");
 
-	/* Set cpu and threads maps */
-	threads = thread_map__new(-1, getpid(), UINT_MAX);
-	if (threads == NULL)
-		err("allocating threads_map\n");
-
-	cpus = cpu_map__new(NULL);
-	if (cpus == NULL)
-		err("allocating cpu_map\n");
-
-	perf_evlist__set_maps(evlist, cpus, threads);
-
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

