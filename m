Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab3JGMPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 08:15:40 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:39264
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751519Ab3JGMPi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 08:15:38 -0400
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zz98dI9371I1454I542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2dh839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h1155h)
X-WSS-ID: 0MUASPC-07-6H0-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yijing Wang <wangyijing@huawei.com>
CC: David Airlie <airlied@linux.ie>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>,
        "Koenig, Christian" <Christian.Koenig@amd.com>
Subject: RE: [PATCH 6/6] radeon: Use pcie_get_readrq() and pcie_set_readrq()
 to simplify code
Thread-Topic: [PATCH 6/6] radeon: Use pcie_get_readrq() and
 pcie_set_readrq() to simplify code
Thread-Index: AQHOwUKWpM+6lhcTQ0+Wm3Jz5tpHv5npKsDA
Date: Mon, 7 Oct 2013 12:15:29 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D02E80EE9B@satlexdag05.amd.com>
References: <1378732388-4508-1-git-send-email-wangyijing@huawei.com>
 <1378732388-4508-7-git-send-email-wangyijing@huawei.com>
 <CAErSpo5epkfhw0zyn-xXr-xCVeWmna8Eu_v3SmOrKU7EqwfDJw@mail.gmail.com>
In-Reply-To: <CAErSpo5epkfhw0zyn-xXr-xCVeWmna8Eu_v3SmOrKU7EqwfDJw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.180.168.240]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Bjorn Helgaas [mailto:bhelgaas@google.com]
> Sent: Friday, October 04, 2013 4:45 PM
> To: Yijing Wang
> Cc: David Airlie; linux-kernel@vger.kernel.org; linux-pci@vger.kernel.org;
> Hanjun Guo; Deucher, Alexander; Koenig, Christian
> Subject: Re: [PATCH 6/6] radeon: Use pcie_get_readrq() and
> pcie_set_readrq() to simplify code
> 
> [-cc unrelated folks, +cc Alex, Christian]
> 
> On Mon, Sep 9, 2013 at 7:13 AM, Yijing Wang <wangyijing@huawei.com>
> wrote:
> > Use pcie_get_readrq() and pcie_set_readrq() functions to simplify code.
> >
> > Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> 
> I believe the following patch is correct, and I'd be happy to merge it
> via the PCI tree along with the rest of this series.
> 
> But it'd be better to have an ack from Alex, and he might prefer to
> merge it directly.

Patch looks correct to me.  Feel free to merge it via the pci tree.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>

> 
> Bjorn
> 
> > ---
> >  drivers/gpu/drm/radeon/evergreen.c |   19 ++++++-------------
> >  1 files changed, 6 insertions(+), 13 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/radeon/evergreen.c
> b/drivers/gpu/drm/radeon/evergreen.c
> > index d5b49e3..b191f92 100644
> > --- a/drivers/gpu/drm/radeon/evergreen.c
> > +++ b/drivers/gpu/drm/radeon/evergreen.c
> > @@ -1169,23 +1169,16 @@ int evergreen_set_uvd_clocks(struct
> radeon_device *rdev, u32 vclk, u32 dclk)
> >
> >  void evergreen_fix_pci_max_read_req_size(struct radeon_device *rdev)
> >  {
> > -       u16 ctl, v;
> > -       int err;
> > -
> > -       err = pcie_capability_read_word(rdev->pdev, PCI_EXP_DEVCTL, &ctl);
> > -       if (err)
> > -               return;
> > -
> > -       v = (ctl & PCI_EXP_DEVCTL_READRQ) >> 12;
> > +       int readrq;
> > +       u16 v;
> >
> > +       readrq = pcie_get_readrq(rdev->pdev);
> > +       v = ffs(readrq) - 8;
> >         /* if bios or OS sets MAX_READ_REQUEST_SIZE to an invalid value, fix it
> >          * to avoid hangs or perfomance issues
> >          */
> > -       if ((v == 0) || (v == 6) || (v == 7)) {
> > -               ctl &= ~PCI_EXP_DEVCTL_READRQ;
> > -               ctl |= (2 << 12);
> > -               pcie_capability_write_word(rdev->pdev, PCI_EXP_DEVCTL, ctl);
> > -       }
> > +       if ((v == 0) || (v == 6) || (v == 7))
> > +               pcie_set_readrq(rdev->pdev, 512);
> >  }
> >
> >  static bool dce4_is_in_vblank(struct radeon_device *rdev, int crtc)
> > --
> > 1.7.1
> >
> >


