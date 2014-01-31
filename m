Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334AbaAaPEg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 10:04:36 -0500
Received: from mail-yk0-f169.google.com ([209.85.160.169]:35723 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976AbaAaPEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 10:04:35 -0500
Date: Fri, 31 Jan 2014 12:04:15 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Pekka Enberg <penberg@iki.fi>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Gaurav Jain <gjain@fb.com>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] perf tools: Fix JIT profiling on heap
Message-ID: <20140131150415.GA26494@ghostprotocols.net>
References: <1389836971-3549-1-git-send-email-namhyung@kernel.org>
 <52EB8E03.1030505@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52EB8E03.1030505@iki.fi>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jan 31, 2014 at 01:50:27PM +0200, Pekka Enberg escreveu:
> On 01/16/2014 03:49 AM, Namhyung Kim wrote:
> >Gaurav reported that perf cannot profile JIT program if it executes
> >the code on heap.  This was because current map__new() only handle JIT
> >on anon mappings - extends it to handle no_dso (heap, stack) case too.
> >
> >This patch assumes JIT profiling only provides dynamic function
> >symbols so check the mapping type to distinguish the case.  It'd
> >provide no symbols for data mapping - if we need to support symbols on
> >data mappings later it should be changed.
> >
> >Reported-by: Gaurav Jain <gjain@fb.com>
> >Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> 
> Looks OK to me.  Gaurav, does this fix your problem?

Yes, he tested it, etc, its already in Linus' tree:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/tools/perf/util/map.c?id=578c03c86fadcc6fd7319ddf41dd4d1d88aab77a

- Arnaldo
 
> >---
> >  tools/perf/util/map.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> >diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
> >index 9b9bd719aa19..ee1dd687a262 100644
> >--- a/tools/perf/util/map.c
> >+++ b/tools/perf/util/map.c
> >@@ -69,7 +69,7 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
> >  		map->ino = ino;
> >  		map->ino_generation = ino_gen;
> >-		if (anon) {
> >+		if ((anon || no_dso) && type == MAP__FUNCTION) {
> >  			snprintf(newfilename, sizeof(newfilename), "/tmp/perf-%d.map", pid);
> >  			filename = newfilename;
> >  		}
> >@@ -93,7 +93,7 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
> >  			 * functions still return NULL, and we avoid the
> >  			 * unnecessary map__load warning.
> >  			 */
> >-			if (no_dso)
> >+			if (type != MAP__FUNCTION)
> >  				dso__set_loaded(dso, map->type);
> >  		}
> >  	}
