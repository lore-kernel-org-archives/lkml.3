Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab3JDUoz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 16:44:55 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:62638 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab3JDUow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 16:44:52 -0400
MIME-Version: 1.0
In-Reply-To: <1378732388-4508-7-git-send-email-wangyijing@huawei.com>
References: <1378732388-4508-1-git-send-email-wangyijing@huawei.com> <1378732388-4508-7-git-send-email-wangyijing@huawei.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 4 Oct 2013 14:44:31 -0600
Message-ID: <CAErSpo5epkfhw0zyn-xXr-xCVeWmna8Eu_v3SmOrKU7EqwfDJw@mail.gmail.com>
Subject: Re: [PATCH 6/6] radeon: Use pcie_get_readrq() and pcie_set_readrq()
 to simplify code
To: Yijing Wang <wangyijing@huawei.com>
Cc: David Airlie <airlied@linux.ie>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?ISO-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[-cc unrelated folks, +cc Alex, Christian]

On Mon, Sep 9, 2013 at 7:13 AM, Yijing Wang <wangyijing@huawei.com> wrote:
> Use pcie_get_readrq() and pcie_set_readrq() functions to simplify code.
>
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>

I believe the following patch is correct, and I'd be happy to merge it
via the PCI tree along with the rest of this series.

But it'd be better to have an ack from Alex, and he might prefer to
merge it directly.

Bjorn

> ---
>  drivers/gpu/drm/radeon/evergreen.c |   19 ++++++-------------
>  1 files changed, 6 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
> index d5b49e3..b191f92 100644
> --- a/drivers/gpu/drm/radeon/evergreen.c
> +++ b/drivers/gpu/drm/radeon/evergreen.c
> @@ -1169,23 +1169,16 @@ int evergreen_set_uvd_clocks(struct radeon_device *rdev, u32 vclk, u32 dclk)
>
>  void evergreen_fix_pci_max_read_req_size(struct radeon_device *rdev)
>  {
> -       u16 ctl, v;
> -       int err;
> -
> -       err = pcie_capability_read_word(rdev->pdev, PCI_EXP_DEVCTL, &ctl);
> -       if (err)
> -               return;
> -
> -       v = (ctl & PCI_EXP_DEVCTL_READRQ) >> 12;
> +       int readrq;
> +       u16 v;
>
> +       readrq = pcie_get_readrq(rdev->pdev);
> +       v = ffs(readrq) - 8;
>         /* if bios or OS sets MAX_READ_REQUEST_SIZE to an invalid value, fix it
>          * to avoid hangs or perfomance issues
>          */
> -       if ((v == 0) || (v == 6) || (v == 7)) {
> -               ctl &= ~PCI_EXP_DEVCTL_READRQ;
> -               ctl |= (2 << 12);
> -               pcie_capability_write_word(rdev->pdev, PCI_EXP_DEVCTL, ctl);
> -       }
> +       if ((v == 0) || (v == 6) || (v == 7))
> +               pcie_set_readrq(rdev->pdev, 512);
>  }
>
>  static bool dce4_is_in_vblank(struct radeon_device *rdev, int crtc)
> --
> 1.7.1
>
>
