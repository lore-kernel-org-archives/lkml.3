Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbaLWNaJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 08:30:09 -0500
Received: from mail.kernel.org ([198.145.19.201]:35088 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755249AbaLWNaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 08:30:06 -0500
Date: Tue, 23 Dec 2014 10:30:02 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 4/7] perf diff: Fix to sort by baseline field by default
Message-ID: <20141223133002.GO7644@kernel.org>
References: <1419223455-4362-1-git-send-email-namhyung@kernel.org>
 <1419223455-4362-5-git-send-email-namhyung@kernel.org>
 <20141222144513.GB2717@kernel.org>
 <20141223041213.GC14960@sejong>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141223041213.GC14960@sejong>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 23, 2014 at 01:12:13PM +0900, Namhyung Kim escreveu:
> On Mon, Dec 22, 2014 at 11:45:13AM -0300, Arnaldo Carvalho de Melo wrote:
> > Looks better, here I tried running 'perf record usleep 1'  in quick
> > succession to then run 'perf diff'  before and after this patch, got:
> > 
> > Before:
> > 
> > [ssdandy ~]$ cat /tmp/before
> > # Event 'cycles'
> > #
> > # Baseline    Delta  Shared Object     Symbol                        
> > # ........  .......  ................  ..............................
> > #
> >             +36.29%  [kernel.vmlinux]  [k] __split_vma.isra.31       
> >     34.55%           [kernel.vmlinux]  [k] copy_user_generic_unrolled
> >              +2.45%  [kernel.vmlinux]  [k] local_clock               
> >      0.11%   +0.02%  [kernel.vmlinux]  [k] native_write_msr_safe     
> >      2.12%           [kernel.vmlinux]  [k] perf_event_comm_output    
> >             +61.13%  [kernel.vmlinux]  [k] unmap_page_range          
> >     63.22%           libc-2.17.so      [.] 0x000000000007c3e0        
> > [acme@ssdandy ~]$
> > 
> > After:
> > 
> > [acme@ssdandy linux]$ perf diff
> > # Event 'cycles'
> > #
> > # Baseline    Delta  Shared Object     Symbol                        
> > # ........  .......  ................  ..............................
> > #
> >     63.22%           libc-2.17.so      [.] 0x000000000007c3e0        
> >     34.55%           [kernel.vmlinux]  [k] copy_user_generic_unrolled
> >      2.12%           [kernel.vmlinux]  [k] perf_event_comm_output    
> >      0.11%   +0.02%  [kernel.vmlinux]  [k] native_write_msr_safe     
> >             +36.29%  [kernel.vmlinux]  [k] __split_vma.isra.31       
> >              +2.45%  [kernel.vmlinux]  [k] local_clock               
> >             +61.13%  [kernel.vmlinux]  [k] unmap_page_range          
> > [acme@ssdandy linux]$
> > 
> > Which was ok up to the point where symbols that only appeared on the
> > second run were not sorted by delta, can you fix that?
 
> I'll do that later.

Ok, thanks for considering doing that!
 
> > Please let me know if it is better to apply this one then a followup to
> > sort the deltas or if a combined patch to achieve both is best.
> 
> I prefer applying this for now and then improve sorting later..

Ok, will apply it, thanks for checking.
 
> > I.e.:
> > 
> > [acme@ssdandy linux]$ perf diff
> > # Event 'cycles'
> > #
> > # Baseline    Delta  Shared Object     Symbol                        
> > # ........  .......  ................  ..............................
> > #
> >     63.22%           libc-2.17.so      [.] 0x000000000007c3e0        
> >     34.55%           [kernel.vmlinux]  [k] copy_user_generic_unrolled
> >      2.12%           [kernel.vmlinux]  [k] perf_event_comm_output    
> >      0.11%   +0.02%  [kernel.vmlinux]  [k] native_write_msr_safe     
> >             +61.13%  [kernel.vmlinux]  [k] unmap_page_range          
> >             +36.29%  [kernel.vmlinux]  [k] __split_vma.isra.31       
> >              +2.45%  [kernel.vmlinux]  [k] local_clock               

> > [acme@ssdandy linux]$

> > Humm, but then wouldn't we be more interested in sorting _everything_ by
> > delta?

> I don't understand whay you said..  what do you mean by 'everything be
> delta'?  Is that something other than perf diff -o 1 ?

A-ha, exactly, thanks for educating me! :-)

- Arnaldo
