Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbaISG03 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 02:26:29 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:61529 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaISG02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 02:26:28 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2] perf tools: Fix build-id matching on vmlinux
References: <1409893157-469-1-git-send-email-namhyung@kernel.org>
	<540964C0.1050702@intel.com> <20140905141123.GE30520@kernel.org>
	<1409930200.1662.16.camel@leonhard>
	<20140905154402.GF30520@kernel.org>
	<87ppf1mkkk.fsf@sejong.aot.lge.com> <20140912141116.GH1801@kernel.org>
Date: Fri, 19 Sep 2014 15:26:25 +0900
In-Reply-To: <20140912141116.GH1801@kernel.org> (Arnaldo Carvalho de Melo's
	message of "Fri, 12 Sep 2014 11:11:16 -0300")
Message-ID: <87zjdwktwu.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2014 11:11:16 -0300, Arnaldo Carvalho de Melo wrote:
> Em Fri, Sep 12, 2014 at 03:14:51PM +0900, Namhyung Kim escreveu:
>> On Fri, 5 Sep 2014 12:44:02 -0300, Arnaldo Carvalho de Melo wrote:
>> > It seems we need a way to state that an entry in the build-id table is
>> > for the kernel, without looking at its file name.
>  
>> Maybe we can add a new build_id2_event (like mmap2) that has a new field
>> to record that info.
>
> Humm, take a look at machine__write_buildid_table() -> write_buildid(),
> we already seem to set build_id_event.header.misc suitably, no?

AFAIK the PERF_RECORD_MISC_KERNEL is set for both of kernel image and
modules so we cannot distinguish a kernel from others (without checking
names).

>
>> > That or to put the build-id into the synthesized kernel mmap
>> > event. Which is better, because:
>
>> > That leads to another problem that needs to get solved eventually: We
>> > need to have the build-id into PERF_RECORD_MMAP, because we're now using
>> > just the mmap filename as the key, not the contents, and for long
>> > running sessions, DSOs can get updated, etc.
>  
>> But it'd require a realtime processing of events at record time.
>
> Been there, done that, backtracked, yes, we can't do that at 'record
> time', else we would be adding way too much noise to the recording
> phase.
>
> The idea is for the _kernel_ to do that, would take sizeof(buildid)
> (about 20 bytes) on the per-DSO structure in the kernel.
>
> When ELF loading it, stashing the contents of an ELF session
> (.note.gnu.build-id) somewhere accessible at PERF_RECORD_MMAP3
> generation time.
>
> Doing that at the time we load the DSO from disk should add negligible
> overhead.
>
> With that we would not need to go over all the perf.data stream to
> generate the build-id table after all record sessions, they would be at
> the struct map already.

Yes, it'll solve the problem and simplifies the perf record.  However I
suspect it's not acceptable to keep such info in the kernel only for the
sake of perf.


>
> We could then have multiple entries in the build-id table for the same
> pathname, with different build ids, that is something we don't support
> now and that provides bogus results when it happens.

Maybe we can save and compare timestamp of build-id/map event and sample
event.  I'm experimenting to separate meta events (comm, mmap, ...) from
sample events with a similar idea... :)

Thanks,
Namhyung
