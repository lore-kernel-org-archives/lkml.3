Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919AbaKKRSE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 12:18:04 -0500
Received: from mail-by2on0083.outbound.protection.outlook.com ([207.46.100.83]:49862
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751573AbaKKRSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 12:18:00 -0500
From: <dinguyen@opensource.altera.com>
To: <paulz@synopsys.com>, <balbi@ti.com>
CC: <dinh.linux@gmail.com>, <swarren@wwwdotorg.org>,
        <b.zolnierkie@samsung.com>, <matthijs@stdin.nl>,
        <r.baldyga@samsung.com>, <jg1.han@samsung.com>,
        <sachin.kamat@linaro.org>, <ben-linux@fluff.org>,
        <dianders@chromium.org>, <kever.yang@rock-chips.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@opensource.altera.com>
Subject: [PATCHv7 0/8] usb: dwc2: Add support for dual-role
Date: Tue, 11 Nov 2014 11:13:32 -0600
Message-ID: <1415726020-19238-1-git-send-email-dinguyen@opensource.altera.com>
X-Mailer: git-send-email 2.0.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR07CA079.namprd07.prod.outlook.com (25.160.24.34) To
 CY1PR0301MB1196.namprd03.prod.outlook.com (25.160.165.27)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1196;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1196;
X-Forefront-PRVS: 0392679D18
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(164054003)(64706001)(20776003)(47776003)(66066001)(53416004)(33646002)(40100003)(101416001)(50466002)(48376002)(122386002)(97736003)(42186005)(102836001)(50226001)(4396001)(105586002)(107046002)(19580395003)(19580405001)(95666004)(21056001)(229853001)(106356001)(86152002)(88136002)(92726001)(104166001)(31966008)(62966003)(87976001)(92566001)(77096003)(87286001)(77156002)(99396003)(89996001)(46102003)(69596002)(120916001)(81156004)(93916002)(86362001)(50986999);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR0301MB1196;H:linux-builds1.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1196;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <dinguyen@opensource.altera.com>

Hello,

This is version 7 of the patch series that combines the dwc2 gadget and host
driver into a single dual role driver. Here are the main differences from V6:

- patch 1/8: Addressed Felipe's comment on which variables should not be just
  limited to gadget(phy, uphy, regulator_bulk_data_supplies, irq, clk,
  debug_root, debug_file, and debug_fifo).
- patch 2/8: Move conversion to use dev_pm_ops API to separate patch.
- patch 3/8: Convert to use dev_pm_ops API
- patch 4/8: Rebased to s3c_hsotg_core_init is now
  s3c_hsotg_core_init_disconnected(), followed by s3c_hsotg_core_connect().
- patch 5/8: Use IRQF_SHARED to have s3c_hsotg_irq handle gadget interrupts.
  Had to remove paulz's Acked-by for this patch, as it is not quite the same
  patch when his ack was given.
- patch 6/8: Assign clk=NULL if a clock is not provided.
- patch 7/8: Moved ahead of Kconfig/Makefile patch to avoid a build error when
  patch 8 is applied to dual-role.
- patch 8/8: none

For v7, the series is rebased on top of Felipe Balbi's tree on -next
branch. I thought this might be appropriate as there are dwc2 patches already
on this branch.

As usual, tested on SOCFPGA(host, gadget, and dual-role) and on Rpi-B
(host mode only).

I have pushed this series to a git repo to make it more convenient for people
to test/review.

git://git.rocketboards.org/linux-socfpga-next.git dwc2_dual_role_v7

Thanks,

Dinh Nguyen (8):
  usb: dwc2: Update the gadget driver to use common dwc2_hsotg structure
  usb: dwc2: Move gadget probe function into platform code
  usb: dwc2: convert to use dev_pm_ops API
  usb: dwc2: Initialize the USB core for peripheral mode
  usb: dwc2: Update common interrupt handler to call gadget interrupt
    handler
  usb: dwc2: gadget: Do not fail probe if there isn't a clock node
  usb: dwc2: move usb_disabled() call to host driver only
  usb: dwc2: Update Kconfig to support dual-role

 drivers/usb/dwc2/Kconfig     |  66 ++++++-----
 drivers/usb/dwc2/Makefile    |  32 ++---
 drivers/usb/dwc2/core.c      |  10 --
 drivers/usb/dwc2/core.h      | 192 ++++++++++++++++++------------
 drivers/usb/dwc2/core_intr.c |   8 +-
 drivers/usb/dwc2/gadget.c    | 274 ++++++++++++++-----------------------------
 drivers/usb/dwc2/hcd.c       |   6 +-
 drivers/usb/dwc2/hcd.h       |  10 --
 drivers/usb/dwc2/pci.c       |   7 ++
 drivers/usb/dwc2/platform.c  |  42 ++++++-
 10 files changed, 317 insertions(+), 330 deletions(-)

-- 
2.0.3

