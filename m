Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501AbaEPIEj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 04:04:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:37108 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756226AbaEPIEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 04:04:30 -0400
Date: Fri, 16 May 2014 10:04:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ben Segall <bsegall@google.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: fix exec_start/task_hot on migrated tasks
Message-ID: <20140516080424.GM11096@twins.programming.kicks-ass.net>
References: <20140515225920.7179.13924.stgit@sword-of-the-dawn.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w5nY8nmEklXMR7Cj"
Content-Disposition: inline
In-Reply-To: <20140515225920.7179.13924.stgit@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--w5nY8nmEklXMR7Cj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 15, 2014 at 03:59:20PM -0700, Ben Segall wrote:
> task_hot checks exec_start on any runnable task, but if it has been
> migrated since the it last ran, then exec_start is a clock_task from
> another cpu. If the old cpu's clock_task was sufficiently far ahead of
> this cpu's then the task will not be considered for another migration
> until it has run. Instead reset exec_start whenever a task is migrated,
> since it is presumably no longer hot anyway.
>=20
> Signed-off-by: Ben Segall <bsegall@google.com>
> ---
>  kernel/sched/fair.c |    3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 28ccf50..9f8dfeb 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4544,6 +4544,9 @@ migrate_task_rq_fair(struct task_struct *p, int nex=
t_cpu)
>  		atomic_long_add(se->avg.load_avg_contrib,
>  						&cfs_rq->removed_load);
>  	}
> +
> +	/* We have migrated, no longer consider this task hot */
> +	se.exec_start =3D 0;
>  }

0 isn't strictly the right thing to do here, since the clock can wrap,
but being wrong every ~585 years isn't too big an issue for this.

Thanks!

--w5nY8nmEklXMR7Cj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdcaIAAoJEHZH4aRLwOS6Qt8P/2N6ObfDOgw0rcsARKeID+kM
YDFX5W4ymgj33lvFF7cgNnfDPFgwt/IH7t0qMkYjywYmUfr9pizF5cC6p5IcnNZ+
85xvtntzv0Ck9KtpOCIU2y7lHugYc8x/qbEe2gWNIHNoJ30OMLRihL6AaEkhu/wM
P/iDk1YmQ9YYk/3chIuEqCLWjpFCI/2W82PdwBmB8PUDs2frSAjFGCN41yCIlW1s
qaJcSnya5RXR1M3DsTawtaVlXOIJg+1Dof3RnO6/o7iw6ZmeWEvLrsQLArCx2gI+
aOszgtf7nHYRuKSkNQiSE7LEWQB4bhtix7YHEs8fDHeYx/Dg46bHxKu0gAOJyCtP
fjYQjLCGbhJ1O/qyftaaMHwPFBjEyS6D6CwqWtBDbYaP17SP9X4bCrxxqVo63CwI
8ku0aejv1s7BOM/lm9qyFwpr4g8mdw6D8DJMliAZY2o7bwXa83tjfeo0/y9TWjf5
At3uuoIKocNurr/pYK38oi1FZCFCRSw9aMFhTo6T27hkIu9um54cOELcOlSlygGp
RaZfNiZGW7w49SZJtLGYht6c/P3r+FJvDHq5/BZZWDx6wS8YePWL7fRhpOGyvvk5
V2unC7dsNFQRIJlkvEBN6F9WblItLZbhd4xIvCrp672Gg0C6nolCwf+4cKhlFXCX
Nx+pufgKyMfNU0TZ7esy
=iSl6
-----END PGP SIGNATURE-----

--w5nY8nmEklXMR7Cj--
