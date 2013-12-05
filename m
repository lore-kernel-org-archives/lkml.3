Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab3LEKxt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 05:53:49 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:33942 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab3LEKxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 05:53:48 -0500
Date: Thu, 5 Dec 2013 11:53:44 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/38] perf/core improvements and fixes
Message-ID: <20131205105344.GD20283@gmail.com>
References: <1386187622-2928-1-git-send-email-acme@infradead.org>
 <20131205100429.GC16749@gmail.com>
 <20131205103707.GC21600@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131205103707.GC21600@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> On Thu, Dec 05, 2013 at 11:04:29AM +0100, Ingo Molnar wrote:
> > 
> > * Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
> > 
> > > From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> > > 
> > > Hi Ingo,
> > > 
> > > 	Please consider pulling,
> > > 
> > > - Arnaldo
> > > 
> > > The following changes since commit 89e3bbd58a6186b832fe2b9419ac2f9ab90e9089:
> > > 
> > >   Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2013-12-04 10:17:17 +0100)
> > > 
> > > are available in the git repository at:
> > > 
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo
> > 
> > Hm, I saw such a build failure:
> > 
> >   CC FPIC  plugin_kmem.o
> >   BUILD    PLUGIN plugin_jbd2.so
> > plugin_jbd2.o: file not recognized: File truncated
> > collect2: error: ld returned 1 exit status
> > make[2]: *** [plugin_jbd2.so] Error 1
> > make[1]: *** [install-traceevent-plugins] Error 2
> > make[1]: *** Waiting for unfinished jobs....
> >   CC FPIC  plugin_kvm.o
> >   CC FPIC  plugin_mac80211.o
> > 
> > which suggests some sort of build race ...
> > 
> > I was doing several 'make clean; make install' runs - and the second 
> > run failed. Unfortunately the failure was not reproducible after that 
> > point - and I tried dozens of times. The test system has 12 CPUs.
> > 
> > The following loop attempts to build until a failure occurs:
> > 
> >   cd tools/perf/
> >   while make install; do make clean; done
> > 
> > Any ideas?
> 
> never saw that one.. starting your test on 24 CPUs server now

I saw it again on a system by running two parallel build jobs:

  D=/tmp/perf-1; mkdir -p $D; while make O=$D install; do make O=$D clean; done
  D=/tmp/perf-2; mkdir -p $D; while make O=$D install; do make O=$D clean; done

one failed with:

  BUILD    PLUGIN plugin_kmem.so
make[2]: *** [sub-make] Error 2
make[1]: *** [/tmp/perf-1/libtraceevent.a] Error 2
make[1]: *** Waiting for unfinished jobs....
  BUILD    PLUGIN plugin_kvm.so

the other with:

  CC FPIC  plugin_cfg80211.o
  CC       /tmp/perf-2/builtin-help.o
  CC       /tmp/perf-2/builtin-sched.o
plugin_sched_switch.o: file not recognized: File truncated
collect2: error: ld returned 1 exit status
make[3]: *** [plugin_sched_switch.so] Error 1  BUILD    PLUGIN plugin_function.so


and that's clearly the new plugin code.

Thanks,

	Ingo
