Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbaJASgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 14:36:09 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:60109 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839AbaJASgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 14:36:07 -0400
Date: Wed, 1 Oct 2014 12:36:03 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        wangyijing@huawei.com
Subject: Re: [PATCH 0/3] Revert MSI msg API churn
Message-ID: <20141001183603.GA22713@google.com>
References: <20141001163814.2709.92885.stgit@gimli.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141001163814.2709.92885.stgit@gimli.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 10:48:16AM -0600, Alex Williamson wrote:
> The MSI message API has gone through some churn, that I think results
> in an inconsistent interface.  We now have this:
> 
> void read_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
> void get_cached_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
> void __write_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
> void write_msi_msg(unsigned int irq, struct msi_msg *msg);
> 
> write_msi_msg() takes an irq arg, but read_msi_msg() takes an
> msi_desc.  Presumably write_msi_msg() was not converted because it
> has a much larger user base, but this sort of inconsitency results
> in a poor API.

Yeah, that isn't good, thanks for noticing.

I rebuilt the pci/msi branch and dropped the commits you mentioned.
The ones that are left are these:

  56b72b409579 PCI/MSI: Use __write_msi_msg() instead of write_msi_msg()
  1e8f4cc82ede MSI/powerpc: Use __read_msi_msg() instead of read_msi_msg()
  2b260085e466 PCI/MSI: Use __get_cached_msi_msg() instead of get_cached_msi_msg()

which I think are OK.

> This series reverts a selection of commits to return us to:
> 
> void __read_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
> void __get_cached_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
> void __write_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
> void get_cached_msi_msg(unsigned int irq, struct msi_msg *msg);
> void write_msi_msg(unsigned int irq, struct msi_msg *msg);
> 
> I've left the removal of read_msi_msg() since it has no users, but
> restored get_cached_msi_msg() since it has an imminent user.  This
> will also cleanup the upcoming merge conflicts in next.  Thanks,
> 
> Alex
> 
> ---
> 
> Alex Williamson (3):
>       Revert "PCI/MSI: Remove unused get_cached_msi_msg()"
>       Revert "PCI/MSI: Rename __get_cached_msi_msg() to get_cached_msi_msg()"
>       Revert "PCI/MSI: Rename __read_msi_msg() to read_msi_msg()"
> 
> 
>  arch/ia64/kernel/msi_ia64.c          |    2 +-
>  arch/ia64/sn/kernel/msi_sn.c         |    2 +-
>  arch/powerpc/platforms/pseries/msi.c |    2 +-
>  arch/x86/kernel/apic/io_apic.c       |    2 +-
>  arch/x86/pci/xen.c                   |    2 +-
>  drivers/pci/msi.c                    |   11 +++++++++--
>  include/linux/msi.h                  |    5 +++--
>  7 files changed, 17 insertions(+), 9 deletions(-)
