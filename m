Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab3KFH4R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 02:56:17 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:42671 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab3KFH4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 02:56:14 -0500
X-AuditID: 9c93016f-b7bb9ae000001e30-63-5279f6181282
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Arun Sharma <asharma@fb.com>
Subject: Re: [RFC/PATCHSET 00/14] perf report: Add support to accumulate hist periods (v2)
References: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
	<20131031080932.GA8479@gmail.com> <87vc0c4ny2.fsf@sejong.aot.lge.com>
	<20131101075502.GA25547@gmail.com> <874n7w4gtm.fsf@sejong.aot.lge.com>
	<20131101092759.GC27063@gmail.com> <87bo1zz4mu.fsf@sejong.aot.lge.com>
	<20131105074650.GA2855@gmail.com> <87txfrxlq8.fsf@sejong.aot.lge.com>
	<20131105115802.GA12045@gmail.com>
Date: Wed, 06 Nov 2013 16:56:08 +0900
In-Reply-To: <20131105115802.GA12045@gmail.com> (Ingo Molnar's message of
	"Tue, 5 Nov 2013 12:58:02 +0100")
Message-ID: <87ppqex8tj.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Tue, 5 Nov 2013 12:58:02 +0100, Ingo Molnar wrote:
> * Namhyung Kim <namhyung@kernel.org> wrote:
>> But the 'cumulative' (btw, I feel a bit hard to type this word..) is 
>> different in that it *generates* entries didn't get sampled originally. 
>> And as it requires callchains, total field will not work if callchains 
>> are missing.
>
> Well, 'total' should disappear if it's not available.

But what if it's the only sort key user gave?

>
> We already have some 'column elimination/optimization' logic - like the 
> 'dso' will disappear already if it's a single dso everywhere, IIRC?

When user explicitly gives a single name as the column filter with -c,
-d and/or -S options.

But it seems to have a same issue that I said above:

  $ perf report -s comm -c perf --stdio
  (...)
  # Overhead
  # ........
  #
     100.00%


And TUI even shows a noise in the output.

>
>> But as Frederic noted, it might affect the performance of perf report, 
>> so it might be better to delay this behavior to make default after users 
>> feel comfortable with an option?
>
> I think with call-chain speedups it should be fast enough, right?

Yeah, it should speedup things significantly.

>
> We can argue about the default separately - if it's all done correctly 
> then it should be really easy to change the default layout of 'perf 
> report'.
>

I just think that the perf tools are going so fast. ;-)


>> For now, there're two kind of columns:
>> 
>> - one for showing entry's overhead percentage: self, sys, user,
>>   guest_sys and guest_user.  So the 'total' should go into this
>>   category.  I named it hpp (hist_entry period percentage) functions and
>>   yes, I know it's an awfully bad name. :)  Please see perf_hpp__format.
>> 
>>   There're controlled by a couple of options:  --show-total-period,
>>   --show-nr-samples and --showcpuutilization (I hate this!).  And event
>>   group also can affect its output.
>> 
>> - one for grouping entries: cpu, pid, comm, dso, symbol, srcline and
>>   parent.  We call it "sort keys" but confusingly it doesn't affect 
>>   output sorting for now.
>
> Well, it's still a sort key in a sense, a string lexicographical ordering 
> in essence, right?

Right.  But it only affects on groupping entries when added and
collapsed not the output ordering.

>
>> > If there's demand then we could decouple sort keys from the display 
>> > order, by slightly augmenting the field format:
>> >
>> >  -F total,self:2,process:0,dso:1,name
>> >
>> > This would sort by 'process' field as the primary key, 'dso' the secondary 
>> > key and 'self' as the tertiary key.
>> >
>> > And we could also keep the -s/--sort option:
>> >
>> >  -s process,dso,self
>> >
>> > So the above -F line would be equivalent to:
>> >
>> >  -F total,self,process,dso,name -s process,dso,self
>> >
>> > What do you think?
>> 
>> I like the second one.  It can sustain the old way but can support the 
>> new way easily.
>>
>> But for compatibility we need to use 'self' sort key internally iff 
>> neither the -F option nor the config option was given by user.  And it 
>> might warn (or notice) users to add 'self' column in the sort key for 
>> future use.
>
> Mind explaining what the problem here is? I don't think I get it.

Well, normal users still use it as they used to - like 
'perf report -s comm,dso' without -F option and the config.

In that case, what would the output look like?  According to the above
proposal it'd look like below.

  # Command  Shared object
  # .......  .............
        aaa  aaa
        aaa  libc.so
        bbb  bbb
        bbb  libc.so


But the user might want see this:

  # Overhead (self)  Command  Shared object
  # ...............  .......  .............
             30.00%      bbb  bbb
             25.00%      aaa  aaa
             25.00%      aaa  libc.so
             20.00%      bbb  libc.so


If she really wants to see it sorted by comm and dso, the command line
should be 'perf report -F self,comm,dso -s comm,dso'
(or just 'perf report -F self -s comm,dso' could do the same).

  # Overhead (self)  Command  Shared object
  # ...............  .......  .............
             25.00%      aaa  aaa
             25.00%      aaa  libc.so
             30.00%      bbb  bbb
             20.00%      bbb  libc.so


Thanks,
Namhyung
