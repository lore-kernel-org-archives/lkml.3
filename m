Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561AbaKVLgf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 06:36:35 -0500
Received: from mout.gmx.net ([212.227.17.21]:55573 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbaKVLgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 06:36:33 -0500
Message-ID: <54707352.8050208@gmx.de>
Date: Sat, 22 Nov 2014 12:28:18 +0100
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>
CC: Michael Kerrisk <mtk.manpages@gmail.com>,
        linux-man <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: getrandom.2: treatment of interrupts
References: <CAKgNAkj_Bs7d=YV_CFLNHuJacbp_+Kk_Jux_FdiBSuUAsObA=Q@mail.gmail.com> <1415722798-4894-1-git-send-email-xypron.glpk@gmx.de> <CAKgNAkgVUeekKZjyTsjWgkXfv_u72T_ms7qofSJ_omqhfExfCw@mail.gmail.com>
In-Reply-To: <CAKgNAkgVUeekKZjyTsjWgkXfv_u72T_ms7qofSJ_omqhfExfCw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:u5Kki6WVuwpWgO/I3E9OOgb656Hi7pq7UuGqieIe+8QAhxSgtPm
 cBsQqa9DZdWjlK2fj33p3bI3pv+slbSG10HoXyeQS0u4kWUDk/tdbe1x1RuCcJMoXhGeigq
 woQhNRn+7zewAIUGTiXg/DWexUK3txrHhoztunDLNHiVg8orvtRCr9WWMCHhA6/Mi9JFcEl
 6GOuQL10vQKLgA0o6dqkg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Theodore,

I created the test program below.

While running it I issued
kill -SIGUSR1 <pid>
and
kill -SIGUSR2 <pid>

What I found was rather strange.

No matter whether specifying GRND_NONBLOCK or not, signals do not 
interrupt the execution of getrandom() while reading from the 
/dev/urandom pool.

Only after getrandom has finished signals are handled.

I would have expected getrandom() to react to interrupts immediately and 
to return whatever number of random bytes have been collected before the 
interrupt.

A system call not reacting to interrupts for several seconds looks like 
a bug to me.

Tested on Linux 3.18.0-rc4 mips64.

Best regards

Heinrich Schuchardt



#define _GNU_SOURCE
#include <errno.h>
#include <linux/unistd.h>
#include <linux/random.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/syscall.h>
#include <sys/types.h>

#if _MIPS_SIM == _MIPS_SIM_ABI32
#define __NR_getrandom                  (__NR_Linux + 353)
#endif /* _MIPS_SIM == _MIPS_SIM_ABI32 */

#if _MIPS_SIM == _MIPS_SIM_ABI64
#define __NR_getrandom                  (__NR_Linux + 313)
#endif /* _MIPS_SIM == _MIPS_SIM_ABI64 */

#if _MIPS_SIM == _MIPS_SIM_NABI32
#define __NR_getrandom                  (__NR_Linux + 317)
#endif /* _MIPS_SIM == _MIPS_SIM_NABI32 */

#ifdef __i386__
#define __NR_getrandom                  (355)
#endif /* __i386__ */

#ifdef __x86_64__
#define __NR_getrandom                  (318)
#endif /* __x86_64__ */

#define SYS_getrandom __NR_getrandom

#define GRND_NONBLOCK   0x0001
#define GRND_RANDOM     0x0002

#define BUFLEN 0x12345678

int getrandom(void *buf, size_t buflen, unsigned int flags)
{
         return syscall(SYS_getrandom, buf, buflen, flags);
}

/**
  * Handles signal.
  *
  * @param sig signal
  */


int do_print = 0;

static void hdl(int sig)
{
         if (sig == SIGUSR1) {
                 fprintf(stderr, "Main received SIGUSR1\n");
                 do_print = 1;
         }
}

int
main(int argc, char *argv[])
{

         char *buf;
         size_t buflen = BUFLEN;
         int ret;
         pid_t pid;
         // action to take when signal occurs
         struct sigaction act;
         // signal mask
         sigset_t blockset;


         pid = getpid();

         printf("PID = %u\n", pid);

         printf("__NR_getrandom = %u\n", __NR_getrandom);

         // Set handler for SIGUSR1
         act.sa_handler = hdl;
         sigemptyset(&act.sa_mask);
         act.sa_flags = 0;
         if (sigaction(SIGUSR1, &act, NULL)) {
                 perror("sigaction");
                 exit(EXIT_FAILURE);
         }

         buf = (char *) malloc(buflen);
         if (buf == NULL) {
                 perror("malloc");
                 exit(EXIT_FAILURE);
         }

         buf = (char *) malloc(buflen);

         for (;;) {
                 ret = getrandom(buf, buflen, GRND_NONBLOCK);
                 if (ret == -1) {
                         fprintf(stderr, "errno = %d\n", errno);
                         perror("getrandom");
                         exit(EXIT_FAILURE);
                 }
                 if (do_print) {
                         do_print = 0;
                         printf("ret = %d\n", ret);
                 }

         }
         printf("ret = %d\n", ret);

         free(buf);

         return EXIT_SUCCESS;
}

