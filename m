Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366AbaDIDbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 23:31:12 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:55990 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756288AbaDIDbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 23:31:10 -0400
MIME-Version: 1.0
Date: Tue, 8 Apr 2014 20:31:08 -0700
Message-ID: <CAMEtUuwPpOE+yHycx1PuMso8gBC2jvUPaa8FoAHcH365ABs8yw@mail.gmail.com>
Subject: [RFC] bpf tracing filters API proposal. Was: [RFC PATCH 00/28] ktap:
 A lightweight dynamic tracing tool for Linux
From: Alexei Starovoitov <ast@plumgrid.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@kernel.org>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Olsa <jolsa@redhat.com>,
        Geoff.Levand@huawei.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 8, 2014 at 2:08 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Apr 08, 2014 at 04:40:36PM +0900, Masami Hiramatsu wrote:
>> (2014/04/07 22:55), Peter Zijlstra wrote:
>> > On Wed, Apr 02, 2014 at 09:42:03AM +0200, Ingo Molnar wrote:
>> >> I'd suggest using C syntax instead initially, because that's what the
>> >> kernel is using.
>> >>
>> >> The overwhelming majority of people probing the kernel are
>> >> programmers, so there's no point in inventing new syntax, we should
>> >> reuse existing syntax!
>> >
>> > Yes please, keep it C, I forever forget all other syntaxes. While I have
>> > in the past known other languages, I never use them frequently enough to
>> > remember them. And there's nothing more frustrating than having to fight
>> > a tool/language when you just want to get work done.
>>
>> Why wouldn't you write a kernel module in C directly? :)
>> It seems that all what you need is not a tracing language nor a bytecode
>> engine, but an well organized tracing APIs(library?) for writing a kernel
>> module for tracing...
>
> Most my kernels are CONFIG_MODULE=n :-) Also, I never can remember how
> to do modules.
>
> That said; what I currently do it hack the kernel with debug bits and
> pieces and run that, which is effectively the same. Its just that its
> impossible to save/share these hacks in any sane fashion.

seconded.
Fo debugging I have similar setup:
few ko template dirs that I copy into new dir, then tweak, insmod, dmesg.
Process is tedious, since one have to think through every line
of the code before doing insmod.
Similar slow process to explore unfamiliar kernel territory:
add some conditional printks and stackdumps,
think through, recompile, reboot.
What I would like to see is something like:

perf run file.c

where file.c contains my debugging code and looks as close as
possible to normal kernel code:

attach("net:netif_receive_skb")
void my_filter(struct bpf_context *ctx)
{
        char devname[4] = "lo";
        struct net_device *dev;
        struct sk_buff *skb = 0;

        skb = (struct sk_buff *)ctx->arg1;
        dev = bpf_load_pointer(&skb->dev);
        if (bpf_memcmp(dev->name, devname, 2) == 0) {
                char fmt[] = "skb %p dev %p \n";
                bpf_trace_printk(fmt, sizeof(fmt), (long)skb, (long)dev, 0);
        }
}

and I don't need to think hard while writing it, since whatever wrong
memory accesses I do, it shouldn't crash the kernel.

above is a working example, but it needs obvious improvements:
- trace_printk(), memcmp() need to be able to accept 'char *'
  in a normal way
- bpf_load_pointer() can be either a macro or whole bpf program
  can be a no-fault zone, so we can have C like:
  if (strcmp(skb->dev->name, "lo") == 0)

'perf' would run C->bpf compiler and orchestrate attaching
bpf programs to events and printing back results.

Answering Jovi's point about "is supported" vs "will be supported":
it is true.
December patches are obviously obsolete and every building
block will get through its own feedback/rewrite cycles.

For example:
- In december I've been using simplified obj_file format that
llvm was generating and kernel was parsing while loading.
- Last week I mentioned that probably makes sense to
use standard elf. It's actually less code in llvm backend
to output elf then custom obj_file
- today I'm thinking that kernel shouldn't be dealing with
  either elf or custom obj_file at all

kernel API for bpf loading should be simpler.
we already have sk_unattached_filter_create().
we can expose it to userspace and add:
sk_filter_associate_to_event()
Then earlier "one bpf program = one event" misunderstanding
wouldn't have happened.
Userspace can decide what syntax to use to associate
tracing filters to events.
llvm compiler should not care. It just compiles C into elf
with function bodies being ibpf instructions.
Then perf interprets this elf file in userspace and calls
sk_unattached_filter_create() N times and
sk_filter_associate_to_event() M times.
Then waits for user input, tears down things and prints tracebuf.

Similar basic interface I'm thinking to use for bpf tables.
Probably makes sense to drop 'bpf' prefix, since they're just
hash tables. Little to do with bpf.
Have a netlink API from user into kernel:
- create hash table (num_of_entries, key_size, value_size, id)
- dump table via netlink
- add/remove key/value pair
Some kernel module may use it to transfer the data between
kernel and userspace.
This can be a generic kernel/user data sharing facility.

Also let bpf programs do 'table_lookup/update', so that
filters can store interesting data.

To summarize,
proposed new user->kernel API via netlink or debugfs is:
- sk_unattached_filter_create(bpf prog)
- sk_filter_associate_to_event(bpf_prog_id, event)
- hash table create/dump/add/remove
That's it.

event creation, tracebuf facilities are reused as is.

ibpf interpreter, ibpf jits, ibpf verifier are reused across
socket filtering, seccomp, tracing filters.

perf would call llvm compiler, extract bpf filters, event and table
description out of elf and call above APIs.
Pretty much all the heavy duty tasks will be done in userspace
and kernel stays generic and hopefully simple.

Note that here I don't consider ibpf instruction set to
be user->kernel API, because I'd like llvm backend
to be hosted in kernel tree, so we can change it in step.

Since llvm compiler doesn't know what it's being used for,
it can be reused for optimized tcpdump, optimized seccomp,
and other things.

All of the pieces I mentioned above were posted to the list
earlier in this form or similar. They need rebase and cleanup.

Thanks
Alexei
