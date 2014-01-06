Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295AbaAFVOz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 16:14:55 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:53120 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755953AbaAFVOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 16:14:54 -0500
Date: Mon, 6 Jan 2014 18:14:44 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: enable close-on-exec flag on perf file
 descriptor
Message-ID: <20140106211444.GD2810@ghostprotocols.net>
References: <cover.1388952061.git.ydroneaud@opteya.com>
 <8c03f54e1598b1727c19706f3af03f98685d9fe6.1388952061.git.ydroneaud@opteya.com>
 <20140106092929.GA31570@twins.programming.kicks-ass.net>
 <1389005485-12778-1-git-send-email-ydroneaud@opteya.com>
 <20140106112436.GF31570@twins.programming.kicks-ass.net>
 <20140106144347.GA13500@ghostprotocols.net>
 <1389042095.13828.30.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1389042095.13828.30.camel@localhost.localdomain>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jan 06, 2014 at 10:01:35PM +0100, Yann Droneaud escreveu:
> Hi,
> 
> Le lundi 06 janvier 2014 à 11:43 -0300, Arnaldo Carvalho de Melo a
> écrit :
> > Em Mon, Jan 06, 2014 at 12:24:36PM +0100, Peter Zijlstra escreveu:
> 
> > > acme, ACK? I was thinking I'd keep these two patches together so the
> > > entire things lands in tip in one go?
> > 
> > Nope, it should notice the EINVAL, drop the flag that doesn't work on
> > older kernels, retry, so that new tools continue to work on older
> > kernels, with yet another fallback.
> > 
> 
> But it may be difficult to distinguish the 'origin' of EINVAL: is it
> from FD_CLOEXEC flag or from an unsupported parameter in the attributes.

It definitely is, that is why the first thing to fall back is the most
recently added feature.
 
> > Please take a look at __perf_evsel__open(), probably it will be best to
> > add a flag to perf_missing_features, like the one we have for the
> > perf_event_attr.mmap2 flag, so that we fail just once, etc.
> > 
> 
> Unfortunately perf_event_open() is called in multiple places, not only
> in __perf_evsel__open(). So a more generic solution should be designed.
> 
> Is something like the function proposed in message
> <1389022310.13828.9.camel@localhost.localdomain> [1]
> ok to be added to its own module:

Well, at least make it set a perf_missing_features flag instead of that
'cloexec' global, that way the routines that use perf_evsel__open would
reuse it.

- Arnaldo
 
> static int cloexec = PERF_FLAG_FD_CLOEXEC;
> 
> int perf_flag_fd_cloexec(void)
> {
>     static int probed;
> 
>     if (!probed) {
>         struct perf_event_attr attr = { 0 };
>         int fd = perf_event_open(&attr, 0, -1, -1,
> PERF_FLAG_FD_CLOEXEC);
>         probed = 1;
>         if (fd >= 0)
>             close(fd);
>         else
>             cloexec = 0;
>      }
> 
>      return cloexec;
> }
> 
> This function should be used to build the flag passed to
> perf_event_open().
> 
> Regards.
> 
> [1] 
> http://lkml.kernel.org/r/1389022310.13828.9.camel@localhost.localdomain
> 
> -- 
> Yann Droneaud
> OPTEYA
> 
