Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760221Ab3CHDaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 22:30:11 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39033 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755655Ab3CHDaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 22:30:09 -0500
Message-ID: <1362713395.3768.466.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 008/153] powerpc/eeh: Fix crash when adding a device in a
 slot with DDW
From: Ben Hutchings <ben@decadent.org.uk>
To: Michael Neuling <mikey@neuling.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Fri, 08 Mar 2013 03:29:55 +0000
In-Reply-To: <CAEjGV6z-d2f6G_bozJmaeg7pmK71uM_JjBZ24KgijnjO1wv+4g@mail.gmail.com>
References: <20130304033707.648729212@decadent.org.uk>
	 <20130304033708.479195432@decadent.org.uk>
	 <CAEjGV6z-d2f6G_bozJmaeg7pmK71uM_JjBZ24KgijnjO1wv+4g@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-CbGo5TU3BeCi/TOQb3bs"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-CbGo5TU3BeCi/TOQb3bs
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2013-03-08 at 13:51 +1100, Michael Neuling wrote:
> This patch is breaking the celleb_defconfig on powerpc with:
>=20
> arch/powerpc/kernel/of_platform.c: In function 'of_pci_phb_probe':
> arch/powerpc/kernel/of_platform.c:95:2: error: implicit declaration of
> function 'eeh_add_sysfs_files' [-Werror=3Dimplicit-function-declaration]

In 3.2 this file doesn't (directly) include <asm/eeh.h> which is where
the definition was added.  In mainline it does.

Assuming that this change is actually required for 3.2 (which I'm not
sure about), I suppose we just need to add the #include.

Ben.

