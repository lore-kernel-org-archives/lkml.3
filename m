Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbaIHHRW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 03:17:22 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43421 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbaIHHRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 03:17:21 -0400
Date: Mon, 8 Sep 2014 09:17:12 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com
Subject: Re: [PATCH v4 04/22] perf: Add a capability for AUX_NO_SG pmus to do
 software double buffering
Message-ID: <20140908071712.GT19379@twins.programming.kicks-ass.net>
References: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1408538179-792-5-git-send-email-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hyYNmTt1S+8ZKAs8"
Content-Disposition: inline
In-Reply-To: <1408538179-792-5-git-send-email-alexander.shishkin@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hyYNmTt1S+8ZKAs8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2014 at 03:36:01PM +0300, Alexander Shishkin wrote:
> For pmus that don't support scatter-gather for AUX data in hardware, it
> might still make sense to implement software double buffering to avoid
> losing data while the user is reading data out. For this purpose, add
> a pmu capability that guarantees multiple high-order chunks for AUX buffe=
r,
> so that the pmu driver can do switchover tricks.

Please expand this with more detail on how to use this.

> Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> ---
>  include/linux/perf_event.h  |  1 +
>  kernel/events/ring_buffer.c | 15 ++++++++++++++-
>  2 files changed, 15 insertions(+), 1 deletion(-)
>=20
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index fe10bf6f94..1e7b659b49 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -172,6 +172,7 @@ struct perf_event;
>   */
>  #define PERF_PMU_CAP_NO_INTERRUPT		0x01
>  #define PERF_PMU_CAP_AUX_NO_SG			0x02
> +#define PERF_PMU_CAP_AUX_SW_DOUBLEBUF		0x04
> =20
>  /**
>   * struct pmu - generic performance monitoring unit
> diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
> index d10919ca42..f5ee3669f8 100644
> --- a/kernel/events/ring_buffer.c
> +++ b/kernel/events/ring_buffer.c
> @@ -286,9 +286,22 @@ int rb_alloc_aux(struct ring_buffer *rb, struct perf=
_event *event,
>  	if (!has_aux(event))
>  		return -ENOTSUPP;
> =20
> -	if (event->pmu->capabilities & PERF_PMU_CAP_AUX_NO_SG)
> +	if (event->pmu->capabilities & PERF_PMU_CAP_AUX_NO_SG) {
>  		order =3D get_order(nr_pages * PAGE_SIZE);
> =20
> +		/*
> +		 * PMU requests more than one contiguous chunks of memory
> +		 * for SW double buffering
> +		 */
> +		if ((event->pmu->capabilities & PERF_PMU_CAP_AUX_SW_DOUBLEBUF) &&
> +		    !overwrite) {
> +			if (!order)
> +				return -EINVAL;
> +
> +			order--;
> +		}
> +	}

In particular this looks like it will allocate double the total amount
of pages and 'loose' half of them. There is no corresponding code in the
free path to collect them.


--hyYNmTt1S+8ZKAs8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUDVf4AAoJEHZH4aRLwOS67DsQAKO8Tv0E/GnoWhCfvB/+AgJO
4Sd5ng461RW49oDmidbYlEKeVEIi8vYZiYwbG3XBWGhqfnQHw8WG/7lDEY8zj+hz
/4+z1VldDoMCbxHw2LVUhz9xc9g/CPItxLmeKa+d9d+2bGrUXKz+IowoI8G94hjt
j150o4uv6KExWBSfb1Nat6l532N+JxhDODCZgdM9uMxOg8jpXf/qppebwsWb1H1Q
F6hoB9ZfkHzX8T30C9ZrblmWiDA6BnYj9TC+8+SMknkEpfkcgGUoAdVepaSzdaiS
ud0DgMxgkwv62Wy9EpM0/8hGVvd5l+4byKMY1sJ93MZtkZpf6JCIYI1EpUo787ys
xBRKnqmmrlxqpuGr1gvzOiQ/ucW6bxqbk0bByTnbYyfu+VvoBZp4a9DyCq/pfjB5
E4wt1BXVKfaz1mG/PrYykB9JC8LbgrCRmn/bdMSFI8HyN5+HB1DscYGu8kP/YOxo
qgs9dL6pLmpMFDTp8q7MxjJzDLGfsm/+eIanaLRmTC/THN+UsaJ8AgDbGAUpRwhy
KNmOvU4B5eZ2Dfj0i0Hu6z5fHi8Vl/99pOPKETVgtqQg0bkUsEaroX9DVKt0t9Vg
IJX9Eb9G6WFuWdBUegyTt9vf+I0Ux2c8NBKEHc75ybggo9UUHonVqI2L8YQD1v46
iFzTcBMTjFoKBsu0QNb+
=tSBC
-----END PGP SIGNATURE-----

--hyYNmTt1S+8ZKAs8--
