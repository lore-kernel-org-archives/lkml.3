Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab3HOLc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 07:32:29 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:39441 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab3HOLc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 07:32:26 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Olof Johansson <olof@lixom.net>, Rob Herring <rob.herring@calxeda.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH v3 01/16] of: add support for retrieving cpu node for a given logical cpu index
Date: Thu, 15 Aug 2013 13:32:16 +0200
Message-ID: <1403722.mOLJEHt2Ii@flatron>
User-Agent: KMail/4.10.5 (Linux/3.10.6-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1374492747-13879-2-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1374069984-20567-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1374492747-13879-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1374492747-13879-2-git-send-email-Sudeep.KarkadaNagesha@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3566729.RXkGxWDZOT"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart3566729.RXkGxWDZOT
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi Sudeep,

I don't like this constant DT parsing every time a node of given CPU is 
required, but I believe it was correctly discussed with people that are 
more into CPU topologies and similar things than me. (My idea would be to 
make a lookup array with logical ID to struct device_node * mapping.)

Let me just review this from DT parsing perspective.

On Monday 22 of July 2013 12:32:12 Sudeep KarkadaNagesha wrote:
> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> 
> Currently different drivers requiring to access cpu device node are
> parsing the device tree themselves. Since the ordering in the DT need
> not match the logical cpu ordering, the parsing logic needs to consider
> that. However, this has resulted in lots of code duplication and in some
> cases even incorrect logic.
> 
> It's better to consolidate them by adding support for getting cpu
> device node for a given logical cpu index in DT core library. However
> logical to physical index mapping can be architecture specific.
> 
> This patch adds of_get_cpu_node to retrieve a cpu device node for a
> given logical cpu index. The default matching of the physical id to the
> logical cpu index can be overridden by architecture specific code.
> 
> It is recommended to use these helper function only in pre-SMP/early
> initialisation stages to retrieve CPU device node pointers in logical
> ordering. Once the cpu devices are registered, it can be retrieved
> easily from cpu device of_node which avoids unnecessary parsing and
> matching.
> 
> Acked-by: Rob Herring <rob.herring@calxeda.com>
> Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> ---
>  drivers/of/base.c  | 72
> ++++++++++++++++++++++++++++++++++++++++++++++++++++++
> include/linux/of.h |  6 +++++
>  2 files changed, 78 insertions(+)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index 5c54279..1e690bf 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -230,6 +230,78 @@ const void *of_get_property(const struct
> device_node *np, const char *name, }
>  EXPORT_SYMBOL(of_get_property);
> 
> +/*
> + * arch_match_cpu_phys_id - Match the given logical CPU and physical id
> + *
> + * @cpu: logical index of a cpu
> + * @phys_id: physical identifier of a cpu
> + *
> + * CPU logical to physical index mapping is architecture specific.
> + * However this __weak function provides a default match of physical
> + * id to logical cpu index.
> + *
> + * Returns true if the physical identifier and the logical index
> correspond + * to the same cpu, false otherwise.
> + */
> +bool __weak arch_match_cpu_phys_id(int cpu, u64 phys_id)
> +{
> +	return (u32)phys_id == cpu;
> +}
> +
> +/**
> + * of_get_cpu_node - Get device node associated with the given logical
> CPU + *
> + * @cpu: CPU number(logical index) for which device node is required
> + *
> + * The main purpose of this function is to retrieve the device node for
> the + * given logical CPU index. It should be used to intialize the
> of_node in + * cpu device. Once of_node in cpu device is populated, all
> the further + * references can use that instead.
> + *
> + * CPU logical to physical index mapping is architecture specific and
> is built + * before booting secondary cores. This function uses
> arch_match_cpu_phys_id + * which can be overridden by architecture
> specific implementation. + *
> + * Returns a node pointer for the logical cpu if found, else NULL.
> + */
> +struct device_node *of_get_cpu_node(int cpu)
> +{
> +	struct device_node *cpun, *cpus;
> +	const __be32 *cell;
> +	u64 hwid;
> +	int ac, prop_len;
> +
> +	cpus = of_find_node_by_path("/cpus");
> +	if (!cpus) {
> +		pr_warn("Missing cpus node, bailing out\n");
> +		return NULL;
> +	}
> +
> +	if (of_property_read_u32(cpus, "#address-cells", &ac)) {
> +		pr_warn("%s: missing #address-cells\n", cpus->full_name);
> +		ac = of_n_addr_cells(cpus);

I'm not sure this fallback is appropriate. According to ePAPR:

"The #address-cells and #size-cells properties are not inherited from 
ancestors in the device tree. They shall be explicitly defined."

In addition:

If missing, a client program should assume a default value of 2 for 
#address-cells, and a value of 1 for #size-cells.

This also leaves in question the correctness of of_n_addr_cells() and 
of_n_size_cells().

> +	}
> +
> +	for_each_child_of_node(cpus, cpun) {
> +		if (of_node_cmp(cpun->type, "cpu"))
> +			continue;
> +		cell = of_get_property(cpun, "reg", &prop_len);
> +		if (!cell) {
> +			pr_warn("%s: missing reg property\n", cpun-
>full_name);
> +			continue;
> +		}
> +		prop_len /= sizeof(*cell);
> +		while (prop_len) {
> +			hwid = of_read_number(cell, ac);
> +			prop_len -= ac;
> +			if (arch_match_cpu_phys_id(cpu, hwid))
> +				return cpun;

This is a nice potential infinite loop. Consider following example:

cpus {
	#address-cells = <2>; /* A typo. Should be 1. */
	#size-cells = <0>;

	cpu@0 {
		/* ... */
		reg = <0>;
	};
};

In this case prop_len will start with 1, while ac will be 2. After first 
iteration of the loop (when the phys id doesn't match) you will end up 
with prop_len = -1 and each iteration will decrement it even more.

By the way, I'm not sure why the whole loop is here. IMHO it should be 
something like:

	if (prop_len != ac) {
		pr_warn(...); // or whatever
		continue;
	}

	hwid = of_read_number(cell, ac);
	// ...

Best regards,
Tomasz

--nextPart3566729.RXkGxWDZOT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAABAgAGBQJSDLxDAAoJEIv3Hb8G/Xru4gAP/1/9/C6xhNYVQqtKiYq43Lk0
YalhL7CVOdar8SCAfSDCZ5kNFANxVgG83ZlCUIwMyJCrdcc3HWdkZLBomVQr/JhG
AaHM97UPAs1df8kkzPINg1ObMloMRDn+VTF8OMy6Ff7GyyPet09bjMaGBcYcCBwe
tKXHzQyiHVhpJPnGTbPGLJtlhlB4bgAUfH5yA8mDnA5lJrYbvQQAdUioOn7Yaiew
Oa0NCVn45a8TioCF4RYXb+sHxDj3BVBX/rNLYf7D2rQl5Lho6oPmAxEguBpfY1Fq
zgMdh5MmxeOtXEYtGxNI1YgsByEGwzxdiO1nEC5U8KotJyexwkQ52H6XjpaIKkO5
W+mFeCDjlblwFwXsOmNP5vTLwtv5RpRw1yLfKuI0jM/ouAr0+DQXU9x9VZJKXyG4
2csSGmmUJEiVu0/nIhRt1FnIMDtuH6ESmYUhB+13VuUNQL2Ikn8zhDTJgA1ECtsh
FkT/tJITfqHwf1fxxniDbanhu2WVbMnP7swE/EVWaVPuLhpOaP2NXdELT44F91OZ
RwDwzMSStS1UFWmVzUqtas1phAdLLyoZRZZm/xnEYQqcCK5jS1Df4IkzRsfN/fvj
SiZpv9SnOdtnGKDgem79xLtl0aD4rOCwzPIC8+AhD+ZgFaGCGosU9nk1fRFF3wpK
X14PUDfWOEQeDkTLAegm
=qBlb
-----END PGP SIGNATURE-----

--nextPart3566729.RXkGxWDZOT--

