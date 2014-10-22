Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535AbaJVT46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 15:56:58 -0400
Received: from mail-by2on0061.outbound.protection.outlook.com ([207.46.100.61]:31031
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751342AbaJVT44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 15:56:56 -0400
From: <atull@opensource.altera.com>
To: <gregkh@linuxfoundation.org>, <jgunthorpe@obsidianresearch.com>,
        <hpa@zytor.com>, <monstr@monstr.eu>, <michal.simek@xilinx.com>,
        <rdunlap@infradead.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <pantelis.antoniou@konsulko.com>, <robh+dt@kernel.org>,
        <grant.likely@linaro.org>, <iws@ovro.caltech.edu>,
        <linux-doc@vger.kernel.org>, <pavel@denx.de>, <broonie@kernel.org>,
        <philip@balister.org>, <rubini@gnudd.com>, <s.trumtrar@pengutronix.de>,
        <jason@lakedaemon.net>, <kyle.teske@ni.com>, <nico@linaro.org>,
        <balbi@ti.com>, <m.chehab@samsung.com>, <davidb@codeaurora.org>,
        <rob@landley.net>, <davem@davemloft.net>, <cesarb@cesarb.net>,
        <sameo@linux.intel.com>, <akpm@linux-foundation.org>,
        <linus.walleij@linaro.org>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH v2 0/3] FPGA Framework with DT and sysfs support
Date: Wed, 22 Oct 2014 14:50:02 -0500
Message-ID: <1414007405-32186-1-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: DM2PR11CA0002.namprd11.prod.outlook.com (25.160.91.12) To
 BL2PR03MB307.namprd03.prod.outlook.com (10.141.68.21)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB307;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 037291602B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(62966002)(31966008)(50986999)(106356001)(48376002)(77096002)(76482002)(99396003)(120916001)(50466002)(77156001)(97736003)(81156004)(107046002)(229853001)(105586002)(95666004)(19580395003)(122386002)(85306004)(19580405001)(15975445006)(46102003)(80022003)(102836001)(87286001)(69596002)(93916002)(101416001)(40100003)(86362001)(104166001)(88136002)(89996001)(33646002)(66066001)(21056001)(47776003)(53416004)(20776003)(42186005)(50226001)(87976001)(4396001)(92566001)(85852003)(92726001)(64706001)(86152002)(2201001)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB307;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@opensource.altera.com>

Followup to "Yet another stab at a fpga framework"
(https://lkml.org/lkml/2014/8/1/517)

One of the problems with writing this framework has been the
wide variety of use cases.  My perspective has mostly been
for a fpga bolted to a SoC.  Having said that, I really hope
this can be useful for as many uses as possible, while still
being integrated into the kernel in a way that is Linux-like.

Three basic methods of programming a FPGA are supported:
 * Load firmware using sysfs (see patch 0002 header for example)
 * Load firmware using Device Tree overlay (see patch 0003)
 * The core fpga-mgr.c exports enough functions for any driver
   to use to get the FPGA programmed.  If someone needs another
   interface, the core functions should give enough
   functionality to make that possible.

If the fpga is programmed using firmware, resume is supported.

Big looming problem in firmware class for us here is that FPGA
image files can easily be 10's to 100's of megabytes.  If we
have FPGA's that are chained, the image file for several FPGA's
is concatenated.  So then you can multiply that.

High level changes from previous version:
 * I went ahead and put the sysfs interface into the core
   although I think it could just as well be separate.
 * Rework the state/status stuff to stop the programming
   steps.  In the event of error, the state machine is left
   at a state with '_ERR' in its name. state is available
   in sysfs, including these error states.
 * Added ability to reset the FPGA from sysfs.  If people
   like this, let me know.  If not it may not be needed as
   that should happen in the normal programming steps.

bus.c adds support for programming from Device Tree overlays.
That code was tested from Pantelis' branch; the rest of this
was tested on for-next.

Alan


Alan Tull (3):
  fpga manager: add sysfs interface document
  fpga manager: framework core
  fpga manager: bus driver

 Documentation/ABI/testing/sysfs-class-fpga-manager |   38 ++
 drivers/Kconfig                                    |    2 +
 drivers/Makefile                                   |    1 +
 drivers/fpga/Kconfig                               |   28 +
 drivers/fpga/Makefile                              |   11 +
 drivers/fpga/bus.c                                 |  124 +++++
 drivers/fpga/fpga-mgr.c                            |  551 ++++++++++++++++++++
 include/linux/fpga-mgr.h                           |  117 +++++
 8 files changed, 872 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-class-fpga-manager
 create mode 100644 drivers/fpga/Kconfig
 create mode 100644 drivers/fpga/Makefile
 create mode 100644 drivers/fpga/bus.c
 create mode 100644 drivers/fpga/fpga-mgr.c
 create mode 100644 include/linux/fpga-mgr.h

-- 
1.7.9.5

