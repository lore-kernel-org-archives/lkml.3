Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984AbaISORH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 10:17:07 -0400
Received: from mail.kernel.org ([198.145.19.201]:52626 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755848AbaISORF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 10:17:05 -0400
Date: Fri, 19 Sep 2014 11:16:53 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2] perf tools: Fix build-id matching on vmlinux
Message-ID: <20140919141653.GA32694@kernel.org>
References: <1409893157-469-1-git-send-email-namhyung@kernel.org>
 <540964C0.1050702@intel.com>
 <20140905141123.GE30520@kernel.org>
 <1409930200.1662.16.camel@leonhard>
 <20140905154402.GF30520@kernel.org>
 <87ppf1mkkk.fsf@sejong.aot.lge.com>
 <20140912141116.GH1801@kernel.org>
 <87zjdwktwu.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zjdwktwu.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Sep 19, 2014 at 03:26:25PM +0900, Namhyung Kim escreveu:
> On Fri, 12 Sep 2014 11:11:16 -0300, Arnaldo Carvalho de Melo wrote:
> > Em Fri, Sep 12, 2014 at 03:14:51PM +0900, Namhyung Kim escreveu:
> >> On Fri, 5 Sep 2014 12:44:02 -0300, Arnaldo Carvalho de Melo wrote:
> >> > It seems we need a way to state that an entry in the build-id table is
> >> > for the kernel, without looking at its file name.

> >> Maybe we can add a new build_id2_event (like mmap2) that has a new field
> >> to record that info.

> > Humm, take a look at machine__write_buildid_table() -> write_buildid(),
> > we already seem to set build_id_event.header.misc suitably, no?
 
> AFAIK the PERF_RECORD_MISC_KERNEL is set for both of kernel image and
> modules so we cannot distinguish a kernel from others (without checking
> names).

Ok, not perfect, but I think we improve the situation by using this
piece of information while looking if the file ends in .ko, in which
case we can mark it as a kernel module, if it doesn't end in .ko, we
have a kernel.

Better than today, probably good enough, no?
 
> >> > That or to put the build-id into the synthesized kernel mmap
> >> > event. Which is better, because:

> >> > That leads to another problem that needs to get solved eventually: We
> >> > need to have the build-id into PERF_RECORD_MMAP, because we're now using
> >> > just the mmap filename as the key, not the contents, and for long
> >> > running sessions, DSOs can get updated, etc.

> >> But it'd require a realtime processing of events at record time.

> > Been there, done that, backtracked, yes, we can't do that at 'record
> > time', else we would be adding way too much noise to the recording
> > phase.

> > The idea is for the _kernel_ to do that, would take sizeof(buildid)
> > (about 20 bytes) on the per-DSO structure in the kernel.

> > When ELF loading it, stashing the contents of an ELF session
> > (.note.gnu.build-id) somewhere accessible at PERF_RECORD_MMAP3
> > generation time.

> > Doing that at the time we load the DSO from disk should add negligible
> > overhead.

> > With that we would not need to go over all the perf.data stream to
> > generate the build-id table after all record sessions, they would be at
> > the struct map already.
 
> Yes, it'll solve the problem and simplifies the perf record.  However I
> suspect it's not acceptable to keep such info in the kernel only for the
> sake of perf.

Hey, perf is a crucial part of development, even if it was the sole
user, I think this would be acceptable.

But this is not perf specific at all, any other tool that needs to map
from sample to a symtab _needs_ this, there is no other way to, on a
system with running apps and its libraries, to safely go from DSO
pathname to its corresponding binary.

Also this enables one to unambiguously describe a running environment
without packing tons of duplicated payloads for multiple workload runs,
be it for profiling or for any other problem characterization task.

And we have build-ids available for quite a while in all DSOs in the
system.

I bet gdb, systemtap, etc would be glad to use this if available.
 
> > We could then have multiple entries in the build-id table for the same
> > pathname, with different build ids, that is something we don't support
> > now and that provides bogus results when it happens.
 
> Maybe we can save and compare timestamp of build-id/map event and sample
> event.  I'm experimenting to separate meta events (comm, mmap, ...) from
> sample events with a similar idea... :)

The point is to go from an entry in /proc/pid/maps to the file where it
was loaded from, in a system where updates may have taken place for that
pathname.

- Arnaldo
