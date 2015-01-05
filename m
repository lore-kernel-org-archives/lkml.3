Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbbAEQON (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 11:14:13 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:37048 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbbAEQOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 11:14:11 -0500
MIME-Version: 1.0
In-Reply-To: <20150105140754.GF29390@twins.programming.kicks-ass.net>
References: <cover.1420396372.git.luto@amacapital.net> <e431cd4c18c2e1c44c774f10758527fb2d1025c4.1420396372.git.luto@amacapital.net>
 <20150105140754.GF29390@twins.programming.kicks-ass.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 5 Jan 2015 08:13:49 -0800
Message-ID: <CALCETrW6cv_s60uzi_scy5JBdr4+wrz1O5we-3okc-SZKRVofA@mail.gmail.com>
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

n Jan 5, 2015 6:08 AM, "Peter Zijlstra" <peterz@infradead.org> wrote:
>
> On Sun, Jan 04, 2015 at 10:36:19AM -0800, Andy Lutomirski wrote:
> > On x86_64, at least, task_pt_regs may be only partially initialized
> > in many contexts, so x86_64 should not use it without extra care
> > from interrupt context, let alone NMI context.
> >
> > This will allow x86_64 to override the logic and will supply some
> > scratch space to use to make a cleaner copy of user regs.
>
> Just wondering how bad it would be to fill out the actual pt_regs that
> was previously partially initialized?

Bad, for at least two reasons.

One is that we don't actually know which regs are initialized.  bx,
bp, r12 etc are particularly bad in this regard, due to the FORK_LIKE
mechanism and similar optimizations.

The other is that the uninitialized part of task_pt_regs can be used
for something else entirely.  If we have a syscall instruction
immediately followed by a regular interrupt, then the interrupt's
hardware frame will overlap task_pt_regs.  (I'm not going to claim
that this design is sensible, but it is what it is.  IIRC Denys
Vlasenko had some patches to partially clean this up.)

It would be possible to rework the code to avoid an extra pt_regs
copy, but I don't see an obvious way to do it cleanly.

--Andy
