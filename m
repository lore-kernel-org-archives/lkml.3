Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbaLEEjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 23:39:31 -0500
Received: from ozlabs.org ([103.22.144.67]:56833 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbaLEEj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 23:39:29 -0500
Date: Fri, 5 Dec 2014 15:39:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-ID: <20141205153921.342a0790@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/u9Ev/9lH4P5uc69YQ9jfuD4"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/u9Ev/9lH4P5uc69YQ9jfuD4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/nouveau/nouveau_drm.c between commit 8b62c8c6df08
("nouveau: move the hotplug ignore to correct place") from Linus' tree
and commit 7bb6d4428d3d ("drm/nouveau: move the (far too many...)
different s/r paths to the same place") from the drm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/nouveau/nouveau_drm.c
index 62b97c4eef8d,afb93bb72f97..000000000000
--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@@ -667,7 -647,30 +647,29 @@@ nouveau_do_resume(struct drm_device *de
  	return 0;
  }
 =20
- int nouveau_pmops_resume(struct device *dev)
+ int
+ nouveau_pmops_suspend(struct device *dev)
+ {
+ 	struct pci_dev *pdev =3D to_pci_dev(dev);
+ 	struct drm_device *drm_dev =3D pci_get_drvdata(pdev);
+ 	int ret;
+=20
+ 	if (drm_dev->switch_power_state =3D=3D DRM_SWITCH_POWER_OFF ||
+ 	    drm_dev->switch_power_state =3D=3D DRM_SWITCH_POWER_DYNAMIC_OFF)
+ 		return 0;
+=20
+ 	ret =3D nouveau_do_suspend(drm_dev, false);
+ 	if (ret)
+ 		return ret;
+=20
+ 	pci_save_state(pdev);
+ 	pci_disable_device(pdev);
 -	pci_ignore_hotplug(pdev);
+ 	pci_set_power_state(pdev, PCI_D3hot);
+ 	return 0;
+ }
+=20
+ int
+ nouveau_pmops_resume(struct device *dev)
  {
  	struct pci_dev *pdev =3D to_pci_dev(dev);
  	struct drm_device *drm_dev =3D pci_get_drvdata(pdev);
@@@ -701,6 -706,105 +705,106 @@@ nouveau_pmops_thaw(struct device *dev
  	return nouveau_do_resume(drm_dev, false);
  }
 =20
+ static int
+ nouveau_pmops_runtime_suspend(struct device *dev)
+ {
+ 	struct pci_dev *pdev =3D to_pci_dev(dev);
+ 	struct drm_device *drm_dev =3D pci_get_drvdata(pdev);
+ 	int ret;
+=20
+ 	if (nouveau_runtime_pm =3D=3D 0) {
+ 		pm_runtime_forbid(dev);
+ 		return -EBUSY;
+ 	}
+=20
+ 	/* are we optimus enabled? */
+ 	if (nouveau_runtime_pm =3D=3D -1 && !nouveau_is_optimus() && !nouveau_is=
_v1_dsm()) {
+ 		DRM_DEBUG_DRIVER("failing to power off - not optimus\n");
+ 		pm_runtime_forbid(dev);
+ 		return -EBUSY;
+ 	}
+=20
+ 	nv_debug_level(SILENT);
+ 	drm_kms_helper_poll_disable(drm_dev);
+ 	vga_switcheroo_set_dynamic_switch(pdev, VGA_SWITCHEROO_OFF);
+ 	nouveau_switcheroo_optimus_dsm();
+ 	ret =3D nouveau_do_suspend(drm_dev, true);
+ 	pci_save_state(pdev);
+ 	pci_disable_device(pdev);
++	pci_ignore_hotplug(pdev);
+ 	pci_set_power_state(pdev, PCI_D3cold);
+ 	drm_dev->switch_power_state =3D DRM_SWITCH_POWER_DYNAMIC_OFF;
+ 	return ret;
+ }
+=20
+ static int
+ nouveau_pmops_runtime_resume(struct device *dev)
+ {
+ 	struct pci_dev *pdev =3D to_pci_dev(dev);
+ 	struct drm_device *drm_dev =3D pci_get_drvdata(pdev);
+ 	struct nvif_device *device =3D &nouveau_drm(drm_dev)->device;
+ 	int ret;
+=20
+ 	if (nouveau_runtime_pm =3D=3D 0)
+ 		return -EINVAL;
+=20
+ 	pci_set_power_state(pdev, PCI_D0);
+ 	pci_restore_state(pdev);
+ 	ret =3D pci_enable_device(pdev);
+ 	if (ret)
+ 		return ret;
+ 	pci_set_master(pdev);
+=20
+ 	ret =3D nouveau_do_resume(drm_dev, true);
+ 	drm_kms_helper_poll_enable(drm_dev);
+ 	/* do magic */
+ 	nvif_mask(device, 0x88488, (1 << 25), (1 << 25));
+ 	vga_switcheroo_set_dynamic_switch(pdev, VGA_SWITCHEROO_ON);
+ 	drm_dev->switch_power_state =3D DRM_SWITCH_POWER_ON;
+ 	nv_debug_level(NORMAL);
+ 	return ret;
+ }
+=20
+ static int
+ nouveau_pmops_runtime_idle(struct device *dev)
+ {
+ 	struct pci_dev *pdev =3D to_pci_dev(dev);
+ 	struct drm_device *drm_dev =3D pci_get_drvdata(pdev);
+ 	struct nouveau_drm *drm =3D nouveau_drm(drm_dev);
+ 	struct drm_crtc *crtc;
+=20
+ 	if (nouveau_runtime_pm =3D=3D 0) {
+ 		pm_runtime_forbid(dev);
+ 		return -EBUSY;
+ 	}
+=20
+ 	/* are we optimus enabled? */
+ 	if (nouveau_runtime_pm =3D=3D -1 && !nouveau_is_optimus() && !nouveau_is=
_v1_dsm()) {
+ 		DRM_DEBUG_DRIVER("failing to power off - not optimus\n");
+ 		pm_runtime_forbid(dev);
+ 		return -EBUSY;
+ 	}
+=20
+ 	/* if we have a hdmi audio device - make sure it has a driver loaded */
+ 	if (drm->hdmi_device) {
+ 		if (!drm->hdmi_device->driver) {
+ 			DRM_DEBUG_DRIVER("failing to power off - no HDMI audio driver loaded\n=
");
+ 			pm_runtime_mark_last_busy(dev);
+ 			return -EBUSY;
+ 		}
+ 	}
+=20
+ 	list_for_each_entry(crtc, &drm->dev->mode_config.crtc_list, head) {
+ 		if (crtc->enabled) {
+ 			DRM_DEBUG_DRIVER("failing to power off - crtc active\n");
+ 			return -EBUSY;
+ 		}
+ 	}
+ 	pm_runtime_mark_last_busy(dev);
+ 	pm_runtime_autosuspend(dev);
+ 	/* we don't want the main rpm_idle to call suspend - we want to autosusp=
end */
+ 	return 1;
+ }
 =20
  static int
  nouveau_drm_open(struct drm_device *dev, struct drm_file *fpriv)

--Sig_/u9Ev/9lH4P5uc69YQ9jfuD4
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUgTb+AAoJEMDTa8Ir7ZwVW3oP/3CKmG022UJQBTinKFHlzxvQ
F+ppvYZCQayWxfYL8yGZ8anLJNM1MjOHaoXYSt+DvLIUyXRHrXf793qsznfY0VQm
m5PCRCcm4fpCAR8p0/kMwoKEA0WaiQ5q7QSsEZ2b2TwOaRKKH8wi30hKgDq7wLHG
iPRcPGGGkne1FZVV7yiRqVzct/8BpzQmwa8vktEsoMfmUCDxiPpD5r1ltE42e1TS
OPu0u0YGKWzJjPhgwn9b/v92cjrdKhz0XBpYSG1Ks7ly4ZEFl8xXhZjzR78b7+aB
Xs8IkPGqOlekKEQfwct88DVzLR3BbKlAOT76sASAMSJanXUyIKclg+to/jNy0kpc
eHdrjToOryVA1dl5nLSfNjaJxJ1xh0deXnWhtEW42zWwa7KtEiQyTju9jY/JavfA
LWvUUwsLCf8ClI7OFcnCJvvpPphTZvffJrV688QB62p3ulioTPsotDoJutZuS7HB
NL5T5XNcVxGCya4zN10MbGpsNJbJ4rW+O7MuY3Dm2nCP1+krgkFoCxZ5up/7As7d
nm3wmA+VSCCIJoVW5v7XXWVH19NCtY4qshPpGPHsa1PFspzKmvBiCSITTG3OOxiP
WNQ8j9fLv0kcCX1CMqrKxgP019RDol/Vnq58q18Q8Y8Cj5NFhFaXC7a57/FdNwtu
MKydZt/kuzqp3HH6NI6A
=DPdS
-----END PGP SIGNATURE-----

--Sig_/u9Ev/9lH4P5uc69YQ9jfuD4--
