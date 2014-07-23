Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394AbaGWLnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 07:43:52 -0400
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:58841
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753634AbaGWLnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 07:43:50 -0400
Date: Wed, 23 Jul 2014 19:36:12 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        <balbi@ti.com>
CC: <gregkh@linuxfoundation.org>, <kishon@ti.com>, <stern@rowland.harvard.edu>,
        <sergei.shtylyov@cogentembedded.com>,
        <yoshihiro.shimoda.uh@renesas.com>,
        <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/8] usb: add support for the generic PHY framework
Message-ID: <20140723113611.GB5071@shlinux1.ap.freescale.net>
References: <1405435156-27297-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405435156-27297-1-git-send-email-antoine.tenart@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(51704005)(24454002)(53754006)(189002)(199002)(52044002)(86362001)(80022001)(83072002)(85852003)(33656002)(107046002)(26826002)(4396001)(47776003)(20776003)(102836001)(64706001)(95666004)(83506001)(81542001)(105606002)(23756003)(15975445006)(104016003)(6806004)(81156004)(68736004)(106466001)(69596002)(15202345003)(85306003)(92566001)(92726001)(81342001)(84676001)(44976005)(97736001)(99396002)(46102001)(83322001)(19580395003)(19580405001)(79102001)(76482001)(74502001)(31966008)(50466002)(74662001)(77982001)(21056001)(54356999)(76176999)(50986999)(87936001)(41533002);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB564;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 028166BF91
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 04:39:08PM +0200, Antoine Ténart wrote:
> Hi all,
> 
> This is an attempt to add more common USB code aware of the generic PHY
> framework, while keeping the compatibility for the USB PHY one. It does
> not add the full support, some USB PHY specific functions not being
> available currently in the generic PHY subsystem (e.g. usb_phy_set_power()).
> But it allows to use the generic PHY framework in other cases, and might
> help others to convert their USB PHY drivers.
> 
> A little background: I submitted a series to support USB on Berlin SoCs[1].
> One patch added a new PHY driver in drivers/usb/phy and Felipe asked it to
> be in the generic PHY framework instead[2]. This PHY being used by a ChipIdea
> driver, changes were needed in ChipIdea, OTG and HCD.
> 
> This is done in 3 steps:
>         1. moving the OTG state from the USB PHY structure to the OTG one
>         2. renaming the field 'phy' to 'usb_phy'
>         3. adding a field for the generic framework PHY and dissociating its
>            use from the USB PHY one
> 
> Step 1 is in the first patch. Steps 2 and 3 are done for OTG, and ChipIdea
> subsystems in patches 2-3 and 7-8.

We did wrong thing that added usb_phy to otg struct, so we should not
add any PHY related to struct otg any more, the otg and phy have NO
relationship, so the second patch and the third patch may do useless job
which may be deleted in future.

You did great refine job that moving otg state to struct otg, so why not
having another patchset to delete struct *otg from struct usb_phy and
delete struct *usb_phy from struct otg, if the phy driver needs otg
utilities, it can be an entry at phy driver's global struct like struct
usb_phy.

You can have one cleanup patchset to clean up the relationship between
usb_phy and otg which includes the first patch in this patchset, and
other cleanup patches, and this generic PHY framework patch can be the
second one.

Felipe, do you agree with me?

Peter

