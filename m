Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbaJARG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 13:06:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbaJARG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 13:06:27 -0400
Message-ID: <1412183174.7360.218.camel@ul30vt.home>
Subject: Re: linux-next: manual merge of the vfio tree with the pci tree
From: Alex Williamson <alex.williamson@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Yijing Wang <wangyijing@huawei.com>
Date: Wed, 01 Oct 2014 11:06:14 -0600
In-Reply-To: <20141001131421.64cab8d7@canb.auug.org.au>
References: <20141001131421.64cab8d7@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-01 at 13:14 +1000, Stephen Rothwell wrote:
> Hi Alex,
> 
> Today's linux-next merge of the vfio tree got a conflict in
> drivers/pci/msi.c between commits a160fe94cb53 ("PCI/MSI: Remove unused
> get_cached_msi_msg()") and 18ef822c59f6 ("PCI/MSI: Rename
> __get_cached_msi_msg() to get_cached_msi_msg()") from the pci tree and
> commit 3b307ffe3faa ("PCI: Export MSI message relevant functions") from
> the vfio tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).  And then I added this merge fix patch (I should probably
> also have added an include of linux/irq.h):

Hi Stephen,

Thanks for the heads-up and manual merge.  I've reviewed the changes to
the MSI API that got us into this conflict and I disagree with them.
I've posted a series to revert a selection of changes currently coming
in through pci/next that should make for a clean merge should Bjorn come
to the same conclusion.  If you need to re-apply the fix in the
meantime, please do include <linux/irq.h> since it generated a build
failure on arm without it.  Thanks!

Alex

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 1 Oct 2014 13:09:58 +1000
> Subject: [PATCH] vfio: update for get_cached_msi_msg API change
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/vfio/pci/vfio_pci_intrs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
> index 553212f037c3..a068bb0d69e5 100644
> --- a/drivers/vfio/pci/vfio_pci_intrs.c
> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> @@ -559,7 +559,7 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_device *vdev,
>  	if (msix) {
>  		struct msi_msg msg;
>  
> -		get_cached_msi_msg(irq, &msg);
> +		get_cached_msi_msg(irq_get_msi_desc(irq), &msg);
>  		write_msi_msg(irq, &msg);
>  	}
>  
> -- 
> 2.1.1
> 
> 
> Someone needs to remember to send this fix to Linus when these 2 trees
> are merged into his tree ...



