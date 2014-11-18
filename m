Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaKRCIz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 21:08:55 -0500
Received: from one.firstfloor.org ([193.170.194.197]:49341 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaKRCIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 21:08:54 -0500
Date: Tue, 18 Nov 2014 03:08:52 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, jolsa@redhat.com,
        linux-kernel@vger.kernel.org, acme@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/8] perf, tools: Support handling complete branch
 stacks as histograms
Message-ID: <20141118020852.GG12538@two.firstfloor.org>
References: <1411774636-6870-1-git-send-email-andi@firstfloor.org>
 <1411774636-6870-2-git-send-email-andi@firstfloor.org>
 <87r3y0gbk8.fsf@sejong.aot.lge.com>
 <20141111233153.GK12538@two.firstfloor.org>
 <877fyutkfi.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877fyutkfi.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I considered this. For this example it doesn't make much difference
> > because the functions are so small.
> >
> > But for anything larger I really need the line numbers to make
> > sense of it. 
> >
> > So I prefer to keep them. I'll look into some easy switch
> > to turn them off though.
> 
> Oh, I'm not just removing line numbers - it also removed duplicates (f1
> and f2).  But having both from/to entries, I'm not sure it's worth tho..

The duplicate removal is only for the LBRs. I think it's a sensible
default there.

What would be nice in the future would be to add some kind
of annotation support to the hist entries, so we could say
"removed N iterations" and display it (and possibly some more
LBR information, like mispredict rate). But that's more
work and definitely would be a new patchkit.

> 
> 
> >> > +		if (sort__has_parent && !*parent &&
> >> > +		    symbol__match_regex(al.sym, &parent_regex))
> >> > +			*parent = al.sym;
> >> > +		else if (have_ignore_callees && root_al &&
> >> > +		  symbol__match_regex(al.sym, &ignore_callees_regex)) {
> >> > +			/* Treat this symbol as the root,
> >> > +			   forgetting its callees. */
> >> > +			*root_al = al;
> >> > +			callchain_cursor_reset(&callchain_cursor);
> >> > +		}
> >> > +		if (!symbol_conf.use_callchain)
> >> > +			return -EINVAL;
> >> 
> >> This check already went away.
> >> 
> >> And, to remove duplicates, I think we need to check last callchain
> >> cursor node wrt the callchain_param.key here.
> >
> > I don't understand the comment. I'm not modifying anything
> > that has been already added to the callchain. Just things
> > to be added in the future. So why would I need to check
> > or change the cursor?
> 
> But didn't you already do it (with ips[first_call]) to remove overlaps
> between LBR and normal callchain?

I added the LBRs, but i didn't add the normal call entries yet.


> 
> 
> >
> >> 
> >> Also, by comparing 'from' address, I'd expect you add the from address
> >> alone but you add both of 'from' and 'to'.  Do we really need to do
> >> that?
> >
> > Adding from and to makes it much clearer to the user what happens,
> > especially with conditional branches, so they can follow the 
> > control flow.
> 
> But it could be confusing too - esp. when it moves from LBR to normal
> callchains?  Hmm.. maybe we can print them bit differently.

Yes that would be nice.

> 
> 
> >
> >
> >> And the first address saved in normal callchain is address of the
> >> function itself so it might be 'to' you need to check if sampled before
> >> any branch in a function.
> >
> > I'm checking against the CALL, not the target.
> 
> Yeah, but I'm afraid that it'd always fail to find a match.

It seems to work as far as I can tell.
> >> > +				err = add_callchain_ip(machine, thread,
> >> > +						       parent, root_al,
> >> > +						       -1, be[i].from);
> >> > +			if (err == -EINVAL)
> >> > +				break;
> >> > +			if (err)
> >> > +				return err;
> >> > +		}
> >> > +		chain_nr -= nr;
> >> 
> >> I'm not sure this line is needed.
> >
> > Without that i could exceed the limit.
> 
> What limit?

The limit of max history entries.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
