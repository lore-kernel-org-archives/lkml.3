Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab3KEJFP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 04:05:15 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:48457 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab3KEJFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 04:05:06 -0500
X-AuditID: 9c93017e-b7c22ae000005611-18-5278b4bf7b7b
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
	<20131105074650.GA2855@gmail.com>
Date: Tue, 05 Nov 2013 18:05:03 +0900
In-Reply-To: <20131105074650.GA2855@gmail.com> (Ingo Molnar's message of "Tue,
	5 Nov 2013 08:46:50 +0100")
Message-ID: <87txfrxlq8.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Nov 2013 08:46:50 +0100, Ingo Molnar wrote:
> * Namhyung Kim <namhyung@kernel.org> wrote:
>> I think it'd better to separate the option and pass column and
>> (optional) sort key argument.
>> 
>>   --cumulative both,total (default)
>>   --cumulative both,self
>>   --cumulative total
>>   --cumulative self (meaningless?)
>> 
>> Maybe we need a config option and a single letter option for the default
>> case like --call-graph and -g options do.
>> 
>> What do you think?
>
> So why restrict it to 'cumulative'? Why not have a generic --fields/-F, 
> with a good default. The ordering of the fields determines sorting 
> behavior.

Ah, I didn't know you meant that too. :)

But the 'cumulative' (btw, I feel a bit hard to type this word..) is
different in that it *generates* entries didn't get sampled originally.
And as it requires callchains, total field will not work if callchains
are missing.

So I tried to make it a standalone option.

>
> The default would be something like:
>
>   -F total,self,process,dso,name
>
> Whether 'cumulative' data is calculated is not a function of any direct 
> option, but simply a function of whether the 'total' field is in the -F 
> list of columns displayed or not.

So you want to turn the cumulative behavior always on, right?

But as Frederic noted, it might affect the performance of perf report,
so it might be better to delay this behavior to make default after users
feel comfortable with an option?

>
> With that scheme we could also do things like this to get old-style 
> sorting:
>
>  -F self,process,dso,name
>
> Or a really frugal 'readprofile'-style output:
>
>  -F self,name
>
> if one is only interested in percentages and raw function names.

s/name/sym(bol)/ :)

Yes, this is what we do with -s option now.

>
> Wrt. sorting order, by default the first column in the list of columns 
> would be the primary (and only) sort key.

Ah, I never thought it like this way.  It makes sense as sort orders
really affect the output sorting.

>
> (The -F field setup list could also be specified in the .perfconfig.)
>
> With this method we could do away with all this geometrical explosion of 
> somewhat inconsistent formatting and sorting options...

For now, there're two kind of columns:

- one for showing entry's overhead percentage: self, sys, user,
  guest_sys and guest_user.  So the 'total' should go into this
  category.  I named it hpp (hist_entry period percentage) functions and
  yes, I know it's an awfully bad name. :)  Please see perf_hpp__format.

  There're controlled by a couple of options:  --show-total-period,
  --show-nr-samples and --showcpuutilization (I hate this!).  And event
  group also can affect its output.

- one for grouping entries: cpu, pid, comm, dso, symbol, srcline and
  parent.  We call it "sort keys" but confusingly it doesn't affect
  output sorting for now.


So I think cleaning this up with -F option is good and I've been wanting
this discussion for a long time. :)

>
> If there's demand then we could decouple sort keys from the display order, 
> by slightly augmenting the field format:
>
>  -F total,self:2,process:0,dso:1,name
>
> This would sort by 'process' field as the primary key, 'dso' the secondary 
> key and 'self' as the tertiary key.
>
> And we could also keep the -s/--sort option:
>
>  -s process,dso,self
>
> So the above -F line would be equivalent to:
>
>  -F total,self,process,dso,name -s process,dso,self
>
> What do you think?

I like the second one.  It can sustain the old way but can support the
new way easily.

But for compatibility we need to use 'self' sort key internally iff
neither the -F option nor the config option was given by user.  And it
might warn (or notice) users to add 'self' column in the sort key for
future use.

Thanks,
Namhyung
