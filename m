Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509AbaIRDwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 23:52:39 -0400
Received: from ozlabs.org ([103.22.144.67]:54290 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757177AbaIRDwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 23:52:36 -0400
Date: Thu, 18 Sep 2014 13:52:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>
Subject: linux-next: manual merge of the kvm-arm tree with the kvm tree
Message-ID: <20140918135226.0526f91f@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/pnTntsZBMoKYY.FjVK.YVl2"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/pnTntsZBMoKYY.FjVK.YVl2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm-arm tree got a conflict in
virt/kvm/arm/vgic.c between commit c06a841bf363 ("KVM: ARM: vgic:
register kvm_device_ops dynamically") from the kvm tree and commit
de56fb1923ca ("KVM: vgic: declare probe function pointer as const")
from the kvm-arm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc virt/kvm/arm/vgic.c
index 3ee3ce06bbec,efe6eee2e7eb..000000000000
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@@ -1993,81 -2070,3 +1993,81 @@@ static struct kvm_device_ops kvm_arm_vg
  	.get_attr =3D vgic_get_attr,
  	.has_attr =3D vgic_has_attr,
  };
 +
 +static void vgic_init_maintenance_interrupt(void *info)
 +{
 +	enable_percpu_irq(vgic->maint_irq, 0);
 +}
 +
 +static int vgic_cpu_notify(struct notifier_block *self,
 +			   unsigned long action, void *cpu)
 +{
 +	switch (action) {
 +	case CPU_STARTING:
 +	case CPU_STARTING_FROZEN:
 +		vgic_init_maintenance_interrupt(NULL);
 +		break;
 +	case CPU_DYING:
 +	case CPU_DYING_FROZEN:
 +		disable_percpu_irq(vgic->maint_irq);
 +		break;
 +	}
 +
 +	return NOTIFY_OK;
 +}
 +
 +static struct notifier_block vgic_cpu_nb =3D {
 +	.notifier_call =3D vgic_cpu_notify,
 +};
 +
 +static const struct of_device_id vgic_ids[] =3D {
 +	{ .compatible =3D "arm,cortex-a15-gic", .data =3D vgic_v2_probe, },
 +	{ .compatible =3D "arm,gic-v3", .data =3D vgic_v3_probe, },
 +	{},
 +};
 +
 +int kvm_vgic_hyp_init(void)
 +{
 +	const struct of_device_id *matched_id;
- 	int (*vgic_probe)(struct device_node *,const struct vgic_ops **,
++	const int (*vgic_probe)(struct device_node *,const struct vgic_ops **,
 +			  const struct vgic_params **);
 +	struct device_node *vgic_node;
 +	int ret;
 +
 +	vgic_node =3D of_find_matching_node_and_match(NULL,
 +						    vgic_ids, &matched_id);
 +	if (!vgic_node) {
 +		kvm_err("error: no compatible GIC node found\n");
 +		return -ENODEV;
 +	}
 +
 +	vgic_probe =3D matched_id->data;
 +	ret =3D vgic_probe(vgic_node, &vgic_ops, &vgic);
 +	if (ret)
 +		return ret;
 +
 +	ret =3D request_percpu_irq(vgic->maint_irq, vgic_maintenance_handler,
 +				 "vgic", kvm_get_running_vcpus());
 +	if (ret) {
 +		kvm_err("Cannot register interrupt %d\n", vgic->maint_irq);
 +		return ret;
 +	}
 +
 +	ret =3D __register_cpu_notifier(&vgic_cpu_nb);
 +	if (ret) {
 +		kvm_err("Cannot register vgic CPU notifier\n");
 +		goto out_free_irq;
 +	}
 +
 +	/* Callback into for arch code for setup */
 +	vgic_arch_setup(vgic);
 +
 +	on_each_cpu(vgic_init_maintenance_interrupt, NULL, 1);
 +
 +	return kvm_register_device_ops(&kvm_arm_vgic_v2_ops,
 +				       KVM_DEV_TYPE_ARM_VGIC_V2);
 +
 +out_free_irq:
 +	free_percpu_irq(vgic->maint_irq, kvm_get_running_vcpus());
 +	return ret;
 +}

--Sig_/pnTntsZBMoKYY.FjVK.YVl2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUGlcCAAoJEMDTa8Ir7ZwV6N8P/39WW8ya2vYyvKY3lIW/IYoh
iNnCeUwyIzBG1e7Wun+0DZcI6KtEunSSiavlO0bWisuxWOyQJieRLhVHqxEU+iGw
AkiUAxSzlhWujK/qrSxbARmRDn80FS+j5Mhn31L+uxfG/jH7PlZJeLRWM8aHu4qP
5QDnSbQw2hIOYnHUQNn65nlaPhT4LyYI/IAcCMyUPF2VY8mu7PGln7q/+S26u8oU
2TxOEXWsKnlcXaFu65j9oYg8pCsNhetgZge6+vKciCIBtpVWJJer6evTuJn46x5i
5ms4OjEYneGfCHKUjiQH9DaW+Ww2zAt+mA3Uh57mqQz/MQ8uOjofT17LwjDH9bS+
vGPKrq+Ku1HUvnsGWEAPYlW1fR+FAkiz2+GORywH0NjTH1AHzKHoiLfTKg+IeJP0
SKU9eMTa/8Y3HgI5AvorI++JXxr0kdIHl2YPYG5Xj4JzwW7xXdq0JUoDRlKKIsUx
AzPTk9gk3Zim1wohfNbMIQNTlSdhG/2hWCFhtxgLRT8yLBd/K3A8mtuQPyylgTdC
VmECN7rfI9sZWAb+Xue7rXee+h4oOVHJLVneA1w6AvE8I25x1G5CkQKAjj5L3rFO
5P6UXkxbXbussn1jftuBEmRAIWtHAOWr2dkJnaQKIGikDG+qfApFqvnARlvgXiwF
ECDG4RATy5Durg5nHdUr
=ji/Z
-----END PGP SIGNATURE-----

--Sig_/pnTntsZBMoKYY.FjVK.YVl2--
