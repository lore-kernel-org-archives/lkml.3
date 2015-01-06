Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbbAFQjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 11:39:48 -0500
Received: from mga11.intel.com ([192.55.52.93]:59938 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754600AbbAFQjp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 11:39:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,708,1413270000"; 
   d="scan'208";a="647075340"
From: "Liang, Kan" <kan.liang@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
CC: "jolsa@redhat.com" <jolsa@redhat.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: RE: [PATCH V6 1/1] perf tool: perf diff support for different
 binaries
Thread-Topic: [PATCH V6 1/1] perf tool: perf diff support for different
 binaries
Thread-Index: AQHQKcCYJ7KOEpNzNUyoh7SK6Z35IZyzRCcA
Date: Tue, 6 Jan 2015 16:39:20 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F07701693397@SHSMSX103.ccr.corp.intel.com>
References: <1417534758-26416-1-git-send-email-kan.liang@intel.com>
 <20150106145356.GA10675@kernel.org>
In-Reply-To: <20150106145356.GA10675@kernel.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> Em Tue, Dec 02, 2014 at 10:39:18AM -0500, kan.liang@intel.com escreveu:
> > From: Kan Liang <kan.liang@intel.com>
> >
> > Currently, the perf diff only works with same binaries. That's because
> > it compares the symbol start address. It doesn't work if the perf.data
> > comes from different binaries. This patch matches the function names.
> 
> Sorry Kan, I saw these patches, its just that it the above statement looked
> completely strange to me, i.e. of course it should look at the dso name,
> then at the symbol name, comparing via addresses makes no sense to me,
> so I kept leaving this patch to look after processing other patches and doing
> other things, then the year end holidays, etc.
> 
> So now I'm looking at old code, from 2009:
> 
>   commit 604c5c92972dcb4b98be34775452d09a5d4ec248
>   Author: Arnaldo Carvalho de Melo <acme@redhat.com>
>   Date:   Wed Dec 16 14:09:53 2009 -0200
> 
>     perf diff: Change the default sort order to "dso,symbol"
> 
>     This is a more intuitive / more meaningful default:
> 
>     $ perf diff | head -8
>          9.02%     +1.00%  libc-2.10.1.so               [.] _IO_vfprintf_internal
>          2.91%     -1.00%  [kernel]                     [k] __kmalloc
>          2.85%     -1.00%  [kernel]                     [k] ext4_htree_store_dirent
>          1.99%     -1.00%  [kernel]                     [k] _atomic_dec_and_lock
>          2.44%             [kernel]
>     $
> 
>     Suggested-by: Ingo Molnar <mingo@elte.hu>
> 
> and I see:
> 
> static void perf_session__match_hists(struct perf_session *old_session,
>                                       struct perf_session *new_session) {
>         struct rb_node *nd;
> 
>         perf_session__resort_by_name(old_session);
> 
>         for (nd = rb_first(&new_session->hists); nd; nd = rb_next(nd)) {
>                 struct hist_entry *pos = rb_entry(nd, struct hist_entry, rb_node);
>                 pos->pair = perf_session__find_hist_entry_by_name(old_session,
> pos);
>         }
> }
> 
> Ok, it will process all samples, store everything in hist_entries, etc, then
> traverse all entries in the most recent perf.data file and look for a pair, _by
> name_:
> 
> static struct hist_entry *
> perf_session__find_hist_entry_by_name(struct perf_session *self,
>                                       struct hist_entry *he) {
>         struct rb_node *n = self->hists.rb_node;
> 
>         while (n) {
>                 struct hist_entry *iter = rb_entry(n, struct hist_entry, rb_node);
>                 int cmp = strcmp(he->map->dso->name, iter->map->dso->name);
> 
>                 if (cmp > 0)
>                         n = n->rb_left;
>                 else if (cmp < 0)
>                         n = n->rb_right;
>                 else {
>                         cmp = strcmp(he->sym->name, iter->sym->name);
>                         if (cmp > 0)
>                                 n = n->rb_left;
>                         else if (cmp < 0)
>                                 n = n->rb_right;
>                         else
>                                 return iter;
>                 }
>         }
> 
>         return NULL;
> }
> 
> See? Resort the old session by "dso,symbol_name", then go on pairing
> them.
> 
> So at some point this got broken :-\
> 
> I.e. this is not changing an existing correct behaviour, but fixing a bug, i.e.
> the changeset comment confused me :-\
> 
> Now I'm trying to figure out _when_ this got broken, what was the
> reasoning for that code to have changed in a way that made it not match
> by dso_name, symbol_name.
> 


It looks it got broken just after two weeks later in 2009. 
perf_session__find_hist_entry_by_name was replaced by hist_entry__cmp.
After that it doesn't compares the name any more.


commit 9c443dfdd31eddea6cbe6ee0ca469fbcc4e1dc3b
Author: Arnaldo Carvalho de Melo <acme@redhat.com>
Date:   Mon Dec 28 22:48:36 2009 -0200

    perf diff: Fix support for all --sort combinations

@@ -122,29 +112,28 @@ static void perf_session__resort_by_name(struct perf_session *self)
        self->hists = tmp;
 }

+static void perf_session__set_hist_entries_positions(struct perf_session *self)
+{
+       perf_session__output_resort(self, self->events_stats.total);
+       perf_session__resort_hist_entries(self);
+}
+
 static struct hist_entry *
-perf_session__find_hist_entry_by_name(struct perf_session *self,
-                                     struct hist_entry *he)
+perf_session__find_hist_entry(struct perf_session *self,
+                             struct hist_entry *he)
 {
        struct rb_node *n = self->hists.rb_node;

        while (n) {
                struct hist_entry *iter = rb_entry(n, struct hist_entry, rb_node);
-               int cmp = strcmp(he->map->dso->name, iter->map->dso->name);
+               int64_t cmp = hist_entry__cmp(he, iter);

-               if (cmp > 0)
+               if (cmp < 0)
                        n = n->rb_left;
-               else if (cmp < 0)
+               else if (cmp > 0)
                        n = n->rb_right;
-               else {
-                       cmp = strcmp(he->sym->name, iter->sym->name);
-                       if (cmp > 0)
-                               n = n->rb_left;
-                       else if (cmp < 0)
-                               n = n->rb_right;
-                       else
-                               return iter;
-               }
+               else
+                       return iter;
        }

        return NULL;
@@ -155,11 +144,9 @@ static void perf_session__match_hists(struct perf_session *old_session,
 {
        struct rb_node *nd;

-       perf_session__resort_by_name(old_session);
-
        for (nd = rb_first(&new_session->hists); nd; nd = rb_next(nd)) {
                struct hist_entry *pos = rb_entry(nd, struct hist_entry, rb_node);
-               pos->pair = perf_session__find_hist_entry_by_name(old_session, pos);
+               pos->pair = perf_session__find_hist_entry(old_session, pos);
        }
 }




