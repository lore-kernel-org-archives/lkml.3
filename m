Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab3LDDJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 22:09:47 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:64767 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830Ab3LDDJp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 22:09:45 -0500
MIME-Version: 1.0
In-Reply-To: <87fvq9cwlk.fsf@tassilo.jf.intel.com>
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com>
	<87fvq9cwlk.fsf@tassilo.jf.intel.com>
Date: Tue, 3 Dec 2013 19:09:44 -0800
Message-ID: <CAMEtUuzweYxqwoaYH+J5a2uRM+PFcBH+Pb8Z_ALPUMp+QFz1tQ@mail.gmail.com>
Subject: Re: [RFC PATCH tip 0/5] tracing filters with BPF
From: Alexei Starovoitov <ast@plumgrid.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 3, 2013 at 4:01 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Alexei Starovoitov <ast@plumgrid.com> writes:
>
> Can you do some performance comparison compared to e.g. ktap?
> How much faster is it?

imo the most interesting ktap scripts (like kmalloc-top.kp) need
tables and timers.
tables are almost ready for prime time, but timers I prefer to keep
out of kernel.
I would like bpf filter to fill tables with interesting data in kernel
up to predefined limit
and periodically read and clear the tables from userspace.
This way I will be able to do nettop.stp, iotop.stp like programs.
So I'm still thinking what should be clean kernel/user interface for
bpf-defined tables.
Format of keys and elements of the table is defined within bpf program.
During load of bpf program, the tables are allocated and bpf program
can now lookup/update into them. At the same time corresponding
userspace program can read tables of this particular bpf program over
netlink.
Creating its own debugfs files for every filter feels too slow and
feature limited, since files are all or nothing interface. Netlink
access to bpf tables feels cleaner. Userspace will use libmnl to
access them. Other ideas?

In the mean time I'll do some simple
  trace probe:xx { print }
performance test…

> While it sounds interesting, I would strongly advise to make this
> capability only available to root. Traditionally lots of complex byte
> code languages which were designed to be "safe" and verifiable weren't
> really. e.g. i managed to crash things with "safe" systemtap multiple
> times. And we all know what happened to Java.
>
> So the likelyhood of this having some hole somewhere (either in
> the byte code or in some library function) is high.

Tracing filters are for root only today and should stay this way.
As far as safety of bpf… hard to argue systemtap point ;)
Though existing bpf is generally accepted to be safe.
extended bpf needs time to prove itself.
