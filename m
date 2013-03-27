Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab3C0PIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 11:08:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31049 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297Ab3C0PIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 11:08:15 -0400
Date: Wed, 27 Mar 2013 11:08:07 -0400
From: Kyle McMartin <kmcmarti@redhat.com>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        kexec@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 05/12] PCI: Require CAP_COMPROMISE_KERNEL for PCI BAR
 access
Message-ID: <20130327150807.GC14004@redacted.bos.redhat.com>
References: <1363642353-30749-1-git-send-email-matthew.garrett@nebula.com>
 <1363642353-30749-5-git-send-email-matthew.garrett@nebula.com>
 <CA+5PVA4VFgExGNrt5Yh+F4f48amAXKYAbdNFDy7VTFTguh6qTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA4VFgExGNrt5Yh+F4f48amAXKYAbdNFDy7VTFTguh6qTA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 11:03:26AM -0400, Josh Boyer wrote:
> On Mon, Mar 18, 2013 at 5:32 PM, Matthew Garrett
> <matthew.garrett@nebula.com> wrote:
> > Any hardware that can potentially generate DMA has to be locked down from
> > userspace in order to avoid it being possible for an attacker to cause
> > arbitrary kernel behaviour. Default to paranoid - in future we can
> > potentially relax this for sufficiently IOMMU-isolated devices.
> >
> > Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> 
> As noted here:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=908888
> 
> this breaks pci passthru with QEMU.  The suggestion in the bug is to move
> the check from read/write to open, but sysfs makes that somewhat
> difficult.  The open code is part of the core sysfs functionality shared
> with the majority of sysfs files, so adding a check there would restrict
> things that clearly don't need to be restricted.
> 
> Kyle had the idea to add a cap field to the attribute structure, and do
> a capable check if that is set.  That would allow for a more generic
> usage of capabilities in sysfs code, at the cost of slightly increasing
> the structure size and open path.  That seems somewhat promising if we
> stick with capabilities.
> 
> I would love to just squarely blame capabilities for causing this, but we
> can't just replace it with an efi_enabled(EFI_SECURE_BOOT) check because
> of the sysfs open case.  I'm not sure there are great answers here.
> 

Yeah, that was something like this (I don't even remember which Fedora
kernel version this was against.)

--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -546,9 +546,6 @@ pci_write_config(struct file* filp, struct kobject *kobj,
 	loff_t init_off = off;
 	u8 *data = (u8*) buf;
 
-	if (!capable(CAP_COMPROMISE_KERNEL))
-		return -EPERM;
-
 	if (off > dev->cfg_size)
 		return 0;
 	if (off + count > dev->cfg_size) {
@@ -772,6 +769,7 @@ void pci_create_legacy_files(struct pci_bus *b)
 	b->legacy_io->attr.name = "legacy_io";
 	b->legacy_io->size = 0xffff;
 	b->legacy_io->attr.mode = S_IRUSR | S_IWUSR;
+	b->legacy_io->attr.cap = CAP_COMPROMISE_KERNEL;
 	b->legacy_io->read = pci_read_legacy_io;
 	b->legacy_io->write = pci_write_legacy_io;
 	b->legacy_io->mmap = pci_mmap_legacy_io;
@@ -786,6 +784,7 @@ void pci_create_legacy_files(struct pci_bus *b)
 	b->legacy_mem->attr.name = "legacy_mem";
 	b->legacy_mem->size = 1024*1024;
 	b->legacy_mem->attr.mode = S_IRUSR | S_IWUSR;
+	b->legacy_io->attr.cap = CAP_COMPROMISE_KERNEL;
 	b->legacy_mem->mmap = pci_mmap_legacy_mem;
 	pci_adjust_legacy_attr(b, pci_mmap_mem);
 	error = device_create_bin_file(&b->dev, b->legacy_mem);
@@ -855,9 +854,6 @@ pci_mmap_resource(struct kobject *kobj, struct bin_attribute *attr,
 	resource_size_t start, end;
 	int i;
 
-	if (!capable(CAP_COMPROMISE_KERNEL))
-		return -EPERM;
-
 	for (i = 0; i < PCI_ROM_RESOURCE; i++)
 		if (res == &pdev->resource[i])
 			break;
@@ -965,9 +961,6 @@ pci_write_resource_io(struct file *filp, struct kobject *kobj,
 		      struct bin_attribute *attr, char *buf,
 		      loff_t off, size_t count)
 {
-	if (!capable(CAP_COMPROMISE_KERNEL))
-		return -EPERM;
-
 	return pci_resource_io(filp, kobj, attr, buf, off, count, true);
 }
 
@@ -1027,6 +1020,7 @@ static int pci_create_attr(struct pci_dev *pdev, int num, int write_combine)
 		}
 		res_attr->attr.name = res_attr_name;
 		res_attr->attr.mode = S_IRUSR | S_IWUSR;
+		res_attr->attr.cap = CAP_COMPROMISE_KERNEL;
 		res_attr->size = pci_resource_len(pdev, num);
 		res_attr->private = &pdev->resource[num];
 		retval = sysfs_create_bin_file(&pdev->dev.kobj, res_attr);
@@ -1142,6 +1136,7 @@ static struct bin_attribute pci_config_attr = {
 	.attr =	{
 		.name = "config",
 		.mode = S_IRUGO | S_IWUSR,
+		.cap  = CAP_COMPROMISE_KERNEL,
 	},
 	.size = PCI_CFG_SPACE_SIZE,
 	.read = pci_read_config,
@@ -1152,6 +1147,7 @@ static struct bin_attribute pcie_config_attr = {
 	.attr =	{
 		.name = "config",
 		.mode = S_IRUGO | S_IWUSR,
+		.cap  = CAP_COMPROMISE_KERNEL,
 	},
 	.size = PCI_CFG_SPACE_EXP_SIZE,
 	.read = pci_read_config,
@@ -1201,6 +1197,7 @@ static int pci_create_capabilities_sysfs(struct pci_dev *dev)
 		attr->size = dev->vpd->len;
 		attr->attr.name = "vpd";
 		attr->attr.mode = S_IRUSR | S_IWUSR;
+		attr->attr.cap = CAP_COMPROMISE_KERNEL;
 		attr->read = read_vpd_attr;
 		attr->write = write_vpd_attr;
 		retval = sysfs_create_bin_file(&dev->dev.kobj, attr);
diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index 614b2b5..e40a725 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -402,6 +402,10 @@ static int open(struct inode * inode, struct file * file)
 	if (!sysfs_get_active(attr_sd))
 		return -ENODEV;
 
+	error = -EACCES;
+	if (attr->attr.cap && !capable(attr->attr.cap))
+		goto err_out;
+
 	error = -EACCES;
 	if ((file->f_mode & FMODE_WRITE) && !(attr->write || attr->mmap))
 		goto err_out;
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 381f06d..0cf0034 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -26,6 +26,7 @@ enum kobj_ns_type;
 struct attribute {
 	const char		*name;
 	umode_t			mode;
+	int			cap;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	bool			ignore_lockdep:1;
 	struct lock_class_key	*key;
