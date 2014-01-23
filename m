Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbaAWQXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 11:23:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696AbaAWQXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 11:23:30 -0500
Date: Thu, 23 Jan 2014 17:22:48 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCHSET 00/24] perf tools: Add support to accumulate hist
 periods (v7)
Message-ID: <20140123162248.GF1180@krava.brq.redhat.com>
References: <1390436045-16830-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390436045-16830-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 09:13:44AM +0900, Namhyung Kim wrote:
> Hello,
> 
> This is a new attempt to implement cumulative hist period report.
> This work begins from Arun's SORT_INCLUSIVE patch [1] but I completely
> rewrote it from scratch.
> 
> This patchset is based on my previous patchset [2] but I think it's
> almost independent so that it can be applied separately.
> 
> Please see the patch 03/24.  I refactored functions that add hist
> entries with struct hist_entry_iter.  While I converted all functions
> carefully, it'd be better anyone can test and confirm that I didn't
> mess up something - especially for branch stack and mem stuff.
> 
> This patchset basically adds period in a sample to every node in the
> callchain.  A hist_entry now has an additional fields to keep the
> cumulative period if --children option is given on perf report.
> 
> I changed the option as a separate --children and added a new
> "Children" column (and renamed the default "Overhead" column into
> "Self").  The output will be sorted by children (cumulative) overhead
> for now.  The reason I changed to the --children is that I still think
> it's much different from other --call-graph options.  The --call-graph
> option will take care of it even with --children option.
> 
> I know that the UI should be changed also to be more flexible as Ingo
> requested, but I'd like to do this first and then move to work on the
> next.  I also added a new config option to enable it by default.

SNIP

>                   --- _start
> 
> 
> Case 3.
> 
>   $ perf report --no-call-graph --children --stdio
> 
>   #     Self  Children  Command      Shared Object                 Symbol
>   # ........  ........  .......  .................  .....................
>   #
>        0.00%    91.50%      abc  libc-2.17.so       [.] __libc_start_main
>        0.00%    91.50%      abc  abc                [.] main             
>        0.00%    91.50%      abc  abc                [.] c                
>        0.00%    91.50%      abc  abc                [.] b                
>       91.50%    91.50%      abc  abc                [.] a                
>        0.00%     8.18%      abc  ld-2.17.so         [.] _dl_sysdep_start 
>        8.18%     8.18%      abc  ld-2.17.so         [.] strlen           
>        0.01%     0.33%      abc  ld-2.17.so         [.] _start           
>        0.31%     0.31%      abc  [kernel.kallsyms]  [k] page_fault       

I couldnt get this one working:

[jolsa@krava perf]$ ./perf report --no-call-graph --children --stdio

#
#     Self  Children  Command  Shared Object                      Symbol
# ........  ........  .......  .............  ..........................
#
    94.47%    94.47%      abc  abc            [.] a                     
     4.74%     4.74%      abc  ld-2.17.so     [.] _dl_map_object_from_fd
     0.75%     0.75%      abc  ld-2.17.so     [.] _dl_start             
     0.04%     0.04%      abc  ld-2.17.so     [.] _start                

I was looking for cumulated stdio output without callchain unwinded,
TUI shows it properly as default


jirka
