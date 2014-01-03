Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbaACCo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 21:44:56 -0500
Received: from mga01.intel.com ([192.55.52.88]:55302 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbaACCoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 21:44:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,595,1384329600"; 
   d="asc'?scan'208";a="459385205"
Date: Thu, 2 Jan 2014 21:25:24 -0500
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Michel Lespinasse <walken@google.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@Intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Janet Morgan <janet.morgan@Intel.com>, Tony Luck <tony.luck@Intel.com>,
        Ruiv Wang <ruiv.wang@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, x86@kernel.org
Subject: Re: [PATCH] x86: Add check for number of available vectors before
 CPU down [v4]
Message-ID: <20140103022524.GB1913@gchen.bj.intel.com>
Mail-Followup-To: Prarit Bhargava <prarit@redhat.com>,
	linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
	Michel Lespinasse <walken@google.com>,
	Seiji Aguchi <seiji.aguchi@hds.com>,
	Yang Zhang <yang.z.zhang@Intel.com>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	Janet Morgan <janet.morgan@Intel.com>,
	Tony Luck <tony.luck@Intel.com>, Ruiv Wang <ruiv.wang@gmail.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>, x86@kernel.org
References: <1388710044-8280-1-git-send-email-prarit@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="A6N2fC+uXW/VQSAv"
Content-Disposition: inline
In-Reply-To: <1388710044-8280-1-git-send-email-prarit@redhat.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--A6N2fC+uXW/VQSAv
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Add some nitpicks below.

Reviewed-by: Chen, Gong <gong.chen@linux.intel.com>

On Thu, Jan 02, 2014 at 07:47:24PM -0500, Prarit Bhargava wrote:
> +int check_irq_vectors_for_cpu_disable(void)
> +{
> +	int irq, cpu;
> +	unsigned int vector, this_count, count;
> +	struct irq_desc *desc;
> +	struct irq_data *data;
> +	struct cpumask affinity_new, online_new;
> +
> +	cpumask_copy(&online_new, cpu_online_mask);
> +	cpu_clear(smp_processor_id(), online_new);
I notice that you use smp_processor_id() many times. Maybe we can
save it first for speed.

> +
> +	this_count = 0;
> +	for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
> +		irq = __this_cpu_read(vector_irq[vector]);
> +		if (irq >= 0) {
> +			desc = irq_to_desc(irq);
> +			data = irq_desc_get_irq_data(desc);
> +			cpumask_copy(&affinity_new, data->affinity);
> +			cpu_clear(smp_processor_id(), affinity_new);
> +			/*
> +			 * Only count active non-percpu irqs, and those
> +			 * irqs that are not linked to on an online cpu; in
> +			 * fixup_irqs(), chip->irq_set_affinity() will be
> +			 * called which will set vector_irq[irq] for each
> +			 * cpu.
> +			 */
> +			if (irq_has_action(irq) && !irqd_is_per_cpu(data) &&
> +			    (cpumask_empty(&affinity_new) ||
> +			     !cpumask_subset(&affinity_new, &online_new)))
> +				this_count++;
Would you please add some extra comments to describe these two different
conditions that cpumask is empty and non-empty. I feel it is a little bit
sutble and I don't expect I'm confused by myself one day :-).


--A6N2fC+uXW/VQSAv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSxh+UAAoJEI01n1+kOSLHFTwQAKBUcmSoGh9H14nHIoXOQ14o
N0+XtgbE3wfoUHVK45bdzRg3kMwBfci2qkfs6RePMtbTJgKf+yp8lW9UERonsOjt
K/78Thae5zJCMr29Oq4oZNN2zIz4tTCXEZyz1dgJLRRUPcvmNCWZDrefSMQaHLaS
PI3d8Wl3m8nIosbdVzSl4LQYp/I8gexb7j9HgrVLobgGu+rasZkUnbzq3ownc1/W
X+xB/18QO7pTTJO5mvfeqvdWQMpXv2PxUjYA9qfL4hyddUpLoiV/QZNfAZRRpyZi
D6oRU7XqxnoGovAECoK9UpqClrHUK4vVRulFi0WRdE+Qj1WrVzkmbxJwLquzEd16
E5sfSR2Uuu6enJbq3Tn8MWBmo+BYDa587c0st4PyN4aZqRrcjCwb2drkdfAQTYyp
U6X4hMxVjnGPEtRAwfzrG2kMhpULJ9QeqY+8Ixv9UBPQMHJ0iD3/0/mEZ6DAWTaM
hUnLKxBoG85wMwjLdNklBwcvxjxZLQt7YXJXKDlsnfIdKZPI8wAe+kEzFLgXe87D
qJUjZ8uhNDYiir2szezoOnYaO5I1BnYteILCo9ZV9YiPv5HtD7fHr67CKjxwm3Ay
s9KCg8g86OSjblYuj8UsPro8NAOAuwWJaPktHpRBhqz0TKc1Xc8a6v6PDZ1i0L+Y
78m6juruA0E+RkdQjIC8
=NkoY
-----END PGP SIGNATURE-----

--A6N2fC+uXW/VQSAv--
