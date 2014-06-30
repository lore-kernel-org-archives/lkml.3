Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbaF3WJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 18:09:41 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:47103 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465AbaF3WJj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 18:09:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAMEtUuyKY=haqP11VgXHdfHBkqfB-KxuswygUd7hDPLkOFz9HQ@mail.gmail.com>
References: <1403913966-4927-1-git-send-email-ast@plumgrid.com>
 <1403913966-4927-4-git-send-email-ast@plumgrid.com> <CALCETrV3WLBmHewCZgfhCkjODWfq_byRg6sF7HpqZ6n9BVMBVQ@mail.gmail.com>
 <CAMEtUuzWs+MbSOGGD-Rc01DHKASa4GxbHdtCrSCLit4cUM35mA@mail.gmail.com>
 <CALCETrWy6=dzTycy-ckiMR92+nQeqAWp_Hw=hi__VSzVWZ43Ag@mail.gmail.com>
 <CAMEtUuwRf--qyPu3rKB7-57KAu2NdsQdEpVRckqabmf61g+h-g@mail.gmail.com>
 <CALCETrUoOTtQ1R1A8Ak35fxHxaFTPHWP6oZWnXDVLKa_ESziWw@mail.gmail.com>
 <CAMEtUuzS=9Y_ZjigofvQ5d3=89RS=+d8-WGPk9VVSMc3qawWsw@mail.gmail.com>
 <CALCETrWq+=Q3G2Smjd2RYES42UagpmD0EKxFM+jNufi6_qitWg@mail.gmail.com> <CAMEtUuyKY=haqP11VgXHdfHBkqfB-KxuswygUd7hDPLkOFz9HQ@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 30 Jun 2014 15:09:17 -0700
Message-ID: <CALCETrW3=idHOKF56d94suiA0NoiUGwr7pENm13q6=1XMbBPdw@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 03/14] bpf: introduce syscall(BPF, ...) and
 BPF maps
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 28, 2014 at 11:36 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
> On Sat, Jun 28, 2014 at 6:52 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Sat, Jun 28, 2014 at 1:49 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
>>>
>>> Sorry I don't like 'fd' direction at all.
>>> 1. it will make the whole thing very socket specific and 'net' dependent.
>>> but the goal here is to be able to use eBPF for tracing in embedded
>>> setups. So it's gotta be net independent.
>>> 2. sockets are already overloaded with all sorts of stuff. Adding more
>>> types of sockets will complicate it a lot.
>>> 3. and most important. read/write operations on sockets are not
>>> done every nanosecond, whereas lookup operations on bpf maps
>>> are done every dozen instructions, so we cannot have any overhead
>>> when accessing maps.
>>> In other words the verifier is done as static analyzer. I moved all
>>> the complexity to verify time, so at run-time the programs are as
>>> fast as possible. I'm strongly against run-time checks in critical path,
>>> since they kill performance and make the whole approach a lot less usable.
>>
>> I may have described my suggestion poorly.  I'm suggesting that all of
>> these global ids be replaced *for userspace's benefit* with fds.  That
>> is, a map would have an associated struct inode, and, when you load an
>> eBPF program, you'd pass fds into the kernel instead of global ids.
>> The kernel would still compile the eBPF program to use the global ids,
>> though.
>
> Hmm. If I understood you correctly, you're suggesting to do it similar
> to ipc/mqueue, shmem, sockets do. By registering and mounting
> a file system and providing all superblock and inode hooks… and
> probably have its own namespace type… hmm… may be. That's
> quite a bit of work to put lightly. As I said in the other email the first
> step is root only and all these complexity just not worth doing
> at this stage.

The downside of not doing it right away is that it's harder to
retrofit in without breaking early users.

You might be able to get away with using anon_inodes.  That will
prevent repoening via /proc/self/fd from working (I think), but that's
a good thing until someone fixes the /proc reopen hole.  Sigh.

--Andy
