Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097AbaGCJK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:10:26 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:46787 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbaGCJKS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:10:18 -0400
From: "Gupta, Pekon" <pekon@ti.com>
To: Brian Norris <computersforpeace@gmail.com>,
        Lee Jones <lee.jones@linaro.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Boris BREZILLON <b.brezillon.dev@gmail.com>
Subject: RE: [PATCH] mtd: nand: stm_nand_bch: add new driver
Thread-Topic: [PATCH] mtd: nand: stm_nand_bch: add new driver
Thread-Index: AQHPelYQfNFHZpZfZEWxVz2EEO3zm5uNWOmAgAC8JjA=
Date: Thu, 3 Jul 2014 09:09:27 +0000
Message-ID: <20980858CB6D3A4BAE95CA194937D5E73EAFAFF1@DBDE04.ent.ti.com>
References: <1401268805-26043-1-git-send-email-lee.jones@linaro.org>
 <20140703002237.GM3599@ld-irv-0074>
In-Reply-To: <20140703002237.GM3599@ld-irv-0074>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Brian Norris [mailto:computersforpeace@gmail.com]
>Hi Lee,
>
>On Wed, May 28, 2014 at 10:20:05AM +0100, Lee Jones wrote:
>> This is a squashed version of the submission to avoid re-sending the
>> entire set over and over, essentially clogging up the MLs.

Apologies, I wasn't able to review this efficiently as promised earlier.
But, I'll continue Brian's email so that all feedbacks are collated under
single thread.
Some earlier reviews on this version of patch can be found here..
[1] http://lists.infradead.org/pipermail/linux-mtd/2014-May/054041.html
[2] http://lists.infradead.org/pipermail/linux-mtd/2014-May/054042.html



>> Cc: computersforpeace@gmail.com
>> Cc: Gupta, Pekon" <pekon@ti.com>
>> Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
>> Cc: linux-mtd@lists.infradead.org
>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
>> ---
>
>Please add versioning to your next patch(es), and describe changes here.
>
>>  Documentation/devicetree/bindings/mtd/stm-nand.txt |   87 +
>
>See:
>
>  Documentation/devicetree/bindings/submitting-patches.txt
>
>You're missing devicetree@vger.kernel.org on CC, and the binding doc
>needs a separate patch. (Sorry if I confused this one earlier.)
>
>>  arch/arm/boot/dts/stih41x-b2020.dtsi               |   40 +
>
>This will need refreshed and sent as a separate patch, to go through the
>appropriate ARM tree.
>
>>  drivers/mtd/nand/Kconfig                           |   14 +
>>  drivers/mtd/nand/Makefile                          |    2 +
>>  drivers/mtd/nand/stm_nand_bch.c                    | 2415 ++++++++++++++++++++
>>  drivers/mtd/nand/stm_nand_dt.c                     |  116 +
>>  drivers/mtd/nand/stm_nand_dt.h                     |   39 +
>>  drivers/mtd/nand/stm_nand_regs.h                   |  302 +++
>>  include/linux/mtd/stm_nand.h                       |  104 +
>>  9 files changed, 3119 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/mtd/stm-nand.txt
>>  create mode 100644 drivers/mtd/nand/stm_nand_bch.c
>>  create mode 100644 drivers/mtd/nand/stm_nand_dt.c
>>  create mode 100644 drivers/mtd/nand/stm_nand_dt.h
>>  create mode 100644 drivers/mtd/nand/stm_nand_regs.h
>>  create mode 100644 include/linux/mtd/stm_nand.h
>>
>> diff --git a/Documentation/devicetree/bindings/mtd/stm-nand.txt
>b/Documentation/devicetree/bindings/mtd/stm-nand.txt
>> new file mode 100644
>> index 0000000..d957f49
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/mtd/stm-nand.txt
>> @@ -0,0 +1,87 @@
>> +STM BCH NAND Support
>> +--------------------
>> +
>> +Required properties:
>> +
>> +- compatible		: Should be "st,nand-bch"
>> +- reg			: Should contain register's location and length
>> +- reg-names		: "nand_mem" - NAND Controller register map
>> +			  "nand_dma" - BCH Controller DMA configuration map
>> +- interrupts		: Interrupt number
>> +- interrupt-names	: "nand_irq" - NAND Controller IRQ
>> +- st,nand-banks		: Subnode representing one or more "banks" of NAND
>> +			  Flash, connected to an STM NAND Controller (see
>> +			  description below).
>> +- nand-ecc-strength	: Generic NAND property (See mtd/nand.txt)
>> +			  Options are; 0, 18, 30 or 0xFF (AUTO)
>
>What is 0xFF (AUTO)?
>
>> +
>> +Properties describing Bank of NAND Flash ("st,nand-banks"):
>> +
>> +- st,nand-csn		: Chip select associated with the Bank.
>> +
>> +- st,nand-timing-relax	: [Optional] Number of IP clock cycles by which to
>> +			  "relax" timing configuration.  Required on some boards
>> +			  to accommodate board-level limitations. Applies to
>> +			  ONFI timing mode configuration.
>> +
>> +- nand-on-flash-bbt	: Generic NAND property (See mtd/nand.txt)
>> +
>> +- partitions		: [Optional] Subnode describing MTD partition map
>> +			  (see mtd/partition.txt)
>> +
>> +Note, during initialisation, the NAND Controller timing registers are configured
>> +according to one of the following methods, in order of precedence:
>> +
>> +	   1. Configuration based on ONFI timing mode, as advertised by the
>> +	      device during ONFI-probing (ONFI-compliant NAND only).
>> +
>> +	   2. Use reset/safe timing values
>> +
>> +Example:
>> +
>> +	nandbch: nand-bch {
>> +		compatible = "st,nand-bch";
>> +		reg = <0xfe901000 0x1000>, <0xfef00800 0x0800>;
>> +		reg-names = "nand_mem", "nand_dma";
>> +		interrupts = <0 139 0x0>;
>> +		interrupt-names = "nand_irq";
>> +		nand-ecc-strength = <30>;
>> +		st,nand-banks = <&nand_banks>;
>
>Is there a good reason to be a phandle, vs. just a subnode? I think
>a subnode might describe the parent/child relationship a little better.
>
>> +
>> +		status = "okay";
>> +	};
>> +
>> +	nand_banks: nand-banks {
>> +		bank0 {
>> +			/* NAND_BBT_USE_FLASH */
>> +			nand-on-flash-bbt;
>> +			st,nand-csn		= <0>;
>> +			st,nand-timing-data	= <&nand_timing0>;
>
>Where is this property documented?
>
>> +
>> +			partitions {
>> +				#address-cells = <1>;
>> +				#size-cells = <1>;
>> +
>> +				partition@0{
>> +					label = "NAND Flash 1";
>
>Do you really want spaces in your partition names?
>
>> +					reg = <0x00000000 0x00800000>;
>> +				};
>> +				partition@800000{
>> +					label = "NAND Flash 2";
>> +					reg = <0x00800000 0x0F800000>;
>> +				};
>> +			};
>> +		};
>> +	};
>> +
>> +	nand_timing0: nand-timing {
>> +		sig-setup	= <10>;
>> +		sig-hold	= <10>;
>> +		CE-deassert	= <0>;
>> +		WE-to-RBn	= <100>;
>> +		wr-on		= <10>;
>> +		wr-off		= <30>;
>> +		rd-on		= <10>;
>> +		rd-off		= <30>;
>> +		chip-delay	= <30>;		/* delay in us */
>> +	};
>
>You didn't document any of this node. And I don't think we want to
>specify every single timing parameter in DT; it may make sense to use
>Boris Brezillon's approach (I note this further down, in the driver
>code) for mapping non-ONFI NAND timings into a compatible ONFI timing
>mode. This will greatly simplify the bindings needed, since it's
>standardized and auto-detectable in many cases.
>
I hope Brian is pointing to same thing as fixed in
http://lists.infradead.org/pipermail/linux-mtd/2014-May/054041.html
"Refer comments by 'Rob Herring <robherring2@gmail.com>' on
[PATCH RFC 1/3] Devicetree: Add pl353 smc controller devicetree binding information"



>> diff --git a/arch/arm/boot/dts/stih41x-b2020.dtsi b/arch/arm/boot/dts/stih41x-b2020.dtsi
>> index bc5818d..7a6a6e8 100644
>> --- a/arch/arm/boot/dts/stih41x-b2020.dtsi
>> +++ b/arch/arm/boot/dts/stih41x-b2020.dtsi
>> @@ -52,5 +52,45 @@
>>  			pinctrl-0	= <&pinctrl_rgmii1>;
>>  		};
>>
>> +		nandbch: nand-bch {
>
>Shouldn't this be named 'nand@xxxxxxxx', 'flash@xxxxxxxx', or similar?
>
>> +			compatible = "st,nand-bch";
>> +			reg = <0xfe901000 0x1000>, <0xfef00800 0x0800>;
>> +			reg-names = "nand_mem", "nand_dma";
>> +			interrupts = <0 139 0x0>;
>> +			interrupt-names = "nand_irq";
>> +			st,nand-banks = <&nand_banks>;
>> +			nand-ecc-strength = <0xFF>;

nit-pick to save yourself from another patch re-spin, Please use lower-case hex :-)


