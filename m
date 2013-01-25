Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab3AYE6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 23:58:20 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:47947 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324Ab3AYE6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 23:58:17 -0500
MIME-Version: 1.0
In-Reply-To: <1358996288-31200-1-git-send-email-wangyijing@huawei.com>
References: <1358996288-31200-1-git-send-email-wangyijing@huawei.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 24 Jan 2013 21:57:55 -0700
Message-ID: <CAErSpo6suRwkRoShnNUKxxHt4D4gFnMVqesoZO3t-aC8tvOwnA@mail.gmail.com>
Subject: Re: [PATCH v2] PCI: Document PCIE BUS MPS parameters
To: Yijing Wang <wangyijing@huawei.com>
Cc: Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Andrew Murray <andrew.murray@arm.com>,
        Joe Lawrence <Joe.Lawrence@stratus.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Hanjun Guo <guohanjun@huawei.com>, jiang.liu@huawei.com,
        Jon Mason <jdmason@kudzu.us>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Jon, can you make sure this documentation is accurate?]

On Wed, Jan 23, 2013 at 7:58 PM, Yijing Wang <wangyijing@huawei.com> wrote:
> v0->v1: Update MPS parameters as non-arch and add MRRS
>                 description into pcie_bus_perf parameter suggested
>                 by Andrew Murray.
> v1->v2: Update some semantic problems and add MPS and MRRS
>                 explanation suggested by Joe Lawrence and Randy Dunlap.
>
> Document PCIE BUS MPS parameters pcie_bus_tune_off, pcie_bus_safe,
> pcie_bus_peer2peer, pcie_bus_perf into Documentation/kernel-parameters.txt.
> These parameters were introduced by Jon Mason <mason@myri.com> at
> commit 5f39e6705 and commit b03e7495a8.
>
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> ---
>  Documentation/kernel-parameters.txt |   16 ++++++++++++++++
>  1 files changed, 16 insertions(+), 0 deletions(-)
>
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 363e348..0bb279f 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2227,6 +2227,22 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>                                 This sorting is done to get a device
>                                 order compatible with older (<= 2.4) kernels.
>                 nobfsort        Don't sort PCI devices into breadth-first order.
> +               pcie_bus_tune_off       Disable PCIe MPS (Max Payload Size)
> +                               turning and using the BIOS-configured MPS defaults.

s/turning/tuning/
s/using/use/

> +               pcie_bus_safe   Use the smallest common denominator MPS
> +                               of the entire tree below a root complex for every
> +                               device on that fabric. Can avoid inconsistent MPS
> +                               problem caused by hotplug.

I'm not sure about this.  "smallest common denominator" is colloquial
and not exact.  I think you probably mean "the smallest supported MPS
of any device below a root complex."

I'm also not sure how this will avoid MPS problems caused by hotplug.
I think you have to assume that a hot-added device may support only a
128B MPS, which means the only way to guarantee that you can use that
device is to set MPS=128 for any device that will send packets to the
hot-added device.  Or we could reconfigure things at the time of the
hot-add, but I don't think we do that today (except for the hot-added
device itself).

> +               pcie_bus_perf   Configure pcie device MPS to the largest

Capitalize "PCIe" consistently.  Better yet, drop it completely since
it's obvious that we're only talking about PCIe here.

> +                               allowable MPS based on its parent bus. Also set
> +                               MRRS (Max Read Request Size) to the largest supported
> +                               value (no larger than the MPS that the device or bus
> +                               can support) for Max performance.

s/Max/best/

> +               pcie_bus_peer2peer      Make the system-wide MPS the smallest
> +                               possible value (128B). This configuration could prevent
> +                               peer to peer DMA transmission from working by having
> +                               the MPS on one root port different than the MPS on
> +                               another.

I think the idea is that pcie_bus_peer2peer would *allow* peer-to-peer
DMA to work, which is the opposite of what you wrote.  Maybe something
like this would be better:

  Set every device's MPS to 128B, which every device is guaranteed to support.
  This configuration allows peer-to-peer DMA between any pair of devices,
  possibly at the cost of reduced performance.

>                 cbiosize=nn[KMG]        The fixed amount of bus space which is
>                                 reserved for the CardBus bridge's IO window.
>                                 The default value is 256 bytes.
> --
> 1.7.1
>
>
