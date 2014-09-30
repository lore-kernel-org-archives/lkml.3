Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452AbaI3NRl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 09:17:41 -0400
Received: from mail.kernel.org ([198.145.19.201]:48988 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbaI3NRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 09:17:40 -0400
Date: Tue, 30 Sep 2014 10:17:34 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>
Subject: Re: [PATCH v2 1/2] perf callchain: Create an address space per thread
Message-ID: <20140930131734.GA2799@kernel.org>
References: <1411966692-26648-1-git-send-email-namhyung@kernel.org>
 <20140929083452.GA1223@krava.brq.redhat.com>
 <87vbo5hc3a.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vbo5hc3a.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Sep 30, 2014 at 03:11:21PM +0900, Namhyung Kim escreveu:
> 
> On Mon, 29 Sep 2014 10:34:52 +0200, Jiri Olsa wrote:
> > On Mon, Sep 29, 2014 at 01:58:11PM +0900, Namhyung Kim wrote:
> >> @@ -37,6 +38,9 @@ struct thread *thread__new(pid_t pid, pid_t tid)
> >>  		thread->cpu = -1;
> >>  		INIT_LIST_HEAD(&thread->comm_list);

> >> +		if (unwind__prepare_access(thread) < 0)
> >> +			goto err_thread;

> > So this is something we need to do only for DWARF unwind via libunwind.
> > Do we want some condition to bypass this in for the rest of the cases?
 
> Ah, you're right, we need to check that before doing this.

> > I think we could check for symbol_conf.use_callchain and for the
> > PERF_SAMPLE_REGS_USER|PERF_SAMPLE_STACK_USER sample types in evlist,
> > something like:

> >   bool has_dwarf_data_for_callchains = symbol_conf.use_callchain && evlist_sample_type_has(evlist, PERF_SAMPLE_REGS_USER|PERF_SAMPLE_STACK_USER)

> Hmm.. it seems that it's hard to get the evlist at this point.  Maybe we
> need to add a field in the symbol_conf or a global variable.. :/

Please don't export evlist in a global way, just set some flag on
symbol_conf.

At some point we need to ditch even symbol_conf :-\

- Arnaldo
