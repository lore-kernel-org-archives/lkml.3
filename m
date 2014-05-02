Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbaEBLwO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 07:52:14 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:57758 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbaEBLwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 07:52:13 -0400
Date: Fri, 2 May 2014 13:52:01 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [rfc][patch] perf,tools: Remove test_attr_* muck from perf.h
Message-ID: <20140502115201.GI30445@twins.programming.kicks-ass.net>
References: <20140501082729.GM11096@twins.programming.kicks-ass.net>
 <20140501183505.GA2317@krava.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
In-Reply-To: <20140501183505.GA2317@krava.redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 01, 2014 at 08:35:05PM +0200, Jiri Olsa wrote:
> On Thu, May 01, 2014 at 10:27:30AM +0200, Peter Zijlstra wrote:
> > Hi,
> >=20
> > I occasionally build the odd program against raw perf and use perf.h for
> > this.
> >=20
> > Now I find that no longer works because of:
> >=20
> > 52502bf201a85 ("perf tests: Add framework for automated perf_event_attr=
 tests")
> >=20
> > So revert the hunk touching on perf.h.
>=20
> But but but, then you'll brake attr tests
>=20
> >=20
> > Also, it seems to be for snake shit only, and snakes stink, except on a
> > plane :-)
>=20
> wanna get to lwn quotes page, huh? ;)
>=20
> any details about the breakage? maybe we could find some
> way to make you happy and keep the snake shit in place

linux-2.6/tools/perf# gcc -o perf_bug perf_bug.c
/tmp/cclObJsz.o: In function `sys_perf_event_open':
perf_bug.c:(.text+0x48): undefined reference to `test_attr__enabled'
perf_bug.c:(.text+0x72): undefined reference to `test_attr__open'
collect2: error: ld returned 1 exit status

Initially perf.h was meant to have just the syscall wrapper and few
system level defines (like the membars etc..)

But now its grown all kinds of gunk outside of that.

So ideally we'd split the thing into two files, one which is a
stand-alone syscall wrapper + system utils things and one which includes
the former and adds all the perf (tool, not kernel) gunk on.

I see all sorts of extern perf_{host,guest} things and util/target.h
includes.. that all should definitely move elsewhere.

---
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/mman.h>
#include <signal.h>
#include <unistd.h>
#include <stdio.h>
#include "perf.h"

struct perf_event_attr perf_attr =3D {
	.type =3D PERF_TYPE_SOFTWARE,
	.config =3D PERF_COUNT_SW_EMULATION_FAULTS,
	.sample_period =3D 0,
	.inherit =3D 1,
};

int main(void)
{
	void *page;
	pid_t pid;
	int fd[16];

	fd[0] =3D sys_perf_event_open(&perf_attr, 0, -1, -1, 0);
	if (fd[0] < 0) {
		perror("sys_perf_event_open 0");
		return 0;
	}

	perf_attr.inherit =3D 0;

	fd[1] =3D sys_perf_event_open(&perf_attr, 0, -1, fd[0], 0);
	if (fd[1] < 0) {
		perror("sys_perf_event_open 1");
		return 0;
	}

	page =3D mmap(NULL, 3*4096, PROT_READ|PROT_WRITE, MAP_SHARED, fd[1], 0);
	if (page =3D=3D ((void *)-1)) {
		perror("mmap");
		return 0;
	}

	pid =3D fork();
	if (!pid) {
		/* child */
		while (1) ;
		return 0;
	}
	usleep(500000);

	munmap(page, 3*4096);

	close(fd[1]);
	kill(pid, SIGTERM);
	waitpid(pid, NULL, 0);

	return 0;
}

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTY4bUAAoJEHZH4aRLwOS6TDkP/2PNJtlFOIaF29cE13S2cAd5
BAgBRjf8mAU6I9GhI6sDit1uMJbpRFrwYgycQT0TBs7CAlnrj26HfyqGYSc/UoU8
1qJxupC0ovSlU+kBejefZuWp0ftbDYiHDYP++OYLRWdMSWo+IvEgOD7uCJzZc/tV
SUyMJIhaiyK7FO9r0uhihcT9p8wPKDQCKnzF1tEG+CB47sa8MMP/SqmXuHgWPcCB
d/Ohod9LzRrCq2sacXMzuKEmfk0lLE38dhtCPY+P5hgueG5uVfmy1xyRrYxIPTwS
tojdhebxzSSa1BsDo4LrGT9SjbkhSJSCj02XSaO/stmt1VbYzoK2kmzgbW+4q7p+
0K7k2aZ/IVUzXrg96KUaQlWHdVMCCiUUAhK31JEMkaFRvqfjEpfm1Pr63vsS2clU
1+j6QZrF2nlkJDx4x54g/C8wH+rZf0PUqQ6Qf/pwS1OyWLIbnfCtORengImJqvOb
OyMaLNbH73UqKENDSXfNJ6I37I9AadDNCnhR9NLPOSlUA14jIs8ECuElQUpsK9uh
ptAbuJ2b8dEYB4rbXzcLSv09wl4O2WrpUBmXzPKUNzEsy8KsGHiEqUHboGkeGiSt
Hp3kMDBafXIQqz93MwegX/HCPhpZYjiu2rbWLjAgP9DJ4Q5vkfE567V9ZL05xFJB
HYpeTLPF9ZoGAIQxnpl8
=tHov
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
