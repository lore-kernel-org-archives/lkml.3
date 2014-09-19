Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223AbaISPm4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 11:42:56 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:61503 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398AbaISPmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 11:42:55 -0400
Subject: Re: [PATCH v2] perf tools: Fix build-id matching on vmlinux
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, stable@vger.kernel.org
In-Reply-To: <20140919141653.GA32694@kernel.org>
References: <1409893157-469-1-git-send-email-namhyung@kernel.org>
	 <540964C0.1050702@intel.com> <20140905141123.GE30520@kernel.org>
	 <1409930200.1662.16.camel@leonhard> <20140905154402.GF30520@kernel.org>
	 <87ppf1mkkk.fsf@sejong.aot.lge.com> <20140912141116.GH1801@kernel.org>
	 <87zjdwktwu.fsf@sejong.aot.lge.com>  <20140919141653.GA32694@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 20 Sep 2014 00:42:46 +0900
Message-ID: <1411141366.1680.15.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-09-19 (금), 11:16 -0300, Arnaldo Carvalho de Melo:
> Em Fri, Sep 19, 2014 at 03:26:25PM +0900, Namhyung Kim escreveu:
> > On Fri, 12 Sep 2014 11:11:16 -0300, Arnaldo Carvalho de Melo wrote:
> > > Em Fri, Sep 12, 2014 at 03:14:51PM +0900, Namhyung Kim escreveu:
> > >> On Fri, 5 Sep 2014 12:44:02 -0300, Arnaldo Carvalho de Melo wrote:
> > >> > It seems we need a way to state that an entry in the build-id table is
> > >> > for the kernel, without looking at its file name.
> 
> > >> Maybe we can add a new build_id2_event (like mmap2) that has a new field
> > >> to record that info.
> 
> > > Humm, take a look at machine__write_buildid_table() -> write_buildid(),
> > > we already seem to set build_id_event.header.misc suitably, no?
>  
> > AFAIK the PERF_RECORD_MISC_KERNEL is set for both of kernel image and
> > modules so we cannot distinguish a kernel from others (without checking
> > names).
> 
> Ok, not perfect, but I think we improve the situation by using this
> piece of information while looking if the file ends in .ko, in which
> case we can mark it as a kernel module, if it doesn't end in .ko, we
> have a kernel.
> 
> Better than today, probably good enough, no?

Yep, I'll check .ko suffix in v3.


>  
> > >> > That or to put the build-id into the synthesized kernel mmap
> > >> > event. Which is better, because:
> 
> > >> > That leads to another problem that needs to get solved eventually: We
> > >> > need to have the build-id into PERF_RECORD_MMAP, because we're now using
> > >> > just the mmap filename as the key, not the contents, and for long
> > >> > running sessions, DSOs can get updated, etc.
> 
> > >> But it'd require a realtime processing of events at record time.
> 
> > > Been there, done that, backtracked, yes, we can't do that at 'record
> > > time', else we would be adding way too much noise to the recording
> > > phase.
> 
> > > The idea is for the _kernel_ to do that, would take sizeof(buildid)
> > > (about 20 bytes) on the per-DSO structure in the kernel.
> 
> > > When ELF loading it, stashing the contents of an ELF session
> > > (.note.gnu.build-id) somewhere accessible at PERF_RECORD_MMAP3
> > > generation time.
> 
> > > Doing that at the time we load the DSO from disk should add negligible
> > > overhead.
> 
> > > With that we would not need to go over all the perf.data stream to
> > > generate the build-id table after all record sessions, they would be at
> > > the struct map already.
>  
> > Yes, it'll solve the problem and simplifies the perf record.  However I
> > suspect it's not acceptable to keep such info in the kernel only for the
> > sake of perf.
> 
> Hey, perf is a crucial part of development, even if it was the sole
> user, I think this would be acceptable.
> 
> But this is not perf specific at all, any other tool that needs to map
> from sample to a symtab _needs_ this, there is no other way to, on a
> system with running apps and its libraries, to safely go from DSO
> pathname to its corresponding binary.
> 
> Also this enables one to unambiguously describe a running environment
> without packing tons of duplicated payloads for multiple workload runs,
> be it for profiling or for any other problem characterization task.
> 
> And we have build-ids available for quite a while in all DSOs in the
> system.
> 
> I bet gdb, systemtap, etc would be glad to use this if available.

Hmm.. okay then.  But IIUC kernel only knows about an executable (and
dynamic linker) at load time not libraries as they're loaded by the
linker.  So kernel needs to check whether a file is an ELF and has
build-id for every file, right?

Thanks,
Namhyung


>  
> > > We could then have multiple entries in the build-id table for the same
> > > pathname, with different build ids, that is something we don't support
> > > now and that provides bogus results when it happens.
>  
> > Maybe we can save and compare timestamp of build-id/map event and sample
> > event.  I'm experimenting to separate meta events (comm, mmap, ...) from
> > sample events with a similar idea... :)
> 
> The point is to go from an entry in /proc/pid/maps to the file where it
> was loaded from, in a system where updates may have taken place for that
> pathname.
> 
> - Arnaldo



