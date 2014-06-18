Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbaFRUEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 16:04:40 -0400
Received: from mail.kernel.org ([198.145.19.201]:37122 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754594AbaFRUEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 16:04:38 -0400
Date: Wed, 18 Jun 2014 17:04:32 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        dsahern@gmail.com, jolsa@redhat.com, xiaoguangrong@linux.vnet.ibm.com,
        yangds.fnst@cn.fujitsu.com, adrian.hunter@intel.com,
        namhyung@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] perf trace: add support for pagefault tracing
Message-ID: <20140618200432.GA20252@kernel.org>
References: <1403103565-6388-1-git-send-email-stfomichev@yandex-team.ru>
 <1403103565-6388-2-git-send-email-stfomichev@yandex-team.ru>
 <20140618154751.GC2702@kernel.org>
 <20140618174254.GD15620@stfomichev-desktop.yandex.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140618174254.GD15620@stfomichev-desktop.yandex.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jun 18, 2014 at 09:42:54PM +0400, Stanislav Fomichev escreveu:
> > I try, when possible, to not use short options that are used in
> > 'strace', so what if we use 'F' here?
> Agreed, will change.
> 
> > And:
> > 
> >    trace --pgfaults --pgfaults
> > 
> > for major and min page faults looks ugly, what if we instead use --pf
> > for both, and allow passing min or maj as args?
> > 
> > I.e.:
> > 
> > For both major and minor:
> > 
> >   trace --pf
> > 
> > for just major page faults:
> > 
> >   trace --pf maj
> Not sure I like it. Currently, when we need to trace page faults its
> major faults in 99.9% of cases, we are not interested in minor ones (and

If 99.9% of the cases is for for major faults, then make --pf default to
that :-) While allowing to change this behaviour via:

For just major faults:

	trace --pf

For all kinds:

	trace --pf all

For just minor faults:

	trace --pf min

Sure you can have the shorthand that -FF means "--pf all"

What I'm trying to avoid is to have to use with long options:

	trace --pf --pf

Also, with your scheme, how would I ask for just minor faults, if
somebody happens to want that?

> there are thousands of them in a second). So we just do 'perf trace -F'.
> If we need minor faults, we are probably interested in all fault events,
> so we do -F twice.
> 
> With 'trace --pf' we by default hit our 0.01% use case, so we always
> need to type 'trace --pf maj'. --pf may be clear from the documentation
> standpoint, but I don't like the fact that --pf defaults to all faults.

So make it default to the most common case :-)

> > > +	int			trace_pgfaults;

> > uint8_t should be enough
> By using int I state: 'I don't care about underlying type, give me
> something to count'. If we use uint8_t it would imply (to me) that
> for some reason we care about struct layout, size, endianness, etc.
> IOW, I don't think we need to care about +-3 bytes here.

Guess I've been using pahole too much... ;-)

Also, uint8_t is something that can count, as is u8, that is more
commonly used in tools/perf/ to make it look like kernel code :-)

But nah, not a biggie, just trying to be judicious in using types.
 