>> +
>> +			status = "okay";
>> +		};
>> +
>> +		nand_banks: nand-banks {
>> +			/*
>> +			 * Micron MT29F8G08ABABAWP:
>> +			 *  - Size = 8Gib(1GiB); Page = 4096+224; Block = 512KiB
>> +			 *  - ECC = 4-bit/540B min
>> +			 *  - ONFI 2.1 (timing parameters retrieved during probe)
>> +			 */
>> +			bank0 {
>> +				nand-on-flash-bbt;
>> +				st,nand-csn		= <0>;
>> +				st,nand-timing-relax	= <0>;
>> +
>> +				partitions {
>> +					#address-cells	= <1>;
>> +					#size-cells	= <1>;
>> +					partition@0 {
>> +						/* 8MB */
>> +						label = "NAND Flash 1";
>> +						reg = <0x00000000 0x00800000>;
>> +					};
>> +					partition@800000 {
>> +						/* 1GB - 8MB */
>> +						label = "NAND Flash 2";
>> +						reg = <0x00800000 0x1F000000>;
Here too, Please use lower-case hex.

>> +					};
>> +				};
>> +			};
>> +		};
>>  	};
>>  };
>> diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
>> index 93ae6a6..119aed5 100644
>> --- a/drivers/mtd/nand/Kconfig
>> +++ b/drivers/mtd/nand/Kconfig
>> @@ -510,4 +510,18 @@ config MTD_NAND_XWAY
>>  	  Enables support for NAND Flash chips on Lantiq XWAY SoCs. NAND is attached
>>  	  to the External Bus Unit (EBU).
>>
>> +config MTD_NAND_STM_BCH
>> +	tristate "STMicroelectronics: NANDi BCH Controller"
>> +	depends on ARM
>> +	depends on OF
>> +	help
>> +	  Adds support for the STMicroelectronics NANDi BCH Controller.
>> +
>> +config MTD_NAND_STM_BCH_DT
>> +	tristate "STMicroelectronics: NANDi BCH Controller Device Tree support"
>> +	default MTD_NAND_STM_BCH if OF
>
>Do you really need a second Kconfig symbol? Separate C files is OK, if
>it provides good separation, but since MTD_NAND_STM_BCH is already
>dependent on CONFIG_OF, would you ever really want to build the main
>driver without the DT support? Or maybe MTD_NAND_STM_BCH shouldn't
>depend on CONFIG_OF?
>
>> +	help
>> +	  Adds support for the STMicroelectronics NANDi BCH Controller's
>> +	  Device Tree component.
>> +
>>  endif # MTD_NAND
>> diff --git a/drivers/mtd/nand/Makefile b/drivers/mtd/nand/Makefile
>> index 542b568..890f47f 100644
>> --- a/drivers/mtd/nand/Makefile
>> +++ b/drivers/mtd/nand/Makefile
>> @@ -46,6 +46,8 @@ obj-$(CONFIG_MTD_NAND_NUC900)		+= nuc900_nand.o
>>  obj-$(CONFIG_MTD_NAND_MPC5121_NFC)	+= mpc5121_nfc.o
>>  obj-$(CONFIG_MTD_NAND_RICOH)		+= r852.o
>>  obj-$(CONFIG_MTD_NAND_JZ4740)		+= jz4740_nand.o
>> +obj-$(CONFIG_MTD_NAND_STM_BCH)		+= stm_nand_bch.o
>> +obj-$(CONFIG_MTD_NAND_STM_BCH_DT)	+= stm_nand_dt.o
>>  obj-$(CONFIG_MTD_NAND_GPMI_NAND)	+= gpmi-nand/
>>  obj-$(CONFIG_MTD_NAND_XWAY)		+= xway_nand.o
>>  obj-$(CONFIG_MTD_NAND_BCM47XXNFLASH)	+= bcm47xxnflash/
>> diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
>> new file mode 100644
>> index 0000000..5ad78ce
>> --- /dev/null
>> +++ b/drivers/mtd/nand/stm_nand_bch.c
>> @@ -0,0 +1,2415 @@
>> +/*
>> + * drivers/mtd/nand/stm_nand_bch.c
>
>This line's a bit redundant and prone to error if things are renamed.
>Drop it? (And ditto for the other files?)
>
>> + *
>> + * Support for STMicroelectronics NANDi BCH Controller
>> + *
>> + * Copyright (c) 2014 STMicroelectronics Limited
>> + * Author: Angus Clark <Angus.Clark@st.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/delay.h>
>> +#include <linux/io.h>
>> +#include <linux/of.h>
>> +#include <linux/clk.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/device.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/dma-mapping.h>
>> +#include <linux/completion.h>
>> +#include <linux/mtd/nand.h>
>> +#include <linux/mtd/stm_nand.h>
>> +#include <linux/mtd/partitions.h>
>> +#include <generated/utsrelease.h>
>> +
>> +#include "stm_nand_regs.h"
>> +#include "stm_nand_dt.h"
>> +
>> +/* NANDi BCH Controller properties */
>> +#define NANDI_BCH_SECTOR_SIZE			1024
>> +#define NANDI_BCH_DMA_ALIGNMENT			64
>> +#define NANDI_BCH_MAX_BUF_LIST			8
>> +#define NANDI_BCH_BUF_LIST_SIZE			(4 * NANDI_BCH_MAX_BUF_LIST)
>> +
>> +/* BCH ECC sizes */
>> +static int bch_ecc_sizes[] = {
>> +	[BCH_18BIT_ECC] = 32,
>> +	[BCH_30BIT_ECC] = 54,
>> +	[BCH_NO_ECC] = 0,
>> +};
>> +
>> +static int bch_ecc_strength[] = {
>> +	[BCH_18BIT_ECC] = 18,
>> +	[BCH_30BIT_ECC] = 30,
>> +	[BCH_NO_ECC] = 0,
>> +};
>> +
>> +/*
>> + * Inband Bad Block Table (IBBT)
>> + */
>> +#define NAND_IBBT_NBLOCKS	4
>> +#define NAND_IBBT_SIGLEN	4
>> +#define NAND_IBBT_PRIMARY	0
>> +#define NAND_IBBT_MIRROR	1
>> +#define NAND_IBBT_SCHEMA	0x10
>> +#define NAND_IBBT_BCH_SCHEMA	0x10
>> +
>> +static uint8_t ibbt_sigs[2][NAND_IBBT_SIGLEN] = {
>> +	{'B', 'b', 't', '0'},
>> +	{'1', 't', 'b', 'B'},
>> +};
>> +
>> +static char *bbt_strs[] = {
>> +	"primary",
>> +	"mirror",
>> +};
>> +
>> +/* IBBT header */
>> +struct nand_ibbt_header {
>> +	uint8_t	signature[4];		/* "Bbt0" or "1tbB" signature */
>> +	uint8_t version;		/* BBT version ("age") */
>> +	uint8_t reserved[3];		/* padding */
>> +	uint8_t schema[4];		/* "base" schema (x4) */
>> +} __packed;
>> +
>> +/* Extend IBBT header with some stm-nand-bch niceties */
>> +struct nand_ibbt_bch_header {
>> +	struct nand_ibbt_header base;
>> +	uint8_t schema[4];		/* "private" schema (x4) */
>> +	uint8_t ecc_size[4];		/* ECC bytes (0, 32, 54) (x4) */
>> +	char	author[64];		/* Arbitrary string for S/W to use */
>> +} __packed;
>> +
>> +/* Bad Block Table (BBT) */
>> +struct nandi_bbt_info {
>> +	uint32_t	bbt_size;		/* Size of bad-block table */
>> +	uint32_t	bbt_vers[2];		/* Version (Primary/Mirror) */
>> +	uint32_t	bbt_block[2];		/* Block No. (Primary/Mirror) */
>> +	uint8_t		*bbt;			/* Table data */
>> +};
>> +
>> +/* Collection of MTD/NAND device information */
>> +struct nandi_info {
>> +	struct mtd_info		mtd;		/* MTD info */
>> +	struct nand_chip	chip;		/* NAND chip info */
>> +
>> +	struct nand_ecclayout	ecclayout;	/* MTD ECC layout */
>> +	struct nandi_bbt_info	bbt_info;	/* Bad Block Table */
>> +	int			nr_parts;	/* Number of MTD partitions */
>> +	struct	mtd_partition	*parts;		/* MTD partitions */
>> +};
>> +
>> +/* NANDi Controller (Hamming/BCH) */
>> +struct nandi_controller {
>> +	void __iomem		*base;		/* Controller base*/
>> +	void __iomem		*dma;		/* DMA control base */
>> +
>> +	struct clk		*bch_clk;
>> +	struct clk		*emi_clk;
>> +						/* IRQ-triggered Completions: */
>> +	struct completion	seq_completed;	/*   SEQ Over */
>> +	struct completion	rbn_completed;	/*   RBn */
>> +
>> +	struct device		*dev;
>> +
>> +	int			bch_ecc_mode;	/* ECC mode */
>> +	bool			extra_addr;	/* Extra address cycle */
>> +
>> +	uint32_t		blocks_per_device;
>> +	uint32_t		sectors_per_page;
>> +
>> +	uint8_t			*buf;		/* Some buffers to use */
>> +	uint8_t			*page_buf;
>> +	uint8_t			*oob_buf;
>> +	uint32_t		*buf_list;
>> +
>> +	int			cached_page;	/* page number of page in */
>> +						/* 'page_buf'             */
>> +
>> +	struct nandi_info	info;		/* NAND device info */
>> +};
>> +
>> +/* ONFI define 6 timing modes */
>> +#define ST_NAND_ONFI_TIMING_MODES		6
>> +
>> +/*
>> + * ONFI NAND Timing Mode Specifications
>> + *
>> + * Note, 'tR' field (maximum page read time) is extracted from the ONFI
>> + * parameter page during device probe.
>> + */
>> +const struct nand_sdr_timings st_nand_onfi_timing_specs[] = {
>
>Did you ever take a look at Boris Brezillon's timing patch series? He
>hasn't submitted an update recently, but it was looking good:
>
>  http://article.gmane.org/gmane.comp.hardware.netbook.arm.sunxi/7976
>
>Perhaps you could even modify/test/resubmit it (it's got a GPL Sign-off,
>after all!). I'd prefer not to stick this stuff in your driver.
>
>> +	/*
>> +	 * ONFI Timing Mode '0' (supported on all ONFI compliant devices)
>> +	 */
>> +	[0] = {
>> +		.tCLS_min	= 50,
>> +		.tCS_min	= 70,
>> +		.tALS_min	= 50,
>> +		.tDS_min	= 40,
>> +		.tWP_min	= 50,
>> +		.tCLH_min	= 20,
>> +		.tCH_min	= 20,
>> +		.tALH_min	= 20,
>> +		.tDH_min	= 20,
>> +		.tWB_max	= 200,
>> +		.tWH_min	= 30,
>> +		.tWC_min	= 100,
>> +		.tRP_min	= 50,
>> +		.tREH_min	= 30,
>> +		.tRC_min	= 100,
>> +		.tREA_max	= 40,
>> +		.tRHOH_min	= 0,
>> +		.tCEA_max	= 100,
>> +		.tCOH_min	= 0,
>> +		.tCHZ_max	= 100,
>> +	},
>> +
>> +	/*
>> +	 * ONFI Timing Mode '1'
>> +	 */
>> +	[1] = {
>> +		.tCLS_min	= 25,
>> +		.tCS_min	= 35,
>> +		.tALS_min	= 25,
>> +		.tDS_min	= 20,
>> +		.tWP_min	= 25,
>> +		.tCLH_min	= 10,
>> +		.tCH_min	= 10,
>> +		.tALH_min	= 10,
>> +		.tDH_min	= 10,
>> +		.tWB_max	= 100,
>> +		.tWH_min	= 15,
>> +		.tWC_min	= 45,
>> +		.tRP_min	= 25,
>> +		.tREH_min	= 15,
>> +		.tRC_min	= 50,
>> +		.tREA_max	= 30,
>> +		.tRHOH_min	= 15,
>> +		.tCEA_max	= 45,
>> +		.tCOH_min	= 15,
>> +		.tCHZ_max	= 50,
>> +	},
>> +
>> +	/*
>> +	 * ONFI Timing Mode '2'
>> +	 */
>> +	[2] = {
>> +		.tCLS_min	= 15,
>> +		.tCS_min	= 25,
>> +		.tALS_min	= 15,
>> +		.tDS_min	= 15,
>> +		.tWP_min	= 17,
>> +		.tCLH_min	= 10,
>> +		.tCH_min	= 10,
>> +		.tALH_min	= 10,
>> +		.tDH_min	= 5,
>> +		.tWB_max	= 100,
>> +		.tWH_min	= 15,
>> +		.tWC_min	= 35,
>> +		.tRP_min	= 17,
>> +		.tREH_min	= 16,
>> +		.tRC_min	= 35,
>> +		.tREA_max	= 25,
>> +		.tRHOH_min	= 15,
>> +		.tCEA_max	= 30,
>> +		.tCOH_min	= 15,
>> +		.tCHZ_max	= 50,
>> +	},
>> +
>> +	/*
>> +	 * ONFI Timing Mode '3'
>> +	 */
>> +	[3] = {
>> +		.tCLS_min	= 10,
>> +		.tCS_min	= 25,
>> +		.tALS_min	= 10,
>> +		.tDS_min	= 10,
>> +		.tWP_min	= 15,
>> +		.tCLH_min	= 5,
>> +		.tCH_min	= 5,
>> +		.tALH_min	= 5,
>> +		.tDH_min	= 5,
>> +		.tWB_max	= 100,
>> +		.tWH_min	= 10,
>> +		.tWC_min	= 30,
>> +		.tRP_min	= 15,
>> +		.tREH_min	= 10,
>> +		.tRC_min	= 30,
>> +		.tREA_max	= 20,
>> +		.tRHOH_min	= 15,
>> +		.tCEA_max	= 25,
>> +		.tCOH_min	= 15,
>> +		.tCHZ_max	= 50,
>> +	},
>> +
>> +	/*
>> +	 * ONFI Timing Mode '4' (EDO only)
>> +	 */
>> +	[4] = {
>> +		.tCLS_min	= 10,
>> +		.tCS_min	= 20,
>> +		.tALS_min	= 10,
>> +		.tDS_min	= 10,
>> +		.tWP_min	= 12,
>> +		.tCLH_min	= 5,
>> +		.tCH_min	= 5,
>> +		.tALH_min	= 5,
>> +		.tDH_min	= 5,
>> +		.tWB_max	= 100,
>> +		.tWH_min	= 10,
>> +		.tWC_min	= 25,
>> +		.tRP_min	= 12,
>> +		.tREH_min	= 10,
>> +		.tRC_min	= 25,
>> +		.tREA_max	= 20,
>> +		.tRHOH_min	= 15,
>> +		.tCEA_max	= 25,
>> +		.tCOH_min	= 15,
>> +		.tCHZ_max	= 30,
>> +	},
>> +
>> +	/*
>> +	 * ONFI Timing Mode '5' (EDO only)
>> +	 */
>> +	[5] = {
>> +		.tCLS_min	= 10,
>> +		.tCS_min	= 15,
>> +		.tALS_min	= 10,
>> +		.tDS_min	= 7,
>> +		.tWP_min	= 10,
>> +		.tCLH_min	= 5,
>> +		.tCH_min	= 5,
>> +		.tALH_min	= 5,
>> +		.tDH_min	= 5,
>> +		.tWB_max	= 100,
>> +		.tWH_min	= 7,
>> +		.tWC_min	= 20,
>> +		.tRP_min	= 10,
>> +		.tREH_min	= 7,
>> +		.tRC_min	= 20,
>> +		.tREA_max	= 16,
>> +		.tRHOH_min	= 15,
>> +		.tCEA_max	= 25,
>> +		.tCOH_min	= 15,
>> +		.tCHZ_max	= 30,
>> +	}
>> +};
>> +
>> +/* BCH 'program' structure */
>> +struct bch_prog {
>> +	u32	multi_cs_addr[3];
>> +	u32	multi_cs_config;
>> +	u8	seq[16];
>> +	u32	addr;
>> +	u32	extra;
>> +	u8	cmd[4];
>> +	u32	reserved1;
>> +	u32	gen_cfg;
>> +	u32	delay;
>> +	u32	reserved2;
>> +	u32	seq_cfg;
>> +};
>> +
>> +/* BCH template programs (modified on-the-fly) */
>> +static struct bch_prog bch_prog_read_page = {
>> +	.cmd = {
>> +		NAND_CMD_READ0,
>> +		NAND_CMD_READSTART,
>> +	},
>> +	.seq = {
>> +		BCH_ECC_SCORE(0),
>> +		BCH_CMD_ADDR,
>> +		BCH_CL_CMD_1,
>> +		BCH_DATA_2_SECTOR,
>> +		BCH_STOP,
>> +	},
>> +	.gen_cfg = (GEN_CFG_DATA_8_NOT_16 |
>> +		    GEN_CFG_EXTRA_ADD_CYCLE |
>> +		    GEN_CFG_LAST_SEQ_NODE),
>> +	.seq_cfg = SEQ_CFG_GO_STOP,
>> +};
>> +
>> +static struct bch_prog bch_prog_write_page = {
>> +	.cmd = {
>> +		NAND_CMD_SEQIN,
>> +		NAND_CMD_PAGEPROG,
>> +		NAND_CMD_STATUS,
>> +	},
>> +	.seq = {
>> +		BCH_CMD_ADDR,
>> +		BCH_DATA_4_SECTOR,
>> +		BCH_CL_CMD_1,
>> +		BCH_CL_CMD_2,
>> +		BCH_OP_ERR,
>> +		BCH_STOP,
>> +	},
>> +	.gen_cfg = (GEN_CFG_DATA_8_NOT_16 |
>> +		    GEN_CFG_EXTRA_ADD_CYCLE |
>> +		    GEN_CFG_LAST_SEQ_NODE),
>> +	.seq_cfg = (SEQ_CFG_GO_STOP |
>> +		    SEQ_CFG_DATA_WRITE),
>> +};
>> +
>> +static struct bch_prog bch_prog_erase_block = {
>> +	.seq = {
>> +		BCH_CL_CMD_1,
>> +		BCH_AL_EX_0,
>> +		BCH_AL_EX_1,
>> +		BCH_AL_EX_2,
>> +		BCH_CL_CMD_2,
>> +		BCH_CL_CMD_3,
>> +		BCH_OP_ERR,
>> +		BCH_STOP,
>> +	},
>> +	.cmd = {
>> +		NAND_CMD_ERASE1,
>> +		NAND_CMD_ERASE1,
>> +		NAND_CMD_ERASE2,
>> +		NAND_CMD_STATUS,
>> +	},
>> +	.gen_cfg = (GEN_CFG_DATA_8_NOT_16 |
>> +		    GEN_CFG_EXTRA_ADD_CYCLE |
>> +		    GEN_CFG_LAST_SEQ_NODE),
>> +	.seq_cfg = (SEQ_CFG_GO_STOP |
>> +		    SEQ_CFG_ERASE),
>> +};
>> +
>> +/* Configure BCH read/write/erase programs */
>> +static void bch_configure_progs(struct nandi_controller *nandi)
>> +{
>> +	uint8_t data_opa = ffs(nandi->sectors_per_page) - 1;
>> +	uint8_t data_instr = BCH_INSTR(BCH_OPC_DATA, data_opa);
>> +	uint32_t gen_cfg_ecc = nandi->bch_ecc_mode << GEN_CFG_ECC_SHIFT;
>> +
>> +	/* Set 'DATA' instruction */
>> +	bch_prog_read_page.seq[3] = data_instr;
>> +	bch_prog_write_page.seq[1] = data_instr;
>> +
>> +	/* Set ECC mode */
>> +	bch_prog_read_page.gen_cfg |= gen_cfg_ecc;
>> +	bch_prog_write_page.gen_cfg |= gen_cfg_ecc;
>> +	bch_prog_erase_block.gen_cfg |= gen_cfg_ecc;
>> +
>> +	/*
>> +	 * Template sequences above are defined for devices that use 5 address
>> +	 * cycles for page Read/Write operations (and 3 for Erase operations).
>> +	 * Update sequences for devices that use 4 address cycles.
>> +	 */
>> +	if (!nandi->extra_addr) {
>> +		/* Clear 'GEN_CFG_EXTRA_ADD_CYCLE' flag */
>> +		bch_prog_read_page.gen_cfg &= ~GEN_CFG_EXTRA_ADD_CYCLE;
>> +		bch_prog_write_page.gen_cfg &= ~GEN_CFG_EXTRA_ADD_CYCLE;
>> +		bch_prog_erase_block.gen_cfg &= ~GEN_CFG_EXTRA_ADD_CYCLE;
>> +
>> +		/* Configure Erase sequence for 2 address cycles */
>> +		/* (page address) */
>> +		bch_prog_erase_block.seq[0] = BCH_CL_CMD_1;
>> +		bch_prog_erase_block.seq[1] = BCH_AL_EX_0;
>> +		bch_prog_erase_block.seq[2] = BCH_AL_EX_1;
>> +		bch_prog_erase_block.seq[3] = BCH_CL_CMD_2;
>> +		bch_prog_erase_block.seq[4] = BCH_CL_CMD_3;
>> +		bch_prog_erase_block.seq[5] = BCH_OP_ERR;
>> +		bch_prog_erase_block.seq[6] = BCH_STOP;
>> +	}
>> +}
>> +
>> +/*
>> + * NANDi Interrupts (shared by Hamming and BCH controllers)
>> + */
>> +static irqreturn_t nandi_irq_handler(int irq, void *dev)
>> +{
>> +	struct nandi_controller *nandi = dev;
>> +	unsigned int status;
>> +
>> +	status = readl(nandi->base + NANDBCH_INT_STA);
>> +
>> +	if (status & NANDBCH_INT_SEQNODESOVER) {
>> +		/* BCH */
>> +		writel(NANDBCH_INT_CLR_SEQNODESOVER,
>> +		       nandi->base + NANDBCH_INT_CLR);
>> +		complete(&nandi->seq_completed);
>> +	}
>> +	if (status & NAND_INT_RBN) {
>> +		/* Hamming */
>> +		writel(NAND_INT_CLR_RBN, nandi->base + NANDHAM_INT_CLR);
>> +		complete(&nandi->rbn_completed);
>> +	}
>> +
>> +	return IRQ_HANDLED;

Did you miss following comments ?
[RFC 05/47] mtd: nand: stm_nand_bch: IRQ support for ST's BCH NAND Controller driver
http://lists.infradead.org/pipermail/linux-mtd/2014-March/052916.html

Shouldn't IRQ_NONE be returned if no valid irq_status was found ?

>> +}
>> +
>> +static void nandi_enable_interrupts(struct nandi_controller *nandi,
>> +				    uint32_t irqs)
>> +{
>> +	uint32_t val;
>> +
>> +	val = readl(nandi->base + NANDBCH_INT_EN);
>> +	val |= irqs;
>> +	writel(val, nandi->base + NANDBCH_INT_EN);
>> +}
>> +
>> +static void nandi_disable_interrupts(struct nandi_controller *nandi,
>> +				     uint32_t irqs)
>> +{
>> +	uint32_t val;
>> +
>> +	val = readl(nandi->base + NANDBCH_INT_EN);
>> +	val &= ~irqs;
>> +	writel(val, nandi->base + NANDBCH_INT_EN);
>> +}
>> +
>> +/*
>> + * BCH Operations
>> + */
>> +static inline void bch_load_prog_cpu(struct nandi_controller *nandi,
>> +				     struct bch_prog *prog)
>> +{
>> +	uint32_t *src = (uint32_t *)prog;
>> +	uint32_t *dst = (uint32_t *)(nandi->base + NANDBCH_ADDRESS_REG_1);
>> +	int i;
>> +
>> +	for (i = 0; i < 16; i++) {
>> +		/* Skip registers marked as "reserved" */
>> +		if (i != 11 && i != 14)

Using macros for 11, 14, and 16 would make it more readable.

>> +			writel(*src, dst);
>> +		dst++;
>> +		src++;
>> +	}
>> +}
>> +
>> +static void bch_wait_seq(struct nandi_controller *nandi)
>> +{
>> +	int ret;
>> +
>> +	ret = wait_for_completion_timeout(&nandi->seq_completed, HZ/2);

Are you sure you want to use same timeout value for all operations
like ERASE, READ, WRITE ? because
(1) There is wide variance between:
- BLOCK_ERASE:  max(tBER) = 10ms) for MT29F4G08 Micron NAND
- PAGE_ERASE: max(tPROG) = 600usec for same Micron part.

(2) The value of HZ varies across kernel versions and hardware platforms.

I suggest you pass the timeout value in call to bch_wait_seq().
And this timeout value should be like 2x of typical value of which you found
during ONFI parsing, or from DT


