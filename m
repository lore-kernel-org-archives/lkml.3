Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbaJMMKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 08:10:52 -0400
Received: from service87.mimecast.com ([91.220.42.44]:37229 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbaJMMKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 08:10:50 -0400
Message-ID: <543BC138.3010109@arm.com>
Date: Mon, 13 Oct 2014 13:10:32 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Joe.C" <yingjoe.chen@mediatek.com>
CC: Mark Rutland <Mark.Rutland@arm.com>, "arm@kernel.org" <arm@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "srv_heupstream@mediatek.com" <srv_heupstream@mediatek.com>,
        "yingjoe.chen@gmail.com" <yingjoe.chen@gmail.com>,
        "hc.yen@mediatek.com" <hc.yen@mediatek.com>,
        "eddie.huang@mediatek.com" <eddie.huang@mediatek.com>,
        "nathan.chung@mediatek.com" <nathan.chung@mediatek.com>,
        "yh.chen@mediatek.com" <yh.chen@mediatek.com>,
        Sascha Hauer <kernel@pengutronix.de>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <Pawel.Moll@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Matt Porter <mporter@linaro.org>, Marc Carino <marc.ceeeee@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sricharan R <r.sricharan@ti.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/7] irqchip: gic: Support hierarchy irq domain.
References: <1412864980-20273-1-git-send-email-yingjoe.chen@mediatek.com>  <1412864980-20273-4-git-send-email-yingjoe.chen@mediatek.com>  <5436BF0C.1030508@arm.com> <1413196996.23455.9.camel@mtksdaap41>
In-Reply-To: <1413196996.23455.9.camel@mtksdaap41>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 13 Oct 2014 12:10:34.0265 (UTC) FILETIME=[B0EF8890:01CFE6DE]
X-MC-Unique: 114101313103401001
Content-Type: multipart/mixed;
 boundary="------------030407050101090003060102"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030407050101090003060102
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 13/10/14 11:43, Joe.C wrote:
> On Thu, 2014-10-09 at 17:59 +0100, Marc Zyngier wrote:
>> On 09/10/14 15:29, Joe.C wrote
>>> @@ -952,7 +988,11 @@ void __init gic_init_bases(unsigned int gic_nr, in=
t irq_start,
>>> =20
>>>  =09gic_irqs -=3D hwirq_base; /* calculate # of irqs to allocate */
>>> =20
>>> -=09if (of_property_read_u32(node, "arm,routable-irqs",
>>> +=09if (IS_ENABLED(CONFIG_IRQ_DOMAIN_HIERARCHY) &&
>>> +=09=09of_find_property(node, "arm,irq-domain-hierarchy", NULL))
>>> +=09=09gic->domain =3D irq_domain_add_linear(node, gic_irqs,
>>> +=09=09=09=09=09&gic_irq_domain_hierarchy_ops, gic);
>>
>> I really think that looking for a property is the wrong thing to do. If
>> "node" is non-NULL, then we're pretty sure that we're initializing from
>> DT, and that a pure linear domain should be the right thing, leaving the
>> legacy stuff for the few non-DT platforms that are still around.
>>
>> Thanks,
>>
>> =09M.
>=20
> The only reason I introduce "arm,irq-domain-hierarchy" property is
> trying to keep original behavior when hierarchy irq domain is not used.
> Without this, when a board init GIC with DT, all driver will have to use
> devicetree. I'm not sure we want to break things like this.

I don't think we want to support a "middle of the road" setup, where the
GIC is probed by DT, but some devices have hardcoded interrupts.

> I will remove this and just use linear for all DT in my next version.

I came up with the attached patch, which allows me to boot my test
platform (together with the other fix I posted earlier).

Thanks,

=09M.
--=20
Jazz is not dead. It just smells funny...
--------------030407050101090003060102
Content-Type: text/x-diff; 
	name=0001-fixup-irqchip-gic-Support-hierarchy-irq-domain.patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename*0="0001-fixup-irqchip-gic-Support-hierarchy-irq-domain.patch"

>From 97d4ea1f0922fb47dd1b09cd2694b7fa5b519db9 Mon Sep 17 00:00:00 2001
From: Marc Zyngier <marc.zyngier@arm.com>
Date: Mon, 13 Oct 2014 10:57:28 +0100
Subject: [PATCH] fixup! irqchip: gic: Support hierarchy irq domain.

---
 drivers/irqchip/Kconfig   |  1 +
 drivers/irqchip/irq-gic.c | 53 ++++++++++++++++++++++---------------------=
----
 2 files changed, 26 insertions(+), 28 deletions(-)

diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index b8632bf..2a48e0a 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -5,6 +5,7 @@ config IRQCHIP
 config ARM_GIC
 =09bool
 =09select IRQ_DOMAIN
+=09select IRQ_DOMAIN_HIERARCHY
 =09select MULTI_IRQ_HANDLER
=20
 config GIC_NON_BANKED
diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 17f5aa6..a99c211 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -835,8 +835,6 @@ static struct notifier_block gic_cpu_notifier =3D {
 };
 #endif
=20
-
-#ifdef CONFIG_IRQ_DOMAIN_HIERARCHY
 static int gic_irq_domain_alloc(struct irq_domain *domain, unsigned int vi=
rq,
 =09=09=09=09unsigned int nr_irqs, void *arg)
 {
@@ -870,10 +868,8 @@ static void gic_irq_domain_free(struct irq_domain *dom=
ain, unsigned int virq,
 static const struct irq_domain_ops gic_irq_domain_hierarchy_ops =3D {
 =09.alloc =3D gic_irq_domain_alloc,
 =09.free =3D gic_irq_domain_free,
+=09.xlate =3D gic_irq_domain_xlate,
 };
-#else
-#define gic_irq_domain_hierarchy_ops 0
-#endif /* CONFIG_IRQ_DOMAIN_HIERARCHY */
=20
 static const struct irq_domain_ops gic_irq_domain_ops =3D {
 =09.map =3D gic_irq_domain_map,
@@ -965,18 +961,6 @@ void __init gic_init_bases(unsigned int gic_nr, int ir=
q_start,
 =09=09gic_cpu_map[i] =3D 0xff;
=20
 =09/*
-=09 * For primary GICs, skip over SGIs.
-=09 * For secondary GICs, skip over PPIs, too.
-=09 */
-=09if (gic_nr =3D=3D 0 && (irq_start & 31) > 0) {
-=09=09hwirq_base =3D 16;
-=09=09if (irq_start !=3D -1)
-=09=09=09irq_start =3D (irq_start & ~31) + 16;
-=09} else {
-=09=09hwirq_base =3D 32;
-=09}
-
-=09/*
 =09 * Find out how many interrupts are supported.
 =09 * The GIC only supports up to 1020 interrupt sources.
 =09 */
@@ -986,14 +970,31 @@ void __init gic_init_bases(unsigned int gic_nr, int i=
rq_start,
 =09=09gic_irqs =3D 1020;
 =09gic->gic_irqs =3D gic_irqs;
=20
-=09gic_irqs -=3D hwirq_base; /* calculate # of irqs to allocate */
+=09if (node) {=09=09/* DT case */
+=09=09const struct irq_domain_ops *ops =3D &gic_irq_domain_hierarchy_ops;
+
+=09=09if (!of_property_read_u32(node, "arm,routable-irqs",
+=09=09=09=09=09  &nr_routable_irqs)) {
+=09=09=09ops =3D &gic_irq_domain_ops;
+=09=09=09gic_irqs =3D nr_routable_irqs;
+=09=09}
+
+=09=09gic->domain =3D irq_domain_add_linear(node, gic_irqs, ops, gic);
+=09} else {=09=09/* Non-DT case */
+=09=09/*
+=09=09 * For primary GICs, skip over SGIs.
+=09=09 * For secondary GICs, skip over PPIs, too.
+=09=09 */
+=09=09if (gic_nr =3D=3D 0 && (irq_start & 31) > 0) {
+=09=09=09hwirq_base =3D 16;
+=09=09=09if (irq_start !=3D -1)
+=09=09=09=09irq_start =3D (irq_start & ~31) + 16;
+=09=09} else {
+=09=09=09hwirq_base =3D 32;
+=09=09}
+
+=09=09gic_irqs -=3D hwirq_base; /* calculate # of irqs to allocate */
=20
-=09if (IS_ENABLED(CONFIG_IRQ_DOMAIN_HIERARCHY) &&
-=09=09of_find_property(node, "arm,irq-domain-hierarchy", NULL))
-=09=09gic->domain =3D irq_domain_add_linear(node, gic_irqs,
-=09=09=09=09=09&gic_irq_domain_hierarchy_ops, gic);
-=09else if (of_property_read_u32(node, "arm,routable-irqs",
-=09=09=09=09 &nr_routable_irqs)) {
 =09=09irq_base =3D irq_alloc_descs(irq_start, 16, gic_irqs,
 =09=09=09=09=09   numa_node_id());
 =09=09if (IS_ERR_VALUE(irq_base)) {
@@ -1004,10 +1005,6 @@ void __init gic_init_bases(unsigned int gic_nr, int =
irq_start,
=20
 =09=09gic->domain =3D irq_domain_add_legacy(node, gic_irqs, irq_base,
 =09=09=09=09=09hwirq_base, &gic_irq_domain_ops, gic);
-=09} else {
-=09=09gic->domain =3D irq_domain_add_linear(node, nr_routable_irqs,
-=09=09=09=09=09=09    &gic_irq_domain_ops,
-=09=09=09=09=09=09    gic);
 =09}
=20
 =09if (WARN_ON(!gic->domain))
--=20
2.0.4

--------------030407050101090003060102--

