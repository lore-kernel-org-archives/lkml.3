Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab3F0Qax (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 12:30:53 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:40515 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab3F0Qaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 12:30:52 -0400
MIME-Version: 1.0
In-Reply-To: <20130627160232.GA1748@hal>
References: <20130626114324.GA3538@hal>
	<CAAHN_R1LyhSJE5bAisx39sOyFfRTXQGpCx=CrwQYHWZHSTnOcw@mail.gmail.com>
	<20130627160232.GA1748@hal>
Date: Thu, 27 Jun 2013 22:00:51 +0530
Message-ID: <CAAHN_R1Y0q7MCbe+uhQVwME491BK_aRt=E_H1sDDTfi_V+OHcg@mail.gmail.com>
Subject: Re: Ambigiuous thread stack annotation in /proc/pid/[s]maps
From: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
To: Jan Glauber <jan.glauber@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 June 2013 21:32, Jan Glauber <jan.glauber@gmail.com> wrote:
> But isn't that confusing to the user? At least it is to me. Imagine someone
> who uses the maps or smaps output to determine the size of code, data and
> stack of a process. Maybe it would be better to not print the stack:tid data
> at all if the kernel cannot distinguish the vma's?
> Is that behaviour documented anywhere?

I'm afraid the documentation update I made to proc.txt did not mention
this.  In fact I went through the discussion thread and I don't think
I or anyone mentioned this in the thread either.  I think I assumed
back then that this was accepted since there was a point made that
vmas used by makecontext/swapcontext should also get marked correctly
with [stack].

However, I agree that you have a point about it being misleading.
Avoiding a vma merge is a possible solution, but we don't have flags
available any more to do that.  I'll try to think of another way.  In
the mean time I could add a note to the proc.txt documentation and
even adjust the language.  Would that be good enough or do you think
the patch should be reverted until I or someone else comes up with a
better solution?

> Never seen that makecontext stuff before. Do you have an example output how
> the maps would look like if that is used?

This is a sample program I cribbed from the makecontext man page and
modified slightly.  The stack is in the data area in this example.
There could be a case of a stack being with the main program stack or
even in the heap.

#include <ucontext.h>
#include <stdio.h>
#include <stdlib.h>

static ucontext_t uctx_main, uctx_func1, uctx_func2;

#define handle_error(msg) \
           do { perror(msg); exit(EXIT_FAILURE); } while (0)

static char func1_stack[16384];
static char func2_stack[16384];

static void func1(void)
{
        printf("func1: started\n");
        printf("func1: swapcontext(&uctx_func1, &uctx_func2)\n");
        if (swapcontext(&uctx_func1, &uctx_func2) == -1)
                handle_error("swapcontext");

        sleep (1);
        printf("func1: returning\n");
}

static void func2(void)
{
        printf("func2: started\n");
        printf("func2: swapcontext(&uctx_func2, &uctx_func1)\n");
        if (swapcontext(&uctx_func2, &uctx_func1) == -1)
                handle_error("swapcontext");
        sleep (1);
        printf("func2: returning\n");
}

int main(int argc, char *argv[])
{
        if (getcontext(&uctx_func1) == -1)
                handle_error("getcontext");
        uctx_func1.uc_stack.ss_sp = func1_stack;
        uctx_func1.uc_stack.ss_size = sizeof(func1_stack);
        uctx_func1.uc_link = &uctx_main;
        makecontext(&uctx_func1, func1, 0);

        if (getcontext(&uctx_func2) == -1)
                handle_error("getcontext");
        uctx_func2.uc_stack.ss_sp = func2_stack;
        uctx_func2.uc_stack.ss_size = sizeof(func2_stack);
        /* Successor context is f1(), unless argc > 1 */
        uctx_func2.uc_link = (argc > 1) ? NULL : &uctx_func1;
        makecontext(&uctx_func2, func2, 0);

        printf("main: swapcontext(&uctx_main, &uctx_func2)\n");
        if (swapcontext(&uctx_main, &uctx_func2) == -1)
                handle_error("swapcontext");

        printf("main: exiting\n");
        exit(EXIT_SUCCESS);
}


$./a.out
$ cat /proc/$(pgrep a.out)/maps

00400000-00401000 r-xp 00000000 fd:00 1704114
  /tmp/a.out
00601000-00602000 rw-p 00001000 fd:00 1704114
  /tmp/a.out
00602000-0060a000 rw-p 00000000 00:00 0
  [stack:7352]
7fac662d2000-7fac6647e000 r-xp 00000000 fd:00 524922
  /usr/lib64/libc-2.15.so
7fac6647e000-7fac6667e000 ---p 001ac000 fd:00 524922
  /usr/lib64/libc-2.15.so
7fac6667e000-7fac66682000 r--p 001ac000 fd:00 524922
  /usr/lib64/libc-2.15.so
7fac66682000-7fac66684000 rw-p 001b0000 fd:00 524922
  /usr/lib64/libc-2.15.so
7fac66684000-7fac66689000 rw-p 00000000 00:00 0
7fac66689000-7fac666a9000 r-xp 00000000 fd:00 524913
  /usr/lib64/ld-2.15.so
7fac6688f000-7fac66892000 rw-p 00000000 00:00 0
7fac668a6000-7fac668a8000 rw-p 00000000 00:00 0
7fac668a8000-7fac668a9000 r--p 0001f000 fd:00 524913
  /usr/lib64/ld-2.15.so
7fac668a9000-7fac668aa000 rw-p 00020000 fd:00 524913
  /usr/lib64/ld-2.15.so
7fac668aa000-7fac668ab000 rw-p 00000000 00:00 0
7fff5b8a8000-7fff5b8ca000 rw-p 00000000 00:00 0
7fff5b9fe000-7fff5ba00000 r-xp 00000000 00:00 0                          [vdso]
ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0
  [vsyscall]


--
http://siddhesh.in