> > > -typedef int (*tracepoint_handler)(struct trace *trace, struct perf_evsel *evsel,
> > > +typedef int (*tracepoint_handler)(struct trace *trace,
> > > +				  union perf_event *event,
> > > +				  struct perf_evsel *evsel,
> > >  				  struct perf_sample *sample);
> > 
> > You'll reduce patch size if you leave the first line alone and just add
> > the new parameter (event) after evsel.
> > 
> > It'll become then:
> > 
> >  typedef int (*tracepoint_handler)(struct trace *trace, struct perf_evsel *evsel,
> > +				  union perf_event *event,
> >  				  struct perf_sample *sample);
> > 
> > Then please make one separate patch adding this new parameter, stating
> > that it will be used by pagefault tracing, that will come in a followup
> > patch in this series.
> Agreed, thanks.
> 
> > > +static bool valid_dso(struct addr_location *al, struct perf_sample *sample)
> > 
> > Humm, can't this be reduced to just:
> > 
> >       return al->map && al->map->dso;
> > 
> > ? I.e. if the helper returned a dso, it is because the address that was
> > looked up is in that dso, no?
> > 
> > I even guess that if there is al->map, that should be enough to check,
> > byt haven't thought this thru nor looked at the relevant sources, in a
> > hurry now.
> Yes, we don't need to check for ->dso, it's always non-null, I'll remove
> the check.
> But we do need to check for the range. Because
> thread__find_addr_map searches for the closest map using only ->start and
> doesn't check if address is within map range (->end).
> Maybe we need to fix it in thread__find_addr_map so it always returns valid map?

That is my expectation, yes, if I ask for the map where address N is, it
should return just that, where have you found this bug?

The thread__find_addr_map will end up calling maps__find() and it does
this:

                if (ip < m->start)
                        p = &(*p)->rb_left;
                else if (ip > m->end)
                        p = &(*p)->rb_right;
                else
                        return m;

Where is the problem?

> > Please separate adding page fault tracing recording on a file in a
> > separate patch from adding it to live mode, then the changelog message
> > can concentrate on examples for each feature.
> Ok.
> 
> > > -			if (sample.raw_data == NULL) {
> > > +			if (evsel->attr.type != PERF_TYPE_SOFTWARE &&
> > > +			    sample.raw_data == NULL) {
> > 
> > This looks like a separate patch with relevant associated changelog
> > message explaining why this is needed.
> No, this belongs here. When we enable page faults, they don't have any
> raw data (while syscalls have). So we still want to keep this check for
> syscalls but don't want it for fault events.

Understood the intent, but the test here is really:

		if (evsel->attr.type == PERF_TYPE_TRACEPOINT &&
		    sample.raw_data == NULL)

Ok?
 
> > > +	if (evsel &&
> > > +	    (perf_evsel__init_syscall_tp(evsel, trace__sys_enter) < 0 ||
> > > +	    perf_evsel__init_sc_tp_ptr_field(evsel, args))) {
> > >  		pr_err("Error during initialize raw_syscalls:sys_enter event\n");
> > >  		goto out;
> > 
> > the above can be ditched, not needed. Care to explain if you think
> > otherwise?

> This doesn't belong to this patch, but it's required because we can do
> 'trace --no-syscalls -F' and get only fault events without syscall events;
> we don't want to fail here.
> Will move to appropriate patch.

Thanks
 
> > > +	evlist__for_each(session->evlist, evsel) {
> > > +		if (evsel->attr.type == PERF_TYPE_SOFTWARE &&
> > > +		    (evsel->attr.config == PERF_COUNT_SW_PAGE_FAULTS_MAJ ||
> > > +		     evsel->attr.config == PERF_COUNT_SW_PAGE_FAULTS_MIN ||
> > > +		     evsel->attr.config == PERF_COUNT_SW_PAGE_FAULTS))
> > > +			evsel->handler = trace__pgfault;
> > 
> > the above looks ugly, can't we set the handler when adding the events?
> > Or is this just for the perf.data handling case? Have to dig deeper,
> > just a first feeling.
> It's for perf.data parsing. If you know a better way to do it without
> iterating over all events, pls let me know.

We had something related in a perf_evlist__set_tracepoint_handlers(),
but this case is for a software event, so we would need a
perf_evlist__set_attr_handlers(), I can do that later, for now this is
the only user, as this evsel->handler thing was introduced with 'trace',
so keep it like this, I can revisit this later.
 
> > >  	}
> > >  
> > >  	err = parse_target_str(trace);
> > > @@ -2290,6 +2416,8 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
> > >  			.user_interval = ULLONG_MAX,
> > >  			.no_buffering  = true,
> > >  			.mmap_pages    = 1024,
> > > +			.sample_address	= true,
> > > +			.sample_time	= true,
> > 
> > The above should be made conditional, i.e. if --pf is used?
> Yes, fixed, thanks.

Also, have you considered using:

[root@zoo ~]# perf list exceptions:page_fault*
  exceptions:page_fault_user                         [Tracepoint event]
  exceptions:page_fault_kernel                       [Tracepoint event]
[root@zoo ~]#

Instead? I need to check if they're completely equivalent to what we
need here...

- Arnaldo
