Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbaLXRZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 12:25:09 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39201 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbaLXRZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 12:25:08 -0500
Date: Wed, 24 Dec 2014 18:25:06 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andy Lutomirski <luto@amacapital.net>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: DRAM unreliable under specific access patern
Message-ID: <20141224172506.GA23683@amd>
References: <20141224163823.GA17035@amd>
 <CALCETrW8nrKSZ800C+WaHMK4DCuWnD9TG3dYo7cZwm5j4CpNJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
In-Reply-To: <CALCETrW8nrKSZ800C+WaHMK4DCuWnD9TG3dYo7cZwm5j4CpNJQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed 2014-12-24 09:13:32, Andy Lutomirski wrote:
> On Wed, Dec 24, 2014 at 8:38 AM, Pavel Machek <pavel@ucw.cz> wrote:
> > Hi!
> >
> > It seems that it is easy to induce DRAM bit errors by doing repeated
> > reads from adjacent memory cells on common hw. Details are at
> >
> > https://www.ece.cmu.edu/~safari/pubs/kim-isca14.pdf
> >
> > . Older memory modules seem to work better, and ECC should detect
> > this. Paper has inner loop that should trigger this.
> >
> > Workarounds seem to be at hardware level, and tricky, too.
> 
> One mostly-effective solution would be to stop buying computers
> without ECC.  Unfortunately, no one seems to sell non-server chips
> that can do ECC.

Or keep using old computers :-).

> > Does anyone have implementation of detector? Any ideas how to work
> > around it in software?
> >
> 
> Platform-dependent page coloring with very strict, and impossible to
> implement fully correctly, page allocation constraints?

This seems to be at cacheline level, not at page level, if I
understand it correctly.

So the problem would is: I have something mapped read-only, and I can
still cause bitflips in it.

Hmm. So it is pretty obviously a security problem, no need for
java. Just do some bit flips in binary root is going to run, and it
will crash for him. You can map binaries read-only, so you have enough
access.

As far as I understand it, attached program could reproduce it on
affected machines?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

--6TrnltStXW4iwmi0
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="disturb.c"

/* -*- linux-c -*-
 * 
 * Try to trigger DRAM disturbance errors, as described in
 *
 * https://www.ece.cmu.edu/~safari/pubs/kim-isca14.pdf
 *
 * Copyright 2014 Pavel Machek <pavel@ucw.cz>, GPLv2+.
 */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

void disturb(char *where)
{
	unsigned int i;
	for (i=0; i<0x1000000; i++) {
		__asm__ __volatile__(
			"movl 0(%0), %%eax 		\n"	\
			"movl 64(%0), %%eax		\n"	\
			"clflush 0(%0)			\n"	\
			"clflush 64(%0)			\n"	\
			"mfence"
			:: "r" (where)
			: "eax"
			);
	}
}

int main(int argc, char *argv[])
{
	long size = 1*1024*1024;
	long i;
	unsigned char *mem;
	
	mem = malloc(size);
	memset(mem, 0xff, size);

	for (i=0; i<128; i+=4)
		disturb(mem+i);

	for (i=0; i<size; i++)
		if (mem[i] != 0xff)
			printf("At %lx, got %x\n", i, mem[i]);
}

--6TrnltStXW4iwmi0--
