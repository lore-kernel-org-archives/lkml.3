Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459AbaF3S1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 14:27:48 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57937 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755486AbaF3S1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 14:27:42 -0400
Date: Mon, 30 Jun 2014 20:27:36 +0200
From: Borislav Petkov <bp@alien8.de>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: RFC: /proc/cpuinfo confusion with AMD processors
Message-ID: <20140630182736.GH4766@pd.tnic>
References: <53B15D27.9010306@redhat.com>
 <20140630131309.GA5199@pd.tnic>
 <53B16621.50505@redhat.com>
 <20140630133803.GE4766@pd.tnic>
 <53B16F3D.5020303@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53B16F3D.5020303@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 10:07:57AM -0400, Prarit Bhargava wrote:
> Sorry, yes, exactly that. Requests have come in where an admin
> is setting up system loads relative to specific nodes and cores.
> Determining that information is trivial on Intel and a lot more
> difficult on AMD. (see below)

Yeah, that might not always work, see below.

> Intel does not have the concept of multi-node packages (AFAIK).

Let's establish terminology first: So I think you mean MCM - Multi-Chip
Module where you have more than one nodes, right?

https://en.wikipedia.org/wiki/Multi-chip_module

And according to the wiki article, Intel has that too.

HOWEVER(!), it is a whole another question whether that is made visible
to the software!

> So the Intel
> existing physical id and core id (both of which are relative to the package) is
> good enough to determine which core it is.  For example from an Intel box
> 
> 
> processor       : 3
> ...
> physical id     : 3
> siblings        : 2
> core id         : 1
> cpu cores       : 2
> 
> 
> 
> tells me that this processor 3 is on socket/package (physical id) 3, core 1 out
> of 2, and the cores are not hyperthreaded.  On a system in which an admin would
> like to (for example) set cpu affinity for a VM or a particular application
> knowing this information is useful.

> On an AMD system,
> 
> processor       : 31
> physical id     : 1
> siblings        : 16
> core id         : 7
> cpu cores       : 8
> 
> implies (using the logic above), package/socket 1,

Yes, the second socket.

> core 7/8 cores, and multi-threading is on ... which is incorrect.

What says that multithreading is on? How do you decide that? I think
you're reading too much into it.

> The package in question is 16 thread and 16 core with no multi-threading.

No, this is wrong.

So you are on socket 1 ("physical id"), it has 16 siblings, i.e.
threads. In this case, 16 threads means 16/2 = 8 compute units.
And core id 7 means the id of the the core on this NUMA node.

But just to show you that this information can be misleading, let's look
at another AMD box:

processor       : 30
cpu family      : 21
model           : 1
model name      : AMD Opteron(TM) Processor 6272
stepping        : 2
microcode       : 0x600063d
cpu MHz         : 1400.000
cache size      : 2048 KB
physical id     : 0
siblings        : 16
core id         : 7
cpu cores       : 8
apicid          : 47
initial apicid  : 15

processor       : 31
cpu family      : 21
model           : 1
model name      : AMD Opteron(TM) Processor 6272
stepping        : 2
microcode       : 0x600063d
cpu MHz         : 1400.000
cache size      : 2048 KB
physical id     : 1
siblings        : 16
core id         : 7
cpu cores       : 8
apicid          : 79
initial apicid  : 47

So those are the last two cores, 30 and 31.

Now look at physical id - 30 is on node 0 and 31 is on node 1. So thread
30 is on physical package 0 and thread 31 is on physical package 1, i.e.
on different physical sockets.

And yet, all the info there is correct - it is just not complete for your
purposes.

If you want to have the detailed information you're interested in,
simply do:

$ grep . /sys/devices/system/cpu/cpu30/topology/*
/sys/devices/system/cpu/cpu30/topology/core_id:7
/sys/devices/system/cpu/cpu30/topology/core_siblings:55555555
/sys/devices/system/cpu/cpu30/topology/core_siblings_list:0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30

All the core siblings, i.e. threads on this node, i.e. package 0.

/sys/devices/system/cpu/cpu30/topology/physical_package_id:0

This is the physical CPU package 0 on the socket in the motherboard.

/sys/devices/system/cpu/cpu30/topology/thread_siblings:50000000
/sys/devices/system/cpu/cpu30/topology/thread_siblings_list:28,30

This is thread 30 in a compute unit together with thread 28.


$ grep . /sys/devices/system/cpu/cpu31/topology/*
/sys/devices/system/cpu/cpu31/topology/core_id:7
/sys/devices/system/cpu/cpu31/topology/core_siblings:aaaaaaaa
/sys/devices/system/cpu/cpu31/topology/core_siblings_list:1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31
/sys/devices/system/cpu/cpu31/topology/physical_package_id:1

This is the physical CPU package 1 on the socket in the motherboard.

/sys/devices/system/cpu/cpu31/topology/thread_siblings:a0000000
/sys/devices/system/cpu/cpu31/topology/thread_siblings_list:29,31

This is thread 31 in a compute unit with thread 29 together.

At the time when we were talking about adding that info to
/proc/cpuinfo, the intention was declined by reviewers and it was said
that we have the topology hierarchy in sysfs where it all should be. And
I agree now, btw...

> The difference in the result occurs because AMD is (IMO) erroneously
> reporting per node information. Another view of this could be that
> on AMD systems we should modify the output to report per package
> information to make it consistent with Intel (and other arches ... ppc
> reports per socket as does s390. I haven't checked ARM yet). AMD is
> the outlier here.

... you can't express complicated topologies in /proc/cpuinfo. This is
nicely done in sysfs where all tools can access it.

> The problem isn't turbostat though -- it is that core_id implies two
> different things for two different x86 processors. Intel reports that
> value as per package, while AMD reports it as per node (and there is
> no way to determine which node it is).

No, you're making the wrong assumption that a single package can have
only one NUMA node. Which is basically not true on AMD. core_id is the
id of the core on that NUMA node. It means the same on Intel *and* AMD.

IF you have more than one nodes in a package, the core_id is still
correct as it is the numbering within the NUMA node.

Again, /proc/cpuinfo is not the proper place for complicated topologies,
at least on x86.

For NUMA we have different tools like numactl which give you that
precise information of the system topology and there was this other tool
which even generates PDFs of the topology. I'm forgetting the name right
now though.

HTH.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
