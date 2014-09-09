Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbaIIIU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 04:20:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:43370 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbaIIIU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 04:20:26 -0400
Date: Tue, 9 Sep 2014 10:20:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH v4 08/22] perf: Add AUX record
Message-ID: <20140909082017.GW19379@twins.programming.kicks-ass.net>
References: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1408538179-792-9-git-send-email-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="q/3oc0oD9fD6j6R5"
Content-Disposition: inline
In-Reply-To: <1408538179-792-9-git-send-email-alexander.shishkin@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--q/3oc0oD9fD6j6R5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2014 at 03:36:05PM +0300, Alexander Shishkin wrote:
> When there's new data in the AUX space, output a record indicating its
> offset and size and weather it was truncated to fix in the ring buffer.

This patch is too late; it should have been before the patch adding
perf_aux_output_*().

I also added acme to cc, he might have wants/needs for the data format I
suppose.

> Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> ---
>  include/uapi/linux/perf_event.h | 16 ++++++++++++++++
>  kernel/events/core.c            | 39 +++++++++++++++++++++++++++++++++++=
++++
>  kernel/events/internal.h        |  3 +++
>  kernel/events/ring_buffer.c     |  1 +
>  4 files changed, 59 insertions(+)
>=20
> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_ev=
ent.h
> index 7e0967c0f5..c022c3d756 100644
> --- a/include/uapi/linux/perf_event.h
> +++ b/include/uapi/linux/perf_event.h
> @@ -733,6 +733,22 @@ enum perf_event_type {
>  	 */
>  	PERF_RECORD_MMAP2			=3D 10,
> =20
> +	/*
> +	 * Records that new data landed in the AUX buffer part.
> +	 *
> +	 * struct {
> +	 * 	struct perf_event_header	header;
> +	 *
> +	 * 	u64				aux_offset;
> +	 * 	u64				aux_size;
> +	 *	u8				truncated;
> +	 *	u8				reserved[7];

Creative.. do we want a u64 flags instead? Is there any chance at all
we're going to fill out these other bits?

> +	 *	u64				id;
> +	 *	u64				stream_id;

You probably should have included a struct sample_id there instead.

> +	 * };
> +	 */
> +	PERF_RECORD_AUX				=3D 11,
> +
>  	PERF_RECORD_MAX,			/* non-ABI */
>  };
> =20
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 9fc9a7583b..0251983018 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -5542,6 +5542,45 @@ void perf_event_mmap(struct vm_area_struct *vma)
>  	perf_event_mmap_event(&mmap_event);
>  }
> =20
> +void perf_event_aux_event(struct perf_event *event, unsigned long head,
> +			  unsigned long size, bool truncated)
> +{
> +	struct perf_output_handle handle;
> +	struct perf_sample_data sample;
> +	struct perf_aux_event {
> +		struct perf_event_header	header;
> +		u64				offset;
> +		u64				size;
> +		u8				truncated;
> +		u8				reserved[7];
> +		u64				id;
> +		u64				stream_id;
> +	} rec =3D {
> +		.header =3D {
> +			.type =3D PERF_RECORD_AUX,
> +			.misc =3D 0,
> +			.size =3D sizeof(rec),
> +		},
> +		.offset		=3D head,
> +		.size		=3D size,
> +		.truncated	=3D truncated,
> +		.id		=3D primary_event_id(event),
> +		.stream_id	=3D event->id,
> +	};
> +	int ret;
> +
> +	perf_event_header__init_id(&rec.header, &sample, event);

Oh hey, you do actually do the struct sample_id here, so why then also
include the id/stream_id again?

> +	ret =3D perf_output_begin(&handle, event, rec.header.size);
> +
> +	if (ret)
> +		return;
> +
> +	perf_output_put(&handle, rec);
> +	perf_event__output_id_sample(event, &handle, &sample);
> +
> +	perf_output_end(&handle);
> +}

--q/3oc0oD9fD6j6R5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUDrg9AAoJEHZH4aRLwOS6zJ0QAKziBaevDO8I8rMgsXpVYMLi
XFHs3Zg4I7Zp9YkMiaetQaJ1WBPvjlHORNo0OrCsaehRP0erpZ3VWHgf5TrikvQK
4gXgVrcYYqT1wVRPZhRqUTKmS/D0csgPpjGGGFUh2r+gk58Zwt2+Cj14Bvs6Ni0u
yxHIEOBVt434KnhtxV6Y8UKxTZHtVxmv2JRmycHIuYmWAluF0qFeByGNUWgV1b2W
WAMUlMhMRVafeBfFnkSptKgMu1XplzubDz30CqQZ9QvyAIjtXoGDZ1gCVMYY4F2z
2LULAIJz3+keJt8C89s/vTV2iP2ou7B57DQW002OYcSWg8UKFGhI9xk68PC8Umcz
lm+4yR5sSk3pK7eSoBmYoQnjHZI6/14y1rWHiQ0se+rY8IeNUSRCH8XULrjg08Pz
Yk2s/IfJiPz2JnZU3gRmy3E+lidtq6/ZKXRsAVqZifthlRgJMan3GpftPkH6wmlR
5Metl6jbqsunLnnhTbkT8PI/pfmyf1klMIPUQy8mTP0Pg36BKKdEQDqmI7RkaGzv
qLlhOlYMMpzdYrr+uGno04l9F9GlmGECoe9v6ZAPg7rGCOuLgD2H6b3YZnW1r2NW
RuxROpvbz9Ot9GnWe7fz2Gfc2dGe0kc75OZ9WJ62CMKMcSB36/sOWr3EQWSynPEA
kzavdLQzTuo6HWa11Nay
=o8sY
-----END PGP SIGNATURE-----

--q/3oc0oD9fD6j6R5--
