Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998Ab3CTDU6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 23:20:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:2944 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503Ab3CTDU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 23:20:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,876,1355126400"; 
   d="asc'?scan'208";a="305605799"
Date: Tue, 19 Mar 2013 23:16:47 -0400
From: Chen Gong <gong.chen@linux.intel.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        x86@kernel.org
Subject: Re: cpu offline causes backtrace from cmci_rediscover
Message-ID: <20130320031647.GA13311@gchen.bj.intel.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org
References: <20130319224408.GB18152@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
In-Reply-To: <20130319224408.GB18152@redhat.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 19, 2013 at 06:44:08PM -0400, Dave Jones wrote:
> Date:	Tue, 19 Mar 2013 18:44:08 -0400
> From: Dave Jones <davej@redhat.com>
> To: Linux Kernel <linux-kernel@vger.kernel.org>
> Cc: x86@kernel.org
> Subject: cpu offline causes backtrace from cmci_rediscover
> User-Agent: Mutt/1.5.21 (2010-09-15)
>=20
> offlining a CPU in 3.9-rc3 gets me this trace..
>=20
> numa_remove_cpu cpu 1 node 0: mask now 0,2-3
> smpboot: CPU 1 is now offline
> BUG: using smp_processor_id() in preemptible [00000000] code: cpu-offline=
=2Esh/10591
> caller is cmci_rediscover+0x6a/0xe0
> Pid: 10591, comm: cpu-offline.sh Not tainted 3.9.0-rc3+ #2
> Call Trace:
>  [<ffffffff81333bbd>] debug_smp_processor_id+0xdd/0x100
>  [<ffffffff8101edba>] cmci_rediscover+0x6a/0xe0
>  [<ffffffff815f5b9f>] mce_cpu_callback+0x19d/0x1ae
>  [<ffffffff8160ea66>] notifier_call_chain+0x66/0x150
>  [<ffffffff8107ad7e>] __raw_notifier_call_chain+0xe/0x10
>  [<ffffffff8104c2e3>] cpu_notify+0x23/0x50
>  [<ffffffff8104c31e>] cpu_notify_nofail+0xe/0x20
>  [<ffffffff815ef082>] _cpu_down+0x302/0x350
>  [<ffffffff815ef106>] cpu_down+0x36/0x50
>  [<ffffffff815f1c9d>] store_online+0x8d/0xd0
>  [<ffffffff813edc48>] dev_attr_store+0x18/0x30
>  [<ffffffff81226eeb>] sysfs_write_file+0xdb/0x150
>  [<ffffffff811adfb2>] vfs_write+0xa2/0x170
>  [<ffffffff811ae16c>] sys_write+0x4c/0xa0
>  [<ffffffff81613019>] system_call_fastpath+0x16/0x1b
>=20
Try this patch:

diff a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/=
mce_intel.c
index 402c454..692c91e 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -311,10 +311,12 @@ void cmci_rediscover(int dying)
                if (cpu =3D=3D dying)
                        continue;

-               if (cpu =3D=3D smp_processor_id()) {
+               if (cpu =3D=3D get_cpu()) {
+                       put_cpu();
                        cmci_rediscover_work_func(NULL);
                        continue;
-               }
+               } else
+                       put_cpu();

                work_on_cpu(cpu, cmci_rediscover_work_func, NULL);
        }


--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRSSofAAoJEI01n1+kOSLHTDoP/RVRgxmzJs3TaG+9yiZocO7C
yA1soQeGyTG+uZuHqej7oCgKQRvbPCdIoacm8QGGfUxOBiA/ZoZlcSvIjmyUxsze
kCMeO148L1sL+pqQKCp+W079+cE8jrLvdI4k1ypSYrkURFulY0YUrvelnDyUrxmG
bcIPCjsqCAytYpiJrIWX7GdcTXo4p5XY92eqnBVeRStB96NmFThQLKhoHo4yzcdp
jSjogEAeuZCTUlOJHhbT/gCpw4JMvHUnJORw+FHy/O5Z7zatKxI88FjimFhDjcs6
u+5jhZ/cpHmqKtzoFLQC2KDP3t8XU/9aghp5feux9pnTrBivYdn4E43LwaFaZReq
Xtn/DUyLfncx+YEfnF2Ri4SAl8xpeCzKCb7pduJ5ewDWcBIkfHuiLG1Q9Gcp1UMU
8Q2UeqCo6Lp1C4HICUIkMNBb6NstafofJxbM4f8JBavWCrEQo6ZAq7dO43MEi+27
DWb/5pW8ieeE9zE473KAgZQwoJEW5uw67MSjkBXGMPMLuwps+lblvS7xBXhWkoOD
m8Bt9tlKwXL3A7Nw5/mNvIuY+o2jJquAVAuDtoAAc7tSjt4uJRJgjCxNkbPvn2Ov
uHFaW55mWoZuiKFgRsARgfdLx5luDSE80eH+B2u2AEIDSqfHK2vDy3w1+F7By2yI
XM6u1icRocyrFBwH4Q77
=utfg
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
