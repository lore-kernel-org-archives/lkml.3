Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbbAES3D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 13:29:03 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:62341 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379AbbAES3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 13:29:02 -0500
MIME-Version: 1.0
In-Reply-To: <20150105164447.GG29390@twins.programming.kicks-ass.net>
References: <cover.1420396372.git.luto@amacapital.net> <e431cd4c18c2e1c44c774f10758527fb2d1025c4.1420396372.git.luto@amacapital.net>
 <20150105140754.GF29390@twins.programming.kicks-ass.net> <CALCETrW6cv_s60uzi_scy5JBdr4+wrz1O5we-3okc-SZKRVofA@mail.gmail.com>
 <20150105164447.GG29390@twins.programming.kicks-ass.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 5 Jan 2015 10:28:39 -0800
Message-ID: <CALCETrXR08PnHz_yFO=i95UYyHvPVV1FT1EoW5rdGX8Ac_F-eg@mail.gmail.com>
Subject: Re: [PATCH 1/2] perf: Move task_pt_regs sampling into arch code
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, root <chenggang.qin@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?B?56em5om/5YiaKOaJv+WImik=?= <chenggang.qcg@taobao.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Paul Mackerras <paulus@samba.org>,
        =?UTF-8?B?56em5om/5YiaKOaJv+WImik=?= 
	<chenggang.qcg@alibaba-inc.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2015 at 8:44 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, Jan 05, 2015 at 08:13:49AM -0800, Andy Lutomirski wrote:
>> > Just wondering how bad it would be to fill out the actual pt_regs that
>> > was previously partially initialized?
>>
>> Bad, for at least two reasons.
>>
>> One is that we don't actually know which regs are initialized.  bx,
>> bp, r12 etc are particularly bad in this regard, due to the FORK_LIKE
>> mechanism and similar optimizations.
>
> Right, but you need to deal with that anyhow.

I cheated by assuming they're uninitialized.  If we actually wrote -1
over them and they were initialized, then we'd be screwed.

>
>> The other is that the uninitialized part of task_pt_regs can be used
>> for something else entirely.  If we have a syscall instruction
>> immediately followed by a regular interrupt, then the interrupt's
>> hardware frame will overlap task_pt_regs.  (I'm not going to claim
>> that this design is sensible, but it is what it is.  IIRC Denys
>> Vlasenko had some patches to partially clean this up.)
>
> Ah, urgh. Yes painful that.
>
>> It would be possible to rework the code to avoid an extra pt_regs
>> copy, but I don't see an obvious way to do it cleanly.
>
> Yeah, we'll see how this works, I was just curious on the exact need for
> the copy, but if as you say, the original structure might not even exist
> properly (even though we have a pointer to it) that's bad (TM).

How much freedom do we have to redesign the whole mechanism?  Instead
of recording the user state from the PMI, we could set a flag so that
we'd sample the user state before return to user mode.  This would
reliably get all of the registers, except in the case where the PMI
was part way through the return-to-user code.  In that case, we'd want
to set another flag to catch the next entry to avoid writing a bogus
sample.

I don't think we could do this without changing the ABI, though.

This would waste ~300 cycles if we set the flag from a fast-path
syscall, at least until my magic sysret optimization goes in.

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
