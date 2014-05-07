Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933449AbaEGPEM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:04:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:38491 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083AbaEGPEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:04:10 -0400
Date: Wed, 7 May 2014 17:04:04 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH v3 2/3] perf record: Propagate exit status of a command
 line workload
Message-ID: <20140507150404.GO30445@twins.programming.kicks-ass.net>
References: <1398346054-3322-1-git-send-email-namhyung@kernel.org>
 <1398346054-3322-2-git-send-email-namhyung@kernel.org>
 <20140429105654.GB1148@krava.brq.redhat.com>
 <20140429111939.GP11096@twins.programming.kicks-ass.net>
 <20140429113747.GD1148@krava.brq.redhat.com>
 <87tx9boeaf.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gm5TwAJMO0F2iVRz"
Content-Disposition: inline
In-Reply-To: <87tx9boeaf.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gm5TwAJMO0F2iVRz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 30, 2014 at 09:24:08AM +0900, Namhyung Kim wrote:
> Hi Jiri and Peter,
>=20
> On Tue, 29 Apr 2014 13:37:47 +0200, Jiri Olsa wrote:
> > On Tue, Apr 29, 2014 at 01:19:39PM +0200, Peter Zijlstra wrote:
> >> On Tue, Apr 29, 2014 at 12:56:54PM +0200, Jiri Olsa wrote:
> >> >=20
> >> >   perf_counter tools: Propagate signals properly
> >> >   commit f7b7c26e01e51fe46097e11f179dc71ce7950084
> >> >   Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >> >   Date:   Wed Jun 10 15:55:59 2009 +0200
> >> >=20
> >> > but I dont think we need to do that
> >>=20
> >> But but but, then you're re-introducing that fail again? That no good.
>=20
> FYI, it's already gone with 804f7ac78803 ("perf record: handle death by
> SIGTERM").
>=20
> >
> > well, I was trying the testcase you mentioned in the changelog
> > and it seemed to work for me.. ;-) I guess I was lucky to hit
> > the bash time window..
> >
> >   while :; do perf stat ./foo ; done
> >
> > so how does this work? bash will kill the loop if perf's wait
> > status is WIFSIGNALED?
>=20
> I'm not sure but isn't it *bash* to catch signal and terminate the
> loop?  It seems the wait status of child has no business with the loop
> termination.  Am I missing something?
>=20
>   $ cat suicide.c
>   #include <signal.h>
>  =20
>   int main(void)
>   {
>     raise(SIGTERM);
>     return 0;
>   }
>  =20

SIGTERM isn't the problem. SIGINT is. Typically when you run:

while :; do perf stat ./foo ; done

Its foo that is running, so when you press ^C, you'll SIGINT foo. foo
will then exit, perf stat will notice the exit, exit itself and because
the loop doesn't look at the return value of perf stat, simply
continues.

What I want, and fixed back then, is that if you press ^C foo
terminates, perf stat/record/etc. will finish, but then terminate with
the same signal. In that case bash finally sees the SIGINT and will in
fact terminate the loop.

try:

$ while :; do ./foo /bin/sleep 5 ; done

and try and break out using ^C

---
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/wait.h>

int main(int argc, char *argv[], char *envp[])
{
	pid_t pid =3D fork();
	if (!pid) /* child */ {
		execve(argv[1], argv+1, envp);
		perror("execve");
		return;
	}

	signal(SIGINT, SIG_IGN);
	waitpid(pid, NULL, 0);
	return 0;
}

--gm5TwAJMO0F2iVRz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTaktkAAoJEHZH4aRLwOS6QHYQAJAjpPs77TGivYHU4l1DvqSn
EG42s0xeo/SJQKqnNrNmhi9l7TpKqOeXYYXBmeFtwDFjmoBbLe8CRTeC4+yLQWSn
bU+3S1pVjFh9xw3c7uPAunYXxJ//tTAFqvDspUkJhPXg/5DacZlkQPlheX6E+hom
RwdOYiaHXbjNQ6rJTjQQCIGBNBipY0NwllGGYvr4r9BFdmbm5edgAs/LXxH4feCN
Vpvg+7xFpayX+wEP2jmIqNHcgWZRpiY+1QRX8pf33U9qVtHSLCMqqGJHAjZWF982
AlcAh7ec3n9vVUR8ZZTY579IF9FG3fLKXpF3BfdbFWwAT+Jc8RrbpF8nDmkhtfLN
TOEAFH8nPHhZL+bIcWKFjUWA3FNqFAR7fO8ywHRsYyQbA9qGHILwn8S0Tw4MAr/t
aNoFF3AUnDLBTFNG9in7/v+KjGnl2EJA8a9oJBXy4yCXDZtJOpOCsYlTF71wu2p3
RIOv72UXHoUv+hnMtPG4WxGZ4agJ+5MapATztT1T2eGxnm1VVlS/BDnIZxYXJHBR
t16+AnomWs5YeDQ8ORrPugUHXi5OqbGGZaMH5gRpzMhS1xo0sSQjGMLdgdcVVx28
EB977sazmWSWnA8NQC81sULN/1KV9K/95g44EYy7UjZMiF5Y6mYv6zRTch7LtHq4
Xxr/fI5zULMT2njEfkLQ
=JoU3
-----END PGP SIGNATURE-----

--gm5TwAJMO0F2iVRz--
