Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbaEKOyZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 10:54:25 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:44421 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbaEKOyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 10:54:24 -0400
Message-ID: <536F8F0E.7020301@gmail.com>
Date: Sun, 11 May 2014 16:54:06 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mtk.manpages@gmail.com, Juri Lelli <juri.lelli@gmail.com>,
        Dario Faggioli <raistlin@linux.it>, Ingo Molnar <mingo@elte.hu>,
        lkml <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: [BUG] sched_setattr() SCHED_DEADLINE hangs system
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Dave: I wonder if there's anything trinity can add in the way of 
a test here?]

Hi Peter,

This looks like another bug in sched_setattr(). Using the program
below (which you might find generally helpful for testing), I'm 
able to reliably freeze up my x64 (Intel Core i7-3520M Processor) 
system for up to about a minute when I run with the following 
command line:

$ time sudo ./t_sched_setattr d 18446744072 18446744072 18446744073

'd' here means use SCHED_DEADLINE, then the remaining arguments
are the Runtime, Deadline, and Period, expressed in *seconds*.
(Those number by the way are just a little below 2^64.)

Aside from interpreting its command-line arguments, all that the 
program does is call sched_setattr() and displays elapsed times.
(By the way, on my system I see some weird effects for time(2), 
presumably VDSO effects.)

Here's sample run:

time sudo ./t_sched_setattr d 18446744072 18446744072 18446744073
Runtime  =      18446744072000000000
Deadline =      18446744072000000000
Period   =      18446744073000000000
About to call sched_setattr()
Successful return from sched_setattr() [6 seconds]

real	0m40.421s
user	0m3.097s
sys	0m30.804s

After unfreezing the machine is fine, while the program is running,
the machine is pretty unresponsive.

I'm on kernel 3.15-rc4.

Cheers,

Michael


=====
/*#* t_sched_setattr.c 
*/
#define _GNU_SOURCE         /* See feature_test_macros(7) */
#include <unistd.h>
#include <sys/syscall.h> 
#include <inttypes.h>
#include <sched.h>
#include <time.h>
#include <sys/types.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

struct sched_attr {
    uint32_t size;

    uint32_t sched_policy;
    uint64_t sched_flags;

    /* SCHED_NORMAL, SCHED_BATCH */
    int32_t sched_nice;

    /* SCHED_FIFO, SCHED_RR */
    uint32_t sched_priority;

    /* SCHED_DEADLINE */
    uint64_t sched_runtime;
    uint64_t sched_deadline;
    uint64_t sched_period;
};

#ifdef __x86_64__
#define __NR_sched_setattr              314
#define __NR_sched_getattr              315
#endif

#ifdef __i386__
#define __NR_sched_setattr              351
#define __NR_sched_getattr              352
#endif

#ifdef __arm__
#define __NR_sched_setattr              380
#define __NR_sched_getattr              381
#endif

#ifndef SCHED_DEADLINE
#define SCHED_DEADLINE          6
#endif

#ifndef SCHED_FLAG_RESET_ON_FORK
#define SCHED_FLAG_RESET_ON_FORK        0x01
#endif

static int
sched_setattr(pid_t pid, const struct sched_attr *attr, unsigned int flags)
{
    return syscall(__NR_sched_setattr, pid, attr, flags);
}

static void
usageError(char *pname)
{
    fprintf(stderr, "Usage:\n");
    fprintf(stderr, "    Non-realtime:\n");
    fprintf(stderr, "        %s {o|b|i} <nice>\n", pname);
    fprintf(stderr, "    Realtime:\n");
    fprintf(stderr, "        %s {f|r} <prio>\n", pname);
    fprintf(stderr, "    Deadline:\n");
    fprintf(stderr, "        %s d <runtime> <deadline> <period>\n",
            pname);
    fprintf(stderr, "               (runtime, deadline, and period are in "
                                    "seconds,\n");
    fprintf(stderr, "               unless -m or -n specified)\n");
    fprintf(stderr, "Options:\n");
    fprintf(stderr, "    -f         SCHED_FLAG_RESET_ON_FORK\n");
    fprintf(stderr, "    -m         Deadline times are in milliseconds\n");
    fprintf(stderr, "    -n         Deadline times are in nanoseconds\n");
    fprintf(stderr, "    -s size    Value for size argument\n");
    fprintf(stderr, "    -p pid     PID of target process (default "
                                    "is self)\n");
    fprintf(stderr, "    -v val     Value for unused bytes of 'attr' "
                                    "buffer\n");
    fprintf(stderr, "    -w nsecs   Sleep time (only valid when setting "
                                    "policy for self)\n");
    exit(EXIT_FAILURE);
}

