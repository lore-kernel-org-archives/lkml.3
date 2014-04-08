Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112AbaDHWQr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 18:16:47 -0400
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:13651 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756174AbaDHWQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 18:16:45 -0400
Message-ID: <5344754B.8050909@akamai.com>
Date: Tue, 08 Apr 2014 18:16:43 -0400
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: "tony.luck@intel.com" <tony.luck@intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "mingo@kernel.org" <mingo@kernel.org>,
        "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "mitake@dcl.info.waseda.ac.jp" <mitake@dcl.info.waseda.ac.jp>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] ie31200_edac: Add driver
References: <cover.1396645124.git.jbaron@akamai.com> <760765424abe31811027ff3efd078bc858b7d3ed.1396645124.git.jbaron@akamai.com> <20140408090924.GE30077@pd.tnic>
In-Reply-To: <20140408090924.GE30077@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On 04/08/2014 05:09 AM, Borislav Petkov wrote:
> On Fri, Apr 04, 2014 at 09:14:04PM +0000, Jason Baron wrote:
>> Add 'ie31200_edac' driver for the E3-1200 series of Intel processors. Driver
>> is based on the following E3-1200 specs:
>>
>> http://www.intel.com/content/www/us/en/processors/xeon/xeon-e3-1200-family-vol-2-datasheet.html
>> http://www.intel.com/content/www/us/en/processors/xeon/xeon-e3-1200v3-vol-2-datasheet.html
>>
>> I've tested this on bad memory hardware, and observed correlating bad reads
>> and uncorrected memory errors as reported by the driver.
>>
>> Signed-off-by: Jason Baron <jbaron@akamai.com>
>> ---
>>  drivers/edac/Kconfig        |   7 +
>>  drivers/edac/Makefile       |   1 +
>>  drivers/edac/ie31200_edac.c | 540 ++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 548 insertions(+)
>>  create mode 100644 drivers/edac/ie31200_edac.c
>>
>> diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
>> index 878f090..27f44a1 100644
>> --- a/drivers/edac/Kconfig
>> +++ b/drivers/edac/Kconfig
>> @@ -186,6 +186,13 @@ config EDAC_I3200
>>         Support for error detection and correction on the Intel
>>         3200 and 3210 server chipsets.
>>
>> +config EDAC_IE31200
>> +     tristate "Intel e312xx"
>> +     depends on EDAC_MM_EDAC && PCI && X86
>> +     help
>> +       Support for error detection and correction on the Intel
>> +       E3-1200 processor.
>> +
>>  config EDAC_X38
>>       tristate "Intel X38"
>>       depends on EDAC_MM_EDAC && PCI && X86
>> diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
>> index 4154ed6..c479a24 100644
>> --- a/drivers/edac/Makefile
>> +++ b/drivers/edac/Makefile
>> @@ -37,6 +37,7 @@ obj-$(CONFIG_EDAC_I82875P)          += i82875p_edac.o
>>  obj-$(CONFIG_EDAC_I82975X)           += i82975x_edac.o
>>  obj-$(CONFIG_EDAC_I3000)             += i3000_edac.o
>>  obj-$(CONFIG_EDAC_I3200)             += i3200_edac.o
>> +obj-$(CONFIG_EDAC_IE31200)           += ie31200_edac.o
>>  obj-$(CONFIG_EDAC_X38)                       += x38_edac.o
>>  obj-$(CONFIG_EDAC_I82860)            += i82860_edac.o
>>  obj-$(CONFIG_EDAC_R82600)            += r82600_edac.o
>> diff --git a/drivers/edac/ie31200_edac.c b/drivers/edac/ie31200_edac.c
>> new file mode 100644
>> index 0000000..ae03d21
>> --- /dev/null
>> +++ b/drivers/edac/ie31200_edac.c
>> @@ -0,0 +1,540 @@
>> +/*
>> + * Intel E3-1200
>> + * Copyright (C) 2014 Jason Baron <jbaron@akamai.com>
>> + *
>> + * Support for the E3-1200 processor family. Heavily based on previous
>> + * Intel EDAC drivers.
>> + *
>> + * Since the DRAM controller is on the cpu chip, we can use its PCI device
>> + * id to identify these processors.
>> + *
>> + * PCI DRAM controller device ids (Taken from The PCI ID Repository - http://pci-ids.ucw.cz/)
>> + *
>> + * 0108: Xeon E3-1200 Processor Family DRAM Controller
>> + * 010c: Xeon E3-1200/2nd Generation Core Processor Family DRAM Controller
>> + * 0150: Xeon E3-1200 v2/3rd Gen Core processor DRAM Controller
>> + * 0158: Xeon E3-1200 v2/Ivy Bridge DRAM Controller
>> + * 015c: Xeon E3-1200 v2/3rd Gen Core processor DRAM Controller
>> + * 0c04: Xeon E3-1200 v3/4th Gen Core Processor DRAM Controller
>> + * 0c08: Xeon E3-1200 v3 Processor DRAM Controller
>> + *
>> + * Based on Intel specification:
>> + * http://www.intel.com/content/dam/www/public/us/en/documents/datasheets/xeon-e3-1200v3-vol-2-datasheet.pdf
>> + * http://www.intel.com/content/www/us/en/processors/xeon/xeon-e3-1200-family-vol-2-datasheet.html
>> + *
>> + * According to the above datasheet (p.16):
>> + * "
>> + * 6. Software must not access B0/D0/F0 32-bit memory-mapped registers with
>> + * requests that cross a DW boundary.
>> + * "
>> + *
>> + * Thus, we make use of the explicit: lo_hi_readq(), which breaks the readq into
>> + * 2 readl() calls. This restriction may be lifted in subsequent chip releases,
>> + * but lo_hi_readq() ensures that we are safe across all e3-1200 processors.
>> + *
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/init.h>
>> +#include <linux/pci.h>
>> +#include <linux/pci_ids.h>
>> +#include <linux/edac.h>
>> +
>> +#include <asm-generic/io-64-nonatomic-lo-hi.h>
>> +#include "edac_core.h"
>> +
>> +#define IE31200_REVISION "1.0"
>> +#define EDAC_MOD_STR "ie31200_edac"
>> +
>> +#define PCI_DEVICE_ID_INTEL_IE31200_HB_1 0x0108
>> +#define PCI_DEVICE_ID_INTEL_IE31200_HB_2 0x010c
>> +#define PCI_DEVICE_ID_INTEL_IE31200_HB_3 0x0150
>> +#define PCI_DEVICE_ID_INTEL_IE31200_HB_4 0x0158
>> +#define PCI_DEVICE_ID_INTEL_IE31200_HB_5 0x015c
>> +#define PCI_DEVICE_ID_INTEL_IE31200_HB_6 0x0c04
>> +#define PCI_DEVICE_ID_INTEL_IE31200_HB_7 0x0c08
>> +
>> +#define IE31200_DIMMS                        4
>> +#define IE31200_RANKS                        8
>> +#define IE31200_RANKS_PER_CHANNEL    4
>> +#define IE31200_DIMMS_PER_CHANNEL    2
>> +#define IE31200_CHANNELS             2
>> +
>> +/* Intel IE31200 register addresses - device 0 function 0 - DRAM Controller */
>> +#define IE31200_MCHBAR_LOW   0x48
>> +#define IE31200_MCHBAR_HIGH  0x4c
>> +#define IE31200_MCHBAR_MASK  0xffffff8000ULL /* bits 38:15 */
> 
> GENMASK_ULL()
> 

