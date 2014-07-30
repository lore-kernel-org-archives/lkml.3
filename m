Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbaG3Sx6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 14:53:58 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40728 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755499AbaG3Sx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 14:53:56 -0400
MIME-Version: 1.0
In-Reply-To: <20140730173638.GB8745@redhat.com>
References: <1406000723-4872-1-git-send-email-ast@plumgrid.com>
	<1406000723-4872-4-git-send-email-ast@plumgrid.com>
	<y0m1tt226lj.fsf@fche.csb>
	<CAMEtUuxNs=HBhtFwhBX3HOU6+QqtYZ+v7sJ74+cg-o+bi5GdoA@mail.gmail.com>
	<20140730173638.GB8745@redhat.com>
Date: Wed, 30 Jul 2014 11:53:54 -0700
Message-ID: <CAMEtUuzmiYDY=mSP2bxv90FA3_LpijBcdSNj6L72z0doxDqKLQ@mail.gmail.com>
Subject: Re: [PATCH RFC v3 net-next 3/3] samples: bpf: eBPF dropmon example in C
From: Alexei Starovoitov <ast@plumgrid.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 10:36 AM, Frank Ch. Eigler <fche@redhat.com> wrote:
>> > What kind of locking/serialization is provided by the ebpf runtime
>> > over shared variables such as my_map?
>>
>> it's traditional rcu scheme.
>
> OK, that protects the table structure, but:
>
>> [...] In such case concurrent write access to map value can be done
>> with bpf_xadd instruction, though using normal read/write is also
>> allowed. In some cases the speed of racy var++ is preferred over
>> 'lock xadd'.
>
> ... so concurrency control over shared values is left up to the
> programmer.

yes. It has to be flexible and fast.
One of our main use cases is network analytics where a lot of
packets are going through ebpf programs, so every cycle counts.
Mandatory locks in critical path are not acceptable. If we add
locks they will be optional.

>> There are no lock/unlock function helpers available to ebpf
>> programs, since program may terminate early with div by zero
>> for example, so in-kernel lock helper implementation would
>> be complicated and slow. It's possible to do, but for the use
>> cases so far there is no need.
>
> OK, I hope that works out.  I've been told that dtrace does something
> similiar (!)  by eschewing protection on global variables such as
> strings.  In their case it's less bad than it sounds because they are
> used to offloading computation to userspace or to store only
> thread-local state, and accept the corollary limitations on control.

interesting.
btw, things like global variables, per-cpu storage are potential ebpf
features. So far they're 'nice to have' instead of 'mandatory'.
The maps are powerful enough to do the same:
Global storage is map of one element.
Per-cpu storage is map of num_cpu elements.
