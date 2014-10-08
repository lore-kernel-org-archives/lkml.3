Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681AbaJHQam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 12:30:42 -0400
Received: from mail-bl2on0140.outbound.protection.outlook.com ([65.55.169.140]:60764
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751829AbaJHQag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 12:30:36 -0400
Message-ID: <1412785827.13320.532.camel@snotra.buserror.net>
Subject: Re: [PATCH v2 1/2] spi: fsl-spi: Fix parameter ram offset setup for
 CPM1
From: Scott Wood <scottwood@freescale.com>
To: leroy christophe <christophe.leroy@c-s.fr>
CC: Mark Brown <broonie@kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-spi@vger.kernel.org>
Date: Wed, 8 Oct 2014 11:30:27 -0500
In-Reply-To: <5435649F.5070908@c-s.fr>
References: <20141003164916.DBD631AAFA2@localhost.localdomain>
	 <1412368198.13320.434.camel@snotra.buserror.net> <542FE1C4.7000403@c-s.fr>
	 <1412640953.13320.502.camel@snotra.buserror.net> <5435649F.5070908@c-s.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [2601:2:5800:3f7:8d24:400:3af9:c4bd]
X-ClientProxiedBy: BLUPR08CA0039.namprd08.prod.outlook.com (10.141.200.19) To
 CY1PR0301MB0731.namprd03.prod.outlook.com (25.160.159.149)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0731;
X-Forefront-PRVS: 0358535363
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(189002)(479174003)(199003)(24454002)(377424004)(77096002)(50986999)(104166001)(93916002)(46102003)(80022003)(42186005)(85852003)(110136001)(47776003)(97736003)(33646002)(76176999)(62966002)(40100002)(86362001)(92726001)(31966008)(87976001)(87286001)(89996001)(101416001)(88136002)(102836001)(103116003)(120916001)(122386002)(4396001)(50226001)(23676002)(106356001)(21056001)(92566001)(77156001)(64706001)(105586002)(20776003)(19580405001)(76482002)(85306004)(50466002)(99396003)(107046002)(95666004)(93886004)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0731;H:[IPv6:2601:2:5800:3f7:8d24:400:3af9:c4bd];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-08 at 18:21 +0200, leroy christophe wrote:
> Le 07/10/2014 02:15, Scott Wood a écrit :
> > On Sat, 2014-10-04 at 14:02 +0200, christophe leroy wrote:
> >> What should it look like if that offset had to be in the device tree ?
> > If the offset is not relocatable or discoverable, it should stay in the
> > device tree.  If you have an old chip you wouldn't have
> > fsl,cpm1-spi-reloc and thus you'd still have "0x3d80 0x30" in reg.
> This index is from the start of the dual port RAM. It is 0x2000 above 
> the start of the CPM area.
> In the DTS, we have:
> 
>      soc@ff000000 {
>          compatible = "fsl,mpc885", "fsl,pq1-soc";
>          #address-cells = <1>;
>          #size-cells = <1>;
>          device_type = "soc";
>          ranges = <0x0 0xff000000 0x28000>;
>          bus-frequency = <0>;
>          clock-frequency = <0>;
> 
>          cpm@9c0 {
>              #address-cells = <1>;
>              #size-cells = <1>;
>              compatible = "fsl,mpc885-cpm", "fsl,cpm1";
>              ranges;
>              reg = <0x9c0 0x40>;
>              brg-frequency = <0>;
>              interrupts = <0>;    // cpm error interrupt
>              interrupt-parent = <&CPM_PIC>;
> 
>              muram@2000 {
>                  #address-cells = <1>;
>                  #size-cells = <1>;
>                  ranges = <0x0 0x2000 0x2000>;
> 
>                  data@0 {
>                      compatible = "fsl,cpm-muram-data";
>                      reg = <0x0 0x1c00>;
>                  };
>              };
> 
>              spi: spi@a80 {
>                  #address-cells = <1>;
>                  #size-cells = <0>;
>                  cell-index = <0>;
>                  compatible = "fsl,spi", "fsl,cpm1-spi";
>                  reg = <0xa80 0x30 0x3d80 0x30>;
>                  interrupts = <5>;
>                  interrupt-parent = <&CPM_PIC>;
>                  mode = "cpu";
> 
> 
> The binding allows me to do an of_iomap() on the parameter RAM, hence to 
> get access to the relocation index which is inside it.
> But if the relocation index is 0, I have to calculate it by myself 
> because the calling function expects it in return.
> The binding is also supposed to tell that the muram is at 0xff002000. 
> But I don't know how I can get this info and use it to calculate the 
> index of my param RAM ? I need to calculate the index which is 1d80 
> (0x3d80 - 0x2000)

What binding are you talking about?  There is no published binding for
this yet.

As for what the driver should do, it should do an of_iomap(), but what
it does with the resulting memory depends on the compatible.  For
fsl,cpm1-spi, the result would be the parameter RAM for the device.  For
fsl,cpm1-spi-reloc and fsl,cpm2-spi, it would be the relocation
register.  The driver would either read the contents of the register, or
write a different offset.

My understanding is that the relocation register would only be zero on
the chips where we'd use fsl,cpm1-spi, not fsl,cpm1-spi-reloc.

-Scott


