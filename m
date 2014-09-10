Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950AbaIJH51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 03:57:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:48927 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbaIJH50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 03:57:26 -0400
Date: Wed, 10 Sep 2014 09:57:22 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        tglx@linutronix.de, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf, x86: Fall back to vmalloc for BTS buffer allocation
Message-ID: <20140910075722.GL6758@twins.programming.kicks-ass.net>
References: <1410307401-12401-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0X5AUaifkWPNnJg2"
Content-Disposition: inline
In-Reply-To: <1410307401-12401-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0X5AUaifkWPNnJg2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 09, 2014 at 05:03:21PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
>=20
> On my workstation the order 4 BTS buffer allocation fails regularly
> after the system has been up for some time due to memory
> fragmentation.
>=20
> BTS is virtual memory, so we can just fall back to vmalloc
> instead of failing.
>=20
> Do this here.
>=20
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel_ds.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/=
cpu/perf_event_intel_ds.c
> index 9dc4199..3cf5b74 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> @@ -312,8 +312,11 @@ static int alloc_bts_buffer(int cpu)
> =20
>  	buffer =3D kzalloc_node(BTS_BUFFER_SIZE, GFP_KERNEL | __GFP_NOWARN, nod=
e);
>  	if (unlikely(!buffer)) {
> -		WARN_ONCE(1, "%s: BTS buffer allocation failure\n", __func__);
> -		return -ENOMEM;
> +		buffer =3D vmalloc_node(BTS_BUFFER_SIZE, node);
> +		if (!buffer) {
> +			WARN_ONCE(1, "%s: BTS buffer allocation failure\n", __func__);
> +			return -ENOMEM;
> +		}
>  	}
> =20
>  	max =3D BTS_BUFFER_SIZE / BTS_RECORD_SIZE;

We did this once, and that blew up big time.

Even now, vmalloc_fault() has a very explicit:

  WARN_ON_ONCE(in_nmi());

So this isn't going to happen until you fix that.

--0X5AUaifkWPNnJg2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUEARiAAoJEHZH4aRLwOS6EL8QALY9KdPus+bauP5b6sHjD3iV
TM47juZiYGFuyVuntCSVmxBEbcFrxqfF4F8QspohoFDzyRHHy0lnqcVRF5jVPXDd
2uuThodmJNZM355h8J/pvuPx0u/aweNO/wJLPqfClJOamvhxmA8wOZ+ndv9dmMxf
F45c5DRuiEJi18sp8UI0DeaCQwQFCuS33MMIFuqYKU0Ircm1MD45TCmmhQJ3tHjp
oK2I+4VZUyhBm+J3zAMBtPjTVN7zV7kCs3+2OLxdzstZsRdYzZxtGZel22GD2EYe
yCgOBPyXmIp6mjoAdXOPvFirOxc5cTfLu/O9FUO3laKkyEN3b0eXA+eEYZS/rEu5
11M7zsKRlyFpgaZ5zce79CxJpzubqyfI28qYbQv3Pc+ixtUVy/WxfmaQd0fPV/Rc
LMTFuS+RJK6MpXjU4nT62MoG4LiW8Fw5lwginFOMdWkiXi1KQdoV12Fgiklncc9L
jmAkoz0t8fxZ6qzr8WwLxDHZ2FFWeW4xL0lFL6K03S21xGj8N/RTkc2hK0rdrTas
fUzLm4Z4G5jAxYk+1bOBMXPDOnApdiW8RBpiEKdjy7UHx6JYTZtX5HbjOy9oxtCI
mlE/UMHL05cndiL7NB/qH7G8QEaqhTkhMNHm/KFsxLVcGYPGKszYdbt/C1wg8/UL
KKbmgcHCspQdxFV/sEL4
=JIOI
-----END PGP SIGNATURE-----

--0X5AUaifkWPNnJg2--
