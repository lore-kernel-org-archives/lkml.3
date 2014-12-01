Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbaLALsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:48:54 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:42324 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbaLALsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:48:51 -0500
Date: Mon, 1 Dec 2014 11:48:54 +0000
From: Will Deacon <will.deacon@arm.com>
To: Dave Jones <davej@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Don Zickus <dzickus@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141201114854.GB18466@arm.com>
References: <CA+55aFyOTpVQiku0xn=UHnXdYweKHZ5AsEUN9wUvOqH9XX4ENg@mail.gmail.com>
 <20141118145234.GA7487@redhat.com>
 <alpine.DEB.2.11.1411181914020.3909@nanos>
 <20141118215540.GD35311@redhat.com>
 <20141119021902.GA14216@redhat.com>
 <CA+55aFw13opSu6ETXgVo1tjrP+1PLkbsiKewEqRgdBKyBKALWA@mail.gmail.com>
 <20141119145902.GA13387@redhat.com>
 <546D0530.8040800@mit.edu>
 <20141120152509.GA5412@redhat.com>
 <20141125122217.GA15280@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141125122217.GA15280@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 12:22:17PM +0000, Will Deacon wrote:
> I'm not sure if this is useful, but I've been seeing trinity lockups
> on arm64 as well. Sometimes they happen a few times a day, sometimes it
> takes a few days (I just saw my first one on -rc6, for example).
> 
> However, I have a little bit more trace than you do and *every single time*
> the lockup has involved an execve to a virtual file system.

Ok, just hit another one of these and I have a little bit more info this
time. The trinity log is:

