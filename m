Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbaBLKIh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 05:08:37 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.218]:52051 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbaBLKIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 05:08:35 -0500
X-RZG-AUTH: :JGIXVUS7cutRB/49FwqZ7WcKdUCnXG6JabOfSXKWrat9gNPpyI0=
X-RZG-CLASS-ID: mo00
From: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Content-Type: multipart/mixed; boundary=Apple-Mail-257--571841838
Subject: [PATCH 1 of 1]: musb: fixed a potential NULL pointer dereference.
Date: Wed, 12 Feb 2014 11:08:22 +0100
Message-Id: <AAE255E2-8388-48FD-B728-D633862DBFB4@goldelico.com>
Cc: Marek Belisko <marek@goldelico.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Mime-Version: 1.0 (Apple Message framework v1085)
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail-257--571841838
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

fixed a potential NULL pointer dereference.
    
    Rationale:
    this is the only location in the musb driver where the
    otg->gadget pointer is dereferenced. Assuming that it
    is never NULL is not only potentially unsafe but was
    observed in the wild on a GTA04 (OMAP3/TPS65950 based
    board) when trying to boot a device tree based 3.14-rc2
    kernel with USB cable plugged in.
    
    DT boot appears to modify the order in which components
    (gadget driver) are loaded and linked and therefore
    an early musb interrupt triggers with a NULL gadget
    pointer ending in a kernel panic.
    
    Since a non-existing gadget can never be "active" we
    simply use a 0 value for musb->is_active.
    
    Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>



--Apple-Mail-257--571841838
Content-Disposition: attachment;
	filename=0001-fixed-a-potential-NULL-pointer-dereference.patch
Content-Type: application/octet-stream;
	name="0001-fixed-a-potential-NULL-pointer-dereference.patch"
Content-Transfer-Encoding: quoted-printable

=46rom=20fecccbfe82a170c81dfb1820810d587def811f54=20Mon=20Sep=2017=20=
00:00:00=202001=0AFrom:=20"H.=20Nikolaus=20Schaller"=20=
<hns@goldelico.com>=0ADate:=20Wed,=2012=20Feb=202014=2010:35:21=20+0100=0A=
Subject:=20[PATCH]=20fixed=20a=20potential=20NULL=20pointer=20=
dereference.=0A=0ARationale:=0Athis=20is=20the=20only=20location=20in=20=
the=20musb=20driver=20where=20the=0Aotg->gadget=20pointer=20is=20=
dereferenced.=20Assuming=20that=20it=0Ais=20never=20NULL=20is=20not=20=
only=20potentially=20unsafe=20but=20was=0Aobserved=20in=20the=20wild=20=
on=20a=20GTA04=20(OMAP3/TPS65950=20based=0Aboard)=20when=20trying=20to=20=
boot=20a=20device=20tree=20based=203.14-rc2=0Akernel=20with=20USB=20=
cable=20plugged=20in.=0A=0ADT=20boot=20appears=20to=20modify=20the=20=
order=20in=20which=20components=0A(gadget=20driver)=20are=20loaded=20and=20=
linked=20and=20therefore=0Aan=20early=20musb=20interrupt=20triggers=20=
with=20a=20NULL=20gadget=0Apointer=20ending=20in=20a=20kernel=20panic.=0A=
=0ASince=20a=20non-existing=20gadget=20can=20never=20be=20"active"=20we=0A=
simply=20use=20a=200=20value=20for=20musb->is_active.=0A=0A=
Signed-off-by:=20H.=20Nikolaus=20Schaller=20<hns@goldelico.com>=0A---=0A=20=
drivers/usb/musb/musb_core.c=20|=20=20=20=203=20++-=0A=201=20files=20=
changed,=202=20insertions(+),=201=20deletions(-)=0A=0Adiff=20--git=20=
a/drivers/usb/musb/musb_core.c=20b/drivers/usb/musb/musb_core.c=0Aindex=20=
df3f65d..f68afef=20100644=0A---=20a/drivers/usb/musb/musb_core.c=0A+++=20=
b/drivers/usb/musb/musb_core.c=0A@@=20-653,7=20+653,8=20@@=20static=20=
irqreturn_t=20musb_stage0_irq(struct=20musb=20*musb,=20u8=20int_usb,=0A=20=
=09=09=09=09break;=0A=20=09=09case=20OTG_STATE_B_PERIPHERAL:=0A=20=09=09=09=
musb_g_suspend(musb);=0A-=09=09=09musb->is_active=20=3D=20=
otg->gadget->b_hnp_enable;=0A+=09=09=09musb->is_active=20=3D=0A+=09=09=09=
=09otg->gadget=20?=20otg->gadget->b_hnp_enable=20:=200;=0A=20=09=09=09if=20=
(musb->is_active)=20{=0A=20=09=09=09=09musb->xceiv->state=20=3D=20=
OTG_STATE_B_WAIT_ACON;=0A=20=09=09=09=09dev_dbg(musb->controller,=20=
"HNP:=20Setting=20timer=20for=20b_ase0_brst\n");=0A--=20=0A1.7.7.4=0A=0A=

--Apple-Mail-257--571841838--
