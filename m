Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab3JCRWB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 13:22:01 -0400
Received: from mail-yh0-f53.google.com ([209.85.213.53]:36969 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab3JCRV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 13:21:57 -0400
Date: Thu, 3 Oct 2013 14:21:41 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ingo Molnar <mingo@kernel.org>
Cc: Ramkumar Ramachandra <artagnon@gmail.com>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [QUERY] Why does perf-trace need me to be root?
Message-ID: <20131003172141.GC2436@ghostprotocols.net>
References: <CALkWK0mmUZe-Wv2H2Z3y9FN0_kYv9gKaaXkMQ0UD-J9Q+=wFzQ@mail.gmail.com>
 <524C1964.8090205@gmail.com>
 <CALkWK0kzXnBKiRyN5HPE-_nScOG-JKjAnD1ujxA_R8tWQWrxZQ@mail.gmail.com>
 <20131003062505.GE25345@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003062505.GE25345@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Oct 03, 2013 at 08:25:05AM +0200, Ingo Molnar escreveu:
> * Ramkumar Ramachandra <artagnon@gmail.com> wrote:
> > David Ahern wrote:
> > > If you trust your users make the debugfs mount point rx by group,world.

> > Thanks David. I can preserve this configuration across reboots by
> > putting an entry in fstab, right? How do I preserve the value of
> > /proc/sys/kernel/perf_event_paranoid across reboots?

> via:

>    echo 'kernel.perf_event_paranoid = -1' >> /etc/sysctl.conf

You don't need that, only if you want users to trace syswide or threads
from other users:

[acme@zoo linux]$ cat /proc/sys/kernel/perf_event_paranoid 
1
[acme@zoo linux]$ trace -e brk usleep 1
     0.420 ( 0.001 ms): brk(                               ) = 0x2427000
     0.698 ( 0.002 ms): brk(                               ) = 0x2427000
     0.702 ( 0.002 ms): brk(brk: 0x2448000                 ) = 0x2448000
     0.704 ( 0.001 ms): brk(                               ) = 0x2448000
[acme@zoo linux]$

When doing syswide we get another message that can get some love and care:

[acme@zoo linux]$ trace -a
Couldn't create the events: Operation not permitted

Here we should tell that if this is done, as you suggested above:

[root@zoo ~]# echo -1 > /proc/sys/kernel/perf_event_paranoid 

Then lets do syswide tracing filtering out common syscalls:

[acme@zoo linux]$ trace -a -e \!write,lseek,ioctl,recvfrom,read,open,getrlimit,writev,poll,rt_sigprocmask,brk,,timer_gettime,timer_settime,gettid,setitimer,select,rt_sigaction,nanosleep,newfstatat,stat,close,openat,getdents,recvmsg,epoll_wait,sendmsg,futex,mmap,munmap,getsockopt,getegid,geteuid,lstat,fstat,inotify_add_watch,exit,madvise,fcntl,alarm,exit_group,wait4,unlink,link,dup,sendto,getuid,setgid,uname,umask,getgid,fsync,chdir,setuid,setreuid,setregid,socket,connect,access,mprotect,getpgrp,setresgid,getpid,execve,dup2,clone,getsockname,bind,arch_prctl,statfs,getppid,pipe2,capget,readlink,fstatfs
    90.964 ( 0.001 ms): python/7597 set_robust_list(head: 0x7ff5cf2d09e0, len: 24                         ) = 0
  1092.945 ( 0.002 ms): python/7598 set_robust_list(head: 0x7ff5cf2d09e0, len: 24                         ) = 0
  1104.372 ( 0.004 ms): fetchmail/2333 setresuid(ruid: -1, euid: 1000, suid: -1                              ) = 0
  1104.589 ( 0.003 ms): fetchmail/2333 setresuid(ruid: -1, euid: 1000, suid: -1                              ) = 0
  1104.869 ( 0.002 ms): fetchmail/7599 set_robust_list(head: 0x7f4d97395ae0, len: 24                         ) = 0
  2095.270 ( 0.001 ms): python/7600 set_robust_list(head: 0x7ff5cf2d09e0, len: 24                         ) = 0
  2581.513 ( 0.004 ms): fetchmail/2333 setresuid(ruid: -1, euid: 1000, suid: -1                              ) = 0
  2581.676 ( 0.002 ms): fetchmail/7601 set_robust_list(head: 0x7f4d97395ae0, len: 24                         ) = 0
  2581.688 ( 0.003 ms): fetchmail/2333 setresuid(ruid: -1, euid: 1000, suid: -1                              ) = 0
  3097.509 ( 0.002 ms): python/7602 set_robust_list(head: 0x7ff5cf2d09e0, len: 24                         ) = 0
  4100.418 ( 0.001 ms): python/7603 set_robust_list(head: 0x7ff5cf2d09e0, len: 24                         ) = 0
^C[acme@zoo linux]$


 
> I think 'perf trace' should probably print such suggestions when it 
> notices a privilege problem, to make it far more obvious for new users to 
> correctly configure their system for easy tracing.
> 
> The current output:
> 
>   comet:~/tip> perf trace
>   Couldn't read the raw_syscalls tracepoints information!
> 
> is as hostile to the user as it gets ;-)

Yes, its good that there are users now! ;-)

- Arnaldo
