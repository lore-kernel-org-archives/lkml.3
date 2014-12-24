Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675AbaLXWIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 17:08:22 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38830 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbaLXWIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 17:08:21 -0500
Date: Wed, 24 Dec 2014 23:08:18 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Mark Seaborn <mseaborn@chromium.org>,
        kernel list <linux-kernel@vger.kernel.org>
Cc: luto@amacapital.net
Subject: Re: DRAM unreliable under specific access patern
Message-ID: <20141224220818.GA17655@amd>
References: <CAL82V5NN8U4PyiSjLxgpTrgsgkbM7rRCbVF5P-HHyEqphLOy+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
In-Reply-To: <CAL82V5NN8U4PyiSjLxgpTrgsgkbM7rRCbVF5P-HHyEqphLOy+g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> Try this test program: https://github.com/mseaborn/rowhammer-test
> 
> It has reproduced bit flips on various machines.
> 
> Your program won't be an effective test because you're just hammering
> addresses x and x+64, which will typically be in the same row of
> DRAM.

Yep, I found out I was wrong in the meantime.

> For the test to be effective, you have to pick addresses that are in
> different rows but in the same bank.  A good way of doing that is just to
> pick random pairs of addresses (as the test program above does).  If the
> machine has 16 banks of DRAM (as many of the machines I've tested on do),
> there will be a 1/16 chance that the two addresses are in the same
> bank.

How long does it normally teake to reproduce something on the bad machine? 

> [Replying off-list just because I'm not subscribed to lkml and only saw
> this thread via the web, but feel free to reply on the list. :-) ]

Will do. (Actually, it is ok to reply to lkml even if you are not
subscribed; lkml is open list.).

In the meantime, I created test that actually uses physical memory,
8MB apart, as described in some footnote. It is attached. It should
work, but it needs boot with specific config options and specific
kernel parameters.

[Unfortunately, I don't have new-enough machine handy].

Best regards,
								Pavel
								
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

--n8g4imXOkfNTN/H1
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="disturb.c"

/* -*- linux-c -*-
 * 
 * Try to trigger DRAM disturbance errors, as described in
 *
 * https://www.ece.cmu.edu/~safari/pubs/kim-isca14.pdf
 *
 * Copyright 2014 Pavel Machek <pavel@ucw.cz>, GPLv2+.
 *
 * You need to run this on cca 2GB machine, or adjust size below. 
 * CONFIG_STRICT_DEVMEM must not be set.
 * Boot with "nopat mem=2G"
 */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/mman.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>

void disturb(char *w1, char *w2)
{
	/* As far as I could tell... this loop should be run for
	   cca 128msec, to run for one full refresh cycle. */
	
	unsigned int i;
	for (i=0; i< 672000; i++) {
		__asm__ __volatile__(
			"movl 0(%0), %%eax 		\n"	\
			"movl 0(%1), %%eax		\n"	\
			"clflush 0(%0)			\n"	\
			"clflush 0(%1)			\n"	\
			"mfence"
			:: "r" (w1), "r" (w2)
			: "eax"
			);
	}
}

int main(int argc, char *argv[])
{
	/* Ok, so we have one memory for checking, but we do need direct access
	   to /dev/mem to access physical memory.

	   /* This needs at least 2GB RAM machine */
	long size = 1*1024*1024*1024;
	long i;
	unsigned char *mem, *map;
	int fd;

	if (size & (size-1)) {
		printf("Need power of two size\n");
		return 1;
	}
	
	mem = malloc(size);
	memset(mem, 0xff, size);

	fd = open("/dev/mem", O_RDONLY);
//	fd = open("/tmp/delme", O_RDONLY);

	errno = 0;
	/* We want to avoid low 1MB */
	map = mmap(NULL, size, PROT_READ, MAP_SHARED, fd, 1*1024*1024);
	if (errno) {
		printf("Can not mmap ram: %m\n");
		return 1;
	}
	/* DRAM operates by whole cachelines, so it should not matter
	   which byte in cacheline we access.
	*/

#define MEG8 (8*1024*1024)
	
	for (i=0; i<(size-MEG8)/100; i+=4096-64)
		disturb(map+i, map+i+MEG8);

	for (i=0; i<size; i++)
		if (mem[i] != 0xff)
			printf("At %lx, got %x\n", i, mem[i]);
}

--n8g4imXOkfNTN/H1
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="disturb.c"

/* -*- linux-c -*-
 * 
 * Try to trigger DRAM disturbance errors, as described in
 *
 * https://www.ece.cmu.edu/~safari/pubs/kim-isca14.pdf
 *
 * Copyright 2014 Pavel Machek <pavel@ucw.cz>, GPLv2+.
 *
 * You need to run this on cca 2GB machine, or adjust size below. 
 * CONFIG_STRICT_DEVMEM must not be set.
 * Boot with "nopat mem=2G"
 */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/mman.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>

void disturb(char *w1, char *w2)
{
	/* As far as I could tell... this loop should be run for
	   cca 128msec, to run for one full refresh cycle. */
	
	unsigned int i;
	for (i=0; i< 672000; i++) {
		__asm__ __volatile__(
			"movl 0(%0), %%eax 		\n"	\
			"movl 0(%1), %%eax		\n"	\
			"clflush 0(%0)			\n"	\
			"clflush 0(%1)			\n"	\
			"mfence"
			:: "r" (w1), "r" (w2)
			: "eax"
			);
	}
}

int main(int argc, char *argv[])
{
	/* Ok, so we have one memory for checking, but we do need direct access
	   to /dev/mem to access physical memory.

	   /* This needs at least 2GB RAM machine */
	long size = 1*1024*1024*1024;
	long i;
	unsigned char *mem, *map;
	int fd;

	if (size & (size-1)) {
		printf("Need power of two size\n");
		return 1;
	}
	
	mem = malloc(size);
	memset(mem, 0xff, size);

	fd = open("/dev/mem", O_RDONLY);
//	fd = open("/tmp/delme", O_RDONLY);

	errno = 0;
	/* We want to avoid low 1MB */
	map = mmap(NULL, size, PROT_READ, MAP_SHARED, fd, 1*1024*1024);
	if (errno) {
		printf("Can not mmap ram: %m\n");
		return 1;
	}
	/* DRAM operates by whole cachelines, so it should not matter
	   which byte in cacheline we access.
	*/

#define MEG8 (8*1024*1024)
	
	for (i=0; i<(size-MEG8)/100; i+=4096-64)
		disturb(map+i, map+i+MEG8);

	for (i=0; i<size; i++)
		if (mem[i] != 0xff)
			printf("At %lx, got %x\n", i, mem[i]);
}

--n8g4imXOkfNTN/H1--
