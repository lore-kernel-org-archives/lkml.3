Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab3KLNXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 08:23:54 -0500
Received: from mail-yh0-f46.google.com ([209.85.213.46]:41356 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724Ab3KLNXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 08:23:50 -0500
Date: Tue, 12 Nov 2013 10:23:43 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 2/2] perf trace: Fix segfault on perf trace -i perf.data
Message-ID: <20131112132343.GA12627@ghostprotocols.net>
References: <1384237500-22991-1-git-send-email-namhyung@kernel.org>
 <1384237500-22991-2-git-send-email-namhyung@kernel.org>
 <20131112114609.GB4053@ghostprotocols.net>
 <20131112115700.GC4053@ghostprotocols.net>
 <20131112212723.GA14439@danjae>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131112212723.GA14439@danjae>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Nov 12, 2013 at 09:27:23PM +0000, Namhyung Kim escreveu:
> Hi Arnaldo,
> 
> On Tue, Nov 12, 2013 at 08:57:00AM -0300, Arnaldo Carvalho de Melo wrote:
> > So this becomes the first part of this patch, split from yours and
> > massaged a bit so that by looking at the patch it becomes quickly clear
> > what it is doing, please let me now if I can keep this as-is (with your
> > authorship, etc).
> 
> Looks good to me.

Thanks for checking!
 
> But I just have a nitpick, please see below.
 
> > +{
> > +	evsel->priv = malloc(sizeof(struct syscall_tp));
> > +	if (evsel->priv != NULL) {
> > +		if (perf_evsel__init_sc_tp_uint_field(evsel, id))
> > +			goto out_delete;
> > +
> > +		evsel->handler = handler;
> > +		return 0;
> > +	}
> > +
> > +	return -ENOMEM;
> > +
> > +out_delete:
> > +	free(evsel->priv);
> > +	evsel->priv = NULL;
 
> Is this part needed?  I can see that perf_evsel__delete_priv() can do
> it for you anyway.  Yes I know it's needed for my later change, but I
> think we do it a bit differently.
 
> And again, is perf_evsel__delete_priv() needed?  Isn't the ->priv is
> not used for anything else?  Why not just letting perf_evsel__delete()
> handle this transparently?

Because it may point to something not allocated via malloc, so the one
who allocates it, frees it, furthermore, the one who allocates it, if
fails to complete the greater init sequence of which the allocation is
part of, frees it and leaves it as it was before the transaction
started.
 
- Arnaldo
