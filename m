Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab3AaR0x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 12:26:53 -0500
Received: from mail-vb0-f44.google.com ([209.85.212.44]:48655 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab3AaR0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 12:26:48 -0500
MIME-Version: 1.0
In-Reply-To: <1359510052-21360-1-git-send-email-wangyijing@huawei.com>
References: <1359510052-21360-1-git-send-email-wangyijing@huawei.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 31 Jan 2013 10:26:26 -0700
Message-ID: <CAErSpo6pQm+ytk5BMR_1cxL0DGcaKFROYUrwYjwY4UVhdhsTeg@mail.gmail.com>
Subject: Re: [PATCH v4] PCI: Document PCIE BUS MPS parameters
To: Yijing Wang <wangyijing@huawei.com>
Cc: Rob Landley <rob@landley.net>, Jon Mason <jdmason@kudzu.us>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Andrew Murray <andrew.murray@arm.com>,
        Joe Lawrence <Joe.Lawrence@stratus.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Hanjun Guo <guohanjun@huawei.com>, jiang.liu@huawei.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 6:40 PM, Yijing Wang <wangyijing@huawei.com> wrote:
> v0->v1: Update MPS parameters as non-arch and add MRRS
>                 description into pcie_bus_perf parameter suggested
>                 by Andrew Murray.
> v1->v2: Update some semantic problems and add MPS and MRRS
>                 explanation suggested by Joe Lawrence and Randy Dunlap.
> v2->v3: Update some semantic problems and the description
>                 of pcie_bus_safe and pcie_bus_peer2peer suggested
>                 by Bjorn Helgaas.
> v3->v4: Update pcie_bus_safe description suggested by Jon Mason
>
> Document PCIE BUS MPS parameters pcie_bus_tune_off, pcie_bus_safe,
> pcie_bus_peer2peer, pcie_bus_perf into Documentation/kernel-parameters.txt.
> These parameters were introduced by Jon Mason <jdmason@kudzu.us> at
> commit 5f39e6705 and commit b03e7495a8.
>
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> ---
>  Documentation/kernel-parameters.txt |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)
>
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 363e348..6ad9b95 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2227,6 +2227,20 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>                                 This sorting is done to get a device
>                                 order compatible with older (<= 2.4) kernels.
>                 nobfsort        Don't sort PCI devices into breadth-first order.
> +               pcie_bus_tune_off       Disable PCIe MPS (Max Payload Size)
> +                               tuning and use the BIOS-configured MPS defaults.
> +               pcie_bus_safe   Set every device's MPS to the largest MPSS
> +                               (Max Payload Size Support) common to all devices
> +                               below the root complex.
> +               pcie_bus_perf   Configure device MPS to the largest
> +                               allowable MPS based on its parent bus. Also set
> +                               MRRS (Max Read Request Size) to the largest supported
> +                               value (no larger than the MPS that the device or bus
> +                               can support) for best performance.
> +               pcie_bus_peer2peer      Set every device's MPS to 128B, which
> +                               every device is guaranteed to support. This
> +                               configuration allows peer-to-peer DMA between any pair
> +                               of devices possibly at the cost of reduced performance.
>                 cbiosize=nn[KMG]        The fixed amount of bus space which is
>                                 reserved for the CardBus bridge's IO window.
>                                 The default value is 256 bytes.

Added to pci/misc for v3.9 with the changes below.  If we need to
change it more, let me know and I'll amend that branch.

I tweaked the pcie_bus_safe text slightly.

The hot-plug case was mentioned in your early patches, but not in the
v4 patch.  I think that's an important use case and we should provide
some guidance if we can.  I know you have some patches in the works
related to this, but as far as I can tell, the only want to ensure
that hot-added devices will work correctly is to use
pcie_bus_peer2peer so every MPS is set to 128.

The reason I think that is because in the pciehp_configure_device()
path, where we configure MPS for newly-added devices, there's nothing
that will change the MPS of any upstream bridges.  So we could have a
root port with MPS=256 and we never change that, even if the new
device only supports MPS=128.

Hopefully we can make this smarter in the future, but the
documentation should reflect the behavior of the current code.

So let me know if any of the below is inaccurate.

+               pcie_bus_safe   Set every device's MPS to the largest value
+                               supported by all devices below the root complex.

+               pcie_bus_peer2peer      Set every device's MPS to 128B, which
+                               every device is guaranteed to support. This
+                               configuration allows peer-to-peer DMA between
+                               any pair of devices, possibly at the cost of
+                               reduced performance.  This also guarantees
+                               that hot-added devices will work.
