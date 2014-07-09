Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbaGIMU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:20:56 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:60854 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbaGIMUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:20:54 -0400
MIME-Version: 1.0
In-Reply-To: <CACVxJT8U-E+vYjGPbiop-7Fqcwt0sWhMtmuCRQHLAnALU+5AgQ@mail.gmail.com>
References: <CACVxJT8U-E+vYjGPbiop-7Fqcwt0sWhMtmuCRQHLAnALU+5AgQ@mail.gmail.com>
Date: Wed, 9 Jul 2014 15:20:53 +0300
Message-ID: <CACVxJT8+9oJa5r2acCdNe5+PjDxYVmASMY2Pcb=FyzB4x+0Naw@mail.gmail.com>
Subject: Re: Procfs race condition bug
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Mike Cardwell <mike.cardwell@grepular.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelianov <xemul@parallels.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[broken email]

On Wed, Jul 9, 2014 at 3:17 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
>> I originally posted this two years ago (*) but received no response.
>> I just had a look and the problem still exists on the 3.14 kernel
>> I am currently running.
>>
>> I *think* I've uncovered a race condition bug in procfs.
>> If I attempt to open a file in /proc/net, eg "/proc/net/tcp"
>> it works fine, but if I spawn a POSIX thread and attempt to do it
>> from there, it *usually* fails with a "No such file or directory",
>> but some times succeeds. If I do a system call inside the thread
>> to look up the thread ID and then open "/proc/THREADID/net/tcp"
>> instead, it works fine.
>>
>> There are more details and some example code
>> so you can replicate the problem on a stack overflow question
>> I asked previously here:
>> http://stackoverflow.com/questions/11580020/opening-proc-net-tcp-in-c-from-a-posix-thread-fails-most-of-the-time
>>
>> (*) https://lkml.org/lkml/2012/7/20/331
>
> Mike,
>
> as was correctly notes on SO, what's happening is that original thread exits
> before spawned thread does open().
>
> ->lookup
> proc_tgid_net_lookup
> get_proc_task_net
> nsproxy = NULL          <== thread is dead
> ENOENT
>
> This was probably broken when /proc/net became symlink:
>
> commit e9720acd728a46cb40daa52c99a979f7c4ff195c
> Author: Pavel Emelyanov <xemul@openvz.org>
> Date:   Fri Mar 7 11:08:40 2008 -0800
>
>     [NET]: Make /proc/net a symlink on /proc/self/net (v3)
>
>
> So, userspace has two solutions:
> 1) original thread doesn't exit too early
> 2) spawned thread uses /proc/$TID
>
>
> So,
> we definitely broke /proc/net/tcp somewhere after netns concept was introduced.
>
> But,
> you'd have very same problem with other /proc files (anything under
> /proc/$PID/).
>
>     Alexey
>
>
> #include <sys/types.h>
> #include <sys/stat.h>
> #include <fcntl.h>
> #include <stdio.h>
> #include <pthread.h>
> #include <unistd.h>
>
> void *f(void *_)
> {
> int fd;
>
> sleep(1);
>
> fd = open("/proc/net/tcp", O_RDONLY);
> if (fd == -1) {
> fprintf(stderr, "FAIL\n");
> return NULL;
> }
> fprintf(stderr, "OK\n");
> return NULL;
> }
>
> int main(void)
> {
> pthread_t thread;
>
> pthread_create(&thread, NULL, f, NULL);
> pthread_exit(0);
> return 0;
> }
