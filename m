Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab3LEKit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 05:38:49 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:48949 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab3LEKip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 05:38:45 -0500
Date: Thu, 5 Dec 2013 11:38:40 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>, Pekka Enberg <penberg@iki.fi>,
        "David S. Miller" <davem@davemloft.net>,
        Arjan van de Ven <arjan@infradead.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH tip 0/5] tracing filters with BPF
Message-ID: <20131205103840.GA20283@gmail.com>
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com>
 <20131203091655.GB20179@gmail.com>
 <CAMEtUuziP0zVe63HSxF0uVs1pnP--1HBs1-WsR2xfLOTyBaHSQ@mail.gmail.com>
 <20131204093417.GC32531@gmail.com>
 <CAMEtUuwMGwQEtX4p1RyNTSZBA_9j-XQ4aEtM7L5hrqPkS2szfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMEtUuwMGwQEtX4p1RyNTSZBA_9j-XQ4aEtM7L5hrqPkS2szfw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexei Starovoitov <ast@plumgrid.com> wrote:

> > I mean more than that, I mean the licensing of BFP filters a user 
> > can find on his own system's kernel should be very clear: by the 
> > act of loading a BFP script into the kernel the user doing the 
> > 'upload' gives permission for it to be redistributed on 
> > kernel-compatible license terms.
> >
> > The easiest way to achieve that is to make sure that all loaded 
> > BFP scripts are 'registered' and are dumpable, viewable and 
> > reusable. That's good for debugging and it's good for 
> > transparency.
> >
> > This means a minimal BFP decoder will have to be in the kernel as 
> > well, but that's OK, we actually have several x86 instruction 
> > decoder in the kernel already, so there's no complexity threshold.
> 
> sure. there is pr_info_bpf_insn() in bpf_run.c that dumps bpf insn in
> human readable format.
> I'll hook it up to trace_seq, so that "cat
> /sys/kernel/debug/.../filter" will dump it.
> 
> Also I'm thinking to add 'license_string' section to bpf binary format
> and call license_is_gpl_compatible() on it during load.
> If false, then just reject it…. not even messing with taint flags...
> That would be way stronger indication of bpf licensing terms than what
> we have for .ko

But will BFP tools generate such gpl-compatible license tags by 
default? If yes then this might work, combined with the facility 
below. If not then it's just a nuisance to users.

Also, 'tainting' is a non-issue here, as we don't want the kernel to 
load license-incompatible scripts at all. This should be made clear in 
the design of the facility and the tooling itself.

> >> wow. I guess if the whole thing takes off, we would need an 
> >> in-kernel directory to store upstreamed bpf filters as well :)
> >
> > I see no reason why not, but more importantly all currently loaded 
> > BFP scripts should be dumpable, displayable and reusable in a 
> > kernel license compatible fashion.
> 
> ok. will add global bpf list as well (was hesitating to do something 
> like this because of central lock)

A lock + list is no big issue here I think, we do such central lookup 
locks all the time. If it ever becomes measurable it can be made 
scalable via numerous techniques.

> and something in debugfs that dumps bodies of all currently loaded 
> filters.
> 
> Will that solve the concern?

My concern would be solved by adding a facility to always be able to 
dump source code as well, i.e. trivially transform it to C or so, so 
that people can review it - or just edit it on the fly, recompile and 
reinsert? Most BFP scripts ought to be pretty simple.

(For example the most common way to load OpenGL shaders is to load the 
GLSL source code and that source code can be queried after insertion 
as well, so this is not an unusual model for small plugin-alike 
scriptlets.)

Thanks,

	Ingo
