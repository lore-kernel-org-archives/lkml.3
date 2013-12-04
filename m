Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab3LDJTO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 04:19:14 -0500
Received: from peace.netnation.com ([204.174.223.2]:34569 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879Ab3LDJTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 04:19:10 -0500
Date: Wed, 4 Dec 2013 01:19:03 -0800
From: Simon Kirby <sim@hostway.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Waiman Long <Waiman.Long@hp.com>, Ian Applegate <ia@cloudflare.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Christoph Lameter <cl@gentwo.org>,
        Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] mutexes: Add CONFIG_DEBUG_MUTEX_FASTPATH=y debug variant
 to debug SMP races
Message-ID: <20131204091903.GA18675@hostway.ca>
References: <CA+55aFyez7uZ6LeXrBRCqJzgJ=w4Xv+CV6QSYp5NkOJ2R9Xang@mail.gmail.com>
 <CA+55aFyhzvJrCiJOqUgL-98=MVutWePToQXaVfS2j6e5eetJSw@mail.gmail.com>
 <20131203085233.GA20179@gmail.com>
 <CA+55aFxhUYi6Lbrxfjgq7OqSDMF24wqvnGn_J_RAMY7y-AmRiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
In-Reply-To: <CA+55aFxhUYi6Lbrxfjgq7OqSDMF24wqvnGn_J_RAMY7y-AmRiQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 03, 2013 at 10:10:29AM -0800, Linus Torvalds wrote:

> On Tue, Dec 3, 2013 at 12:52 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > I'd expect such bugs to be more prominent with unlucky object
> > size/alignment: if mutex->count lies on a separate cache line from
> > mutex->wait_lock.
> 
> I doubt that makes much of a difference. It's still just "CPU cycles"
> away, and the window will be tiny unless you have multi-socket
> machines and/or are just very unlucky.
> 
> For stress-testing, it would be much better to use some hack like
> 
>     /* udelay a bit if the spinlock isn't contended */
>     if (mutex->wait_lock.ticket.head+1 == mutex->wait_lock.ticket.tail)
>         udelay(1);
> 
> in __mutex_unlock_common() just before the spin_unlock(). Make the
> window really *big*.

I haven't had a chance yet to do much testing of the proposed race fix
and race enlarging patches, but I did write a tool to reproduce the race.
I started it running and left for dinner, and sure enough, it actually
seems to work on plain 3.12 on a Dell PowerEdge r410 w/dual E5520,
reproducing "Poison overwritten" at a rate of about once every 15 minutes
(running 6 in parallel, booted with "slub_debug").

I have no idea if actually relying on tsc alignment between cores and
sockets is a reasonable idea these days, but it seems to work. I first
used a read() on a pipe close()d by the other process to synchronize
them, but this didn't seem to work as well as busy-waiting until the
timestamp counters pass a previously-decided-upon start time.

Meanwhile, I still don't understand how moving the unlock _up_ to cover
less of the code can solve the race, but I will stare at your long
explanation more tomorrow.

Simon-

--cWoXeonUoKmBZSoM
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="piperace.c"

#include <sys/wait.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#define MAX_PIPES 450
#define FORK_CYCLES 2000000
#define CLOSE_CYCLES 100000
#define STAT_SHIFT 6

static inline unsigned long readtsc()
{
	unsigned int low, high;
	asm volatile("rdtsc" : "=a" (low), "=d" (high));
	return low | ((unsigned long)(high) << 32);
}

static int pipefd[MAX_PIPES][2];

int main(int argc, char *argv[]) {
	unsigned long loop, race_start, miss;
	unsigned long misses = 0, races = 0;
	int i;
	pid_t pid;
	struct rlimit rlim = {
		.rlim_cur = MAX_PIPES * 2 + 96,
		.rlim_max = MAX_PIPES * 2 + 96,
	};

	if (setrlimit(RLIMIT_NOFILE, &rlim) != 0)
		perror("setrlimit(RLIMIT_NOFILE)");

	for (loop = 1;;loop++) {
		/*
		 * Make a bunch of pipes
		 */
		for (i = 0;i < MAX_PIPES;i++) {
			if (pipe(pipefd[i]) == -1) {
				perror("pipe()");
				exit(EXIT_FAILURE);
			}
		}

		race_start = readtsc() + FORK_CYCLES;

		asm("":::"memory");

		pid = fork();
		if (pid == -1) {
			perror("fork()");
			exit(EXIT_FAILURE);
		}
		pid = !!pid;

		/*
		 * Close one pipe descriptor per process
		 */
		for (i = 0;i < MAX_PIPES;i++)
			close(pipefd[i][!pid]);

		for (i = 0;i < MAX_PIPES;i++) {
			/*
			 * Line up and try to close at the same time
			 */
			miss = 1;
			while (readtsc() < race_start)
				miss = 0;

			close(pipefd[i][pid]);

			misses+= miss;
			race_start+= CLOSE_CYCLES;
		}
		races+= MAX_PIPES;

		if (!(loop & (~(~0UL << STAT_SHIFT))))
			fprintf(stderr, "%c %lu (%.2f%% false starts)\n",
				"CP"[pid], readtsc(), misses * 100. / races);

		if (pid)
			wait(NULL);	/* Parent */
		else
			exit(0);	/* Child */
	}
}


--cWoXeonUoKmBZSoM--
