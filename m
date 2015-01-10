Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132AbbAJV1Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 16:27:25 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:50625 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbbAJV1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 16:27:21 -0500
MIME-Version: 1.0
In-Reply-To: <CAK1hOcPAxvuPRB-+z2kob2=sF1C+aftH4M9JL2MaA5VcQDzuNA@mail.gmail.com>
References: <1420734315-30943-1-git-send-email-dvlasenk@redhat.com>
	<1420734315-30943-4-git-send-email-dvlasenk@redhat.com>
	<20150109121950.GD13637@pd.tnic>
	<CAK1hOcMsGJ7geRAzfazPLZitcO0o9XYRPJDYa8sJHR4i6DPL-g@mail.gmail.com>
	<20150110142336.GC12218@pd.tnic>
	<CAK1hOcO7K=4N8CF=LOPmosXRNnogaNi5vLDPMdb0XiKsL=JOfg@mail.gmail.com>
	<CALCETrXS7BvtS3P3J8hnbt3GGvezx-935uxanSN_a=CU6s1d3g@mail.gmail.com>
	<20150110204231.GD12218@pd.tnic>
	<CALCETrWwnfU9roXp_0Z_hHo-c2LMcc3_KRKJgx_=p2U-+i5PrA@mail.gmail.com>
	<CAK1hOcPAxvuPRB-+z2kob2=sF1C+aftH4M9JL2MaA5VcQDzuNA@mail.gmail.com>
Date: Sat, 10 Jan 2015 13:27:20 -0800
X-Google-Sender-Auth: dqsBELBJIzlgjmh90Xfqw8JZwqg
Message-ID: <CA+55aFy-uSod4dndhjZ2VKgLkG42hajk7HLJwuNdv_eHfTW-=Q@mail.gmail.com>
Subject: Re: [PATCH 3/4] x86: open-code register save/restore in
 trace_hardirqs thunks
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Borislav Petkov <bp@alien8.de>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 1:09 PM, Denys Vlasenko
<vda.linux@googlemail.com> wrote:
>
> I think using push/pop is okay. In the very hottest code paths
> you may want to prefer mov's.

For kernel entrypoints in particular, the code sequence is quite
possibly constrained by the decoder and instruction fetch rather than
the execution engine. Even if the entrypoint were to be in the L1 I$
(which is not generally the case except in microbenchmarks), I am
pretty sure that even Intel doesn't actually speculatively decode
across system call boundaries, so unlike normal nice code, you don't
have the front end running ahead of the execution engine.

Looking at the system call hotpath, for example, it looks like we
save/restore 8 registers. So 16 instructions or about 80 bytes of
code. I could easily imagine us avoiding one cacheline access by using
shorter 1- and 2-byte push/pop instructions (depending a bit on how
the cacheline alignment works out, of course).

Depending on how well it prefetches from L2 and/or exact decoder
details, that kind of issue *can* overshadow the actual execution
costs. Of course, on microbenchmarks (eg some system call benchmark
that does "getppid()" in a loop), even the kernel side stays in the
L1, so those might show possible execution issues more. And
macrobenchmarks probably won't show a cycle or two in the system call
or fault path anyway.

                    Linus
