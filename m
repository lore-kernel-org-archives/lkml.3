Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbaENKOH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 06:14:07 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37739 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665AbaENKOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 06:14:04 -0400
Date: Wed, 14 May 2014 12:13:54 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Michael wang <wangyun@linux.vnet.ibm.com>,
        "ktkhai@parallels.com" <ktkhai@parallels.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched: hang in migrate_swap
Message-ID: <20140514101354.GI30445@twins.programming.kicks-ass.net>
References: <20140224071028.GW9987@twins.programming.kicks-ass.net>
 <530B1B80.4000307@linux.vnet.ibm.com>
 <20140224121218.GR15586@twins.programming.kicks-ass.net>
 <534610A4.5000302@oracle.com>
 <53464164.5030701@linux.vnet.ibm.com>
 <336561397137116@web27h.yandex.ru>
 <5347FCED.8040706@oracle.com>
 <1442521397229373@web20m.yandex.ru>
 <53711785.5010504@oracle.com>
 <2614131400060552@web30m.yandex.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+luzzTK7BKd/hj/D"
Content-Disposition: inline
In-Reply-To: <2614131400060552@web30m.yandex.ru>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+luzzTK7BKd/hj/D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2014 at 01:42:32PM +0400, Kirill Tkhai wrote:
> Peter, do we have to queue stop works orderly?
>=20
> Is there is not a possibility, when two pair of works queued different on
> different cpus?
>=20
>=20
>  kernel/stop_machine.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
> index b6b67ec..29e221b 100644
> --- a/kernel/stop_machine.c
> +++ b/kernel/stop_machine.c
> @@ -250,8 +250,14 @@ struct irq_cpu_stop_queue_work_info {
>  static void irq_cpu_stop_queue_work(void *arg)
>  {
>  	struct irq_cpu_stop_queue_work_info *info =3D arg;
> -	cpu_stop_queue_work(info->cpu1, info->work1);
> -	cpu_stop_queue_work(info->cpu2, info->work2);
> +
> +	if (info->cpu1 < info->cpu2) {
> +		cpu_stop_queue_work(info->cpu1, info->work1);
> +		cpu_stop_queue_work(info->cpu2, info->work2);
> +	} else {
> +		cpu_stop_queue_work(info->cpu2, info->work2);
> +		cpu_stop_queue_work(info->cpu1, info->work1);
> +	}
>  }

I'm not sure, we already send the IPI to the first cpu of the pair, so
supposing we have 4 cpus, and get 4 pairs like:

0,1 1,2 2,3 3,0

That would result in IPIs to 0, 1, 2, and 0 again, and since the IPI
function is serialized I don't immediately see a way for this to
deadlock.



--+luzzTK7BKd/hj/D
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTc0HiAAoJEHZH4aRLwOS6vz4P/A+QnJ2b7Cq7yp75XGxc8zh8
ubHjSTZgqQmA0uhR9fg78t0He3dGf52vAfBdv5V8qkpH5pL4HKNjpj20gezVbyHj
ebJu6qBWHlwUR6ptkMhL9J8IStk/fvvR8Yq3g+mh8MaqOgtCNC16Nl1R1P7Ujk/3
AVZ3jBL4/qT067l1wflBLG7W93kzPecQLTkqtr8ntEqxuXUgdft/yRWV6GckaAnN
c8yGRaXajmXikGB/5BsV9W7Q1JXtIWktlVRSPaLKaEIhjcjJpuRfupWk4ZF3Kxc5
nId7G32A5vJ3mU3kQavGQeBwDn0xFH1lhZr/V1tyXVsDW53DAQJp7Jf+e9o4ff7e
7lwtgo2TreBw4RgsJjHWdAXyiZFxe6gQiQqw57SxDDV5QLEp4LSdAUJrDR2n9Jjb
bqmKdpkvmcxIivXwppGMkIs3z91PKBbsS192naFtlMaZV8usrB8WwQv/B48EenaN
qR8GRIXuWxDF18dRG2F+G+OMBL/KeZeZ0CwimOVZgUUM71oJ77i6XDB8aYf1YGee
HeefWukW52fo8z7Gh0/AE+YQihC+iwTvd6jJDmxkj8iM2opWRreJE4J2z9LphUyW
LStJdysqnGhSHrvHJbM/DEgma+ILdvjGg0qc8Oq7cuC6usX81wXWBcpJiOgb7HAr
CANoQr+t1lVACu/D/GUf
=0vFV
-----END PGP SIGNATURE-----

--+luzzTK7BKd/hj/D--
