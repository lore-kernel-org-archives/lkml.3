Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341AbaIJNEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 09:04:43 -0400
Received: from service87.mimecast.com ([91.220.42.44]:48563 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbaIJNEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 09:04:40 -0400
Date: Wed, 10 Sep 2014 14:04:32 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>
Subject: Re: [PATCH v10 07/10] OF: Introduce helper function for getting PCI
 domain_nr
Message-ID: <20140910130432.GB27864@e106497-lin.cambridge.arm.com>
References: <1410184472-17630-1-git-send-email-Liviu.Dudau@arm.com>
 <1410184472-17630-8-git-send-email-Liviu.Dudau@arm.com>
 <CAL_JsqJi8k1Goc3UmXhuxf9v7=4gJrYG_Di7v574PxS8TsJaXw@mail.gmail.com>
 <20140908145459.GO27864@e106497-lin.cambridge.arm.com>
 <CAL_JsqJdGKDVwJOpPp19OkVPGzR7Zqv3nh+ONHHaYnPLYTYoYg@mail.gmail.com>
 <20140908155931.GP27864@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
In-Reply-To: <20140908155931.GP27864@e106497-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 10 Sep 2014 13:04:33.0624 (UTC) FILETIME=[C41CBD80:01CFCCF7]
X-MC-Unique: 114091014043511901
Content-Type: multipart/mixed; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 08, 2014 at 04:59:31PM +0100, Liviu Dudau wrote:
> On Mon, Sep 08, 2014 at 04:27:36PM +0100, Rob Herring wrote:
> > On Mon, Sep 8, 2014 at 9:54 AM, Liviu Dudau <Liviu.Dudau@arm.com> wrote=
:
> > > On Mon, Sep 08, 2014 at 03:27:56PM +0100, Rob Herring wrote:
> > >> On Mon, Sep 8, 2014 at 8:54 AM, Liviu Dudau <Liviu.Dudau@arm.com> wr=
ote:
> > >> > Add of_pci_get_domain_nr() to retrieve the PCI domain number
> > >> > of a given device from DT. If the information is not present,
> > >> > the function can be requested to allocate a new domain number.
> > >> >
> > >> > Cc: Bjorn Helgaas <bhelgaas@google.com>
> > >> > Cc: Arnd Bergmann <arnd@arndb.de>
> > >> > Cc: Grant Likely <grant.likely@linaro.org>
> > >> > Cc: Rob Herring <robh+dt@kernel.org>
> > >> > Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> > >> > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> > >> > ---
> > >> >  drivers/of/of_pci.c    | 34 ++++++++++++++++++++++++++++++++++
> > >> >  include/linux/of_pci.h |  7 +++++++
> > >> >  2 files changed, 41 insertions(+)
> > >> >
> > >> > diff --git a/drivers/of/of_pci.c b/drivers/of/of_pci.c
> > >> > index 8481996..a107edb 100644
> > >> > --- a/drivers/of/of_pci.c
> > >> > +++ b/drivers/of/of_pci.c
> > >> > @@ -89,6 +89,40 @@ int of_pci_parse_bus_range(struct device_node *=
node, struct resource *res)
> > >> >  }
> > >> >  EXPORT_SYMBOL_GPL(of_pci_parse_bus_range);
> > >> >
> > >> > +static atomic_t of_domain_nr =3D ATOMIC_INIT(-1);
> > >> > +
> > >> > +/**
> > >> > + * This function will try to obtain the host bridge domain number=
 by
> > >> > + * using of_alias_get_id() call with "pci-domain" as a stem. If t=
hat
> > >> > + * fails, a local allocator will be used. The local allocator can
> > >> > + * be requested to return a new domain_nr if the information is m=
issing
> > >> > + * from the device tree.
> > >> > + *
> > >> > + * @node: device tree node with the domain information
> > >> > + * @allocate_if_missing: if DT lacks information about the domain=
 nr,
> > >> > + * allocate a new number.
> > >> > + *
> > >> > + * Returns the associated domain number from DT, or a new domain =
number
> > >> > + * if DT information is missing and @allocate_if_missing is true.=
 If
> > >> > + * @allocate_if_missing is false then the last allocated domain n=
umber
> > >> > + * will be returned.
> > >> > + */
> > >> > +int of_pci_get_domain_nr(struct device_node *node, bool allocate_=
if_missing)
> > >> > +{
> > >> > +       int domain;
> > >> > +
> > >> > +       domain =3D of_alias_get_id(node, "pci-domain");
> > >> > +       if (domain =3D=3D -ENODEV) {
> > >> > +               if (allocate_if_missing)
> > >> > +                       domain =3D atomic_inc_return(&of_domain_nr=
);
> > >> > +               else
> > >> > +                       domain =3D atomic_read(&of_domain_nr);
> > >>
> > >> This function seems a bit broken to me. It is overloaded with too ma=
ny
> > >> different outcomes. Think about how this would work if you have
> > >> multiple PCI buses and a mixture of having pci-domain aliases or not=
.
> > >> Aren't domain numbers global? Allocation should then start outside o=
f
> > >> the range of alias ids.
> > >>
> > >> Rob
> > >>
> > >
> > > Rob,
> > >
> > > Would this version make more sense?
> >=20
> > No.
> >=20

Hi Rob,

Here is an updated version of the patch. I have implemented a separate func=
tion
for getting the max domain number from the device tree and use the result a=
s
the start value + 1 for the allocator.

Best regards,
Liviu

--=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    =C2=AF\_(=E3=83=84)_/=C2=AF
--d6Gm4EdcadzBjdND
Content-Type: text/x-diff; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="0001-OF-Introduce-helper-function-for-getting-PCI-domain_.patch"

>From 77257fceaa8fbd74d6132fcf57c3af14bd48c0ae Mon Sep 17 00:00:00 2001
From: Liviu Dudau <Liviu.Dudau@arm.com>
Date: Mon, 4 Aug 2014 17:03:04 +0100
Subject: [PATCH v10 07/10] OF: Introduce helper function for getting PCI do=
main_nr

Add of_pci_get_domain_nr() to retrieve the PCI domain number
of a given device from DT. If the information is not present,
the function can be requested to allocate a new domain number.

Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
---
 drivers/of/of_pci.c    | 62 ++++++++++++++++++++++++++++++++++++++++++++++=
++++
 include/linux/of_pci.h |  7 ++++++
 2 files changed, 69 insertions(+)

diff --git a/drivers/of/of_pci.c b/drivers/of/of_pci.c
index 8481996..3560401 100644
--- a/drivers/of/of_pci.c
+++ b/drivers/of/of_pci.c
@@ -3,6 +3,8 @@
 #include <linux/of.h>
 #include <linux/of_pci.h>
=20
+#include "of_private.h"
+
 static inline int __of_pci_pci_compare(struct device_node *node,
 =09=09=09=09       unsigned int data)
 {
@@ -89,6 +91,66 @@ int of_pci_parse_bus_range(struct device_node *node, str=
uct resource *res)
 }
 EXPORT_SYMBOL_GPL(of_pci_parse_bus_range);
=20
+static atomic_t of_domain_nr =3D ATOMIC_INIT(-1);
+
+/*
+ * Get the maximum value for a domain number from the device tree
+ */
+static int of_get_max_pci_domain_nr(void)
+{
+=09struct alias_prop *app;
+=09int max_domain =3D -1;
+
+=09mutex_lock(&of_mutex);
+=09list_for_each_entry(app, &aliases_lookup, link) {
+=09=09if (strncmp(app->stem, "pci-domain", 10) !=3D 0)
+=09=09=09continue;
+
+=09=09max_domain =3D max(max_domain, app->id);
+=09}
+=09mutex_unlock(&of_mutex);
+
+=09return max_domain;
+}
+
+/**
+ * This function will try to obtain the host bridge domain number by
+ * using of_alias_get_id() call with "pci-domain" as a stem. If that
+ * fails, a local allocator will be used. The local allocator can
+ * be requested to return a new domain_nr if the information is missing
+ * from the device tree.
+ *
+ * @node: device tree node with the domain information
+ * @allocate_if_missing: if DT lacks information about the domain nr,
+ * allocate a new number.
+ *
+ * Returns the associated domain number from DT, or a new domain number
+ * if DT information is missing and @allocate_if_missing is true. If
+ * @allocate_if_missing is false then the last allocated domain number
+ * will be returned.
+ */
+int of_pci_get_domain_nr(struct device_node *node, bool allocate_if_missin=
g)
+{
+=09int domain;
+
+=09domain =3D atomic_read(&of_domain_nr);
+=09if (of_domain_nr =3D=3D -1) {
+=09=09/* first run, get max defined domain nr in device tree */
+=09=09domain =3D of_get_max_pci_domain_nr();
+=09=09/* then set the start value for allocator to be max + 1 */
+=09=09atomic_set(&of_domain_nr, domain + 1);
+=09}
+=09domain =3D of_alias_get_id(node, "pci-domain");
+=09if (domain =3D=3D -ENODEV) {
+=09=09domain =3D atomic_read(&of_domain_nr);
+=09=09if (allocate_if_missing)
+=09=09=09atomic_inc(&of_domain_nr);
+=09}
+
+=09return domain;
+}
+EXPORT_SYMBOL_GPL(of_pci_get_domain_nr);
+
 #ifdef CONFIG_PCI_MSI
=20
 static LIST_HEAD(of_pci_msi_chip_list);
diff --git a/include/linux/of_pci.h b/include/linux/of_pci.h
index dde3a4a..3a3824c 100644
--- a/include/linux/of_pci.h
+++ b/include/linux/of_pci.h
@@ -15,6 +15,7 @@ struct device_node *of_pci_find_child_device(struct devic=
e_node *parent,
 int of_pci_get_devfn(struct device_node *np);
 int of_irq_parse_and_map_pci(const struct pci_dev *dev, u8 slot, u8 pin);
 int of_pci_parse_bus_range(struct device_node *node, struct resource *res)=
;
+int of_pci_get_domain_nr(struct device_node *node, bool allocate_if_missin=
g);
 #else
 static inline int of_irq_parse_pci(const struct pci_dev *pdev, struct of_p=
handle_args *out_irq)
 {
@@ -43,6 +44,12 @@ of_pci_parse_bus_range(struct device_node *node, struct =
resource *res)
 {
 =09return -EINVAL;
 }
+
+static inline int
+of_pci_get_domain_nr(struct device_node *node, bool allocate_if_missing)
+{
+=09return -1;
+}
 #endif
=20
 #if defined(CONFIG_OF) && defined(CONFIG_PCI_MSI)
--=20
2.0.4

--d6Gm4EdcadzBjdND--

