Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142Ab3KFIaw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 03:30:52 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:59176 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116Ab3KFIau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 03:30:50 -0500
Date: Wed, 6 Nov 2013 09:30:46 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Arun Sharma <asharma@fb.com>
Subject: Re: [RFC/PATCHSET 00/14] perf report: Add support to accumulate hist
 periods (v2)
Message-ID: <20131106083046.GA4655@gmail.com>
References: <20131031080932.GA8479@gmail.com>
 <87vc0c4ny2.fsf@sejong.aot.lge.com>
 <20131101075502.GA25547@gmail.com>
 <874n7w4gtm.fsf@sejong.aot.lge.com>
 <20131101092759.GC27063@gmail.com>
 <87bo1zz4mu.fsf@sejong.aot.lge.com>
 <20131105074650.GA2855@gmail.com>
 <87txfrxlq8.fsf@sejong.aot.lge.com>
 <20131105115802.GA12045@gmail.com>
 <87ppqex8tj.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ppqex8tj.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> Hi Ingo,
> 
> On Tue, 5 Nov 2013 12:58:02 +0100, Ingo Molnar wrote:
> > * Namhyung Kim <namhyung@kernel.org> wrote:
> >> But the 'cumulative' (btw, I feel a bit hard to type this word..) is 
> >> different in that it *generates* entries didn't get sampled originally. 
> >> And as it requires callchains, total field will not work if callchains 
> >> are missing.
> >
> > Well, 'total' should disappear if it's not available.
> 
> But what if it's the only sort key user gave?

Do you mean something like:

  -F self,name -s total

i.e. if a sort key not displayed?

I think sort keys should be automatically added to the displayed fields 
list.

This rule is obviously met with the -F total:2,self:1,name:0 kind of 
sorting syntax (you can only sort by fields that get displayed) - if mixed 
with -s then it should be implicit I think.

> >> But for compatibility we need to use 'self' sort key internally iff 
> >> neither the -F option nor the config option was given by user.  And 
> >> it might warn (or notice) users to add 'self' column in the sort key 
> >> for future use.
> >
> > Mind explaining what the problem here is? I don't think I get it.
> 
> Well, normal users still use it as they used to - like 
> 'perf report -s comm,dso' without -F option and the config.
> 
> In that case, what would the output look like?  According to the above
> proposal it'd look like below.
> 
>   # Command  Shared object
>   # .......  .............
>         aaa  aaa
>         aaa  libc.so
>         bbb  bbb
>         bbb  libc.so
> 
> 
> But the user might want see this:
> 
>   # Overhead (self)  Command  Shared object
>   # ...............  .......  .............
>              30.00%      bbb  bbb
>              25.00%      aaa  aaa
>              25.00%      aaa  libc.so
>              20.00%      bbb  libc.so
> 
> 
> If she really wants to see it sorted by comm and dso, the command line
> should be 'perf report -F self,comm,dso -s comm,dso'
> (or just 'perf report -F self -s comm,dso' could do the same).
> 
>   # Overhead (self)  Command  Shared object
>   # ...............  .......  .............
>              25.00%      aaa  aaa
>              25.00%      aaa  libc.so
>              30.00%      bbb  bbb
>              20.00%      bbb  libc.so

This problem should be solved if all -s fields are displayed - i.e. they 
are added to the -F list, right?

Basically there's just a single concept: the -F list. The -s option simply 
modifies and extends the -F list but internally perf report would not know 
anything about '-s', it only knows about fields to display and it would 
know which of those fields are to be sorted and in what order.

Does that make sense to you? Does it cover everything needed?

Thanks,

	Ingo
