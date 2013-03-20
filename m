Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab3CTSBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 14:01:19 -0400
Received: from mail.openrapids.net ([64.15.138.104]:52317 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752046Ab3CTSBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 14:01:18 -0400
Date: Wed, 20 Mar 2013 14:01:13 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: kpark3469@gmail.com, keun-o.park@windriver.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracepoints: prevents null probe from being added
Message-ID: <20130320180113.GA24537@Krystal>
References: <1363749497-12176-1-git-send-email-kpark3469@gmail.com> <1363800712.6345.17.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363800712.6345.17.camel@gandalf.local.home>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Wed, 2013-03-20 at 12:18 +0900, kpark3469@gmail.com wrote:
> > From: Sahara <keun-o.park@windriver.com>
> > 
> > Somehow tracepoint_entry_add/remove_probe functions allow a null probe
> > function.
> 
> You actually hit this in practice, or is this just something that you
> observe from code review?
> 
> >  Especially on getting a null probe in remove function, it seems
> > to be used to remove all probe functions in the entry.
> 
> Hmm, that actually sounds like a feature.

Yep. It's been a long time since I wrote this code, but the removal code
seems to use NULL probe pointer to remove all probes for a given
tracepoint.

I'd be tempted to just validate non-NULL probe within
tracepoint_entry_add_probe() and let other sites as is, just in case
anyone would be using this feature.

I cannot say that I have personally used this "remove all" feature much
though.

Thanks,

Mathieu

> 
> > But, the code is not handled as expected. Since the tracepoint_entry
> > maintains funcs array's last func as NULL in order to mark it as the end
> > of the array. Also NULL func is used in for-loop to check out the end of
> > the loop. So if there's NULL func in the entry's funcs, the for-loop
> > will be abruptly ended in the middle of operation.
> > Also checking out if probe is null in for-loop is not efficient.
> > 
> > Signed-off-by: Sahara <keun-o.park@windriver.com>
> > ---
> >  kernel/tracepoint.c |   18 ++++++++++++------
> >  1 files changed, 12 insertions(+), 6 deletions(-)
> > 
> > diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> > index 0c05a45..30f427e 100644
> > --- a/kernel/tracepoint.c
> > +++ b/kernel/tracepoint.c
> > @@ -112,7 +112,10 @@ tracepoint_entry_add_probe(struct tracepoint_entry *entry,
> >  	int nr_probes = 0;
> >  	struct tracepoint_func *old, *new;
> >  
> > -	WARN_ON(!probe);
> > +	if (unlikely(!probe)) {
> > +		WARN_ON(!probe);
> > +		return ERR_PTR(-EINVAL);
> > +	}
> 
> Um, you want:
> 
> 	if (WARN_ON(!probe))
> 		return ERR_PTR(-EINVAL);
> 
> >  
> >  	debug_print_probes(entry);
> >  	old = entry->funcs;
> > @@ -147,15 +150,19 @@ tracepoint_entry_remove_probe(struct tracepoint_entry *entry,
> >  
> >  	old = entry->funcs;
> >  
> > +	if (unlikely(!probe)) {
> > +		WARN_ON(!probe);
> > +		return ERR_PTR(-EINVAL);
> > +	}
> 
> Here too if it wasn't intended to allow removal of all probes from a
> tracepoint.
> 
> > +
> >  	if (!old)
> >  		return ERR_PTR(-ENOENT);
> >  
> >  	debug_print_probes(entry);
> >  	/* (N -> M), (N > 1, M >= 0) probes */
> >  	for (nr_probes = 0; old[nr_probes].func; nr_probes++) {
> > -		if (!probe ||
> > -		    (old[nr_probes].func == probe &&
> > -		     old[nr_probes].data == data))
> > +		if (old[nr_probes].func == probe &&
> > +		     old[nr_probes].data == data)
> >  			nr_del++;
> >  	}
> >  
> > @@ -173,8 +180,7 @@ tracepoint_entry_remove_probe(struct tracepoint_entry *entry,
> >  		if (new == NULL)
> >  			return ERR_PTR(-ENOMEM);
> >  		for (i = 0; old[i].func; i++)
> > -			if (probe &&
> > -			    (old[i].func != probe || old[i].data != data))
> > +			if (old[i].func != probe || old[i].data != data)
> 
> This makes it look like the null probe was intentional.
> 
> -- Steve
> 
> >  				new[j++] = old[i];
> >  		new[nr_probes - nr_del].func = NULL;
> >  		entry->refcount = nr_probes - nr_del;
> 
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