[child1:27912] [438] execve(name="/proc/602/task/602/oom_score", argv=0x3a8426c0, envp=0x3a7a3bb0) = 0    # wtf
[child0:27837] [1081] setfsuid(uid=-128) = 0x3fffb000
[child0:27837] [1082] shmdt(shmaddr=0x7f92269000) = -1 (Invalid argument)
[child0:27837] [1083] fchmod(fd=676, mode=5237) = -1 (Operation not permitted)
[child0:27837] [1084] setuid(uid=0xffffe000) = -1 (Operation not permitted)
[child0:27837] [1085] newfstatat(dfd=676, filename="/proc/612/fdinfo/390", statbuf=0x7f935d8000, flag=0x0) = -1 (Permission denied)
[child0:27837] [1086] process_vm_readv(pid=0, lvec=0x3a7a3d70, liovcnt=47, rvec=0x3a7a4070, riovcnt=74, flags=0x0) = -1 (No such process)
[child0:27837] [1087] clock_gettime(which_clock=0x890000000000003f, tp=0x0) = -1 (Invalid argument)
[child0:27837] [1088] accept(fd=676, upeer_sockaddr=0x3a842360, upeer_addrlen=16) = -1 (Socket operation on non-socket)
[child0:27837] [1089] getpid() = 0x6cbd
[child0:27837] [1090] getpeername(fd=496, usockaddr=0x3a842310, usockaddr_len=16) = -1 (Socket operation on non-socket)
[child0:27837] [1091] timer_getoverrun(timer_id=0x4ff8e1) = -1 (Invalid argument)
[child0:27837] [1092] sigaltstack(uss=0x7f93069000, uoss=0x0, regs=0x0) = -1 (Invalid argument)
[child0:27837] [1093] io_cancel(ctx_id=-3, iocb=0x0, result=0xffffffc000080000) = -1 (Bad address)
[child0:27837] [1094] mknodat(dfd=496, filename="/proc/irq/84/affinity_hint", mode=0xa2c03013110804a0, dev=0xfbac6adf1379fada) = -1 (File exists)
[child0:27837] [1095] clock_nanosleep(which_clock=0x2, flags=0x1, rqtp=0x0, rmtp=0xffffffc000080000) = -1 (Bad address)
[child0:27837] [1096] reboot(magic1=-52, magic2=0xffffff1edbdf7fff, cmd=0xffb5179bfafbfbff, arg=0x0) = -1 (Operation not permitted)
[child0:27837] [1097] sched_yield() = 0
[child0:27837] [1098] getpid() = 0x6cbd
[child0:27837] [1099] newuname(name=0x400008200405) = -1 (Bad address)
[child0:27837] [1100] vmsplice(fd=384, iov=0x3a88fc20, nr_segs=687, flags=0x2) = -1 (Resource temporarily unavailable)
[child0:27837] [1101] timerfd_gettime(ufd=496, otmr=0x1) = -1 (Invalid argument)
[child0:27837] [1102] getcwd(buf=0x0, size=111) = -1 (Bad address)
[child0:27837] [1103] setdomainname(name=0x0, len=0) = -1 (Operation not permitted)
[child0:27837] [1104] sched_getparam(pid=0, param=0xbaedc7bf7ffaf2fe) = -1 (Bad address)
[child0:27837] [1105] readlinkat(dfd=496, pathname="/proc/4/task/4/net/netstat", buf=0x7f935d4000, bufsiz=0) = -1 (Invalid argument)
[child0:27837] [1106] shmctl(shmid=0xa1000000000000ff, cmd=0x7dad54836e49ff1d, buf=0x900000000000002c) = -1 (Invalid argument)
[child0:27837] [1107] getpgid(pid=0) = 0x6cbd
[child0:27837] [1108] flistxattr(fd=496, list=0xffffffffffffffdf, size=0xe7ff) = 0
[child0:27837] [1109] remap_file_pages(start=0x7f9324b000, size=0xfffffffffffaaead, prot=0, pgoff=0, flags=0x0) = -1 (Invalid argument)
[child0:27837] [1110] io_submit(ctx_id=0xffbf, nr=0xffbef, iocbpp=0x8) = -1 (Invalid argument)
[child0:27837] [1111] flistxattr(fd=384, list=0x0, size=0) = 0
[child0:27837] [1112] semtimedop(semid=0xffffffffefffffff, tsops=0x0, nsops=0xfffffffff71a7113, timeout=0xffffffa9) = -1 (Invalid argument)
[child0:27837] [1113] ioctl(fd=384, cmd=0x5100000080000000, arg=362) = -1 (Inappropriate ioctl for device)
[child0:27837] [1114] futex(uaddr=0x0, op=0xb, val=0x80000000000000de, utime=0x8, uaddr2=0x0, val3=0xffffffff00000fff) = -1 (Bad address)
[child0:27837] [1115] listxattr(pathname="/proc/219/net/softnet_stat", list=0x0, size=152) = 0
[child0:27837] [1116] getrusage(who=0xffffffffff080808, ru=0xffffffc000080000) = -1 (Invalid argument)
[child0:27837] [1117] clock_settime(which_clock=0xffffffff7fffffff, tp=0x0) = -1 (Invalid argument)
[child0:27837] [1118] mremap(addr=0x6680000000, old_len=0, new_len=8192, flags=0x2, new_addr=0x5080400000) = -1 (Invalid argument)
[child0:27837] [1119] waitid(which=0x80000702c966254, upid=0, infop=0x7f90069000, options=-166, ru=0x7f90069004) = -1 (Invalid argument)
[child0:27837] [1120] sigaltstack(uss=0x40000000bd5fff6f, uoss=0x8000000000000000, regs=0x0) = -1 (Bad address)
[child0:27837] [1121] timer_delete(timer_id=0x4300d68e28803329) = -1 (Invalid argument)
[child0:27837] [1122] preadv(fd=384, vec=0x3a88fc20, vlen=173, pos_l=0x82000000ff804000, pos_h=96) = -1 (Invalid argument)
[child0:27837] [1123] getdents64(fd=384, dirent=0x7f90a69000, count=0x2ab672e3) = -1 (Not a directory)
[child0:27837] [1124] mlock(addr=0x7f92e69000, len=0x1e0000) 

