Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751125Ab3LFFnc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 00:43:32 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:42724 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab3LFFnb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 00:43:31 -0500
MIME-Version: 1.0
In-Reply-To: <20131205103840.GA20283@gmail.com>
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com>
	<20131203091655.GB20179@gmail.com>
	<CAMEtUuziP0zVe63HSxF0uVs1pnP--1HBs1-WsR2xfLOTyBaHSQ@mail.gmail.com>
	<20131204093417.GC32531@gmail.com>
	<CAMEtUuwMGwQEtX4p1RyNTSZBA_9j-XQ4aEtM7L5hrqPkS2szfw@mail.gmail.com>
	<20131205103840.GA20283@gmail.com>
Date: Thu, 5 Dec 2013 21:43:29 -0800
Message-ID: <CAMEtUuzuXnKOYHrN62TUX=QffP-AJ0OYg-Cb7cwDhPkqL5SpbA@mail.gmail.com>
Subject: Re: [RFC PATCH tip 0/5] tracing filters with BPF
From: Alexei Starovoitov <ast@plumgrid.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>, Pekka Enberg <penberg@iki.fi>,
        "David S. Miller" <davem@davemloft.net>,
        Arjan van de Ven <arjan@infradead.org>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 5, 2013 at 2:38 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
>> Also I'm thinking to add 'license_string' section to bpf binary format
>> and call license_is_gpl_compatible() on it during load.
>> If false, then just reject it…. not even messing with taint flags...
>> That would be way stronger indication of bpf licensing terms than what
>> we have for .ko
>
> But will BFP tools generate such gpl-compatible license tags by
> default? If yes then this might work, combined with the facility
> below. If not then it's just a nuisance to users.

yes. similar to existing .ko module_license() tag. see below.

> My concern would be solved by adding a facility to always be able to
> dump source code as well, i.e. trivially transform it to C or so, so
> that people can review it - or just edit it on the fly, recompile and
> reinsert? Most BFP scripts ought to be pretty simple.

C code has '#include' in them, so without storing fully preprocessed code
it will not be equivalent. but then true source will be gigantic.
Can be zipped, but that sounds like an overkill.
Also we might want other languages with their own dependent includes.
Sure, we can have a section in bpf binary that has the source, but it's not
enforceable. Kernel cannot know that it's an actual source.
gcc/llvm will produce different bpf code out of the same source.
the source is in C or in language X, etc.
Doesn't seem that including some form of source will help
with enforcing the license.

imo requiring module_license("gpl"); line in C code and equivalent
string in all other languages that want to translate to bpf would be
stronger indication of licensing terms.
then compiler would have to include that string into 'license_string'
section and kernel can actually enforce it.
