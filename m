Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab3KFJRu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 04:17:50 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:55850 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854Ab3KFJRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 04:17:47 -0500
X-AuditID: 9c93017e-b7c9fae00000057d-90-527a0939b4e1
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
References: <20131031080932.GA8479@gmail.com>
	<87vc0c4ny2.fsf@sejong.aot.lge.com> <20131101075502.GA25547@gmail.com>
	<874n7w4gtm.fsf@sejong.aot.lge.com> <20131101092759.GC27063@gmail.com>
	<87bo1zz4mu.fsf@sejong.aot.lge.com> <20131105074650.GA2855@gmail.com>
	<87txfrxlq8.fsf@sejong.aot.lge.com> <20131105115802.GA12045@gmail.com>
	<87ppqex8tj.fsf@sejong.aot.lge.com> <20131106083046.GA4655@gmail.com>
Date: Wed, 06 Nov 2013 18:17:45 +0900
In-Reply-To: <20131106083046.GA4655@gmail.com> (Ingo Molnar's message of "Wed,
	6 Nov 2013 09:30:46 +0100")
Message-ID: <87r4atx51i.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Nov 2013 09:30:46 +0100, Ingo Molnar wrote:
> * Namhyung Kim <namhyung@kernel.org> wrote:
>
>> Hi Ingo,
>> 
>> On Tue, 5 Nov 2013 12:58:02 +0100, Ingo Molnar wrote:
>> > * Namhyung Kim <namhyung@kernel.org> wrote:
>> >> But the 'cumulative' (btw, I feel a bit hard to type this word..) is 
>> >> different in that it *generates* entries didn't get sampled originally. 
>> >> And as it requires callchains, total field will not work if callchains 
>> >> are missing.
>> >
>> > Well, 'total' should disappear if it's not available.
>> 
>> But what if it's the only sort key user gave?
>
> Do you mean something like:
>
>   -F self,name -s total
>
> i.e. if a sort key not displayed?

What I worry is when no -F option was given at all.

>
> I think sort keys should be automatically added to the displayed fields 
> list.

Agreed.

>
> This rule is obviously met with the -F total:2,self:1,name:0 kind of 
> sorting syntax (you can only sort by fields that get displayed) - if mixed 
> with -s then it should be implicit I think.
>
>> >> But for compatibility we need to use 'self' sort key internally iff 
>> >> neither the -F option nor the config option was given by user.  And 
>> >> it might warn (or notice) users to add 'self' column in the sort key 
>> >> for future use.
>> >
>> > Mind explaining what the problem here is? I don't think I get it.
>> 
>> Well, normal users still use it as they used to - like 
>> 'perf report -s comm,dso' without -F option and the config.
>> 
>> In that case, what would the output look like?  According to the above
>> proposal it'd look like below.
>> 
>>   # Command  Shared object
>>   # .......  .............
>>         aaa  aaa
>>         aaa  libc.so
>>         bbb  bbb
>>         bbb  libc.so
>> 
>> 
>> But the user might want see this:
>> 
>>   # Overhead (self)  Command  Shared object
>>   # ...............  .......  .............
>>              30.00%      bbb  bbb
>>              25.00%      aaa  aaa
>>              25.00%      aaa  libc.so
>>              20.00%      bbb  libc.so
>> 
>> 
>> If she really wants to see it sorted by comm and dso, the command line
>> should be 'perf report -F self,comm,dso -s comm,dso'
>> (or just 'perf report -F self -s comm,dso' could do the same).
>> 
>>   # Overhead (self)  Command  Shared object
>>   # ...............  .......  .............
>>              25.00%      aaa  aaa
>>              25.00%      aaa  libc.so
>>              30.00%      bbb  bbb
>>              20.00%      bbb  libc.so
>
> This problem should be solved if all -s fields are displayed - i.e. they 
> are added to the -F list, right?

But old users might not aware of the new -F option, and use -s option
only.  If so, she will get output like the first example, right?

>
> Basically there's just a single concept: the -F list. The -s option simply 
> modifies and extends the -F list but internally perf report would not know 
> anything about '-s', it only knows about fields to display and it would 
> know which of those fields are to be sorted and in what order.
>
> Does that make sense to you? Does it cover everything needed?

I like the concept.  I'm just looking for a way to add it without
upsetting old users. :)

Thanks,
Namhyung
