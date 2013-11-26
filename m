Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab3KZDqr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 22:46:47 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:47870 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab3KZDqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 22:46:43 -0500
MIME-Version: 1.0
In-Reply-To: <1385429290-25397-11-git-send-email-yinghai@kernel.org>
References: <1385429290-25397-1-git-send-email-yinghai@kernel.org> <1385429290-25397-11-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 25 Nov 2013 20:46:22 -0700
Message-ID: <CAErSpo4Sa6hpv45E9fQB_LsSrTt_mFzxbJvRocuCo9HXcAYfow@mail.gmail.com>
Subject: Re: [PATCH v2 10/10] intel-gtt: Read 64bit for gmar_bus_addr
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 6:28 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> That bar could be 64bit pref mem and above 4G.
>
> -v2: refresh to 3.13-rc1
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: David Airlie <airlied@linux.ie>
> Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

This looks OK to me.  Does it depend on any previous patches in this
series?  If not, I think Dave should pick it up.

Bjorn

> ---
>  drivers/char/agp/intel-gtt.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
> index b8e2014..b929e9d 100644
> --- a/drivers/char/agp/intel-gtt.c
> +++ b/drivers/char/agp/intel-gtt.c
> @@ -609,8 +609,10 @@ static bool intel_gtt_can_wc(void)
>  static int intel_gtt_init(void)
>  {
>         u32 gma_addr;
> +       u32 addr_hi = 0;
>         u32 gtt_map_size;
>         int ret;
> +       int pos;
>
>         ret = intel_private.driver->setup();
>         if (ret != 0)
> @@ -660,13 +662,17 @@ static int intel_gtt_init(void)
>         }
>
>         if (INTEL_GTT_GEN <= 2)
> -               pci_read_config_dword(intel_private.pcidev, I810_GMADDR,
> -                                     &gma_addr);
> +               pos = I810_GMADDR;
>         else
> -               pci_read_config_dword(intel_private.pcidev, I915_GMADDR,
> -                                     &gma_addr);
> +               pos = I915_GMADDR;
> +
> +       pci_read_config_dword(intel_private.pcidev, pos, &gma_addr);
> +
> +       if (gma_addr & PCI_BASE_ADDRESS_MEM_TYPE_64)
> +               pci_read_config_dword(intel_private.pcidev, pos + 4, &addr_hi);
>
>         intel_private.gma_bus_addr = (gma_addr & PCI_BASE_ADDRESS_MEM_MASK);
> +       intel_private.gma_bus_addr |= (u64)addr_hi << 32;
>
>         return 0;
>  }
> --
> 1.8.1.4
>
