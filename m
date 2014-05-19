Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637AbaESI7J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 04:59:09 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:39078 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaESI7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 04:59:07 -0400
Date: Mon, 19 May 2014 10:58:54 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [RFC 2/2] perf: add AUX area to ring buffer for raw data streams
Message-ID: <20140519085854.GW30445@twins.programming.kicks-ass.net>
References: <1400166510-9234-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1400166510-9234-3-git-send-email-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z5Jh1Kjtcc8el5NM"
Content-Disposition: inline
In-Reply-To: <1400166510-9234-3-git-send-email-alexander.shishkin@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--z5Jh1Kjtcc8el5NM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 15, 2014 at 06:08:30PM +0300, Alexander Shishkin wrote:
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -252,6 +252,19 @@ struct pmu {
>  	 * flush branch stack on context-switches (needed in cpu-wide mode)
>  	 */
>  	void (*flush_branch_stack)	(void);
> +
> +	/*
> +	 * Allocate AUX space buffer: return an array of @nr_pages pages to be
> +	 * mapped to userspace that will also be passed to ->free_aux.
> +	 */
> +	void *(*alloc_aux)		(int cpu, int nr_pages, bool overwrite,
> +					 struct perf_event_mmap_page *user_page);
> +					/* optional */
> +
> +	/*
> +	 * Free AUX buffer
> +	 */
> +	void (*free_aux)		(void *aux); /* optional */
>  };

I'm not entirely thrilled to expose it to the PMU like this.. I realize
you want this in order to get physically contiguous pages.

Are you aware of allocation constraints for other architectures?

>  #define PERF_RECORD_MISC_CPUMODE_MASK		(7 << 0)
> @@ -710,6 +726,18 @@ enum perf_event_type {
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
> +	 * };
> +	 */
> +	PERF_RECORD_AUX				=3D 11,
> +
>  	PERF_RECORD_MAX,			/* non-ABI */
>  };

Ideally the patch introducing this would also introduce code to generate
these records.

> @@ -4076,7 +4090,63 @@ static int perf_mmap(struct file *file, struct vm_=
area_struct *vma)
>  		return -EINVAL;
> =20
>  	vma_size =3D vma->vm_end - vma->vm_start;
> -	nr_pages =3D (vma_size / PAGE_SIZE) - 1;
> +
> +	if (vma->vm_pgoff =3D=3D 0) {
> +		nr_pages =3D (vma_size / PAGE_SIZE) - 1;
> +	} else {
> +		/*
> +		 * AUX area mapping: if rb->aux_nr_pages !=3D 0, it's already
> +		 * mapped, all subsequent mappings should have the same size
> +		 * and offset. Must be above the normal perf buffer.
> +		 */
> +		u64 aux_offset, aux_size;
> +
> +		if (!event->rb)
> +			return -EINVAL;
> +
> +		nr_pages =3D vma_size / PAGE_SIZE;
> +
> +		mutex_lock(&event->mmap_mutex);
> +		ret =3D -EINVAL;
> +
> +		rb =3D event->rb;
> +		if (!rb)
> +			goto aux_unlock;
> +
> +		aux_offset =3D ACCESS_ONCE(rb->user_page->aux_offset);
> +		aux_size =3D ACCESS_ONCE(rb->user_page->aux_size);
> +
> +		if (aux_offset < perf_data_size(rb) + PAGE_SIZE)
> +			goto aux_unlock;
> +
> +		if (aux_offset !=3D vma->vm_pgoff << PAGE_SHIFT)
> +			goto aux_unlock;
> +
> +		/* already mapped with a different offset */
> +		if (rb_has_aux(rb) && rb->aux_pgoff !=3D vma->vm_pgoff)
> +			goto aux_unlock;
> +
> +		if (aux_size !=3D vma_size || aux_size !=3D nr_pages * PAGE_SIZE)
> +			goto aux_unlock;
> +
> +		/* already mapped with a different size */
> +		if (rb_has_aux(rb) && rb->aux_nr_pages !=3D nr_pages)
> +			goto aux_unlock;
> +
> +		if (!atomic_inc_not_zero(&rb->mmap_count))
> +			goto aux_unlock;
> +
> +		if (rb_has_aux(rb)) {
> +			atomic_inc(&rb->aux_mmap_count);
> +			ret =3D 0;
> +			goto unlock;
> +		}
> +
> +		atomic_set(&rb->aux_mmap_count, 1);
> +		user_extra =3D nr_pages;
> +
> +		goto accounting;
> +	}

That appears to be missing a is_power_of_2(aux_size) check.

The problem with not having that is that since
perf_event_mmap_page::aux_{head,tail} are of Z mod 2^64 but your actual
{head,tail} are of Z mod aux_size, you need aux_size to be a full
divider of 2^64 or otherwise you get wrapping issues at the overflow.

Having it them all 2^n makes the divider trivial.

--z5Jh1Kjtcc8el5NM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTecfOAAoJEHZH4aRLwOS6nDoP/2Pa4KYN1oQj6GzHHUtw4M47
5Ifa+H+JbMW6j1ajVTKP70bYiJM4BAp05t4l97w55pCYpurzYMwriKRx9/KyFEM6
J+8mrAHdjxVi2KRw1iDGJdVnd4+4xMDUa025ZPOlqQYyGDWIHwESUk7LHLIVPZ1z
NiFXFBfLu0AoORT7YSGCwj1xKs55HcMrL9E6mo5nV7rKxzgkGZD2yJ7LVUjI0XyV
HmJ6wmFwnfF5GCB55n/eu98+ctWK4yqMQ5eMo+PG63nCVCogpb7lDhO+tBeqIRiy
PJ654OHi0puhAot9/EQ/rBRDNpC1Si6mvX9O8NXgbiPI72S8z8aHm+r1pJIf8+ZY
kwZ9Fv7na8ThHpYwQK0dYccqzFSLEw/PtJlVDCR2VflcVTON2zUEWV3ZeSkW1+kR
8szzN7IECzqTlt3UBiFChxIQSF+osm3JbkKrhOs4tdxGEVYxAeQBQoZaPWpQYJYQ
GlC0qhbj6cbYdANIW0xvZAPYzbIqvfM88vzztKuA35q/g3XiaEEnPsR2IpW5qnXB
xRkKokV+6pLyD0aVd2J5JiagChMDUDyAEpsdzwHbtqpgvOpVQ3DdqMJnJdUzRFQN
nu3Q6YzC+kiupcFpF05lHsbEeqVBhv/Sn0u/Yrd0M/Nb7y5TMTcR1Cy5neP2p7LX
FF3cMtYQHVaPb20fA5JO
=es1j
-----END PGP SIGNATURE-----

--z5Jh1Kjtcc8el5NM--
