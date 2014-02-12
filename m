Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbaBLOSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 09:18:55 -0500
Received: from merlin.infradead.org ([205.233.59.134]:39020 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbaBLOSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 09:18:53 -0500
Date: Wed, 12 Feb 2014 11:18:37 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Anton Blanchard <anton@samba.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Michael Ellerman <michaele@au1.ibm.com>
Subject: Re: [PATCH 06/35] perf hists: Leave symbol addr hist bucket auto
 alloc to symbol layer
Message-ID: <20140212141837.GB7116@ghostprotocols.net>
References: <1387566550-3524-1-git-send-email-acme@infradead.org>
 <1387566550-3524-7-git-send-email-acme@infradead.org>
 <20140212182316.44a10ca6@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212182316.44a10ca6@kryten>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Feb 12, 2014 at 06:23:16PM +1100, Anton Blanchard escreveu:
> Hi,
> 
> > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> > 
> > Since now symbol__addr_inc_samples() does the auto alloc, no need to
> > do it prior to calling hist_entry__inc_addr_samples.
> 
> perf annotate on a ppc64 build (no TUI) is failing. I get zero output.
> I haven't had a chance to look closer, but I used the following git
> bisect test script to isolate:

Can you try the following patch?

It should fix another problem, i.e. we were allocating, but annotation
would fail in the !TUI case, as it would return at
symbol__inc_addr_samples when use_browser != 1, now it will allocate and
mark the right bucket.

I'll have this in perf/urgent and will do the optimization of not
allocating those buckets in the report case when not doing integrated
annotation, i.e. report --stdio doesn't provide a way to go to the
annotation --stdio, so no point on allocating the buckets. Just on
'annotate --stdio' we should allocate it, etc.

- Arnaldo

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 469eb679fb9d..7cf522523c12 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -489,7 +489,7 @@ static int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
 {
 	struct annotation *notes;
 
-	if (sym == NULL || use_browser != 1 || !sort__has_sym)
+	if (sym == NULL || !sort__has_sym)
 		return 0;
 
 	notes = symbol__annotation(sym);