ok

>> +#define IE31200_MMR_WINDOW_SIZE      32768
> 
> (1 << 15) ?
> 

ok

>> +
>> +/* Error Status Register (16b)
>> + *
>> + * 15    reserved
>> + * 14    Isochronous TBWRR Run Behind FIFO Full
>> + *       (ITCV)
>> + * 13    Isochronous TBWRR Run Behind FIFO Put
>> + *       (ITSTV)
>> + * 12    reserved
>> + * 11    MCH Thermal Sensor Event
>> + *       for SMI/SCI/SERR (GTSE)
>> + * 10    reserved
>> + *  9    LOCK to non-DRAM Memory Flag (LCKF)
>> + *  8    reserved
>> + *  7    DRAM Throttle Flag (DTF)
>> + *  6:2  reserved
>> + *  1    Multi-bit DRAM ECC Error Flag (DMERR)
>> + *  0    Single-bit DRAM ECC Error Flag (DSERR)
>> + */
>> +#define IE31200_ERRSTS               0xc8
>> +#define IE31200_ERRSTS_UE    0x0002
> 
> Let's use the BIT() macro for those:
> 
> BIT(1)
> 
>> +#define IE31200_ERRSTS_CE    0x0001
> 
> BIT(0)
> 

make sense.

>> +#define IE31200_ERRSTS_BITS  (IE31200_ERRSTS_UE | IE31200_ERRSTS_CE)
>> +
>> +/*
>> + * Channel 0 ECC Error Log (64b)
>> + *
>> + * 63:48 Error Column Address (ERRCOL)
>> + * 47:32 Error Row Address (ERRROW)
>> + * 31:29 Error Bank Address (ERRBANK)
>> + * 28:27 Error Rank Address (ERRRANK)
>> + * 26:24 reserved
>> + * 23:16 Error Syndrome (ERRSYND)
>> + * 15: 2 reserved
>> + *    1  Multiple Bit Error Status (MERRSTS)
>> + *    0  Correctable Error Status (CERRSTS)
>> + */
>> +#define IE31200_C0ECCERRLOG                  0x40c8
>> +#define IE31200_C1ECCERRLOG                  0x44c8
>> +#define IE31200_ECCERRLOG_CE                 0x1
>> +#define IE31200_ECCERRLOG_UE                 0x2
> 
> Ditto.
> 
>> +#define IE31200_ECCERRLOG_RANK_BITS          0x18000000
> 
> GENMASK
> 
>> +#define IE31200_ECCERRLOG_RANK_SHIFT         27
>> +#define IE31200_ECCERRLOG_SYNDROME_BITS              0xff0000
> 
> Ditto.
> 

