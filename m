Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbaKXEdZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 23:33:25 -0500
Received: from ozlabs.org ([103.22.144.67]:49847 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbaKXEdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 23:33:23 -0500
Date: Mon, 24 Nov 2014 15:33:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Joerg Roedel <joro@8bytes.org>, Stephen Warren <swarren@nvidia.com>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Thierry Reding <treding@nvidia.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olav Haugan <ohaugan@codeaurora.org>
Subject: linux-next: manual merge of the iommu tree with the tegra tree
Message-ID: <20141124153310.61fc2202@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/AJxGmQ/5CkoDIsRRCgrdQp0"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/AJxGmQ/5CkoDIsRRCgrdQp0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Joerg,

Today's linux-next merge of the iommu tree got a conflict in
drivers/iommu/tegra-smmu.c between commit a2257374a4bd ("memory: Add
NVIDIA Tegra memory controller support") from the tegra tree and commit
315786ebbf4a ("iommu: Add iommu_map_sg() function") from the iommu tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/iommu/tegra-smmu.c
index 0909e0bae9ec,73e845a66925..000000000000
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@@ -535,187 -1049,248 +535,188 @@@ static int tegra_smmu_map(struct iommu_
  	return 0;
  }
 =20
 -static int smmu_debugfs_stats_open(struct inode *inode, struct file *file)
 +static size_t tegra_smmu_unmap(struct iommu_domain *domain, unsigned long=
 iova,
 +			       size_t size)
  {
 -	return single_open(file, smmu_debugfs_stats_show, inode->i_private);
 -}
 +	struct tegra_smmu_as *as =3D domain->priv;
 +	struct tegra_smmu *smmu =3D as->smmu;
 +	unsigned long offset;
 +	struct page *page;
 +	u32 *pte;
 =20
 -static const struct file_operations smmu_debugfs_stats_fops =3D {
 -	.open		=3D smmu_debugfs_stats_open,
 -	.read		=3D seq_read,
 -	.llseek		=3D seq_lseek,
 -	.release	=3D single_release,
 -	.write		=3D smmu_debugfs_stats_write,
 -};
 +	pte =3D as_get_pte(as, iova, &page);
 +	if (!pte)
 +		return 0;
 =20
 -static void smmu_debugfs_delete(struct smmu_device *smmu)
 -{
 -	debugfs_remove_recursive(smmu->debugfs_root);
 -	kfree(smmu->debugfs_info);
 +	offset =3D offset_in_page(pte);
 +	as_put_pte(as, iova);
 +
 +	smmu->soc->ops->flush_dcache(page, offset, 4);
 +	smmu_flush_ptc(smmu, page, offset);
 +	smmu_flush_tlb_group(smmu, as->id, iova);
 +	smmu_flush(smmu);
 +
 +	return size;
  }
 =20
 -static void smmu_debugfs_create(struct smmu_device *smmu)
 +static phys_addr_t tegra_smmu_iova_to_phys(struct iommu_domain *domain,
 +					   dma_addr_t iova)
  {
 -	int i;
 -	size_t bytes;
 -	struct dentry *root;
 -
 -	bytes =3D ARRAY_SIZE(smmu_debugfs_mc) * ARRAY_SIZE(smmu_debugfs_cache) *
 -		sizeof(*smmu->debugfs_info);
 -	smmu->debugfs_info =3D kmalloc(bytes, GFP_KERNEL);
 -	if (!smmu->debugfs_info)
 -		return;
 -
 -	root =3D debugfs_create_dir(dev_name(smmu->dev), NULL);
 -	if (!root)
 -		goto err_out;
 -	smmu->debugfs_root =3D root;
 -
 -	for (i =3D 0; i < ARRAY_SIZE(smmu_debugfs_mc); i++) {
 -		int j;
 -		struct dentry *mc;
 -
 -		mc =3D debugfs_create_dir(smmu_debugfs_mc[i], root);
 -		if (!mc)
 -			goto err_out;
 -
 -		for (j =3D 0; j < ARRAY_SIZE(smmu_debugfs_cache); j++) {
 -			struct dentry *cache;
 -			struct smmu_debugfs_info *info;
 -
 -			info =3D smmu->debugfs_info;
 -			info +=3D i * ARRAY_SIZE(smmu_debugfs_mc) + j;
 -			info->smmu =3D smmu;
 -			info->mc =3D i;
 -			info->cache =3D j;
 -
 -			cache =3D debugfs_create_file(smmu_debugfs_cache[j],
 -						    S_IWUGO | S_IRUGO, mc,
 -						    (void *)info,
 -						    &smmu_debugfs_stats_fops);
 -			if (!cache)
 -				goto err_out;
 -		}
 -	}
 +	struct tegra_smmu_as *as =3D domain->priv;
 +	struct page *page;
 +	unsigned long pfn;
 +	u32 *pte;
 =20
 -	return;
 +	pte =3D as_get_pte(as, iova, &page);
 +	pfn =3D *pte & SMMU_PFN_MASK;
 =20
 -err_out:
 -	smmu_debugfs_delete(smmu);
 +	return PFN_PHYS(pfn);
  }
 =20
 -static int tegra_smmu_suspend(struct device *dev)
 +static struct tegra_smmu *tegra_smmu_find(struct device_node *np)
  {
 -	struct smmu_device *smmu =3D dev_get_drvdata(dev);
 +	struct platform_device *pdev;
 +	struct tegra_mc *mc;
 =20
 -	smmu->translation_enable_0 =3D smmu_read(smmu, SMMU_TRANSLATION_ENABLE_0=
);
 -	smmu->translation_enable_1 =3D smmu_read(smmu, SMMU_TRANSLATION_ENABLE_1=
);
 -	smmu->translation_enable_2 =3D smmu_read(smmu, SMMU_TRANSLATION_ENABLE_2=
);
 -	smmu->asid_security =3D smmu_read(smmu, SMMU_ASID_SECURITY);
 -	return 0;
 +	pdev =3D of_find_device_by_node(np);
 +	if (!pdev)
 +		return NULL;
 +
 +	mc =3D platform_get_drvdata(pdev);
 +	if (!mc)
 +		return NULL;
 +
 +	return mc->smmu;
  }
 =20
 -static int tegra_smmu_resume(struct device *dev)
 +static int tegra_smmu_add_device(struct device *dev)
  {
 -	struct smmu_device *smmu =3D dev_get_drvdata(dev);
 -	unsigned long flags;
 -	int err;
 +	struct device_node *np =3D dev->of_node;
 +	struct of_phandle_args args;
 +	unsigned int index =3D 0;
 =20
 -	spin_lock_irqsave(&smmu->lock, flags);
 -	err =3D smmu_setup_regs(smmu);
 -	spin_unlock_irqrestore(&smmu->lock, flags);
 -	return err;
 +	while (of_parse_phandle_with_args(np, "iommus", "#iommu-cells", index,
 +					  &args) =3D=3D 0) {
 +		struct tegra_smmu *smmu;
 +
 +		smmu =3D tegra_smmu_find(args.np);
 +		if (smmu) {
 +			/*
 +			 * Only a single IOMMU master interface is currently
 +			 * supported by the Linux kernel, so abort after the
 +			 * first match.
 +			 */
 +			dev->archdata.iommu =3D smmu;
 +			break;
 +		}
 +
 +		index++;
 +	}
 +
 +	return 0;
  }
 =20
 -static int tegra_smmu_probe(struct platform_device *pdev)
 +static void tegra_smmu_remove_device(struct device *dev)
  {
 -	struct smmu_device *smmu;
 -	struct device *dev =3D &pdev->dev;
 -	int i, asids, err =3D 0;
 -	dma_addr_t uninitialized_var(base);
 -	size_t bytes, uninitialized_var(size);
 +	dev->archdata.iommu =3D NULL;
 +}
 =20
 -	if (smmu_handle)
 -		return -EIO;
 +static const struct iommu_ops tegra_smmu_ops =3D {
 +	.capable =3D tegra_smmu_capable,
 +	.domain_init =3D tegra_smmu_domain_init,
 +	.domain_destroy =3D tegra_smmu_domain_destroy,
 +	.attach_dev =3D tegra_smmu_attach_dev,
 +	.detach_dev =3D tegra_smmu_detach_dev,
 +	.add_device =3D tegra_smmu_add_device,
 +	.remove_device =3D tegra_smmu_remove_device,
 +	.map =3D tegra_smmu_map,
 +	.unmap =3D tegra_smmu_unmap,
++	.map_sg =3D default_iommu_map_sg,
 +	.iova_to_phys =3D tegra_smmu_iova_to_phys,
 =20
 -	BUILD_BUG_ON(PAGE_SHIFT !=3D SMMU_PAGE_SHIFT);
 +	.pgsize_bitmap =3D SZ_4K,
 +};
 =20
 -	if (of_property_read_u32(dev->of_node, "nvidia,#asids", &asids))
 -		return -ENODEV;
 +static void tegra_smmu_ahb_enable(void)
 +{
 +	static const struct of_device_id ahb_match[] =3D {
 +		{ .compatible =3D "nvidia,tegra30-ahb", },
 +		{ }
 +	};
 +	struct device_node *ahb;
 =20
 -	bytes =3D sizeof(*smmu) + asids * sizeof(*smmu->as);
 -	smmu =3D devm_kzalloc(dev, bytes, GFP_KERNEL);
 -	if (!smmu) {
 -		dev_err(dev, "failed to allocate smmu_device\n");
 -		return -ENOMEM;
 +	ahb =3D of_find_matching_node(NULL, ahb_match);
 +	if (ahb) {
 +		tegra_ahb_enable_smmu(ahb);
 +		of_node_put(ahb);
  	}
 +}
 =20
 -	smmu->nregs =3D pdev->num_resources;
 -	smmu->regs =3D devm_kzalloc(dev, 2 * smmu->nregs * sizeof(*smmu->regs),
 -				  GFP_KERNEL);
 -	smmu->rege =3D smmu->regs + smmu->nregs;
 -	if (!smmu->regs)
 -		return -ENOMEM;
 -	for (i =3D 0; i < smmu->nregs; i++) {
 -		struct resource *res;
 -
 -		res =3D platform_get_resource(pdev, IORESOURCE_MEM, i);
 -		smmu->regs[i] =3D devm_ioremap_resource(&pdev->dev, res);
 -		if (IS_ERR(smmu->regs[i]))
 -			return PTR_ERR(smmu->regs[i]);
 -		smmu->rege[i] =3D smmu->regs[i] + resource_size(res) - 1;
 -	}
 -	/* Same as "mc" 1st regiter block start address */
 -	smmu->regbase =3D (void __iomem *)((u32)smmu->regs[0] & PAGE_MASK);
 +struct tegra_smmu *tegra_smmu_probe(struct device *dev,
 +				    const struct tegra_smmu_soc *soc,
 +				    struct tegra_mc *mc)
 +{
 +	struct tegra_smmu *smmu;
 +	size_t size;
 +	u32 value;
 +	int err;
 =20
 -	err =3D of_get_dma_window(dev->of_node, NULL, 0, NULL, &base, &size);
 -	if (err)
 -		return -ENODEV;
 +	/* This can happen on Tegra20 which doesn't have an SMMU */
 +	if (!soc)
 +		return NULL;
 =20
 -	if (size & SMMU_PAGE_MASK)
 -		return -EINVAL;
 +	smmu =3D devm_kzalloc(dev, sizeof(*smmu), GFP_KERNEL);
 +	if (!smmu)
 +		return ERR_PTR(-ENOMEM);
 =20
 -	size >>=3D SMMU_PAGE_SHIFT;
 -	if (!size)
 -		return -EINVAL;
 +	/*
 +	 * This is a bit of a hack. Ideally we'd want to simply return this
 +	 * value. However the IOMMU registration process will attempt to add
 +	 * all devices to the IOMMU when bus_set_iommu() is called. In order
 +	 * not to rely on global variables to track the IOMMU instance, we
 +	 * set it here so that it can be looked up from the .add_device()
 +	 * callback via the IOMMU device's .drvdata field.
 +	 */
 +	mc->smmu =3D smmu;
 =20
 -	smmu->ahb =3D of_parse_phandle(dev->of_node, "nvidia,ahb", 0);
 -	if (!smmu->ahb)
 -		return -ENODEV;
 +	size =3D BITS_TO_LONGS(soc->num_asids) * sizeof(long);
 =20
 -	smmu->dev =3D dev;
 -	smmu->num_as =3D asids;
 -	smmu->iovmm_base =3D base;
 -	smmu->page_count =3D size;
 -
 -	smmu->translation_enable_0 =3D ~0;
 -	smmu->translation_enable_1 =3D ~0;
 -	smmu->translation_enable_2 =3D ~0;
 -	smmu->asid_security =3D 0;
 -
 -	for (i =3D 0; i < smmu->num_as; i++) {
 -		struct smmu_as *as =3D &smmu->as[i];
 -
 -		as->smmu =3D smmu;
 -		as->asid =3D i;
 -		as->pdir_attr =3D _PDIR_ATTR;
 -		as->pde_attr =3D _PDE_ATTR;
 -		as->pte_attr =3D _PTE_ATTR;
 -
 -		spin_lock_init(&as->lock);
 -		spin_lock_init(&as->client_lock);
 -		INIT_LIST_HEAD(&as->client);
 -	}
 -	spin_lock_init(&smmu->lock);
 -	err =3D smmu_setup_regs(smmu);
 -	if (err)
 -		return err;
 -	platform_set_drvdata(pdev, smmu);
 +	smmu->asids =3D devm_kzalloc(dev, size, GFP_KERNEL);
 +	if (!smmu->asids)
 +		return ERR_PTR(-ENOMEM);
 =20
 -	smmu->avp_vector_page =3D alloc_page(GFP_KERNEL);
 -	if (!smmu->avp_vector_page)
 -		return -ENOMEM;
 +	mutex_init(&smmu->lock);
 =20
 -	smmu_debugfs_create(smmu);
 -	smmu_handle =3D smmu;
 -	bus_set_iommu(&platform_bus_type, &smmu_iommu_ops);
 -	return 0;
 -}
 +	smmu->regs =3D mc->regs;
 +	smmu->soc =3D soc;
 +	smmu->dev =3D dev;
 +	smmu->mc =3D mc;
 =20
 -static int tegra_smmu_remove(struct platform_device *pdev)
 -{
 -	struct smmu_device *smmu =3D platform_get_drvdata(pdev);
 -	int i;
 +	value =3D SMMU_PTC_CONFIG_ENABLE | SMMU_PTC_CONFIG_INDEX_MAP(0x3f);
 =20
 -	smmu_debugfs_delete(smmu);
 +	if (soc->supports_request_limit)
 +		value |=3D SMMU_PTC_CONFIG_REQ_LIMIT(8);
 =20
 -	smmu_write(smmu, SMMU_CONFIG_DISABLE, SMMU_CONFIG);
 -	for (i =3D 0; i < smmu->num_as; i++)
 -		free_pdir(&smmu->as[i]);
 -	__free_page(smmu->avp_vector_page);
 -	smmu_handle =3D NULL;
 -	return 0;
 -}
 +	smmu_writel(smmu, value, SMMU_PTC_CONFIG);
 =20
 -static const struct dev_pm_ops tegra_smmu_pm_ops =3D {
 -	.suspend	=3D tegra_smmu_suspend,
 -	.resume		=3D tegra_smmu_resume,
 -};
 +	value =3D SMMU_TLB_CONFIG_HIT_UNDER_MISS |
 +		SMMU_TLB_CONFIG_ACTIVE_LINES(0x20);
 =20
 -static const struct of_device_id tegra_smmu_of_match[] =3D {
 -	{ .compatible =3D "nvidia,tegra30-smmu", },
 -	{ },
 -};
 -MODULE_DEVICE_TABLE(of, tegra_smmu_of_match);
 -
 -static struct platform_driver tegra_smmu_driver =3D {
 -	.probe		=3D tegra_smmu_probe,
 -	.remove		=3D tegra_smmu_remove,
 -	.driver =3D {
 -		.owner	=3D THIS_MODULE,
 -		.name	=3D "tegra-smmu",
 -		.pm	=3D &tegra_smmu_pm_ops,
 -		.of_match_table =3D tegra_smmu_of_match,
 -	},
 -};
 +	if (soc->supports_round_robin_arbitration)
 +		value |=3D SMMU_TLB_CONFIG_ROUND_ROBIN_ARBITRATION;
 =20
 -static int tegra_smmu_init(void)
 -{
 -	return platform_driver_register(&tegra_smmu_driver);
 -}
 +	smmu_writel(smmu, value, SMMU_TLB_CONFIG);
 =20
 -static void __exit tegra_smmu_exit(void)
 -{
 -	platform_driver_unregister(&tegra_smmu_driver);
 -}
 +	smmu_flush_ptc(smmu, NULL, 0);
 +	smmu_flush_tlb(smmu);
 +	smmu_writel(smmu, SMMU_CONFIG_ENABLE, SMMU_CONFIG);
 +	smmu_flush(smmu);
 +
 +	tegra_smmu_ahb_enable();
 =20
 -subsys_initcall(tegra_smmu_init);
 -module_exit(tegra_smmu_exit);
 +	err =3D bus_set_iommu(&platform_bus_type, &tegra_smmu_ops);
 +	if (err < 0)
 +		return ERR_PTR(err);
 =20
 -MODULE_DESCRIPTION("IOMMU API for SMMU in Tegra30");
 -MODULE_AUTHOR("Hiroshi DOYU <hdoyu@nvidia.com>");
 -MODULE_ALIAS("platform:tegra-smmu");
 -MODULE_LICENSE("GPL v2");
 +	return smmu;
 +}

--Sig_/AJxGmQ/5CkoDIsRRCgrdQp0
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUcrUQAAoJEMDTa8Ir7ZwVFoYP/ivdXdXaU+Y3Iz/lQsrWcOH7
qnqybCzLcXNZCNtQXNZn8VBSLAiuJPcgcRHHNFWCzhQX0yOhac7Ws0gAtEZk8iFJ
PqkCoJ+XavZP3CgKGrxhr4K+5OMk8x2lLjPMtmNt7LlR2LlenpgIsqhyjbvbRTyB
qClOzuj4mPJqB91muweNAspuYYv/lWGypPooZvL262xnLFm2uxxFQsCUqXlTV07s
7qOImOhm2+WoRKW3vm0JE4m0Nqv5ZF6jnPgZs5k3i5ARFO3gOPyTF2EqECjIx4Km
XlQC+Zlz4HXnsNsFe2sEQGYhG9y5hL2vke6we4eZ7+LG6cAs6s4IaiSMQGyUyoSQ
o1i4TBnoRMLL6rzegEqi3knLVSF8a947WAaynjGNguBxAO5jEw+i4mS8yq8qV/sK
4x/SWPs7I7OhUmiZN1Z5/VRJSSqfq9LYTLBHAHsQFvdvLBvZflodggy8GvHRetM0
tWYraDJktpJNMcAMwiTjbgZESTOuhkhK66gT5rpfzPS02HfaIAfZoCBuj9qty1qM
s/AxswRa9jP2R252F6HYqJ2GephvAeYXY6tqEMPjAVi+UQZZURxDc+FPJDMvcpCz
r8FqWI9SR+j2ML0/xTH7MGyWYjtx8HbUu2mB6UgpycCKlAWqaB4WHe2lTRhBTmf2
iYEAJPkHL6wRHdvBZkGE
=eba/
-----END PGP SIGNATURE-----

--Sig_/AJxGmQ/5CkoDIsRRCgrdQp0--