> 
> HCD generic PHY support was made by Sergei and Yoshihiro[1]. I added some
> modifications to make this support consistent with this series in patches
> 4-6.
> 
> I tested it by using the ChipIdea driver I introduced, both with an USB PHY
> and a PHY driver successfully. I also compiled a multi_v7 kernel (ARM), with
> every driver I could enable in the USB section.
> 
> I'd like more people to test and your inputs and suggestions on these changes.
> 
> Feel free to add Ccs if others might be interested in this. If needed patches
> can be squashed or divided, I tried there to group modifications by USB
> framework parts (OTG, HCD, ChipIdea).
> 
> Patches can also be found at:
> git://git.free-electrons.com:users/antoine-tenart/linux.git usb-phy
> 
> The series applies on top of Sergei and Yoshihiro generic PHY support in
> HCD[1].
> 
> Thanks a lot!
> 
> Antoine
> 
> Changes since v1:
>         - rebased the series on top of [1] (generic PHY support for HCD)
>         - split s/phy/usb_phy/ renaming and generic PHY support in separate
>           patches
> 
> [1] https://www.mail-archive.com/linux-usb@vger.kernel.org/msg43471.html
> 
> Antoine Ténart (8):
>   usb: move the OTG state from the USB PHY to the OTG structure
>   usb: rename phy to usb_phy in OTG
>   usb: add support to the generic PHY framework in OTG
>   usb: rename phy to usb_phy in HCD
>   usb: rename gen_phy to phy in HCD
>   usb: allow to supply the PHY in the drivers when using HCD
>   usb: rename transceiver and phy to usb_phy in ChipIdea
>   usb: chipidea: add support to the generic PHY framework in ChipIdea
> 
>  drivers/phy/phy-omap-usb2.c         | 14 ++----
>  drivers/usb/chipidea/ci.h           |  7 ++-
>  drivers/usb/chipidea/ci_hdrc_imx.c  |  2 +-
>  drivers/usb/chipidea/ci_hdrc_msm.c  |  8 ++--
>  drivers/usb/chipidea/core.c         | 71 ++++++++++++++++++++++-----
>  drivers/usb/chipidea/debug.c        |  5 +-
>  drivers/usb/chipidea/host.c         | 18 ++++---
>  drivers/usb/chipidea/otg_fsm.c      | 18 +++----
>  drivers/usb/chipidea/udc.c          |  4 +-
>  drivers/usb/common/usb-otg-fsm.c    |  8 ++--
>  drivers/usb/core/hcd.c              | 45 +++++++++---------
>  drivers/usb/core/hub.c              |  8 ++--
>  drivers/usb/host/ehci-fsl.c         | 16 +++----
>  drivers/usb/host/ehci-hub.c         |  2 +-
>  drivers/usb/host/ehci-msm.c         |  4 +-
>  drivers/usb/host/ehci-tegra.c       | 16 +++----
>  drivers/usb/host/ohci-omap.c        | 20 ++++----
>  drivers/usb/musb/am35x.c            | 28 +++++------
>  drivers/usb/musb/blackfin.c         | 18 +++----
>  drivers/usb/musb/da8xx.c            | 28 +++++------
>  drivers/usb/musb/davinci.c          | 18 +++----
>  drivers/usb/musb/musb_core.c        | 94 ++++++++++++++++++------------------
>  drivers/usb/musb/musb_dsps.c        | 26 +++++-----
>  drivers/usb/musb/musb_gadget.c      | 36 +++++++-------
>  drivers/usb/musb/musb_host.c        |  8 ++--
>  drivers/usb/musb/musb_virthub.c     | 22 ++++-----
>  drivers/usb/musb/omap2430.c         | 30 ++++++------
>  drivers/usb/musb/tusb6010.c         | 40 ++++++++--------
>  drivers/usb/musb/ux500.c            | 10 ++--
>  drivers/usb/phy/phy-ab8500-usb.c    | 16 +++----
>  drivers/usb/phy/phy-fsl-usb.c       | 23 ++++-----
>  drivers/usb/phy/phy-generic.c       |  6 +--
>  drivers/usb/phy/phy-gpio-vbus-usb.c | 12 ++---
>  drivers/usb/phy/phy-isp1301-omap.c  | 10 ++--
>  drivers/usb/phy/phy-msm-usb.c       | 95 +++++++++++++++++++------------------
>  drivers/usb/phy/phy-mv-usb.c        | 50 +++++++++----------
>  drivers/usb/phy/phy-samsung-usb2.c  |  2 +-
>  drivers/usb/phy/phy-tahvo.c         |  8 ++--
>  drivers/usb/phy/phy-ulpi.c          |  6 +--
>  include/linux/usb/chipidea.h        |  4 +-
>  include/linux/usb/hcd.h             |  6 ++-
>  include/linux/usb/otg.h             |  7 ++-
>  include/linux/usb/phy.h             |  1 -
>  43 files changed, 469 insertions(+), 401 deletions(-)
> 
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

Best Regards,
Peter Chen
