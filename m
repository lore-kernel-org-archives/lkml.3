Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434AbaHORva (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 13:51:30 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:55102 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbaHORv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 13:51:28 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrV7vO6r--G2ns+A6qmDQYSzNXeemT=x41EF+XWmayM95g@mail.gmail.com>
References: <1407916658-8731-1-git-send-email-ast@plumgrid.com>
	<1407916658-8731-18-git-send-email-ast@plumgrid.com>
	<CALCETrV7vO6r--G2ns+A6qmDQYSzNXeemT=x41EF+XWmayM95g@mail.gmail.com>
Date: Fri, 15 Aug 2014 10:51:27 -0700
Message-ID: <CAMEtUuzCyxdOo+yYYZfDPRAu2yeQOw8TbUABwU-HD0+78PnV7A@mail.gmail.com>
Subject: Re: [PATCH RFC v4 net-next 17/26] tracing: allow eBPF programs to be
 attached to events
From: Alexei Starovoitov <ast@plumgrid.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2014 at 10:25 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Wed, Aug 13, 2014 at 12:57 AM, Alexei Starovoitov <ast@plumgrid.com> wrote:
>> User interface:
>> fd = open("/sys/kernel/debug/tracing/__event__/filter")
>>
>> write(fd, "bpf_123")
>
> I didn't follow all the code flow leading to parsing the "bpf_123"
> string, but if it works the way I imagine it does, it's a security
> problem.  In general, write(2) should never do anything that involves
> any security-relevant context of the caller.
>
> Ideally, you would look up fd 123 in the file table of whomever called
> open.  If that's difficult to implement efficiently, then it would be
> nice to have some check that the callers of write(2) and open(2) are
> the same task and that exec wasn't called in between.
>
> This isn't a very severe security issue because you need privilege to
> open the thing in the first place, but it would still be nice to
> address.

hmm. you need to be root to open the events anyway.
pretty much the whole tracing for root only, since any kernel data
structures can be printed, stored into maps and so on.
So I don't quite follow your security concern here.

Even say root opens a tracepoint and does exec() of another
app that uploads ebpf program, gets program_fd and does
write into tracepoint fd. The root app that did this open() is
doing exec() on purpose. It's not like it's exec-ing something
it doesn't know about.

Remember, FDs was your idea in the first place ;)
I had global ids and everything root initially.
