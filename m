Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbaHOGIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 02:08:15 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:57333 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407AbaHOGIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 02:08:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAE40pdf0pNYyazjpdkzxNJi7iC4LOOr_XEu078OUqP_uoCXnHg@mail.gmail.com>
References: <1407916658-8731-1-git-send-email-ast@plumgrid.com>
	<1407916658-8731-18-git-send-email-ast@plumgrid.com>
	<CAE40pdf0pNYyazjpdkzxNJi7iC4LOOr_XEu078OUqP_uoCXnHg@mail.gmail.com>
Date: Thu, 14 Aug 2014 23:08:10 -0700
Message-ID: <CAMEtUuymPDhYBe42i4DJNXsdgZRaq9LuEU_nGSsqrY1FcFHqhQ@mail.gmail.com>
Subject: Re: [PATCH RFC v4 net-next 17/26] tracing: allow eBPF programs to be
 attached to events
From: Alexei Starovoitov <ast@plumgrid.com>
To: Brendan Gregg <brendan.d.gregg@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
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

On Thu, Aug 14, 2014 at 2:20 PM, Brendan Gregg
<brendan.d.gregg@gmail.com> wrote:
> On Wed, Aug 13, 2014 at 12:57 AM, Alexei Starovoitov <ast@plumgrid.com> wrote:
> [...]
>> +/* For tracing filters save first six arguments of tracepoint events.
>> + * On 64-bit architectures argN fields will match one to one to arguments passed
>> + * to tracepoint events.
>> + * On 32-bit architectures u64 arguments to events will be seen into two
>> + * consecutive argN, argN+1 fields. Pointers, u32, u16, u8, bool types will
>> + * match one to one
>> + */
>> +struct bpf_context {
>> +       unsigned long arg1;
>> +       unsigned long arg2;
>> +       unsigned long arg3;
>> +       unsigned long arg4;
>> +       unsigned long arg5;
>> +       unsigned long arg6;
>> +       unsigned long ret;
>> +};
>
> While this works, the argN+1 shift for 32-bit is a gotcha to learn.
> Lets say arg1 was 64-bit, and my program only examined arg2. I'd need
> two programs, one for 64-bit (using arg2) and 32-bit (arg3). If there

correct.
I've picked 'long' type for these tracepoint 'arguments' to match
what is going on at assembler level.
32-bit archs are passing 64-bit values in two consecutive registers
or two stack slots. So it's partially exposing architectural details.
I've tried to use u64 here, but it complicated tracepoint+ebpf patch
a lot, since I need per-architecture support for moving C arguments
into u64 variables and hacking tracepoint event definitions in a nasty
ways. This 'long' type approach is the least intrusive I could find.
Also out of 1842 total tracepoint fields, only 144 fields are 64-bit,
so rarely one would need to deal with u64. Most of the tracepoint
arguments are either longs, ints or pointers, which fits this approach
the best.
In general the eBPF design approach is to keep kernel bits as simple
as possible and move complexity to user space.
In this case some higher language than C for writing scripts can
hide this oddity.
