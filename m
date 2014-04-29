Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288AbaD2BNk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 21:13:40 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:50754 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757259AbaD2BNi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 21:13:38 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCHSET 00/17] perf report: Add -F option for specifying output fields (v4)
References: <1397617554-26319-1-git-send-email-namhyung@kernel.org>
	<20140422211647.GO8488@redhat.com> <87lhuwr2pk.fsf@sejong.aot.lge.com>
	<20140423125828.GL5328@redhat.com> <1398346899.1681.18.camel@leonhard>
	<20140424210015.GJ8488@redhat.com> <20140428194642.GQ5328@redhat.com>
Date: Tue, 29 Apr 2014 10:13:35 +0900
In-Reply-To: <20140428194642.GQ5328@redhat.com> (Don Zickus's message of "Mon,
	28 Apr 2014 15:46:42 -0400")
Message-ID: <878uqpos3k.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Don,

On Mon, 28 Apr 2014 15:46:42 -0400, Don Zickus wrote:
> On Thu, Apr 24, 2014 at 05:00:15PM -0400, Don Zickus wrote:
>> On Thu, Apr 24, 2014 at 10:41:39PM +0900, Namhyung Kim wrote:
>> > Hi Don,
>> > 
>> > 2014-04-23 (수), 08:58 -0400, Don Zickus:
>> > > On Wed, Apr 23, 2014 at 03:15:35PM +0900, Namhyung Kim wrote:
>> > > > On Tue, 22 Apr 2014 17:16:47 -0400, Don Zickus wrote:
>> > > > > ./perf mem record -a grep -r foo /* > /dev/null
>> > > > > ./perf mem report -F overhead,symbol_daddr,pid -s symbol_daddr,pid --stdio 
>> > > > >
>> > > > > I was thinking I could sort everything based on the symbol_daddr and pid.
>> > > > > Then re-sort the output to display the highest 'symbol_daddr,pid' pair.
>> > > > > But it didn't seem to work that way.  Instead it seems like I get the
>> > > > > original sort just displayed in the -F format.
>> > > > 
>> > > > Could you please show me the output of your example?
>> > > 
>> > > 
>> > > # To display the perf.data header info, please use --header/--header-only
>> > > # options.
>> > > #
>> > > # Samples: 96K of event 'cpu/mem-loads/pp'
>> > > # Total weight : 1102938
>> > > # Sort order   : symbol_daddr,pid
>> > > #
>> > > # Overhead Data Symbol          Command:  Pid
>> > > # ........ ......................................................................
>> > > #
>> > >      0.00%  [k] 0xffff8807a8c1cf80 grep:116437
>> > >      0.00%  [k] 0xffff8807a8c8cee0 grep:116437
>> > >      0.00%  [k] 0xffff8807a8dceea0 grep:116437
>> > >      0.01%  [k] 0xffff8807a9298dc0 grep:116437
>> > >      0.01%  [k] 0xffff8807a934be40 grep:116437
>> > >      0.00%  [k] 0xffff8807a9416ec0 grep:116437
>> > >      0.02%  [k] 0xffff8807a9735700 grep:116437
>> > >      0.00%  [k] 0xffff8807a98e9460 grep:116437
>> > >      0.02%  [k] 0xffff8807a9afc890 grep:116437
>> > >      0.00%  [k] 0xffff8807aa64feb0 grep:116437
>> > >      0.02%  [k] 0xffff8807aa6b0030 grep:116437
>> > 
>> > Hmm.. it seems that it's exactly sorted by the data symbol addresses, so
>> > I don't see any problem here.  What did you expect?  If you want to see
>> > those symbol_daddr,pid pair to be sorted by overhead, you can use the
>> > one of -F or -s option only.
>> 
>> Good question.  I guess I was hoping to see things sorted by overhead, but
>> as you said removing all the -F options gives me that.  I have been
>> distracted with other fires this week, I lost focus at what I was trying
>> to accomplish.
>> 
>> Let me figure that out again and try to come up with a more clear email
>> explaining what I was looking for (for myself at least :-) ).
>
> Ok.  I think I figured out what I need.  This might be quite long..

Great. :)

>
>
> Our orignal concept for the c2c tool was to sort hist entries into
> cachelines, filter in only the HITMs and stores and re-sort based on
> cachelines with the most weight.
>
> So using today's perf with a new search called 'cacheline' to achieve
> this (copy-n-pasted):

Maybe 'd'cacheline is a more appropriate name IMHO.

>
> ----
> #define CACHE_LINESIZE       64
> #define CLINE_OFFSET_MSK     (CACHE_LINESIZE - 1)
> #define CLADRS(a)            ((a) & ~(CLINE_OFFSET_MSK))
> #define CLOFFSET(a)          (int)((a) &  (CLINE_OFFSET_MSK))
>
> static int64_t
> sort__cacheline_cmp(struct hist_entry *left, struct hist_entry *right)
> {
>        u64 l, r;
>        struct map *l_map, *r_map;
>
>        if (!left->mem_info)  return -1;
>        if (!right->mem_info) return 1;
>
>        /* group event types together */
>        if (left->cpumode > right->cpumode) return -1;
>        if (left->cpumode < right->cpumode) return 1;
>
>        l_map = left->mem_info->daddr.map;
>        r_map = right->mem_info->daddr.map;
>
>        /* properly sort NULL maps to help combine them */
>        if (!l_map && !r_map)
>                goto addr;
>
>        if (!l_map) return -1;
>        if (!r_map) return 1;
>
>        if (l_map->maj > r_map->maj) return -1;
>        if (l_map->maj < r_map->maj) return 1;
>
>        if (l_map->min > r_map->min) return -1;
>        if (l_map->min < r_map->min) return 1;
>
>        if (l_map->ino > r_map->ino) return -1;
>        if (l_map->ino < r_map->ino) return 1;
>
>        if (l_map->ino_generation > r_map->ino_generation) return -1;
>        if (l_map->ino_generation < r_map->ino_generation) return 1;
>
>        /*
>         * Addresses with no major/minor numbers are assumed to be
>         * anonymous in userspace.  Sort those on pid then address.
>         *
>         * The kernel and non-zero major/minor mapped areas are
>         * assumed to be unity mapped.  Sort those on address.
>         */
>
>        if ((left->cpumode != PERF_RECORD_MISC_KERNEL) &&
>            !l_map->maj && !l_map->min && !l_map->ino &&
>            !l_map->ino_generation) {
>                /* userspace anonymous */
>
>                if (left->thread->pid_ > right->thread->pid_) return -1;
>                if (left->thread->pid_ < right->thread->pid_) return 1;

Isn't it necessary to check whether the address is in a same map in case
of anon pages?  I mean the daddr.al_addr is a map-relative offset so it
might have same value for different maps.


>        }
>
> addr:
>        /* al_addr does all the right addr - start + offset calculations */
>        l = CLADRS(left->mem_info->daddr.al_addr);
>        r = CLADRS(right->mem_info->daddr.al_addr);
>
>        if (l > r) return -1;
>        if (l < r) return 1;
>
>        return 0;
> }
>
> ----
>
> I can get the following 'perf mem report' outputs
>
> I used a special program called hitm_test3 which purposely generates
> HITMs either locally or remotely based on cpu input.  It does this by
> having processA grab lockX from cacheline1, release lockY from cacheline2,
> then processB grabs lockY from cacheline2 and releases lockX from
> cacheline1 (IOW ping pong two locks across two cachelines), found here
>
> http://people.redhat.com/dzickus/hitm_test/
>
> [ perf mem record -a hitm_test -s1,19 -c1000000 -t]
>
> (where -s is the cpus to bind to, -c is loop count, -t disables internal
> perf tracking)
>
> (using 'perf mem' to auto generate correct record/report options for
> cachelines)
> (the hitm counts should be higher, but sampling is a crapshoot.  Using
> ld_lat=30 would probably filter most of the L1 hits)
>
> Table 1: normal perf
> #perf mem report --stdio -s cacheline,pid
>
>
> # Overhead       Samples  Cacheline                       Command:  Pid
> # ........  ............  .......................  ....................
> #
>     47.61%         42257  [.] 0x0000000000000080      hitm_test3:146344
>     46.14%         42596  [.] 0000000000000000        hitm_test3:146343
>      2.16%          2074  [.] 0x0000000000003340      hitm_test3:146344
>      1.88%          1796  [.] 0x0000000000003340      hitm_test3:146343
>      0.20%           140  [.] 0x00007ffff291ce00      hitm_test3:146344
>      0.18%           126  [.] 0x00007ffff291ce00      hitm_test3:146343
>      0.10%             1  [k] 0xffff88042f071500         swapper:     0
>      0.07%             1  [k] 0xffff88042ef747c0     watchdog/11:    62
> ...
>
> Ok, now I know the hottest cachelines. Not to bad.  However, in order to
> determine cacheline contention, it would be nice to know the offsets into
> the cacheline to see if there is contention or not. Unfortunately, the way
> the sorting works here, all the hist_entry data was combined into each
> cacheline, so I lose my granularity...
>
> I can do:
>
> Table 2: normal perf
> #perf mem report --stdio -s cacheline,pid,dso_daddr,mem
>
>
> # Overhead       Samples  Cacheline                       Command:  Pid
> # Data Object             Memory access
> # ........  ............  .......................  ....................
> # ..............................  ........................
> #
>     45.24%         42581  [.] 0000000000000000        hitm_test3:146343 SYSV00000000 (deleted)          L1 hit
>     44.43%         42231  [.] 0x0000000000000080      hitm_test3:146344 SYSV00000000 (deleted)          L1 hit
>      2.19%            13  [.] 0x0000000000000080      hitm_test3:146344 SYSV00000000 (deleted)          Local RAM hit
>      2.16%          2074  [.] 0x0000000000003340      hitm_test3:146344 hitm_test3                      L1 hit
>      1.88%          1796  [.] 0x0000000000003340      hitm_test3:146343 hitm_test3                      L1 hit
>      1.00%            13  [.] 0x0000000000000080      hitm_test3:146344 SYSV00000000 (deleted)          Remote Cache (1 hop) hit
>      0.91%            15  [.] 0000000000000000        hitm_test3:146343 SYSV00000000 (deleted)          Remote Cache (1 hop) hit
>      0.20%           140  [.] 0x00007ffff291ce00      hitm_test3:146344 [stack]                         L1 hit
>      0.18%           126  [.] 0x00007ffff291ce00      hitm_test3:146343 [stack]                         L1 hit
>
> Now I have some granularity (though the program keeps hitting the same
> offset in the cacheline) and some different levels of memory operations.
> Seems like a step forward.  However, the cacheline is broken up a little
> bit (see 0x0000000000000080 is split up three ways).
>
> I can now see where the cache contention is but I don't know how prevalent
> it is (what percentage of the cacheline is under contention).  No need to
> waste time with cachelines that have little or no contention.
>
> Hmm, what if I used the -F option to group all the cachelines and their
> offsets together.
>
> Table 3: perf with -F
> #perf mem report --stdio -s cacheline,pid,dso_daddr,mem  -i don.data -F cacheline,pid,dso_daddr,mem,overhead,sample|grep 0000000000000
>   [k] 0000000000000000           swapper:     0  [kernel.kallsyms] Uncached hit                 0.00%             1
>   [k] 0000000000000000            kipmi0:  1500  [kernel.kallsyms] Uncached hit                 0.02%             1
>   [.] 0000000000000000        hitm_test3:146343  SYSV00000000 (deleted) L1 hit                      45.24%         42581
>   [.] 0000000000000000        hitm_test3:146343  SYSV00000000 (deleted) Remote Cache (1 hop) hit     0.91%            15
>   [.] 0x0000000000000080      hitm_test3:146344  SYSV00000000 (deleted) L1 hit                      44.43%         42231
>   [.] 0x0000000000000080      hitm_test3:146344  SYSV00000000 (deleted) Local RAM hit                2.19%            13
>   [.] 0x0000000000000080      hitm_test3:146344  SYSV00000000 (deleted) Remote Cache (1 hop) hit     1.00%            13
>
> Now I have the ability to see the whole cacheline easily and can probably
> roughly calculate the contention in my head.  Of course there was some
> pre-determined knowledge that was needed to get this info (like which
> cacheline is interesting from Table 1).
>
> Of course, our c2c tool was trying to make the output more readable and
> more obvious such that the user didn't have to know what to look for.
>
> Internally our tool sorts similar to Table2, but then resorts onto a new
> rbtree with a struct c2c_hit based on the hottest cachelines.  Based on
> this new rbtree we can print our analysis easily.
>
> This new rbtree is slightly different than the -F output in that we
> 'group' cacheline entries together and re-sort that group.  The -F option
> just resorts the sorted hist_entry and has no concept of grouping.
>
>
>
>
> We would prefer to have a 'group' sorting concept as we believe that is
> the easiest way to organize the data.  But I don't know if that can be
> incorporated into the 'perf' tool itself, or just keep that concept local
> to our flavor of the perf subcommand.
>
> I am hoping this semi-concocted example gives a better picture of the
> problem I am trying to wrestle with.

Yep, I understand your problem.

And I think it's good for having the group sorting concept in perf tools
for general use.  But it has a conflict with the proposed change of -F
option when non-sort keys are used for the -s or -F.  So it needs more
thinking..

Unfortunately I'll be busy by the end of next week.  So I'll be able to
discuss and work on it later.

Thanks,
Namhyung