ok.

>> +#define IE31200_ECCERRLOG_SYNDROME_SHIFT     16
>> +#define IE31200_CAPID0                               0xe4
>> +
>> +#define IE31200_MAD_DIMM_0_OFFSET 0x5004
>> +
>> +#define IE31200_PAGES(n) \
>> +     (n << (28 - PAGE_SHIFT))
>> +
>> +struct ie31200_priv {
>> +     void __iomem *window;
>> +};
>> +
>> +static int nr_channels;
>> +
>> +static int how_many_channels(struct pci_dev *pdev)
>> +{
>> +     int n_channels;
>> +     unsigned char capid0_2b; /* 2nd byte of CAPID0 */
>> +
>> +     pci_read_config_byte(pdev, IE31200_CAPID0 + 1, &capid0_2b);
>> +
>> +     /* check PDCD: Dual Channel Disable */
>> +     if (capid0_2b & 0x10) {
> 
> Now that you have nice defines for all those bits, why not do that for
> those naked numbers too? :-)
> 
> Maybe even local to this function:
> 
> #define PDCD    BIT(4)
> 
> 

ok.

>> +             edac_dbg(0, "In single channel mode\n");
>> +             n_channels = 1;
>> +     } else {
>> +             edac_dbg(0, "In dual channel mode\n");
>> +             n_channels = 2;
>> +     }
>> +
>> +     /* check DDPCD - check if both channels are filled */
> 
> Ditto:
> 
> #define DDPCD BIT(6)
> 

ok.

