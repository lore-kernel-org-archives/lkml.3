Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588AbaEWVf0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 17:35:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:42710 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbaEWVfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 17:35:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,896,1392192000"; 
   d="scan'208";a="516840451"
Date: Fri, 23 May 2014 14:35:03 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, jolsa@redhat.com,
        linux-kernel@vger.kernel.org, acme@infradead.org
Subject: Re: [PATCH 1/9] perf, tools: Support handling complete branch stacks
 as histograms v6
Message-ID: <20140523213503.GD29957@tassilo.jf.intel.com>
References: <1400259938-3436-1-git-send-email-andi@firstfloor.org>
 <1400259938-3436-2-git-send-email-andi@firstfloor.org>
 <87fvk6ji10.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fvk6ji10.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 05:21:15PM +0900, Namhyung Kim wrote:
> This is gone with 540476de74c9 ("perf tools: Remove
> symbol_conf.use_callchain check").

The patchkit applies to tip/perf/core.

> > +				 * Check for overlap into the callchain.
> > +				 * The return address is one off compared to
> > +				 * the branch entry. To adjust for this
> > +				 * assume the calling instruction is not longer
> > +				 * than 8 bytes.
> > +				 */
> > +				if (be[i].from < chain->ips[first_call] &&
> > +				    be[i].from >= chain->ips[first_call] - 8)
> > +					first_call++;
> 
> It seems that you need to check chain->ips[first_call] is greater than
> PERF_CONTEXT_MAX and use such value as the cpumode...

I don't understand the comment. The only IP that gets resolved is the from/to.
And add_callchain_ip does it own resolution.

Wouldn't make any sense to get it from first_call

> 
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
> 
> ... for here.
> 
> 
> > +			if (err == -EINVAL)
> > +				break;
> > +			if (err)
> > +				return err;
> > +		}
> > +		chain_nr -= nr;
> 
> It seems it could make some callchain nodes being ignored.  What if a
> case like small callchains with matches to only 2 nodes in the LBR?
> 
>   nr = 16, chain_nr = 10 and first_call = 2

The chain_nr variable is just to handle it when the user
specified a max_stack value. nr is always capped to max_stack too.
If lbr size is >= max_stack it will end up being 0 or negative and the 
following loop to add normal call stack entries will do nothing.

I think that's the correct behavior.

-Andi
