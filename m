Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab3KNH0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 02:26:47 -0500
Received: from smtp.citrix.com ([66.165.176.89]:38532 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087Ab3KNH0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 02:26:44 -0500
X-IronPort-AV: E=Sophos;i="4.93,698,1378857600"; 
   d="asc'?scan'208";a="74357385"
Message-ID: <1384414000.29902.25.camel@Abyss>
Subject: Re: [Xen-devel] [PATCH 1/2] xen: vnuma support for PV guests
 running as domU.
From: Dario Faggioli <dario.faggioli@citrix.com>
To: Elena Ufimtseva <ufimtseva@gmail.com>
CC: <xen-devel@lists.xenproject.org>, <akpm@linux-foundation.org>,
        <wency@cn.fujitsu.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>,
        <mingo@redhat.com>, <david.vrabel@citrix.com>, <hpa@zytor.com>,
        <boris.ostrovsky@oracle.com>, <tglx@linutronix.de>,
        <stefano.stabellini@eu.citrix.com>, <ian.campbell@citrix.com>
Date: Thu, 14 Nov 2013 08:26:40 +0100
In-Reply-To: <1384400179-24404-2-git-send-email-ufimtseva@gmail.com>
References: <1384400179-24404-1-git-send-email-ufimtseva@gmail.com>
	 <1384400179-24404-2-git-send-email-ufimtseva@gmail.com>
Organization: Citrix Ltd
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="=-XRlrjOJWqu46b4p/MAL6"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
MIME-Version: 1.0
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-XRlrjOJWqu46b4p/MAL6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On mer, 2013-11-13 at 22:36 -0500, Elena Ufimtseva wrote:
> Signed-off-by: Elena Ufimtseva <ufimtseva@gmail.com>
> ---
> +++ b/arch/x86/include/asm/xen/vnuma.h
> @@ -0,0 +1,12 @@
> +#ifndef _ASM_X86_VNUMA_H
> +#define _ASM_X86_VNUMA_H
> +
> +#ifdef CONFIG_XEN
> +int xen_vnuma_supported(void);
> +int xen_numa_init(void);
> +#else
> +int xen_vnuma_supported(void) { return 0; };
> +int xen_numa_init(void) { return -1; };
> +#endif
> +
> +#endif /* _ASM_X86_VNUMA_H */
> diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
>

> @@ -621,6 +622,10 @@ static int __init dummy_numa_init(void)
>  void __init x86_numa_init(void)
>  {
>  	if (!numa_off) {
> +#ifdef CONFIG_XEN
> +		if (xen_vnuma_supported() && !numa_init(xen_numa_init))
> +			return;
> +#endif
>
This looks a bit weird (looking at both the hunks above, I mean). Isn't
it that, if !CONFIG_XEN, xen_vnuma_supported() and xen_numa_init() are
never called, thus there is very few point in defining a specific
behavior for them?

Oh, having looked at the other patch, I appreciate that at least
xen_vnuma_supported() is (possibly) called even when !CONFIG_XEN. Well,
the above still holds for xen_numa_init(), I guess. :-)

> diff --git a/arch/x86/xen/vnuma.c b/arch/x86/xen/vnuma.c

> +int __init xen_numa_init(void)
> +{

> +	mem_size =3D  pcpus * sizeof(struct vmemrange);
> +	dist_size =3D pcpus * pcpus * sizeof(*numa_topo.vdistance);
> +	cpu_to_node_size =3D pcpus * sizeof(*numa_topo.cpu_to_node);
> +
> +	physm =3D memblock_alloc(mem_size, PAGE_SIZE);
> +	vblock =3D __va(physm);
> +
> +	physd =3D memblock_alloc(dist_size, PAGE_SIZE);
> +	vdistance  =3D __va(physd);
> +
> +	physc =3D memblock_alloc(cpu_to_node_size, PAGE_SIZE);
> +	cpu_to_node  =3D __va(physc);
> +
> +	if (!physm || !physc || !physd)
> +		goto vnumaout;
> +
It's probably not a big deal, but I think names like 'out', 'err',
'fail', etc. are just fine for labels... No need for having that sort of
func name prefix.

> +	set_xen_guest_handle(numa_topo.nr_nodes, &nr_nodes);
> +	set_xen_guest_handle(numa_topo.vmemblks, vblock);
> +	set_xen_guest_handle(numa_topo.vdistance, vdistance);
> +	set_xen_guest_handle(numa_topo.cpu_to_node, cpu_to_node);
> +
> +	rc =3D HYPERVISOR_memory_op(XENMEM_get_vnuma_info, &numa_topo);
> +
> +	if (rc < 0)
> +		goto vnumaout;
> +	if (*numa_topo.nr_nodes =3D=3D 0) {
> +		/* will pass to dummy_numa_init */
> +		goto vnumaout;
> +	}
> +	if (*numa_topo.nr_nodes > num_possible_cpus()) {
> +		pr_debug("vNUMA: Node without cpu is not supported in this version.\n"=
);
> +		goto vnumaout;
> +	}
Blank line here?

> +	/*
> +	 * NUMA nodes memory ranges are in pfns, constructed and
> +	 * aligned based on e820 ram domain map.
> +	 */
> +	for (i =3D 0; i < *numa_topo.nr_nodes; i++) {
> +		if (numa_add_memblk(i, vblock[i].start, vblock[i].end))
> +			/* pass to numa_dummy_init */
> +			goto vnumaout;
> +		node_set(i, numa_nodes_parsed);
> +	}
And here...
> +	setup_nr_node_ids();
...And perhaps even here (but it's less important, I think)...
> +	/* Setting the cpu, apicid to node */
> +	for_each_cpu(cpu, cpu_possible_mask) {
> +		set_apicid_to_node(cpu, cpu_to_node[cpu]);
> +		numa_set_node(cpu, cpu_to_node[cpu]);
> +		cpumask_set_cpu(cpu, node_to_cpumask_map[cpu_to_node[cpu]]);
> +	}
...And here...
> +	for (i =3D 0; i < *numa_topo.nr_nodes; i++) {
> +		for (j =3D 0; j < *numa_topo.nr_nodes; j++) {
> +			idx =3D (j * *numa_topo.nr_nodes) + i;
> +			numa_set_distance(i, j, *(vdistance + idx));
> +		}
> +	}
...And probably here too...
> +	rc =3D 0;
> +vnumaout:
> +	if (physm)
> +		memblock_free(__pa(physm), mem_size);
> +	if (physd)
> +		memblock_free(__pa(physd), dist_size);
> +	if (physc)
> +		memblock_free(__pa(physc), cpu_to_node_size);
...And here.
> +	/*
> +	 * Set the "dummy" node and exit without error so Linux
> +	 * will not try any NUMA init functions which might break
> +	 * guests in the future. This will discard all previous
> +	 * settings.
> +	 */
IIRC, it's more something that was already happening (the breakage, I
mean), than a "safety net" for the unforeseeable future. Might be worth
giving some context about it, perhaps referencing the email thread or
the git commit hash in the comment.

> +	if (rc !=3D 0) {
> +		for (i =3D 0; i < MAX_LOCAL_APIC; i++)
> +			set_apicid_to_node(i, NUMA_NO_NODE);
> +		nodes_clear(numa_nodes_parsed);
> +		nodes_clear(node_possible_map);
> +		nodes_clear(node_online_map);
> +		node_set(0, numa_nodes_parsed);
> +		numa_add_memblk(0, 0, PFN_PHYS(max_pfn));
> +	}
> +	return 0;
>
Ok, so, we always return 'success', as we were saying during last round.
However, we do not call dummy_numa_init() directly, and instead we do
all these stuff, with the last two statements being exactly what
dummy_numa_init() does. Reason is linking, i.e., the fact that
dummy_numa_init() is not exported and you can't reach it from here,
right?

Personally, I think this is fine, but I'd probably:
 - say something about it in a comment (the fact that you're
   cut'ng-&past'ng the dummy_numa_init() code);
 - pick up the printk (or at least something like that) from there too.

Thanks and Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
-----------------------------------------------------------------
Dario Faggioli, Ph.D, http://about.me/dario.faggioli
Senior Software Engineer, Citrix Systems R&D Ltd., Cambridge (UK)


--=-XRlrjOJWqu46b4p/MAL6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iEYEABECAAYFAlKEezAACgkQk4XaBE3IOsSflwCeNyVzjHURmNq4dNZ0gVG3hpJR
6H8AnRyhrKeUgvEjV1UWpRsjJ6AM71ic
=zG9L
-----END PGP SIGNATURE-----

--=-XRlrjOJWqu46b4p/MAL6--
