Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891AbaGGJEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 05:04:42 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:44679 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaGGJEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 05:04:39 -0400
Date: Mon, 7 Jul 2014 11:04:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/1] perf: Prevent race in PERF_SAMPLE_READ group format
 sample output
Message-ID: <20140707090428.GG6758@twins.programming.kicks-ass.net>
References: <1403721875-15669-1-git-send-email-jolsa@kernel.org>
 <1403721875-15669-2-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GSe1yqLCWMTKXEPF"
Content-Disposition: inline
In-Reply-To: <1403721875-15669-2-git-send-email-jolsa@kernel.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GSe1yqLCWMTKXEPF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 25, 2014 at 08:44:35PM +0200, Jiri Olsa wrote:
> From: Jiri Olsa <jolsa@redhat.com>
>=20
> While iterating siblings in perf_output_read_group we could
> race with addition and removal of sibling in perf_group_attach
> and perf_group_detach respective.

So why would anybody do this?

> While in perf_output_read_group we are under active context,
> so the only sibling_list modification could come via IPI in:
>   perf_install_in_context or perf_remove_from_context
>=20
> Disable interrupts before iterating siblings to prevent
> this race.
>=20
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  kernel/events/core.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>=20
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index a33d9a2b..66649d3 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -4509,6 +4509,7 @@ static void perf_output_read_group(struct perf_outp=
ut_handle *handle,
>  {
>  	struct perf_event *leader =3D event->group_leader, *sub;
>  	u64 read_format =3D event->attr.read_format;
> +	unsigned long flags;
>  	u64 values[5];
>  	int n =3D 0;
> =20
> @@ -4529,6 +4530,15 @@ static void perf_output_read_group(struct perf_out=
put_handle *handle,
> =20
>  	__output_copy(handle, values, n * sizeof(u64));
> =20
> +	/*
> +	 * We are now under active context, so the only sibling_list
> +	 * modification could come via IPI in:
> +	 *   perf_install_in_context and perf_remove_from_context
> +	 *
> +	 * Disable interrupts to prevent this race.
> +	 */
> +	local_irq_save(flags);

I think this is too late; you want it right at the beginning, before we
read ->nr_siblings, as that is also changed by
add_event_to_ctx()->perf_group_attach().

That said; it would be nice not to have to poke at the interrupt flag,
its expensive.

So is this really a problem, or just a case of: if you do silly things,
you get silly results?

--GSe1yqLCWMTKXEPF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTumKcAAoJEHZH4aRLwOS6SzEP/0tXTzC0gcia7Ku8VCXQKrc/
B8ADziIJDm7mfLVgxxTj8xblbSycz70jr5NalxB99PRo9UN/mCKeyiYRdz134y51
NcgJeP3TniabFbalhcjup50qnge/XmUnzu6ocISyMDPBwoWkP9PAPolYUJSBuTpA
76miTszw+nCMbG5dLM6lcSd1eCOS2b0iDsyEtQRgUQ6ofCVExOlscocOuYOzNm9K
5pqqm5e9jE6AaYPBejPeypSq2mQ34ocFULfQNpVn8JXFUkdQF84DsSRPbnC5R3Y7
guyCbEe8HbJYhGA/o4IZTOP5immyZEWZs5gHEM8QYr5XgTlStzO06lOZfPa2RCGC
j1ULhI+KBu90ZB0aIae/au6S6dy3GvzXN/QDAXVYy/vQSBsCfvQrshO2pkfFrD9Y
QbG2SKzWlDxFXF68TX0SbeO2MxbaFWsO66j8fcbwfQ74NteDIpwXoD2Ge+9wP1U/
BkvxbW0aVOLZHkCLT/zTbvwNqK0TGrT3uiMoc0bjUTTk/xH4vEUR9gss33dniv8m
NoOvRx8JtXY6gYysmEMRwxfDfh2Nm8gtPu2kGImALt1HVOxmush9SlYmPRtsSuM3
T+jZcfu3Vxx8kCq5MtiuIj1Qb652eUVD3fsNnOTEvdb46FTMd5x0cqUr2mZ7gSlT
gsrRsPDzO6r1snZzA+iB
=9+S+
-----END PGP SIGNATURE-----

--GSe1yqLCWMTKXEPF--
