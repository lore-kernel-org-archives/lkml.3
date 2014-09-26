Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030234AbaIZVZb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 17:25:31 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:62365 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755763AbaIZVZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 17:25:29 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrXS5KBHm-3Fz031VFPpTHC_BDOLd_zNB6DjCidZa5-x2A@mail.gmail.com>
References: <CALCETrVrHHxGo1RkPu+9LVnPo9XY9yYnJzg2ot0zOgoBspzbOQ@mail.gmail.com>
	<CAMEtUuyt9RASKZ4NeqK_OUYNN8QT6P20+kjcwywchur6QXSt0A@mail.gmail.com>
	<CALCETrXS5KBHm-3Fz031VFPpTHC_BDOLd_zNB6DjCidZa5-x2A@mail.gmail.com>
Date: Fri, 26 Sep 2014 14:25:27 -0700
Message-ID: <CAMEtUux-WFOGABTrWW=BGUstE=Zz6agXTGCGrRJtNXDfRmx-5A@mail.gmail.com>
Subject: Re: eBPF verifier thoughts (Re: [PATCH v15 net-next 00/11] eBPF
 syscall, verifier, testsuite)
From: Alexei Starovoitov <ast@plumgrid.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: David Miller <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
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

On Fri, Sep 26, 2014 at 1:39 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> not quite. there is a distinction between key and value.
>> They both come from map definition and correspond to key_size
>> and value_size, so they have to have two different corresponding
>> _internal_ types 'ptr_to_map_key' and 'ptr_to_map_value'
>> This distinction is needed to properly describe function
>> arguments constraints.
>
> But they're still just pointers to buffers of some size known to the
> verifier, right?  By calling them "pointer to map key" and "pointer to
> map value" you're tying them to map objects in a way that makes little
> sense to me.

'pointer_to_map_key' is internal argument constraint of the
in-kernel helper function. It tells verifier how to check the values
passed into function.
Just pointer + size abstraction is not enough here.
verifier has to know the type of what it's checking.

> So what's "spill part"?  Unless I misunderstood the stack tracking
> code, you're tracking each byte separately.
>
> You're also tracking the type for each stack slot separately for each
> instruction.  That looks like it'll account for the considerable
> majority of total memory usage.

verifier has to track each byte separately, because
malicious program may write a pointer into stack with 8-byte
write, then modify single byte with 1-byte write and then
try to read 8-byte back. Verifier has to catch that and
that's why it's tracking every byte-sized slot independently.

> I don't like the fact that the function proto comes from the
> environment instead of from the program.

that's must have.
in-kernel function argument constraints must come from
kernel. where else?
User program says I want to call function foo() and here
is my code that invokes it. Kernel sees prototype of this
foo() and checks arguments.
There is no point for user space program to also
pass foo() constraints. The only thing kernel can do
with this extra info is to check that it matches what
kernel already knows.

>> nope. breadth-first just doesn't work at all.
>
> Sorry, I didn't actually mean BFS.  I meant to order the search such
> that all incoming control flow edges to an insn are visited before any
> of the outgoing edges are visited.

hmm. I'm not sure how exactly you plan on achieving that.
I don't think we want to see real control/data flow graph
analysis in the kernel the way compilers do things.
It will be tens of thousands lines of code.
The algorithm you see in this verifier is straight forward and
tiny. I guess when time passes by when may get enough
courage to attempt something like this, but
today 'kiss' principle rules.

>> complexity is actually described in the doc.
>> There are several limits. Verifier will be aborted if it walks
>> more then 32k instructions or more then 1k branches.
>> So the very worst case takes micro seconds to reject
>> the program. So I don't see your concern.
>
> That this will randomly fail, then.  For all I know, there are
> existing valid BPF programs with vastly more than 32k "instructions"
> as counted by the verifier.

you need to double check your data :)
classic bpf limit is 4k instructions per program.
We're keeping the same limit for eBPF.
32k limit says that verifier will visit each instruction
no more than 8 times.
if we have a program full of branches, then yes, 32k limit will
be reached and that's exactly what 'state pruning' patch is
addressing! As I already said, I dropped it out of this set
to ease review and to keep patch set size minimal.
You can see it my tree:
https://git.kernel.org/cgit/linux/kernel/git/ast/bpf.git/commit/?h=v14&id=1d9529ae4ce24bc31ca245a156299aa9e59a29f0
I was planning to send it next.
It's small incremental patch on top of existing things.
