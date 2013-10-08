Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab3JHJCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 05:02:40 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:34540 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab3JHJCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 05:02:37 -0400
Date: Tue, 8 Oct 2013 11:02:34 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC PATCH 00/50] tools/perf: Speed up the build system
Message-ID: <20131008090234.GE3295@gmail.com>
References: <1381147003-2574-1-git-send-email-mingo@kernel.org>
 <87y564zvk0.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y564zvk0.fsf@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> Ingo Molnar <mingo@kernel.org> writes:
> >
> > The series also includes a number of fixes and convenience features:
> >
> >    - auto-detect the number of CPUs on the system and add the -j<cpus>
> >      option automatically
> 
> FWIW I would prefer if you not do that automatically, because:
>
> - Often the optimal factor is not 1, but something like 1.5*CPUs (but 
> I'm not sure it's the same on all systems, probably depends on the IO 
> capacity and memory)

In my experience on numerous systems perf builds are rarely IO bound. But 
it could be upped to a factor of 1.5x without hurting the normal case if 
someone does convincing measurements.

> - It may use a lot of memory, so should be something controlled by the 
> user.

Lamest excuse evar: if your box cannot take NR_CPUs make jobs then you can 
tune it down. (You'll run into many other problems first though, before 
you start worrying about the perf build memory use.)

In the unlikely case of building it on a limited but SMP capable system 
with less than ~100 MB of free RAM you can override it:

  $ make
      BUILD: Doing 'make -j12' parallel build

  $ make JOBS=1
      BUILD: Doing 'make -j1' parallel build

Problem solved.

> - Often it's useful to use a few threads less to avoid interactivity 
> problems on a workstation.

Many people use 2*NR_CPUS for kernel builds and report interactivity 
problems relentlessly.

> - With LTO there can be rare cases where you need to lower it to avoid 
> running out of memory.

Oh, so out you come with the real reason, near the end of your list of 
complaints. Not a very honest approach.

If LTO is implemented correctly for a project then the biggest memory 
usage peak is during the final linking stage - which is single threaded...

> - Kernel build users should be already trained to set that parameter and 
> it's not really a big burden.

Second lamest excuse evar.

Really, 'make' doing the right thing out of box is a basic usability 
feature.

All other concerns you listed are secondary: they occur for specialized 
users or usecases, which need special care and hand-tuning anyway.

Thanks,

	Ingo