>> +     if (capid0_2b & 0x40)
>> +             edac_dbg(0, "2 DIMMS per channel disabled\n");
>> +     else
>> +             edac_dbg(0, "2 DIMMS per channel enabled\n");
>> +
>> +     return n_channels;
>> +}
>> +
>> +static bool ecc_capable(struct pci_dev *pdev)
>> +{
>> +     unsigned char capid0_4b; /* 4th byte of CAPID0 */
>> +
>> +     pci_read_config_byte(pdev, IE31200_CAPID0 + 3, &capid0_4b);
>> +     if (capid0_4b & 0x2)
> 
> BIT(1) at least, if no define.
> 
>> +             return false;
>> +     return true;
>> +}
>> +
>> +static unsigned long eccerrlog_syndrome(u64 log)
>> +{
>> +     return (log & IE31200_ECCERRLOG_SYNDROME_BITS) >>
>> +             IE31200_ECCERRLOG_SYNDROME_SHIFT;
>> +}
> 
> Looks like this wants to be a macro.
> 
>> +
>> +static int eccerrlog_row(int channel, u64 log)
>> +{
>> +     u64 rank = ((log & IE31200_ECCERRLOG_RANK_BITS) >>
>> +             IE31200_ECCERRLOG_RANK_SHIFT);
>> +     return rank;
>> +}
> 
> Ditto.
> 

ok.

>> +
>> +enum ie31200_chips {
>> +     IE31200 = 0,
>> +};
>> +
>> +struct ie31200_dev_info {
>> +     const char *ctl_name;
>> +};
>> +
>> +struct ie31200_error_info {
>> +     u16 errsts;
>> +     u16 errsts2;
>> +     u64 eccerrlog[IE31200_CHANNELS];
>> +};
>> +
>> +static const struct ie31200_dev_info ie31200_devs[] = {
>> +     [IE31200] = {
>> +             .ctl_name = "IE31200"
>> +     },
>> +};
> 
> Maybe pull those up before the first function definition so that you can
> have all struct definitions together.
> 
>> +
>> +static void ie31200_clear_error_info(struct mem_ctl_info *mci)
>> +{
>> +     struct pci_dev *pdev;
>> +
>> +     pdev = to_pci_dev(mci->pdev);
> 
> Just drop all the local gaming by simply doing:
> 
>         pci_write_bits16(to_pci_dev(mci->pdev), IE31200_ERRSTS,
>                          IE31200_ERRSTS_BITS,
>                          IE31200_ERRSTS_BITS);
> 
>> +
>> +     /*
>> +      * Clear any error bits.
>> +      * (Yes, we really clear bits by writing 1 to them.)
> 
> Yeah, that's that write-to-clear mechanism.
> 
>> +      */
>> +     pci_write_bits16(pdev, IE31200_ERRSTS, IE31200_ERRSTS_BITS,
>> +             IE31200_ERRSTS_BITS);
> 
> Arg alignment.
> 
>> +}
>> +
>> +static void ie31200_get_and_clear_error_info(struct mem_ctl_info *mci,
>> +             struct ie31200_error_info *info)
> 
> Ditto.
> 
>> +{
>> +     struct pci_dev *pdev;
>> +     struct ie31200_priv *priv = mci->pvt_info;
>> +     void __iomem *window = priv->window;
>> +
>> +     pdev = to_pci_dev(mci->pdev);
>> +
>> +     /*
>> +      * This is a mess because there is no atomic way to read all the
>> +      * registers at once and the registers can transition from CE being
>> +      * overwritten by UE.
>> +      */
> 
> For the UE you'd get an MCE, right?
> 

One would think. But I have a system which is:

 Intel(R) Xeon(R) CPU E31270 @ 3.40GHz

and has:

00:00.0 Host bridge: Intel Corporation Device 0108 (rev 09)

And I can regularly generate uncorrected errors, which I see both from the
simple memory scanner I have (which simply compares what it reads to what
it wrote), and as reported by this driver in the 'ue_count'. BUT I don't
see any evidence of MCEs in the logs and the MCE interrupt count in
/proc/interrupts is 0.

> Btw, this driver is polling, AFAICT. Doesn't e3-12xx support the CMCI
> interrupt which you can feed into this driver directly and thus not need
> the polling at all?

On the system with the ce and ue events that I'm testing on, I don't see
'MCE' nudge above 0, in /proc/interrupts. So I think that implies that
we are not getting any CMCI there?

So if possible maybe we can confirm with Intel whether we expect an MCE
for memory errors...

> 
>> +     pci_read_config_word(pdev, IE31200_ERRSTS, &info->errsts);
>> +     if (!(info->errsts & IE31200_ERRSTS_BITS))
>> +             return;
>> +
>> +     info->eccerrlog[0] = lo_hi_readq(window + IE31200_C0ECCERRLOG);
>> +     if (nr_channels == 2)
>> +             info->eccerrlog[1] = lo_hi_readq(window + IE31200_C1ECCERRLOG);
>> +
>> +     pci_read_config_word(pdev, IE31200_ERRSTS, &info->errsts2);
>> +
>> +     /*
>> +      * If the error is the same for both reads then the first set
>> +      * of reads is valid.  If there is a change then there is a CE
>> +      * with no info and the second set of reads is valid and
>> +      * should be UE info.
>> +      */
>> +     if ((info->errsts ^ info->errsts2) & IE31200_ERRSTS_BITS) {
>> +             info->eccerrlog[0] = lo_hi_readq(window + IE31200_C0ECCERRLOG);
>> +             if (nr_channels == 2)
>> +                     info->eccerrlog[1] =
>> +                             lo_hi_readq(window + IE31200_C1ECCERRLOG);
>> +     }
>> +
>> +     ie31200_clear_error_info(mci);
>> +}
>> +
>> +static void ie31200_process_error_info(struct mem_ctl_info *mci,
>> +             struct ie31200_error_info *info)
> 
> arg alignment.
> 

