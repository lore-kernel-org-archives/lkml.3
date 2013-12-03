Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab3LCNf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 08:35:27 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:42764 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845Ab3LCNfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 08:35:23 -0500
Subject: Re: [PATCH 1/6] GenWQE PCI support, health monitoring and recovery
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de
In-Reply-To: <20131127191658.GA28409@kroah.com>
References: <1383741943-14609-1-git-send-email-haver@linux.vnet.ibm.com>
	 <1383741943-14609-2-git-send-email-haver@linux.vnet.ibm.com>
	 <20131127191658.GA28409@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Tue, 03 Dec 2013 14:35:17 +0100
Message-ID: <1386077717.12186.7.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120313-8372-0000-0000-000007F6C075
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Am Mittwoch, den 27.11.2013, 11:16 -0800 schrieb Greg KH:
> On Wed, Nov 06, 2013 at 01:45:38PM +0100, Frank Haverkamp wrote:
> > --- /dev/null
> > +++ b/include/linux/genwqe/genwqe_card.h
> > @@ -0,0 +1,547 @@
> > +#ifndef __GENWQE_CARD_H__
> > +#define __GENWQE_CARD_H__
> > +
> > +/**
> > + * IBM Accelerator Family 'GenWQE'
> > + *
> > + * (C) Copyright IBM Corp. 2013
> > + *
> > + * Author: Frank Haverkamp <haver@linux.vnet.ibm.com>
> > + * Author: Joerg-Stephan Vogt <jsvogt@de.ibm.com>
> > + * Author: Michael Jung <mijung@de.ibm.com>
> > + * Author: Michael Ruettger <michael@ibmra.de>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License (version 2 only)
> > + * as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +/*
> > + * User-space API for the GenWQE card. For debugging and test purposes
> > + * the register addresses are included here too.
> > + */
> > +
> > +#ifdef __KERNEL__
> > +#  include <linux/types.h>
> > +#  include <linux/ioctl.h>
> > +#else
> > +#  include <stdint.h>
> > +#  include <asm/ioctl.h>
> > +#  include <stddef.h>
> > +#  include <string.h>
> > +#
> > +#  ifndef __user
> > +#    define __user
> > +#  endif
> > +#endif
> 
> Ick, really?

Yes, looks ugly. I got rid of that.

> 
> Anyway, userspace .h files need to be in include/uapi/, not in
> include/linux/, please split only the userspace side of this file out to
> that directory, the other bits that do not need to go to userspace can
> probably go back down in your local directory, right?

Sure. I moved the file over, found some constants/struct names with
sub-optimal prefixes, and fixed those too.

