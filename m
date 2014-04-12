Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbaDLTFL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 15:05:11 -0400
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:36258
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754472AbaDLTFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 15:05:09 -0400
From: Jane Wan <Jane.Wan@gainspeed.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <broonie@kernel.org>, <Emilian.Medve@Freescale.com>,
        <kenth.eriksson@transmode.com>, <thomas.de.schampheleire@gmail.com>,
        <b48286@Freescale.com>, <jg1.han@samsung.com>, <sr@denx.de>,
        <insop.song@gainspeed.com>
CC: <spi-devel-general@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Jane Wan <Jane.Wan@gainspeed.com>
Subject: [PATCH] Configure FSL eSPI CSBEF, CSAFT, and whether to send all received data to user
Date: Sat, 12 Apr 2014 11:48:35 -0700
Message-ID: <1397328516-13260-1-git-send-email-Jane.Wan@gainspeed.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [108.60.97.2]
X-Forefront-PRVS: 01792087B6
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(50226001)(4396001)(81342001)(74502001)(66066001)(19580395003)(62966002)(83322001)(19580405001)(79102001)(77156001)(74662001)(31966008)(77982001)(50986999)(80022001)(46102001)(36756003)(81542001)(50466002)(80976001)(99396002)(15202345003)(20776003)(47776003)(2201001)(92566001)(89996001)(48376002)(87936001)(87286001)(88136002)(83072002)(93916002)(15975445006)(86362001)(85852003)(92726001)(921003)(1121002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR07MB465;H:BY2PRD0711HT002.namprd07.prod.outlook.com;FPR:ECF175D7.A3F69532.73F41CA7.6E5F9EB.202A6;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: gainspeed.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make FSL eSPI properties configurable through device tree.  The
configurable parameters include CSnBEF and CSnAFT in ESPI_SPMODEn
registers (n=0,1,2,3), and whether to send all received data to user.

The FSL eSPI driver hardcodes CSnBEF and CSnAFT to 0.  Some device
needs to set them to different values.

When user sends n_tx bytes and receives n_rx bytes on FSL eSPI
interface, the FSL eSPI driver sends (n_tx + n_rx) bytes on MOSI.
Simultaniously, there are (n_tx + n_rx) received on MISO.  The FSL
eSPI driver only passes the last n_rx bytes to user device driver.
The other n_tx bytes received from the slave device are dropped.  
Some device has issue with this mechanism.  The device driver
requires to know all bytes that the slave device puts on MISO.

Part of this fix is based on a previous patch that was not included,
see http://www.mail-archive.com/spi-devel-general@lists.sourceforge.net/msg08658.html

Test done:
- Kernel version 3.8.13
- Three devices attached to FSL eSPI interface with chip select 0-2.
- The device at cs0 and cs1 work with original FSL eSPI driver.
- The device driver at cs2 has issue with original FSL eSPI driver.
  It requires to receive all data that the slave device puts on MISO.
  It also requires CS2BEF in SPI_SPMODE2 register to be set to 1.
- After set proper values in the device tree (as example below), all
  three  devices work fine with the FSL eSPI driver.
        spi@110000 {
                redpine@2 {
                        #address-cells = <1>;
                        #size-cells = <1>;
                        compatible = "spidev";
                        reg = <2>;
                        spi-max-frequency = <10000000>; /* input clock */
                        fsl,csbef = <1>; /* CS assertiion time in bits before frame start */
                        fsl,csaft = <1>; /* CS assertiion time in bits after frame end */
                        fsl,spi-raw-rxdata-to-user = <1>; /* send all rx data to user */
                };
        };


Jane Wan (1):
  Configure fsl espi CSBEF, CSAFT, and whether to send all received
    data to user

 drivers/spi/spi-fsl-espi.c       |   68 ++++++++++++++++++++++++++++++++++----
 1 files changed, 61 insertions(+), 7 deletions(-)

-- 
1.7.9.5

