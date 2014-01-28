Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbaA1ItR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 03:49:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53336 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754684AbaA1ItP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 03:49:15 -0500
Date: Tue, 28 Jan 2014 08:49:11 +0000
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: numa: Initialse numa balancing after jump label
 initialisation
Message-ID: <20140128084911.GM4963@suse.de>
References: <20140127155127.GJ4963@suse.de>
 <20140127144336.6e9428d317bc2f476fa8de3e@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140127144336.6e9428d317bc2f476fa8de3e@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 02:43:36PM -0800, Andrew Morton wrote:
> On Mon, 27 Jan 2014 15:51:27 +0000 Mel Gorman <mgorman@suse.de> wrote:
> 
> > The command line parsing takes place before jump labels are initialised which
> > generates a warning if numa_balancing= is specified and CONFIG_JUMP_LABEL
> > is set. On older kernls before commit c4b2c0c5 (static_key: WARN on
> > usage before jump_label_init was called) the kernel would have crashed.
> > This patch enables automatic numa balancing later in the initialisation
> > process if numa_balancing= is specified.
> > 
> > ...
> >
> > @@ -2666,9 +2666,14 @@ static void __init check_numabalancing_enable(void)
> >  	if (IS_ENABLED(CONFIG_NUMA_BALANCING_DEFAULT_ENABLED))
> >  		numabalancing_default = true;
> >  
> > +	/* Parsed by setup_numabalancing. override == 1 enables, -1 disables */
> > +	if (numabalancing_override)
> > +		set_numabalancing_state(numabalancing_override == 1);
> > +
> >  	if (nr_node_ids > 1 && !numabalancing_override) {
> > -		printk(KERN_INFO "Enabling automatic NUMA balancing. "
> > -			"Configure with numa_balancing= or sysctl");
> > +		printk(KERN_INFO "%s automatic NUMA balancing. "
> > +			"Configure with numa_balancing= or sysctl",
> > +			numabalancing_default ? "Enabling" : "Disabling");
> >  		set_numabalancing_state(numabalancing_default);
> >  	}
> >  }
> 
> Current mainline is a bit different from this:
> 
> 		printk(KERN_INFO "Enabling automatic NUMA balancing. "
> 			"Configure with numa_balancing= or the kernel.numa_balancing sysctl");
> 
> So this won't apply as-is to -stable.
> 

That's ok.

> I assume you suggested the -stable backport to fix the
> it-crashes-before-c4b2c0c5 thing, so it isn't really needed in 3.12.x.
> 

I am recommending this patch for -stable because 3.12.x crashes. c4b2c0c5
prevents a crash but it is still the case that the parameter is not handled
properly so backporting c4b2c0c5 is not a suitable alternative.

> Or something.  Please sort all that out when Greg comes back with
> a hey-that-didnt-apply.

I will.

-- 
Mel Gorman
SUSE Labs
