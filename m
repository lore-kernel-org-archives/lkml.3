Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088Ab3KAHzu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 03:55:50 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:51649 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114Ab3KAHzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 03:55:06 -0400
Date: Fri, 1 Nov 2013 08:55:02 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>, Pekka Enberg <penberg@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Arun Sharma <asharma@fb.com>
Subject: Re: [RFC/PATCHSET 00/14] perf report: Add support to accumulate hist
 periods (v2)
Message-ID: <20131101075502.GA25547@gmail.com>
References: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
 <20131031080932.GA8479@gmail.com>
 <87vc0c4ny2.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vc0c4ny2.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> > A couple of details:
> >
> > 1)
> >
> > This is pretty close to SysProf output, right? So why not use the 
> > well-known SysProf naming and call the first column 'self' and the 
> > second column 'total'? I think those names are pretty intuitive and 
> > it would help people who come from SysProf over to perf.
> 
> Okay, I can do it. (Although sysprof seems to call it 'cumulative'
> rather than 'total' - but I think the 'total' is better since it's
> simpler and shorter.)

So sysprof-1.2 has the following two windows:

 'functions',   with 'self' and 'total' fields
 'descendants', with 'self' and 'cumulative' fields

'descendants' appears to be similar to the perf 'dso' concept.

> > 2)
> >
> > Is it possible to configure the default 'report -g' style, so that 
> > people who'd like to use it all the time don't have to type '-g 
> > cumulative' all the time?
> 
> Hmm.. maybe I can add support for the 'report.call-graph' config option.

If we display your new 'total' field by default then it's not as 
pressing to me :)

> > 3)
> >
> > I'd even argue that we enable this reporting feature by default, if 
> > a data file includes call-chain data: the first column will still 
> > show the well-known percentage that perf report produces today, the 
> > second column will be a new feature in essence.
> >
> > The only open question would be, by which column should we sort: 
> > 'sysprof style' sorts by 'total', 'perf style' sorts by 'self'. 
> > Agreed?
> 
> Right, I defaulted to go by 'total'.  But we can add an option for 
> it.

The purpose would be to allow people to do old-style 'sort by 
function overhead' output, while still seeing the 'total' field as 
well.

Btw., if anyone is interested in improving the GTK front-end, it 
would be _really_ nice if it had a 'start profiling' button like 
sysprof has today, with a 'samples' field showing the current number 
of samples. (We could even improve upon sysprof by adding 'stop' 
functionality as well ;-)

A bit like perf top, except the reporting session is hidden until 
the user actively requests the profile.

Maybe it could even be called a gtk version of 'perf top', with a 
button to start/stop collection, with another button to 
activate/deactivate reporting output, and yet another button to 
reset the profiling buffer.

With that feature set perf would be a ready sysprof workflow 
replacement I think. (I've Cc:-ed Pekka, just in case! :-)

> > 4)
> >
> > This is not directly related to the new feature you added: 
> > call-graph profiling still takes quite a bit of time. It might 
> > make sense to save the ordered histogram to a perf.data.ordered 
> > file, so that repeat invocations of 'perf report' don't have to 
> > recalculate everything again and again?
> >
> > This file would be maintained transparently and would only be 
> > re-created when the perf.data file changes, or something like 
> > that.
> 
> Hmm.. good idea.  We may discuss it along with Jiri's multiple 
> file storage patches.  I haven't had a time to review - maybe next 
> week.

So Arnaldo tells me that with your and Frederic's latest 
callgraph-speedup patches the parsing of perf.data got _really_ 
fast, so maybe my performance complaint is moot and we should delay 
complicating the primary perf.data file model with a 'cache' until 
your patches are in and we see the full impact.

Thanks,

	Ingo
