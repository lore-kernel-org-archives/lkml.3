Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab3JHNoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:44:44 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58982 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747Ab3JHNon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:44:43 -0400
Message-ID: <1381239876.15686.56.camel@marge.simpson.net>
Subject: Re: perf: perf sched lat segfault - bisected
From: Mike Galbraith <bitbucket@online.de>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 08 Oct 2013 15:44:36 +0200
In-Reply-To: <52540685.2000306@gmail.com>
References: <1381221715.15686.3.camel@marge.simpson.net>
	 <20131008121709.GA3955@infradead.org>
	 <1381235260.15686.38.camel@marge.simpson.net>
	 <1381235727.15686.41.camel@marge.simpson.net> <52540685.2000306@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:C3QU7lJliDdvn4W/um3ennFhEC5POs9eXYuLAu740eg
 nZZUvuJVoULi1pl0a0GVkZ0RRqpsaE+jXQ0faJu9CeUzXbNnrg
 evF0BiOHRH3UHyuP7f37aHDMZbkDqlWEgoQghVIdcOc85ZamKO
 OS28QA9UQ0S4IwhDZbPqjQst1Iuv0mVtGh8mwy9EASSJDB1fW4
 uzKh8Topa834PFyT7ES+KnawPVmt8mHuf2bTiptdO7mMacCKox
 f2Xr62F93moz28cc2kXxw8R+P62O/TC+Z8fub32BGNOAANS7vC
 o0OlMrMLdlPDZqVlz6YPxfk0hFnifkic58jwHoHBcjkXs2GiSj
 boUqGSXArcwsZCzNA4Q/U6iaCLE667ELAvUcjdaISAQSS4twkv
 6TKlfTaDcN4LA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-08 at 07:20 -0600, David Ahern wrote: 
> On 10/8/13 6:35 AM, Mike Galbraith wrote:
> >
> > (except replay segfaults, but lord knows when that last worked)
> 
> Fairly recently actually. I ran it early summer adding my timehist 
> command to builtin-sched.c. I'll take a look later today.

pr_err() blows up in self_open_counters() when you hit 1024 fds.  Too
many threads to play back after recording make in perf directory.
Playing a static load back works fine. 

Program received signal SIGSEGV, Segmentation fault.
[Switching to Thread 0x7fffedbc8700 (LWP 5270)]
buffered_vfprintf (s=0x7ffff301f700, format=0x65b9e0 "Error: sys_perf_event_open() syscall returned with %d (%s)\n", args=0x7fffedbc7a90) at vfprintf.c:2265
2265      result = INTUSE(_IO_vfprintf) (hp, format, args);
(gdb) where
#0  buffered_vfprintf (s=0x7ffff301f700, format=0x65b9e0 "Error: sys_perf_event_open() syscall returned with %d (%s)\n", args=0x7fffedbc7a90) at vfprintf.c:2265
#1  0x00007ffff2cd9dbe in _IO_vfprintf_internal (s=0x7ffff301f700, format=0x65b9e0 "Error: sys_perf_event_open() syscall returned with %d (%s)\n", ap=0x7fffedbc7a90) at vfprintf.c:1291
#2  0x00007ffff2d84148 in ___vfprintf_chk (fp=0x7ffff301f700, flag=1, format=<optimized out>, ap=<optimized out>) at vfprintf_chk.c:35
#3  0x000000000048d4f8 in vfprintf (__ap=0x7fffedbc7a90, __fmt=<optimized out>, __stream=<optimized out>) at /usr/include/bits/stdio2.h:128
#4  eprintf (level=<optimized out>, fmt=<optimized out>) at util/debug.c:29
#5  0x000000000043aa10 in self_open_counters () at builtin-sched.c:441
#6  thread_func (ctx=<optimized out>) at builtin-sched.c:476
#7  0x00007ffff79b1f05 in start_thread (arg=0x7fffedbc8700) at pthread_create.c:301
#8  0x00007ffff2d7010d in clone () at ../sysdeps/unix/sysv/linux/x86_64/clone.S:115
(gdb)