>> +	if (!ret)
>> +		dev_err(nandi->dev, "BCH Seq timeout\n");
>> +}
>> +
>> +static uint8_t bch_erase_block(struct nandi_controller *nandi,
>> +			       loff_t offs)
>> +{
>> +	struct nand_chip *chip = &nandi->info.chip;
>> +	struct bch_prog *prog = &bch_prog_erase_block;
>> +	uint8_t status;
>> +
>> +	dev_dbg(nandi->dev, "%s: offs = 0x%012llx\n", __func__, offs);
>> +
>> +	prog->extra = (uint32_t)(offs >> chip->page_shift);
>> +
>> +	emiss_nandi_select(STM_NANDI_BCH);
>> +
>> +	nandi_enable_interrupts(nandi, NANDBCH_INT_SEQNODESOVER);
>> +	reinit_completion(&nandi->seq_completed);
>> +
>> +	bch_load_prog_cpu(nandi, prog);
>> +
>> +	bch_wait_seq(nandi);
>> +
>> +	nandi_disable_interrupts(nandi, NANDBCH_INT_SEQNODESOVER);
>> +
>> +	status = (uint8_t)(readl(nandi->base +
>> +				 NANDBCH_CHECK_STATUS_REG_A) & 0xff);
>> +
>> +	return status;
>> +}
>> +
>> +static int bch_erase(struct mtd_info *mtd, int page)
>> +{
>> +	struct nand_chip *chip = mtd->priv;
>> +	struct nandi_controller *nandi = chip->priv;
>> +	uint32_t page_size = mtd->writesize;
>> +	loff_t offs = page * page_size;
>
>You might have an overflow bug here, for >= 4GB NAND. You should cast to
>loff_t before the multiplication. Examine the rest of your driver for
>similar bugs; I think there's at least two repeats of this.
>
>(Related: Coverity caught a whole bunch of these type of bugs in the MTD
>test modules. I have fixes queued up that I meant to test and submit
>soon.)
>
>> +
>> +	return bch_erase_block(nandi, offs);
>> +}
>> +
>> +/*
>> + * Detect an erased page, tolerating and correcting up to a specified number of
>> + * bits at '0'.  (For many devices, it is now deemed within spec for an erased
>> + * page to include a number of bits at '0', either as a result of read-disturb
>> + * behaviour or 'stuck-at-zero' failures.)  Returns the number of corrected
>> + * bits, or a '-1' if we have exceeded the maximum number of bits at '0' (likely
>> + * to be a genuine uncorrectable ECC error).  In the latter case, the data must
>> + * be returned unmodified, in accordance with the MTD API.
>> + */
>> +static int check_erased_page(uint8_t *data, uint32_t page_size, int max_zeros)
>
>Another "check erased page" implementation? Sigh... it would be nice if
>we could agree on a common implementation to share. My last attempt was
>unsuccessful, since some drivers have some very odd requirements.
>
>> +{
>> +	uint8_t *b = data;
>> +	int zeros = 0;
>> +	int i;
>> +
>> +	for (i = 0; i < page_size; i++) {
>> +		zeros += hweight8(~*b++);
Are you sure you want to use hweight8 ?
hweight32 or something should give better performance, plz check.
because this piece of code (check_xx_bitflips) sometimes becomes
bottle neck for READ path.

>> +		if (zeros > max_zeros)
>> +			return -1;
>> +	}
>> +
>> +	if (zeros)
>> +		memset(data, 0xff, page_size);
>
>It seems like you're not considering the spare area at all. What if this
>is a mostly-blank page, with ECC data, but most of the bitflips are in
>the spare area? Then you will "correct" this page to all 0xFF, not
>noticing that this was really not a blank page at all.
>
>> +
>> +	return zeros;
>> +}
>> +
>> +/* Returns the number of ECC errors, or '-1' for uncorrectable error */
>> +static int bch_read_page(struct nandi_controller *nandi,
>> +			 loff_t offs,
>> +			 uint8_t *buf)
>> +{
>> +	struct nand_chip *chip = &nandi->info.chip;
>> +	struct bch_prog *prog = &bch_prog_read_page;
>> +	uint32_t page_size = nandi->info.mtd.writesize;
>> +	unsigned long list_phys;
>> +	unsigned long buf_phys;
>> +	uint32_t ecc_err;
>> +	int ret = 0;
>> +
>> +	dev_dbg(nandi->dev, "%s: offs = 0x%012llx\n", __func__, offs);
>> +
>> +	BUG_ON(offs & (NANDI_BCH_DMA_ALIGNMENT - 1));
>> +
>> +	emiss_nandi_select(STM_NANDI_BCH);
>> +
>> +	nandi_enable_interrupts(nandi, NANDBCH_INT_SEQNODESOVER);
>> +	reinit_completion(&nandi->seq_completed);
>> +
>> +	/* Reset ECC stats */
>> +	writel(CFG_RESET_ECC_ALL | CFG_ENABLE_AFM,
>> +	       nandi->base + NANDBCH_CONTROLLER_CFG);
>> +	writel(CFG_ENABLE_AFM, nandi->base + NANDBCH_CONTROLLER_CFG);
>> +
>> +	prog->addr = (uint32_t)((offs >> (chip->page_shift - 8)) & 0xffffff00);
>> +
>> +	buf_phys = dma_map_single(NULL, buf, page_size, DMA_FROM_DEVICE);
>> +
>> +	memset(nandi->buf_list, 0x00, NANDI_BCH_BUF_LIST_SIZE);
>> +	nandi->buf_list[0] = buf_phys | (nandi->sectors_per_page - 1);
>> +
>> +	list_phys = dma_map_single(NULL, nandi->buf_list,
>> +				   NANDI_BCH_BUF_LIST_SIZE, DMA_TO_DEVICE);
>> +
>> +	writel(list_phys, nandi->base + NANDBCH_BUFFER_LIST_PTR);
>> +
>> +	bch_load_prog_cpu(nandi, prog);
>> +
>> +	bch_wait_seq(nandi);
>> +
>> +	nandi_disable_interrupts(nandi, NANDBCH_INT_SEQNODESOVER);
>> +
>> +	dma_unmap_single(NULL, list_phys, NANDI_BCH_BUF_LIST_SIZE,
>> +			 DMA_TO_DEVICE);
>> +	dma_unmap_single(NULL, buf_phys, page_size, DMA_FROM_DEVICE);
>> +
>> +	/* Use the maximum per-sector ECC count! */
>> +	ecc_err = readl(nandi->base + NANDBCH_ECC_SCORE_REG_A) & 0xff;
>> +	if (ecc_err == 0xff) {
>> +		/*
>> +		 * Downgrade uncorrectable ECC error for an erased page,
>> +		 * tolerating 'bch_ecc_strength' bits at zero.
>
>Couldn't this (more straightforwarly) just be chip->ecc.strength?
>
>But then, do you really want to "correct" that many bits in an erased
>page? What if there are stuck 1 bits, too? Then when you finally program
>the page, you may have more errors than you can actually correct.
>
>Maybe chip->ecc.strength / 2 would be a good compromise, allowing for a
>50/50 distribution of 0->1 and 1->0 errors.
>
>> +		 */
>> +		ret = check_erased_page(buf, page_size,
>> +					bch_ecc_strength[nandi->bch_ecc_mode]);

You should use chip->ecc.strength here instead of 'bch_ecc_strength[nandi->bch_ecc_mode]'
Though both mean same in your case, but chip->ecc.strength is generic
term used from NAND framework point of view.

>> +		if (ret >= 0)
>> +			dev_dbg(nandi->dev,
>> +				"%s: erased page detected: \n"
>> +				"  downgrading uncorrectable ECC error.\n",
>> +				__func__);
>
>You seem to be missing all handling of mtd->ecc_stats; you need to
>increment mtd->ecc_stats.corrected or mtd->ecc_stats.failed for
>corrected bitlips and ECC failure reporting. Otherwise, the MTD API will
>not report -EUCLEAN and -EBADMSG properly.
>
>> +	} else {
>> +		ret = (int)ecc_err;

Yes, updating mtd->ecc_stats is important, something like ...
	if (ret < 0)
		mtd->ecc_stats.failed++;
	else
		mtd->ecc_stats.corrected += stat;
And it should be done either for both erased-page and programmed-page,
Otherwise you can do that in bch_read(), common path for all chip-_read().


>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +static int bch_read(struct mtd_info *mtd, struct nand_chip *chip,
>> +			 uint8_t *buf, int oob_required, int page)
>> +{
>> +	struct nandi_controller *nandi = chip->priv;
>> +	uint32_t page_size = mtd->writesize;
>> +	loff_t offs = page * page_size;
>
>32-bit overflow
>
>> +	bool bounce = false;
>> +	uint8_t *p;
>> +	int ret;
>> +
>> +	if (((unsigned int)buf & (NANDI_BCH_DMA_ALIGNMENT - 1)) ||
>> +	    (!virt_addr_valid(buf))) /* vmalloc'd buffer! */
>> +		bounce = true;
>> +
>> +	p = bounce ? nandi->page_buf : buf;
>
>It looks like you're reimplementing NAND_USE_BOUNCE_BUFFER. Can you try
>using that flag? (You may need to extend it to account for your DMA
>alignment, too.)
>
>> +
>> +	ret = bch_read_page(nandi, offs, p);
>> +
>> +	if (bounce)
>> +		memcpy(buf, p, page_size);
>> +
>> +	return ret;
>> +}
>> +
>> +/* Returns the status of the NAND device following the write operation */
>> +static uint8_t bch_write_page(struct nandi_controller *nandi,
>> +			      loff_t offs, const uint8_t *buf)
>> +{
>> +	struct nand_chip *chip = &nandi->info.chip;
>> +	struct bch_prog *prog = &bch_prog_write_page;
>> +	uint32_t page_size = nandi->info.mtd.writesize;
>> +	uint8_t *p = (uint8_t *)buf;
>> +	unsigned long list_phys;
>> +	unsigned long buf_phys;
>> +	uint8_t status;
>> +	bool bounce = false;
>> +
>> +	dev_dbg(nandi->dev, "%s: offs = 0x%012llx\n", __func__, offs);
>> +
>> +	BUG_ON(offs & (page_size - 1));
>> +
>> +	if (((unsigned long)buf & (NANDI_BCH_DMA_ALIGNMENT - 1)) ||
>> +	    !virt_addr_valid(buf)) { /* vmalloc'd buffer! */
>> +		bounce = true;
>> +	}
>> +
>> +	if (bounce) {
>> +		memcpy(nandi->page_buf, buf, page_size);
>> +		p = nandi->page_buf;
>> +		nandi->cached_page = -1;
>> +	}
>> +
>> +	emiss_nandi_select(STM_NANDI_BCH);
>> +
>> +	nandi_enable_interrupts(nandi, NANDBCH_INT_SEQNODESOVER);
>> +	reinit_completion(&nandi->seq_completed);
>> +
>> +	prog->addr = (uint32_t)((offs >> (chip->page_shift - 8)) & 0xffffff00);
>> +
>> +	buf_phys = dma_map_single(NULL, p, page_size, DMA_TO_DEVICE);
>> +	memset(nandi->buf_list, 0x00, NANDI_BCH_BUF_LIST_SIZE);
>> +	nandi->buf_list[0] = buf_phys | (nandi->sectors_per_page - 1);
>> +
>> +	list_phys = dma_map_single(NULL, nandi->buf_list,
>> +				   NANDI_BCH_BUF_LIST_SIZE, DMA_TO_DEVICE);
>> +
>> +	writel(list_phys, nandi->base + NANDBCH_BUFFER_LIST_PTR);
>> +
>> +	bch_load_prog_cpu(nandi, prog);
>> +
>> +	bch_wait_seq(nandi);
>> +
>> +	nandi_disable_interrupts(nandi, NANDBCH_INT_SEQNODESOVER);
>> +
>> +	dma_unmap_single(NULL, list_phys, NANDI_BCH_BUF_LIST_SIZE,
>> +			 DMA_TO_DEVICE);
>> +	dma_unmap_single(NULL, buf_phys, page_size, DMA_FROM_DEVICE);
>> +
>> +	status = (uint8_t)(readl(nandi->base +
>> +				 NANDBCH_CHECK_STATUS_REG_A) & 0xff);
>> +
>> +	return status;
>> +}
>> +
>> +static int bch_write(struct mtd_info *mtd, struct nand_chip *chip,
>> +		     uint32_t offset, int data_len, const uint8_t *buf,
>> +		     int oob_required, int page, int cached, int raw)
>> +{
>> +	struct nandi_controller *nandi = chip->priv;
>> +	uint32_t page_size = mtd->writesize;
>> +	loff_t offs = page * page_size;
>
>32-bit overflow
>
>> +	int ret;
>> +
>> +	ret = bch_write_page(nandi, offs, buf);
>> +	if (ret & NAND_STATUS_FAIL)
>> +		return -EIO;
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>> + * Hamming-FLEX operations
>> + */
>> +static int flex_wait_rbn(struct nandi_controller *nandi)
>> +{
>> +	int ret;
>> +
>> +	ret = wait_for_completion_timeout(&nandi->rbn_completed, HZ/2);
>> +	if (!ret)
>> +		dev_err(nandi->dev, "FLEX RBn timeout\n");
>> +
>> +	return ret;
>> +}
>> +
>> +static void flex_cmd(struct nandi_controller *nandi, uint8_t cmd)
>> +{
>> +	uint32_t val;
>> +
>> +	val = (FLEX_CMD_CSN | FLEX_CMD_BEATS_1 | cmd);
>> +	writel(val, nandi->base + NANDHAM_FLEX_CMD);
>> +}
>> +
>> +static void flex_addr(struct nandi_controller *nandi,
>> +		      uint32_t addr, int cycles)
>> +{
>> +	addr &= 0x00ffffff;
>> +
>> +	BUG_ON(cycles < 1);
>> +	BUG_ON(cycles > 3);
>> +
>> +	addr |= (FLEX_ADDR_CSN | FLEX_ADDR_ADD8_VALID);
>> +	addr |= (cycles & 0x3) << 28;
>> +
>> +	writel(addr, nandi->base + NANDHAM_FLEX_ADD);
>> +}
>> +
>> +/*
>> + * Partial implementation of MTD/NAND Interface, based on Hamming-FLEX
>> + * operation.
>> + *
>> + * Allows us to make use of nand_base.c functions where possible
>> + * (e.g. nand_scan_ident() and friends).
>> + */
>> +static void flex_command_lp(struct mtd_info *mtd, unsigned int command,
>> +			    int column, int page)
>> +{
>> +	struct nand_chip *chip = mtd->priv;
>> +	struct nandi_controller *nandi = chip->priv;
>> +
>> +	emiss_nandi_select(STM_NANDI_HAMMING);
>> +
>> +	switch (command) {
>> +	case NAND_CMD_READOOB:
>> +		/* Emulate NAND_CMD_READOOB */
>> +		column += mtd->writesize;
>> +		command = NAND_CMD_READ0;
>> +		break;
>> +	case NAND_CMD_READ0:
>> +	case NAND_CMD_ERASE1:
>> +	case NAND_CMD_SEQIN:
>> +	case NAND_CMD_RESET:
>> +	case NAND_CMD_PARAM:
>> +		/* Prime RBn wait */
>> +		nandi_enable_interrupts(nandi, NAND_INT_RBN);
>> +		reinit_completion(&nandi->rbn_completed);
>> +		break;
>> +	case NAND_CMD_READID:
>> +	case NAND_CMD_STATUS:
>> +	case NAND_CMD_ERASE2:
>> +		break;
>> +	default:
>> +		/* Catch unexpected commands */
>> +		BUG();
>> +	}
>> +
>> +	/*
>> +	 * Command Cycle
>> +	 */
>> +	flex_cmd(nandi, command);
>> +
>> +	/*
>> +	 * Address Cycles
>> +	 */
>> +	if (column != -1)
>> +		flex_addr(nandi, column,
>> +			  (command == NAND_CMD_READID) ? 1 : 2);
>> +
>> +	if (page != -1)
>> +		flex_addr(nandi, page, nandi->extra_addr ? 3 : 2);
>> +
>> +	/* Complete 'READ0' command */
>> +	if (command == NAND_CMD_READ0)
>> +		flex_cmd(nandi, NAND_CMD_READSTART);
>> +
>> +	/* Wait for RBn, if required                        */
>> +	/* (Note, other commands may handle wait elsewhere) */
>> +	if (command == NAND_CMD_RESET ||
>> +	    command == NAND_CMD_READ0 ||
>> +	    command == NAND_CMD_PARAM) {
>> +		flex_wait_rbn(nandi);
>> +		nandi_disable_interrupts(nandi, NAND_INT_RBN);
>> +	}
>> +}
>> +
>> +static uint8_t flex_read_byte(struct mtd_info *mtd)
>> +{
>> +	struct nand_chip *chip = mtd->priv;
>> +	struct nandi_controller *nandi = chip->priv;
>> +
>> +	emiss_nandi_select(STM_NANDI_HAMMING);
>> +
>> +	return (uint8_t)(readl(nandi->base + NANDHAM_FLEX_DATA) & 0xff);
>> +}
>> +
>> +static int flex_wait_func(struct mtd_info *mtd, struct nand_chip *chip)
>> +{
>> +	struct nandi_controller *nandi = chip->priv;
>> +
>> +	emiss_nandi_select(STM_NANDI_HAMMING);
>> +
>> +	flex_wait_rbn(nandi);
>> +
>> +	flex_cmd(nandi, NAND_CMD_STATUS);
>> +
>> +	return (int)(readl(nandi->base + NANDHAM_FLEX_DATA) & 0xff);
>> +}
>> +
>> +/* Multi-CS devices not supported */
>> +static void flex_select_chip(struct mtd_info *mtd, int chipnr)
>> +{
>> +
>> +}
>> +
>> +static void flex_read_buf(struct mtd_info *mtd, uint8_t *buf, int len)
>> +{
>> +	struct nand_chip *chip = mtd->priv;
>> +	struct nandi_controller *nandi = chip->priv;
>> +	int aligned;
>> +
>> +	emiss_nandi_select(STM_NANDI_HAMMING);
>> +
>> +	/* Read bytes until buf is 4-byte aligned */
>> +	while (len && ((unsigned int)buf & 0x3)) {
>> +		*buf++ = (uint8_t)(readl(nandi->base + NANDHAM_FLEX_DATA)
>> +				   & 0xff);
>> +		len--;
>> +	};
>> +
>> +	/* Use 'BEATS_4'/readsl */
>> +	if (len > 8) {
>> +		aligned = len & ~0x3;
>> +		writel(FLEX_DATA_CFG_BEATS_4 | FLEX_DATA_CFG_CSN,
>> +		       nandi->base + NANDHAM_FLEX_DATAREAD_CONFIG);
>> +
>> +		readsl(nandi->base + NANDHAM_FLEX_DATA, buf, aligned >> 2);
>> +
>> +		buf += aligned;
>> +		len -= aligned;
>> +
>> +		writel(FLEX_DATA_CFG_BEATS_1 | FLEX_DATA_CFG_CSN,
>> +		       nandi->base + NANDHAM_FLEX_DATAREAD_CONFIG);
>> +	}
>> +
>> +	/* Mop up remaining bytes */
>> +	while (len > 0) {
>> +		*buf++ = (uint8_t)(readl(nandi->base + NANDHAM_FLEX_DATA)
>> +				   & 0xff);
>> +		len--;
>> +	}
>> +}
>> +
>> +static void flex_write_buf(struct mtd_info *mtd, const uint8_t *buf, int len)
>> +{
>> +	struct nand_chip *chip = mtd->priv;
>> +	struct nandi_controller *nandi = chip->priv;
>> +	int aligned;
>> +
>> +	/* Write bytes until buf is 4-byte aligned */
>> +	while (len && ((unsigned int)buf & 0x3)) {
>> +		writel(*buf++, nandi->base + NANDHAM_FLEX_DATA);
>> +		len--;
>> +	};
>> +
>> +	/* USE 'BEATS_4/writesl */
>> +	if (len > 8) {
>> +		aligned = len & ~0x3;
>> +		writel(FLEX_DATA_CFG_BEATS_4 | FLEX_DATA_CFG_CSN,
>> +		       nandi->base + NANDHAM_FLEX_DATAWRITE_CONFIG);
>> +		writesl(nandi->base + NANDHAM_FLEX_DATA, buf, aligned >> 2);
>> +		buf += aligned;
>> +		len -= aligned;
>> +		writel(FLEX_DATA_CFG_BEATS_1 | FLEX_DATA_CFG_CSN,
>> +		       nandi->base + NANDHAM_FLEX_DATAWRITE_CONFIG);
>> +	}
>> +
>> +	/* Mop up remaining bytes */
>> +	while (len > 0) {
>> +		writel(*buf++, nandi->base + NANDHAM_FLEX_DATA);
>> +		len--;
>> +	}
>> +}
>> +
>> +static int flex_read_raw(struct nandi_controller *nandi,
>> +			 uint32_t page_addr,
>> +			 uint32_t col_addr,
>> +			 uint8_t *buf, uint32_t len)
>> +{
>> +	dev_dbg(nandi->dev, "%s %u bytes at [0x%06x,0x%04x]\n",
>> +		__func__, len, page_addr, col_addr);
>> +
>> +	BUG_ON(len & 0x3);
>> +	BUG_ON((unsigned long)buf & 0x3);
>> +
>> +	emiss_nandi_select(STM_NANDI_HAMMING);
>> +	nandi_enable_interrupts(nandi, NAND_INT_RBN);
>> +	reinit_completion(&nandi->rbn_completed);
>> +
>> +	writel(FLEX_DATA_CFG_BEATS_4 | FLEX_DATA_CFG_CSN,
>> +	       nandi->base + NANDHAM_FLEX_DATAREAD_CONFIG);
>> +
>> +	flex_cmd(nandi, NAND_CMD_READ0);
>> +	flex_addr(nandi, col_addr, 2);
>> +	flex_addr(nandi, page_addr, nandi->extra_addr ? 3 : 2);
>> +	flex_cmd(nandi, NAND_CMD_READSTART);
>> +
>> +	flex_wait_rbn(nandi);
>> +
>> +	readsl(nandi->base + NANDHAM_FLEX_DATA, buf, len / 4);
>> +
>> +	nandi_disable_interrupts(nandi, NAND_INT_RBN);
>> +
>> +	writel(FLEX_DATA_CFG_BEATS_1 | FLEX_DATA_CFG_CSN,
>> +	       nandi->base + NANDHAM_FLEX_DATAREAD_CONFIG);
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>> + * Bad Block Tables/Bad Block Markers
>> + */
>> +#define BBT_MARK_BAD_FACTORY	0x0
>> +#define BBT_MARK_BAD_WEAR	0x1
>> +#define BBT_MARK_GOOD		0x3
>> +
>> +static void bbt_set_block_mark(uint8_t *bbt, uint32_t block, uint8_t mark)
>> +{
>> +	unsigned int byte = block >> 2;
>> +	unsigned int shift = (block & 0x3) << 1;
>> +
>> +	bbt[byte] &= ~(0x3 << shift);
>> +	bbt[byte] |= ((mark & 0x3) << shift);
>> +}
>> +
>> +static uint8_t bbt_get_block_mark(uint8_t *bbt, uint32_t block)
>> +{
>> +	unsigned int byte = block >> 2;
>> +	unsigned int shift = (block & 0x3) << 1;
>> +
>> +	return (bbt[byte] >> shift) & 0x3;
>> +}
>> +
>> +static int bbt_is_block_bad(uint8_t *bbt, uint32_t block)
>> +{
>> +	return bbt_get_block_mark(bbt, block) == BBT_MARK_GOOD ? 0 : 1;
>> +}
>> +
>> +/* Scan page for BBM(s), according to specified BBT options */
>> +static int nandi_scan_bad_block_markers_page(struct nandi_controller *nandi,
>> +					     uint32_t page)
>> +{
>> +	struct mtd_info *mtd = &nandi->info.mtd;
>> +	struct nand_chip *chip = mtd->priv;
>> +	uint8_t *oob_buf = nandi->oob_buf;
>> +	int i, e;
>> +
>> +	/* Read the OOB area */
>> +	flex_read_raw(nandi, page, mtd->writesize, oob_buf, mtd->oobsize);
>> +
>> +	if (oob_buf[chip->badblockpos] == 0xff)
>> +		return 0;
>> +
>> +	/* Tolerate 'alien' Hamming Boot Mode ECC */
>> +	e = 0;
>> +	for (i = 0; i < mtd->oobsize; i += 16)
>> +		e += hweight8(oob_buf[i + 3] ^ 'B');
>> +	if (e <= 1)
>> +		return 0;
>> +
>> +	/* Tolerate 'alien' Hamming AFM ECC */
>> +	e = 0;
>> +	for (i = 0; i < mtd->oobsize; i += 16) {
>> +		e += hweight8(oob_buf[i + 3] ^ 'A');
>> +		e += hweight8(oob_buf[i + 4] ^ 'F');
>> +		e += hweight8(oob_buf[i + 5] ^ 'M');
>> +		if (e <= 1)
>> +			return 0;
>> +	}
>> +
>> +	return 1;
>> +}
>> +
>> +/* Scan block for BBM(s), according to specified BBT options */
>> +static int nandi_scan_bad_block_markers_block(struct nandi_controller *nandi,
>> +					      uint32_t block)
>> +
>> +{
>> +	struct mtd_info *mtd = &nandi->info.mtd;
>> +	struct nand_chip *chip = mtd->priv;
>> +	uint32_t pages_per_block = mtd->erasesize >> chip->page_shift;
>> +	uint32_t page = block << (chip->phys_erase_shift - chip->page_shift);
>> +
>> +	if (nandi_scan_bad_block_markers_page(nandi, page))
>> +		return 1;
>> +
>> +	if ((chip->bbt_options & NAND_BBT_SCAN2NDPAGE) &&
>> +	    nandi_scan_bad_block_markers_page(nandi, page + 1))
>> +		return 1;
>> +
>> +	if ((chip->bbt_options & NAND_BBT_SCANLASTPAGE) &&
>> +	    nandi_scan_bad_block_markers_page(nandi,
>> +					      page + pages_per_block - 1))
>> +		return 1;
>> +
>> +	return 0;
>> +}
>> +
>> +/* Scan for BBMs and build memory-resident BBT */
>> +static int nandi_scan_build_bbt(struct nandi_controller *nandi,
>> +				struct nandi_bbt_info *bbt_info)
>> +{
>> +	struct mtd_info *mtd = &nandi->info.mtd;
>> +	struct nand_chip *chip = mtd->priv;
>> +	uint32_t page_size = mtd->writesize;
>> +	uint8_t *bbt = bbt_info->bbt;
>> +	uint32_t block;
>> +
>> +	dev_dbg(nandi->dev,
>> +		"scan device for bad-block markers [bbt options = 0x%02x]\n",
>> +		chip->bbt_options);
>> +
>> +	memset(bbt, 0xff, page_size);
>> +	bbt_info->bbt_vers[0] = 0;
>> +	bbt_info->bbt_vers[1] = 0;
>> +	bbt_info->bbt_block[0] = nandi->blocks_per_device - 1;
>> +	bbt_info->bbt_block[1] = nandi->blocks_per_device - 2;
>> +
>> +	for (block = 0; block < nandi->blocks_per_device; block++)
>> +		if (nandi_scan_bad_block_markers_block(nandi, block))
>> +			bbt_set_block_mark(bbt, block, BBT_MARK_BAD_FACTORY);
>> +
>> +	return 0;
>> +}
>> +
>> +/* Populate IBBT BCH Header */
>> +static void bch_fill_ibbt_header(struct nandi_controller *nandi,
>> +				 struct nand_ibbt_bch_header *ibbt_header,
>> +				 int bak, uint8_t vers)
>> +{
>> +	const char author[] = "STLinux " UTS_RELEASE " (stm-nand-bch)";
>> +
>> +	memcpy(ibbt_header->base.signature, ibbt_sigs[bak], NAND_IBBT_SIGLEN);
>> +	ibbt_header->base.version = vers;
>> +	memset(ibbt_header->base.schema, NAND_IBBT_SCHEMA, 4);
>> +
>> +	memset(ibbt_header->schema, NAND_IBBT_SCHEMA, 4);
>> +	memset(ibbt_header->ecc_size, bch_ecc_sizes[nandi->bch_ecc_mode], 4);
>> +	memcpy(ibbt_header->author, author, sizeof(author));
>> +}
>> +
>> +/* Write IBBT to Flash */
>> +static int bch_write_bbt_data(struct nandi_controller *nandi,
>> +			      struct nandi_bbt_info *bbt_info,
>> +			      uint32_t block, int bak, uint8_t vers)
>> +{
>> +	struct nand_chip *chip = &nandi->info.chip;
>> +	uint32_t page_size = nandi->info.mtd.writesize;
>> +	uint32_t block_size = nandi->info.mtd.erasesize;
>> +	struct nand_ibbt_bch_header *ibbt_header =
>> +		(struct nand_ibbt_bch_header *)nandi->page_buf;
>> +	loff_t offs;
>> +
>> +	nandi->cached_page = -1;
>> +
>> +	/* Write BBT contents to first page of block */
>> +	offs = (loff_t)block << chip->phys_erase_shift;
>> +	if (bch_write_page(nandi, offs, bbt_info->bbt) & NAND_STATUS_FAIL)
>> +		return 1;
>> +
>> +	/* Update IBBT header and write to last page of block */
>> +	memset(ibbt_header, 0xff, nandi->info.mtd.writesize);
>> +	bch_fill_ibbt_header(nandi, ibbt_header, bak, vers);
>> +	offs += block_size - page_size;
>> +	if (bch_write_page(nandi, offs, (uint8_t *)ibbt_header) &
>> +	    NAND_STATUS_FAIL)
>> +		return 1;
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>> + * Update Flash-resident BBT:
>> + *   erase/search suitable block, and write table data to Flash
>> + */
>> +static int bch_update_bbt(struct nandi_controller *nandi,
>> +			 struct nandi_bbt_info *bbt_info,
>> +			 int bak, uint8_t vers)
>> +{
>> +	struct nand_chip *chip = &nandi->info.chip;
>> +	loff_t offs;
>> +	uint32_t block;
>> +	uint32_t block_lower;
>> +	uint32_t block_other;
>> +
>> +	block_other = bbt_info->bbt_block[(bak+1)%2];
>> +	block_lower = nandi->blocks_per_device - NAND_IBBT_NBLOCKS;
>> +
>> +	for (block = bbt_info->bbt_block[bak]; block >= block_lower;  block--) {
>> +		offs = (loff_t)block << chip->phys_erase_shift;
>> +
>> +		/* Skip if block used by other table */
>> +		if (block == block_other)
>> +			continue;
>> +
>> +		/* Skip if block is marked bad */
>> +		if (bbt_is_block_bad(bbt_info->bbt, block))
>> +			continue;
>> +
>> +		/* Erase block, mark bad and skip on failure */
>> +		if (bch_erase_block(nandi, offs) & NAND_STATUS_FAIL) {
>> +			dev_info(nandi->dev,
>> +				 "failed to erase block [%u:0x%012llx] while updating BBT\n",
>> +				 block, offs);
>> +			vers++;
>> +			bbt_set_block_mark(bbt_info->bbt, block,
>> +					   BBT_MARK_BAD_WEAR);
>> +			continue;
>> +		}
>> +
>> +		/* Write BBT, mark bad and skip on failure */
>> +		if (bch_write_bbt_data(nandi, bbt_info, block, bak, vers)) {
>> +			dev_info(nandi->dev,
>> +				 "failed to write BBT to block [%u:0x%012llx]\n",
>> +				 block, offs);
>> +			vers++;
>> +			bbt_set_block_mark(bbt_info->bbt, block,
>> +					   BBT_MARK_BAD_WEAR);
>> +			continue;
>> +		}
>> +
>> +		/* Success */
>> +		bbt_info->bbt_block[bak] = block;
>> +		bbt_info->bbt_vers[bak] = vers;
>> +		break;
>> +	}
>> +
>> +	/* No space in BBT area */
>> +	if (block < block_lower) {
>> +		dev_err(nandi->dev, "no space left in BBT area\n");
>> +		dev_err(nandi->dev, "failed to update %s BBT\n", bbt_strs[bak]);
>> +		return -ENOSPC;
>> +	}
>> +
>> +	dev_info(nandi->dev, "wrote BBT [%s:%u] at 0x%012llx [%u]\n",
>> +		 bbt_strs[bak], vers, offs, block);
>> +
>> +	return 0;
>> +}
>> +
>> +#define NAND_IBBT_UPDATE_PRIMARY	0x1
>> +#define NAND_IBBT_UPDATE_MIRROR		0x2
>> +#define NAND_IBBT_UPDATE_BOTH		(NAND_IBBT_UPDATE_PRIMARY | \
>> +					 NAND_IBBT_UPDATE_MIRROR)
>> +static char *bbt_update_strs[] = {
>> +	"",
>> +	"primary",
>> +	"mirror",
>> +	"both",
>> +};
>> +
>> +/*
>> + * Update Flash-resident BBT(s):
>> + *   incrementing 'vers' number if required, and ensuring Primary
>> + *   and Mirror are kept in sync
>> + */
>> +static int bch_update_bbts(struct nandi_controller *nandi,
>> +			   struct nandi_bbt_info *bbt_info,
>> +			   unsigned int update, uint8_t vers)
>> +{
>> +	int err;
>> +
>> +	dev_info(nandi->dev, "updating %s BBT(s)\n", bbt_update_strs[update]);
>> +
>> +	do {
>> +		/* Update Primary if specified */
>> +		if (update & NAND_IBBT_UPDATE_PRIMARY) {
>> +			err = bch_update_bbt(nandi, bbt_info, NAND_IBBT_PRIMARY,
>> +					     vers);
>> +			/* Bail out on error (e.g. no space left in BBT area) */
>> +			if (err)
>> +				return err;
>> +
>> +			/*
>> +			 * If update resulted in a new BBT version
>> +			 * (e.g. Erase/Write fail on BBT block) update version
>> +			 * here, and force update of other table.
>> +			 */
>> +			if (bbt_info->bbt_vers[NAND_IBBT_PRIMARY] != vers) {
>> +				vers = bbt_info->bbt_vers[NAND_IBBT_PRIMARY];
>> +				update = NAND_IBBT_UPDATE_MIRROR;
>> +			}
>> +		}
>> +
>> +		/* Update Mirror if specified */
>> +		if (update & NAND_IBBT_UPDATE_MIRROR) {
>> +			err = bch_update_bbt(nandi, bbt_info, NAND_IBBT_MIRROR,
>> +					     vers);
>> +			/* Bail out on error (e.g. no space left in BBT area) */
>> +			if (err)
>> +				return err;
>> +
>> +			/*
>> +			 * If update resulted in a new BBT version
>> +			 * (e.g. Erase/Write fail on BBT block) update version
>> +			 * here, and force update of other table.
>> +			 */
>> +			if (bbt_info->bbt_vers[NAND_IBBT_MIRROR] != vers) {
>> +				vers = bbt_info->bbt_vers[NAND_IBBT_MIRROR];
>> +				update = NAND_IBBT_UPDATE_PRIMARY;
>> +			}
>> +		}
>> +
>> +		/* Continue, until Primary and Mirror versions are in sync */
>> +	} while (bbt_info->bbt_vers[NAND_IBBT_PRIMARY] !=
>> +		 bbt_info->bbt_vers[NAND_IBBT_MIRROR]);
>> +
>> +	return 0;
>> +}
>> +
>> +/* Scan block for IBBT signature */
>> +static int bch_find_ibbt_sig(struct nandi_controller *nandi,
>> +			     uint32_t block, int *bak, uint8_t *vers,
>> +			     char *author)
>> +{
>> +	struct nand_chip *chip = &nandi->info.chip;
>> +	struct mtd_info *mtd = &nandi->info.mtd;
>> +	struct nand_ibbt_bch_header *ibbt_header;
>> +	loff_t offs;
>> +	uint8_t *buf = nandi->page_buf;
>> +	int match_sig;
>> +	unsigned int b;
>> +	unsigned int i;
>> +
>> +	nandi->cached_page = -1;
>> +
>> +	/* Load last page of block */
>> +	offs = (loff_t)block << chip->phys_erase_shift;
>> +	offs += mtd->erasesize - mtd->writesize;
>> +	if (bch_read_page(nandi, offs, buf) < 0) {

*Important*: You shouldn't call internal functions directly here..
Instead use chip->_read() OR mtd-read() that will:
- keep this code independent of ECC modes added in your driver in future.
- implicitly handle updating mtd->ecc_stat (like ecc_failed, bits_corrected).
- implicitly take care of address alignments checks and offset calculations.

<Same applies to other places where you have directly used bch_read_page())

>> +		dev_info(nandi->dev,
>> +			 "Uncorrectable ECC error while scanning BBT signature at block %u
>[0x%012llx]\n",
>> +			 block, offs);
>> +		return 0;
>> +	}
>> +	ibbt_header = (struct nand_ibbt_bch_header *)buf;
>> +
>> +	/* Test IBBT signature */
>> +	match_sig = 0;
>> +	for (b = 0; b < 2 && !match_sig; b++) {
>> +		match_sig = 1;
>> +		for (i = 0; i < NAND_IBBT_SIGLEN; i++) {
>> +			if (ibbt_header->base.signature[i] != ibbt_sigs[b][i]) {
>> +				match_sig = 0;
>> +				break;
>> +			}
>> +		}
>> +
>> +	}
>> +
>> +	if (!match_sig)
>> +		return 0; /* Failed to match IBBT signature */
>> +
>> +	/* Test IBBT schema */
>> +	for (i = 0; i < 4; i++)
>> +		if (ibbt_header->base.schema[i] != NAND_IBBT_SCHEMA)
>> +			return 0;
>> +
>> +	/* Test IBBT BCH schema */
>> +	for (i = 0; i < 4; i++)
>> +		if (ibbt_header->schema[i] != NAND_IBBT_BCH_SCHEMA)
>> +			return 0;
>> +
>> +	/* We have a match */
>> +	*vers = ibbt_header->base.version;
>> +	*bak = b - 1;
>> +	strncpy(author, ibbt_header->author, 64);
>> +
>> +	return 1;
>> +}
>> +
>> +/* Search for and load Flash-resident BBT, updating Primary/Mirror if req'd */
>> +static int bch_load_bbt(struct nandi_controller *nandi,
>> +			struct nandi_bbt_info *bbt_info)
>> +{
>> +	struct nand_chip *chip = &nandi->info.chip;
>> +	unsigned int update = 0;
>> +	uint32_t block;
>> +	loff_t offs;
>> +	uint8_t vers;
>> +	char author[64];
>> +	int bak;
>> +
>> +	dev_dbg(nandi->dev, "looking for Flash-resident BBTs\n");
>> +
>> +	bbt_info->bbt_block[0] = 0;
>> +	bbt_info->bbt_block[1] = 0;
>> +	bbt_info->bbt_vers[0] = 0;
>> +	bbt_info->bbt_vers[1] = 0;
>> +
>> +	/* Look for IBBT signatures */
>> +	for (block = nandi->blocks_per_device - NAND_IBBT_NBLOCKS;
>> +	     block < nandi->blocks_per_device;
>> +	     block++) {
>> +		offs = (loff_t)block << chip->phys_erase_shift;
>> +
>> +		if (bch_find_ibbt_sig(nandi, block, &bak, &vers, author)) {
>> +			dev_dbg(nandi->dev,
>> +				"found BBT [%s:%u] at 0x%012llx [%u] (%s)\n",
>> +				bbt_strs[bak], vers, offs, block,
>> +				author);
>> +
>> +			if (bbt_info->bbt_block[bak] == 0 ||
>> +			    ((int8_t)(bbt_info->bbt_vers[bak] - vers)) < 0) {
>> +				bbt_info->bbt_block[bak] = block;
>> +				bbt_info->bbt_vers[bak] = vers;
>> +			}
>> +		}
>> +	}
>> +
>> +	/* What have we found? */
>> +	if (bbt_info->bbt_block[0] == 0 && bbt_info->bbt_block[1] == 0) {
>> +		/* no primary, no mirror: return error */
>> +		return 1;
>> +	} else if (bbt_info->bbt_block[0] == 0) {
>> +		/* no primary: use mirror, update primary */
>> +		bak = 1;
>> +		update = NAND_IBBT_UPDATE_PRIMARY;
>> +		bbt_info->bbt_block[0] = nandi->blocks_per_device - 1;
>> +	} else if (bbt_info->bbt_block[1] == 0) {
>> +		/* no mirror: use primary, update mirror */
>> +		bak = 0;
>> +		update = NAND_IBBT_UPDATE_MIRROR;
>> +		bbt_info->bbt_block[1] = nandi->blocks_per_device - 1;
>> +	} else if (bbt_info->bbt_vers[0] == bbt_info->bbt_vers[1]) {
>> +		/* primary == mirror: use primary, no update required */
>> +		bak = 0;
>> +	} else if ((int8_t)(bbt_info->bbt_vers[1] -
>> +			    bbt_info->bbt_vers[0]) < 0) {
>> +		/* primary > mirror: use primary, update mirror */
>> +		bak = 0;
>> +		update = NAND_IBBT_UPDATE_MIRROR;
>> +	} else {
>> +		/* mirror > primary: use mirror, update primary */
>> +		bak = 1;
>> +		update = NAND_IBBT_UPDATE_PRIMARY;
>> +	}
>> +
>> +	vers = bbt_info->bbt_vers[bak];
>> +	block = bbt_info->bbt_block[bak];
>> +	offs = block << chip->phys_erase_shift;
>
>You need to cast 'block' to loff_t to prevent 32-bit overflow.
>
>> +	dev_info(nandi->dev, "using BBT [%s:%u] at 0x%012llx [%u]\n",
>> +		 bbt_strs[bak], vers, offs, block);
>> +
>> +	/* Read BBT data */
>> +	if (bch_read_page(nandi, offs, bbt_info->bbt) < 0) {

Please use mtd_read() and you can make yourself free of offset calculations
and address alignments.


>> +		dev_err(nandi->dev,
>> +			"error while reading BBT %s:%u] at 0x%012llx [%u]\n",
>> +			bbt_strs[bak], vers, offs, block);
>> +		return 1;
>> +	}
>> +
>> +	/* Update other BBT if required */
>> +	if (update)
>> +		bch_update_bbts(nandi, bbt_info, update, vers);
>> +
>> +	return 0;
>> +}
>> +
>> +static int bch_scan_bbt(struct mtd_info *mtd)
>> +{
>> +	struct nand_chip *chip = mtd->priv;
>> +	struct nandi_controller *nandi = chip->priv;
>> +	struct nandi_bbt_info *bbt_info = &nandi->info.bbt_info;
>> +	int err;
>> +	/* Load Flash-resident BBT */
>> +	err = bch_load_bbt(nandi, bbt_info);
>> +	if (err) {
>> +		dev_warn(nandi->dev,
>> +			"failed to find BBTs:"
>> +			"  scanning device for bad-block markers\n");
>> +
>> +		/* Scan, build, and write BBT */
>> +		nandi_scan_build_bbt(nandi, bbt_info);
>> +		err = bch_update_bbts(nandi, bbt_info, NAND_IBBT_UPDATE_BOTH,
>> +				      bbt_info->bbt_vers[0] + 1);
>> +		if (err)
>> +			return err;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int bch_mtd_read_oob(struct mtd_info *mtd,
>> +			    struct nand_chip *chip, int page)
>> +{
>> +	BUG();
>> +	return 0;
>> +}
>> +
>> +static int bch_mtd_write_oob(struct mtd_info *mtd,
>> +			     struct nand_chip *chip, int page)
>> +{
>> +	BUG();
>> +	return 0;
>> +}
>> +
>> +static int bch_read_page_raw(struct mtd_info *mtd, struct nand_chip *chip,
>> +			     uint8_t *buf, int oob_required, int page)
>> +{
>> +	BUG();
>> +	return 0;
>> +}
>> +
>> +static int bch_write_page_raw(struct mtd_info *mtd, struct nand_chip *chip,
>> +			      const uint8_t *buf, int oob_required)
>> +{
>> +	BUG();
>> +	return 0;
>> +}
>> +
>> +static void bch_hwctl(struct mtd_info *mtd, int mode)
>> +{
>> +	BUG();
>> +}
>> +
>> +static int bch_calculate(struct mtd_info *mtd, const uint8_t *dat,
>> +			 uint8_t *ecc_code)
>> +{
>> +	BUG();
>> +	return 0;
>> +}
>> +
>> +static int bch_correct(struct mtd_info *mtd, uint8_t *dat, uint8_t *read_ecc,
>> +		       uint8_t *calc_ecc)
>> +{
>> +	BUG();
>> +	return 0;
>> +}
>> +
>> +static int bch_block_isbad(struct mtd_info *mtd, loff_t offs, int getchip)
>> +{
>> +	struct nand_chip *chip = mtd->priv;
>> +	struct nandi_controller *nandi = chip->priv;
>> +
>> +	uint32_t block;
>> +
>> +	/* Check for invalid offset */
>> +	if (offs > mtd->size)
>> +		return -EINVAL;
>> +
>> +	block = offs >> chip->phys_erase_shift;
>> +
>> +	/* Protect blocks reserved for BBTs */
>> +	if (block >= (nandi->blocks_per_device - NAND_IBBT_NBLOCKS))
>> +		return 1;
>> +
>> +	return bbt_is_block_bad(nandi->info.bbt_info.bbt, block);
>> +}
>> +
>> +static int bch_block_markbad(struct mtd_info *mtd, loff_t offs)
>> +{
>> +	struct nand_chip *chip = mtd->priv;
>> +	struct nandi_controller *nandi = chip->priv;
>> +
>> +	uint32_t block;
>> +	int ret;
>> +
>> +	/* Is block already considered bad? (will also catch invalid offsets) */
>> +	ret = mtd_block_isbad(mtd, offs);
>
>You're violating some of the layering here; the low-level driver
>probably shouldn't be calling the high-level mtd_*() APIs. On a similar
>note, I'm not 100% confident that the nand_base/nand_bbt separation is
>written cleanly enough for easy maintenance of your nand_base + ST BBT
>code in parallel. I might need a second look at that, and I think
>modularizing your BBT code to a separate file could help ease this a
>little.
>
>> +	if (ret < 0)
>> +		return ret;
>> +	if (ret == 1)
>> +		return 0;
>> +
>> +	/* Mark bad */
>> +	block = offs >> chip->phys_erase_shift;
>> +	bbt_set_block_mark(nandi->info.bbt_info.bbt, block, BBT_MARK_BAD_WEAR);
>> +
>> +	/* Update BBTs, incrementing bbt_vers */
>> +	ret = bch_update_bbts(nandi, &nandi->info.bbt_info,
>> +			      NAND_IBBT_UPDATE_BOTH,
>> +			      nandi->info.bbt_info.bbt_vers[0] + 1);
>> +
>> +	return ret;
>> +}
>> +
>> +static void nandi_dump_bad_blocks(struct nandi_controller *nandi)
>> +{
>> +	struct nand_chip *chip = &nandi->info.chip;
>> +	int bad_count = 0;
>> +	uint32_t block;
>> +	uint8_t *bbt = nandi->info.bbt_info.bbt;
>> +	uint8_t mark;
>> +
>> +	pr_info("BBT:\n");
>> +	for (block = 0; block < nandi->blocks_per_device; block++) {
>> +		mark = bbt_get_block_mark(bbt, block);
>> +		if (mark != BBT_MARK_GOOD) {
>> +			pr_info("\t\tBlock 0x%08x [%05u] marked bad [%s]\n",
>> +				block << chip->phys_erase_shift, block,
>> +				(mark == BBT_MARK_BAD_FACTORY) ?
>> +				"Factory" : "Wear");
>> +			bad_count++;
>> +		}
>> +	}
>> +	if (bad_count == 0)
>> +		pr_info("\t\tNo bad blocks listed in BBT\n");
>> +}
>> +
>> +/*
>> + * Initialisation
>> + */
>> +static int bch_check_compatibility(struct nandi_controller *nandi,
>> +				   struct mtd_info *mtd,
>> +				   struct nand_chip *chip)
>> +{
>> +	if (chip->bits_per_cell > 1)
>> +		dev_warn(nandi->dev, "MLC NAND not fully supported\n");
>> +
>> +	if (chip->options & NAND_BUSWIDTH_16) {
>> +		dev_err(nandi->dev, "x16 NAND not supported\n");
>> +		return false;
>> +	}
>> +
>> +	if (nandi->blocks_per_device / 4 > mtd->writesize) {
>> +		/* Need to implement multi-page BBT support... */
>> +		dev_err(nandi->dev, "BBT too big to fit in single page\n");
>> +		return false;
>> +	}
>> +
>> +	if (bch_ecc_sizes[nandi->bch_ecc_mode] * nandi->sectors_per_page >
>> +	    mtd->oobsize) {
>> +		dev_err(nandi->dev, "insufficient OOB for selected ECC\n");
>> +		return false;
>> +	}
>> +
>> +	return true;
>> +}
>> +
>> +/* Select strongest ECC scheme compatible with OOB size */
>> +static int bch_set_ecc_auto(struct nandi_controller *nandi,
>> +			    struct mtd_info *mtd)
>> +{
>> +	int oob_bytes_per_sector = mtd->oobsize / nandi->sectors_per_page;
>> +	int try_ecc_modes[] = { BCH_30BIT_ECC, BCH_18BIT_ECC, -1 };
>> +	int m, ecc_mode;
>> +
>> +	for (m = 0; try_ecc_modes[m] >= 0; m++) {
>> +		ecc_mode = try_ecc_modes[m];
>> +		if (oob_bytes_per_sector >= bch_ecc_sizes[ecc_mode]) {
>> +			nandi->bch_ecc_mode = ecc_mode;
>> +			return 0;
>> +		}
>> +	}
>> +
>> +	return -EINVAL;
>> +}
>> +
>> +static void nandi_set_mtd_defaults(struct nandi_controller *nandi,
>> +				   struct mtd_info *mtd, struct nand_chip *chip)
>> +{
>> +	struct nandi_info *info = &nandi->info;
>> +	int i;
>> +
>> +	/* ecclayout */
>> +	info->ecclayout.eccbytes = mtd->oobsize;
>> +	for (i = 0; i < 64; i++)
>> +		info->ecclayout.eccpos[i] = i;
>> +	info->ecclayout.oobfree[0].offset = 0;
>> +	info->ecclayout.oobfree[0].length = 0;
>> +	chip->ecc.mode = NAND_ECC_HW;
>> +
>> +	/* nand_chip */
>> +	chip->controller = &chip->hwcontrol;
>> +	spin_lock_init(&chip->controller->lock);
>> +	init_waitqueue_head(&chip->controller->wq);
>> +	chip->state = FL_READY;
>> +	chip->priv = nandi;
>> +	chip->ecc.layout = &info->ecclayout;
>> +	chip->options |= NAND_NO_SUBPAGE_WRITE;
>> +
>> +	chip->cmdfunc = flex_command_lp;
>> +	chip->read_byte = flex_read_byte;
>> +	chip->select_chip = flex_select_chip;
>> +	chip->waitfunc = flex_wait_func;
>> +	chip->read_buf = flex_read_buf;
>> +	chip->write_buf = flex_write_buf;
>> +
>> +	chip->bbt_options |= NAND_BBT_USE_FLASH;
>> +
>> +	/* mtd_info */
>> +	mtd->owner = THIS_MODULE;
>> +	mtd->type = MTD_NANDFLASH;
>> +	mtd->flags = MTD_CAP_NANDFLASH;
>> +	mtd->ecclayout = &info->ecclayout;
>> +	mtd->subpage_sft = 0;
>
>Is this necessary? You've already set NAND_NO_SUBPAGE_WRITE, and
>kzalloc() will initialize the field.
>
>> +
>> +	chip->ecc.hwctl = bch_hwctl;
>> +	chip->ecc.calculate = bch_calculate;
>> +	chip->ecc.correct = bch_correct;
>> +
>> +	chip->ecc.read_oob = bch_mtd_read_oob;
>> +	chip->ecc.write_oob = bch_mtd_write_oob;
>> +
>> +	chip->ecc.read_page = bch_read;
>> +	chip->ecc.read_page_raw = bch_read_page_raw;
>> +	chip->ecc.write_page_raw = bch_write_page_raw;
>> +	chip->write_page = bch_write;
>> +	chip->erase = bch_erase;
>> +
>> +	chip->scan_bbt = bch_scan_bbt;
>> +	chip->block_bad = bch_block_isbad;
>> +	chip->block_markbad = bch_block_markbad;
>
>If you make the ST BBT format optional, then these three bad block
>function pointer assignments should be conditional.
>
>> +}
>> +
>> +/*
>> + * Timing and Clocks
>> + */
>> +
>> +static void nandi_clk_enable(struct nandi_controller *nandi)
>> +{
>> +	if (nandi->emi_clk)
>
>I believe the NULL check is unnecessary.
>
>> +		clk_prepare_enable(nandi->emi_clk);
>> +	if (nandi->bch_clk)
>
>Ditto.
>
>> +		clk_prepare_enable(nandi->bch_clk);
>> +}
>> +
>> +static void nandi_clk_disable(struct nandi_controller *nandi)
>> +{
>> +	if (nandi->emi_clk)
>
>Ditto.
>
>> +		clk_disable_unprepare(nandi->emi_clk);
>> +	if (nandi->bch_clk)
>
>Ditto.
>
>> +		clk_disable_unprepare(nandi->bch_clk);
>> +}
>> +
>> +static struct clk *nandi_clk_setup(struct nandi_controller *nandi,
>> +				   char *clkname)
>> +{
>> +	struct clk *clk;
>> +	int ret;
>> +
>> +	clk = clk_get(nandi->dev, clkname);
>
>Try devm_clk_get()? Then you can drop the clock_put()'s in your
>remove().
>
>> +	if (IS_ERR_OR_NULL(clk)) {
>> +		dev_warn(nandi->dev, "Failed to get %s clock\n", clkname);
>> +		return NULL;
>> +	}
>> +
>> +	ret = clk_prepare_enable(clk);
>> +	if (ret) {
>> +		dev_warn(nandi->dev, "Failed to enable %s clock\n", clkname);
>> +		clk_put(clk);
>> +		return NULL;
>> +	}
>> +
>> +	return clk;
>> +}
>> +
>> +/* Derive Hamming-FLEX timing register values from 'nand_sdr_timings' data */
>> +static void flex_calc_timing_registers(const struct nand_sdr_timings *spec,
>> +				       int tCLK, int relax,
>> +				       uint32_t *ctl_timing,
>> +				       uint32_t *wen_timing,
>> +				       uint32_t *ren_timing)
>> +{
>> +	int tMAX_HOLD;
>> +	int n_ctl_setup;
>> +	int n_ctl_hold;
>> +	int n_ctl_wb;
>> +
>> +	int tMAX_WEN_OFF;
>> +	int n_wen_on;
>> +	int n_wen_off;
>> +
>> +	int tMAX_REN_OFF;
>> +	int n_ren_on;
>> +	int n_ren_off;
>> +
>> +	/*
>> +	 * CTL_TIMING
>> +	 */
>> +
>> +	/*	- SETUP */
>> +	n_ctl_setup = (spec->tCLS_min - spec->tWP_min + tCLK - 1)/tCLK;
>> +	if (n_ctl_setup < 1)
>> +		n_ctl_setup = 1;
>> +	n_ctl_setup += relax;
>> +
>> +	/*	- HOLD */
>> +	tMAX_HOLD = spec->tCLH_min;
>> +	if (spec->tCH_min > tMAX_HOLD)
>> +		tMAX_HOLD = spec->tCH_min;
>> +	if (spec->tALH_min > tMAX_HOLD)
>> +		tMAX_HOLD = spec->tALH_min;
>> +	if (spec->tDH_min > tMAX_HOLD)
>> +		tMAX_HOLD = spec->tDH_min;
>> +	n_ctl_hold = (tMAX_HOLD + tCLK - 1)/tCLK + relax;
>> +
>> +	/*	- CE_deassert_hold = 0 */
>> +
>> +	/*	- WE_high_to_RBn_low */
>> +	n_ctl_wb = (spec->tWB_max + tCLK - 1)/tCLK;
>> +
>> +	*ctl_timing = ((n_ctl_setup & 0xff) |
>> +		       (n_ctl_hold & 0xff) << 8 |
>> +		       (n_ctl_wb & 0xff) << 24);
>> +
>> +	/*
>> +	 * WEN_TIMING
>> +	 */
>> +
>> +	/*	- ON */
>> +	n_wen_on = (spec->tWH_min + tCLK - 1)/tCLK + relax;
>> +
>> +	/*	- OFF */
>> +	tMAX_WEN_OFF = spec->tWC_min - spec->tWH_min;
>> +	if (spec->tWP_min > tMAX_WEN_OFF)
>> +		tMAX_WEN_OFF = spec->tWP_min;
>> +	n_wen_off = (tMAX_WEN_OFF + tCLK - 1)/tCLK + relax;
>> +
>> +	*wen_timing = ((n_wen_on & 0xff) |
>> +		       (n_wen_off & 0xff) << 8);
>> +
>> +	/*
>> +	 * REN_TIMING
>> +	 */
>> +
>> +	/*	- ON */
>> +	n_ren_on = (spec->tREH_min + tCLK - 1)/tCLK + relax;
>> +
>> +	/*	- OFF */
>> +	tMAX_REN_OFF = spec->tRC_min - spec->tREH_min;
>> +	if (spec->tRP_min > tMAX_REN_OFF)
>> +		tMAX_REN_OFF = spec->tRP_min;
>> +	if (spec->tREA_max > tMAX_REN_OFF)
>> +		tMAX_REN_OFF = spec->tREA_max;
>> +	n_ren_off = (tMAX_REN_OFF + tCLK - 1)/tCLK + 1 + relax;
>> +
>> +	*ren_timing = ((n_ren_on & 0xff) |
>> +		       (n_ren_off & 0xff) << 8);
>> +}
>> +
>> +/* Derive BCH timing register values from 'nand_sdr_timings' data */
>> +static void bch_calc_timing_registers(const struct nand_sdr_timings *spec,
>> +				      int tCLK, int relax,
>> +				      uint32_t *ctl_timing,
>> +				      uint32_t *wen_timing,
>> +				      uint32_t *ren_timing)
>> +{
>> +	int tMAX_HOLD;
>> +	int n_ctl_setup;
>> +	int n_ctl_hold;
>> +	int n_ctl_wb;
>> +
>> +	int n_wen_on;
>> +	int n_wen_off;
>> +	int wen_half_on;
>> +	int wen_half_off;
>> +
>> +	int tMAX_REN_ON;
>> +	int tMAX_CS_DEASSERT;
>> +	int n_d_latch;
>> +	int n_telqv;
>> +	int n_ren_on;
>> +	int n_ren_off;
>> +	int ren_half_on;
>> +	int ren_half_off;
>> +
>> +	/*
>> +	 * CTL_TIMING
>> +	 */
>> +
>> +	/*	- SETUP */
>> +	if (spec->tCLS_min > spec->tWP_min)
>> +		n_ctl_setup = (spec->tCLS_min - spec->tWP_min + tCLK - 1)/tCLK;
>> +	else
>> +		n_ctl_setup = 0;
>> +	n_ctl_setup += relax;
>> +
>> +	/*	- HOLD */
>> +	tMAX_HOLD = spec->tCLH_min;
>> +	if (spec->tCH_min > tMAX_HOLD)
>> +		tMAX_HOLD = spec->tCH_min;
>> +	if (spec->tALH_min > tMAX_HOLD)
>> +		tMAX_HOLD = spec->tALH_min;
>> +	if (spec->tDH_min > tMAX_HOLD)
>> +		tMAX_HOLD = spec->tDH_min;
>> +	n_ctl_hold = (tMAX_HOLD + tCLK - 1)/tCLK + relax;
>> +	/*	- CE_deassert_hold = 0 */
>> +
>> +	/*	- WE_high_to_RBn_low */
>> +	n_ctl_wb = (spec->tWB_max + tCLK - 1)/tCLK;
>> +
>> +	*ctl_timing = ((n_ctl_setup & 0xff) |
>> +		       (n_ctl_hold & 0xff) << 8 |
>> +		       (n_ctl_wb & 0xff) << 24);
>> +
>> +	/*
>> +	 * WEN_TIMING
>> +	 */
>> +
>> +	/*	- ON */
>> +	n_wen_on = (2 * spec->tWH_min + tCLK - 1)/tCLK;
>> +	wen_half_on = n_wen_on % 2;
>> +	n_wen_on /= 2;
>> +	n_wen_on += relax;
>> +
>> +	/*	- OFF */
>> +	n_wen_off = (2 * spec->tWP_min + tCLK - 1)/tCLK;
>> +	wen_half_off = n_wen_off % 2;
>> +	n_wen_off /= 2;
>> +	n_wen_off += relax;
>> +
>> +	*wen_timing = ((n_wen_on & 0xff) |
>> +		       (n_wen_off & 0xff) << 8 |
>> +		       (wen_half_on << 16) |
>> +		       (wen_half_off << 17));
>> +
>> +	/*
>> +	 * REN_TIMING
>> +	 */
>> +
>> +	/*	- ON */
>> +	tMAX_REN_ON = spec->tRC_min - spec->tRP_min;
>> +	if (spec->tREH_min > tMAX_REN_ON)
>> +		tMAX_REN_ON = spec->tREH_min;
>> +
>> +	n_ren_on = (2 * tMAX_REN_ON + tCLK - 1)/tCLK;
>> +	ren_half_on = n_ren_on % 2;
>> +	n_ren_on /= 2;
>> +	n_ren_on += relax;
>> +
>> +	/*	- OFF */
>> +	n_ren_off = (2 * spec->tREA_max + tCLK - 1)/tCLK;
>> +	ren_half_off = n_ren_off % 2;
>> +	n_ren_off /= 2;
>> +	n_ren_off += relax;
>> +
>> +	/*	- DATA_LATCH */
>> +	if (spec->tREA_max <= (spec->tRP_min - (2 * tCLK)))
>> +		n_d_latch = 0;
>> +	else if (spec->tREA_max <= (spec->tRP_min - tCLK))
>> +		n_d_latch = 1;
>> +	else if ((spec->tREA_max <= spec->tRP_min) && (spec->tRHOH_min >= 2 * tCLK))
>> +		n_d_latch = 2;
>> +	else
>> +		n_d_latch = 3;
>> +
>> +	/*	- TELQV */
>> +	tMAX_CS_DEASSERT = spec->tCOH_min;
>> +	if (spec->tCHZ_max > tMAX_CS_DEASSERT)
>> +		tMAX_CS_DEASSERT = spec->tCHZ_max;
>> +
>> +	n_telqv = (tMAX_CS_DEASSERT + tCLK - 1)/tCLK;
>> +
>> +	*ren_timing = ((n_ren_on & 0xff) |
>> +		       (n_ren_off & 0xff) << 8 |
>> +		       (n_d_latch & 0x3) << 16 |
>> +		       (wen_half_on << 18) |
>> +		       (wen_half_off << 19) |
>> +		       (n_telqv & 0xff) << 24);
>> +}
>> +
>> +static void flex_configure_timing_registers(struct nandi_controller *nandi,
>> +					    const struct nand_sdr_timings *spec,
>> +					    int relax)
>> +{
>> +	uint32_t ctl_timing;
>> +	uint32_t wen_timing;
>> +	uint32_t ren_timing;
>> +	int emi_t_ns;
>> +
>> +	/* Select Hamming Controller */
>> +	emiss_nandi_select(STM_NANDI_HAMMING);
>> +
>> +	/* Get EMI clock (default 100MHz) */
>> +	if (nandi->emi_clk)
>> +		emi_t_ns = 1000000000UL / clk_get_rate(nandi->emi_clk);
>> +	else {
>> +		dev_warn(nandi->dev,
>> +			 "No EMI clock available; assuming default 100MHz\n");
>> +		emi_t_ns = 10;
>> +	}
>> +
>> +	/* Derive timing register values from specification */
>> +	flex_calc_timing_registers(spec, emi_t_ns, relax,
>> +				   &ctl_timing, &wen_timing, &ren_timing);
>> +
>> +	dev_dbg(nandi->dev,
>> +		"updating FLEX timing configuration [0x%08x, 0x%08x, 0x%08x]\n",
>> +		ctl_timing, wen_timing, ren_timing);
>> +
>> +	/* Program timing registers */
>> +	writel(ctl_timing, nandi->base + NANDHAM_CTL_TIMING);
>> +	writel(wen_timing, nandi->base + NANDHAM_WEN_TIMING);
>> +	writel(ren_timing, nandi->base + NANDHAM_REN_TIMING);
>> +}
>> +
>> +static void bch_configure_timing_registers(struct nandi_controller *nandi,
>> +					   const struct nand_sdr_timings *spec,
>> +					   int relax)
>> +{
>> +	uint32_t ctl_timing;
>> +	uint32_t wen_timing;
>> +	uint32_t ren_timing;
>> +	int bch_t_ns;
>> +
>> +	/* Select BCH Controller */
>> +	emiss_nandi_select(STM_NANDI_BCH);
>> +
>> +	/* Get BCH clock (default 200MHz) */
>> +	if (nandi->bch_clk)
>> +		bch_t_ns = 1000000000UL / clk_get_rate(nandi->bch_clk);
>> +	else {
>> +		dev_warn(nandi->dev,
>> +			 "No BCH clock available; assuming default 200MHz\n");
>> +		bch_t_ns = 5;
>> +	}
>> +
>> +	/* Derive timing register values from specification */
>> +	bch_calc_timing_registers(spec, bch_t_ns, relax,
>> +				  &ctl_timing, &wen_timing, &ren_timing);
>> +
>> +	dev_dbg(nandi->dev,
>> +		"updating BCH timing configuration [0x%08x, 0x%08x, 0x%08x]\n",
>> +		ctl_timing, wen_timing, ren_timing);
>> +
>> +	/* Program timing registers */
>> +	writel(ctl_timing, nandi->base + NANDBCH_CTL_TIMING);
>> +	writel(wen_timing, nandi->base + NANDBCH_WEN_TIMING);
>> +	writel(ren_timing, nandi->base + NANDBCH_REN_TIMING);
>> +}
>> +
>> +static void nandi_configure_timing_registers(struct nandi_controller *nandi,
>> +					const struct nand_sdr_timings *spec,
>> +					int relax)
>> +{
>> +	bch_configure_timing_registers(nandi, spec, relax);
>> +	flex_configure_timing_registers(nandi, spec, relax);
>> +}
>> +
>> +static void nandi_init_hamming(struct nandi_controller *nandi, int emi_bank)
>> +{
>> +	dev_dbg(nandi->dev, "%s\n", __func__);
>> +
>> +	emiss_nandi_select(STM_NANDI_HAMMING);
>> +
>> +	/* Reset and disable boot-mode controller */
>> +	writel(BOOT_CFG_RESET, nandi->base + NANDHAM_BOOTBANK_CFG);
>> +	udelay(1);
>> +	writel(0x00000000, nandi->base + NANDHAM_BOOTBANK_CFG);
>> +
>> +	/* Reset controller */
>> +	writel(CFG_RESET, nandi->base + NANDHAM_FLEXMODE_CFG);
>> +	udelay(1);
>> +	writel(0x00000000, nandi->base + NANDHAM_FLEXMODE_CFG);
>> +
>> +	/* Set EMI Bank */
>> +	writel(0x1 << emi_bank, nandi->base + NANDHAM_FLEX_MUXCTRL);
>> +
>> +	/* Enable FLEX mode */
>> +	writel(CFG_ENABLE_FLEX, nandi->base + NANDHAM_FLEXMODE_CFG);
>> +
>> +	/* Configure FLEX_DATA_READ/WRITE for 1-byte access */
>> +	writel(FLEX_DATA_CFG_BEATS_1 | FLEX_DATA_CFG_CSN,
>> +	       nandi->base + NANDHAM_FLEX_DATAREAD_CONFIG);
>> +	writel(FLEX_DATA_CFG_BEATS_1 | FLEX_DATA_CFG_CSN,
>> +	       nandi->base + NANDHAM_FLEX_DATAREAD_CONFIG);
>> +
>> +	/* RBn interrupt on rising edge */
>> +	writel(NAND_EDGE_CFG_RBN_RISING, nandi->base + NANDHAM_INT_EDGE_CFG);
>> +
>> +	/* Enable interrupts */
>> +	nandi_enable_interrupts(nandi, NAND_INT_ENABLE);
>> +}
>> +
>> +static void nandi_init_bch(struct nandi_controller *nandi, int emi_bank)
>> +{
>> +	dev_dbg(nandi->dev, "%s\n", __func__);
>> +
>> +	/* Initialise BCH Controller */
>> +	emiss_nandi_select(STM_NANDI_BCH);
>> +
>> +	/* Reset and disable boot-mode controller */
>> +	writel(BOOT_CFG_RESET, nandi->base + NANDBCH_BOOTBANK_CFG);
>> +	udelay(1);
>> +	writel(0x00000000, nandi->base + NANDBCH_BOOTBANK_CFG);
>> +
>> +	/* Reset AFM controller */
>> +	writel(CFG_RESET, nandi->base + NANDBCH_CONTROLLER_CFG);
>> +	udelay(1);
>> +	writel(0x00000000, nandi->base + NANDBCH_CONTROLLER_CFG);
>> +
>> +	/* Set EMI Bank */
>> +	writel(0x1 << emi_bank, nandi->base + NANDBCH_FLEX_MUXCTRL);
>> +
>> +	/* Reset ECC stats */
>> +	writel(CFG_RESET_ECC_ALL, nandi->base + NANDBCH_CONTROLLER_CFG);
>> +	udelay(1);
>> +
>> +	/* Enable AFM */
>> +	writel(CFG_ENABLE_AFM, nandi->base + NANDBCH_CONTROLLER_CFG);
>> +
>> +	/* Configure Read DMA Plugs (values supplied by Validation) */
>> +	writel(0x00000005, nandi->dma + EMISS_NAND_RD_DMA_PAGE_SIZE);
>> +	writel(0x00000005, nandi->dma + EMISS_NAND_RD_DMA_MAX_OPCODE_SIZE);
>> +	writel(0x00000002, nandi->dma + EMISS_NAND_RD_DMA_MIN_OPCODE_SIZE);
>> +	writel(0x00000001, nandi->dma + EMISS_NAND_RD_DMA_MAX_CHUNK_SIZE);
>> +	writel(0x00000000, nandi->dma + EMISS_NAND_RD_DMA_MAX_MESSAGE_SIZE);
>> +
>> +	/* Configure Write DMA Plugs (values supplied by Validation) */
>> +	writel(0x00000005, nandi->dma + EMISS_NAND_WR_DMA_PAGE_SIZE);
>> +	writel(0x00000005, nandi->dma + EMISS_NAND_WR_DMA_MAX_OPCODE_SIZE);
>> +	writel(0x00000002, nandi->dma + EMISS_NAND_WR_DMA_MIN_OPCODE_SIZE);
>> +	writel(0x00000001, nandi->dma + EMISS_NAND_WR_DMA_MAX_CHUNK_SIZE);
>> +	writel(0x00000000, nandi->dma + EMISS_NAND_WR_DMA_MAX_MESSAGE_SIZE);
>> +
>> +	nandi_enable_interrupts(nandi, NAND_INT_ENABLE);
>> +}
>> +
>> +static void nandi_init_controller(struct nandi_controller *nandi,
>> +				  int emi_bank)
>> +{
>> +	nandi_init_bch(nandi, emi_bank);
>> +	nandi_init_hamming(nandi, emi_bank);
>> +}
>> +
>> +/* Initialise working buffers, accomodating DMA alignment constraints */
>> +static int nandi_init_working_buffers(struct nandi_controller *nandi,
>> +				      struct nandi_bbt_info *bbt_info,
>> +				      struct mtd_info *mtd)
>> +{
>> +	uint32_t bbt_buf_size;
>> +	uint32_t buf_size;
>> +
>> +	/*	- Page and OOB */
>> +	buf_size = mtd->writesize + mtd->oobsize + NANDI_BCH_DMA_ALIGNMENT;
>> +
>> +	/*	- BBT data (page-size aligned) */
>> +	bbt_info->bbt_size = nandi->blocks_per_device >> 2; /* 2 bits/block */
>> +	bbt_buf_size = ALIGN(bbt_info->bbt_size, mtd->writesize);
>> +	buf_size += bbt_buf_size + NANDI_BCH_DMA_ALIGNMENT;
>> +
>> +	/*	- BCH BUF list */
>> +	buf_size += NANDI_BCH_BUF_LIST_SIZE + NANDI_BCH_DMA_ALIGNMENT;
>> +
>> +	/* Allocate bufffer */
>> +	nandi->buf = devm_kzalloc(nandi->dev, buf_size, GFP_KERNEL);
>> +	if (!nandi->buf) {
>> +		dev_err(nandi->dev, "failed to allocate working buffers\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	/* Set/Align buffer pointers */
>> +	nandi->page_buf = PTR_ALIGN(nandi->buf, NANDI_BCH_DMA_ALIGNMENT);
>> +	nandi->oob_buf  = nandi->page_buf + mtd->writesize;
>> +	bbt_info->bbt   = PTR_ALIGN(nandi->oob_buf + mtd->oobsize,
>> +				    NANDI_BCH_DMA_ALIGNMENT);
>> +	nandi->buf_list = (uint32_t *)PTR_ALIGN(bbt_info->bbt + bbt_buf_size,
>> +						NANDI_BCH_DMA_ALIGNMENT);
>> +	nandi->cached_page = -1;
>> +
>> +	return 0;
>> +}
>> +
>> +static int remap_named_resource(struct platform_device *pdev,
>> +				char *name,
>> +				void __iomem **io_ptr)
>> +{
>> +	struct resource *res, *mem;
>> +	resource_size_t size;
>> +	void __iomem *p;
>> +
>> +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, name);
>> +	if (!res)
>> +		return -ENXIO;
>> +
>> +	size = resource_size(res);
>> +
>> +	mem = devm_request_mem_region(&pdev->dev, res->start, size, name);
>> +	if (!mem)
>> +		return -EBUSY;
>> +
>> +	p = devm_ioremap_nocache(&pdev->dev, res->start, size);
>> +	if (!p)
>> +		return -ENOMEM;
>> +
>> +	*io_ptr = p;
>> +
>> +	return 0;
>> +}
>> +
>> +static struct nandi_controller *
>> +nandi_init_resources(struct platform_device *pdev)
>> +{
>> +	struct nandi_controller *nandi;
>> +	int irq;
>> +	int err;
>> +
>> +	nandi = devm_kzalloc(&pdev->dev, sizeof(*nandi), GFP_KERNEL);
>> +	if (!nandi) {
>> +		dev_err(&pdev->dev,
>> +			"failed to allocate NANDi controller data\n");
>> +		return ERR_PTR(-ENOMEM);
>> +	}
>> +
>> +	nandi->dev = &pdev->dev;
>> +
>> +	err = remap_named_resource(pdev, "nand_mem", &nandi->base);
>> +	if (err)
>> +		return ERR_PTR(err);
>> +
>> +	err = remap_named_resource(pdev, "nand_dma", &nandi->dma);
>> +	if (err)
>> +		return ERR_PTR(err);
>> +
>> +	irq = platform_get_irq_byname(pdev, "nand_irq");
>> +	if (irq < 0) {
>> +		dev_err(&pdev->dev, "failed to find IRQ resource\n");
>> +		return ERR_PTR(irq);
>> +	}
>> +
>> +	err = devm_request_irq(&pdev->dev, irq, nandi_irq_handler,
>> +			       IRQF_DISABLED, dev_name(&pdev->dev), nandi);
>> +	if (err) {
>> +		dev_err(&pdev->dev, "irq request failed\n");
>> +		return ERR_PTR(err);
>> +	}
>> +
>> +	nandi->emi_clk = nandi_clk_setup(nandi, "emi_clk");
>> +	nandi->bch_clk = nandi_clk_setup(nandi, "bch_clk");
>> +
>> +	platform_set_drvdata(pdev, nandi);
>> +
>> +	return nandi;
>> +}
>> +
>> +static void *stm_bch_dt_get_pdata(struct platform_device *pdev)
>> +{
>> +	struct device_node *np = pdev->dev.of_node;
>> +	struct stm_plat_nand_bch_data *pdata;
>> +	int ecc_strength;
>> +	int ret;
>> +
>> +	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
>> +	if (!pdata)
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	of_property_read_u32(np, "nand-ecc-strength", &ecc_strength);
>> +	if (ecc_strength == 0)
>> +		pdata->bch_ecc_cfg = BCH_NO_ECC;
>> +	else if (ecc_strength == 18)
>> +		pdata->bch_ecc_cfg = BCH_18BIT_ECC;
>> +	else if (ecc_strength == 30)
>> +		pdata->bch_ecc_cfg = BCH_30BIT_ECC;
>> +	else
>> +		pdata->bch_ecc_cfg = BCH_ECC_AUTO;
>> +
>> +	ret = stm_of_get_nand_banks(&pdev->dev, np, &pdata->bank);
>> +	if (ret < 0)
>> +		return ERR_PTR(ret);
>> +
>> +	return pdata;
>> +}
>> +
>> +static int stm_nand_bch_probe(struct platform_device *pdev)
>> +{
>> +	const char *part_probes[] = { "cmdlinepart", "ofpart", NULL, };
>> +	struct stm_plat_nand_bch_data *pdata = pdev->dev.platform_data;
>
>You're assigning 'pdata' here (probably to NULL, since you're looking
>for DT-enabled platform devices, not legacy-style platform_devices)...
>
>> +	struct device_node *np = pdev->dev.of_node;
>> +	struct mtd_part_parser_data ppdata;
>> +	struct stm_nand_bank_data *bank;
>> +	struct nandi_bbt_info *bbt_info;
>> +	struct nandi_controller *nandi;
>> +	struct nandi_info *info;
>> +	struct nand_chip *chip;
>> +	struct mtd_info *mtd;
>> +	int compatible, err;
>> +
>> +	if (!np) {
>> +		dev_err(&pdev->dev, "DT node found\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	pdata = stm_bch_dt_get_pdata(pdev);
>
>...and then you're reassigning it here. Drop the first assignment?
>
>> +	if (IS_ERR(pdata))
>> +		return PTR_ERR(pdata);
>> +
>> +	ppdata.of_node = stm_of_get_partitions_node(np, 0);
>
>So you only support a single bank, at chip-select 0? Is this a
>hardware limitation, or simply software? You might consider whether this
>needs to be noted in the DT binding too -- it currently suggests that
>this can be plural.
>
>> +
>> +	pdev->dev.platform_data = pdata;
>
>Are you actually looking for driver data, not platform data? (e.g.,
>dev_set_drvdata() / platform_get_drvdata()) The two are a little
>different, but your usage sounds like this more of a driver-private
>description.
>
>> +
>> +	nandi = nandi_init_resources(pdev);
>> +	if (IS_ERR(nandi)) {
>> +		dev_err(&pdev->dev, "failed to initialise NANDi resources\n");
>> +		return PTR_ERR(nandi);
>> +	}
>> +
>> +	init_completion(&nandi->seq_completed);
>> +	init_completion(&nandi->rbn_completed);
>> +
>> +	bank = pdata->bank;
>> +	if (bank)
>> +		nandi_init_controller(nandi, bank->csn);
>> +
>> +	info            = &nandi->info;
>> +	chip            = &info->chip;
>> +	bbt_info        = &info->bbt_info;
>> +	mtd             = &info->mtd;
>> +	mtd->priv       = chip;
>> +	mtd->name       = dev_name(&pdev->dev);
>> +	mtd->dev.parent = &pdev->dev;
>> +
>> +	nandi_set_mtd_defaults(nandi, mtd, chip);
>> +
>> +	err = nand_scan_ident(mtd, 1, NULL);
>> +	if (err)
>> +		return err;
>> +
>> +	/*
>> +	 * Configure timing registers
>> +	 */
>> +	if (bank && bank->timing_spec) {
>> +		dev_info(&pdev->dev, "Using platform timing data\n");
>> +		nandi_configure_timing_registers(nandi, bank->timing_spec,
>> +						 bank->timing_relax);
>> +	} else if (chip->onfi_version) {
>> +		int mode = fls(onfi_get_async_timing_mode(chip) - 1);
>> +
>> +		/* Modes 4 and 5 (EDO) are not supported on our H/W */
>> +		if (mode > 3)
>> +			mode = 3;
>> +
>> +		dev_info(&pdev->dev, "Using ONFI Timing Mode %d\n", mode);
>> +		nandi_configure_timing_registers(nandi,
>> +					&st_nand_onfi_timing_specs[mode],
>> +					bank ? bank->timing_relax : 0);
>> +	} else {
>> +		dev_warn(&pdev->dev, "No timing data available\n");
>> +	}
>> +
>> +	if (mtd->writesize < NANDI_BCH_SECTOR_SIZE) {
>> +		dev_err(nandi->dev,
>> +			"page size incompatible with BCH ECC sector\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	/* Derive some working variables */
>> +	nandi->sectors_per_page = mtd->writesize / NANDI_BCH_SECTOR_SIZE;
>> +	nandi->blocks_per_device = mtd->size >> chip->phys_erase_shift;
>> +	nandi->extra_addr = ((chip->chipsize >> chip->page_shift) >
>> +			     0x10000) ? true : false;
>> +	mtd->writebufsize = mtd->writesize;
>> +
>> +	/* Set ECC mode */
>> +	if (pdata->bch_ecc_cfg == BCH_ECC_AUTO) {
>> +		err = bch_set_ecc_auto(nandi, mtd);
>> +		if (err) {
>> +			dev_err(nandi->dev, "insufficient OOB for BCH ECC\n");
>> +			return err;
>> +		}
>> +	} else {
>> +		nandi->bch_ecc_mode = pdata->bch_ecc_cfg;
>> +	}
>> +
>> +	chip->ecc.size = NANDI_BCH_SECTOR_SIZE;
>> +	chip->ecc.bytes = mtd->oobsize;
>> +	chip->ecc.strength = bch_ecc_strength[nandi->bch_ecc_mode];
>> +
>> +	info->ecclayout.eccbytes =
>> +		nandi->sectors_per_page * bch_ecc_sizes[nandi->bch_ecc_mode];
>> +
>> +	compatible = bch_check_compatibility(nandi, mtd, chip);
>> +	if (!compatible) {
>> +		dev_err(nandi->dev,
>> +			"NAND device incompatible with NANDi/BCH Controller\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	/* Tune BCH programs according to device found and ECC mode */
>> +	bch_configure_progs(nandi);
>> +
>> +	err = nandi_init_working_buffers(nandi, bbt_info, mtd);
>> +	if (err)
>> +		return err;
>> +
>> +	err = nand_scan_tail(mtd);
>> +	if (err)
>> +		return err;
>> +
>> +	nandi_dump_bad_blocks(nandi);
>> +
>> +	/* Add partitions */
>> +	return mtd_device_parse_register(mtd, part_probes, &ppdata,
>> +					bank->partitions, bank->nr_partitions);
>> +}
>> +
>> +static int stm_nand_bch_remove(struct platform_device *pdev)
>> +{
>> +	struct nandi_controller *nandi = platform_get_drvdata(pdev);
>> +
>> +	nand_release(&nandi->info.mtd);
>> +
>> +	nandi_clk_disable(nandi);
>> +
>> +	return 0;
>> +}
>> +
>> +#ifdef CONFIG_PM
>
>Should this be CONFIG_PM_SLEEP?
>
>> +static int stm_nand_bch_suspend(struct device *dev)
>> +{
>> +	struct nandi_controller *nandi = dev_get_drvdata(dev);
>> +
>> +	nandi_clk_disable(nandi);
>> +
>> +	return 0;
>> +}
>> +static int stm_nand_bch_resume(struct device *dev)
>> +{
>> +	struct nandi_controller *nandi = dev_get_drvdata(dev);
>> +
>> +	nandi_clk_enable(nandi);
>> +
>> +	return 0;
>> +}
>> +
>> +static int stm_nand_bch_restore(struct device *dev)
>> +{
>> +	struct nandi_controller *nandi = dev_get_drvdata(dev);
>> +	struct stm_plat_nand_bch_data *pdata = dev->platform_data;
>> +	struct stm_nand_bank_data *bank = pdata->bank;
>> +
>> +	nandi_init_controller(nandi, bank->csn);
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct dev_pm_ops stm_nand_bch_pm_ops = {
>> +	.suspend = stm_nand_bch_suspend,
>> +	.resume = stm_nand_bch_resume,
>> +	.restore = stm_nand_bch_restore,
>> +};
>> +#else
>> +static const struct dev_pm_ops stm_nand_bch_pm_ops;
>
>I think this might as well be:
>
>#define stm_nand_bch_pm_ops	NULL
>
>> +#endif
>> +
>> +static struct of_device_id nand_bch_match[] = {
>> +	{ .compatible = "st,nand-bch", },
>> +	{},
>> +};
>> +MODULE_DEVICE_TABLE(of, nand_bch_match);
>> +
>> +static struct platform_driver stm_nand_bch_driver = {
>> +	.probe	= stm_nand_bch_probe ,
>> +	.remove	= stm_nand_bch_remove,
>> +	.driver	= {
>> +		.name	= "stm-nand-bch",
>> +		.owner	= THIS_MODULE,
>> +		.of_match_table = of_match_ptr(nand_bch_match),
>> +		.pm	= &stm_nand_bch_pm_ops,
>> +	},
>> +};
>> +module_platform_driver(stm_nand_bch_driver);
>> +
>> +MODULE_LICENSE("GPL");
>> +MODULE_AUTHOR("Angus Clark");
>> +MODULE_DESCRIPTION("STM NAND BCH driver");
>> diff --git a/drivers/mtd/nand/stm_nand_dt.c b/drivers/mtd/nand/stm_nand_dt.c
>> new file mode 100644
>> index 0000000..21bd20f
>> --- /dev/null
>> +++ b/drivers/mtd/nand/stm_nand_dt.c
>> @@ -0,0 +1,116 @@
>> +/*
>> + * drivers/mtd/nand/stm_nand_dt.c
>> + *
>> + * Support for NANDi BCH Controller Device Tree component
>> + *
>> + * Copyright (c) 2014 STMicroelectronics Limited
>> + * Author: Author: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + */
>> +
>> +#include <linux/init.h>
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/err.h>
>> +#include <linux/byteorder/generic.h>
>> +#include <linux/of.h>
>> +#include <linux/of_address.h>
>> +#include <linux/of_mtd.h>
>> +#include <linux/mtd/nand.h>
>> +#include <linux/mtd/stm_nand.h>
>> +
>> +#include "stm_nand_regs.h"
>> +
>> +/**
>> +* stm_of_get_partitions_node - get partitions node from stm-nand type devices.
>> +*
>> +* @dev		device pointer to use for devm allocations.
>> +* @np		device node of the driver.
>> +* @bank_nr	which bank number to use to get partitions.
>> +*
>> +* Returns a node pointer if found, with refcount incremented, use
>> +* of_node_put() on it when done.
>> +*
>> +*/
>> +struct device_node *stm_of_get_partitions_node(struct device_node *np,
>> +					       int bank_nr)
>> +{
>> +	struct device_node *banksnp, *banknp, *partsnp = NULL;
>> +	char name[10];
>> +
>> +	banksnp = of_parse_phandle(np, "st,nand-banks", 0);
>> +	if (!banksnp)
>> +		return NULL;
>> +
>> +	sprintf(name, "bank%d", bank_nr);
>> +	banknp = of_get_child_by_name(banksnp, name);
>> +	if (banknp)
>> +		return NULL;
>> +
>> +	partsnp = of_get_child_by_name(banknp, "partitions");
>> +	of_node_put(banknp);
>> +
>> +	return partsnp;
>> +}
>> +EXPORT_SYMBOL(stm_of_get_partitions_node);
>> +
>> +/**
>> + * stm_of_get_nand_banks - Get nand banks info from a given device node.
>> + *
>> + * @dev			device pointer to use for devm allocations.
>> + * @np			device node of the driver.
>> + * @banksptr		double pointer to banks which is allocated
>> + *			and filled with bank data.
>> + *
>> + * Returns a count of banks found in the given device node.
>> + *
>> + */
>> +int stm_of_get_nand_banks(struct device *dev, struct device_node *np,
>> +			  struct stm_nand_bank_data **banksptr)
>> +{
>> +	struct stm_nand_bank_data *banks;
>> +	struct device_node *banknp, *banksnp;
>> +	int nr_banks = 0;
>> +
>> +	if (!np)
>> +		return -ENODEV;
>> +
>> +	banksnp = of_parse_phandle(np, "st,nand-banks", 0);
>> +	if (!banksnp) {
>> +		dev_warn(dev, "No NAND banks specified in DT: %s\n",
>> +			 np->full_name);
>> +		return -ENODEV;
>> +	}
>> +
>> +	for_each_child_of_node(banksnp, banknp)
>> +		nr_banks++;
>> +
>> +	*banksptr = devm_kzalloc(dev, sizeof(*banks) * nr_banks, GFP_KERNEL);
>> +	banks = *banksptr;
>> +	banknp = NULL;
>> +
>> +	for_each_child_of_node(banksnp, banknp) {
>> +		int bank = 0;
>> +
>> +		of_property_read_u32(banknp, "st,nand-csn", &banks[bank].csn);
>> +
>> +		if (of_get_nand_bus_width(banknp) == 16)
>> +			banks[bank].options |= NAND_BUSWIDTH_16;
>> +		if (of_get_nand_on_flash_bbt(banknp))
>> +			banks[bank].bbt_options |= NAND_BBT_USE_FLASH;
>> +
>> +		banks[bank].nr_partitions = 0;
>> +		banks[bank].partitions = NULL;
>> +
>> +		of_property_read_u32(banknp, "st,nand-timing-relax",
>> +				     &banks[bank].timing_relax);
>> +		bank++;
>> +	}
>> +
>> +	return nr_banks;
>> +}
>> +EXPORT_SYMBOL(stm_of_get_nand_banks);
>> diff --git a/drivers/mtd/nand/stm_nand_dt.h b/drivers/mtd/nand/stm_nand_dt.h
>> new file mode 100644
>> index 0000000..de4507c
>> --- /dev/null
>> +++ b/drivers/mtd/nand/stm_nand_dt.h
>> @@ -0,0 +1,39 @@
>> +/*
>> + * drivers/mtd/nand/stm_nand_dt.h
>> + *
>> + * Support for NANDi BCH Controller Device Tree component
>> + *
>> + * Copyright (c) 2014 STMicroelectronics Limited
>> + * Author: Author: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + */
>> +
>> +#ifndef STM_NAND_DT_H
>> +#define STM_NAND_DT_H
>> +
>> +#if defined(CONFIG_MTD_NAND_STM_BCH_DT)
>> +struct device_node *stm_of_get_partitions_node(struct device_node *np,
>> +					       int bank_nr);
>> +
>> +int stm_of_get_nand_banks(struct device *dev, struct device_node *np,
>> +			  struct stm_nand_bank_data **banksp);
>> +#else
>> +static inline
>> +struct device_node *stm_of_get_partitions_node(struct device_node *np,
>> +					       int bank_nr)
>> +{
>> +	return NULL;
>> +}
>> +
>> +static inline int  stm_of_get_nand_banks(struct device *dev,
>> +					 struct device_node *np,
>> +					 struct stm_nand_bank_data **banksp)
>> +{
>> +	return 0;
>> +}
>> +#endif /* CONFIG_MTD_NAND_STM_BCH_DT */
>> +#endif /* STM_NAND_DT_H */
>> diff --git a/drivers/mtd/nand/stm_nand_regs.h b/drivers/mtd/nand/stm_nand_regs.h
>> new file mode 100644
>> index 0000000..2b0e069
>> --- /dev/null
>> +++ b/drivers/mtd/nand/stm_nand_regs.h
>> @@ -0,0 +1,302 @@
>> +/*
>> + * drivers/mtd/nand/stm_nand_regs.h
>> + *
>> + * STMicroelectronics NAND Controller register definitions
>> + *
>> + * Copyright (c) 2008-2014 STMicroelectronics Limited
>> + * Author: Angus Clark <Angus.Clark@st.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + */
>> +
>> +#ifndef STM_NANDC_REGS_H
>> +#define STM_NANDC_REGS_H
>> +
>> +/* Hamming Controller Registers (Offsets from EMINAND_BASE) */
>> +#define NANDHAM_BOOTBANK_CFG				0x000
>> +#define NANDHAM_RBN_STA					0x004
>> +#define NANDHAM_INT_EN					0x010
>> +#define NANDHAM_INT_STA					0x014
>> +#define NANDHAM_INT_CLR					0x018
>> +#define NANDHAM_INT_EDGE_CFG				0x01C
>> +#define NANDHAM_CTL_TIMING				0x040
>> +#define NANDHAM_WEN_TIMING				0x044
>> +#define NANDHAM_REN_TIMING				0x048
>> +#define NANDHAM_BLOCK_ZERO_REMAP_REG			0x04C
>> +#define NANDHAM_FLEXMODE_CFG				0x100
>> +#define NANDHAM_FLEX_MUXCTRL				0x104
>> +#define NANDHAM_FLEX_DATAWRITE_CONFIG			0x10C
>> +#define NANDHAM_FLEX_DATAREAD_CONFIG			0x110
>> +#define NANDHAM_FLEX_CMD				0x114
>> +#define NANDHAM_FLEX_ADD				0x118
>> +#define NANDHAM_FLEX_DATA				0x120
>> +#define NANDHAM_VERSION_REG				0x144
>> +#define NANDHAM_MULTI_CS_CONFIG_REG			0x1EC
>> +#define NANDHAM_AFM_SEQ_REG_1				0x200
>> +#define NANDHAM_AFM_SEQ_REG_2				0x204
>> +#define NANDHAM_AFM_SEQ_REG_3				0x208
>> +#define NANDHAM_AFM_SEQ_REG_4				0x20C
>> +#define NANDHAM_AFM_ADD					0x210
>> +#define NANDHAM_AFM_EXTRA				0x214
>> +#define NANDHAM_AFM_CMD					0x218
>> +#define NANDHAM_AFM_SEQ_CFG				0x21C
>> +#define NANDHAM_AFM_GEN_CFG				0x220
>> +#define NANDHAM_AFM_SEQ_STA				0x240
>> +#define NANDHAM_AFM_ECC_REG_0				0x280
>> +#define NANDHAM_AFM_ECC_REG_1				0x284
>> +#define NANDHAM_AFM_ECC_REG_2				0x288
>> +#define NANDHAM_AFM_ECC_REG_3				0x28C
>> +#define NANDHAM_AFM_DATA_FIFO				0x300
>> +
>> +/* BCH Controller Registers (Offsets from EMI_NAND) */
>> +#define NANDBCH_BOOTBANK_CFG				0x000
>> +#define NANDBCH_RBN_STA					0x004
>> +#define NANDBCH_INT_EN					0x010
>> +#define NANDBCH_INT_STA					0x014
>> +#define NANDBCH_INT_CLR					0x018
>> +#define NANDBCH_INT_EDGE_CFG				0x01C
>> +#define NANDBCH_CTL_TIMING				0x040
>> +#define NANDBCH_WEN_TIMING				0x044
>> +#define NANDBCH_REN_TIMING				0x048
>> +#define NANDBCH_BLOCK_ZERO_REMAP_REG			0x04C
>> +#define NANDBCH_BOOT_STATUS				0x050
>> +#define NANDBCH_FALSE_BOOT_REG				0x054
>> +#define NANDBCH_FALSE_BOOT_STATUS			0x058
>> +#define NANDBCH_CONTROLLER_CFG				0x100
>> +#define NANDBCH_FLEX_MUXCTRL				0x104
>> +#define NANDBCH_FLEX_DATAWRITE_CONFIG			0x10C
>> +#define NANDBCH_FLEX_DATAREAD_CONFIG			0x110
>> +#define NANDBCH_VERSION_REG				0x144
>> +#define NANDBCH_ADDRESS_REG_1				0x1F0
>> +#define NANDBCH_ADDRESS_REG_2				0x1F4
>> +#define NANDBCH_ADDRESS_REG_3				0x1F8
>> +#define NANDBCH_MULTI_CS_CONFIG_REG			0x1FC
>> +#define NANDBCH_SEQ_REG_1				0x200
>> +#define NANDBCH_SEQ_REG_2				0x204
>> +#define NANDBCH_SEQ_REG_3				0x208
>> +#define NANDBCH_SEQ_REG_4				0x20C
>> +#define NANDBCH_ADD					0x210
>> +#define NANDBCH_EXTRA_REG				0x214
>> +#define NANDBCH_CMD					0x218
>> +#define NANDBCH_GEN_CFG					0x220
>> +#define NANDBCH_DELAY_REG				0x224
>> +#define NANDBCH_SEQ_CFG					0x22C
>> +#define NANDBCH_SEQ_STA					0x270
>> +#define NANDBCH_DATA_BUFFER_ENTRY_0			0x280
>> +#define NANDBCH_DATA_BUFFER_ENTRY_1			0x284
>> +#define NANDBCH_DATA_BUFFER_ENTRY_2			0x288
>> +#define NANDBCH_DATA_BUFFER_ENTRY_3			0x28C
>> +#define NANDBCH_DATA_BUFFER_ENTRY_4			0x290
>> +#define NANDBCH_DATA_BUFFER_ENTRY_5			0x294
>> +#define NANDBCH_DATA_BUFFER_ENTRY_6			0x298
>> +#define NANDBCH_DATA_BUFFER_ENTRY_7			0x29C
>> +#define NANDBCH_ECC_SCORE_REG_A				0x2A0
>> +#define NANDBCH_ECC_SCORE_REG_B				0x2A4
>> +#define NANDBCH_CHECK_STATUS_REG_A			0x2A8
>> +#define NANDBCH_CHECK_STATUS_REG_B			0x2AC
>> +#define NANDBCH_BUFFER_LIST_PTR				0x300
>> +#define NANDBCH_SEQ_PTR_REG				0x304
>> +#define NANDBCH_ERROR_THRESHOLD_REG			0x308
>> +
>> +/* EMISS NAND BCH STPLUG Registers (Offsets from EMISS_NAND_DMA) */
>> +#define EMISS_NAND_RD_DMA_PAGE_SIZE			0x000
>> +#define EMISS_NAND_RD_DMA_MAX_OPCODE_SIZE		0x004
>> +#define EMISS_NAND_RD_DMA_MIN_OPCODE_SIZE		0x008
>> +#define EMISS_NAND_RD_DMA_MAX_CHUNK_SIZE		0x00C
>> +#define EMISS_NAND_RD_DMA_MAX_MESSAGE_SIZE		0x010
>> +
>> +#define EMISS_NAND_WR_DMA_PAGE_SIZE			0x100
>> +#define EMISS_NAND_WR_DMA_MAX_OPCODE_SIZE		0x104
>> +#define EMISS_NAND_WR_DMA_MIN_OPCODE_SIZE		0x108
>> +#define EMISS_NAND_WR_DMA_MAX_CHUNK_SIZE		0x10C
>> +#define EMISS_NAND_WR_DMA_MAX_MESSAGE_SIZE		0x110
>> +
>> +
>> +/*
>> + * Hamming/BCH controller interrupts
>> + */
>> +
>> +/* NANDxxx_INT_EN/NANDxxx_INT_STA */
>> +/*      Common */
>> +#define NAND_INT_ENABLE				(0x1 << 0)
>> +#define NAND_INT_RBN				(0x1 << 2)
>> +#define NAND_INT_SEQCHECK			(0x1 << 5)
>> +/*      Hamming only */
>> +#define NANDHAM_INT_DATA_DREQ			(0x1 << 3)
>> +#define NANDHAM_INT_SEQ_DREQ			(0x1 << 4)
>> +#define NANDHAM_INT_ECC_FIX_REQ			(0x1 << 6)
>> +/*      BCH only */
>> +#define NANDBCH_INT_SEQNODESOVER		(0x1 << 7)
>> +#define NANDBCH_INT_ECCTHRESHOLD		(0x1 << 8)
>> +
>> +/* NANDxxx_INT_CLR */
>> +/*      Common */
>> +#define NAND_INT_CLR_RBN			(0x1 << 2)
>> +#define NAND_INT_CLR_SEQCHECK			(0x1 << 3)
>> +/*      Hamming only */
>> +#define NANDHAM_INT_CLR_ECC_FIX_REQ		(0x1 << 4)
>> +#define NANDHAM_INT_CLR_DATA_DREQ		(0x1 << 5)
>> +#define NANDHAM_INT_CLR_SEQ_DREQ		(0x1 << 6)
>> +/*      BCH only */
>> +#define NANDBCH_INT_CLR_SEQNODESOVER		(0x1 << 5)
>> +#define NANDBCH_INT_CLR_ECCTHRESHOLD		(0x1 << 6)
>> +
>> +/* NANDxxx_INT_EDGE_CFG */
>> +#define NAND_EDGE_CFG_RBN_RISING		0x1
>> +#define NAND_EDGE_CFG_RBN_FALLING		0x2
>> +#define NAND_EDGE_CFG_RBN_ANY			0x3
>> +
>> +/* NANDBCH_CONTROLLER_CFG/NANDHAM_FLEXMODE_CFG */
>> +#define CFG_ENABLE_FLEX				0x1
>> +#define CFG_ENABLE_AFM				0x2
>> +#define CFG_RESET				(0x1 << 3)
>> +#define CFG_RESET_ECC(x)			(0x1 << (7 + (x)))
>> +#define CFG_RESET_ECC_ALL			(0xff << 7)
>> +
>> +
>> +/*
>> + * BCH Controller
>> + */
>> +
>> +/* NANDBCH_BOOTBANK_CFG */
>> +#define BOOT_CFG_RESET				(0x1 << 3)
>> +
>> +/* NANDBCH_CTL_TIMING */
>> +#define NANDBCH_CTL_SETUP(x)			((x) & 0xff)
>> +#define NANDBCH_CTL_HOLD(x)			(((x) & 0xff) << 8)
>> +#define NANDBCH_CTL_WERBN(x)			(((x) & 0xff) << 24)
>> +
>> +/* NANDBCH_WEN_TIMING */
>> +#define NANDBCH_WEN_ONTIME(x)			((x) & 0xff)
>> +#define NANDBCH_WEN_OFFTIME(x)			(((x) & 0xff) << 8)
>> +#define NANDBCH_WEN_ONHALFCYCLE			(0x1 << 16)
>> +#define NANDBCH_WEN_OFFHALFCYCLE		(0x1 << 17)
>> +
>> +/* NANDBCH_REN_TIMING */
>> +#define NANDBCH_REN_ONTIME(x)			((x) & 0xff)
>> +#define NANDBCH_REN_OFFTIME(x)			(((x) & 0xff) << 8)
>> +#define NANDBCH_REN_ONHALFCYCLE			(0x1 << 16)
>> +#define NANDBCH_REN_OFFHALFCYCLE		(0x1 << 17)
>> +#define NANDBCH_REN_TELQV(x)			(((x) & 0xff) << 24)
>> +
>> +/* NANDBCH_BLOCK_ZERO_REMAP_REG */
>> +#define NANDBCH_BACKUP_COPY_FOUND		(0x1 << 0)
>> +#define NANDBCH_ORIG_CODE_CORRUPTED		(0x1 << 1)
>> +#define NANDBCH_BLK_ZERO_REMAP(x)		((x) >> 14)
>> +
>> +/* NANDBCH_BOOT_STATUS */
>> +#define NANDBCH_BOOT_MAX_ERRORS(x)		((x) & 0x1f)
>> +
>> +/* NANDBCH_GEN_CFG */
>> +#define GEN_CFG_DATA_8_NOT_16			(0x1 << 16)
>> +#define GEN_CFG_EXTRA_ADD_CYCLE			(0x1 << 18)
>> +#define GEN_CFG_2X8_MODE			(0x1 << 19)
>> +#define GEN_CFG_ECC_SHIFT			20
>> +#define GEN_CFG_18BIT_ECC			(BCH_18BIT_ECC << \
>> +						GEN_CFG_ECC_SHIFT)
>> +#define GEN_CFG_30BIT_ECC			(BCH_30BIT_ECC << \
>> +						GEN_CFG_ECC_SHIFT)
>> +#define GEN_CFG_NO_ECC				(BCH_NO_ECC    << \
>> +						GEN_CFG_ECC_SHIFT)
>> +#define GEN_CFG_LAST_SEQ_NODE			(0x1 << 22)
>> +
>> +/* NANDBCH_SEQ_CFG */
>> +#define SEQ_CFG_REPEAT_COUNTER(x)		((x) & 0xffff)
>> +#define SEQ_CFG_SEQ_IDENT(x)			(((x) & 0xff) << 16)
>> +#define SEQ_CFG_DATA_WRITE			(0x1 << 24)
>> +#define SEQ_CFG_ERASE				(0x1 << 25)
>> +#define SEQ_CFG_GO_STOP				(0x1 << 26)
>> +
>> +/* NANDBCH_SEQ_STA */
>> +#define SEQ_STA_RUN				(0x1 << 4)
>> +
>> +/*
>> + * BCH Commands
>> + */
>> +#define BCH_OPC_STOP			0x0
>> +#define BCH_OPC_CMD			0x1
>> +#define BCH_OPC_INC			0x2
>> +#define BCH_OPC_DEC_JUMP		0x3
>> +#define BCH_OPC_DATA			0x4
>> +#define BCH_OPC_DELAY			0x5
>> +#define BCH_OPC_CHECK			0x6
>> +#define BCH_OPC_ADDR			0x7
>> +#define BCH_OPC_NEXT_CHIP_ON		0x8
>> +#define BCH_OPC_DEC_JMP_MCS		0x9
>> +#define BCH_OPC_ECC_SCORE		0xA
>> +
>> +#define BCH_INSTR(opc, opr)		((opc) | ((opr) << 4))
>> +
>> +#define BCH_CMD_ADDR			BCH_INSTR(BCH_OPC_CMD, 0)
>> +#define BCH_CL_CMD_1			BCH_INSTR(BCH_OPC_CMD, 1)
>> +#define BCH_CL_CMD_2			BCH_INSTR(BCH_OPC_CMD, 2)
>> +#define BCH_CL_CMD_3			BCH_INSTR(BCH_OPC_CMD, 3)
>> +#define BCH_CL_EX_0			BCH_INSTR(BCH_OPC_CMD, 4)
>> +#define BCH_CL_EX_1			BCH_INSTR(BCH_OPC_CMD, 5)
>> +#define BCH_CL_EX_2			BCH_INSTR(BCH_OPC_CMD, 6)
>> +#define BCH_CL_EX_3			BCH_INSTR(BCH_OPC_CMD, 7)
>> +#define BCH_INC(x)			BCH_INSTR(BCH_OPC_INC, (x))
>> +#define BCH_DEC_JUMP(x)			BCH_INSTR(BCH_OPC_DEC_JUMP, (x))
>> +#define BCH_STOP			BCH_INSTR(BCH_OPC_STOP, 0)
>> +#define BCH_DATA_1_SECTOR		BCH_INSTR(BCH_OPC_DATA, 0)
>> +#define BCH_DATA_2_SECTOR		BCH_INSTR(BCH_OPC_DATA, 1)
>> +#define BCH_DATA_4_SECTOR		BCH_INSTR(BCH_OPC_DATA, 2)
>> +#define BCH_DATA_8_SECTOR		BCH_INSTR(BCH_OPC_DATA, 3)
>> +#define BCH_DATA_16_SECTOR		BCH_INSTR(BCH_OPC_DATA, 4)
>> +#define BCH_DATA_32_SECTOR		BCH_INSTR(BCH_OPC_DATA, 5)
>> +#define BCH_DELAY_0			BCH_INSTR(BCH_OPC_DELAY, 0)
>> +#define BCH_DELAY_1			BCH_INSTR(BCH_OPC_DELAY, 1)
>> +#define BCH_OP_ERR			BCH_INSTR(BCH_OPC_CHECK, 0)
>> +#define BCH_CACHE_ERR			BCH_INSTR(BCH_OPC_CHECK, 1)
>> +#define BCH_ERROR			BCH_INSTR(BCH_OPC_CHECK, 2)
>> +#define BCH_AL_EX_0			BCH_INSTR(BCH_OPC_ADDR, 0)
>> +#define BCH_AL_EX_1			BCH_INSTR(BCH_OPC_ADDR, 1)
>> +#define BCH_AL_EX_2			BCH_INSTR(BCH_OPC_ADDR, 2)
>> +#define BCH_AL_EX_3			BCH_INSTR(BCH_OPC_ADDR, 3)
>> +#define BCH_AL_AD_0			BCH_INSTR(BCH_OPC_ADDR, 4)
>> +#define BCH_AL_AD_1			BCH_INSTR(BCH_OPC_ADDR, 5)
>> +#define BCH_AL_AD_2			BCH_INSTR(BCH_OPC_ADDR, 6)
>> +#define BCH_AL_AD_3			BCH_INSTR(BCH_OPC_ADDR, 7)
>> +#define BCH_NEXT_CHIP_ON		BCH_INSTR(BCH_OPC_NEXT_CHIP_ON, 0)
>> +#define BCH_DEC_JMP_MCS(x)		BCH_INSTR(BCH_OPC_DEC_JMP_MCS, (x))
>> +#define BCH_ECC_SCORE(x)		BCH_INSTR(BCH_OPC_ECC_SCORE, (x))
>> +
>> +
>> +/*
>> + * Hamming-FLEX register fields
>> + */
>> +
>> +/* NANDHAM_FLEX_DATAREAD/WRITE_CONFIG */
>> +#define FLEX_DATA_CFG_WAIT_RBN			(0x1 << 27)
>> +#define FLEX_DATA_CFG_BEATS_1			(0x1 << 28)
>> +#define FLEX_DATA_CFG_BEATS_2			(0x2 << 28)
>> +#define FLEX_DATA_CFG_BEATS_3			(0x3 << 28)
>> +#define FLEX_DATA_CFG_BEATS_4			(0x0 << 28)
>> +#define FLEX_DATA_CFG_BYTES_1			(0x0 << 30)
>> +#define FLEX_DATA_CFG_BYTES_2			(0x1 << 30)
>> +#define FLEX_DATA_CFG_CSN			(0x1 << 31)
>> +
>> +/* NANDHAM_FLEX_CMD */
>> +#define FLEX_CMD_RBN				(0x1 << 27)
>> +#define FLEX_CMD_BEATS_1			(0x1 << 28)
>> +#define FLEX_CMD_BEATS_2			(0x2 << 28)
>> +#define FLEX_CMD_BEATS_3			(0x3 << 28)
>> +#define FLEX_CMD_BEATS_4			(0x0 << 28)
>> +#define FLEX_CMD_CSN				(0x1 << 31)
>> +#define FLEX_CMD(x)				(((x) & 0xff) |	\
>> +						 FLEX_CMD_RBN |	\
>> +						 FLEX_CMD_BEATS_1 |	\
>> +						 FLEX_CMD_CSN)
>> +/* NANDHAM_FLEX_ADD */
>> +#define FLEX_ADDR_RBN				(0x1 << 27)
>> +#define FLEX_ADDR_BEATS_1			(0x1 << 28)
>> +#define FLEX_ADDR_BEATS_2			(0x2 << 28)
>> +#define FLEX_ADDR_BEATS_3			(0x3 << 28)
>> +#define FLEX_ADDR_BEATS_4			(0x0 << 28)
>> +#define FLEX_ADDR_ADD8_VALID			(0x1 << 30)
>> +#define FLEX_ADDR_CSN				(0x1 << 31)
>> +
>> +#endif /* STM_NANDC_REGS_H */
>> diff --git a/include/linux/mtd/stm_nand.h b/include/linux/mtd/stm_nand.h
>> new file mode 100644
>> index 0000000..3cd3a14
>> --- /dev/null
>> +++ b/include/linux/mtd/stm_nand.h
>> @@ -0,0 +1,104 @@
>> +/*
>> + * include/linux/mtd/stm_mtd.h
>> + *
>> + * Support for STMicroelectronics NAND Controllers
>> + *
>> + * Copyright (c) 2014 STMicroelectronics Limited
>> + * Author: Angus Clark <Angus.Clark@st.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + */
>> +
>> +#ifndef __LINUX_STM_NAND_H
>> +#define __LINUX_STM_NAND_H
>> +
>> +#include <linux/io.h>
>> +
>> +/*
>> + * Board-level specification relating to a 'bank' of NAND Flash
>> + */
>> +struct stm_nand_bank_data {
>> +	int			csn;
>> +	int			nr_partitions;
>> +	struct mtd_partition	*partitions;
>> +	unsigned int		options;
>> +	unsigned int		bbt_options;
>> +
>> +	struct nand_sdr_timings *timing_spec;
>> +
>> +	/*
>> +	 * No. of IP clk cycles by which to 'relax' the timing configuration.
>> +	 * Required on some boards to to accommodate board-level limitations.
>> +	 * Used in conjunction with 'nand_sdr_timings' and ONFI configuration.
>> +	 */
>> +	int			timing_relax;
>> +};
>> +
>> +/* ECC Modes */
>> +enum stm_nand_bch_ecc_config {
>> +	BCH_18BIT_ECC = 0,
>> +	BCH_30BIT_ECC,
>> +	BCH_NO_ECC,
>> +	BCH_ECC_RSRV,
>> +	BCH_ECC_AUTO,
>> +};
>> +
>> +struct stm_plat_nand_bch_data {
>> +	struct stm_nand_bank_data *bank;
>> +	enum stm_nand_bch_ecc_config bch_ecc_cfg;
>> +
>> +	/* The threshold at which the number of corrected bit-flips per sector
>> +	 * is deemed to have reached an excessive level (triggers '-EUCLEAN' to
>> +	 * be returned to the caller).  The value should be in the range 1 to
>> +	 * <ecc-strength> where <ecc-strength> is 18 or 30, depending on the BCH
>> +	 * ECC mode in operation.  A value of 0 is interpreted by the driver as
>> +	 * <ecc-strength>.
>> +	 */
>> +	unsigned int bch_bitflip_threshold;
>
>This field is never set or used...
>
>> +	bool flashss;
>
>Ditto.
>
Probably answered in [2]


>> +};
>> +
>> +#define EMISS_BASE				0xfef01000
>> +#define EMISS_CONFIG				0x0000
>> +#define EMISS_CONFIG_HAMMING_NOT_BCH		(0x1 << 6)
>> +
>> +enum nandi_controllers {
>> +	STM_NANDI_UNCONFIGURED,
>> +	STM_NANDI_HAMMING,
>> +	STM_NANDI_BCH
>> +};
>> +


/* some header comment for this function would be good */

>> +static inline void emiss_nandi_select(enum nandi_controllers controller)
>> +{
>> +	unsigned v;
>> +	void __iomem *emiss_config_base;
>> +
>> +	emiss_config_base = ioremap(EMISS_BASE, 4);

Important: 'emiss_nandi_select' is called at every READ, WRITE and ERASE operation.
Do you really want to ioremap() and iounmap() here ?
Shouldn't this be part of somewhere in probe(), where your ecc-scheme
and controller configurations are initialized ?


>> +	if (!emiss_config_base) {
>> +		pr_err("%s: failed to ioremap EMISS\n", __func__);
>> +		return;
>> +	}
>> +
>> +	v = readl(emiss_config_base + EMISS_CONFIG);
>> +
>> +	if (controller == STM_NANDI_HAMMING) {
>> +		if (v & EMISS_CONFIG_HAMMING_NOT_BCH)
>> +			goto out;
>> +		v |= EMISS_CONFIG_HAMMING_NOT_BCH;
>> +	} else {
>> +		if (!(v & EMISS_CONFIG_HAMMING_NOT_BCH))
>> +			goto out;
>> +		v &= ~EMISS_CONFIG_HAMMING_NOT_BCH;
>> +	}
>> +
>> +	writel(v, emiss_config_base + EMISS_CONFIG);
>> +	readl(emiss_config_base + EMISS_CONFIG);
>> +
>> +out:
>> +	iounmap(emiss_config_base);
>> +}
>> +
>> +#endif /* __LINUX_STM_NAND_H */
>
>Alright, that's enough of my review for now. I'm not sure I've gotten to
>everything yet, but that should give you something to chew on.
>
>Brian

Sorry, this review got delayed from my part..
But I hope I have covered most of the review in this and earlier responses.
if you are able to clean most of these then should be ready for 3.17+.

Please re-send the next version in similar squashed format, as its easy for review.
And once Brian is okay, may be then you can re-send individual patches.


with regards, pekon