int
main(int argc, char *argv[])
{
    size_t size, alloc_size;;
    int opt, flags, val;
    struct sched_attr *sa;
    pid_t pid;
    int sleepTime;
    long long timeFactor;
    time_t base;

    /* Parse command-line arguments */

    sleepTime = 0;
    pid = 0;
    flags = 0;
    size = sizeof(struct sched_attr);
    val = 0;
    timeFactor = 1000 * 1000 * 1000;


    while ((opt = getopt(argc, argv, "fmnp:s:v:w:")) != -1) {
        switch (opt) {
        case 'f': flags = SCHED_FLAG_RESET_ON_FORK;     break;
        case 'm': timeFactor = 1000 * 1000;             break;
        case 'n': timeFactor = 1;                       break;
        case 'p': pid = atoi(optarg);                   break;
        case 's': size = atoi(optarg);                  break;
        case 'v': val = atoi(optarg);                   break;
        case 'w': sleepTime = atoi(optarg);             break;
        default:  usageError(argv[1]);
        }
    }

    if (optind + 1 > argc)
        usageError(argv[0]);

    alloc_size = (size > sizeof(struct sched_attr)) ? size :
                               sizeof(struct sched_attr);
    sa = malloc(alloc_size);
    if (sa == NULL) {
        perror("malloc");
        exit(EXIT_FAILURE);
    }

    /* Initializing bytes in buffer to nonzero values allows us to test
       the E2BIG error case */

    memset(sa, val, alloc_size);

    sa->size = size;
    sa->sched_flags = flags;

    switch (argv[optind][0]) {

    case 'o':
        sa->sched_policy = SCHED_OTHER;
        sa->sched_nice = atoi(argv[optind + 1]);
        break;

    case 'b':
        sa->sched_policy = SCHED_BATCH;
        sa->sched_priority = 1;
        sa->sched_nice = atoi(argv[optind + 1]);
        break;

    case 'i':
        sa->sched_policy = SCHED_IDLE;
        sa->sched_nice = atoi(argv[optind + 1]);
        /* Yes, SCHED_IDLE doesn't use nice values, but this let's us
           test what happen if a nonzero nice value is given */
        break;

    case 'f':
        sa->sched_policy = SCHED_FIFO;
        sa->sched_priority = atoi(argv[optind + 1]);
        break;

    case 'r':
        sa->sched_policy = SCHED_RR;
        sa->sched_priority = atoi(argv[optind + 1]);
        break;

    case 'd':
        if (argc != optind + 4)
           usageError(argv[0]);
        sa->sched_policy = SCHED_DEADLINE;
        sa->sched_runtime = atoll(argv[optind + 1]) * timeFactor;
        sa->sched_deadline = atoll(argv[optind + 2]) * timeFactor;
        sa->sched_period = atoll(argv[optind + 3]) * timeFactor;
        printf("Runtime  = %25" PRIu64 "\nDeadline = %25" PRIu64
                "\nPeriod   = %25" PRIu64 "\n",
                sa->sched_runtime, sa->sched_deadline, sa->sched_period);
        break;

    default:
        usageError(argv[0]);
    }

    printf("About to call sched_setattr()\n");

    usleep(10000);

    base = time(NULL);
    if (sched_setattr(pid, sa, 0) == -1) {
        perror("sched_setattr");
        printf("sa->size = %" PRIu32 "\n", sa->size);
        exit(EXIT_FAILURE);
    }

    usleep(10000);      /* Without this small sleep, time() does not
                           seem to return an up-to-date time. Some VDSO
                           effect? */

    printf("Successful return from sched_setattr() [%ld seconds]\n",
            (long) time(NULL) - base);

    /* If we set our own scheduling policy and attributes, then we
       optionally sleep for a while, so we can inspect process
       attributes */

    if ((pid == 0 || pid == getpid()) && sleepTime > 0)
        sleep(sleepTime);

    exit(EXIT_SUCCESS);
}


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