so for some bizarre reason, child1 (27912) managed to execve oom_score
from /proc. mlock then hangs waiting for a completion in flush_work,
although I'm not sure how the execve is responsible for that.

Looking at the task trace:


SysRq : Show State
  task                        PC stack   pid father

[...]

deferwq         S ffffffc0000855b0     0   599      2 0x00000000
Call trace:
[<ffffffc0000855b0>] __switch_to+0x74/0x8c
[<ffffffc000534214>] __schedule+0x214/0x680
[<ffffffc0005346a4>] schedule+0x24/0x74
[<ffffffc0000c5780>] rescuer_thread+0x200/0x29c
[<ffffffc0000ca404>] kthread+0xd8/0xf0
sh              S ffffffc0000855b0     0   602      1 0x00000000
Call trace:
[<ffffffc0000855b0>] __switch_to+0x74/0x8c
[<ffffffc000534214>] __schedule+0x214/0x680
[<ffffffc0005346a4>] schedule+0x24/0x74
[<ffffffc0000b1f94>] do_wait+0x1c4/0x1fc
[<ffffffc0000b306c>] SyS_wait4+0x74/0xf0
trinity         S ffffffc0000855b0     0   610    602 0x00000000
Call trace:
[<ffffffc0000855b0>] __switch_to+0x74/0x8c
[<ffffffc000534214>] __schedule+0x214/0x680
[<ffffffc0005346a4>] schedule+0x24/0x74
[<ffffffc0000b1f94>] do_wait+0x1c4/0x1fc
[<ffffffc0000b306c>] SyS_wait4+0x74/0xf0
trinity-watchdo R  running task        0   611    610 0x00000000
Call trace:
[<ffffffc0000855b0>] __switch_to+0x74/0x8c
[<ffffffc000534214>] __schedule+0x214/0x680
[<ffffffc0005346a4>] schedule+0x24/0x74
[<ffffffc0005373a0>] do_nanosleep+0xcc/0x134
[<ffffffc0000f9da4>] hrtimer_nanosleep+0x88/0x108
[<ffffffc0000f9eb0>] SyS_nanosleep+0x8c/0xa4
trinity-main    S ffffffc0000855b0     0   612    610 0x00000000
Call trace:
[<ffffffc0000855b0>] __switch_to+0x74/0x8c
[<ffffffc000534214>] __schedule+0x214/0x680
[<ffffffc0005346a4>] schedule+0x24/0x74
[<ffffffc0000b1f94>] do_wait+0x1c4/0x1fc
[<ffffffc0000b306c>] SyS_wait4+0x74/0xf0
trinity-c0      D ffffffc0000855b0     0 27837    612 0x00000000
Call trace:
[<ffffffc0000855b0>] __switch_to+0x74/0x8c
[<ffffffc000534214>] __schedule+0x214/0x680
[<ffffffc0005346a4>] schedule+0x24/0x74
[<ffffffc000537204>] schedule_timeout+0x134/0x18c
[<ffffffc000535364>] wait_for_common+0x9c/0x144
[<ffffffc00053541c>] wait_for_completion+0x10/0x1c
[<ffffffc0000c4cdc>] flush_work+0xbc/0x168
[<ffffffc00013f608>] lru_add_drain_all+0x12c/0x180
[<ffffffc00015cb78>] SyS_mlock+0x20/0x118
trinity-c1      R  running task        0 27912    612 0x00000000
Call trace:
[<ffffffc0000855b0>] __switch_to+0x74/0x8c
trinity-c1      R  running task        0 27921  27912 0x00000000
Call trace:


We can see the child that did the execve has somehow gained its own
child process (27921) that we're unable to backtrace. I can't see any
clone/fork syscalls in the log for 27912.

At this point, both of the CPUs are sitting in idle, so there's nothing
interesting in their register dumps.

Still confused.

Will
