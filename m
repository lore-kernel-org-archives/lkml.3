Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427Ab3LJWab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 17:30:31 -0500
Received: from mail-yh0-f51.google.com ([209.85.213.51]:57817 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab3LJWaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 17:30:25 -0500
Date: Tue, 10 Dec 2013 15:30:20 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 04/11] PCI/MSI/pSeries: Make quota traversing and
 requesting race-safe
Message-ID: <20131210223020.GF4699@google.com>
References: <cover.1385399393.git.agordeev@redhat.com>
 <97749db3e9562eb05fb3ee22a0be0ed7a93a0615.1385399393.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97749db3e9562eb05fb3ee22a0be0ed7a93a0615.1385399393.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 10:09:53AM +0100, Alexander Gordeev wrote:
> The current MSI quota handling is not race-safe and might lead
> to incoherent number of MSIs allocated between the firmware and
> Linux MSI data structures. I.e. if the following chain is called
> from concurrently loading drivers: rtas_setup_msi_irqs() ->
> msi_quota_for_device() -> traverse_pci_devices() a driver might
> get a stalled value of MSI limit for its device or possibly even
> crash.

Can you outline the race and the scenario that leads to incorrect results
or a crash?  I looked through rtas_setup_msi_irqs() (briefly) and I didn't
see the way that concurrent calls for different devices could interfere
with each other.

I was looking for some place that modifies state, where concurrent calls
might trample on each other, but it looks like msi_quota_for_device() is
pretty safe: it traverses a tree, but everything it computes is on the
stack and it doesn't seem to save results anywhere.  Maybe I'm barking up
the wrong tree?

Bjorn

> This update introduces "rtas_quota_mutex" and serializes all
> accesses to msi_quota_for_device() function. As result, no driver
> could eat into other device's MSI limit.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>  arch/powerpc/platforms/pseries/msi.c |   24 ++++++++++++++++++++++--
>  1 files changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/pseries/msi.c b/arch/powerpc/platforms/pseries/msi.c
> index 009ec73..0e1d288 100644
> --- a/arch/powerpc/platforms/pseries/msi.c
> +++ b/arch/powerpc/platforms/pseries/msi.c
> @@ -26,6 +26,8 @@ static int query_token, change_token;
>  #define RTAS_CHANGE_MSIX_FN	4
>  #define RTAS_CHANGE_32MSI_FN	5
>  
> +static DEFINE_MUTEX(rtas_quota_mutex);
> +
>  /* RTAS Helpers */
>  
>  static int rtas_change_msi(struct pci_dn *pdn, u32 func, u32 num_irqs)
> @@ -345,7 +347,9 @@ static int rtas_msi_check_device(struct pci_dev *pdev, int nvec, int type)
>  	if (rc)
>  		return rc;
>  
> +	mutex_lock(&rtas_quota_mutex);
>  	quota = msi_quota_for_device(pdev, nvec);
> +	mutex_unlock(&rtas_quota_mutex);
>  
>  	if (quota && quota < nvec)
>  		return quota;
> @@ -399,6 +403,7 @@ static int rtas_setup_msi_irqs(struct pci_dev *pdev, int nvec_in, int type)
>  	struct msi_msg msg;
>  	int nvec = nvec_in;
>  	int use_32bit_msi_hack = 0;
> +	int quota;
>  
>  	pdn = pci_get_pdn(pdev);
>  	if (!pdn)
> @@ -407,13 +412,21 @@ static int rtas_setup_msi_irqs(struct pci_dev *pdev, int nvec_in, int type)
>  	if (type == PCI_CAP_ID_MSIX && check_msix_entries(pdev))
>  		return -EINVAL;
>  
> +	mutex_lock(&rtas_quota_mutex);
> +
> +	quota = msi_quota_for_device(pdev, nvec);
> +	if (quota && quota < nvec) {
> +		mutex_unlock(&rtas_quota_mutex);
> +		return quota;
> +	}
> +
>  	/*
>  	 * Firmware currently refuse any non power of two allocation
>  	 * so we round up if the quota will allow it.
>  	 */
>  	if (type == PCI_CAP_ID_MSIX) {
>  		int m = roundup_pow_of_two(nvec);
> -		int quota = msi_quota_for_device(pdev, m);
> +		quota = msi_quota_for_device(pdev, m);
>  
>  		if (quota >= m)
>  			nvec = m;
> @@ -433,8 +446,11 @@ again:
>  				 * We only want to run the 32 bit MSI hack below if
>  				 * the max bus speed is Gen2 speed
>  				 */
> -				if (pdev->bus->max_bus_speed != PCIE_SPEED_5_0GT)
> +				if (pdev->bus->max_bus_speed !=
> +				    PCIE_SPEED_5_0GT) {
> +					mutex_unlock(&rtas_quota_mutex);
>  					return rc;
> +				}
>  
>  				use_32bit_msi_hack = 1;
>  			}
> @@ -459,6 +475,7 @@ again:
>  			nvec = nvec_in;
>  			goto again;
>  		}
> +		mutex_unlock(&rtas_quota_mutex);
>  		pr_debug("rtas_msi: rtas_change_msi() failed\n");
>  		return rc;
>  	}
> @@ -467,6 +484,7 @@ again:
>  	list_for_each_entry(entry, &pdev->msi_list, list) {
>  		hwirq = rtas_query_irq_number(pdn, i++);
>  		if (hwirq < 0) {
> +			mutex_unlock(&rtas_quota_mutex);
>  			pr_debug("rtas_msi: error (%d) getting hwirq\n", hwirq);
>  			return hwirq;
>  		}
> @@ -474,6 +492,7 @@ again:
>  		virq = irq_create_mapping(NULL, hwirq);
>  
>  		if (virq == NO_IRQ) {
> +			mutex_unlock(&rtas_quota_mutex);
>  			pr_debug("rtas_msi: Failed mapping hwirq %d\n", hwirq);
>  			return -ENOSPC;
>  		}
> @@ -486,6 +505,7 @@ again:
>  		entry->msg = msg;
>  	}
>  
> +	mutex_unlock(&rtas_quota_mutex);
>  	return 0;
>  }
>  
> -- 
> 1.7.7.6
> 
