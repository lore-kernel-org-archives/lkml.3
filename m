Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab3EVJCi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 05:02:38 -0400
Received: from mga14.intel.com ([143.182.124.37]:5334 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495Ab3EVJCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 05:02:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,718,1363158000"; 
   d="asc'?scan'208";a="306141402"
Date: Wed, 22 May 2013 04:55:53 -0400
From: Chen Gong <gong.chen@linux.intel.com>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, tj@kernel.org, laijs@cn.fujitsu.com,
        davem@davemloft.net, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 01/13] x86: get pg_data_t's memory from other node
Message-ID: <20130522085553.GB25406@gchen.bj.intel.com>
Mail-Followup-To: Tang Chen <tangchen@cn.fujitsu.com>, mingo@redhat.com,
	hpa@zytor.com, akpm@linux-foundation.org, yinghai@kernel.org,
	jiang.liu@huawei.com, wency@cn.fujitsu.com,
	isimatu.yasuaki@jp.fujitsu.com, tj@kernel.org, laijs@cn.fujitsu.com,
	davem@davemloft.net, mgorman@suse.de, minchan@kernel.org,
	mina86@mina86.com, x86@kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <1367313683-10267-1-git-send-email-tangchen@cn.fujitsu.com>
 <1367313683-10267-2-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eAbsdosE1cNLO4uF"
Content-Disposition: inline
In-Reply-To: <1367313683-10267-2-git-send-email-tangchen@cn.fujitsu.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eAbsdosE1cNLO4uF
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 30, 2013 at 05:21:11PM +0800, Tang Chen wrote:
> Date: Tue, 30 Apr 2013 17:21:11 +0800
> From: Tang Chen <tangchen@cn.fujitsu.com>
> To: mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org,
>  yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
>  isimatu.yasuaki@jp.fujitsu.com, tj@kernel.org, laijs@cn.fujitsu.com,
>  davem@davemloft.net, mgorman@suse.de, minchan@kernel.org,
>  mina86@mina86.com
> Cc: x86@kernel.org, linux-doc@vger.kernel.org,
>  linux-kernel@vger.kernel.org, linux-mm@kvack.org
> Subject: [PATCH v2 01/13] x86: get pg_data_t's memory from other node
> X-Mailer: git-send-email 1.7.10.1
>=20
> From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>=20
> If system can create movable node which all memory of the
> node is allocated as ZONE_MOVABLE, setup_node_data() cannot
> allocate memory for the node's pg_data_t.
> So, use memblock_alloc_try_nid() instead of memblock_alloc_nid()
> to retry when the first allocation fails.
>=20
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> ---
>  arch/x86/mm/numa.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
> index 11acdf6..4f754e6 100644
> --- a/arch/x86/mm/numa.c
> +++ b/arch/x86/mm/numa.c
> @@ -214,10 +214,9 @@ static void __init setup_node_data(int nid, u64 star=
t, u64 end)
>  	 * Allocate node data.  Try node-local memory and then any node.
>  	 * Never allocate in DMA zone.
>  	 */
> -	nd_pa =3D memblock_alloc_nid(nd_size, SMP_CACHE_BYTES, nid);
> +	nd_pa =3D memblock_alloc_try_nid(nd_size, SMP_CACHE_BYTES, nid);

go through the implementation of memblock_alloc_try_nid, it will call
panic when allocation fails(a.k.a alloc =3D 0), if so, below information
will be never printed. Do we really need this?

>  	if (!nd_pa) {
> -		pr_err("Cannot find %zu bytes in node %d\n",
> -		       nd_size, nid);
> +		pr_err("Cannot find %zu bytes in any node\n", nd_size);
>  		return;
>  	}
>  	nd =3D __va(nd_pa);
> --=20
> 1.7.1
>=20
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>

--eAbsdosE1cNLO4uF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRnIgZAAoJEI01n1+kOSLH/CsP/16GGe0N5L1uTc8i48q7KelX
NUyty60GuYFGWxxKjbWTCniPqUUV6PMSMKfVvUOQOnuaKrnAgoLbuZQeyXrscscc
h4sCSwIrE3opJuOyFbEaPmIaSmo0BkzFWP8Sepqvi+lJEsBYvEryy8RZeaVw8NBN
GGfq0Uu793G9bFXZ+qK4B+GAZD9XE2k26qG2GAhSCNZKYxVquTtoayTE91XwbDFg
TU/vXNodk5ufJ4udjNBM/cyd1Z52uB1DDoHCnrKflXCAfle1OwWFvG6O/TD7xwVC
+7L+fJnSg6v+fA+s+zE1s+4ndzLfCLss+sjdjrNXScLBksnhhoMAO6ZDQLpGIeGB
IT7HNaUWV4GzP1tB6LQe0rGLCeFMlDu/9ecxVvymBGwIflkSuG7opCTzo9E/WOh3
MPkDMTT5RG/DpRMr3yH3Qdcw9T2TVbuNDYzcgYkcIQCj7IddlFwDg3Dt9dBUlGqg
90YkQ73T8xHcBEUf20MEMDdGLH8ckpjqya8ylTPv/CkQ5Ic5xQl0knvk9bOEbG8M
R/IqcP+IbRYerPhywzSIQ6EfowqESPC1y9OHWSOJkOIU4WAAtdYKQdBTqcK1F5SJ
mGrF1jK8tJ0hmxFwmaRKOBFNWt+C4o63fwu6DnPwCJM+oo6Hul/S/OP/5WE2cnd1
HXCotahlUMaG1MyDQZpr
=xxwK
-----END PGP SIGNATURE-----

--eAbsdosE1cNLO4uF--
