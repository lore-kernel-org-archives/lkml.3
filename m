Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598AbaHOSxl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 14:53:41 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:46969 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaHOSxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 14:53:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAMEtUuzCyxdOo+yYYZfDPRAu2yeQOw8TbUABwU-HD0+78PnV7A@mail.gmail.com>
References: <1407916658-8731-1-git-send-email-ast@plumgrid.com>
 <1407916658-8731-18-git-send-email-ast@plumgrid.com> <CALCETrV7vO6r--G2ns+A6qmDQYSzNXeemT=x41EF+XWmayM95g@mail.gmail.com>
 <CAMEtUuzCyxdOo+yYYZfDPRAu2yeQOw8TbUABwU-HD0+78PnV7A@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 15 Aug 2014 11:53:16 -0700
Message-ID: <CALCETrUQN=vt3EUO=jNFC+sDHAiJdNyZWg4rwiEF7WKjPLi8Bg@mail.gmail.com>
Subject: Re: [PATCH RFC v4 net-next 17/26] tracing: allow eBPF programs to be
 attached to events
To: Alexei Starovoitov <ast@plumgrid.com>
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

On Fri, Aug 15, 2014 at 10:51 AM, Alexei Starovoitov <ast@plumgrid.com> wrote:
> On Fri, Aug 15, 2014 at 10:25 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Wed, Aug 13, 2014 at 12:57 AM, Alexei Starovoitov <ast@plumgrid.com> wrote:
>>> User interface:
>>> fd = open("/sys/kernel/debug/tracing/__event__/filter")
>>>
>>> write(fd, "bpf_123")
>>
>> I didn't follow all the code flow leading to parsing the "bpf_123"
>> string, but if it works the way I imagine it does, it's a security
>> problem.  In general, write(2) should never do anything that involves
>> any security-relevant context of the caller.
>>
>> Ideally, you would look up fd 123 in the file table of whomever called
>> open.  If that's difficult to implement efficiently, then it would be
>> nice to have some check that the callers of write(2) and open(2) are
>> the same task and that exec wasn't called in between.
>>
>> This isn't a very severe security issue because you need privilege to
>> open the thing in the first place, but it would still be nice to
>> address.
>
> hmm. you need to be root to open the events anyway.
> pretty much the whole tracing for root only, since any kernel data
> structures can be printed, stored into maps and so on.
> So I don't quite follow your security concern here.
>
> Even say root opens a tracepoint and does exec() of another
> app that uploads ebpf program, gets program_fd and does
> write into tracepoint fd. The root app that did this open() is
> doing exec() on purpose. It's not like it's exec-ing something
> it doesn't know about.

As long as everyone who can debugfs/tracing/whatever has all
privileges, then this is fine.

If not, then it's a minor capability or MAC bypass.  Suppose you only
have one capability or, more realistically, limited MAC permissions.
You can still open the tracing file, pass it to an unwitting program
with elevated permission (e.g. using selinux's entrypoint mechanism),
and trick that program into writing bpf_123.

Admittedly, it's unlikely that fd 123 will be an *eBPF* fd, but the
attack is possible.

I don't think that fixing this should be a prerequisite for merging,
since the risk is so small.  Nonetheless, it would be nice.  (This
family of attacks has lead to several root vulnerabilities in the
past.)

--Andy

>
> Remember, FDs was your idea in the first place ;)
> I had global ids and everything root initially.



-- 
Andy Lutomirski
AMA Capital Management, LLC
