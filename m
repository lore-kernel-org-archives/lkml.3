Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab3KMFbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 00:31:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020Ab3KMFbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 00:31:41 -0500
Date: Tue, 12 Nov 2013 23:31:13 -0600
From: Clark Williams <williams@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: RT <linux-rt-users@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] 3.12.0-rt1: net: iwlwifi request only a threaded
 handler for interrupts
Message-ID: <20131112233113.3a5d043c@sluggy>
In-Reply-To: <20131112131659.578eb7c1@sluggy>
References: <20131112131659.578eb7c1@sluggy>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/QLe8xp2x9KG+RCwrBoVbFeK"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/QLe8xp2x9KG+RCwrBoVbFeK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 12 Nov 2013 13:16:59 -0600
Clark Williams <williams@redhat.com> wrote:

> Sebastian,
>=20
> I needed this for my laptop on 3.12, so tweaked it to apply properly.=20
>=20
> Clark
>

So of course I sent the wrong patch:

commit 49d487614d56bc10969dd0dcbce709825fc06d0e
Author: Clark Williams <clark.williams@gmail.com>
Date:   Tue Nov 12 12:17:07 2013 -0600

    net: iwlwifi: request only a threaded handler for interrupts
   =20
    On RT the trans_pcie->irq_lock lock is converted into a sleeping lock
    and can't be used in primary irq handler. The lock is used in mutliple
    places which means turning it into a raw lock could increase the
    latency of the system.
    For now both handlers are moved into the thread.
   =20
    Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    Signed-off-by: Clark Williams <clark.williams@gmail.com>

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wirele=
ss/iwlwifi/pcie/trans.c
index c3f904d..60df2c1 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1375,6 +1375,20 @@ static const struct iwl_trans_ops trans_ops_pcie =3D=
 {
        .set_bits_mask =3D iwl_trans_pcie_set_bits_mask,
 };
=20
+#ifdef CONFIG_PREEMPT_RT_BASE
+static irqreturn_t iwl_rt_irq_handler(int irq, void *dev_id)
+{
+       irqreturn_t ret;
+
+       local_bh_disable();
+       ret =3D iwl_pcie_isr_ict(irq, dev_id);
+       local_bh_enable();
+       if (ret =3D=3D IRQ_WAKE_THREAD)
+               ret =3D iwl_pcie_irq_handler(irq, dev_id);
+       return ret;
+}
+#endif
+
 struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
                                       const struct pci_device_id *ent,
                                       const struct iwl_cfg *cfg)
@@ -1493,9 +1507,15 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_de=
v *pdev,
        if (iwl_pcie_alloc_ict(trans))
                goto out_free_cmd_pool;
=20
+#ifdef CONFIG_PREEMPT_RT_BASE
+       err =3D request_threaded_irq(pdev->irq, NULL, iwl_rt_irq_handler,
+                                  IRQF_SHARED | IRQF_ONESHOT,=20
+                                  DRV_NAME, trans);
+#else
        err =3D request_threaded_irq(pdev->irq, iwl_pcie_isr_ict,
                                   iwl_pcie_irq_handler,
                                   IRQF_SHARED, DRV_NAME, trans);
+#endif
        if (err) {
                IWL_ERR(trans, "Error allocating IRQ %d\n", pdev->irq);
                goto out_free_ict;

--Sig_/QLe8xp2x9KG+RCwrBoVbFeK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlKDDqEACgkQHyuj/+TTEp2dpACcCuCyTkFA8DBEHlWNhskV4gwd
K/0AoKx3tBIjOg6SuaKRvw2sefObhGgT
=U3zV
-----END PGP SIGNATURE-----

--Sig_/QLe8xp2x9KG+RCwrBoVbFeK--
