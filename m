Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbaDKS2z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 14:28:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754599AbaDKS2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 14:28:54 -0400
Date: Fri, 11 Apr 2014 14:28:35 -0400
From: Don Zickus <dzickus@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@kernel.org, namhyung@kernel.org, eranian@google.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 5/5] perf: Enable multiple hist_entry_group output
Message-ID: <20140411182834.GJ8488@redhat.com>
References: <1397160661-33395-1-git-send-email-dzickus@redhat.com>
 <1397160661-33395-6-git-send-email-dzickus@redhat.com>
 <20140411173000.GC22707@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140411173000.GC22707@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 07:30:00PM +0200, Jiri Olsa wrote:
> On Thu, Apr 10, 2014 at 04:11:01PM -0400, Don Zickus wrote:
> > Enable multiple hist_entry_group groups in the output based on a sort
> > method.
> > 
> > Currently only 'perf report' is hooked in with '--group-sort='.  The choices
> > are cpu, pid, and cacheline.  Only --stdio works right now.  I haven't figured
> > out how the other outputs work.
> > 
> > Sample output from 'perf mem record -a grep -r foo /* > /dev/null'
> > 
> > (normal) perf mem report --percent-limit=1.0 --stdio
> > 
> >  Overhead       Samples
> >   Local Weight             Memory access                                      Symbol
> >  ........  ............  ............  ........................  ........................
> > 
> >      4.13%             1  1759          Uncached hit              [k] ahci_scr_read
> >      1.16%             1  492           L1 hit                    [k] _raw_read_lock
> > 
> > (cpu groups) perf mem report --group-sort=cpu --percent-limit=1.0 --stdio
> > 
> >  Overhead       Samples  CPU
> >   Local Weight             Memory access                                      Symbol
> >  ........  ............  ............  ........................  ........................
> > 
> >     28.80%          1239   25
> > 	     3.07%               377           L1 hit                    [k] complete_walk
> > 	     2.76%               339           LFB hit                   [k] update_cfs_shares
> > 	     2.66%               326           LFB hit                   [k] copy_user_enhanced_f
> > 	     2.11%               259           Local RAM hit             [k] copy_user_enhanced_f
> > 	     1.84%               226           LFB hit                   [k] copy_user_enhanced_f
> > 	     1.74%               213           LFB hit                   [k] copy_user_enhanced_f
> > 	     1.53%               187           LFB hit                   [k] copy_user_enhanced_f
> > 	     1.04%               128           LFB hit                   [k] copy_user_enhanced_f
> > 	     1.01%               124           LFB hit                   [k] copy_user_enhanced_f
> >     27.44%           990    7
> > 	    15.06%               1759          Uncached hit              [k] ahci_scr_read
> > 	     4.21%               492           L1 hit                    [k] _raw_read_lock
> > 	     1.04%               122           LFB hit                   [k] find_busiest_group
> > 	     1.02%            1  7             L1 hit                    [.] __gconv_transform_ut
> >     20.34%          1010    0
> > 	     4.04%            5  7             L1 hit                    [k] poll_idle
> > 	     3.56%               308           Local RAM hit             [k] copy_user_enhanced_f
> > 	     2.59%               224           L3 hit                    [k] copy_user_enhanced_f
> > 	     2.12%               184           Local RAM hit             [k] copy_user_enhanced_f
> > 	     1.54%            1  7             L1 hit                    [.] __gconv_transform_ut
> 
> nice, that looks very usefull

\o/  :-)

> 
> Correct me if I'm wrong, but your current design allows to define
> just one group, right?

No, you can do multiple groups, ie --group-sort=cpu,pid,cacheline
(exactly the same way --sort works, in fact it uses the same sorting
functions and routines [pid_cmp is the _same_ in sort and group-sort]).
However, that is different than what you are asking below.  In my current
design, the output mimics --sorts output, just add sorted columns for each
group added.

> 
> so, current code can do following CPU sorting:
> 
>    Overhead   CPU
>    ........   ...
>    90%        0
>    10%        1
> 
> 
> and with your changes we could do:
> 
>    Overhead   CPU  symbol
>    ........   ...  ......
>    90%        0
>         50%        krava1
>         20%        krava2
>         30%        krava3
> 
>    10%        1
>         50%        krava4
>         50%        krava5
>   
> 
> I wonder we could go more generic and allow more nested groups,
> like eg allow group sort on cpu and pid (or more):

I never thought about that because I went in a different direction (as
described above), but I like the nested idea.  Coding it up would be much
trickier I think.  I would need to wrap my brain around it.

> 
>    Overhead   CPU  pid  symbol
>    ........   ...  ...  ......
>    90%        0
>       50%          100
>         50%             krava1
>         20%             krava2
>         30%             krava3
>       50%          110
>         50%             krava1
>         20%             krava2
>         30%             krava3
> 
>    10%        1
>       100%         200
>         50%             krava4
>         50%             krava5
> 
> 
> I glanced over the changes and I wonder we could do it
> by chaining hists structs via 'struct hist_entry'
> 
> like adding 'struct hists' into 'struct hists_entry'
> and making the sort_order local for each 'struct hists'

Well 'struct hists' was in 'struct hists_entry' (until this patchset
removed it).  :-)

We might be able to chain 'struct hists' somehow, though I am not sure how
to tell when a traverse a 'struct hists' vs. using 'entries' because we
hit an endpoint.  And if we have to write new sorting routines.  Also I
was originally keeping 'struct hists' as the upper level gatekeeper of
high level data, like filter_str and locks, col_len, etc.

I am not opposed to chaining, just thinking 'struct hists' isn't the right
struct to do it with.  I could be wrong. :-)  Will have to think about it.
Gives me something to thinking about next week on a plane to SF. :-)

Thanks for looking.

Cheers,
Don
