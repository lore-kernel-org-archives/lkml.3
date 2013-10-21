Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081Ab3JUJAm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:00:42 -0400
Received: from mx0.aculab.com ([213.249.233.131]:52894 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752817Ab3JUIxM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:53:12 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH RFC v2 29/29] vmxnet3: Make use of pcim_enable_msix_range() interface
Date: Mon, 21 Oct 2013 09:51:32 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B7398@saturn3.aculab.com>
In-Reply-To: <75788c5da384b16633fdab43d37a277aa92f38fd.1382103786.git.agordeev@redhat.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH RFC v2 29/29] vmxnet3: Make use of pcim_enable_msix_range() interface
Thread-Index: Ac7MlrECyupy0e7iR2aX0L91BqOCIwBo5uIA
References: <cover.1382103786.git.agordeev@redhat.com> <75788c5da384b16633fdab43d37a277aa92f38fd.1382103786.git.agordeev@redhat.com>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Alexander Gordeev" <agordeev@redhat.com>, <linux-kernel@vger.kernel.org>
Cc: "Bjorn Helgaas" <bhelgaas@google.com>,
        "Michael Ellerman" <michael@ellerman.id.au>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        "Tejun Heo" <tj@kernel.org>,
        "Ben Hutchings" <bhutchings@solarflare.com>,
        "Mark Lord" <kernel@start.ca>, "H. Peter Anvin" <hpa@zytor.com>,
        <linux-pci@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: [PATCH RFC v2 29/29] vmxnet3: Make use of pcim_enable_msix_range() interface
...
> diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
> index d33802c..e552d2b 100644
> --- a/drivers/net/vmxnet3/vmxnet3_drv.c
> +++ b/drivers/net/vmxnet3/vmxnet3_drv.c
> @@ -2735,39 +2735,19 @@ vmxnet3_read_mac_addr(struct vmxnet3_adapter *adapter, u8 *mac)
>   */
> 
>  static int
> -vmxnet3_acquire_msix_vectors(struct vmxnet3_adapter *adapter,
> -			     int vectors)
> +vmxnet3_acquire_msix_vectors(struct vmxnet3_adapter *adapter, int vectors)
>  {
> -	int err = -EINVAL, vector_threshold;
> -	vector_threshold = VMXNET3_LINUX_MIN_MSIX_VECT;
> -
> -	while (vectors >= vector_threshold) {
> -		err = pci_enable_msix(adapter->pdev, adapter->intr.msix_entries,
> -				      vectors);
> -		if (!err) {
> -			adapter->intr.num_intrs = vectors;
> -			return 0;
> -		} else if (err < 0) {
> -			dev_err(&adapter->netdev->dev,
> -				   "Failed to enable MSI-X, error: %d\n", err);
> -			return err;
> -		} else if (err < vector_threshold) {
> -			dev_info(&adapter->pdev->dev,
> -				 "Number of MSI-Xs which can be allocated "
> -				 "is lower than min threshold required.\n");
> -			return -ENOSPC;
> -		} else {
> -			/* If fails to enable required number of MSI-x vectors
> -			 * try enabling minimum number of vectors required.
> -			 */
> -			dev_err(&adapter->netdev->dev,
> -				"Failed to enable %d MSI-X, trying %d instead\n",
> -				    vectors, vector_threshold);
> -			vectors = vector_threshold;
> -		}
> +	vectors = pcim_enable_msix_range(adapter->pdev,
> +					 adapter->intr.msix_entries, vectors,
> +					 VMXNET3_LINUX_MIN_MSIX_VECT);
> +	if (vectors < 0) {
> +		dev_err(&adapter->netdev->dev,
> +			"Failed to enable MSI-X, error: %d\n", vectors);
> +		return vectors;
>  	}
> 
> -	return err;
> +	adapter->intr.num_intrs = vectors;
> +	return 0;
>  }

AFAICT the old code either used the requested number or the minimum number.
The new code seems to claim an intermediate number of interrupts - but probably
only uses the minimum number.
This wastes the last few MSI-X interrupts.
The code (especially the calling code) would be easier to read if the 'vectors'
value wasn't explicitly passed.

	David



