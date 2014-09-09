Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256AbaIIIop (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 04:44:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:43470 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932206AbaIIIom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 04:44:42 -0400
Date: Tue, 9 Sep 2014 10:44:36 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com
Subject: Re: [PATCH v4 09/22] perf: Support overwrite mode for AUX area
Message-ID: <20140909084436.GY19379@twins.programming.kicks-ass.net>
References: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1408538179-792-10-git-send-email-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tsXbTCuc02oUSrD/"
Content-Disposition: inline
In-Reply-To: <1408538179-792-10-git-send-email-alexander.shishkin@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tsXbTCuc02oUSrD/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2014 at 03:36:06PM +0300, Alexander Shishkin wrote:

> diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
> index 925f369947..5006caba63 100644
> --- a/kernel/events/ring_buffer.c
> +++ b/kernel/events/ring_buffer.c

> @@ -294,9 +295,22 @@ void perf_aux_output_end(struct perf_output_handle *=
handle, unsigned long size,
>  			 bool truncated)
>  {
>  	struct ring_buffer *rb =3D handle->rb;
> +	unsigned long aux_head;
> =20
> +	aux_head =3D local_read(&rb->aux_head);
> +
> +	if (rb->aux_overwrite) {
> +		local_set(&rb->aux_head, size);
> +
> +		/*
> +		 * Send a RECORD_AUX with size=3D=3D0 to communicate aux_head
> +		 * of this snapshot to userspace
> +		 */
> +		perf_event_aux_event(handle->event, size, 0, truncated);

Humm.. why not write a 'normal' AUX record?

Also, you didn't mention this in your Changelog _at_all_.

> +	} else {
> +		local_add(size, &rb->aux_head);
> +		perf_event_aux_event(handle->event, aux_head, size, truncated);
> +	}
> =20
>  	smp_wmb();
>  	rb->user_page->aux_head =3D local_read(&rb->aux_head);

--tsXbTCuc02oUSrD/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUDr30AAoJEHZH4aRLwOS6lCoP/jQb5UxVEJ32Xoull2/DSlVw
ZMBnlDwbW+ti3DlPIadaN3Te9bfUvH9f8B6X8NWz20kzwiX5cUIfDVKdBidwpRux
Mf3wF4ur3zkdg5s/eGy3qTP3eFQPC54Gcs6onfnunJjJlWKf0kxTb1SiVHamdYnc
yXegp/0qKIFnYjng+7mxw1HWAl7doetlzNYlNH43MfjMfi96X7ZympYLn7BpzMId
DILl5buu9sb+06tKLvIDf1VKuOq7yB3sEn1m3qky3b5IOAfmGM87HdEFG5ej++xX
BIQ7dj2nZnGKZwmGPWx28xPxVCdjd5y6JiRx43TUY7T3av11ZlWNIP0rZBq/lFWo
6XFgU9tgv9NBIzJdOuQVAz1IVR/htk/xcc4aOpjNAVphaifTiAH6WnQ8hwxNLRBr
ZV0rKq9VycoInY0rn1d4b+n5Jp9LHBkVgtOr+KC7Dv5n2Xn6x/3mlIix2Knzsq6y
CWjYgFWCTbw8QGZLIChVzuYpmmDvKGvjPnnLztsR2j7AbxnhNINiaYY3PbvcZ9Dc
LtAB2hLE0MW/dHjyr8p8IBNkc2dTIS9YsTureElao9JzEvA+YI4sxo8UFYXrWoXm
lc7Z8VWtAIIw8WnIR7A0hPzFs7oDnW09KrDqgfVoVoWWN/Sdy+OlmtZ92dEvsel7
N4PJB7zkSTy9h9R6XC66
=U0qA
-----END PGP SIGNATURE-----

--tsXbTCuc02oUSrD/--