> Mikey
>=20
> On Mon, Mar 4, 2013 at 2:37 PM, Ben Hutchings <ben@decadent.org.uk> wrote=
:
> > 3.2-stable review patch.  If anyone has any objections, please let me k=
now.
> >
> > ------------------
> >
> > From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
> >
> > commit 6a040ce72598159a74969a2d01ab0ba5ee6536b3 upstream.
> >
> > The DDW code uses a eeh_dev struct from the pci_dev. However, this is
> > not set until eeh_add_device_late is called.
> >
> > Since pci_bus_add_devices is called before eeh_add_device_late, the PCI
> > devices are added to the bus, making drivers' probe hooks to be called.
> > These will call set_dma_mask, which will call the DDW code, which will
> > require the eeh_dev struct from pci_dev. This would result in a crash,
> > due to a NULL dereference.
> >
> > Calling eeh_add_device_late after pci_bus_add_devices would make the
> > system BUG, because device files shouldn't be added to devices there
> > were not added to the system. So, a new function is needed to add such
> > files only after pci_bus_add_devices have been called.
> >
> > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.c=
om>
> > Acked-by: Gavin Shan <shangw@linux.vnet.ibm.com>
> > Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > [bwh: Backported to 3.2: adjust context]
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > ---
> >  arch/powerpc/include/asm/eeh.h       |    3 +++
> >  arch/powerpc/kernel/of_platform.c    |    3 +++
> >  arch/powerpc/kernel/pci-common.c     |    7 +++++--
> >  arch/powerpc/platforms/pseries/eeh.c |   24 +++++++++++++++++++++++-
> >  4 files changed, 34 insertions(+), 3 deletions(-)
> >
> > --- a/arch/powerpc/include/asm/eeh.h
> > +++ b/arch/powerpc/include/asm/eeh.h
> > @@ -61,6 +61,7 @@ void __init pci_addr_cache_build(void);
> >   */
> >  void eeh_add_device_tree_early(struct device_node *);
> >  void eeh_add_device_tree_late(struct pci_bus *);
> > +void eeh_add_sysfs_files(struct pci_bus *);
> >
> >  /**
> >   * eeh_remove_device_recursive - undo EEH for device & children.
> > @@ -105,6 +106,8 @@ static inline void eeh_add_device_tree_e
> >
> >  static inline void eeh_add_device_tree_late(struct pci_bus *bus) { }
> >
> > +static inline void eeh_add_sysfs_files(struct pci_bus *bus) { }
> > +
> >  static inline void eeh_remove_bus_device(struct pci_dev *dev) { }
> >  #define EEH_POSSIBLE_ERROR(val, type) (0)
> >  #define EEH_IO_ERROR_VALUE(size) (-1UL)
> > --- a/arch/powerpc/kernel/of_platform.c
> > +++ b/arch/powerpc/kernel/of_platform.c
> > @@ -91,6 +91,9 @@ static int __devinit of_pci_phb_probe(st
> >         /* Add probed PCI devices to the device model */
> >         pci_bus_add_devices(phb->bus);
> >
> > +       /* sysfs files should only be added after devices are added */
> > +       eeh_add_sysfs_files(phb->bus);
> > +
> >         return 0;
> >  }
> >
> > --- a/arch/powerpc/kernel/pci-common.c
> > +++ b/arch/powerpc/kernel/pci-common.c
> > @@ -1536,11 +1536,14 @@ void pcibios_finish_adding_to_bus(struct
> >         pcibios_allocate_bus_resources(bus);
> >         pcibios_claim_one_bus(bus);
> >
> > +       /* Fixup EEH */
> > +       eeh_add_device_tree_late(bus);
> > +
> >         /* Add new devices to global lists.  Register in proc, sysfs. *=
/
> >         pci_bus_add_devices(bus);
> >
> > -       /* Fixup EEH */
> > -       eeh_add_device_tree_late(bus);
> > +       /* sysfs files should only be added after devices are added */
> > +       eeh_add_sysfs_files(bus);
> >  }
> >  EXPORT_SYMBOL_GPL(pcibios_finish_adding_to_bus);
> >
> > --- a/arch/powerpc/platforms/pseries/eeh.c
> > +++ b/arch/powerpc/platforms/pseries/eeh.c
> > @@ -1238,7 +1238,6 @@ static void eeh_add_device_late(struct p
> >         pdn->pcidev =3D dev;
> >
> >         pci_addr_cache_insert_device(dev);
> > -       eeh_sysfs_add_device(dev);
> >  }
> >
> >  void eeh_add_device_tree_late(struct pci_bus *bus)
> > @@ -1257,6 +1256,29 @@ void eeh_add_device_tree_late(struct pci
> >  EXPORT_SYMBOL_GPL(eeh_add_device_tree_late);
> >
> >  /**
> > + * eeh_add_sysfs_files - Add EEH sysfs files for the indicated PCI bus
> > + * @bus: PCI bus
> > + *
> > + * This routine must be used to add EEH sysfs files for PCI
> > + * devices which are attached to the indicated PCI bus. The PCI bus
> > + * is added after system boot through hotplug or dlpar.
> > + */
> > +void eeh_add_sysfs_files(struct pci_bus *bus)
> > +{
> > +       struct pci_dev *dev;
> > +
> > +       list_for_each_entry(dev, &bus->devices, bus_list) {
> > +               eeh_sysfs_add_device(dev);
> > +               if (dev->hdr_type =3D=3D PCI_HEADER_TYPE_BRIDGE) {
> > +                       struct pci_bus *subbus =3D dev->subordinate;
> > +                       if (subbus)
> > +                               eeh_add_sysfs_files(subbus);
> > +               }
> > +       }
> > +}
> > +EXPORT_SYMBOL_GPL(eeh_add_sysfs_files);
> > +
> > +/**
> >   * eeh_remove_device - undo EEH setup for the indicated pci device
> >   * @dev: pci device to be removed
> >   *
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel"=
 in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
>=20

--=20
Ben Hutchings
Always try to do things in chronological order;
it's less confusing that way.

--=-CbGo5TU3BeCi/TOQb3bs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUTlbM+e/yOyVhhEJAQpWhBAAtvchRlpGaL4pw+mqV+gRr0QgD9djlFP6
sTxDnsmpbv+7B7Ywj6TOOx9zACLNU04AIUtnbCwR517CRotOZ03Ptjm1EjKKXZkM
oa2E1fdF6TI3cBQ8lixRPppkm75pB2JFBABugWYAJw1f2f8VnlFOF337ypADG0k2
BPxCavJAA8T1JmTo7eQZnkLf4x4Z9tjnCdw5joVLm15rzKJLOYAcMJdNtM1KA0lm
rjNso7KykkWzp76ZZM6FtDrqFDQiRP82ZUMO7SMQPybbXCFA2h8Z841RNoLK6YLt
unQrquPDf8aTXSGzFQGM3KKz8Wey2npgru6pBlwdGOYiZcRUHGmbUchxWuW5htbA
0oknQmg3u9GRqq6m0DoRjMo4BVhXJd2MA4bHdTB1GXrmR2efOFKatk8umLjLly3j
UMdBIhMzzlxQMxnH417qu+j/b9eC0SJnRdI6OwQ8mAdhYR4AgtujPJa6t8HYEdnB
Qq/jMIHOOJAsoKMbf4ArvDxxtfjTjQAbRkQ6/EzN7wlwx6NJSycpJ8/tCqi/Y044
3KsVR/HZrip/fhGkzAY4Cz4vuobG/Pf8lt5BCsiorz1ACGul6SohfrcLvdZ/qYbP
mqr5Nd7PSTDuFbbNVOulQ38PSZ1RfQvSI3FHcUvcZ+KWUOZQ4nIm5MVixKsRCA6O
GpufLG3NUI0=
=nRdz
-----END PGP SIGNATURE-----

--=-CbGo5TU3BeCi/TOQb3bs--
