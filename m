Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbaILG2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 02:28:16 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:60397 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaILG2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 02:28:14 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] perf tools: Fix build-id matching on vmlinux
References: <1409893157-469-1-git-send-email-namhyung@kernel.org>
	<540964C0.1050702@intel.com> <20140905141123.GE30520@kernel.org>
	<1409930200.1662.16.camel@leonhard>
	<20140905154402.GF30520@kernel.org>
	<CABPqkBQxcTK7YFhcaV5PORx7ub+scwpkd3Rd=bAPgTK6Cvh1Rg@mail.gmail.com>
	<20140908133847.GA2773@kernel.org>
Date: Fri, 12 Sep 2014 15:28:12 +0900
In-Reply-To: <20140908133847.GA2773@kernel.org> (Arnaldo Carvalho de Melo's
	message of "Mon, 8 Sep 2014 10:38:47 -0300")
Message-ID: <87lhppmjyb.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Sep 2014 10:38:47 -0300, Arnaldo Carvalho de Melo wrote:
> Em Sun, Sep 07, 2014 at 10:24:12PM +0200, Stephane Eranian escreveu:
>> Can't you figure out it is from the kernel (in perf record) by remembering
>> you got the buildid from /sys/kernel/notes?
>
> Sure, the question was more about how to encode that in the build-id
> table in the perf.data file, i.e. we don't have a flags field there that
> we could use a bit for this purpose (hey, this entry is for the kernel,
> please match it to the PERF_RECORD_MMAP [kernel_kallsyms] synthesized
> for the kernel).

So why not adding a new build_id2_event? :)


>
> We know it is a kernel because the name is [kernel.kallsyms] in the
> synthesized PERF_RECORD_MMAP. So perhaps we should have the kernel
> pathname right after the reference relocation symbol, that way we would
> use it to get the entry in the build-id table.
>
> I.e. parts of what we need are in the synthesized PERF_RECORD_MMAP (how
> to do relocation, start-end kernel mmap, and we have parts of it in the
> build-id table: the build-id and the full pathname. How to connect both
> is what we're trying to achieve here, and in a backwards compatible
> way.
>
> The (ugly) way I found to achieve all this is to concatenate the full
> pathname right after the ref reloc symbol in the synthesized
> PERF_RECORD_MMAP for the kernel mmap.
>
> Older tools would just ignore what is after the ref reloc symbol (need
> to check if we put the zero there, if not, we can add the zero + the
> full pathname.).
>
> Newer tools would look if the size of the record is longer than the
> strlen(ref_reloc_symbol), and if it is, it means we have the kernel full
> pathname after the ref_reloc_symbol, that we can use to find the
> build-id in the build-id table.

Or else, what about synthesizing a build-id event right after the kernel
mmap event (in perf_event__synthesize_kernel_mmap)?  This way we can
have same effect of extending the mmap event while keeping backward
compatibility IMHO.  At report time, we might need to set a flag that it
has just seen the kernel mmap event so that it expects to see a matching
build-id event (use it as a kernel dso).

Thanks,
Namhyung


>
> In the future this is all moot if we add the build-id to all
> PERF_RECORD_MMAP events, as described below:
>
>> > That leads to another problem that needs to get solved eventually: We
>> > need to have the build-id into PERF_RECORD_MMAP, because we're now using
>> > just the mmap filename as the key, not the contents, and for long
>> > running sessions, DSOs can get updated, etc.
>
> - Arnaldo
