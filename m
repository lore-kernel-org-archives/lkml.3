Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204AbbAFCZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 21:25:13 -0500
Received: from smtprelay0114.hostedemail.com ([216.40.44.114]:33110 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753697AbbAFCZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 21:25:06 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:965:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2892:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3874:4390:5007:6261:7875:7901:8660:10004:10400:10848:10967:11026:11232:11658:11914:12043:12296:12517:12519:12740:13069:13095:13148:13230:13255:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: nose59_f2e639bbaa14
X-Filterd-Recvd-Size: 2509
Date: Mon, 5 Jan 2015 21:25:02 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "'Christoph Lameter'" <cl@linux.com>,
        "'Pekka Enberg'" <penberg@kernel.org>,
        "'David Rientjes'" <rientjes@google.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        "'Jesper Dangaard Brouer'" <brouer@redhat.com>
Subject: Re: [PATCH 1/2] mm/slub: optimize alloc/free fastpath by removing
 preemption on/off
Message-ID: <20150105212502.1bdc4f67@gandalf.local.home>
In-Reply-To: <20150106013247.GC17222@js1304-P5Q-DELUXE>
References: <023701d028c2$dba2cb30$92e86190$@alibaba-inc.com>
	<20150106013247.GC17222@js1304-P5Q-DELUXE>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Jan 2015 10:32:47 +0900
Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:


> > > +++ b/mm/slub.c
> > > @@ -2398,13 +2398,15 @@ redo:
> > >  	 * reading from one cpu area. That does not matter as long
> > >  	 * as we end up on the original cpu again when doing the cmpxchg.
> > >  	 *
> > > -	 * Preemption is disabled for the retrieval of the tid because that
> > > -	 * must occur from the current processor. We cannot allow rescheduling
> > > -	 * on a different processor between the determination of the pointer
> > > -	 * and the retrieval of the tid.
> > > +	 * We should guarantee that tid and kmem_cache are retrieved on
> > > +	 * the same cpu. It could be different if CONFIG_PREEMPT so we need
> > > +	 * to check if it is matched or not.
> > >  	 */
> > > -	preempt_disable();
> > > -	c = this_cpu_ptr(s->cpu_slab);
> > > +	do {
> > > +		tid = this_cpu_read(s->cpu_slab->tid);
> > > +		c = this_cpu_ptr(s->cpu_slab);
> > > +	} while (IS_ENABLED(CONFIG_PREEMPT) && unlikely(tid != c->tid));
> > > +	barrier();
> > 
> > Help maintenance more if barrier is documented in commit message.
> 
> Hello,
> 
> Okay. Will add some information about this barrier in commit message.

A comment in the commit message is useless. Adding a small comment
above the barrier() call itself would be much more useful.

-- Steve
