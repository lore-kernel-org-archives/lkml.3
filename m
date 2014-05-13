Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761327AbaEMKnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:43:24 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58828 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760194AbaEMKnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:43:22 -0400
Date: Tue, 13 May 2014 12:43:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Dario Faggioli <raistlin@linux.it>, Ingo Molnar <mingo@elte.hu>,
        lkml <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: [BUG] sched_setattr() SCHED_DEADLINE hangs system
Message-ID: <20140513104307.GZ30445@twins.programming.kicks-ass.net>
References: <536F8F0E.7020301@gmail.com>
 <53707007.3080003@gmail.com>
 <20140512084727.GN30445@twins.programming.kicks-ass.net>
 <CAKgNAkiGt6xV0JaddmC8pLeTe+fSEu79DNvzg8XbA-MPo_zXyg@mail.gmail.com>
 <20140512123032.GC13467@laptop.programming.kicks-ass.net>
 <20140513115749.ebf3eebc64e44aac6f183410@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2DMJGKatbWMtT1aQ"
Content-Disposition: inline
In-Reply-To: <20140513115749.ebf3eebc64e44aac6f183410@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2DMJGKatbWMtT1aQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 13, 2014 at 11:57:49AM +0200, Juri Lelli wrote:
>  static bool
>  __checkparam_dl(const struct sched_attr *attr)
>  {
>  	return attr && attr->sched_deadline != 0 &&
>  		(attr->sched_period == 0 ||
> -		(s64)(attr->sched_period   - attr->sched_deadline) >= 0) &&
> -		(s64)(attr->sched_deadline - attr->sched_runtime ) >= 0  &&
> -		attr->sched_runtime >= (2 << (DL_SCALE - 1));
> +		(attr->sched_period >= attr->sched_deadline)) &&
> +		(attr->sched_deadline >= attr->sched_runtime) &&
> +		attr->sched_runtime >= (1ULL << DL_SCALE) &&
> +		(attr->sched_deadline < (1ULL << 63) &&
> +		attr->sched_period < (1ULL << 63));
>  }

Could we maybe rewrite that function to look less like a ioccc.org
submission?

static bool
__checkparam_dl(const struct sched_attr *attr)
{
	if (!attr) /* possible at all? */
		return false;

	/* runtime <= deadline <= period */
	if (attr->sched_period   < attr->sched_deadline ||
	    attr->sched_deadline < attr->sched_runtime)
		return false;

	/*
	 * Since we truncate DL_SCALE bits make sure we're at least that big,
	 * if runtime > (1 << DL_SCALE), so must the others be per the above
	 */
	if (attr->sched_runtime <= (1ULL << DL_SCALE))
		return false;

	/*
	 * Since we use the MSB for wrap-around and sign issues, make
	 * sure its not set, if period < 2^63, so must the others be.
	 */
	if (attr->sched_period & (1ULL << 63))
		return false;

	return true;
}

Did I miss anything?

--2DMJGKatbWMtT1aQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTcfc7AAoJEHZH4aRLwOS60oEP/3D0V+yyXjcf26745KTpT6mn
z3iOX2nXaLe2rwYhJAZvJRkgDdDAz0Rn0O5+4UXRpXsWbrWuweiYmjYFUeIfO7R9
VKym05NFNKwKVCU5Zotcl9ndfRPUySaOqIgxJcGya1X7HPgGEk5WxilRY/zOSzNa
NZtAN+ySRoFFIKaIV5cduw7B1+WJ5DQzHCer4X/pk1ja1XnRstuZ9OI35qVWLgPt
AeeTnqOIl6e8Sb7W3k1bYPI0BYgrf0t7C0VkDWbQl9MoV+au6MDu9SnRPK80b57/
mt8tJZswCVpZ4ufcpYVRsBc1Gsb98zH5NbSgBiDxQBg+OuPsqPirXOukgonUdtqR
LVghp5R5gHJThrvIlfXoZzugIVxYHhGU0ZgiGC5DpatvqU2YFnLPP/NR2hxM0zV8
AWhNBBivxNaY6+g64RyodIFMY6RfzM4QTlPVPEAaQh8D+mopvJRRPZZCxMyx/ql7
C9EGB5Pcx+cnG6VF6tsJLoxVj6ISytemu70sIi+4GjyWraDT9k66HKv6fS1sOUGM
Q8nmPc0LICUCnaE5B4x4XdPzeTEOdIhdPMJBZFhGisrdPbxZ/Ifm3lCASAPOjoj7
EpCM8FHoM8NhjcDblnykuI62ZCzZwApp/vkwDsqq1EW5eojmriKnS/uyNmoZCkJI
gtrwVZ+PsFM7ddNiukDf
=Svim
-----END PGP SIGNATURE-----

--2DMJGKatbWMtT1aQ--
