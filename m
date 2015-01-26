Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbbAZOPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 09:15:12 -0500
Received: from mga11.intel.com ([192.55.52.93]:37293 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910AbbAZOPI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 09:15:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,469,1418112000"; 
   d="scan'208";a="642656572"
From: "Liang, Kan" <kan.liang@intel.com>
To: "'Arnaldo Carvalho de Melo'" <acme@kernel.org>
CC: "jolsa@redhat.com" <jolsa@redhat.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: RE: [PATCH V6 1/1] perf tool: perf diff support for different
 binaries
Thread-Topic: [PATCH V6 1/1] perf tool: perf diff support for different
 binaries
Thread-Index: AQHQKcCYJ7KOEpNzNUyoh7SK6Z35IZzPtuNg
Date: Mon, 26 Jan 2015 14:15:01 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F077016A5F6F@SHSMSX103.ccr.corp.intel.com>
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



> 
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


Hi Arnaldo,

I tried the 2009 version perf diff. The code still only work for the same binaries.

Although it compared by name, it used a global list of dsos. 
That means the binaries which has same name can only be loaded once. It's OK
for same binaries. But for different binaries, it's a problem. For example, we have
an old binary and an updated binary. They very likely have same name and most
of the function. So only dsos from old binary will be loaded. When processing the
data from updated binary, perf still use the symbol information from old binary. 
That's wrong for different binaries.

Then about two weeks later, the patch as below to use IP to replace symbol name.

author	Arnaldo Carvalho de Melo <acme@redhat.com>	2009-12-29 00:48:36 (GMT)
committer	Ingo Molnar <mingo@elte.hu>	2009-12-30 11:00:00 (GMT)
commit	9c443dfdd31eddea6cbe6ee0ca469fbcc4e1dc3b (patch)
tree	6e217aaf89b941fbbc7b905046d5350392d642db /tools/perf
parent	cdbae31408cf39372402076cf2e189ec693daa71 (diff)
perf diff: Fix support for all --sort combinations


The global dsos is discarded from a patch in 2010. Since the previous patch has already
use the IP to compare. So it still doesn't work for different binaries

author	Zhang, Yanmin <yanmin_zhang@linux.intel.com>	2010-04-19 05:32:50 (GMT)
committer	Avi Kivity <avi@redhat.com>	2010-04-19 09:37:24 (GMT)
commit	a1645ce12adb6c9cc9e19d7695466204e3f017fe (patch)
tree	5d31aaaf534997e6e9cebc07f38eca35f76986cf /tools/perf
parent	ff9d07a0e7ce756a183e7c2e483aec452ee6b574 (diff)
perf: 'perf kvm' tool for monitoring guest performance from host


So I think perf diff never works for different binaries.  My patch should not be a bug fix,
but a feature enhancement as I mentioned in the description. 

What do you think?

Thanks,
Kan


> I.e. this is not changing an existing correct behaviour, but fixing a bug, i.e.
> the changeset comment confused me :-\
> 
> Now I'm trying to figure out _when_ this got broken, what was the
> reasoning for that code to have changed in a way that made it not match
> by dso_name, symbol_name.
> 
> Also please, when providing code to be built to reproduce your results,
> make it self contained,  i.e. in the case below, I had to replace "noinline"
> with "__attribute__((noinline))".
> 
> - Arnaldo
> 

