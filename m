Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbaKKXcD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 18:32:03 -0500
Received: from one.firstfloor.org ([193.170.194.197]:60534 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbaKKXcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 18:32:01 -0500
Date: Wed, 12 Nov 2014 00:31:53 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, jolsa@redhat.com,
        linux-kernel@vger.kernel.org, acme@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/8] perf, tools: Support handling complete branch
 stacks as histograms
Message-ID: <20141111233153.GK12538@two.firstfloor.org>
References: <1411774636-6870-1-git-send-email-andi@firstfloor.org>
 <1411774636-6870-2-git-send-email-andi@firstfloor.org>
 <87r3y0gbk8.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r3y0gbk8.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the long delay. Just revisiting that.

On Wed, Oct 22, 2014 at 10:03:51AM +0900, Namhyung Kim wrote:
> >             |          |          f2 tcall.c:5
> >             |          |          f1 tcall.c:12
> >             |          |          f1 tcall.c:12
> >             |          |          f2 tcall.c:7
> >             |          |          f2 tcall.c:5
> >             |          |          f1 tcall.c:11
> 
> I think it'd be better if it just prints function names as normal
> callchain does (and optionally srcline with a switch) and duplicates
> removed like below:
> 
>      54.91%  tcall.c:6  [.] f2                      tcall
>              |
>              |--65.53%-- f2 tcall.c:5
>              |          |
>              |          |--70.83%-- f1
>              |          |          main
>              |          |          f1
>              |          |          f2
>              |          |          f1
>              |          |          f2

I considered this. For this example it doesn't make much difference
because the functions are so small.

But for anything larger I really need the line numbers to make
sense of it. 

So I prefer to keep them. I'll look into some easy switch
to turn them off though.


> > +		if (sort__has_parent && !*parent &&
> > +		    symbol__match_regex(al.sym, &parent_regex))
> > +			*parent = al.sym;
> > +		else if (have_ignore_callees && root_al &&
> > +		  symbol__match_regex(al.sym, &ignore_callees_regex)) {
> > +			/* Treat this symbol as the root,
> > +			   forgetting its callees. */
> > +			*root_al = al;
> > +			callchain_cursor_reset(&callchain_cursor);
> > +		}
> > +		if (!symbol_conf.use_callchain)
> > +			return -EINVAL;
> 
> This check already went away.
> 
> And, to remove duplicates, I think we need to check last callchain
> cursor node wrt the callchain_param.key here.

I don't understand the comment. I'm not modifying anything
that has been already added to the callchain. Just things
to be added in the future. So why would I need to check
or change the cursor?

> 
> Also, by comparing 'from' address, I'd expect you add the from address
> alone but you add both of 'from' and 'to'.  Do we really need to do
> that?

Adding from and to makes it much clearer to the user what happens,
especially with conditional branches, so they can follow the 
control flow.


> And the first address saved in normal callchain is address of the
> function itself so it might be 'to' you need to check if sampled before
> any branch in a function.

I'm checking against the CALL, not the target.

> 
> > +			} else
> > +				be[i] = branch->entries[branch->nr - i - 1];
> > +		}
> > +
> > +		nr = remove_loops(be, nr);
> > +
> > +		for (i = 0; i < nr; i++) {
> > +			err = add_callchain_ip(machine, thread, parent,
> > +					       root_al,
> > +					       -1, be[i].to);
> > +			if (!err)
> > +				err = add_callchain_ip(machine, thread,
> > +						       parent, root_al,
> > +						       -1, be[i].from);
> > +			if (err == -EINVAL)
> > +				break;
> > +			if (err)
> > +				return err;
> > +		}
> > +		chain_nr -= nr;
> 
> I'm not sure this line is needed.

Without that i could exceed the limit.

-Andi
