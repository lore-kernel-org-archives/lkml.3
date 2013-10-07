Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab3JGSat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 14:30:49 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:53059 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab3JGSap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 14:30:45 -0400
MIME-Version: 1.0
In-Reply-To: <A3397C8B8B789E45844E7EC5DEAD89D02E80EE9B@satlexdag05.amd.com>
References: <1378732388-4508-1-git-send-email-wangyijing@huawei.com>
 <1378732388-4508-7-git-send-email-wangyijing@huawei.com> <CAErSpo5epkfhw0zyn-xXr-xCVeWmna8Eu_v3SmOrKU7EqwfDJw@mail.gmail.com>
 <A3397C8B8B789E45844E7EC5DEAD89D02E80EE9B@satlexdag05.amd.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 7 Oct 2013 12:30:25 -0600
Message-ID: <CAErSpo4z1VmYwrCQv+vgyNET+1eFirEV3hAnbpF78DW+N18Nig@mail.gmail.com>
Subject: Re: [PATCH 6/6] radeon: Use pcie_get_readrq() and pcie_set_readrq()
 to simplify code
To: "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc: Yijing Wang <wangyijing@huawei.com>, David Airlie <airlied@linux.ie>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>,
        "Koenig, Christian" <Christian.Koenig@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 7, 2013 at 6:15 AM, Deucher, Alexander
<Alexander.Deucher@amd.com> wrote:
>> -----Original Message-----
>> From: Bjorn Helgaas [mailto:bhelgaas@google.com]
>> Sent: Friday, October 04, 2013 4:45 PM
>> To: Yijing Wang
>> Cc: David Airlie; linux-kernel@vger.kernel.org; linux-pci@vger.kernel.org;
>> Hanjun Guo; Deucher, Alexander; Koenig, Christian
>> Subject: Re: [PATCH 6/6] radeon: Use pcie_get_readrq() and
>> pcie_set_readrq() to simplify code
>>
>> [-cc unrelated folks, +cc Alex, Christian]
>>
>> On Mon, Sep 9, 2013 at 7:13 AM, Yijing Wang <wangyijing@huawei.com>
>> wrote:
>> > Use pcie_get_readrq() and pcie_set_readrq() functions to simplify code.
>> >
>> > Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>>
>> I believe the following patch is correct, and I'd be happy to merge it
>> via the PCI tree along with the rest of this series.
>>
>> But it'd be better to have an ack from Alex, and he might prefer to
>> merge it directly.
>
> Patch looks correct to me.  Feel free to merge it via the pci tree.
>
> Reviewed-by: Alex Deucher <alexander.deucher@amd.com>

Thanks, I'll add your Reviewed-by and merge it.

Bjorn

>> > ---
>> >  drivers/gpu/drm/radeon/evergreen.c |   19 ++++++-------------
>> >  1 files changed, 6 insertions(+), 13 deletions(-)
>> >
>> > diff --git a/drivers/gpu/drm/radeon/evergreen.c
>> b/drivers/gpu/drm/radeon/evergreen.c
>> > index d5b49e3..b191f92 100644
>> > --- a/drivers/gpu/drm/radeon/evergreen.c
>> > +++ b/drivers/gpu/drm/radeon/evergreen.c
>> > @@ -1169,23 +1169,16 @@ int evergreen_set_uvd_clocks(struct
>> radeon_device *rdev, u32 vclk, u32 dclk)
>> >
>> >  void evergreen_fix_pci_max_read_req_size(struct radeon_device *rdev)
>> >  {
>> > -       u16 ctl, v;
>> > -       int err;
>> > -
>> > -       err = pcie_capability_read_word(rdev->pdev, PCI_EXP_DEVCTL, &ctl);
>> > -       if (err)
>> > -               return;
>> > -
>> > -       v = (ctl & PCI_EXP_DEVCTL_READRQ) >> 12;
>> > +       int readrq;
>> > +       u16 v;
>> >
>> > +       readrq = pcie_get_readrq(rdev->pdev);
>> > +       v = ffs(readrq) - 8;
>> >         /* if bios or OS sets MAX_READ_REQUEST_SIZE to an invalid value, fix it
>> >          * to avoid hangs or perfomance issues
>> >          */
>> > -       if ((v == 0) || (v == 6) || (v == 7)) {
>> > -               ctl &= ~PCI_EXP_DEVCTL_READRQ;
>> > -               ctl |= (2 << 12);
>> > -               pcie_capability_write_word(rdev->pdev, PCI_EXP_DEVCTL, ctl);
>> > -       }
>> > +       if ((v == 0) || (v == 6) || (v == 7))
>> > +               pcie_set_readrq(rdev->pdev, 512);
>> >  }
>> >
>> >  static bool dce4_is_in_vblank(struct radeon_device *rdev, int crtc)
>> > --
>> > 1.7.1
>> >
>> >
>
>
