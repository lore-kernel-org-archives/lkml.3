Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbaDDG0R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:26:17 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39386 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbaDDG0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:26:13 -0400
MIME-Version: 1.0
In-Reply-To: <CAGdX0WEeZJ9hxq1y-gmGC=kdtU0ecLbs5gVYb_8ZE6sOW_PPvg@mail.gmail.com>
References: <CAGdX0WEeZJ9hxq1y-gmGC=kdtU0ecLbs5gVYb_8ZE6sOW_PPvg@mail.gmail.com>
Date: Thu, 3 Apr 2014 23:26:12 -0700
Message-ID: <CAMEtUuyQZo6fSMTZ5XKPfPBdjR13916Rd3=z5dip3N_WOzvr6Q@mail.gmail.com>
Subject: Re: ktap and ebpf integration
From: Alexei Starovoitov <ast@plumgrid.com>
To: Jovi Zhangwei <jovi.zhangwei@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg KH <gregkh@linuxfoundation.org>, Andi Kleen <andi@firstfloor.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 3, 2014 at 6:21 PM, Jovi Zhangwei <jovi.zhangwei@gmail.com> wrote:
> Hi Alexei,
>
> We talked a lot on ktap and ebpf integration in these days,
> Now I think we can put into deeply to thinking out some
> technical issues in there.
>
> Firstly, I want to make sure you are support this ktap and
> ebpf integration direction, I aware you have ongoing 'bpf filter'
> patch set work, which actually overlapping with ktap integration
> efforts (IMO the interface should be unified and simple for user,
>  so I think filter debugfs file is not a good interface), so please let
> me know your answer about this.

I think the more choices users have the better.
I'll continue with C based filters and you can continue with ktap
syntax. That's ok. We can share all kernel pieces.
Like:
1.
user: C -> llvm -> obj_file
kernel: obj_file -> ibpf_verifier -> ibpf execution engine
2.
user: ktap language -> ktap_compiler -> obj_file
kernel: obj_file -> ibpf_verifier -> ibpf execution engine

> If the answer is yes, then we can go through ebpf core
> improvement, for example:

In the architecture I'm proposing there are three main pieces:
- user facing language and userspace compiler into ibpf
  instruction set stored into object file format like ELF
  or something simpler
- in kernel loader of that object file, license and instruction verifier
- ibpf execution engine

ibpf execution engine can do all requested features already.
It's a matter of loader and verifier to accept them.
For example:

> - support global variable access

from execution engine point of view global or stack variable
makes no difference. It's a 'ld rY, word ptr [rX]' instruction.
where register rX is pointing to the stack or to some memory location.
In my old patch set 'verifier' was proving correctness of stack
and table accesses only, since I didn't see the need for global
pointers yet, but we can add it.

>   this is mandatory for dynamic tracing, otherwise, there have
>   no possible to run a simple script like get function execution
>   time.

I don't understand the correlation between measuring function
execution time and global variables.
I think userspace should be measuring script execution time.
Time sampling within kernel can be done from ibpf program
by calling ktime_get().

> - support timer in kernel
>   The final solution must need to support kernel timer for profiling,
>   and sampling stack.

we can let programs be executed in kernel by timer events, but
I think it's a userspace task.
If userspace can do it without hurting performance, it probably
should do it.

For example to do systemtap 'iotop.stp' which looks like:
probe vfs.read.return {
    reads[execname()] += bytes_read
}
probe vfs.write.return {
    writes[execname()] += bytes_written
}
# print top 10 IO processes every 5 seconds
probe timer.s(5) {
    foreach (name in writes)
        total_io[name] += writes[name]
    foreach (name in reads)
        total_io[name] += reads[name]
    printf ("%16s\t%10s\t%10s\n", "Process", "KB Read", "KB Written")
...
}
first two probe functions belong in kernel as two independent
ibpf programs that access 'reads' and 'writes' tables,
and 'timer.s' really belongs in userspace.
Every 5 seconds it can access 'reads' and 'write' tables, sort them,
print them, etc.
The important concept here is a user/kernel shared table.
ibpf program can read/write to it from kernel.
userspace component can read/write it in parallel.

Back in september I posted patches for this style of table
access via netlink.
Note that ibpf program doesn't own memory.
It can call 'bpf_table_update' to store key/value pair
into kernel table. Think of it as small in kernel database
that ibpf program can store data to and user space can
read/write data at the same time.

> - support register multi-event in one script

I think it should be clear now, that it's already supported.
one ibpf program == one function.
object file may contain multiple programs that attach to
different kprobe events and store key/value pairs into
the same or different tables.
>From verifier point of view this two programs are disjoint.
They cannot call each other. Verifier checks them
independently.

> - support trace_end

if you mean the final print out of everything,
then it's a userspace task.

Thanks
Alexei
