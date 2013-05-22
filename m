Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750921Ab3EVECZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 00:02:25 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52696 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab3EVECY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 00:02:24 -0400
Date: Wed, 22 May 2013 14:02:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Igor Mammedov <imammedo@redhat.com>
Subject: Re: linux-next: manual merge of the driver-core tree with the pm
 tree
Message-Id: <20130522140213.eb65bcc559088b199db1857f@canb.auug.org.au>
In-Reply-To: <20130522134741.51b06d38cb4939003c8e37a0@canb.auug.org.au>
References: <20130522134741.51b06d38cb4939003c8e37a0@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__22_May_2013_14_02_13_+1000_sqW7ynx/Kpb6QE26"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__22_May_2013_14_02_13_+1000_sqW7ynx/Kpb6QE26
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 22 May 2013 13:47:41 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the driver-core tree got a conflict in
> drivers/base/cpu.c between commit 0902a9044fa5 ("Driver core: Use generic
> offline/online for CPU offline/online") from the pm tree and commit
> 1c4e2d70afb1 ("cpu: make sure that cpu/online file created before
> KOBJ_ADD is emitted") from the driver-core tree.
>=20
> I fixed it up (they do some bits in common - see below) and can carry the
> fix as necessary (no action is required).
>=20
> diff --cc drivers/base/cpu.c
> index 7431ba6,c377673..0000000
> --- a/drivers/base/cpu.c
> +++ b/drivers/base/cpu.c
> @@@ -38,39 -34,66 +38,48 @@@ static void change_cpu_under_node(struc
>   	cpu->node_id =3D to_nid;
>   }
>  =20
>  -static ssize_t show_online(struct device *dev,
>  -			   struct device_attribute *attr,
>  -			   char *buf)
>  +static int __ref cpu_subsys_online(struct device *dev)
>   {
>   	struct cpu *cpu =3D container_of(dev, struct cpu, dev);
>  +	int cpuid =3D dev->id;
>  +	int from_nid, to_nid;
>  +	int ret;
>  +
>  +	cpu_hotplug_driver_lock();
>  +
>  +	from_nid =3D cpu_to_node(cpuid);
>  +	ret =3D cpu_up(cpuid);
>  +	/*
>  +	 * When hot adding memory to memoryless node and enabling a cpu
>  +	 * on the node, node number of the cpu may internally change.
>  +	 */
>  +	to_nid =3D cpu_to_node(cpuid);
>  +	if (from_nid !=3D to_nid)
>  +		change_cpu_under_node(cpu, from_nid, to_nid);
>  =20
>  -	return sprintf(buf, "%u\n", !!cpu_online(cpu->dev.id));
>  +	cpu_hotplug_driver_unlock();
>  +	return ret;
>   }
>  =20
>  -static ssize_t __ref store_online(struct device *dev,
>  -				  struct device_attribute *attr,
>  -				  const char *buf, size_t count)
>  +static int cpu_subsys_offline(struct device *dev)
>   {
>  -	struct cpu *cpu =3D container_of(dev, struct cpu, dev);
>  -	int cpuid =3D cpu->dev.id;
>  -	int from_nid, to_nid;
>  -	ssize_t ret;
>  +	int ret;
>  =20
>   	cpu_hotplug_driver_lock();
>  -	switch (buf[0]) {
>  -	case '0':
>  -		ret =3D cpu_down(cpuid);
>  -		if (!ret)
>  -			kobject_uevent(&dev->kobj, KOBJ_OFFLINE);
>  -		break;
>  -	case '1':
>  -		from_nid =3D cpu_to_node(cpuid);
>  -		ret =3D cpu_up(cpuid);
>  -
>  -		/*
>  -		 * When hot adding memory to memoryless node and enabling a cpu
>  -		 * on the node, node number of the cpu may internally change.
>  -		 */
>  -		to_nid =3D cpu_to_node(cpuid);
>  -		if (from_nid !=3D to_nid)
>  -			change_cpu_under_node(cpu, from_nid, to_nid);
>  -
>  -		if (!ret)
>  -			kobject_uevent(&dev->kobj, KOBJ_ONLINE);
>  -		break;
>  -	default:
>  -		ret =3D -EINVAL;
>  -	}
>  +	ret =3D cpu_down(dev->id);
>   	cpu_hotplug_driver_unlock();
>  -
>  -	if (ret >=3D 0)
>  -		ret =3D count;
>   	return ret;
>   }
>  -static DEVICE_ATTR(online, 0644, show_online, store_online);
>  =20
> + static struct attribute *hotplug_cpu_attrs[] =3D {
> + 	&dev_attr_online.attr,
> + 	NULL
> + };
> +=20
> + static struct attribute_group hotplug_cpu_attr_group =3D {
> + 	.attrs =3D hotplug_cpu_attrs,
> + };
> +=20
>   void unregister_cpu(struct cpu *cpu)
>   {
>   	int logical_cpu =3D cpu->dev.id;
> @@@ -102,20 -125,8 +111,19 @@@ static ssize_t cpu_release_store(struc
>   static DEVICE_ATTR(probe, S_IWUSR, NULL, cpu_probe_store);
>   static DEVICE_ATTR(release, S_IWUSR, NULL, cpu_release_store);
>   #endif /* CONFIG_ARCH_CPU_PROBE_RELEASE */
> -=20
>   #endif /* CONFIG_HOTPLUG_CPU */
>  =20
>  +struct bus_type cpu_subsys =3D {
>  +	.name =3D "cpu",
>  +	.dev_name =3D "cpu",
>  +	.match =3D cpu_subsys_match,
>  +#ifdef CONFIG_HOTPLUG_CPU
>  +	.online =3D cpu_subsys_online,
>  +	.offline =3D cpu_subsys_offline,
>  +#endif
>  +};
>  +EXPORT_SYMBOL_GPL(cpu_subsys);
>  +
>   #ifdef CONFIG_KEXEC
>   #include <linux/kexec.h>

OK, after doing that I got this error:

drivers/base/cpu.c:75:3: error: 'dev_attr_online' undeclared here (not in a=
 function)
  &dev_attr_online.attr,
   ^

So I applied this merge fix patch:

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 811bb5a..ff97614 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -71,15 +71,6 @@ static int cpu_subsys_offline(struct device *dev)
 	return ret;
 }
=20
-static struct attribute *hotplug_cpu_attrs[] =3D {
-	&dev_attr_online.attr,
-	NULL
-};
-
-static struct attribute_group hotplug_cpu_attr_group =3D {
-	.attrs =3D hotplug_cpu_attrs,
-};
-
 void unregister_cpu(struct cpu *cpu)
 {
 	int logical_cpu =3D cpu->dev.id;
@@ -182,9 +173,6 @@ static const struct attribute_group *hotplugable_cpu_at=
tr_groups[] =3D {
 #ifdef CONFIG_KEXEC
 	&crash_note_cpu_attr_group,
 #endif
-#ifdef CONFIG_HOTPLUG_CPU
-	&hotplug_cpu_attr_group,
-#endif
 	NULL
 };
=20
Better ideas welcome :-)
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__22_May_2013_14_02_13_+1000_sqW7ynx/Kpb6QE26
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRnENJAAoJEECxmPOUX5FEcc4P/iSEw092vSo32cOHvJULM1QJ
Z2wP8b4NT6FIACzp/fpAo2TgCFIjOCRHr+2U4nQnCivVPHhQoEfxbcGTxEt1nYkQ
xSX5CfOMFAUmdl4N++w0HLm6p8i5hM+zMkaJqhOFDYPQeAInqPSRxMjcgSlG+m8H
eODsSKh9IIuNM/bxNkxUTCeJnlm3/8SRrfEvh72chaDIZ3amryiEZyEfRwQGRNnB
HlG4COhqa0xjHqKawz28JO53q4YwxvZD+T1hpE6XkidpHApdfGP1CTy+j9unzfe8
45vgUq6HB97lzsapLSHxVaUjpQGoykiCyHe5GdjSx9ySFY5j+EjXRnwF7EUbf3BS
90lLEbe+vxKr0YvI4AD6VRsm3UEPQI504rc1OQBW8hKHmXYHj7yhm3vodgaY8r6E
uqYpdCzH0Ntfa/RN8JLntSEBRVYlg0jsKWkkpwVi18xzyFy1CTZWdYSFVibAwFLP
yzJXSqIEzTeXvVByLdtGgZPNHo2jOB2QrV/eWzOoamsGMF6hybPIM5H/WqdTk5lA
oejAGB3YFQnHxboJUA+D0VLykeJf0GP0I2nzruK1qizwFlg6p9Ghj67ZYEIiwc4Y
gFJL/tXPIWO2tj73FMpip8n8C7cKRiTH85UDG5KBO+ArBTMpnVY+AsCD/nz7yxg2
ke3JWiYBHEzoCcINEMS4
=ZmTt
-----END PGP SIGNATURE-----

--Signature=_Wed__22_May_2013_14_02_13_+1000_sqW7ynx/Kpb6QE26--
