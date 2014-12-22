Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbaLVOpX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 09:45:23 -0500
Received: from mail.kernel.org ([198.145.19.201]:52056 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755128AbaLVOpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 09:45:19 -0500
Date: Mon, 22 Dec 2014 11:45:13 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 4/7] perf diff: Fix to sort by baseline field by default
Message-ID: <20141222144513.GB2717@kernel.org>
References: <1419223455-4362-1-git-send-email-namhyung@kernel.org>
 <1419223455-4362-5-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419223455-4362-5-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 22, 2014 at 01:44:12PM +0900, Namhyung Kim escreveu:
> The currently perf diff didn't add the baseline and delta (or other
> compute) fields to the sort list so output will be sorted by other
> fields like alphabetical order of DSO or symbol as below example.
> 
> Fix it by adding hpp formats for the fields and provides default
> compare functions.
> 
> Before:
> 
>   $ perf diff
>   # Event 'cycles'
>   #
>   # Baseline    Delta  Shared Object       Symbol
>   # ........  .......  ..................  ...............................
>   #
>                        [bridge]            [k] ip_sabotage_in
>                        [btrfs]             [k] __etree_search.constprop.47
>        0.01%           [btrfs]             [k] btrfs_file_mmap
>        0.01%   -0.01%  [btrfs]             [k] btrfs_getattr
>                        [e1000e]            [k] e1000_watchdog
>        0.00%           [kernel.vmlinux]    [k] PageHuge
>        0.00%           [kernel.vmlinux]    [k] __acct_update_integrals
>        0.00%           [kernel.vmlinux]    [k] __activate_page
>                        [kernel.vmlinux]    [k] __alloc_fd
>        0.02%   +0.02%  [kernel.vmlinux]    [k] __alloc_pages_nodemask
>        ...
> 
> After:
> 
>   # Baseline    Delta  Shared Object       Symbol
>   # ........  .......  ..................  ................................
>   #
>       24.73%   -4.62%  perf                [.] append_chain_children
>        7.96%   -1.29%  perf                [.] dso__find_symbol
>        6.97%   -2.07%  libc-2.20.so        [.] vfprintf
>        4.61%   +0.88%  libc-2.20.so        [.] __fprintf_chk
>        4.41%   +2.43%  perf                [.] sort__comm_cmp
>        4.10%   -0.16%  perf                [.] comm__str
>        4.03%   -0.93%  perf                [.] machine__findnew_thread_time
>        3.82%   +3.09%  perf                [.] __hists__add_entry
>        2.95%   -0.18%  perf                [.] sort__dso_cmp
>        ...

Looks better, here I tried running 'perf record usleep 1'  in quick
succession to then run 'perf diff'  before and after this patch, got:

Before:

[ssdandy ~]$ cat /tmp/before
# Event 'cycles'
#
# Baseline    Delta  Shared Object     Symbol                        
# ........  .......  ................  ..............................
#
            +36.29%  [kernel.vmlinux]  [k] __split_vma.isra.31       
    34.55%           [kernel.vmlinux]  [k] copy_user_generic_unrolled
             +2.45%  [kernel.vmlinux]  [k] local_clock               
     0.11%   +0.02%  [kernel.vmlinux]  [k] native_write_msr_safe     
     2.12%           [kernel.vmlinux]  [k] perf_event_comm_output    
            +61.13%  [kernel.vmlinux]  [k] unmap_page_range          
    63.22%           libc-2.17.so      [.] 0x000000000007c3e0        
[acme@ssdandy ~]$

After:

[acme@ssdandy linux]$ perf diff
# Event 'cycles'
#
# Baseline    Delta  Shared Object     Symbol                        
# ........  .......  ................  ..............................
#
    63.22%           libc-2.17.so      [.] 0x000000000007c3e0        
    34.55%           [kernel.vmlinux]  [k] copy_user_generic_unrolled
     2.12%           [kernel.vmlinux]  [k] perf_event_comm_output    
     0.11%   +0.02%  [kernel.vmlinux]  [k] native_write_msr_safe     
            +36.29%  [kernel.vmlinux]  [k] __split_vma.isra.31       
             +2.45%  [kernel.vmlinux]  [k] local_clock               
            +61.13%  [kernel.vmlinux]  [k] unmap_page_range          
[acme@ssdandy linux]$

Which was ok up to the point where symbols that only appeared on the
second run were not sorted by delta, can you fix that?

Please let me know if it is better to apply this one then a followup to
sort the deltas or if a combined patch to achieve both is best.

I.e.:

[acme@ssdandy linux]$ perf diff
# Event 'cycles'
#
# Baseline    Delta  Shared Object     Symbol                        
# ........  .......  ................  ..............................
#
    63.22%           libc-2.17.so      [.] 0x000000000007c3e0        
    34.55%           [kernel.vmlinux]  [k] copy_user_generic_unrolled
     2.12%           [kernel.vmlinux]  [k] perf_event_comm_output    
     0.11%   +0.02%  [kernel.vmlinux]  [k] native_write_msr_safe     
            +61.13%  [kernel.vmlinux]  [k] unmap_page_range          
            +36.29%  [kernel.vmlinux]  [k] __split_vma.isra.31       
             +2.45%  [kernel.vmlinux]  [k] local_clock               

[acme@ssdandy linux]$

Humm, but then wouldn't we be more interested in sorting _everything_ by
delta?

- Arnaldo
