Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934530Ab3DSVqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 17:46:22 -0400
Received: from mail.openrapids.net ([64.15.138.104]:58641 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933393Ab3DSVqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 17:46:21 -0400
Date: Fri, 19 Apr 2013 17:46:16 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: kpark3469@gmail.com, keun-o.park@windriver.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] tracepoints: prevents null probe from being added
Message-ID: <20130419214616.GB9588@Krystal>
References: <1365991995-19445-1-git-send-email-kpark3469@gmail.com> <1366407596.9609.129.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366407596.9609.129.camel@gandalf.local.home>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Mon, 2013-04-15 at 11:13 +0900, kpark3469@gmail.com wrote:
> > From: Sahara <keun-o.park@windriver.com>
> > 
> > Somehow tracepoint_entry_add_probe function allows a null probe function.
> > And, this may lead to unexpected result since the number of probe
> > functions in an entry can be counted by checking whether probe is null
> > or not in for-loop.
> > This patch prevents the null probe from being added.
> > In tracepoint_entry_remove_probe function, checking probe parameter
> > within for-loop is moved out for code efficiency leaving the null probe
> > feature which removes all probe functions in the entry.
> > 
> > Signed-off-by: Sahara <keun-o.park@windriver.com>
> > Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
> > Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> 
> BTW, do not add tags that were not given to you. "Reviewed-by" has a
> meaning, more than just someone that reviewed your patch. It means that
> they not only reviewed your patch but couldn't find anything wrong with
> it. As both Mathieu and I had comments, that does not deserve a
> "Reviewed-by" tag.
> 
> I'm not even sure that Mathieu gave an "Acked-by". I thought he did, but
> I can't seem to find it. Mathieu?

I don't recall, but all my comments were addressed. In order to clear
any confusion:

Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

Thanks,

Mathieu

> 
> Anyway, I'll start testing this patch as it seems fine with me (although
> I still wouldn't give a Reviewed-by tag).
> 
> Thanks,
> 
> -- Steve
> 
> > ---
> >  kernel/tracepoint.c |   21 +++++++++++++--------
> >  1 files changed, 13 insertions(+), 8 deletions(-)
> > 
> > diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> > index 0c05a45..29f2654 100644
> > --- a/kernel/tracepoint.c
> > +++ b/kernel/tracepoint.c
> > @@ -112,7 +112,8 @@ tracepoint_entry_add_probe(struct tracepoint_entry *entry,
> >  	int nr_probes = 0;
> >  	struct tracepoint_func *old, *new;
> >  
> > -	WARN_ON(!probe);
> > +	if (WARN_ON(!probe))
> > +		return ERR_PTR(-EINVAL);
> >  
> >  	debug_print_probes(entry);
> >  	old = entry->funcs;
> > @@ -152,13 +153,18 @@ tracepoint_entry_remove_probe(struct tracepoint_entry *entry,
> >  
> >  	debug_print_probes(entry);
> >  	/* (N -> M), (N > 1, M >= 0) probes */
> > -	for (nr_probes = 0; old[nr_probes].func; nr_probes++) {
> > -		if (!probe ||
> > -		    (old[nr_probes].func == probe &&
> > -		     old[nr_probes].data == data))
> > -			nr_del++;
> > +	if (probe) {
> > +		for (nr_probes = 0; old[nr_probes].func; nr_probes++) {
> > +			if (old[nr_probes].func == probe &&
> > +			     old[nr_probes].data == data)
> > +				nr_del++;
> > +		}
> >  	}
> >  
> > +	/*
> > +	 * If probe is NULL, then nr_probes = nr_del = 0, and then the
> > +	 * entire entry will be removed.
> > +	 */
> >  	if (nr_probes - nr_del == 0) {
> >  		/* N -> 0, (N > 1) */
> >  		entry->funcs = NULL;
> > @@ -173,8 +179,7 @@ tracepoint_entry_remove_probe(struct tracepoint_entry *entry,
> >  		if (new == NULL)
> >  			return ERR_PTR(-ENOMEM);
> >  		for (i = 0; old[i].func; i++)
> > -			if (probe &&
> > -			    (old[i].func != probe || old[i].data != data))
> > +			if (old[i].func != probe || old[i].data != data)
> >  				new[j++] = old[i];
> >  		new[nr_probes - nr_del].func = NULL;
> >  		entry->refcount = nr_probes - nr_del;
> 
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
