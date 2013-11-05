Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab3KEHq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 02:46:56 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:45545 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab3KEHqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 02:46:55 -0500
Date: Tue, 5 Nov 2013 08:46:50 +0100
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
Message-ID: <20131105074650.GA2855@gmail.com>
References: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
 <20131031080932.GA8479@gmail.com>
 <87vc0c4ny2.fsf@sejong.aot.lge.com>
 <20131101075502.GA25547@gmail.com>
 <874n7w4gtm.fsf@sejong.aot.lge.com>
 <20131101092759.GC27063@gmail.com>
 <87bo1zz4mu.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bo1zz4mu.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> Hi Ingo,
> 
> On Fri, 1 Nov 2013 10:27:59 +0100, Ingo Molnar wrote:
> > * Namhyung Kim <namhyung@kernel.org> wrote:
> >
> >> >> > 2)
> >> >> >
> >> >> > Is it possible to configure the default 'report -g' style, so that 
> >> >> > people who'd like to use it all the time don't have to type '-g 
> >> >> > cumulative' all the time?
> >> >> 
> >> >> Hmm.. maybe I can add support for the 'report.call-graph' config option.
> >> >
> >> > If we display your new 'total' field by default then it's not as 
> >> > pressing to me :)
> >> 
> >> Do you mean -g cumulative without 'self' column?
> >
> > So, if by default we display both 'self' and 'total' and sort by 
> > 'total', then I'm personally a happy camper: while it's a change of 
> > the default perf report output, it's also a step forward.
> >
> > But some people might complain about it once this hits v3.13 (or 
> > v3.14) and might want to hide individual columns and have different 
> > sorting preferences.
> >
> > So out of defensive caution you might want to provide toggles for 
> > such things, maybe even generalize it a bit to allow arbitrary 
> > hiding/display of individual colums in perf report.
> >
> > That would probably also make it easier to do minimal tweaks to the 
> > upstream reporting defaults.
> 
> Okay, so what would the interface look like?
> 
> I think it'd better to separate the option and pass column and
> (optional) sort key argument.
> 
>   --cumulative both,total (default)
>   --cumulative both,self
>   --cumulative total
>   --cumulative self (meaningless?)
> 
> Maybe we need a config option and a single letter option for the default
> case like --call-graph and -g options do.
> 
> What do you think?

So why restrict it to 'cumulative'? Why not have a generic --fields/-F, 
with a good default. The ordering of the fields determines sorting 
behavior.

The default would be something like:

  -F total,self,process,dso,name

Whether 'cumulative' data is calculated is not a function of any direct 
option, but simply a function of whether the 'total' field is in the -F 
list of columns displayed or not.

With that scheme we could also do things like this to get old-style 
sorting:

 -F self,process,dso,name

Or a really frugal 'readprofile'-style output:

 -F self,name

if one is only interested in percentages and raw function names.

Wrt. sorting order, by default the first column in the list of columns 
would be the primary (and only) sort key.

(The -F field setup list could also be specified in the .perfconfig.)

With this method we could do away with all this geometrical explosion of 
somewhat inconsistent formatting and sorting options...

If there's demand then we could decouple sort keys from the display order, 
by slightly augmenting the field format:

 -F total,self:2,process:0,dso:1,name

This would sort by 'process' field as the primary key, 'dso' the secondary 
key and 'self' as the tertiary key.

And we could also keep the -s/--sort option:

 -s process,dso,self

So the above -F line would be equivalent to:

 -F total,self,process,dso,name -s process,dso,self

What do you think?

Thanks,

	Ingo
