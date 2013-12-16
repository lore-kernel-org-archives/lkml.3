Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567Ab3LPVDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 16:03:34 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:52175 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab3LPVDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 16:03:33 -0500
Date: Mon, 16 Dec 2013 14:03:27 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Lance Ortiz <lance.ortiz@hp.com>, Tony Luck <tony.luck@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 1/2] PCI, AER: Add a TLP header print helper
Message-ID: <20131216210327.GA28662@google.com>
References: <1386515571-23252-1-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386515571-23252-1-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 08, 2013 at 04:12:50PM +0100, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> ... and call it instead of duplicating the large printk format
> statement.
> 
> No functionality change.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>

I applied both of these to my pci/aer branch for v3.14, thanks!

Bjorn

> ---
>  drivers/pci/pcie/aer/aerdrv_errprint.c | 44 ++++++++++++++++------------------
>  1 file changed, 21 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/pci/pcie/aer/aerdrv_errprint.c b/drivers/pci/pcie/aer/aerdrv_errprint.c
> index 2c7c9f5f592c..32efc5e0d2eb 100644
> --- a/drivers/pci/pcie/aer/aerdrv_errprint.c
> +++ b/drivers/pci/pcie/aer/aerdrv_errprint.c
> @@ -124,6 +124,21 @@ static const char *aer_agent_string[] = {
>  	"Transmitter ID"
>  };
>  
> +static void __print_tlp_header(struct pci_dev *dev,
> +			       struct aer_header_log_regs *t)
> +{
> +	unsigned char *tlp = (unsigned char *)&t;
> +
> +	dev_err(&dev->dev, "  TLP Header:"
> +		" %02x%02x%02x%02x %02x%02x%02x%02x"
> +		" %02x%02x%02x%02x %02x%02x%02x%02x\n",
> +		*(tlp + 3), *(tlp + 2), *(tlp + 1), *tlp,
> +		*(tlp + 7), *(tlp + 6), *(tlp + 5), *(tlp + 4),
> +		*(tlp + 11), *(tlp + 10), *(tlp + 9),
> +		*(tlp + 8), *(tlp + 15), *(tlp + 14),
> +		*(tlp + 13), *(tlp + 12));
> +}
> +
>  static void __aer_print_error(struct pci_dev *dev,
>  			      struct aer_err_info *info)
>  {
> @@ -178,17 +193,8 @@ void aer_print_error(struct pci_dev *dev, struct aer_err_info *info)
>  
>  		__aer_print_error(dev, info);
>  
> -		if (info->tlp_header_valid) {
> -			unsigned char *tlp = (unsigned char *) &info->tlp;
> -			dev_err(&dev->dev, "  TLP Header:"
> -				" %02x%02x%02x%02x %02x%02x%02x%02x"
> -				" %02x%02x%02x%02x %02x%02x%02x%02x\n",
> -				*(tlp + 3), *(tlp + 2), *(tlp + 1), *tlp,
> -				*(tlp + 7), *(tlp + 6), *(tlp + 5), *(tlp + 4),
> -				*(tlp + 11), *(tlp + 10), *(tlp + 9),
> -				*(tlp + 8), *(tlp + 15), *(tlp + 14),
> -				*(tlp + 13), *(tlp + 12));
> -		}
> +		if (info->tlp_header_valid)
> +			__print_tlp_header(dev, &info->tlp);
>  	}
>  
>  	if (info->id && info->error_dev_num > 1 && info->id == id)
> @@ -250,18 +256,10 @@ void cper_print_aer(struct pci_dev *dev, int cper_severity,
>  	if (aer_severity != AER_CORRECTABLE)
>  		dev_err(&dev->dev, "aer_uncor_severity: 0x%08x\n",
>  		       aer->uncor_severity);
> -	if (tlp_header_valid) {
> -		const unsigned char *tlp;
> -		tlp = (const unsigned char *)&aer->header_log;
> -		dev_err(&dev->dev, "aer_tlp_header:"
> -			" %02x%02x%02x%02x %02x%02x%02x%02x"
> -			" %02x%02x%02x%02x %02x%02x%02x%02x\n",
> -			*(tlp + 3), *(tlp + 2), *(tlp + 1), *tlp,
> -			*(tlp + 7), *(tlp + 6), *(tlp + 5), *(tlp + 4),
> -			*(tlp + 11), *(tlp + 10), *(tlp + 9),
> -			*(tlp + 8), *(tlp + 15), *(tlp + 14),
> -			*(tlp + 13), *(tlp + 12));
> -	}
> +
> +	if (tlp_header_valid)
> +		__print_tlp_header(dev, &aer->header_log);
> +
>  	trace_aer_event(dev_name(&dev->dev), (status & ~mask),
>  			aer_severity);
>  }
> -- 
> 1.8.4
> 
