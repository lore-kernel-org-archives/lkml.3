Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927AbaDWH1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 03:27:43 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:41329 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031AbaDWH1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 03:27:41 -0400
Message-ID: <53576B68.70602@monstr.eu>
Date: Wed, 23 Apr 2014 09:27:36 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>, Lee Jones <lee.jones@linaro.org>
CC: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3] mfd: syscon: Support early initialization
References: <3eb785d83c406f4a57508dc03610b05492e12bfd.1396969250.git.michal.simek@xilinx.com> <53463824.3040606@samsung.com> <5346377C.1030606@monstr.eu>
In-Reply-To: <5346377C.1030606@monstr.eu>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="1BOacsRLws05hhDnmQw4qp8s1VQLtTr55"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1BOacsRLws05hhDnmQw4qp8s1VQLtTr55
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/10/2014 08:17 AM, Michal Simek wrote:
> On 04/10/2014 08:20 AM, Pankaj Dubey wrote:
>> Hi Michal,
>>
>> On 04/09/2014 12:00 AM, Michal Simek wrote:
>>> Some platforms need to get system controller
>>> ready as soon as possible.
>>> The patch provides early_syscon_initialization
>>> which create early mapping for all syscon compatible
>>> devices in early_syscon_probe.
>>> Regmap is get via syscon_early_regmap_lookup_by_phandle()
>>>
>>> Regular device probes attach device to regmap
>>> via regmap_attach_dev().
>>>
>>> For early syscon initialization is necessary to extend
>>> struct syscon and provide remove function
>>> which unmap all early init structures.
>>>
>>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>>> ---
>>>
>>> Changes in v3:
>>> - Keep backward compatibility for platform drivers and test it
>>> - Use only one probe method which is early_syscon_probe
>>>    suggested by Lee Jones. Do not force anybody to call early_syscon_=
init
>>> - Add kernel-doc description
>>>
>>> Changes in v2:
>>> - Fix bad logic in early_syscon_probe
>>> - Fix compilation failure for x86_64 reported by zero day testing sys=
tem
>>> - Regmap change available here
>>>    git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git t=
ags/nodev
>>>
>>>   drivers/mfd/syscon.c       | 159 ++++++++++++++++++++++++++++++++++=
++++++-----
>>>   include/linux/mfd/syscon.h |  11 ++++
>>>   2 files changed, 153 insertions(+), 17 deletions(-)
>>>
>>> diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
>>> index 71841f9..8e2ff88 100644
>>> --- a/drivers/mfd/syscon.c
>>> +++ b/drivers/mfd/syscon.c
>>> @@ -20,12 +20,15 @@
>>>   #include <linux/of_platform.h>
>>>   #include <linux/platform_device.h>
>>>   #include <linux/regmap.h>
>>> +#include <linux/slab.h>
>>>   #include <linux/mfd/syscon.h>
>>>
>>>   static struct platform_driver syscon_driver;
>>>
>>>   struct syscon {
>>> +    void __iomem *base;
>>>       struct regmap *regmap;
>>> +    struct resource res;
>>>   };
>>>
>>>   static int syscon_match_node(struct device *dev, void *data)
>>> @@ -95,6 +98,30 @@ struct regmap *syscon_regmap_lookup_by_pdevname(co=
nst char *s)
>>>   }
>>>   EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_pdevname);
>>>
>>> +/**
>>> + * syscon_early_regmap_lookup_by_phandle - Early phandle lookup func=
tion
>>> + * @np:        device_node pointer
>>> + * @property:    property name which handle system controller phandl=
e
>>> + * Return:    regmap pointer, an error pointer otherwise
>>> + */
>>> +struct regmap *syscon_early_regmap_lookup_by_phandle(struct device_n=
ode *np,
>>> +                             const char *property)
>>> +{
>>> +    struct device_node *syscon_np;
>>> +    struct syscon *syscon;
>>> +
>>> +    syscon_np =3D of_parse_phandle(np, property, 0);
>>> +    if (!syscon_np)
>>> +        return ERR_PTR(-ENODEV);
>>> +
>>> +    syscon =3D syscon_np->data;
>>> +
>>> +    of_node_put(syscon_np);
>>> +
>>> +    return syscon->regmap;
>>> +}
>>> +EXPORT_SYMBOL_GPL(syscon_early_regmap_lookup_by_phandle);
>>> +
>>>   struct regmap *syscon_regmap_lookup_by_phandle(struct device_node *=
np,
>>>                       const char *property)
>>>   {
>>> @@ -123,36 +150,118 @@ static struct regmap_config syscon_regmap_conf=
ig =3D {
>>>       .reg_stride =3D 4,
>>>   };
>>>
>>> -static int syscon_probe(struct platform_device *pdev)
>>> +/**
>>> + * early_syscon_probe - Early system controller probe method
>>> + * @np:        device_node pointer
>>> + * @syscon_p:    syscon pointer
>>> + * @res:    device IO resource
>>> + * Return:    0 if successful, a negative error code otherwise
>>> + */
>>> +static int early_syscon_probe(struct device_node *np, struct syscon =
**syscon_p,
>>> +                  struct resource *res)
>>>   {
>>> -    struct device *dev =3D &pdev->dev;
>>>       struct syscon *syscon;
>>> -    struct resource *res;
>>> -    void __iomem *base;
>>> +    int ret;
>>> +
>>> +    if (np && np->data) {
>>> +        pr_debug("Early syscon was called\n");
>>> +        *syscon_p =3D (struct syscon *)&np->data;
>>> +        return 0;
>>> +    }
>>>
>>> -    syscon =3D devm_kzalloc(dev, sizeof(*syscon), GFP_KERNEL);
>>> +    syscon =3D kzalloc(sizeof(*syscon), GFP_KERNEL);
>>>       if (!syscon)
>>>           return -ENOMEM;
>>>
>>> -    res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>> -    if (!res)
>>> -        return -ENOENT;
>>> +    *syscon_p =3D (struct syscon *)&syscon;
>>>
>>> -    base =3D devm_ioremap(dev, res->start, resource_size(res));
>>> -    if (!base)
>>> -        return -ENOMEM;
>>> +    if (!res && np) {
>>> +        if (of_address_to_resource(np, 0, &syscon->res)) {
>>> +            ret =3D -EINVAL;
>>> +            goto alloc;
>>> +        }
>>> +
>>> +        np->data =3D syscon;
>>> +        of_node_put(np);
>>> +    } else {
>>> +        syscon->res =3D *res;
>>> +    }
>>>
>>> -    syscon_regmap_config.max_register =3D res->end - res->start - 3;=

>>> -    syscon->regmap =3D devm_regmap_init_mmio(dev, base,
>>> -                    &syscon_regmap_config);
>>> +    syscon->base =3D ioremap(syscon->res.start, resource_size(&sysco=
n->res));
>>> +    if (!syscon->base) {
>>> +        pr_err("%s: Unable to map I/O memory\n", __func__);
>>> +        ret =3D PTR_ERR(syscon->base);
>>> +        goto alloc;
>>> +    }
>>> +
>>> +    syscon_regmap_config.max_register =3D syscon->res.end -
>>> +                        syscon->res.start - 3;
>>> +    syscon->regmap =3D regmap_init_mmio(NULL, syscon->base,
>>> +                      &syscon_regmap_config);
>>>       if (IS_ERR(syscon->regmap)) {
>>> -        dev_err(dev, "regmap init failed\n");
>>> -        return PTR_ERR(syscon->regmap);
>>> +        pr_err("regmap init failed\n");
>>> +        ret =3D PTR_ERR(syscon->regmap);
>>> +        goto iomap;
>>>       }
>>> +    if (np)
>>> +        pr_info("syscon: %s regmap %pR registered\n", np->name,
>>> +            &syscon->res);
>>> +
>>> +    return 0;
>>> +
>>> +iomap:
>>> +    iounmap(syscon->base);
>>> +alloc:
>>> +    kfree(syscon);
>>> +
>>> +    return ret;
>>> +}
>>> +
>>> +/**
>>> + * early_syscon_init - Early system controller initialization
>>> + */
>>> +void __init early_syscon_init(void)
>>> +{
>>> +    struct device_node *np;
>>> +    struct syscon *syscon =3D NULL;
>>> +
>>> +    for_each_matching_node_and_match(np, of_syscon_match, NULL) {
>>> +        if (early_syscon_probe(np, &syscon, NULL))
>>> +            BUG();
>>> +    }
>>> +}
>>> +
>>> +/**
>>> + * syscon_probe - System controller probe method
>>> + * @pdev:    Platform device
>>> + * Return:    0 if successful, a negative error code otherwise
>>> + */
>>> +static int syscon_probe(struct platform_device *pdev)
>>> +{
>>> +    struct syscon *syscon, *syscon_p;
>>> +    struct resource *res =3D NULL;
>>> +    struct device *dev =3D &pdev->dev;
>>> +    struct device_node *np =3D pdev->dev.of_node;
>>> +    int ret;
>>> +
>>> +    if (!np) {
>>> +        res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>> +        if (!res)
>>> +            return -ENOENT;
>>> +    }
>>> +    ret =3D early_syscon_probe(np, &syscon_p, res);
>>> +    if (ret) {
>>> +        dev_err(dev, "Syscon probe failed\n");
>>> +        return ret;
>>> +    }
>>> +
>>> +    syscon =3D *(struct syscon **)syscon_p;
>>> +
>>> +    regmap_attach_dev(dev, syscon->regmap, &syscon_regmap_config);
>>>
>>>       platform_set_drvdata(pdev, syscon);
>>>
>>> -    dev_info(dev, "regmap %pR registered\n", res);
>>> +    dev_info(dev, "regmap attach device to %pR\n", &syscon->res);
>>>
>>>       return 0;
>>>   }
>>> @@ -162,6 +271,21 @@ static const struct platform_device_id syscon_id=
s[] =3D {
>>>       { }
>>>   };
>>>
>>> +/**
>>> + * syscon_remove - System controller cleanup function
>>> + * @pdev:    Platform device
>>> + * Return:    0 always
>>> + */
>>> +static int syscon_remove(struct platform_device *pdev)
>>> +{
>>> +    struct syscon *syscon =3D platform_get_drvdata(pdev);
>>> +
>>> +    iounmap(syscon->base);
>>> +    kfree(syscon);
>>> +
>>> +    return 0;
>>> +}
>>> +
>>>   static struct platform_driver syscon_driver =3D {
>>>       .driver =3D {
>>>           .name =3D "syscon",
>>> @@ -169,6 +293,7 @@ static struct platform_driver syscon_driver =3D {=

>>>           .of_match_table =3D of_syscon_match,
>>>       },
>>>       .probe        =3D syscon_probe,
>>> +    .remove        =3D syscon_remove,
>>>       .id_table    =3D syscon_ids,
>>>   };
>>>
>>> diff --git a/include/linux/mfd/syscon.h b/include/linux/mfd/syscon.h
>>> index 8789fa3..465c092 100644
>>> --- a/include/linux/mfd/syscon.h
>>> +++ b/include/linux/mfd/syscon.h
>>> @@ -24,6 +24,10 @@ extern struct regmap *syscon_regmap_lookup_by_pdev=
name(const char *s);
>>>   extern struct regmap *syscon_regmap_lookup_by_phandle(
>>>                       struct device_node *np,
>>>                       const char *property);
>>> +extern struct regmap *syscon_early_regmap_lookup_by_phandle(
>>> +                    struct device_node *np,
>>> +                    const char *property);
>>> +extern void early_syscon_init(void);
>>>   #else
>>>   static inline struct regmap *syscon_node_to_regmap(struct device_no=
de *np)
>>>   {
>>> @@ -46,6 +50,13 @@ static inline struct regmap *syscon_regmap_lookup_=
by_phandle(
>>>   {
>>>       return ERR_PTR(-ENOSYS);
>>>   }
>>> +
>>> +static struct regmap *syscon_early_regmap_lookup_by_phandle(
>>> +                    struct device_node *np,
>>> +                    const char *property)
>>> +{
>>> +    return ERR_PTR(-ENOSYS);
>>> +}
>>>   #endif
>>>
>>>   #endif /* __LINUX_MFD_SYSCON_H__ */
>>> --=20
>>> 1.8.2.3
>>>
>> Thanks for CC'ing me.
>=20
> no problem.
>=20
>>
>> I have tested this patch along with Exynos PMU related changes posted =
here
>> https://lkml.org/lkml/2014/4/2/53 and modified it for using Syscon, an=
d it's working for me.
>=20
> great.
>=20
>=20
>> I have observed one issue during this testing:
>>
>> Even though we are saying early initialization I could not use "early_=
syscon_init" from machine's
>> "map_io" or "init_early". I observed that "early_syscon_init" failed t=
o called "early_syscon_probe",
>> because it can not get any matching node, when I debug further I found=
 that as "early_syscon_init"
>> is calling "for_each_matching_node_and_match" and it can't work before=
 unflatten'ing device tree,
>> which happens in "setup_arch" a bit late, after "map_io" and "init_ear=
ly" calls of machine.
>>
>> So if I have to use "early_syscon_init" I MUST call it after device tr=
ee is unflattened. It worked for me
>> when I called it from "init_machine" (from exynos_dt_machine_init), Bu=
t if someone needs it at very
>> early stage then it might not work. So how about using "of_scan_flat_d=
t" in "early_syscon_init"?, so that
>> we can use this functionality at very early stage if required.
>=20
> Yes you are right. I have discussed this with Arnd and for Zynq there i=
s no need to call it so early
> that's why using this function is fine. Arnd wasn't sure if there is an=
y need to call it before unflattening
> that's why I didn't try to solve this case.
>=20
> Can you send me that patch? I will test it on Zynq and if it is working=
, let's include it to v4.

Pankaj: Any update on this? I think that your patch can be applied on the=
 top of this one.

Lee: Can you please look at these changes?  It is around for a while and =
I would like to close it.

Thanks,
Michal



--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--1BOacsRLws05hhDnmQw4qp8s1VQLtTr55
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlNXa2gACgkQykllyylKDCFhiACfaZeAFIroor2drhkzf35+baVS
ipcAniF0lgnfT6E7+P0FqkPUrMkNNjMJ
=Vy41
-----END PGP SIGNATURE-----

--1BOacsRLws05hhDnmQw4qp8s1VQLtTr55--
