Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbaIEXed (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 19:34:33 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:46575 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbaIEXe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 19:34:27 -0400
Date: Fri, 5 Sep 2014 17:34:21 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: rdunlap@infradead.org, bp@alien8.de, tony.luck@intel.com,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND RFC 5/5] PCIe, AER: Update initial value of UC error mask
Message-ID: <20140905233421.GL8080@google.com>
References: <1407910961-7798-1-git-send-email-gong.chen@linux.intel.com>
 <1407910961-7798-6-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407910961-7798-6-git-send-email-gong.chen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 02:22:41AM -0400, Chen, Gong wrote:
> In PCI-e SPEC r3.0, BIT 0 of Uncorrectable Error Status Register
> is redefined and it has an explicit requirement that when writing
> this field, a value of 1b is the only choice. So change previous
> initial maks from 0 to 1.
> 
> Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
> ---
> NOTE: After scratching all use cases, this is the most obvious use
> case to violate the SPEC. Most of use cases just read first and
> then overwrite for clear purpose. Even so, such fix is obvious to
> not compatiable with previous SPEC definition. Do we need a dirty
> hack?
> 
>  arch/mips/pci/pci-octeon.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/mips/pci/pci-octeon.c b/arch/mips/pci/pci-octeon.c
> index 59cccd95688b..f1bfdc201297 100644
> --- a/arch/mips/pci/pci-octeon.c
> +++ b/arch/mips/pci/pci-octeon.c
> @@ -134,7 +134,7 @@ int pcibios_plat_dev_init(struct pci_dev *dev)
>  				       dconfig);
>  		/* Enable reporting of all uncorrectable errors */
>  		/* Uncorrectable Error Mask - turned on bits disable errors */
> -		pci_write_config_dword(dev, pos + PCI_ERR_UNCOR_MASK, 0);
> +		pci_write_config_dword(dev, pos + PCI_ERR_UNCOR_MASK, 1);

I see the text in the spec that says we should only write 1 to bit 0 (sec
7.10.3, for anybody following along).  It looks like that change was made
between PCIe r1.0 and r1.1.  It would really be nice to have more context
about why the change was made, because if there's hardware in the field
that implements r1.0 behavior, this patch will change the way it works, and
I don't know how to verify that is safe.

Does this actually change fix a problem?  If it fixes a problem that
happens on real hardware, that's a much better reason to make a change than
just to comply with the spec.

Sec 7.10.2 also says we should ignore the value of bit 0 in the
Uncorrectable Error Status register, and I don't see any place where we
follow that advice.

Bjorn

>  		 * Leave severity at HW default. This only controls if
>  		 * errors are reported as uncorrectable or
> -- 
> 2.0.0.rc2
> 
