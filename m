Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbbANBrj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 20:47:39 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:43173 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbbANBri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 20:47:38 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
Date: Wed, 14 Jan 2015 10:45:06 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 2/4] perf probe: Do not rely on map__load() filter to
 find symbols
Message-ID: <20150114014506.GC800@sejong>
References: <1420886028-15135-1-git-send-email-namhyung@kernel.org>
 <1420886028-15135-2-git-send-email-namhyung@kernel.org>
 <54B3BEA2.3020700@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <54B3BEA2.3020700@hitachi.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 09:31:30PM +0900, Masami Hiramatsu wrote:
> (2015/01/10 19:33), Namhyung Kim wrote:
> > The find_probe_trace_events_from_map() searches matching symbol from a
> > map (so from a backing dso).  For uprobes, it'll create a new map (and
> > dso) and loads it using a filter.  It's a little bit inefficient in that
> > it'll read out the symbol table everytime but works well anyway.
> > 
> > For kprobes however, it'll reuse existing kernel map which might be
> > loaded before.  In this case map__load() just returns with no result.
> > It makes kprobes always failed to find symbol even if it exists in the
> > map (dso).
> > 
> > To fix it, use map__find_symbol_by_name() instead.  It'll load a map
> > with full symbols and sorts them by name.  It needs to search sibing
> > nodes since there can be multiple (local) symbols with same name.  Now
> > resulting symbol references are saved in the funcs list.
> > 
> > Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> > Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> > ---
> >  tools/perf/util/probe-event.c | 101 ++++++++++++++++++++++++++++++++++++------
> >  1 file changed, 87 insertions(+), 14 deletions(-)
> > 
> > diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> > index 7f9b8632e433..e5af16988791 100644
> > --- a/tools/perf/util/probe-event.c
> > +++ b/tools/perf/util/probe-event.c
> > @@ -2191,20 +2191,86 @@ static int __add_probe_trace_events(struct perf_probe_event *pev,
> >  	return ret;
> >  }
> >  
> > -static char *looking_function_name;
> > -static int num_matched_functions;
> > +struct symbol_entry {
> > +	struct list_head node;
> > +	struct symbol *sym;
> > +};
> >  
> > -static int probe_function_filter(struct map *map __maybe_unused,
> > -				      struct symbol *sym)
> > +/* returns 1 if symbol was added, 0 if symbol was skipped, -1 if error */
> > +static int add_symbol_entry(struct symbol *sym, struct list_head *head)
> >  {
> > -	if ((sym->binding == STB_GLOBAL || sym->binding == STB_LOCAL) &&
> > -	    strcmp(looking_function_name, sym->name) == 0) {
> > -		num_matched_functions++;
> > +	struct symbol_entry *ent;
> > +
> > +	if (sym->binding != STB_GLOBAL && sym->binding != STB_LOCAL)
> >  		return 0;
> > -	}
> > +
> > +	ent = malloc(sizeof(*ent));
> > +	if (ent == NULL)
> > +		return -1;
> 
> return -ENOMEM; ?

Okay, will change.


> 
> > +
> > +	ent->sym = sym;
> > +	list_add(&ent->node, head);
> >  	return 1;
> >  }
> >  
> > +static int find_probe_functions(struct map *map, char *name, struct list_head *head)
> > +{
> > +	struct symbol *sym, *orig_sym;
> > +	struct symbol_entry *ent;
> > +	struct rb_node *node;
> > +	int found = 0;
> > +	int ret;
> > +
> > +	sym = map__find_symbol_by_name(map, name, NULL);
> > +	if (sym == NULL)
> > +		return 0;
> > +
> > +	ret = add_symbol_entry(sym, head);
> > +	if (ret < 0)
> > +		goto err;
> > +
> > +	found += ret;
> 
> If ret always be 1 in successful case, we'd better do "found++" here.
> And it also means we can do it shorter as below.
> 
> if (add_symbol_entry(sym, head) < 0)
> 	goto err;
> found++;

But it can return 0 in successful case like STB_WEAK..  I'm not sure
how we can handle the weak functions properly, but anyway the original
code already ignored the weak functions.


> 
> > +
> > +	/* search back and forth to find symbols that have same name */
> 
> Hmm, I see. but this code looks no-good sign... Can we have any generic
> synonym handling routine?

Like what?  I guess we can change map__find_symbol_by_name() to return
a list of symbols or add a new function to do it.  Is it okay to you?


> 
> Other parts looks good to me:)

Thanks for your review!
Namhyung