> 
> > +
> > +/* Basename of sysfs, debugfs and /dev interfaces */
> > +#define GENWQE_DEVNAME "genwqe"
> > +
> > +#define GENWQE_TYPE_ALTERA_230		0x00 /* GenWQE4 Stratix-IV-230 */
> > +#define GENWQE_TYPE_ALTERA_530		0x01 /* GenWQE4 Stratix-IV-530 */
> > +#define GENWQE_TYPE_ALTERA_A4		0x02 /* GenWQE5 A4 Stratix-V-A4 */
> > +#define GENWQE_TYPE_ALTERA_A7		0x03 /* GenWQE5 A7 Stratix-V-A7 */
> > +
> > +/* MMIO Unit offsets: Each UnitID occupies a defined address range */
> > +#define UID_OFFS(uid)			((uid) << 24)
> > +
> > +#define SLU_OFFS			UID_OFFS(0)
> > +#define HSU_OFFS			UID_OFFS(1)
> > +#define APP_OFFS			UID_OFFS(2)
> > +#define MEMC0_OFFS			UID_OFFS(3)
> > +#define MEMC1_OFFS			UID_OFFS(4)
> > +#define ETH0_OFFS			UID_OFFS(5)
> > +#define ETH1_OFFS			UID_OFFS(6)
> > +#define GENWQE_MAX_UNITS		3
> > +
> > +/* Common offsets per UnitID */
> > +#define IO_EXTENDED_ERROR_POINTER	0x00000048
> > +#define IO_ERROR_INJECT_SELECTOR	0x00000060
> > +#define IO_EXTENDED_DIAG_SELECTOR	0x00000070
> > +#define IO_EXTENDED_DIAG_READ_MBX	0x00000078
> > +#define IO_EXTENDED_DIAG_MAP(ring)	(0x00000500 | ((ring) << 3))
> > +
> > +#define EXTENDED_DIAG_SELECTOR(ring, trace) (((ring) << 8) | (trace))
> > +
> > +/* UnitID 0: Service Layer Unit (SLU) */
> > +
> > +/* SLU: Unit Configuration Register */
> > +#define IO_SLU_UNITCFG			0x00000000
> > +#define   SLU_UNITCFG_TYPE_MASK		0x000000000ff00000 /* 27:20 */
> > +
> > +/* SLU: Fault Isolation Register (FIR) (ac_slu_fir) */
> > +#define IO_SLU_FIR			0x00000008 /* read only, wr direct */
> > +#define IO_SLU_FIR_CLR			0x00000010 /* read and clear */
> > +
> > +/* SLU: First Error Capture Register (FEC/WOF) */
> > +#define IO_SLU_FEC			0x00000018
> > +
> > +#define IO_SLU_ERR_ACT_MASK		0x00000020
> > +#define IO_SLU_ERR_ATTN_MASK		0x00000028
> > +#define IO_SLU_FIRX1_ACT_MASK		0x00000030
> > +#define IO_SLU_FIRX0_ACT_MASK		0x00000038
> > +#define IO_SLU_SEC_LEM_DEBUG_OVR	0x00000040
> > +#define IO_SLU_EXTENDED_ERR_PTR		0x00000048
> > +#define IO_SLU_COMMON_CONFIG		0x00000060
> > +
> > +/* SLU: Flash FIR */
> > +#define IO_SLU_FLASH_FIR		0x00000108
> > +
> > +/* SLU: SLC FIR (This section needs to be updated for A5) */
> > +#define IO_SLU_SLC_FIR			0x00000110
> > +
> > +/* SLU: RIU Secondary Trap Register */
> > +#define IO_SLU_RIU_TRAP			0x00000280
> > +
> > +/* SLU: Flash FEC */
> > +#define IO_SLU_FLASH_FEC		0x00000308
> > +
> > +/* SLU: SLC secondary FEC */
> > +#define IO_SLU_SLC_FEC			0x00000310
> > +
> > +#define W1CLR_OFFS			0x00400000
> > +#define W1SET_OFFS			0x00800000
> > +
> > +/*
> > + * The  Virtual Function's Access is from offset 0x00010000
> > + * The Physical Function's Access is from offset 0x00050000
> > + * Single Shared Registers exists only at offset 0x00060000
> > + */
> > +
> > +/*
> > + * SLC: Queue Virtual Window Window for accessing into a specific VF
> > + * queue. When accessing the 0x10000 space using the 0x50000 address
> > + * segment, the value indicated here is used to specify which VF
> > + * register is decoded. This register, and the 0x50000 register space
> > + * can only be accessed by the PF. Example, if this register is set to
> > + * 0x2, then a read from 0x50000 is the same as a read from 0x10000
> > + * from VF=2.
> > + */
> > +
> > +/* SLC: Queue Segment */
> > +#define IO_SLC_QUEUE_SEGMENT		0x00010000
> > +#define IO_SLC_VF_QUEUE_SEGMENT		0x00050000
> > +
> > +/* SLC: Queue Offset */
> > +#define IO_SLC_QUEUE_OFFSET		0x00010008
> > +#define IO_SLC_VF_QUEUE_OFFSET		0x00050008
> > +
> > +/* SLC: Queue Configuration */
> > +#define IO_SLC_QUEUE_CONFIG		0x00010010
> > +#define IO_SLC_VF_QUEUE_CONFIG		0x00050010
> > +
> > +/* SLC: Job Timout/Only accessible for the PF */
> > +#define IO_SLC_APPJOB_TIMEOUT		0x00010018
> > +#define IO_SLC_VF_APPJOB_TIMEOUT	0x00050018
> > +#define TIMEOUT_250MS			0x0000000full
> > +#define HEARTBEAT_DISABLE		0x0000ff00ull
> > +
> > +/* SLC: Queue InitSequence Register */
> > +#define	IO_SLC_QUEUE_INITSQN		0x00010020
> > +#define	IO_SLC_VF_QUEUE_INITSQN		0x00050020
> > +
> > +/* SLC: Queue Wrap */
> > +#define IO_SLC_QUEUE_WRAP		0x00010028
> > +#define IO_SLC_VF_QUEUE_WRAP		0x00050028
> > +
> > +/* SLC: Queue Status */
> > +#define IO_SLC_QUEUE_STATUS		0x00010100
> > +#define IO_SLC_VF_QUEUE_STATUS		0x00050100
> > +
> > +/* SLC: Queue Working Time */
> > +#define IO_SLC_QUEUE_WTIME		0x00010030
> > +#define IO_SLC_VF_QUEUE_WTIME		0x00050030
> > +
> > +/* SLC: Queue Error Counts */
> > +#define IO_SLC_QUEUE_ERRCNTS		0x00010038
> > +#define IO_SLC_VF_QUEUE_ERRCNTS		0x00050038
> > +
> > +/* SLC: Queue Loast Response Word */
> > +#define IO_SLC_QUEUE_LRW		0x00010040
> > +#define IO_SLC_VF_QUEUE_LRW		0x00050040
> > +
> > +/* SLC: Freerunning Timer */
> > +#define IO_SLC_FREE_RUNNING_TIMER	0x00010108
> > +#define IO_SLC_VF_FREE_RUNNING_TIMER	0x00050108
> > +
> > +/* SLC: Queue Virtual Access Region */
> > +#define IO_PF_SLC_VIRTUAL_REGION	0x00050000
> > +
> > +/* SLC: Queue Virtual Window */
> > +#define IO_PF_SLC_VIRTUAL_WINDOW	0x00060000
> > +
> > +/* SLC: DDCB Application Job Pending [n] (n=0:63) */
> > +#define IO_PF_SLC_JOBPEND(n)		(0x00061000 + 8*(n))
> > +#define IO_SLC_JOBPEND(n)		IO_PF_SLC_JOBPEND(n)
> > +
> > +/* SLC: Parser Trap RAM [n] (n=0:31) */
> > +#define IO_SLU_SLC_PARSE_TRAP(n)	(0x00011000 + 8*(n))
> > +
> > +/* SLC: Dispatcher Trap RAM [n] (n=0:31) */
> > +#define IO_SLU_SLC_DISP_TRAP(n)	(0x00011200 + 8*(n))
> > +
> > +/* Global Fault Isolation Register (GFIR) */
> > +#define IO_SLC_CFGREG_GFIR		0x00020000
> > +#define GFIR_ERR_TRIGGER		0x000000000000ffffull
> > +
> > +/* SLU: Soft Reset Register */
> > +#define IO_SLC_CFGREG_SOFTRESET		0x00020018
> > +
> > +/* SLU: Misc Debug Register */
> > +#define IO_SLC_MISC_DEBUG		0x00020060
> > +#define IO_SLC_MISC_DEBUG_CLR		0x00020068
> > +#define IO_SLC_MISC_DEBUG_SET		0x00020070
> > +
> > +/* Temperature Sensor Reading */
> > +#define IO_SLU_TEMPERATURE_SENSOR	0x00030000
> > +#define IO_SLU_TEMPERATURE_CONFIG	0x00030008
> > +
> > +/* Voltage Margining Control */
> > +#define IO_SLU_VOLTAGE_CONTROL		0x00030080
> > +#define VOLTAGE_NOMINAL			0x00000000ull
> > +#define VOLTAGE_DOWN5			0x00000006ull
> > +#define VOLTAGE_UP5			0x00000007ull
> > +
> > +/* Direct LED Control Register */
> > +#define IO_SLU_LEDCONTROL		0x00030100
> > +
> > +/* SLU: Flashbus Direct Access -A5 */
> > +#define IO_SLU_FLASH_DIRECTACCESS	0x00040010
> > +
> > +/* SLU: Flashbus Direct Access2 -A5 */
> > +#define IO_SLU_FLASH_DIRECTACCESS2	0x00040020
> > +
> > +/* SLU: Flashbus Command Interface -A5 */
> > +#define IO_SLU_FLASH_CMDINTF		0x00040030
> > +
> > +/* SLU: BitStream Loaded */
> > +#define IO_SLU_BITSTREAM		0x00040040
> > +
> > +/* This Register has a switch which will change the CAs to UR */
> > +#define IO_HSU_ERR_BEHAVIOR		0x01001010
> > +
> > +#define IO_SLC2_SQB_TRAP		0x00062000
> > +#define IO_SLC2_QUEUE_MANAGER_TRAP	0x00062008
> > +#define IO_SLC2_FLS_MASTER_TRAP		0x00062010
> > +
> > +/* UnitID 1: HSU Registers */
> > +#define IO_HSU_UNITCFG			0x01000000
> > +#define IO_HSU_FIR			0x01000008
> > +#define IO_HSU_FIR_CLR			0x01000010
> > +#define IO_HSU_FEC			0x01000018
> > +#define IO_HSU_ERR_ACT_MASK		0x01000020
> > +#define IO_HSU_ERR_ATTN_MASK		0x01000028
> > +#define IO_HSU_FIRX1_ACT_MASK		0x01000030
> > +#define IO_HSU_FIRX0_ACT_MASK		0x01000038
> > +#define IO_HSU_SEC_LEM_DEBUG_OVR	0x01000040
> > +#define IO_HSU_EXTENDED_ERR_PTR		0x01000048
> > +#define IO_HSU_COMMON_CONFIG		0x01000060
> > +
> > +/* UnitID 2: Application Unit (APP) */
> > +#define IO_APP_UNITCFG			0x02000000
> > +#define IO_APP_FIR			0x02000008
> > +#define IO_APP_FIR_CLR			0x02000010
> > +#define IO_APP_FEC			0x02000018
> > +#define IO_APP_ERR_ACT_MASK		0x02000020
> > +#define IO_APP_ERR_ATTN_MASK		0x02000028
> > +#define IO_APP_FIRX1_ACT_MASK		0x02000030
> > +#define IO_APP_FIRX0_ACT_MASK		0x02000038
> > +#define IO_APP_SEC_LEM_DEBUG_OVR	0x02000040
> > +#define IO_APP_EXTENDED_ERR_PTR		0x02000048
> > +#define IO_APP_COMMON_CONFIG		0x02000060
> > +
> > +#define IO_APP_DEBUG_REG_01		0x02010000
> > +#define IO_APP_DEBUG_REG_02		0x02010008
> > +#define IO_APP_DEBUG_REG_03		0x02010010
> > +#define IO_APP_DEBUG_REG_04		0x02010018
> > +#define IO_APP_DEBUG_REG_05		0x02010020
> > +#define IO_APP_DEBUG_REG_06		0x02010028
> > +#define IO_APP_DEBUG_REG_07		0x02010030
> > +#define IO_APP_DEBUG_REG_08		0x02010038
> > +#define IO_APP_DEBUG_REG_09		0x02010040
> > +#define IO_APP_DEBUG_REG_10		0x02010048
> > +#define IO_APP_DEBUG_REG_11		0x02010050
> > +#define IO_APP_DEBUG_REG_12		0x02010058
> > +#define IO_APP_DEBUG_REG_13		0x02010060
> > +#define IO_APP_DEBUG_REG_14		0x02010068
> > +#define IO_APP_DEBUG_REG_15		0x02010070
> > +#define IO_APP_DEBUG_REG_16		0x02010078
> > +#define IO_APP_DEBUG_REG_17		0x02010080
> > +#define IO_APP_DEBUG_REG_18		0x02010088
> > +
> > +/* Read/write from/to registers */
> > +struct regs_io {
> > +	uint32_t num;		/* register offset/address */
> > +	union {
> > +		uint64_t val64;
> > +		uint32_t val32;
> > +		uint16_t define;
> > +	};
> > +};
> 
> For all of your userspace structures, they need to use proper variable
> types.  For a unsigned 32 bit number, that would be __u32.  Please fix
> up all of your structures for that.

Fixed them.

> 
> Also, have you properly audited the structures for 32bit user / 64bit
> kernel issues?

As you point out below, I failed doing so ;-).

> 
> > +/* common struct for chip image exchange */
> > +struct chip_bitstream {
> > +	uint8_t __user *pdata;		/* pointer to image data     */
> > +	int	 size;			/* size of image file	     */
> 
> I think this fails the 32/64bit issue, right?

Yes. I replaced those by something like
   __u32 data_addr;
I hope that is fixing the 32/64bit issue.

> thanks,
> 
> greg k-h
> 

Thanks

Frank

