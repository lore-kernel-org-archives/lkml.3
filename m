Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758801AbaJ3KKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 06:10:09 -0400
Received: from mail-by2on0146.outbound.protection.outlook.com ([207.46.100.146]:2016
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758587AbaJ3KKF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 06:10:05 -0400
X-WSS-ID: 0NE95KN-07-XS8-02
X-M-MSG: 
From: Huang Rui <ray.huang@amd.com>
To: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Jason Chang <jason.chang@amd.com>, Vincent Wan <vincent.wan@amd.com>,
        Tony Li <tony.li@amd.com>, <linux-usb@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Huang Rui <ray.huang@amd.com>
Subject: [PATCH v4 00/20] usb: dwc3: add support for AMD Nolan SoC
Date: Thu, 30 Oct 2014 18:08:25 +0800
Message-ID: <1414663725-2195-1-git-send-email-ray.huang@amd.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset="yes"
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(164054003)(199003)(189002)(102836001)(88136002)(31966008)(80022003)(33646002)(46102003)(50466002)(4396001)(76482002)(92566001)(92726001)(68736004)(93916002)(19580395003)(19580405001)(50226001)(47776003)(44976005)(77096002)(21056001)(84676001)(64706001)(104166001)(53416004)(86362001)(97736003)(2171001)(50986999)(107046002)(87936001)(62966002)(106466001)(99396003)(120916001)(95666004)(36756003)(20776003)(87286001)(101416001)(89996001)(77156001)(105586002)(229853001)(85306004)(85852003);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB196;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB196;
X-Forefront-PRVS: 038002787A
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The series of patches add AMD Nolan (NL) SoC support for DesignWare USB3
OTG IP with PCI bus glue layer. This controller supported hibernation, LPM
erratum and used the 2.80a IP version and amd own phy. Current
implementation support both simulation and SoC platform. And already tested
with gadget zero and msc tool. It works well on file storage gadget.


These patches are generated on balbi/testing/next

Changes from v3 -> v4
- Add comment on hibernation patch
- Fix typos of commit log and comments
- Remove WARN_ON for temporary solution of FPGA board
- Rename tx deemph to tx de-emphasis
- Add documentation under Documentation/devicetree/bindings/usb/dwc3.txt
- Check FPGA flag on usb3 and usb2 suspend phy quirk
- Refine description of PCI quirk patch
- Remove amd_nl_plat flag at dwc3 structure
- Make HIRD threshold configurable

Changes from v2 -> v3
- Confirmed these quirks will be needed in product level
- Move AMD configuration patch to the last one with all quirk flags
- Make all quirks as 1-bit field instead of single-bits on a 32-bit
  variable
- Add all quirks DeviceTree counterparts
- Make LPM erratum configurable
- Add PCI ID into pci_ids.h because it will be used both on PCI and DWC3
  device driver.

Changes from v1 -> v2
- Remove dual role function temporarily
- Add pci quirk to avoid to bind with xhci driver
- Distinguish between simulation board and soc
- Break down all the special quirks


Patch 1:
- Enable hibernation

Patch 2:
- Distinguish between simulation board and SoC

Patch 3:
- Initialize platform data at pci glue layer

Patch 4 - 16:
- Break down all the special quirks

Patch 17:
- Add PCI device ID of AMD NL USB3 DRD

Patch 18:
- Prevent xHCI driver from claiming AMD NL USB3 DRD device

Patch 19:
- Add support AMD NL USB3 DRD for dwc3 driver

Patch 20:
- Make HIRD threshold configurable

Patch set already passed all the MSC testing on simulation board with low
clock frequency, so the speed will slower than true SoC. Detailed result
without verbose debug option is below:

root@hr-bak:/home/ray/felipe/usb-tools# ./msc.sh -o /dev/sdb1
Starting test suite: 2014年 10月 30日 星期四 15:42:32 CST
test 0a: simple 4k read/write
test  0: sent       3.91 MB read       7.43 MB/s write       6.45 MB/s ... success
test 0b: simple 8k read/write
test  0: sent       7.81 MB read      10.10 MB/s write       8.92 MB/s ... success
test 0c: simple 16k read/write
test  0: sent      15.62 MB read      15.22 MB/s write      12.02 MB/s ... success
test 0d: simple 32k read/write
test  0: sent      31.25 MB read      19.30 MB/s write      16.65 MB/s ... success
test 0e: simple 64k read/write
test  0: sent      62.50 MB read      22.43 MB/s write      16.04 MB/s ... success
test 1: simple 1-sector read/write
test  1: sent     500.00 kB read       1.27 MB/s write       1.04 MB/s ... success
test 2: simple 8-sectors read/write
test  2: sent       3.91 MB read       7.39 MB/s write       6.35 MB/s ... success
test 3: simple 32-sectors read/write
test  3: sent      15.62 MB read      15.26 MB/s write      12.42 MB/s ... success
test 4: simple 64-sectors read/write
test  4: sent      31.25 MB read      19.56 MB/s write      16.83 MB/s ... success
test 5a: scatter/gather for 2-sectors buflen 4k
test  5: sent    1000.00 kB read       2.53 MB/s write       1.89 MB/s ... success
test 5b: scatter/gather for 2-sectors buflen 8k
test  5: sent    1000.00 kB read       2.52 MB/s write       1.87 MB/s ... success
test 5c: scatter/gather for 2-sectors buflen 16k
test  5: sent    1000.00 kB read       2.53 MB/s write       1.85 MB/s ... success
test 5d: scatter/gather for 2-sectors buflen 32k
test  5: sent    1000.00 kB read       2.47 MB/s write       2.08 MB/s ... success
test 5e: scatter/gather for 2-sectors buflen 64k
test  5: sent    1000.00 kB read       2.48 MB/s write       2.09 MB/s ... success
test 6a: scatter/gather for 8-sectors buflen 4k
test  6: sent       3.91 MB read       7.05 MB/s write       6.31 MB/s ... success
test 6b: scatter/gather for 8-sectors buflen 8k
test  6: sent       3.91 MB read       7.43 MB/s write       6.39 MB/s ... success
test 6c: scatter/gather for 8-sectors buflen 16k
test  6: sent       3.91 MB read       7.66 MB/s write       6.27 MB/s ... success
test 6d: scatter/gather for 8-sectors buflen 32k
test  6: sent       3.91 MB read       7.71 MB/s write       6.30 MB/s ... success
test 6e: scatter/gather for 8-sectors buflen 64k
test  6: sent       3.91 MB read       7.38 MB/s write       6.46 MB/s ... success
test 7a: scatter/gather for 32-sectors buflen 16k
test  7: sent      15.62 MB read      14.56 MB/s write      11.90 MB/s ... success
test 7b: scatter/gather for 32-sectors buflen 32k
test  7: sent      15.62 MB read      15.16 MB/s write      12.02 MB/s ... success
test 7c: scatter/gather for 32-sectors buflen 64k
test  7: sent      15.62 MB read      15.29 MB/s write      12.03 MB/s ... success
test 8a: scatter/gather for 64-sectors buflen 32k
test  8: sent      31.25 MB read      19.48 MB/s write      16.62 MB/s ... success
test 8b: scatter/gather for 64-sectors buflen 64k
test  8: sent      31.25 MB read      19.62 MB/s write      16.71 MB/s ... success
test 9: scatter/gather for 128-sectors buflen 64k
test  9: sent      62.50 MB read      22.14 MB/s write      16.65 MB/s ... success
test 10: read over the end of the block device
test 10: sent      62.01 MB read       0.00 MB/s write       0.00 MB/s ... success
test 11: lseek past the end of the block device
test 11: sent       0.00 B read       0.00 MB/s write       0.00 MB/s ... success
test 12: write over the end of the block device
test 12: sent       0.00 B read       0.00 MB/s write       0.00 MB/s ... success
test 13: write 1 sg, read 8 random size sgs
test 13: sent      62.50 MB read      21.54 MB/s write      16.17 MB/s ... success
test 14: write 8 random size sgs, read 1 sg
test 14: sent      62.50 MB read      21.62 MB/s write      15.98 MB/s ... success
test 15: write and read 8 random size sgs
test 15: sent      62.50 MB read      22.00 MB/s write      16.53 MB/s ... success
test 16a: read with heap allocated buffer
test 16: sent      62.50 MB read      21.10 MB/s write       0.00 MB/s ... success
test 16b: read with stack allocated buffer
test 16: sent      62.50 MB read      21.28 MB/s write       0.00 MB/s ... success
test 17a: write with heap allocated buffer
test 17: sent       0.00 B read       0.00 MB/s write      20.29 MB/s ... success
test 17b: write with stack allocated buffer
test 17: sent       0.00 B read       0.00 MB/s write      20.34 MB/s ... success
test 18a: write 0x00 and read it back
test 18: sent      62.50 MB read      21.80 MB/s write      16.02 MB/s ... success
test 18b: write 0xff and read it back
test 18: sent      62.50 MB read      20.56 MB/s write      15.06 MB/s ... success
test 18c: write 0x55 and read it back
test 18: sent      62.50 MB read      21.68 MB/s write      15.94 MB/s ... success
test 18d: write 0xaa and read it back
test 18: sent      62.50 MB read      21.69 MB/s write      15.99 MB/s ... success
test 18e: write 0x11 and read it back
test 18: sent      62.50 MB read      21.59 MB/s write      15.97 MB/s ... success
test 18f: write 0x22 and read it back
test 18: sent      62.50 MB read      21.62 MB/s write      15.98 MB/s ... success
test 18g: write 0x44 and read it back
test 18: sent      62.50 MB read      21.42 MB/s write      16.09 MB/s ... success
test 18h: write 0x88 and read it back
test 18: sent      62.50 MB read      21.01 MB/s write      15.83 MB/s ... success
test 18i: write 0x33 and read it back
test 18: sent      62.50 MB read      21.42 MB/s write      16.06 MB/s ... success
test 18j: write 0x66 and read it back
test 18: sent      62.50 MB read      21.53 MB/s write      16.01 MB/s ... success
test 18k: write 0x99 and read it back
test 18: sent      62.50 MB read      21.39 MB/s write      16.03 MB/s ... success
test 18l: write 0xcc and read it back
test 18: sent      62.50 MB read      21.77 MB/s write      16.02 MB/s ... success
test 18m: write 0x77 and read it back
test 18: sent      62.50 MB read      21.99 MB/s write      16.09 MB/s ... success
test 18n: write 0xbb and read it back
test 18: sent      62.50 MB read      21.91 MB/s write      16.02 MB/s ... success
test 18o: write 0xdd and read it back
test 18: sent      62.50 MB read      21.17 MB/s write      15.90 MB/s ... success
test 18p: write 0xee and read it back
test 18: sent      62.50 MB read      21.93 MB/s write      16.05 MB/s ... success
Test suite ended: 2014年 10月 30日 星期四 15:46:12 CST

Thanks,
Rui

Huang Rui (20):
  usb: dwc3: enable hibernation if to be supported
  usb: dwc3: add a flag to check if it is FPGA board
  usb: dwc3: initialize platform data at pci glue layer
  usb: dwc3: add disable scramble quirk
  usb: dwc3: add lpm erratum support
  usb: dwc3: add U2Exit LFPS quirk
  usb: dwc3: add P3 in U2 SS Inactive quirk
  usb: dwc3: add request P1/P2/P3 quirk
  usb: dwc3: add delay P1/P2/P3 quirk
  usb: dwc3: add delay phy power change quirk
  usb: dwc3: add LFPS filter quirk
  usb: dwc3: add rx_detect to polling LFPS quirk
  usb: dwc3: set SUSPHY bit for all cores
  usb: dwc3: add Tx de-emphasis quirk
  usb: dwc3: add disable usb3 suspend phy quirk
  usb: dwc3: add disable usb2 suspend phy quirk
  PCI: Add support for AMD Nolan USB3 DRD
  PCI: Prevent xHCI driver from claiming AMD Nolan USB3 DRD device
  usb: dwc3: add support for AMD Nolan platform
  usb: dwc3: make HIRD threshold configurable

 Documentation/devicetree/bindings/usb/dwc3.txt |  23 ++++
 drivers/pci/quirks.c                           |  20 +++
 drivers/usb/dwc3/core.c                        | 174 ++++++++++++++++++++++++-
 drivers/usb/dwc3/core.h                        |  78 +++++++++--
 drivers/usb/dwc3/dwc3-pci.c                    |  32 +++++
 drivers/usb/dwc3/gadget.c                      |  15 ++-
 drivers/usb/dwc3/platform_data.h               |  20 +++
 include/linux/pci_ids.h                        |   1 +
 8 files changed, 347 insertions(+), 16 deletions(-)

-- 
1.9.1