ok.

>> +{
>> +     int channel;
>> +     u64 log;
>> +
>> +     if (!(info->errsts & IE31200_ERRSTS_BITS))
>> +             return;
>> +
>> +     if ((info->errsts ^ info->errsts2) & IE31200_ERRSTS_BITS) {
>> +             edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1, 0, 0, 0,
>> +                                  -1, -1, -1, "UE overwrote CE", "");
>> +             info->errsts = info->errsts2;
>> +     }
>> +
>> +     for (channel = 0; channel < nr_channels; channel++) {
>> +             log = info->eccerrlog[channel];
>> +             if (log & IE31200_ECCERRLOG_UE) {
>> +                     edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1,
>> +                                          0, 0, 0,
>> +                                          eccerrlog_row(channel, log),
>> +                                          channel, -1,
>> +                                          "i3000 UE", "");
>> +             } else if (log & IE31200_ECCERRLOG_CE) {
>> +                     edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 1,
>> +                                          0, 0, eccerrlog_syndrome(log),
>> +                                          eccerrlog_row(channel, log),
>> +                                          channel, -1,
>> +                                          "i3000 CE", "");
>> +             }
>> +     }
>> +}
>> +
>> +static void ie31200_check(struct mem_ctl_info *mci)
>> +{
>> +     struct ie31200_error_info info;
>> +
>> +     edac_dbg(1, "MC%d\n", mci->mc_idx);
>> +     ie31200_get_and_clear_error_info(mci, &info);
>> +     ie31200_process_error_info(mci, &info);
>> +}
>> +
>> +static void __iomem *ie31200_map_mchbar(struct pci_dev *pdev)
>> +{
>> +     union {
>> +             u64 mchbar;
>> +             struct {
>> +                     u32 mchbar_low;
>> +                     u32 mchbar_high;
>> +             };
>> +     } u;
>> +     void __iomem *window;
>> +
>> +     pci_read_config_dword(pdev, IE31200_MCHBAR_LOW, &u.mchbar_low);
>> +     pci_read_config_dword(pdev, IE31200_MCHBAR_HIGH, &u.mchbar_high);
>> +     u.mchbar &= IE31200_MCHBAR_MASK;
>> +
>> +     if (u.mchbar != (resource_size_t)u.mchbar) {
>> +             pr_err("ie31200: mmio space beyond accessible range (0x%llx)\n",
>> +                     (unsigned long long)u.mchbar);
> 
> We have edac_*_printk for those, which takes care of the prefix, etc.
> 
>> +             return NULL;
>> +     }
>> +
>> +     window = ioremap_nocache(u.mchbar, IE31200_MMR_WINDOW_SIZE);
>> +     if (!window)
>> +             pr_err("ie31200: cannot map mmio space at 0x%llx\n",
>> +                     (unsigned long long)u.mchbar);
> 
> Ditto.
> 
>> +
>> +     return window;
>> +}
>> +
>> +struct dimm_data {
>> +     u8 size; /* in 256MB multiples */
>> +     u8 dual_rank : 1,
>> +        x16_width : 1; /* 0 means x8 width */
>> +};
> 
> Also move up to the rest of the struct definitions.
> 

