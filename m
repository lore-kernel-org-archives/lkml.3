Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbaANWNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 17:13:19 -0500
Received: from mout.gmx.net ([212.227.15.15]:52126 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637AbaANWNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 17:13:16 -0500
Message-ID: <52D5B67A.8080900@gmx.de>
Date: Tue, 14 Jan 2014 23:13:14 +0100
From: =?ISO-8859-1?Q?Dirk_B=E4chle?= <tshortik@gmx.de>
Reply-To: dl9obn@darc.de
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: performance: spawning (exec*/wait) shows non-constant time if memory
 grows
Content-Type: multipart/mixed;
 boundary="------------030407080707090805060005"
X-Provags-ID: V03:K0:j+/2jtdfHf9UNQbjxytQ/76YVTz9ZvzWZxJ/0jBT1/4W24QQXw7
 xgEL8yBkLcA667cAJMjoefX9pl1F745nHjV7vEUB2nmWW43ihVNC7FyYe3iFt7eaHLtp71h
 QKuJShM+hshpMZCVqfIVcmNdkxaCY3t96jLLLWLtvzjG7TMVnOQXYc+34G9QqaxvAYFlicL
 KK05xwCN1lI4hy8XAQuXA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030407080707090805060005
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi there,

when running the attached program "spawn_test.c" on my machine (see end
of this mail), I get the following results (as measured with
"/usr/bin/time"):

cycles | elapsed time
---------------------

  2000  | 0:01.69
  4000  | 0:04.04
  8000  | 0:10.72
16000  | 0:32.51
32000  | 1:46.85

, indicating that the runtime increases non-linearly. An "strace" for the
program shows that single "execve/wait" calls are requiring more and more
time, when the total memory usage for the program goes up.
Note how the processes don't run in parallel, but are started one after
the other in the single "cycles"...
By setting the define USE_EXECUTE to "0", one can confirm that it's indeed
the wait call (and not the execlp) that grows in time.
As you can see in the source file, I also used "ptrace" to find out whether
it's the number of actual instructions that increases:

cycles | instructions
---------------------

  4000  |  806848773
  8000  | 1613697249

So the number of machine instructions scales linearly, hence it appears 
to be
more of a timing/locking/scheduling problem to me.
During my runs, the total process never consumed more than 10% of the
available RAM in the system. That's why I'm currently not looking in
the area of memory management (fragmentation?).

I tried to understand the code of "do_wait" in kernel/exit.c
(v3.2.0 sources), but am a bit lost as to where and how to continue my
debugging.

Here are my questions:

- Can someone reproduce my results on his side?
- What's the reason for this behaviour, is it known already or even
   expected?
- Are there any kernel parameters/settings that influence it, and could
   possibly be tweaked? How can the time performance be improved?
- Are the timing outputs of "strace" reliable under the given
   circumstances, or do I have to debug this differently?

Thanks a lot in advance for your answers. Please CC me directly, I'm
not subscribed to this list.
I'd really appreciate any pointers on how to debug this further,
where to look in the sources, what additional docs to read...or anything
else I could try. It'd be even more awesome if a kernel developer, with
the necessary experience under his belt, could take it from here and
find out what's going on.

ad STFW: I searched the LKML archives, http://lwn.net/Kernel/Index and
the web for keywords like "exec, wait, performance, futex, hash, table"
(in various combinations) and found the discussion at
https://lkml.org/lkml/2013/11/23/15.
I also tried to grasp the source of "futex.c", but I don't know enough
about the kernel to tell whether the above problem is related to futexes
or not.
I couldn't find any reports or discussions about performance problems
related to exec*/wait, combined with growing memory usage.


Best regards,

Dirk Baechle


P.S.: This is not a toy project. What's actually behind it are my
profilings for the build system SCons (www.scons.org)...please visit
http://scons.org/wiki/WhySconsIsNotSlow to find out more.
I'm trying to improve its performance, for which the
above problem seems to be the key.

P.P.S.: Some data about my machine...

OS       = Ubuntu 12.04.4 LTS
CPU      = 2x Intel(R) Core(TM)2 Duo CPU E8300 @ 2.83GHz
RAM      = 2GB
uname -a = Linux ubuntu 3.2.0-58-generic #88-Ubuntu SMP
            Tue Dec 3 17:37:58 UTC 2013
            x86_64 x86_64 x86_64 GNU/Linux


--------------030407080707090805060005
Content-Type: text/x-csrc;
 name="spawn_test.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="spawn_test.c"

/*

   Usage: spawn_test [#processes to create]

   Default is the current maximum of 32000 processes...

 Inspired by Trevor Highland (http://blog.melski.net/2013/12/11/update-scons-is-still-really-slow/),
 this little program spawns single processes in quick succession. 
 By allocating more and more memory at the same time, the runtimes for the single
 process calls seem to grow.
 Checking the output of "strace -o out.txt -r -f -s 256 spawn_test", the method
 wait() in the Kernel appears to be responsible for this behaviour.
*/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

/* Activates the counting of machine instructions via ptrace().
 All code and comments for the following USE_PTRACE parts were
 copied from http://www.tldp.org/LDP/LGNET/81/sandeep.html .
*/
#define USE_PTRACE 0

#if USE_PTRACE == 1
#include <signal.h>
#include <syscall.h>
#include <sys/ptrace.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <errno.h>
#endif

/* the maximum number of cycles (=processes to create) possible */
#define MAXCYCLES 32000
/* length of a single "dummy" signature (total_mem = SIGLEN*cycles) */
#define SIGLEN 20000

/* set to 0 or 1, 0=simple sleep, 1=exec */
#define USE_EXECUTE 1

int main(int argc, char **argv)
{
    int cnt = 0;             /* simple counter for the current cycle */
    int cycles = MAXCYCLES;  /* number of cycles (=processes to create) */
    char echo_arg[100];      /* current argument for the echo command/process */
    char *m_list[MAXCYCLES]; /* list where we hold the allocated "dummy" signatures */
    pid_t child_pid;         /* pid of created child process */
    int child_status;        /* gets the child's status for the wait() */
#if USE_PTRACE == 1
    long long counter = 0;   /*  machine instruction counter */
#endif

    /* try to read the number of cycles from the command line */
    if (argc > 1) {
        cycles = atoi(argv[1]);
        if (cycles > MAXCYCLES) {
            cycles = MAXCYCLES;
            printf("Warning: setting number of cycles to internal maximum of %d!", MAXCYCLES);
        }
    }

    /* create processes and continually allocate memory */
    printf("Starting %d cycles...\n", cycles);
    for (; cnt < cycles; ++cnt) {
        sprintf(echo_arg, "%d/%d (%.2f%%)", cnt, cycles, ((double) cnt)*100.0/((double) cycles));

        printf("%s\n", echo_arg);
        child_pid = fork();
        if (child_pid == 0) {
            /* This is done by the child process. */
#if USE_PTRACE == 1
            ptrace(PTRACE_TRACEME, 0, 0, 0);
#endif
#if USE_EXECUTE == 1
            execlp("echo", echo_arg, NULL);

            /* If execlp returns, it must have failed. */
            printf("Unknown command\n");
#else
            sleep(0.01);
#endif
            exit(0);
        } else {
           /* This is run by the parent.  Wait for the child
              to terminate. */
#if USE_PTRACE == 1
            wait(&child_status); 
            /*   
             *   parent waits for child to stop at next 
             *   instruction (execl()) 
             */
            while (child_status == 1407 ) {
                    counter++;
                    if (ptrace(PTRACE_SINGLESTEP, child_pid, 0, 0) != 0)
                            perror("ptrace");
                    /* 
                     *   switch to singlestep tracing and 
                     *   release child
                     *   if unable call error.
                     */
                    wait(&child_status);
                    /*   wait for next instruction to complete  */
            }
            /*
             * continue to stop, wait and release until
             * the child is finished; wait_val != 1407
             * Low=0177L and High=05 (SIGTRAP)
             */
#else
           while (wait(&child_status) != child_pid)
               ;
#endif

        }
        /* get a new piece of memory, as if we'd be collecting build infos */
        m_list[cnt] = malloc(SIGLEN*sizeof(char));
        strcpy(m_list[cnt], echo_arg);
    }

    printf("Done.\n");
#if USE_PTRACE == 1
    printf("Number of machine instructions : %lld\n", counter);
#endif
}


--------------030407080707090805060005--
