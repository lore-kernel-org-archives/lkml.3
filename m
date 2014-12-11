Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934520AbaLKVqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 16:46:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933134AbaLKVqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 16:46:44 -0500
Date: Thu, 11 Dec 2014 22:46:23 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        namhyung@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 03/10] perf, tools: Use al.addr to set up call chain
Message-ID: <20141211214623.GD26788@krava.redhat.com>
References: <1415844328-4884-1-git-send-email-andi@firstfloor.org>
 <1415844328-4884-4-git-send-email-andi@firstfloor.org>
 <20141113191633.GE3612@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141113191633.GE3612@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 04:16:33PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Nov 12, 2014 at 06:05:21PM -0800, Andi Kleen escreveu:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > Use the relative address, this makes get_srcline work correctly
> > in the end.
> 
> Applied.
>  
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> > ---
> >  tools/perf/util/machine.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> > index 2e16d69..066e963 100644
> > --- a/tools/perf/util/machine.c
> > +++ b/tools/perf/util/machine.c
> > @@ -1411,7 +1411,7 @@ static int add_callchain_ip(struct thread *thread,
> >  		}
> >  	}
> >  
> > -	return callchain_cursor_append(&callchain_cursor, ip, al.map, al.sym);
> > +	return callchain_cursor_append(&callchain_cursor, al.addr, al.map, al.sym);
> >  }
> >  
> >  struct branch_info *sample__resolve_bstack(struct perf_sample *sample,
> > -- 
> > 1.9.3

hi,
this patch also changed the output of callchain entries
with 'map' but with no symbol, like in following diff:

---
                  ---get_next_seq
                     |
-                    |--70.16%-- 0x40e1cf
+                    |--70.16%-- 0xe1cf
                     |          0x841f0f
                     |
-                    |--25.83%-- 0x40e153
+                    |--25.83%-- 0xe153
                     |          0x841f0f
                     |
-                     --4.00%-- 0x40e27f
+                     --4.00%-- 0xe27f
--

I'm guessing this change was unintentional..? in case we have a map
but no symbol seeing full address is more clear than relative at
least for binary, not sure about DSOs..

thoughts?

thanks,
jirka


---
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 64b377e591e4..a4fb25fb26f5 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -816,22 +816,30 @@ out:
 char *callchain_list__sym_name(struct callchain_list *cl,
 			       char *bf, size_t bfsize, bool show_dso)
 {
+	struct map *map = cl->ms.map;
 	int printed;
 
 	if (cl->ms.sym) {
 		if (callchain_param.key == CCKEY_ADDRESS &&
-		    cl->ms.map && !cl->srcline)
-			cl->srcline = get_srcline(cl->ms.map->dso,
-						  map__rip_2objdump(cl->ms.map,
-								    cl->ip),
+		    map && !cl->srcline) {
+			cl->srcline = get_srcline(map->dso,
+						  map__rip_2objdump(map, cl->ip),
 						  cl->ms.sym, false);
+		}
 		if (cl->srcline)
 			printed = scnprintf(bf, bfsize, "%s %s",
 					cl->ms.sym->name, cl->srcline);
 		else
 			printed = scnprintf(bf, bfsize, "%s", cl->ms.sym->name);
-	} else
-		printed = scnprintf(bf, bfsize, "%#" PRIx64, cl->ip);
+	} else {
+		/*
+		 * The cl->ip value is unbased ip (applied map->map_ip).
+		 * Display the unmap ip in case we have no symbol.
+		 */
+		u64 addr = map ? map->unmap_ip(map, cl->ip) : cl->ip;
+
+		printed = scnprintf(bf, bfsize, "%#" PRIx64, addr);
+	}
 
 	if (show_dso)
 		scnprintf(bf + printed, bfsize - printed, " %s",