ok.

>> +static int ie31200_probe1(struct pci_dev *pdev, int dev_idx)
>> +{
>> +     int rc;
>> +     int i, j;
>> +     struct mem_ctl_info *mci = NULL;
>> +     struct edac_mc_layer layers[2];
>> +     struct dimm_data dimm_info[IE31200_CHANNELS][IE31200_DIMMS_PER_CHANNEL];
>> +     void __iomem *window;
>> +     struct ie31200_priv *priv;
>> +     u32 addr_decode;
>> +
>> +     edac_dbg(0, "MC:\n");
>> +
>> +     if (!ecc_capable(pdev)) {
>> +             edac_dbg(1, "Not edac capable\n");
> 
> dbg? Why not info? Also, "No ECC support" or somesuch, "edac capable" is funny :-)
> 
>> +             return -ENODEV;
>> +     }
>> +
>> +     window = ie31200_map_mchbar(pdev);
>> +     if (!window)
>> +             return -ENODEV;
>> +
>> +     /* populate DIMM info */
>> +     for (i = 0; i < IE31200_CHANNELS; i++) {
>> +             addr_decode = readl(window + IE31200_MAD_DIMM_0_OFFSET +
>> +                                     (i * 4));
>> +             edac_dbg(0, "addr_decode: 0x%x\n", addr_decode);
>> +             for (j = 0; j < IE31200_DIMMS_PER_CHANNEL; j++) {
>> +                     dimm_info[i][j].size = (addr_decode >> (j * 8)) & 0xff;
>> +                     dimm_info[i][j].dual_rank =
>> +                             (addr_decode & (0x20000 << j)) ? 1 : 0;
>> +                     dimm_info[i][j].x16_width =
>> +                             (addr_decode & (0x80000 << j)) ? 1 : 0;
> 
> #define's for those naked bits?
> 
>> +                     edac_dbg(0, "size: 0x%x, rank: %d, width: %d\n",
>> +                              dimm_info[i][j].size,
>> +                              dimm_info[i][j].dual_rank,
>> +                              dimm_info[i][j].x16_width);
>> +             }
>> +     }
>> +
>> +     nr_channels = how_many_channels(pdev);
>> +
>> +     layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
>> +     layers[0].size = IE31200_DIMMS;
>> +     layers[0].is_virt_csrow = true;
>> +     layers[1].type = EDAC_MC_LAYER_CHANNEL;
>> +     layers[1].size = nr_channels;
>> +     layers[1].is_virt_csrow = false;
>> +     mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers,
>> +                         sizeof(struct ie31200_priv));
>> +
>> +     rc = -ENOMEM;
>> +     if (!mci)
>> +             goto fail_unmap;
>> +
>> +     edac_dbg(3, "MC: init mci\n");
>> +
>> +     mci->pdev = &pdev->dev;
>> +     mci->mtype_cap = MEM_FLAG_DDR3;
>> +
>> +     mci->edac_ctl_cap = EDAC_FLAG_SECDED;
>> +     mci->edac_cap = EDAC_FLAG_SECDED;
>> +
>> +     mci->mod_name = EDAC_MOD_STR;
>> +     mci->mod_ver = IE31200_REVISION;
>> +     mci->ctl_name = ie31200_devs[dev_idx].ctl_name;
>> +     mci->dev_name = pci_name(pdev);
>> +     mci->edac_check = ie31200_check;
>> +     mci->ctl_page_to_phys = NULL;
>> +     priv = mci->pvt_info;
>> +     priv->window = window;
>> +
>> +     /*
>> +      * The dram rank boundary (DRB) reg values are boundary addresses
>> +      * for each DRAM rank with a granularity of 64MB.  DRB regs are
>> +      * cumulative; the last one will contain the total memory
>> +      * contained in all ranks.
>> +      */
>> +     for (i = 0; i < IE31200_DIMMS_PER_CHANNEL; i++) {
>> +             for (j = 0; j < IE31200_CHANNELS; j++) {
>> +                     struct dimm_info *dimm;
>> +                     unsigned long nr_pages;
>> +
>> +                     nr_pages = IE31200_PAGES(dimm_info[j][i].size);
>> +                     if (nr_pages == 0)
>> +                             continue;
>> +
>> +                     if (dimm_info[j][i].dual_rank) {
>> +                             nr_pages = nr_pages / 2;
>> +                             dimm = EDAC_DIMM_PTR(mci->layers, mci->dimms,
>> +                                                  mci->n_layers, (i * 2) + 1,
>> +                                                  j, 0);
>> +                             dimm->nr_pages = nr_pages;
>> +                             edac_dbg(0, "set nr pages: 0x%lx\n", nr_pages);
>> +                             dimm->grain = 8; /* just a guess */
>> +                             dimm->mtype = MEM_DDR3;
>> +                             dimm->dtype = DEV_UNKNOWN;
>> +                             dimm->edac_mode = EDAC_UNKNOWN;
>> +                     }
>> +                     dimm = EDAC_DIMM_PTR(mci->layers, mci->dimms,
>> +                                          mci->n_layers, i * 2, j, 0);
>> +                     dimm->nr_pages = nr_pages;
>> +                     edac_dbg(0, "set nr pages: 0x%lx\n", nr_pages);
>> +                     dimm->grain = 8; /* same guess */
>> +                     dimm->mtype = MEM_DDR3;
>> +                     dimm->dtype = DEV_UNKNOWN;
>> +                     dimm->edac_mode = EDAC_UNKNOWN;
>> +             }
>> +     }
>> +
>> +     ie31200_clear_error_info(mci);
>> +
>> +     rc = -ENODEV;
>> +     if (edac_mc_add_mc(mci)) {
>> +             edac_dbg(3, "MC: failed edac_mc_add_mc()\n");
>> +             goto fail_free;
>> +     }
>> +
>> +     /* get this far and it's successful */
>> +     edac_dbg(3, "MC: success\n");
>> +     return 0;
>> +
>> +fail_free:
>> +     if (mci)
>> +             edac_mc_free(mci);
>> +fail_unmap:
>> +     iounmap(window);
>> +
>> +     return rc;
>> +}
>> +
>> +static int ie31200_init_one(struct pci_dev *pdev,
>> +                         const struct pci_device_id *ent)
>> +{
>> +     int rc;
>> +
>> +     edac_dbg(0, "MC:\n");
>> +
>> +     if (pci_enable_device(pdev) < 0)
>> +             return -EIO;
>> +
>> +     rc = ie31200_probe1(pdev, ent->driver_data);
> 
> return ie31200_probe1(..)
> 
> and kill rc.
> 

I also noticed that some EDAC drivers do a 'pci_dev_get()' in
their 'init_one' function, so I'm not clear if that's needed as well
(I'm hoping the MCH can't be removed at run-time :)).

Thanks for the review.

-Jason
 






