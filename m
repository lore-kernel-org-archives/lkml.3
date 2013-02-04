Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345Ab3BDRjL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 12:39:11 -0500
Received: from smtp2.macqel.be ([194.78.208.39]:14779 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753576Ab3BDRjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 12:39:08 -0500
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org
Cc: Philippe De Muyter <phdm@macqel.be>, Greg Ungerer <gerg@snapgear.com>,
        Stany MARCEL <smarcel@pactenovation.fr>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH resent] dma: add the freescale-provided MultiChannel DMA driver
Date: Mon,  4 Feb 2013 18:38:23 +0100
Message-Id: <1359999503-29215-1-git-send-email-phdm@macqel.be>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the (cleaned-up) Freescale-provided MultiChannel DMA
driver for ColdFire M54xx and MPC8220 processors.

This driver is needed for the ethernet FEC driver of the ColdFire
M547x and M548x processors.

It is not dmaengine-enabled, but that's not needed for the above FEC driver.
I have however installed it in the driver/dma tree as this IP block is not
m68k-specific, but freescale-specific, and shared at least between powerpc
and coldfire parts (possibly arm-parts as well).

The installation in drivers/dma implies a small rule change in
drivers/Makefile to enter drivers/dma on CONFIG_DMADEVICES instead
of CONFIG_DMAENGINE.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Cc: Greg Ungerer <gerg@snapgear.com>
Cc: Stany MARCEL <smarcel@pactenovation.fr>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/m68k/Kconfig.cpu                   |    2 +
 drivers/Makefile                        |    2 +-
 drivers/dma/Kconfig                     |    9 +
 drivers/dma/Makefile                    |    1 +
 drivers/dma/fsl_mcd_dma/MCD_dmaApi.c    |  963 ++++++++++++
 drivers/dma/fsl_mcd_dma/MCD_tasks.c     | 2425 +++++++++++++++++++++++++++++++
 drivers/dma/fsl_mcd_dma/MCD_tasksInit.c |  274 ++++
 drivers/dma/fsl_mcd_dma/MCD_tasksInit.h |   76 +
 drivers/dma/fsl_mcd_dma/Makefile        |    1 +
 include/linux/MCD_dma.h                 |  376 +++++
 10 files changed, 4128 insertions(+), 1 deletions(-)
 create mode 100644 drivers/dma/fsl_mcd_dma/MCD_dmaApi.c
 create mode 100644 drivers/dma/fsl_mcd_dma/MCD_tasks.c
 create mode 100644 drivers/dma/fsl_mcd_dma/MCD_tasksInit.c
 create mode 100644 drivers/dma/fsl_mcd_dma/MCD_tasksInit.h
 create mode 100644 drivers/dma/fsl_mcd_dma/Makefile
 create mode 100644 include/linux/MCD_dma.h

diff --git a/arch/m68k/Kconfig.cpu b/arch/m68k/Kconfig.cpu
index b1cfff8..721d64c 100644
--- a/arch/m68k/Kconfig.cpu
+++ b/arch/m68k/Kconfig.cpu
@@ -242,6 +242,8 @@ config M5407
 
 config M54xx
 	bool
+	select HAS_DMA
+	select DMADEVICES
 
 config M547x
 	bool "MCF547x"
diff --git a/drivers/Makefile b/drivers/Makefile
index 7863b9f..d8372ab 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -29,7 +29,7 @@ obj-$(CONFIG_PNP)		+= pnp/
 obj-y				+= amba/
 # Many drivers will want to use DMA so this has to be made available
 # really early.
-obj-$(CONFIG_DMA_ENGINE)	+= dma/
+obj-$(CONFIG_DMADEVICES)	+= dma/
 
 obj-$(CONFIG_VIRTIO)		+= virtio/
 obj-$(CONFIG_XEN)		+= xen/
diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index d4c1218..4e25f5a 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -118,6 +118,15 @@ config FSL_DMA
 	  The Elo is the DMA controller on some 82xx and 83xx parts, and the
 	  Elo Plus is the DMA controller on 85xx and 86xx parts.
 
+config FSL_MCD_DMA
+	bool "Freescale MultiChannel DMA (MCD) support"
+	depends on PPC_MPC8220 || M54xx
+	---help---
+	  This enables generic support for the Freescale MultiChannel DMA (MCD)
+	  available on MPC8220 and ColdFire 547x/548x family.
+	  This driver is used by the specific dma driver for the target CPU.
+	  Some drivers, especially the FEC DMA driver, need it.
+
 config MPC512X_DMA
 	tristate "Freescale MPC512x built-in DMA engine support"
 	depends on PPC_MPC512x || PPC_MPC831x
diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
index 7428fea..6b1e42d 100644
--- a/drivers/dma/Makefile
+++ b/drivers/dma/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_DMATEST) += dmatest.o
 obj-$(CONFIG_INTEL_IOATDMA) += ioat/
 obj-$(CONFIG_INTEL_IOP_ADMA) += iop-adma.o
 obj-$(CONFIG_FSL_DMA) += fsldma.o
+obj-$(CONFIG_FSL_MCD_DMA) += fsl_mcd_dma/
 obj-$(CONFIG_MPC512X_DMA) += mpc512x_dma.o
 obj-$(CONFIG_MV_XOR) += mv_xor.o
 obj-$(CONFIG_DW_DMAC) += dw_dmac.o
diff --git a/drivers/dma/fsl_mcd_dma/MCD_dmaApi.c b/drivers/dma/fsl_mcd_dma/MCD_dmaApi.c
new file mode 100644
index 0000000..06606a0
--- /dev/null
+++ b/drivers/dma/fsl_mcd_dma/MCD_dmaApi.c
@@ -0,0 +1,963 @@
+/*
+ * drivers/dma/MCD_dmaApi.c
+ *
+ * Copyright (C) 2004-2008 Freescale Semiconductor, Inc.
+ *     Kurt Mahan <kmahan@freescale.com>
+ * readl/writel conversion and other cleanup
+ * (C) Copyright 2010-2012 Philippe De Muyter <phdm@macqel.be> Macq SA
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+ * MA 02111-1307 USA
+ */
+
+#include <linux/MCD_dma.h>
+#include <linux/io.h>
+#include "MCD_tasksInit.h"
+
+/********************************************************************/
+/*
+ * This is an API-internal pointer to the DMA's registers
+ */
+struct dmaRegs *MCD_dmaBar;
+
+/*
+ * MCD_realTaskTableSrc & MCD_modelTaskTableSrc get relocated to on-chip
+ * SRAM, at which point we access them as these tables
+ */
+struct TaskTableEntry *MCD_taskTable;
+struct TaskTableEntry *MCD_modelTaskTable;
+
+
+/*
+ * MCD_chStatus[] is an array of status indicators for remembering
+ * whether a DMA has ever been attempted on each channel, pausing
+ * status, etc.
+ */
+static int MCD_chStatus[NCHANNELS] = {
+	MCD_NO_DMA, MCD_NO_DMA, MCD_NO_DMA, MCD_NO_DMA,
+	MCD_NO_DMA, MCD_NO_DMA, MCD_NO_DMA, MCD_NO_DMA,
+	MCD_NO_DMA, MCD_NO_DMA, MCD_NO_DMA, MCD_NO_DMA,
+	MCD_NO_DMA, MCD_NO_DMA, MCD_NO_DMA, MCD_NO_DMA
+};
+
+/*
+ * Prototypes for local functions
+ */
+static void MCD_memcpy(int *dest, int *src, u32 size);
+static void MCD_resmActions(int channel);
+
+/*
+ * Buffer descriptors used for storage of progress info for single Dmas
+ * Also used as storage for the DMA for CRCs for single DMAs
+ * Otherwise, the DMA does not parse these buffer descriptors
+ */
+#ifndef MCD_INCLUDE_EU
+struct MCD_bufDesc MCD_singleBufDescs[NCHANNELS];
+#endif
+struct MCD_bufDesc *MCD_relocBuffDesc;
+
+
+/*
+ * Defines for the debug control register's functions
+ */
+#define DBG_CTL_COMP1_TASK  (0x00002000) /* have comparator 1 look for a task # */
+#define DBG_CTL_ENABLE      (DBG_CTL_AUTO_ARM    | \
+			     DBG_CTL_BREAK       | \
+			     DBG_CTL_INT_BREAK   | \
+			     DBG_CTL_COMP1_TASK)
+#define DBG_CTL_DISABLE     (DBG_CTL_AUTO_ARM    | \
+			     DBG_CTL_INT_BREAK   | \
+			     DBG_CTL_COMP1_TASK)
+#define DBG_KILL_ALL_STAT   (0xFFFFFFFF)
+
+/*
+ * Offset to context save area where progress info is stored
+ */
+#define CSAVE_OFFSET        10
+#define CURRBD ((CSAVE_OFFSET + 4) * 4)
+#define DCOUNT ((CSAVE_OFFSET + 6) * 4)
+#define DESTPTR ((CSAVE_OFFSET + 5) * 4)
+#define SRCPTR ((CSAVE_OFFSET + 7) * 4)
+
+/*
+ * Defines for Byte Swapping
+ */
+#define MCD_BYTE_SWAP_KILLER    0xFFF8888F
+#define MCD_NO_BYTE_SWAP_ATALL  0x00040000
+
+/*
+ * Execution Unit Identifiers
+ */
+#define MAC  0  /* legacy - not used */
+#define LUAC 1  /* legacy - not used */
+#define CRC  2  /* legacy - not used */
+#define LURC 3  /* Logic Unit with CRC */
+
+/*
+ * Task Identifiers
+ */
+#define TASK_CHAINNOEU  0
+#define TASK_SINGLENOEU 1
+#ifdef MCD_INCLUDE_EU
+#define TASK_CHAINEU    2
+#define TASK_SINGLEEU   3
+#define TASK_FECRX      4
+#define TASK_FECTX      5
+#else
+#define TASK_CHAINEU    0
+#define TASK_SINGLEEU   1
+#define TASK_FECRX      2
+#define TASK_FECTX      3
+#endif
+
+/*
+ * Structure to remember which variant is on which channel
+ */
+struct MCD_remVariants {
+	int remDestRsdIncr;  /* -1,0,1 */
+	int remSrcRsdIncr;   /* -1,0,1 */
+	s16 remDestIncr;     /* DestIncr */
+	s16 remSrcIncr;      /* srcIncr */
+	u32 remXferSize;     /* xferSize */
+};
+
+/*
+ * Structure to remember the startDma parameters for each channel
+ */
+struct MCD_remVariants MCD_remVariants[NCHANNELS];
+
+/********************************************************************/
+/*
+ * Function: MCD_initDma
+ * Purpose:  Initializes the DMA API by setting up a pointer to the DMA
+ *           registers, relocating and creating the appropriate task
+ *           structures, and setting up some global settings
+ * Arguments:
+ *  dmaBarAddr    - pointer to the multichannel DMA registers
+ *  taskTableDest - location to move DMA task code and structs to
+ *  flags         - operational parameters
+ * Return Value:
+ *  MCD_TABLE_UNALIGNED if taskTableDest is not 512-byte aligned
+ *  MCD_OK otherwise
+ */
+
+int MCD_initDma(struct dmaRegs *dmaBarAddr, void *taskTableDest, u32 flags)
+{
+	int i;
+	struct TaskTableEntry *entryPtr, *tte;
+	u16 control;
+
+	/* Setup the local pointer to register set */
+	MCD_dmaBar = dmaBarAddr;
+
+	/* Do we need to move/create a task table */
+	if ((flags & MCD_RELOC_TASKS) != 0) {
+		int fixedSize;
+		u32 *fixedPtr;
+		int varTabsOffset, funcDescTabsOffset, contextSavesOffset;
+		int taskDescTabsOffset;
+		int varTabsSize, funcDescTabsSize, contextSavesSize;
+		int taskTableSize, taskDescTabSize;
+
+		int i;
+
+		/* Check if physical address is aligned on 512 byte boundary */
+		if (((u32)taskTableDest & 0x000001ff) != 0)
+			return MCD_TABLE_UNALIGNED;
+
+		/* set up local pointer to task Table */
+		MCD_taskTable = taskTableDest;
+
+		/*
+		 * Create a task table:
+		 * - compute aligned base offsets for variable tables and
+		 *   function descriptor tables, then
+		 * - loop through the task table and setup the pointers
+		 * - copy over model task table with the the actual task
+		 *   descriptor tables
+		 */
+		taskTableSize = NCHANNELS * sizeof(struct TaskTableEntry);
+		/* Align variable tables to size */
+		varTabsOffset = taskTableSize + (u32)taskTableDest;
+		varTabsOffset = ALIGN(varTabsOffset, VAR_TAB_SIZE);
+		/* Align function descriptor tables */
+		varTabsSize = NCHANNELS * VAR_TAB_SIZE;
+		funcDescTabsOffset = varTabsOffset + varTabsSize;
+		funcDescTabsOffset = ALIGN(funcDescTabsOffset, FUNCDESC_TAB_SIZE);
+
+		funcDescTabsSize = FUNCDESC_TAB_NUM * FUNCDESC_TAB_SIZE;
+		contextSavesOffset = funcDescTabsOffset + funcDescTabsSize;
+		contextSavesSize = (NCHANNELS * CONTEXT_SAVE_SIZE);
+		fixedSize = taskTableSize + varTabsSize + funcDescTabsSize +
+			    contextSavesSize;
+
+		/* Zero the thing out */
+		fixedPtr = (u32 *)taskTableDest;
+		for (i = 0; i < (fixedSize/4); i++)
+			fixedPtr[i] = 0;
+
+		entryPtr = (struct TaskTableEntry *)MCD_taskTable;
+		/* Set up fixed pointers */
+		for (i = 0; i < NCHANNELS; i++) {
+			tte = &entryPtr[i];
+			tte->varTab = (u32)varTabsOffset; /* update ptr to local value */
+			tte->FDTandFlags = (u32)funcDescTabsOffset | MCD_TT_FLAGS_DEF;
+			tte->contextSaveSpace = (u32)contextSavesOffset;
+			varTabsOffset += VAR_TAB_SIZE;
+#ifdef MCD_INCLUDE_EU /* if not there is only one, just point to the same one */
+			funcDescTabsOffset += FUNCDESC_TAB_SIZE;
+#endif
+			contextSavesOffset += CONTEXT_SAVE_SIZE;
+		}
+		/* Copy over the function descriptor table */
+		for (i = 0; i < FUNCDESC_TAB_NUM; i++) {
+			tte = &entryPtr[i];
+			MCD_memcpy((void *)(tte->FDTandFlags & ~MCD_TT_FLAGS_MASK),
+				   (void *)MCD_funcDescTab0, FUNCDESC_TAB_SIZE);
+		}
+
+		/* Copy model task table to where the context save stuff leaves off */
+		MCD_modelTaskTable = (struct TaskTableEntry *)contextSavesOffset;
+
+		MCD_memcpy((void *)MCD_modelTaskTable, (void *)MCD_modelTaskTableSrc,
+			    NUMOFVARIANTS * sizeof(struct TaskTableEntry));
+
+		/* Point to local version of model task table */
+		entryPtr = MCD_modelTaskTable;
+		taskDescTabsOffset = (u32)MCD_modelTaskTable +
+				    (NUMOFVARIANTS * sizeof(struct TaskTableEntry));
+
+		/* Copy actual task code and update TDT ptrs in local model task table */
+		for (i = 0; i < NUMOFVARIANTS; i++) {
+			tte = &entryPtr[i];
+			taskDescTabSize = tte->TDTend - tte->TDTstart + 4;
+			MCD_memcpy((void *)taskDescTabsOffset, (void *)tte->TDTstart, taskDescTabSize);
+			tte->TDTstart = (u32)taskDescTabsOffset;
+			taskDescTabsOffset += taskDescTabSize;
+			tte->TDTend = (u32)taskDescTabsOffset - 4;
+		}
+#ifdef MCD_INCLUDE_EU
+		/*
+		 * Tack single DMA BDs onto end of code so API controls where
+		 * they are since DMA might write to them
+		 */
+		MCD_relocBuffDesc = (struct MCD_bufDesc *)(entryPtr[NUMOFVARIANTS - 1].TDTend + 4);
+#else
+		/*
+		 * DMA does not touch them so they can be wherever and we don't
+		 * need to waste SRAM on them
+		 */
+		MCD_relocBuffDesc = MCD_singleBufDescs;
+#endif
+	} else {
+		/*
+		 * Point the would-be relocated task tables and the buffer
+		 * descriptors to the ones the linker generated
+		 */
+		if (((u32)MCD_realTaskTableSrc & 0x000001ff) != 0)
+			return MCD_TABLE_UNALIGNED;
+
+		entryPtr = (struct TaskTableEntry *)MCD_realTaskTableSrc;
+		for (i = 0; i < NCHANNELS; i++) {
+			tte = &entryPtr[i];
+			if (((tte->varTab & (VAR_TAB_SIZE - 1)) != 0) ||
+			   ((tte->FDTandFlags & (FUNCDESC_TAB_SIZE - 1)) != 0))
+				return MCD_TABLE_UNALIGNED;
+		}
+
+		MCD_taskTable = (struct TaskTableEntry *)MCD_realTaskTableSrc;
+		MCD_modelTaskTable = (struct TaskTableEntry *)MCD_modelTaskTableSrc;
+		MCD_relocBuffDesc = MCD_singleBufDescs;
+	}
+
+	/* Make all channels inactive, and remember them as such: */
+	writel((u32) MCD_taskTable, &MCD_dmaBar->taskbar);
+	for (i = 0;  i < NCHANNELS;  i++) {
+		writew(0x0, &MCD_dmaBar->taskControl[i]);
+		MCD_chStatus[i] = MCD_NO_DMA;
+	}
+
+	/* Set up pausing mechanism to inactive state: */
+	writel(0, &MCD_dmaBar->debugComp1);
+	writel(0, &MCD_dmaBar->debugComp2);
+	writel(DBG_CTL_DISABLE, &MCD_dmaBar->debugControl);
+	writel(DBG_KILL_ALL_STAT, &MCD_dmaBar->debugStatus);
+
+	/* Enable or disable commbus prefetch */
+	control = readw(&MCD_dmaBar->ptdControl);
+	if ((flags & MCD_COMM_PREFETCH_EN) != 0)
+		control &= ~PTD_CTL_COMM_PREFETCH;
+	else
+		control |= PTD_CTL_COMM_PREFETCH;
+	writew(control, &MCD_dmaBar->ptdControl);
+
+	return MCD_OK;
+}
+/*********************** End of MCD_initDma() ***********************/
+
+/********************************************************************/
+/* Function:   MCD_dmaStatus
+ * Purpose:    Returns the status of the DMA on the requested channel
+ * Arguments:  channel - channel number
+ * Returns:    Predefined status indicators
+ */
+int MCD_dmaStatus(int channel)
+{
+	u16 tcrValue;
+
+	if ((channel < 0) || (channel >= NCHANNELS))
+		return MCD_CHANNEL_INVALID;
+
+	tcrValue = readw(&MCD_dmaBar->taskControl[channel]);
+	if ((tcrValue & TASK_CTL_EN) == 0) {
+		/* Nothing running if last reported with task enabled */
+		if (MCD_chStatus[channel] == MCD_RUNNING
+			|| MCD_chStatus[channel] == MCD_IDLE)
+			MCD_chStatus[channel] = MCD_DONE;
+		} else { /* something is running */
+		/* There are three possibilities: paused, running or idle. */
+		if (MCD_chStatus[channel] == MCD_RUNNING
+		    || MCD_chStatus[channel] == MCD_IDLE) {
+			writel(PTD_DBG_TSK_VLD_INIT, &MCD_dmaBar->ptdDebug);
+			/* Determine which initiator is asserted. */
+			if ((readl(&MCD_dmaBar->ptdDebug) >> channel) & 0x1)
+				MCD_chStatus[channel] = MCD_RUNNING;
+			else
+				MCD_chStatus[channel] = MCD_IDLE;
+			/* Do not change the status if it is already paused */
+		}
+	}
+	return MCD_chStatus[channel];
+}
+/******************** End of MCD_dmaStatus() ************************/
+
+/********************************************************************/
+/* Function:    MCD_startDma
+ * Ppurpose:    Starts a particular kind of DMA
+ * Arguments:   see below
+ * Returns:     MCD_CHANNEL_INVALID if channel is invalid, else MCD_OK
+ */
+
+int MCD_startDma(
+	const int  channel,   /* the channel on which to run the DMA */
+	s8   *srcAddr,  /* the address to move data from, or physical buffer-descriptor address */
+	s16  srcIncr,   /* the amount to increment the source address per transfer */
+	s8   *destAddr, /* the address to move data to */
+	s16  destIncr,  /* the amount to increment the destination address per transfer */
+	u32  dmaSize,   /* the number of bytes to transfer independent of the transfer size */
+	u32  xferSize,  /* the number bytes in of each data movement (1, 2, or 4) */
+	u32  initiator, /* what device initiates the DMA */
+	int  priority,  /* priority of the DMA */
+	u32  flags,     /* flags describing the DMA */
+	u32  funcDesc   /* a description of byte swapping, bit swapping, and CRC actions */
+#ifdef MCD_NEED_ADDR_TRANS
+	s8   *srcAddrVirt /* virtual buffer descriptor address TBD */
+#endif
+)
+{
+	int srcRsdIncr, destRsdIncr;
+	int *cSave;
+	short xferSizeIncr;
+	int tcrCount = 0;
+#ifdef MCD_INCLUDE_EU
+	u32 *realFuncArray;
+#endif
+	u16 control;
+	struct MCD_remVariants *var;
+	struct TaskTableEntry *tte;
+	u32 css;
+	struct TaskTableEntry *mmte;
+
+	if ((channel < 0) || (channel >= NCHANNELS))
+		return MCD_CHANNEL_INVALID;
+
+#ifndef MCD_INCLUDE_EU
+	funcDesc = MCD_FUNC_NOEU1;
+#endif
+
+#ifdef MCD_DEBUG
+printf("startDma:Setting up params\n");
+#endif
+
+	/* Enable task-wise priority */
+	control = readl(&MCD_dmaBar->ptdControl);
+	writel(control | 0x8000, &MCD_dmaBar->ptdControl);
+
+	/* Calculate additional parameters to the regular DMA calls. */
+	srcRsdIncr = srcIncr < 0 ? -1 : (srcIncr > 0 ? 1 : 0);
+	destRsdIncr = destIncr < 0 ? -1 : (destIncr > 0 ? 1 : 0);
+	xferSizeIncr = (xferSize & 0xffff) | 0x20000000;
+
+	/* Remember which variant is running for each channel */
+	var = &MCD_remVariants[channel];
+	var->remSrcRsdIncr = srcRsdIncr;
+	var->remDestRsdIncr = destRsdIncr;
+	var->remDestIncr = destIncr;
+	var->remSrcIncr = srcIncr;
+	var->remXferSize = xferSize;
+
+	tte = &MCD_taskTable[channel];
+
+	cSave = (int *)(tte->contextSaveSpace + CURRBD);
+
+#ifdef MCD_INCLUDE_EU
+	realFuncArray = (u32 *) (tte->FDTandFlags & 0xffffff00);
+
+	/*
+	* Modify the LURC's normal and byte-residue-loop functions
+	* according to parameter.
+	*/
+	switch (xferSize) {
+	case 4:
+		realFuncArray[(LURC*16)] = funcDesc;
+		break;
+	case 2:
+		realFuncArray[(LURC*16)] = funcDesc & 0xfffff00f;
+		break;
+	case 1:
+	default:
+		realFuncArray[(LURC*16)] = funcDesc & 0xffff000f;
+		break;
+	}
+
+	realFuncArray[(LURC*16+1)] = 0
+		| (funcDesc & MCD_BYTE_SWAP_KILLER)
+		| MCD_NO_BYTE_SWAP_ATALL;
+#endif
+
+	/* Write the initiator field in the TCR and set the initiator-hold bit */
+	writew(0
+		| (initiator << 8)
+		| TASK_CTL_HIPRITSKEN
+		| TASK_CTL_HLDINITNUM,
+		&MCD_dmaBar->taskControl[channel]);
+
+	/*
+	 * Current versions of the MPC8220 MCD have a hardware quirk that could
+	 * cause the write to the TCR to collide with an MDE access to the
+	 * initiator-register file, so we have to verify that the write occurred
+	 * correctly by reading back the value.  On MCF547x/8x devices and any
+	 * future revisions of the MPC8220, this loop will not be entered.
+	 */
+	while (((readw(&MCD_dmaBar->taskControl[channel]) & 0x1fff) !=
+	  ((initiator << 8) | TASK_CTL_HIPRITSKEN | TASK_CTL_HLDINITNUM)) &&
+	    (tcrCount < 1000)) {
+		tcrCount++;
+		writew(0
+		    | (initiator << 8)
+		    | TASK_CTL_HIPRITSKEN
+		    | TASK_CTL_HLDINITNUM,
+			&MCD_dmaBar->taskControl[channel]);
+	}
+
+	writeb(priority & PRIORITY_PRI_MASK, &MCD_dmaBar->priority[channel]);
+
+	if (channel < 8 && channel >= 0) {
+		u32 tasksize = readl(&MCD_dmaBar->taskSize0);
+		int shift = (7 - channel) * 4;
+		u32 xfermask;
+
+		tasksize &= ~(0xf << shift);
+		xfermask = xferSize & 3;
+		xfermask |= xfermask << 2;
+		tasksize |= xfermask << shift;
+		writel(tasksize, &MCD_dmaBar->taskSize0);
+	} else {
+		u32 tasksize = readl(&MCD_dmaBar->taskSize1);
+		int shift = (15 - channel) * 4;
+		u32 xfermask;
+
+		tasksize &= ~(0xf << shift);
+		xfermask = xferSize & 3;
+		xfermask |= xfermask << 2;
+		tasksize |= xfermask << shift;
+		writel(tasksize, &MCD_dmaBar->taskSize1);
+	}
+
+	/* Setup task table flags/options */
+	tte->FDTandFlags &= ~MCD_TT_FLAGS_MASK;
+	tte->FDTandFlags |= (MCD_TT_FLAGS_MASK & flags);
+
+	if (flags & MCD_FECTX_DMA) {
+		/* TDTStart and TDTEnd */
+		mmte = &MCD_modelTaskTable[TASK_FECTX];
+		tte->TDTstart = mmte->TDTstart;
+		tte->TDTend = mmte->TDTend;
+		MCD_startDmaENetXmit(srcAddr, srcAddr, destAddr, MCD_taskTable,
+				     channel);
+	} else if (flags & MCD_FECRX_DMA) {
+		/* TDTStart and TDTEnd */
+		mmte = &MCD_modelTaskTable[TASK_FECRX];
+		tte->TDTstart = mmte->TDTstart;
+		tte->TDTend = mmte->TDTend;
+		MCD_startDmaENetRcv(srcAddr, srcAddr, destAddr, MCD_taskTable,
+				    channel);
+	} else if (flags & MCD_SINGLE_DMA) {
+		struct MCD_bufDesc *mrbd;
+
+		/*
+		 * This buffer descriptor is used for storing off initial
+		 * parameters * for later progress query calculation and for
+		 * the DMA to write the resulting checksum. The DMA does not
+		 * use this to determine how to * operate, that info is passed
+		 * with the init routine
+		 */
+		mrbd = &MCD_relocBuffDesc[channel];
+		mrbd->srcAddr = srcAddr;
+		mrbd->destAddr = destAddr;
+		mrbd->lastDestAddr = destAddr;
+		mrbd->dmaSize = dmaSize;
+		mrbd->flags = 0;       /* not used */
+		mrbd->csumResult = 0;  /* not used */
+		mrbd->next = 0;        /* not used */
+
+		/* Initialize the progress-querying stuff to show no progress:*/
+		css = tte->contextSaveSpace;
+		writel((int)srcAddr, css + SRCPTR);
+		writel((int)destAddr, css + DESTPTR);
+		writel(0, css + DCOUNT);
+		writel((u32)mrbd, css + CURRBD);
+
+		if (funcDesc == MCD_FUNC_NOEU1 || funcDesc == MCD_FUNC_NOEU2) {
+			/* TDTStart and TDTEnd */
+			mmte = &MCD_modelTaskTable[TASK_SINGLENOEU];
+			tte->TDTstart = mmte->TDTstart;
+			tte->TDTend = mmte->TDTend;
+			MCD_startDmaSingleNoEu(srcAddr, srcIncr, destAddr,
+					destIncr, dmaSize,
+					xferSizeIncr, flags, (int *)mrbd,
+					cSave, MCD_taskTable, channel);
+		} else {
+			/* TDTStart and TDTEnd */
+			mmte = &MCD_modelTaskTable[TASK_SINGLEEU];
+			tte->TDTstart = mmte->TDTstart;
+			tte->TDTend = mmte->TDTend;
+			MCD_startDmaSingleEu(srcAddr, srcIncr, destAddr,
+					destIncr, dmaSize,
+					xferSizeIncr, flags, (int *)mrbd,
+					cSave, MCD_taskTable, channel);
+		}
+	} else /* Chained DMA */ {
+		struct MCD_bufDesc *mbd;
+
+		/* Initialize the progress-querying stuff to show no progress:*/
+#if 1 /* (!defined(MCD_NEED_ADDR_TRANS)) */
+		mbd = (struct MCD_bufDesc *) srcAddr;
+#else /* if using address translation, need the virtual addr of the first buffdesc */
+		mbd = (struct MCD_bufDesc *) srcAddrVirt;
+#endif
+		css = tte->contextSaveSpace;
+		writel((int)mbd->srcAddr, css + SRCPTR);
+		writel((int)mbd->destAddr, css + DESTPTR);
+		writel(0, css + DCOUNT);
+		writel((u32)srcAddr, css + CURRBD);
+
+		if (funcDesc == MCD_FUNC_NOEU1 || funcDesc == MCD_FUNC_NOEU2) {
+			/* TDTStart and TDTEnd */
+			mmte = &MCD_modelTaskTable[TASK_CHAINNOEU];
+			tte->TDTstart = mmte->TDTstart;
+			tte->TDTend = mmte->TDTend;
+			MCD_startDmaChainNoEu((int *)srcAddr, srcIncr, destIncr,
+					      xferSize, xferSizeIncr, cSave,
+					      MCD_taskTable, channel);
+		} else {
+			/* TDTStart and TDTEnd */
+			mmte = &MCD_modelTaskTable[TASK_CHAINEU];
+			tte->TDTstart = mmte->TDTstart;
+			tte->TDTend = mmte->TDTend;
+			MCD_startDmaChainEu((int *)srcAddr, srcIncr, destIncr,
+					    xferSize, xferSizeIncr, cSave,
+					    MCD_taskTable, channel);
+		}
+	}
+
+	MCD_chStatus[channel] = MCD_IDLE;
+	return MCD_OK;
+}
+
+/************************ End of MCD_startDma() *********************/
+
+/********************************************************************/
+/* Function:    MCD_XferProgrQuery
+ * Purpose:     Returns progress of DMA on requested channel
+ * Arguments:   channel - channel to retrieve progress for
+ *              progRep - pointer to user supplied MCD_XferProg struct
+ * Returns:     MCD_CHANNEL_INVALID if channel is invalid, else MCD_OK
+ *
+ * Notes:
+ *  MCD_XferProgrQuery() upon completing or after aborting a DMA, or
+ *  while the DMA is in progress, this function returns the first
+ *  DMA-destination address not (or not yet) used in the DMA. When
+ *  encountering a non-ready buffer descriptor, the information for
+ *  the last completed descriptor is returned.
+ *
+ *  MCD_XferProgQuery() has to avoid the possibility of getting
+ *  partially-updated information in the event that we should happen
+ *  to query DMA progress just as the DMA is updating it. It does that
+ *  by taking advantage of the fact context is not saved frequently for
+ *  the most part. We therefore read it at least twice until we get the
+ *  same information twice in a row.
+ *
+ *  Because a small, but not insignificant, amount of time is required
+ *  to write out the progress-query information, especially upon
+ *  completion of the DMA, it would be wise to guarantee some time lag
+ *  between successive readings of the progress-query information.
+ */
+
+/*
+ * How many iterations of the loop below to execute to stabilize values
+ */
+#define STABTIME 0
+
+int MCD_XferProgrQuery(const int channel, struct MCD_XferProg *progRep)
+{
+	struct MCD_XferProg prevRep;
+	int again;  /* true if we are to try again to get consistent results */
+	int i;  /* used as a time-waste counter */
+	int destDiffBytes; /* Total number of bytes that we think actually got xfered. */
+	int numIterations; /* number of iterations */
+	int bytesNotXfered; /* bytes that did not get xfered. */
+	s8 *LWAlignedInitDestAddr, *LWAlignedCurrDestAddr;
+	int subModVal, addModVal; /* Mode values to added and subtracted from
+				     the final destAddr */
+	struct TaskTableEntry *tte;
+	u32 css;
+	struct MCD_remVariants *var;
+
+	if ((channel < 0) || (channel >= NCHANNELS))
+		return MCD_CHANNEL_INVALID;
+
+	tte = &MCD_taskTable[channel];
+	css = tte->contextSaveSpace;
+
+	/* Read a trial value for the progress-reporting values */
+	prevRep.lastSrcAddr = (s8 *)readl(css + SRCPTR);
+	prevRep.lastDestAddr = (s8 *)readl(css + DESTPTR);
+	prevRep.dmaSize = readl(css + DCOUNT);
+	prevRep.currBufDesc = (struct MCD_bufDesc *)readl(css + CURRBD);
+
+	/* Repeatedly reread those values until they match previous values: */
+	do {
+		/* Take a little bit of time to ensure stability: */
+		for (i = 0;  i < STABTIME;  i++)
+			i += i >> 2;  /* make sure this loop does something so
+					 that it doesn't get optimized out */
+		/* Check them again: */
+		progRep->lastSrcAddr = (s8 *)readl(css + SRCPTR);
+		progRep->lastDestAddr = (s8 *)readl(css + DESTPTR);
+		progRep->dmaSize = readl(css + DCOUNT);
+		progRep->currBufDesc = (struct MCD_bufDesc *)readl(css + CURRBD);
+
+		/* See if they match: */
+		if (prevRep.lastSrcAddr  != progRep->lastSrcAddr
+		    || prevRep.lastDestAddr != progRep->lastDestAddr
+		    || prevRep.dmaSize      != progRep->dmaSize
+		    || prevRep.currBufDesc  != progRep->currBufDesc) {
+			/* If they don't match, remember previous values and try again:*/
+			prevRep.lastSrcAddr = progRep->lastSrcAddr;
+			prevRep.lastDestAddr = progRep->lastDestAddr;
+			prevRep.dmaSize = progRep->dmaSize;
+			prevRep.currBufDesc = progRep->currBufDesc;
+			again = MCD_TRUE;
+		} else
+			again = MCD_FALSE;
+	} while (again == MCD_TRUE);
+
+
+	/* Update dmaSize and lastDestAddr */
+	var = &MCD_remVariants[channel];
+	switch (var->remDestRsdIncr) {
+	case MINUS1:
+		subModVal = ((int)progRep->lastDestAddr)
+			    & ((var->remXferSize) - 1);
+		addModVal = ((int)progRep->currBufDesc->destAddr)
+			    & ((var->remXferSize) - 1);
+		LWAlignedInitDestAddr = (progRep->currBufDesc->destAddr) - addModVal;
+		LWAlignedCurrDestAddr = (progRep->lastDestAddr) - subModVal;
+		destDiffBytes = LWAlignedInitDestAddr - LWAlignedCurrDestAddr;
+		bytesNotXfered = (destDiffBytes/var->remDestIncr) *
+				(var->remDestIncr + var->remXferSize);
+		progRep->dmaSize = destDiffBytes - bytesNotXfered + addModVal - subModVal;
+		break;
+	case ZERO:
+		progRep->lastDestAddr = progRep->currBufDesc->destAddr;
+		break;
+	case PLUS1:
+		/* This value has to be subtracted from the final calculated dmaSize. */
+		subModVal = ((int)progRep->currBufDesc->destAddr)
+			    & ((var->remXferSize) - 1);
+		/* These bytes are already in lastDestAddr. */
+		addModVal = ((int)progRep->lastDestAddr)
+			    & ((var->remXferSize) - 1);
+		LWAlignedInitDestAddr = (progRep->currBufDesc->destAddr) - subModVal;
+		LWAlignedCurrDestAddr = (progRep->lastDestAddr) - addModVal;
+		destDiffBytes = (progRep->lastDestAddr - LWAlignedInitDestAddr);
+		numIterations = (LWAlignedCurrDestAddr - LWAlignedInitDestAddr)/var->remDestIncr;
+		bytesNotXfered =  numIterations *
+				  (var->remDestIncr - var->remXferSize);
+		progRep->dmaSize = destDiffBytes - bytesNotXfered - subModVal;
+		break;
+	default:
+		break;
+	}
+
+	/* This covers M1,P1,Z for source */
+	switch (var->remSrcRsdIncr) {
+	case MINUS1:
+		progRep->lastSrcAddr = progRep->currBufDesc->srcAddr +
+		     (var->remSrcIncr * (progRep->dmaSize/var->remXferSize));
+		break;
+	case ZERO:
+		progRep->lastSrcAddr = progRep->currBufDesc->srcAddr;
+		break;
+	case PLUS1:
+		progRep->lastSrcAddr = progRep->currBufDesc->srcAddr +
+		     (var->remSrcIncr * (progRep->dmaSize/var->remXferSize));
+		break;
+	default:
+		break;
+	}
+
+	return MCD_OK;
+}
+/******************* End of MCD_XferProgrQuery() ********************/
+
+/********************************************************************/
+/* MCD_resmActions() does the majority of the actions of a DMA resume.
+ * It is called from MCD_killDma() and MCD_resumeDma().  It has to be
+ * a separate function because the kill function has to negate the task
+ * enable before resuming it, but the resume function has to do nothing
+ * if there is no DMA on that channel (i.e., if the enable bit is 0).
+ */
+static void MCD_resmActions(int channel)
+{
+	u32 status;
+
+	writel(DBG_CTL_DISABLE, &MCD_dmaBar->debugControl);
+	status = readl(&MCD_dmaBar->debugStatus);
+	writel(status, &MCD_dmaBar->debugStatus);
+
+	/* Determine which initiators are asserted */
+	writel(PTD_DBG_TSK_VLD_INIT, &MCD_dmaBar->ptdDebug);
+
+	if ((readl(&MCD_dmaBar->ptdDebug) >> channel) & 0x1)
+		MCD_chStatus[channel] = MCD_RUNNING;
+	else
+		MCD_chStatus[channel] = MCD_IDLE;
+}
+/********************* End of MCD_resmActions() *********************/
+
+/********************************************************************/
+/* Function:    MCD_killDma
+ * Purpose:     Halt the DMA on the requested channel, without any
+ *              intention of resuming the DMA.
+ * Arguments:   channel - requested channel
+ * Returns:     MCD_CHANNEL_INVALID if channel is invalid, else MCD_OK
+ *
+ * Notes:
+ *  A DMA may be killed from any state, including paused state, and it
+ *  always goes to the MCD_HALTED state even if it is killed while in
+ *  the MCD_NO_DMA or MCD_IDLE states.
+ */
+int MCD_killDma(int channel)
+{
+	if ((channel < 0) || (channel >= NCHANNELS))
+		return MCD_CHANNEL_INVALID;
+
+	writew(0x0, &MCD_dmaBar->taskControl[channel]);
+
+	/* Clean up after a paused task */
+	if (MCD_chStatus[channel] == MCD_PAUSED) {
+		u32 status;
+
+		writel(DBG_CTL_DISABLE, &MCD_dmaBar->debugControl);
+		status = readl(&MCD_dmaBar->debugStatus);
+		writel(status, &MCD_dmaBar->debugStatus);
+	}
+
+	MCD_chStatus[channel] = MCD_HALTED;
+
+	return MCD_OK;
+}
+/************************ End of MCD_killDma() **********************/
+
+/********************************************************************/
+/* Function:    MCD_continDma
+ * Purpose:     Continue a DMA which as stopped due to encountering an
+ *              unready buffer descriptor.
+ * Arguments:   channel - channel to continue the DMA on
+ * Returns:     MCD_CHANNEL_INVALID if channel is invalid, else MCD_OK
+ *
+ * Notes:
+ *  This routine does not check to see if there is a task which can
+ *  be continued. Also this routine should not be used with single DMAs.
+ */
+int MCD_continDma(int channel)
+{
+	u16 tcrValue;
+
+	if ((channel < 0) || (channel >= NCHANNELS))
+		return MCD_CHANNEL_INVALID;
+
+	tcrValue = readw(&MCD_dmaBar->taskControl[channel]);
+	writew(tcrValue | TASK_CTL_EN, &MCD_dmaBar->taskControl[channel]);
+	MCD_chStatus[channel] = MCD_RUNNING;
+
+	return MCD_OK;
+}
+/********************** End of MCD_continDma() **********************/
+
+/*********************************************************************
+ * MCD_pauseDma() and MCD_resumeDma() below use the DMA's debug unit
+ * to freeze a task and resume it.  We freeze a task by breakpointing
+ * on the stated task.  That is, not any specific place in the task,
+ * but any time that task executes.  In particular, when that task
+ * executes, we want to freeze that task and only that task.
+ *
+ * The bits of the debug control register influence interrupts vs.
+ * breakpoints as follows:
+ * - Bits 14 and 0 enable or disable debug functions.  If enabled, you
+ *   will get the interrupt but you may or may not get a breakpoint.
+ * - Bits 2 and 1 decide whether you also get a breakpoint in addition
+ *   to an interrupt.
+ *
+ * The debug unit can do these actions in response to either internally
+ * detected breakpoint conditions from the comparators, or in response
+ * to the external breakpoint pin, or both.
+ * - Bits 14 and 1 perform the above-described functions for
+ *   internally-generated conditions, i.e., the debug comparators.
+ * - Bits 0 and 2 perform the above-described functions for external
+ *   conditions, i.e., the breakpoint external pin.
+ *
+ * Note that, although you "always" get the interrupt when you turn
+ * the debug functions, the interrupt can nevertheless, if desired, be
+ * masked by the corresponding bit in the PTD's IMR. Note also that
+ * this means that bits 14 and 0 must enable debug functions before
+ * bits 1 and 2, respectively, have any effect.
+ *
+ * NOTE: It's extremely important to not pause more than one DMA channel
+ *  at a time.
+ ********************************************************************/
+
+/********************************************************************/
+/* Function:    MCD_pauseDma
+ * Purpose:     Pauses the DMA on a given channel (if any DMA is running
+ *              on that channel).
+ * Arguments:   channel
+ * Returns:     MCD_CHANNEL_INVALID if channel is invalid, else MCD_OK
+ */
+int MCD_pauseDma(int channel)
+{
+	if ((channel < 0) || (channel >= NCHANNELS))
+		return MCD_CHANNEL_INVALID;
+
+	if (readw(&MCD_dmaBar->taskControl[channel]) & TASK_CTL_EN) {
+		writel(channel, &MCD_dmaBar->debugComp1);
+		writel(DBG_CTL_ENABLE | (1 << (channel + 16)),
+		       &MCD_dmaBar->debugControl);
+		MCD_chStatus[channel] = MCD_PAUSED;
+	}
+	return MCD_OK;
+}
+/************************* End of MCD_pauseDma() ********************/
+
+/********************************************************************/
+/* Function:    MCD_resumeDma
+ * Purpose:     Resumes the DMA on a given channel (if any DMA is
+ *              running on that channel).
+ * Arguments:   channel - channel on which to resume DMA
+ * Returns:     MCD_CHANNEL_INVALID if channel is invalid, else MCD_OK
+ */
+int MCD_resumeDma(int channel)
+{
+	if ((channel < 0) || (channel >= NCHANNELS))
+		return MCD_CHANNEL_INVALID;
+
+	if (readw(&MCD_dmaBar->taskControl[channel]) & TASK_CTL_EN)
+		MCD_resmActions(channel);
+
+	return MCD_OK;
+}
+/************************ End of MCD_resumeDma() ********************/
+
+/********************************************************************/
+/* Function:    MCD_csumQuery
+ * Purpose:     Provide the checksum after performing a non-chained DMA
+ * Arguments:   channel - channel to report on
+ *              csum - pointer to where to write the checksum/CRC
+ * Returns:     MCD_ERROR if the channel is invalid, else MCD_OK
+ *
+ * Notes:
+ *
+ */
+int MCD_csumQuery(int channel, u32 *csum)
+{
+#ifdef MCD_INCLUDE_EU
+	if ((channel < 0) || (channel >= NCHANNELS))
+		return MCD_CHANNEL_INVALID;
+
+	*csum = MCD_relocBuffDesc[channel].csumResult;
+	return MCD_OK;
+#else
+	return MCD_ERROR;
+#endif
+}
+/*********************** End of MCD_resumeDma() *********************/
+
+/********************************************************************/
+/* Function:    MCD_getCodeSize
+ * Purpose:     Provide the size requirements of the microcoded tasks
+ * Returns:     Size in bytes
+ */
+int MCD_getCodeSize(void)
+{
+#ifdef MCD_INCLUDE_EU
+	return 0x2b64;
+#else
+	return 0x1744;
+#endif
+}
+/********************** End of MCD_getCodeSize() ********************/
+
+/********************************************************************/
+/* Function:    MCD_getVersion
+ * Purpose:     Provide the version string and number
+ * Arguments:   longVersion - user supplied pointer to a pointer to a char
+ *                    which points to the version string
+ * Returns:     Version number and version string (by reference)
+ */
+char MCD_versionString[] = "Multi-channel DMA API v1.0";
+#define MCD_REV_MAJOR   0x01
+#define MCD_REV_MINOR   0x00
+
+int MCD_getVersion(char **longVersion)
+{
+	*longVersion = MCD_versionString;
+	return (MCD_REV_MAJOR << 8) | MCD_REV_MINOR;
+}
+/********************** End of MCD_getVersion() *********************/
+
+/********************************************************************/
+/* Private version of memcpy()
+ * Note that everything this is used for is longword-aligned.
+ */
+static void MCD_memcpy(int *dest, int *src, u32 size)
+{
+	u32 i;
+
+	for (i = 0;  i < size;  i += sizeof(int), dest++, src++)
+		*dest = *src;
+}
+/********************************************************************/
diff --git a/drivers/dma/fsl_mcd_dma/MCD_tasks.c b/drivers/dma/fsl_mcd_dma/MCD_tasks.c
new file mode 100644
index 0000000..677ed9b
--- /dev/null
+++ b/drivers/dma/fsl_mcd_dma/MCD_tasks.c
@@ -0,0 +1,2425 @@
+/*
+ * drivers/dma/MCD_tasks.c
+ *
+ * Copyright (C) 2004-2008 Freescale Semiconductor, Inc.
+ *     Kurt Mahan <kmahan@freescale.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+ * MA 02111-1307 USA
+ */
+
+#include <linux/MCD_dma.h>
+
+u32 MCD_varTab0[];
+u32 MCD_varTab1[];
+u32 MCD_varTab2[];
+u32 MCD_varTab3[];
+u32 MCD_varTab4[];
+u32 MCD_varTab5[];
+u32 MCD_varTab6[];
+u32 MCD_varTab7[];
+u32 MCD_varTab8[];
+u32 MCD_varTab9[];
+u32 MCD_varTab10[];
+u32 MCD_varTab11[];
+u32 MCD_varTab12[];
+u32 MCD_varTab13[];
+u32 MCD_varTab14[];
+u32 MCD_varTab15[];
+
+u32 MCD_funcDescTab0[];
+#ifdef MCD_INCLUDE_EU
+u32 MCD_funcDescTab1[];
+u32 MCD_funcDescTab2[];
+u32 MCD_funcDescTab3[];
+u32 MCD_funcDescTab4[];
+u32 MCD_funcDescTab5[];
+u32 MCD_funcDescTab6[];
+u32 MCD_funcDescTab7[];
+u32 MCD_funcDescTab8[];
+u32 MCD_funcDescTab9[];
+u32 MCD_funcDescTab10[];
+u32 MCD_funcDescTab11[];
+u32 MCD_funcDescTab12[];
+u32 MCD_funcDescTab13[];
+u32 MCD_funcDescTab14[];
+u32 MCD_funcDescTab15[];
+#endif
+
+u32 MCD_contextSave0[];
+u32 MCD_contextSave1[];
+u32 MCD_contextSave2[];
+u32 MCD_contextSave3[];
+u32 MCD_contextSave4[];
+u32 MCD_contextSave5[];
+u32 MCD_contextSave6[];
+u32 MCD_contextSave7[];
+u32 MCD_contextSave8[];
+u32 MCD_contextSave9[];
+u32 MCD_contextSave10[];
+u32 MCD_contextSave11[];
+u32 MCD_contextSave12[];
+u32 MCD_contextSave13[];
+u32 MCD_contextSave14[];
+u32 MCD_contextSave15[];
+
+const u32 MCD_realTaskTableSrc[] = {
+	0x00000000,
+	0x00000000,
+	(u32)MCD_varTab0,   /* Task 0 Variable Table */
+	(u32)MCD_funcDescTab0,  /* Task 0 Function Descriptor Table & Flags */
+	0x00000000,
+	0x00000000,
+	(u32)MCD_contextSave0,  /* Task 0 context save space */
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	(u32)MCD_varTab1,   /* Task 1 Variable Table */
+#ifdef MCD_INCLUDE_EU
+	(u32)MCD_funcDescTab1,  /* Task 1 Function Descriptor Table & Flags */
+#else
+	(u32)MCD_funcDescTab0,  /* Task 0 Function Descriptor Table & Flags */
+#endif
+	0x00000000,
+	0x00000000,
+	(u32)MCD_contextSave1,  /* Task 1 context save space */
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	(u32)MCD_varTab2,   /* Task 2 Variable Table */
+#ifdef MCD_INCLUDE_EU
+	(u32)MCD_funcDescTab2,  /* Task 2 Function Descriptor Table & Flags */
+#else
+	(u32)MCD_funcDescTab0,  /* Task 0 Function Descriptor Table & Flags */
+#endif
+	0x00000000,
+	0x00000000,
+	(u32)MCD_contextSave2,  /* Task 2 context save space */
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	(u32)MCD_varTab3,   /* Task 3 Variable Table */
+#ifdef MCD_INCLUDE_EU
+	(u32)MCD_funcDescTab3,  /* Task 3 Function Descriptor Table & Flags */
+#else
+	(u32)MCD_funcDescTab0,  /* Task 0 Function Descriptor Table & Flags */
+#endif
+	0x00000000,
+	0x00000000,
+	(u32)MCD_contextSave3,  /* Task 3 context save space */
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	(u32)MCD_varTab4,   /* Task 4 Variable Table */
+#ifdef MCD_INCLUDE_EU
+	(u32)MCD_funcDescTab4,  /* Task 4 Function Descriptor Table & Flags */
+#else
+	(u32)MCD_funcDescTab0,  /* Task 0 Function Descriptor Table & Flags */
+#endif
+	0x00000000,
+	0x00000000,
+	(u32)MCD_contextSave4,  /* Task 4 context save space */
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	(u32)MCD_varTab5,   /* Task 5 Variable Table */
+#ifdef MCD_INCLUDE_EU
+	(u32)MCD_funcDescTab5,  /* Task 5 Function Descriptor Table & Flags */
+#else
+	(u32)MCD_funcDescTab0,  /* Task 0 Function Descriptor Table & Flags */
+#endif
+	0x00000000,
+	0x00000000,
+	(u32)MCD_contextSave5,  /* Task 5 context save space */
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	(u32)MCD_varTab6,   /* Task 6 Variable Table */
+#ifdef MCD_INCLUDE_EU
+	(u32)MCD_funcDescTab6,  /* Task 6 Function Descriptor Table & Flags */
+#else
+	(u32)MCD_funcDescTab0,  /* Task 0 Function Descriptor Table & Flags */
+#endif
+	0x00000000,
+	0x00000000,
+	(u32)MCD_contextSave6,  /* Task 6 context save space */
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	(u32)MCD_varTab7,   /* Task 7 Variable Table */
+#ifdef MCD_INCLUDE_EU
+	(u32)MCD_funcDescTab7,  /* Task 7 Function Descriptor Table & Flags */
+#else
+	(u32)MCD_funcDescTab0,  /* Task 0 Function Descriptor Table & Flags */
+#endif
+	0x00000000,
+	0x00000000,
+	(u32)MCD_contextSave7,  /* Task 7 context save space */
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	(u32)MCD_varTab8,   /* Task 8 Variable Table */
+#ifdef MCD_INCLUDE_EU
+	(u32)MCD_funcDescTab8,  /* Task 8 Function Descriptor Table & Flags */
+#else
+	(u32)MCD_funcDescTab0,  /* Task 0 Function Descriptor Table & Flags */
+#endif
+	0x00000000,
+	0x00000000,
+	(u32)MCD_contextSave8,  /* Task 8 context save space */
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	(u32)MCD_varTab9,   /* Task 9 Variable Table */
+#ifdef MCD_INCLUDE_EU
+	(u32)MCD_funcDescTab9,  /* Task 9 Function Descriptor Table & Flags */
+#else
+	(u32)MCD_funcDescTab0,  /* Task 0 Function Descriptor Table & Flags */
+#endif
+	0x00000000,
+	0x00000000,
+	(u32)MCD_contextSave9,  /* Task 9 context save space */
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	(u32)MCD_varTab10,  /* Task 10 Variable Table */
+#ifdef MCD_INCLUDE_EU
+	(u32)MCD_funcDescTab10, /* Task 10 Function Descriptor Table & Flags */
+#else
+	(u32)MCD_funcDescTab0,  /* Task 0 Function Descriptor Table & Flags */
+#endif
+	0x00000000,
+	0x00000000,
+	(u32)MCD_contextSave10, /* Task 10 context save space */
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	(u32)MCD_varTab11,  /* Task 11 Variable Table */
+#ifdef MCD_INCLUDE_EU
+	(u32)MCD_funcDescTab11, /* Task 11 Function Descriptor Table & Flags */
+#else
+	(u32)MCD_funcDescTab0,  /* Task 0 Function Descriptor Table & Flags */
+#endif
+	0x00000000,
+	0x00000000,
+	(u32)MCD_contextSave11, /* Task 11 context save space */
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	(u32)MCD_varTab12,  /* Task 12 Variable Table */
+#ifdef MCD_INCLUDE_EU
+	(u32)MCD_funcDescTab12, /* Task 12 Function Descriptor Table & Flags */
+#else
+	(u32)MCD_funcDescTab0,  /* Task 0 Function Descriptor Table & Flags */
+#endif
+	0x00000000,
+	0x00000000,
+	(u32)MCD_contextSave12, /* Task 12 context save space */
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	(u32)MCD_varTab13,  /* Task 13 Variable Table */
+#ifdef MCD_INCLUDE_EU
+	(u32)MCD_funcDescTab13, /* Task 13 Function Descriptor Table & Flags */
+#else
+	(u32)MCD_funcDescTab0,  /* Task 0 Function Descriptor Table & Flags */
+#endif
+	0x00000000,
+	0x00000000,
+	(u32)MCD_contextSave13, /* Task 13 context save space */
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	(u32)MCD_varTab14,  /* Task 14 Variable Table */
+#ifdef MCD_INCLUDE_EU
+	(u32)MCD_funcDescTab14, /* Task 14 Function Descriptor Table & Flags */
+#else
+	(u32)MCD_funcDescTab0,  /* Task 0 Function Descriptor Table & Flags */
+#endif
+	0x00000000,
+	0x00000000,
+	(u32)MCD_contextSave14, /* Task 14 context save space */
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	(u32)MCD_varTab15,  /* Task 15 Variable Table */
+#ifdef MCD_INCLUDE_EU
+	(u32)MCD_funcDescTab15, /* Task 15 Function Descriptor Table & Flags */
+#else
+	(u32)MCD_funcDescTab0,  /* Task 0 Function Descriptor Table & Flags */
+#endif
+	0x00000000,
+	0x00000000,
+	(u32)MCD_contextSave15, /* Task 15 context save space */
+	0x00000000,
+};
+
+
+u32 MCD_varTab0[] = {   /* Task 0 Variable Table */
+	0x00000000, /* var[0] */
+	0x00000000, /* var[1] */
+	0x00000000, /* var[2] */
+	0x00000000, /* var[3] */
+	0x00000000, /* var[4] */
+	0x00000000, /* var[5] */
+	0x00000000, /* var[6] */
+	0x00000000, /* var[7] */
+	0x00000000, /* var[8] */
+	0x00000000, /* var[9] */
+	0x00000000, /* var[10] */
+	0x00000000, /* var[11] */
+	0x00000000, /* var[12] */
+	0x00000000, /* var[13] */
+	0x00000000, /* var[14] */
+	0x00000000, /* var[15] */
+	0x00000000, /* var[16] */
+	0x00000000, /* var[17] */
+	0x00000000, /* var[18] */
+	0x00000000, /* var[19] */
+	0x00000000, /* var[20] */
+	0x00000000, /* var[21] */
+	0x00000000, /* var[22] */
+	0x00000000, /* var[23] */
+	0xe0000000, /* inc[0] */
+	0x20000000, /* inc[1] */
+	0x2000ffff, /* inc[2] */
+	0x00000000, /* inc[3] */
+	0x00000000, /* inc[4] */
+	0x00000000, /* inc[5] */
+	0x00000000, /* inc[6] */
+	0x00000000, /* inc[7] */
+};
+
+
+u32 MCD_varTab1[] = {   /* Task 1 Variable Table */
+	0x00000000, /* var[0] */
+	0x00000000, /* var[1] */
+	0x00000000, /* var[2] */
+	0x00000000, /* var[3] */
+	0x00000000, /* var[4] */
+	0x00000000, /* var[5] */
+	0x00000000, /* var[6] */
+	0x00000000, /* var[7] */
+	0x00000000, /* var[8] */
+	0x00000000, /* var[9] */
+	0x00000000, /* var[10] */
+	0x00000000, /* var[11] */
+	0x00000000, /* var[12] */
+	0x00000000, /* var[13] */
+	0x00000000, /* var[14] */
+	0x00000000, /* var[15] */
+	0x00000000, /* var[16] */
+	0x00000000, /* var[17] */
+	0x00000000, /* var[18] */
+	0x00000000, /* var[19] */
+	0x00000000, /* var[20] */
+	0x00000000, /* var[21] */
+	0x00000000, /* var[22] */
+	0x00000000, /* var[23] */
+	0xe0000000, /* inc[0] */
+	0x20000000, /* inc[1] */
+	0x2000ffff, /* inc[2] */
+	0x00000000, /* inc[3] */
+	0x00000000, /* inc[4] */
+	0x00000000, /* inc[5] */
+	0x00000000, /* inc[6] */
+	0x00000000, /* inc[7] */
+};
+
+u32 MCD_varTab2[] = {   /* Task 2 Variable Table */
+	0x00000000, /* var[0] */
+	0x00000000, /* var[1] */
+	0x00000000, /* var[2] */
+	0x00000000, /* var[3] */
+	0x00000000, /* var[4] */
+	0x00000000, /* var[5] */
+	0x00000000, /* var[6] */
+	0x00000000, /* var[7] */
+	0x00000000, /* var[8] */
+	0x00000000, /* var[9] */
+	0x00000000, /* var[10] */
+	0x00000000, /* var[11] */
+	0x00000000, /* var[12] */
+	0x00000000, /* var[13] */
+	0x00000000, /* var[14] */
+	0x00000000, /* var[15] */
+	0x00000000, /* var[16] */
+	0x00000000, /* var[17] */
+	0x00000000, /* var[18] */
+	0x00000000, /* var[19] */
+	0x00000000, /* var[20] */
+	0x00000000, /* var[21] */
+	0x00000000, /* var[22] */
+	0x00000000, /* var[23] */
+	0xe0000000, /* inc[0] */
+	0x20000000, /* inc[1] */
+	0x2000ffff, /* inc[2] */
+	0x00000000, /* inc[3] */
+	0x00000000, /* inc[4] */
+	0x00000000, /* inc[5] */
+	0x00000000, /* inc[6] */
+	0x00000000, /* inc[7] */
+};
+
+u32 MCD_varTab3[] = {   /* Task 3 Variable Table */
+	0x00000000, /* var[0] */
+	0x00000000, /* var[1] */
+	0x00000000, /* var[2] */
+	0x00000000, /* var[3] */
+	0x00000000, /* var[4] */
+	0x00000000, /* var[5] */
+	0x00000000, /* var[6] */
+	0x00000000, /* var[7] */
+	0x00000000, /* var[8] */
+	0x00000000, /* var[9] */
+	0x00000000, /* var[10] */
+	0x00000000, /* var[11] */
+	0x00000000, /* var[12] */
+	0x00000000, /* var[13] */
+	0x00000000, /* var[14] */
+	0x00000000, /* var[15] */
+	0x00000000, /* var[16] */
+	0x00000000, /* var[17] */
+	0x00000000, /* var[18] */
+	0x00000000, /* var[19] */
+	0x00000000, /* var[20] */
+	0x00000000, /* var[21] */
+	0x00000000, /* var[22] */
+	0x00000000, /* var[23] */
+	0xe0000000, /* inc[0] */
+	0x20000000, /* inc[1] */
+	0x2000ffff, /* inc[2] */
+	0x00000000, /* inc[3] */
+	0x00000000, /* inc[4] */
+	0x00000000, /* inc[5] */
+	0x00000000, /* inc[6] */
+	0x00000000, /* inc[7] */
+};
+
+u32 MCD_varTab4[] = {   /* Task 4 Variable Table */
+	0x00000000, /* var[0] */
+	0x00000000, /* var[1] */
+	0x00000000, /* var[2] */
+	0x00000000, /* var[3] */
+	0x00000000, /* var[4] */
+	0x00000000, /* var[5] */
+	0x00000000, /* var[6] */
+	0x00000000, /* var[7] */
+	0x00000000, /* var[8] */
+	0x00000000, /* var[9] */
+	0x00000000, /* var[10] */
+	0x00000000, /* var[11] */
+	0x00000000, /* var[12] */
+	0x00000000, /* var[13] */
+	0x00000000, /* var[14] */
+	0x00000000, /* var[15] */
+	0x00000000, /* var[16] */
+	0x00000000, /* var[17] */
+	0x00000000, /* var[18] */
+	0x00000000, /* var[19] */
+	0x00000000, /* var[20] */
+	0x00000000, /* var[21] */
+	0x00000000, /* var[22] */
+	0x00000000, /* var[23] */
+	0xe0000000, /* inc[0] */
+	0x20000000, /* inc[1] */
+	0x2000ffff, /* inc[2] */
+	0x00000000, /* inc[3] */
+	0x00000000, /* inc[4] */
+	0x00000000, /* inc[5] */
+	0x00000000, /* inc[6] */
+	0x00000000, /* inc[7] */
+};
+
+u32 MCD_varTab5[] = {   /* Task 5 Variable Table */
+	0x00000000, /* var[0] */
+	0x00000000, /* var[1] */
+	0x00000000, /* var[2] */
+	0x00000000, /* var[3] */
+	0x00000000, /* var[4] */
+	0x00000000, /* var[5] */
+	0x00000000, /* var[6] */
+	0x00000000, /* var[7] */
+	0x00000000, /* var[8] */
+	0x00000000, /* var[9] */
+	0x00000000, /* var[10] */
+	0x00000000, /* var[11] */
+	0x00000000, /* var[12] */
+	0x00000000, /* var[13] */
+	0x00000000, /* var[14] */
+	0x00000000, /* var[15] */
+	0x00000000, /* var[16] */
+	0x00000000, /* var[17] */
+	0x00000000, /* var[18] */
+	0x00000000, /* var[19] */
+	0x00000000, /* var[20] */
+	0x00000000, /* var[21] */
+	0x00000000, /* var[22] */
+	0x00000000, /* var[23] */
+	0xe0000000, /* inc[0] */
+	0x20000000, /* inc[1] */
+	0x2000ffff, /* inc[2] */
+	0x00000000, /* inc[3] */
+	0x00000000, /* inc[4] */
+	0x00000000, /* inc[5] */
+	0x00000000, /* inc[6] */
+	0x00000000, /* inc[7] */
+};
+
+u32 MCD_varTab6[] = {   /* Task 6 Variable Table */
+	0x00000000, /* var[0] */
+	0x00000000, /* var[1] */
+	0x00000000, /* var[2] */
+	0x00000000, /* var[3] */
+	0x00000000, /* var[4] */
+	0x00000000, /* var[5] */
+	0x00000000, /* var[6] */
+	0x00000000, /* var[7] */
+	0x00000000, /* var[8] */
+	0x00000000, /* var[9] */
+	0x00000000, /* var[10] */
+	0x00000000, /* var[11] */
+	0x00000000, /* var[12] */
+	0x00000000, /* var[13] */
+	0x00000000, /* var[14] */
+	0x00000000, /* var[15] */
+	0x00000000, /* var[16] */
+	0x00000000, /* var[17] */
+	0x00000000, /* var[18] */
+	0x00000000, /* var[19] */
+	0x00000000, /* var[20] */
+	0x00000000, /* var[21] */
+	0x00000000, /* var[22] */
+	0x00000000, /* var[23] */
+	0xe0000000, /* inc[0] */
+	0x20000000, /* inc[1] */
+	0x2000ffff, /* inc[2] */
+	0x00000000, /* inc[3] */
+	0x00000000, /* inc[4] */
+	0x00000000, /* inc[5] */
+	0x00000000, /* inc[6] */
+	0x00000000, /* inc[7] */
+};
+
+u32 MCD_varTab7[] = {   /* Task 7 Variable Table */
+	0x00000000, /* var[0] */
+	0x00000000, /* var[1] */
+	0x00000000, /* var[2] */
+	0x00000000, /* var[3] */
+	0x00000000, /* var[4] */
+	0x00000000, /* var[5] */
+	0x00000000, /* var[6] */
+	0x00000000, /* var[7] */
+	0x00000000, /* var[8] */
+	0x00000000, /* var[9] */
+	0x00000000, /* var[10] */
+	0x00000000, /* var[11] */
+	0x00000000, /* var[12] */
+	0x00000000, /* var[13] */
+	0x00000000, /* var[14] */
+	0x00000000, /* var[15] */
+	0x00000000, /* var[16] */
+	0x00000000, /* var[17] */
+	0x00000000, /* var[18] */
+	0x00000000, /* var[19] */
+	0x00000000, /* var[20] */
+	0x00000000, /* var[21] */
+	0x00000000, /* var[22] */
+	0x00000000, /* var[23] */
+	0xe0000000, /* inc[0] */
+	0x20000000, /* inc[1] */
+	0x2000ffff, /* inc[2] */
+	0x00000000, /* inc[3] */
+	0x00000000, /* inc[4] */
+	0x00000000, /* inc[5] */
+	0x00000000, /* inc[6] */
+	0x00000000, /* inc[7] */
+};
+
+u32 MCD_varTab8[] = {   /* Task 8 Variable Table */
+	0x00000000, /* var[0] */
+	0x00000000, /* var[1] */
+	0x00000000, /* var[2] */
+	0x00000000, /* var[3] */
+	0x00000000, /* var[4] */
+	0x00000000, /* var[5] */
+	0x00000000, /* var[6] */
+	0x00000000, /* var[7] */
+	0x00000000, /* var[8] */
+	0x00000000, /* var[9] */
+	0x00000000, /* var[10] */
+	0x00000000, /* var[11] */
+	0x00000000, /* var[12] */
+	0x00000000, /* var[13] */
+	0x00000000, /* var[14] */
+	0x00000000, /* var[15] */
+	0x00000000, /* var[16] */
+	0x00000000, /* var[17] */
+	0x00000000, /* var[18] */
+	0x00000000, /* var[19] */
+	0x00000000, /* var[20] */
+	0x00000000, /* var[21] */
+	0x00000000, /* var[22] */
+	0x00000000, /* var[23] */
+	0xe0000000, /* inc[0] */
+	0x20000000, /* inc[1] */
+	0x2000ffff, /* inc[2] */
+	0x00000000, /* inc[3] */
+	0x00000000, /* inc[4] */
+	0x00000000, /* inc[5] */
+	0x00000000, /* inc[6] */
+	0x00000000, /* inc[7] */
+};
+
+u32 MCD_varTab9[] = {   /* Task 9 Variable Table */
+	0x00000000, /* var[0] */
+	0x00000000, /* var[1] */
+	0x00000000, /* var[2] */
+	0x00000000, /* var[3] */
+	0x00000000, /* var[4] */
+	0x00000000, /* var[5] */
+	0x00000000, /* var[6] */
+	0x00000000, /* var[7] */
+	0x00000000, /* var[8] */
+	0x00000000, /* var[9] */
+	0x00000000, /* var[10] */
+	0x00000000, /* var[11] */
+	0x00000000, /* var[12] */
+	0x00000000, /* var[13] */
+	0x00000000, /* var[14] */
+	0x00000000, /* var[15] */
+	0x00000000, /* var[16] */
+	0x00000000, /* var[17] */
+	0x00000000, /* var[18] */
+	0x00000000, /* var[19] */
+	0x00000000, /* var[20] */
+	0x00000000, /* var[21] */
+	0x00000000, /* var[22] */
+	0x00000000, /* var[23] */
+	0xe0000000, /* inc[0] */
+	0x20000000, /* inc[1] */
+	0x2000ffff, /* inc[2] */
+	0x00000000, /* inc[3] */
+	0x00000000, /* inc[4] */
+	0x00000000, /* inc[5] */
+	0x00000000, /* inc[6] */
+	0x00000000, /* inc[7] */
+};
+
+u32 MCD_varTab10[] = {   /* Task 10 Variable Table */
+	0x00000000, /* var[0] */
+	0x00000000, /* var[1] */
+	0x00000000, /* var[2] */
+	0x00000000, /* var[3] */
+	0x00000000, /* var[4] */
+	0x00000000, /* var[5] */
+	0x00000000, /* var[6] */
+	0x00000000, /* var[7] */
+	0x00000000, /* var[8] */
+	0x00000000, /* var[9] */
+	0x00000000, /* var[10] */
+	0x00000000, /* var[11] */
+	0x00000000, /* var[12] */
+	0x00000000, /* var[13] */
+	0x00000000, /* var[14] */
+	0x00000000, /* var[15] */
+	0x00000000, /* var[16] */
+	0x00000000, /* var[17] */
+	0x00000000, /* var[18] */
+	0x00000000, /* var[19] */
+	0x00000000, /* var[20] */
+	0x00000000, /* var[21] */
+	0x00000000, /* var[22] */
+	0x00000000, /* var[23] */
+	0xe0000000, /* inc[0] */
+	0x20000000, /* inc[1] */
+	0x2000ffff, /* inc[2] */
+	0x00000000, /* inc[3] */
+	0x00000000, /* inc[4] */
+	0x00000000, /* inc[5] */
+	0x00000000, /* inc[6] */
+	0x00000000, /* inc[7] */
+};
+
+u32 MCD_varTab11[] = {   /* Task 11 Variable Table */
+	0x00000000, /* var[0] */
+	0x00000000, /* var[1] */
+	0x00000000, /* var[2] */
+	0x00000000, /* var[3] */
+	0x00000000, /* var[4] */
+	0x00000000, /* var[5] */
+	0x00000000, /* var[6] */
+	0x00000000, /* var[7] */
+	0x00000000, /* var[8] */
+	0x00000000, /* var[9] */
+	0x00000000, /* var[10] */
+	0x00000000, /* var[11] */
+	0x00000000, /* var[12] */
+	0x00000000, /* var[13] */
+	0x00000000, /* var[14] */
+	0x00000000, /* var[15] */
+	0x00000000, /* var[16] */
+	0x00000000, /* var[17] */
+	0x00000000, /* var[18] */
+	0x00000000, /* var[19] */
+	0x00000000, /* var[20] */
+	0x00000000, /* var[21] */
+	0x00000000, /* var[22] */
+	0x00000000, /* var[23] */
+	0xe0000000, /* inc[0] */
+	0x20000000, /* inc[1] */
+	0x2000ffff, /* inc[2] */
+	0x00000000, /* inc[3] */
+	0x00000000, /* inc[4] */
+	0x00000000, /* inc[5] */
+	0x00000000, /* inc[6] */
+	0x00000000, /* inc[7] */
+};
+
+u32 MCD_varTab12[] = {   /* Task 12 Variable Table */
+	0x00000000, /* var[0] */
+	0x00000000, /* var[1] */
+	0x00000000, /* var[2] */
+	0x00000000, /* var[3] */
+	0x00000000, /* var[4] */
+	0x00000000, /* var[5] */
+	0x00000000, /* var[6] */
+	0x00000000, /* var[7] */
+	0x00000000, /* var[8] */
+	0x00000000, /* var[9] */
+	0x00000000, /* var[10] */
+	0x00000000, /* var[11] */
+	0x00000000, /* var[12] */
+	0x00000000, /* var[13] */
+	0x00000000, /* var[14] */
+	0x00000000, /* var[15] */
+	0x00000000, /* var[16] */
+	0x00000000, /* var[17] */
+	0x00000000, /* var[18] */
+	0x00000000, /* var[19] */
+	0x00000000, /* var[20] */
+	0x00000000, /* var[21] */
+	0x00000000, /* var[22] */
+	0x00000000, /* var[23] */
+	0xe0000000, /* inc[0] */
+	0x20000000, /* inc[1] */
+	0x2000ffff, /* inc[2] */
+	0x00000000, /* inc[3] */
+	0x00000000, /* inc[4] */
+	0x00000000, /* inc[5] */
+	0x00000000, /* inc[6] */
+	0x00000000, /* inc[7] */
+};
+
+u32 MCD_varTab13[] = {   /* Task 13 Variable Table */
+	0x00000000, /* var[0] */
+	0x00000000, /* var[1] */
+	0x00000000, /* var[2] */
+	0x00000000, /* var[3] */
+	0x00000000, /* var[4] */
+	0x00000000, /* var[5] */
+	0x00000000, /* var[6] */
+	0x00000000, /* var[7] */
+	0x00000000, /* var[8] */
+	0x00000000, /* var[9] */
+	0x00000000, /* var[10] */
+	0x00000000, /* var[11] */
+	0x00000000, /* var[12] */
+	0x00000000, /* var[13] */
+	0x00000000, /* var[14] */
+	0x00000000, /* var[15] */
+	0x00000000, /* var[16] */
+	0x00000000, /* var[17] */
+	0x00000000, /* var[18] */
+	0x00000000, /* var[19] */
+	0x00000000, /* var[20] */
+	0x00000000, /* var[21] */
+	0x00000000, /* var[22] */
+	0x00000000, /* var[23] */
+	0xe0000000, /* inc[0] */
+	0x20000000, /* inc[1] */
+	0x2000ffff, /* inc[2] */
+	0x00000000, /* inc[3] */
+	0x00000000, /* inc[4] */
+	0x00000000, /* inc[5] */
+	0x00000000, /* inc[6] */
+	0x00000000, /* inc[7] */
+};
+
+u32 MCD_varTab14[] = {   /* Task 14 Variable Table */
+	0x00000000, /* var[0] */
+	0x00000000, /* var[1] */
+	0x00000000, /* var[2] */
+	0x00000000, /* var[3] */
+	0x00000000, /* var[4] */
+	0x00000000, /* var[5] */
+	0x00000000, /* var[6] */
+	0x00000000, /* var[7] */
+	0x00000000, /* var[8] */
+	0x00000000, /* var[9] */
+	0x00000000, /* var[10] */
+	0x00000000, /* var[11] */
+	0x00000000, /* var[12] */
+	0x00000000, /* var[13] */
+	0x00000000, /* var[14] */
+	0x00000000, /* var[15] */
+	0x00000000, /* var[16] */
+	0x00000000, /* var[17] */
+	0x00000000, /* var[18] */
+	0x00000000, /* var[19] */
+	0x00000000, /* var[20] */
+	0x00000000, /* var[21] */
+	0x00000000, /* var[22] */
+	0x00000000, /* var[23] */
+	0xe0000000, /* inc[0] */
+	0x20000000, /* inc[1] */
+	0x2000ffff, /* inc[2] */
+	0x00000000, /* inc[3] */
+	0x00000000, /* inc[4] */
+	0x00000000, /* inc[5] */
+	0x00000000, /* inc[6] */
+	0x00000000, /* inc[7] */
+};
+
+u32 MCD_varTab15[] = {   /* Task 15 Variable Table */
+	0x00000000, /* var[0] */
+	0x00000000, /* var[1] */
+	0x00000000, /* var[2] */
+	0x00000000, /* var[3] */
+	0x00000000, /* var[4] */
+	0x00000000, /* var[5] */
+	0x00000000, /* var[6] */
+	0x00000000, /* var[7] */
+	0x00000000, /* var[8] */
+	0x00000000, /* var[9] */
+	0x00000000, /* var[10] */
+	0x00000000, /* var[11] */
+	0x00000000, /* var[12] */
+	0x00000000, /* var[13] */
+	0x00000000, /* var[14] */
+	0x00000000, /* var[15] */
+	0x00000000, /* var[16] */
+	0x00000000, /* var[17] */
+	0x00000000, /* var[18] */
+	0x00000000, /* var[19] */
+	0x00000000, /* var[20] */
+	0x00000000, /* var[21] */
+	0x00000000, /* var[22] */
+	0x00000000, /* var[23] */
+	0xe0000000, /* inc[0] */
+	0x20000000, /* inc[1] */
+	0x2000ffff, /* inc[2] */
+	0x00000000, /* inc[3] */
+	0x00000000, /* inc[4] */
+	0x00000000, /* inc[5] */
+	0x00000000, /* inc[6] */
+	0x00000000, /* inc[7] */
+};
+
+u32 MCD_funcDescTab0[] = {   /* Task 0 Function Descriptor Table */
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0xa0045670, /* mainFunc(), EU# 3 */
+	0xa0000000, /* rsduFunc(), EU# 3 */
+	0xa0000000, /* crcAccumVal(), EU# 3 */
+	0x20000000, /* setCrcAccum(), EU# 3 */
+	0x21800000, /* and(), EU# 3 */
+	0x21e00000, /* or(), EU# 3 */
+	0x20400000, /* add(), EU# 3 */
+	0x20500000, /* sub(), EU# 3 */
+	0x205a0000, /* andNot(), EU# 3 */
+	0x20a00000, /* shiftR(), EU# 3 */
+	0x202fa000, /* andReadyBit(), EU# 3 */
+	0x202f9000, /* andNotReadyBit(), EU# 3 */
+	0x202ea000, /* andWrapBit(), EU# 3 */
+	0x202da000, /* andLastBit(), EU# 3 */
+	0x202e2000, /* andInterruptBit(), EU# 3 */
+	0x202f2000, /* andCrcRestartBit(), EU# 3 */
+};
+
+#ifdef MCD_INCLUDE_EU
+u32 MCD_funcDescTab1[] = {   /* Task 1 Function Descriptor Table */
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0xa0045670, /* mainFunc(), EU# 3 */
+	0xa0000000, /* rsduFunc(), EU# 3 */
+	0xa0000000, /* crcAccumVal(), EU# 3 */
+	0x20000000, /* setCrcAccum(), EU# 3 */
+	0x21800000, /* and(), EU# 3 */
+	0x21e00000, /* or(), EU# 3 */
+	0x20400000, /* add(), EU# 3 */
+	0x20500000, /* sub(), EU# 3 */
+	0x205a0000, /* andNot(), EU# 3 */
+	0x20a00000, /* shiftR(), EU# 3 */
+	0x202fa000, /* andReadyBit(), EU# 3 */
+	0x202f9000, /* andNotReadyBit(), EU# 3 */
+	0x202ea000, /* andWrapBit(), EU# 3 */
+	0x202da000, /* andLastBit(), EU# 3 */
+	0x202e2000, /* andInterruptBit(), EU# 3 */
+	0x202f2000, /* andCrcRestartBit(), EU# 3 */
+};
+
+u32 MCD_funcDescTab2[] = {   /* Task 2 Function Descriptor Table */
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0xa0045670, /* mainFunc(), EU# 3 */
+	0xa0000000, /* rsduFunc(), EU# 3 */
+	0xa0000000, /* crcAccumVal(), EU# 3 */
+	0x20000000, /* setCrcAccum(), EU# 3 */
+	0x21800000, /* and(), EU# 3 */
+	0x21e00000, /* or(), EU# 3 */
+	0x20400000, /* add(), EU# 3 */
+	0x20500000, /* sub(), EU# 3 */
+	0x205a0000, /* andNot(), EU# 3 */
+	0x20a00000, /* shiftR(), EU# 3 */
+	0x202fa000, /* andReadyBit(), EU# 3 */
+	0x202f9000, /* andNotReadyBit(), EU# 3 */
+	0x202ea000, /* andWrapBit(), EU# 3 */
+	0x202da000, /* andLastBit(), EU# 3 */
+	0x202e2000, /* andInterruptBit(), EU# 3 */
+	0x202f2000, /* andCrcRestartBit(), EU# 3 */
+};
+
+u32 MCD_funcDescTab3[] = {   /* Task 3 Function Descriptor Table */
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0xa0045670, /* mainFunc(), EU# 3 */
+	0xa0000000, /* rsduFunc(), EU# 3 */
+	0xa0000000, /* crcAccumVal(), EU# 3 */
+	0x20000000, /* setCrcAccum(), EU# 3 */
+	0x21800000, /* and(), EU# 3 */
+	0x21e00000, /* or(), EU# 3 */
+	0x20400000, /* add(), EU# 3 */
+	0x20500000, /* sub(), EU# 3 */
+	0x205a0000, /* andNot(), EU# 3 */
+	0x20a00000, /* shiftR(), EU# 3 */
+	0x202fa000, /* andReadyBit(), EU# 3 */
+	0x202f9000, /* andNotReadyBit(), EU# 3 */
+	0x202ea000, /* andWrapBit(), EU# 3 */
+	0x202da000, /* andLastBit(), EU# 3 */
+	0x202e2000, /* andInterruptBit(), EU# 3 */
+	0x202f2000, /* andCrcRestartBit(), EU# 3 */
+};
+
+u32 MCD_funcDescTab4[] = {   /* Task 4 Function Descriptor Table */
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0xa0045670, /* mainFunc(), EU# 3 */
+	0xa0000000, /* rsduFunc(), EU# 3 */
+	0xa0000000, /* crcAccumVal(), EU# 3 */
+	0x20000000, /* setCrcAccum(), EU# 3 */
+	0x21800000, /* and(), EU# 3 */
+	0x21e00000, /* or(), EU# 3 */
+	0x20400000, /* add(), EU# 3 */
+	0x20500000, /* sub(), EU# 3 */
+	0x205a0000, /* andNot(), EU# 3 */
+	0x20a00000, /* shiftR(), EU# 3 */
+	0x202fa000, /* andReadyBit(), EU# 3 */
+	0x202f9000, /* andNotReadyBit(), EU# 3 */
+	0x202ea000, /* andWrapBit(), EU# 3 */
+	0x202da000, /* andLastBit(), EU# 3 */
+	0x202e2000, /* andInterruptBit(), EU# 3 */
+	0x202f2000, /* andCrcRestartBit(), EU# 3 */
+};
+
+u32 MCD_funcDescTab5[] = {   /* Task 5 Function Descriptor Table */
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0xa0045670, /* mainFunc(), EU# 3 */
+	0xa0000000, /* rsduFunc(), EU# 3 */
+	0xa0000000, /* crcAccumVal(), EU# 3 */
+	0x20000000, /* setCrcAccum(), EU# 3 */
+	0x21800000, /* and(), EU# 3 */
+	0x21e00000, /* or(), EU# 3 */
+	0x20400000, /* add(), EU# 3 */
+	0x20500000, /* sub(), EU# 3 */
+	0x205a0000, /* andNot(), EU# 3 */
+	0x20a00000, /* shiftR(), EU# 3 */
+	0x202fa000, /* andReadyBit(), EU# 3 */
+	0x202f9000, /* andNotReadyBit(), EU# 3 */
+	0x202ea000, /* andWrapBit(), EU# 3 */
+	0x202da000, /* andLastBit(), EU# 3 */
+	0x202e2000, /* andInterruptBit(), EU# 3 */
+	0x202f2000, /* andCrcRestartBit(), EU# 3 */
+};
+
+u32 MCD_funcDescTab6[] = {   /* Task 6 Function Descriptor Table */
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0xa0045670, /* mainFunc(), EU# 3 */
+	0xa0000000, /* rsduFunc(), EU# 3 */
+	0xa0000000, /* crcAccumVal(), EU# 3 */
+	0x20000000, /* setCrcAccum(), EU# 3 */
+	0x21800000, /* and(), EU# 3 */
+	0x21e00000, /* or(), EU# 3 */
+	0x20400000, /* add(), EU# 3 */
+	0x20500000, /* sub(), EU# 3 */
+	0x205a0000, /* andNot(), EU# 3 */
+	0x20a00000, /* shiftR(), EU# 3 */
+	0x202fa000, /* andReadyBit(), EU# 3 */
+	0x202f9000, /* andNotReadyBit(), EU# 3 */
+	0x202ea000, /* andWrapBit(), EU# 3 */
+	0x202da000, /* andLastBit(), EU# 3 */
+	0x202e2000, /* andInterruptBit(), EU# 3 */
+	0x202f2000, /* andCrcRestartBit(), EU# 3 */
+};
+
+u32 MCD_funcDescTab7[] = {   /* Task 7 Function Descriptor Table */
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0xa0045670, /* mainFunc(), EU# 3 */
+	0xa0000000, /* rsduFunc(), EU# 3 */
+	0xa0000000, /* crcAccumVal(), EU# 3 */
+	0x20000000, /* setCrcAccum(), EU# 3 */
+	0x21800000, /* and(), EU# 3 */
+	0x21e00000, /* or(), EU# 3 */
+	0x20400000, /* add(), EU# 3 */
+	0x20500000, /* sub(), EU# 3 */
+	0x205a0000, /* andNot(), EU# 3 */
+	0x20a00000, /* shiftR(), EU# 3 */
+	0x202fa000, /* andReadyBit(), EU# 3 */
+	0x202f9000, /* andNotReadyBit(), EU# 3 */
+	0x202ea000, /* andWrapBit(), EU# 3 */
+	0x202da000, /* andLastBit(), EU# 3 */
+	0x202e2000, /* andInterruptBit(), EU# 3 */
+	0x202f2000, /* andCrcRestartBit(), EU# 3 */
+};
+
+u32 MCD_funcDescTab8[] = {   /* Task 8 Function Descriptor Table */
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0xa0045670, /* mainFunc(), EU# 3 */
+	0xa0000000, /* rsduFunc(), EU# 3 */
+	0xa0000000, /* crcAccumVal(), EU# 3 */
+	0x20000000, /* setCrcAccum(), EU# 3 */
+	0x21800000, /* and(), EU# 3 */
+	0x21e00000, /* or(), EU# 3 */
+	0x20400000, /* add(), EU# 3 */
+	0x20500000, /* sub(), EU# 3 */
+	0x205a0000, /* andNot(), EU# 3 */
+	0x20a00000, /* shiftR(), EU# 3 */
+	0x202fa000, /* andReadyBit(), EU# 3 */
+	0x202f9000, /* andNotReadyBit(), EU# 3 */
+	0x202ea000, /* andWrapBit(), EU# 3 */
+	0x202da000, /* andLastBit(), EU# 3 */
+	0x202e2000, /* andInterruptBit(), EU# 3 */
+	0x202f2000, /* andCrcRestartBit(), EU# 3 */
+};
+
+u32 MCD_funcDescTab9[] = {   /* Task 9 Function Descriptor Table */
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0xa0045670, /* mainFunc(), EU# 3 */
+	0xa0000000, /* rsduFunc(), EU# 3 */
+	0xa0000000, /* crcAccumVal(), EU# 3 */
+	0x20000000, /* setCrcAccum(), EU# 3 */
+	0x21800000, /* and(), EU# 3 */
+	0x21e00000, /* or(), EU# 3 */
+	0x20400000, /* add(), EU# 3 */
+	0x20500000, /* sub(), EU# 3 */
+	0x205a0000, /* andNot(), EU# 3 */
+	0x20a00000, /* shiftR(), EU# 3 */
+	0x202fa000, /* andReadyBit(), EU# 3 */
+	0x202f9000, /* andNotReadyBit(), EU# 3 */
+	0x202ea000, /* andWrapBit(), EU# 3 */
+	0x202da000, /* andLastBit(), EU# 3 */
+	0x202e2000, /* andInterruptBit(), EU# 3 */
+	0x202f2000, /* andCrcRestartBit(), EU# 3 */
+};
+
+u32 MCD_funcDescTab10[] = {   /* Task 10 Function Descriptor Table */
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0xa0045670, /* mainFunc(), EU# 3 */
+	0xa0000000, /* rsduFunc(), EU# 3 */
+	0xa0000000, /* crcAccumVal(), EU# 3 */
+	0x20000000, /* setCrcAccum(), EU# 3 */
+	0x21800000, /* and(), EU# 3 */
+	0x21e00000, /* or(), EU# 3 */
+	0x20400000, /* add(), EU# 3 */
+	0x20500000, /* sub(), EU# 3 */
+	0x205a0000, /* andNot(), EU# 3 */
+	0x20a00000, /* shiftR(), EU# 3 */
+	0x202fa000, /* andReadyBit(), EU# 3 */
+	0x202f9000, /* andNotReadyBit(), EU# 3 */
+	0x202ea000, /* andWrapBit(), EU# 3 */
+	0x202da000, /* andLastBit(), EU# 3 */
+	0x202e2000, /* andInterruptBit(), EU# 3 */
+	0x202f2000, /* andCrcRestartBit(), EU# 3 */
+};
+
+u32 MCD_funcDescTab11[] = {   /* Task 11 Function Descriptor Table */
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0xa0045670, /* mainFunc(), EU# 3 */
+	0xa0000000, /* rsduFunc(), EU# 3 */
+	0xa0000000, /* crcAccumVal(), EU# 3 */
+	0x20000000, /* setCrcAccum(), EU# 3 */
+	0x21800000, /* and(), EU# 3 */
+	0x21e00000, /* or(), EU# 3 */
+	0x20400000, /* add(), EU# 3 */
+	0x20500000, /* sub(), EU# 3 */
+	0x205a0000, /* andNot(), EU# 3 */
+	0x20a00000, /* shiftR(), EU# 3 */
+	0x202fa000, /* andReadyBit(), EU# 3 */
+	0x202f9000, /* andNotReadyBit(), EU# 3 */
+	0x202ea000, /* andWrapBit(), EU# 3 */
+	0x202da000, /* andLastBit(), EU# 3 */
+	0x202e2000, /* andInterruptBit(), EU# 3 */
+	0x202f2000, /* andCrcRestartBit(), EU# 3 */
+};
+
+u32 MCD_funcDescTab12[] = {   /* Task 12 Function Descriptor Table */
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0xa0045670, /* mainFunc(), EU# 3 */
+	0xa0000000, /* rsduFunc(), EU# 3 */
+	0xa0000000, /* crcAccumVal(), EU# 3 */
+	0x20000000, /* setCrcAccum(), EU# 3 */
+	0x21800000, /* and(), EU# 3 */
+	0x21e00000, /* or(), EU# 3 */
+	0x20400000, /* add(), EU# 3 */
+	0x20500000, /* sub(), EU# 3 */
+	0x205a0000, /* andNot(), EU# 3 */
+	0x20a00000, /* shiftR(), EU# 3 */
+	0x202fa000, /* andReadyBit(), EU# 3 */
+	0x202f9000, /* andNotReadyBit(), EU# 3 */
+	0x202ea000, /* andWrapBit(), EU# 3 */
+	0x202da000, /* andLastBit(), EU# 3 */
+	0x202e2000, /* andInterruptBit(), EU# 3 */
+	0x202f2000, /* andCrcRestartBit(), EU# 3 */
+};
+
+u32 MCD_funcDescTab13[] = {   /* Task 13 Function Descriptor Table */
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0xa0045670, /* mainFunc(), EU# 3 */
+	0xa0000000, /* rsduFunc(), EU# 3 */
+	0xa0000000, /* crcAccumVal(), EU# 3 */
+	0x20000000, /* setCrcAccum(), EU# 3 */
+	0x21800000, /* and(), EU# 3 */
+	0x21e00000, /* or(), EU# 3 */
+	0x20400000, /* add(), EU# 3 */
+	0x20500000, /* sub(), EU# 3 */
+	0x205a0000, /* andNot(), EU# 3 */
+	0x20a00000, /* shiftR(), EU# 3 */
+	0x202fa000, /* andReadyBit(), EU# 3 */
+	0x202f9000, /* andNotReadyBit(), EU# 3 */
+	0x202ea000, /* andWrapBit(), EU# 3 */
+	0x202da000, /* andLastBit(), EU# 3 */
+	0x202e2000, /* andInterruptBit(), EU# 3 */
+	0x202f2000, /* andCrcRestartBit(), EU# 3 */
+};
+
+u32 MCD_funcDescTab14[] = {   /* Task 14 Function Descriptor Table */
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0xa0045670, /* mainFunc(), EU# 3 */
+	0xa0000000, /* rsduFunc(), EU# 3 */
+	0xa0000000, /* crcAccumVal(), EU# 3 */
+	0x20000000, /* setCrcAccum(), EU# 3 */
+	0x21800000, /* and(), EU# 3 */
+	0x21e00000, /* or(), EU# 3 */
+	0x20400000, /* add(), EU# 3 */
+	0x20500000, /* sub(), EU# 3 */
+	0x205a0000, /* andNot(), EU# 3 */
+	0x20a00000, /* shiftR(), EU# 3 */
+	0x202fa000, /* andReadyBit(), EU# 3 */
+	0x202f9000, /* andNotReadyBit(), EU# 3 */
+	0x202ea000, /* andWrapBit(), EU# 3 */
+	0x202da000, /* andLastBit(), EU# 3 */
+	0x202e2000, /* andInterruptBit(), EU# 3 */
+	0x202f2000, /* andCrcRestartBit(), EU# 3 */
+};
+
+u32 MCD_funcDescTab15[] = {   /* Task 15 Function Descriptor Table */
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0xa0045670, /* mainFunc(), EU# 3 */
+	0xa0000000, /* rsduFunc(), EU# 3 */
+	0xa0000000, /* crcAccumVal(), EU# 3 */
+	0x20000000, /* setCrcAccum(), EU# 3 */
+	0x21800000, /* and(), EU# 3 */
+	0x21e00000, /* or(), EU# 3 */
+	0x20400000, /* add(), EU# 3 */
+	0x20500000, /* sub(), EU# 3 */
+	0x205a0000, /* andNot(), EU# 3 */
+	0x20a00000, /* shiftR(), EU# 3 */
+	0x202fa000, /* andReadyBit(), EU# 3 */
+	0x202f9000, /* andNotReadyBit(), EU# 3 */
+	0x202ea000, /* andWrapBit(), EU# 3 */
+	0x202da000, /* andLastBit(), EU# 3 */
+	0x202e2000, /* andInterruptBit(), EU# 3 */
+	0x202f2000, /* andCrcRestartBit(), EU# 3 */
+};
+#endif /*MCD_INCLUDE_EU*/
+
+u32 MCD_contextSave0[128];  /* Task 0 context save space */
+u32 MCD_contextSave1[128];  /* Task 1 context save space */
+u32 MCD_contextSave2[128];  /* Task 2 context save space */
+u32 MCD_contextSave3[128];  /* Task 3 context save space */
+u32 MCD_contextSave4[128];  /* Task 4 context save space */
+u32 MCD_contextSave5[128];  /* Task 5 context save space */
+u32 MCD_contextSave6[128];  /* Task 6 context save space */
+u32 MCD_contextSave7[128];  /* Task 7 context save space */
+u32 MCD_contextSave8[128];  /* Task 8 context save space */
+u32 MCD_contextSave9[128];  /* Task 9 context save space */
+u32 MCD_contextSave10[128]; /* Task 10 context save space */
+u32 MCD_contextSave11[128]; /* Task 11 context save space */
+u32 MCD_contextSave12[128]; /* Task 12 context save space */
+u32 MCD_contextSave13[128]; /* Task 13 context save space */
+u32 MCD_contextSave14[128]; /* Task 14 context save space */
+u32 MCD_contextSave15[128]; /* Task 15 context save space */
+
+u32 MCD_ChainNoEu_TDT[];
+u32 MCD_SingleNoEu_TDT[];
+#ifdef MCD_INCLUDE_EU
+u32 MCD_ChainEu_TDT[];
+u32 MCD_SingleEu_TDT[];
+#endif
+u32 MCD_ENetRcv_TDT[];
+u32 MCD_ENetXmit_TDT[];
+
+const u32 MCD_modelTaskTableSrc[] = {
+	(u32)MCD_ChainNoEu_TDT,
+	(u32)&((u8 *)MCD_ChainNoEu_TDT)[0x0000016c],
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	(u32)MCD_SingleNoEu_TDT,
+	(u32)&((u8 *)MCD_SingleNoEu_TDT)[0x000000d4],
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+#ifdef MCD_INCLUDE_EU
+	(u32)MCD_ChainEu_TDT,
+	(u32)&((u8 *)MCD_ChainEu_TDT)[0x000001b4],
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	(u32)MCD_SingleEu_TDT,
+	(u32)&((u8 *)MCD_SingleEu_TDT)[0x00000124],
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+#endif
+	(u32)MCD_ENetRcv_TDT,
+	(u32)&((u8 *)MCD_ENetRcv_TDT)[0x000000a4],
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	(u32)MCD_ENetXmit_TDT,
+	(u32)&((u8 *)MCD_ENetXmit_TDT)[0x000000d0],
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+};
+u32 MCD_ChainNoEu_TDT[] = {
+	0x80004000, /* 0000(:370):  LCDEXT: idx0 = 0x00000000; ; */
+	0x8118801b, /* 0004(:370):  LCD: idx1 = var2; idx1 once var0; idx1 += inc3 */
+	0xb8c60018, /* 0008(:371):    LCD: idx2 = *(idx1 + var12); idx2 once var0; idx2 += inc3 */
+	0x10002b10, /* 000C(:372):      DRD1A: var10 = idx2; FN=0 MORE init=0 WS=0 RS=0 */
+	0x7000000d, /* 0010(:373):      DRD2A: EU0=0 EU1=0 EU2=0 EU3=13 EXT MORE init=0 WS=0 RS=0 */
+	0x018cf89f, /* 0014(:373):      DRD2B1: var6 = EU3(); EU3(idx2)  */
+	0x6000000a, /* 0018(:374):      DRD2A: EU0=0 EU1=0 EU2=0 EU3=10 EXT init=0 WS=0 RS=0 */
+	0x080cf89f, /* 001C(:374):      DRD2B1: idx0 = EU3(); EU3(idx2)  */
+	0x000001f8, /* 0020(:0):    NOP */
+	0x98180364, /* 0024(:378):  LCD: idx0 = idx0; idx0 == var13; idx0 += inc4 */
+	0x8118801b, /* 0028(:380):    LCD: idx1 = var2; idx1 once var0; idx1 += inc3 */
+	0xf8c6001a, /* 002C(:381):      LCDEXT: idx2 = *(idx1 + var12 + 8); idx2 once var0; idx2 += inc3 */
+	0xb8c6601b, /* 0030(:382):      LCD: idx3 = *(idx1 + var12 + 12); ; idx3 += inc3 */
+	0x10002710, /* 0034(:384):        DRD1A: var9 = idx2; FN=0 MORE init=0 WS=0 RS=0 */
+	0x00000f18, /* 0038(:385):        DRD1A: var3 = idx3; FN=0 init=0 WS=0 RS=0 */
+	0xb8c6001d, /* 003C(:387):      LCD: idx2 = *(idx1 + var12 + 20); idx2 once var0; idx2 += inc3 */
+	0x10001310, /* 0040(:388):        DRD1A: var4 = idx2; FN=0 MORE init=0 WS=0 RS=0 */
+	0x60000007, /* 0044(:389):        DRD2A: EU0=0 EU1=0 EU2=0 EU3=7 EXT init=0 WS=0 RS=0 */
+	0x014cf88b, /* 0048(:389):        DRD2B1: var5 = EU3(); EU3(idx2,var11)  */
+	0x98c6001c, /* 004C(:391):      LCD: idx2 = idx1 + var12 + 4; idx2 once var0; idx2 += inc3 */
+	0x00000710, /* 0050(:392):        DRD1A: var1 = idx2; FN=0 init=0 WS=0 RS=0 */
+	0x98c70018, /* 0054(:393):      LCD: idx2 = idx1 + var14; idx2 once var0; idx2 += inc3 */
+	0x10001f10, /* 0058(:394):        DRD1A: var7 = idx2; FN=0 MORE init=0 WS=0 RS=0 */
+	0x0000c818, /* 005C(:395):        DRD1A: *idx2 = var3; FN=0 init=0 WS=0 RS=0 */
+	0x000001f8, /* 0060(:0):      NOP */
+	0xc1476018, /* 0064(:399):    LCDEXT: idx1 = var2 + var14; ; idx1 += inc3 */
+	0xc003231d, /* 0068(:399):    LCDEXT: idx2 = var0, idx3 = var6; idx3 == var12; idx2 += inc3, idx3 += inc5 */
+	0x811a601b, /* 006C(:400):    LCD: idx4 = var2; ; idx4 += inc3 */
+	0xc1862102, /* 0070(:403):      LCDEXT: idx5 = var3, idx6 = var12; idx6 < var4; idx5 += inc0, idx6 += inc2 */
+	0x849be009, /* 0074(:403):      LCD: idx7 = var9; ; idx7 += inc1 */
+	0x03fed7b8, /* 0078(:406):        DRD1A: *idx7; FN=0 init=31 WS=3 RS=3 */
+	0xda9b001b, /* 007C(:408):      LCDEXT: idx5 = idx5, idx6 = idx6; idx5 once var0; idx5 += inc3, idx6 += inc3 */
+	0x9b9be01b, /* 0080(:408):      LCD: idx7 = idx7; ; idx7 += inc3 */
+	0x1000cb20, /* 0084(:409):        DRD1A: *idx2 = idx4; FN=0 MORE init=0 WS=0 RS=0 */
+	0x70000006, /* 0088(:410):        DRD2A: EU0=0 EU1=0 EU2=0 EU3=6 EXT MORE init=0 WS=0 RS=0 */
+	0x088cf88f, /* 008C(:410):        DRD2B1: idx2 = EU3(); EU3(idx2,var15)  */
+	0x1000cb28, /* 0090(:411):        DRD1A: *idx2 = idx5; FN=0 MORE init=0 WS=0 RS=0 */
+	0x70000006, /* 0094(:412):        DRD2A: EU0=0 EU1=0 EU2=0 EU3=6 EXT MORE init=0 WS=0 RS=0 */
+	0x088cf88f, /* 0098(:412):        DRD2B1: idx2 = EU3(); EU3(idx2,var15)  */
+	0x1000cb30, /* 009C(:413):        DRD1A: *idx2 = idx6; FN=0 MORE init=0 WS=0 RS=0 */
+	0x70000006, /* 00A0(:414):        DRD2A: EU0=0 EU1=0 EU2=0 EU3=6 EXT MORE init=0 WS=0 RS=0 */
+	0x088cf88f, /* 00A4(:414):        DRD2B1: idx2 = EU3(); EU3(idx2,var15)  */
+	0x1000cb38, /* 00A8(:415):        DRD1A: *idx2 = idx7; FN=0 MORE init=0 WS=0 RS=0 */
+	0x0000c728, /* 00AC(:416):        DRD1A: *idx1 = idx5; FN=0 init=0 WS=0 RS=0 */
+	0x000001f8, /* 00B0(:0):      NOP */
+	0xc1476018, /* 00B4(:420):    LCDEXT: idx1 = var2 + var14; ; idx1 += inc3 */
+	0xc003241d, /* 00B8(:420):    LCDEXT: idx2 = var0, idx3 = var6; idx3 == var16; idx2 += inc3, idx3 += inc5 */
+	0x811a601b, /* 00BC(:421):    LCD: idx4 = var2; ; idx4 += inc3 */
+	0xda9b001b, /* 00C0(:424):      LCDEXT: idx5 = idx5, idx6 = idx6; idx5 once var0; idx5 += inc3, idx6 += inc3 */
+	0x9b9be01b, /* 00C4(:424):      LCD: idx7 = idx7; ; idx7 += inc3 */
+	0x0000d3a0, /* 00C8(:425):        DRD1A: *idx4; FN=0 init=0 WS=0 RS=0 */
+	0xc1862102, /* 00CC(:427):      LCDEXT: idx5 = var3, idx6 = var12; idx6 < var4; idx5 += inc0, idx6 += inc2 */
+	0x849be009, /* 00D0(:427):      LCD: idx7 = var9; ; idx7 += inc1 */
+	0x0bfed7b8, /* 00D4(:430):        DRD1A: *idx7; FN=0 TFD init=31 WS=3 RS=3 */
+	0xda9b001b, /* 00D8(:432):      LCDEXT: idx5 = idx5, idx6 = idx6; idx5 once var0; idx5 += inc3, idx6 += inc3 */
+	0x9b9be01b, /* 00DC(:432):      LCD: idx7 = idx7; ; idx7 += inc3 */
+	0x1000cb20, /* 00E0(:433):        DRD1A: *idx2 = idx4; FN=0 MORE init=0 WS=0 RS=0 */
+	0x70000006, /* 00E4(:434):        DRD2A: EU0=0 EU1=0 EU2=0 EU3=6 EXT MORE init=0 WS=0 RS=0 */
+	0x088cf88f, /* 00E8(:434):        DRD2B1: idx2 = EU3(); EU3(idx2,var15)  */
+	0x1000cb28, /* 00EC(:435):        DRD1A: *idx2 = idx5; FN=0 MORE init=0 WS=0 RS=0 */
+	0x70000006, /* 00F0(:436):        DRD2A: EU0=0 EU1=0 EU2=0 EU3=6 EXT MORE init=0 WS=0 RS=0 */
+	0x088cf88f, /* 00F4(:436):        DRD2B1: idx2 = EU3(); EU3(idx2,var15)  */
+	0x1000cb30, /* 00F8(:437):        DRD1A: *idx2 = idx6; FN=0 MORE init=0 WS=0 RS=0 */
+	0x70000006, /* 00FC(:438):        DRD2A: EU0=0 EU1=0 EU2=0 EU3=6 EXT MORE init=0 WS=0 RS=0 */
+	0x088cf88f, /* 0100(:438):        DRD2B1: idx2 = EU3(); EU3(idx2,var15)  */
+	0x1000cb38, /* 0104(:439):        DRD1A: *idx2 = idx7; FN=0 MORE init=0 WS=0 RS=0 */
+	0x0000c728, /* 0108(:440):        DRD1A: *idx1 = idx5; FN=0 init=0 WS=0 RS=0 */
+	0x000001f8, /* 010C(:0):      NOP */
+	0x8118801b, /* 0110(:444):    LCD: idx1 = var2; idx1 once var0; idx1 += inc3 */
+	0xd8c60018, /* 0114(:446):      LCDEXT: idx2 = idx1 + var12; idx2 once var0; idx2 += inc3 */
+	0x98c6601c, /* 0118(:446):      LCD: idx3 = idx1 + var12 + 4; ; idx3 += inc3 */
+	0x6000000b, /* 011C(:447):        DRD2A: EU0=0 EU1=0 EU2=0 EU3=11 EXT init=0 WS=0 RS=0 */
+	0x0c8cfc9f, /* 0120(:447):        DRD2B1: *idx2 = EU3(); EU3(*idx2)  */
+	0x000001f8, /* 0124(:0):      NOP */
+	0xa146001e, /* 0128(:450):    LCD: idx1 = *(var2 + var12 + 24); idx1 once var0; idx1 += inc3 */
+	0x10000b08, /* 012C(:451):      DRD1A: var2 = idx1; FN=0 MORE init=0 WS=0 RS=0 */
+	0x10002050, /* 0130(:452):      DRD1A: var8 = var10; FN=0 MORE init=0 WS=0 RS=0 */
+	0xb8c60018, /* 0134(:453):      LCD: idx2 = *(idx1 + var12); idx2 once var0; idx2 += inc3 */
+	0x10002b10, /* 0138(:454):        DRD1A: var10 = idx2; FN=0 MORE init=0 WS=0 RS=0 */
+	0x7000000a, /* 013C(:455):        DRD2A: EU0=0 EU1=0 EU2=0 EU3=10 EXT MORE init=0 WS=0 RS=0 */
+	0x080cf89f, /* 0140(:455):        DRD2B1: idx0 = EU3(); EU3(idx2)  */
+	0x6000000d, /* 0144(:456):        DRD2A: EU0=0 EU1=0 EU2=0 EU3=13 EXT init=0 WS=0 RS=0 */
+	0x018cf89f, /* 0148(:456):        DRD2B1: var6 = EU3(); EU3(idx2)  */
+	0x000001f8, /* 014C(:0):      NOP */
+	0x8618801b, /* 0150(:462):    LCD: idx1 = var12; idx1 once var0; idx1 += inc3 */
+	0x7000000e, /* 0154(:463):      DRD2A: EU0=0 EU1=0 EU2=0 EU3=14 EXT MORE init=0 WS=0 RS=0 */
+	0x084cf21f, /* 0158(:463):      DRD2B1: idx1 = EU3(); EU3(var8)  */
+	0xd8990336, /* 015C(:464):      LCDEXT: idx2 = idx1; idx2 > var12; idx2 += inc6 */
+	0x8019801b, /* 0160(:464):      LCD: idx3 = var0; idx3 once var0; idx3 += inc3 */
+	0x040001f8, /* 0164(:465):        DRD1A: FN=0 INT init=0 WS=0 RS=0 */
+	0x000001f8, /* 0168(:0):      NOP */
+	0x000001f8, /* 016C(:0):    NOP */
+};
+u32 MCD_SingleNoEu_TDT[] = {
+	0x8198001b, /* 0000(:657):  LCD: idx0 = var3; idx0 once var0; idx0 += inc3 */
+	0x7000000d, /* 0004(:658):    DRD2A: EU0=0 EU1=0 EU2=0 EU3=13 EXT MORE init=0 WS=0 RS=0 */
+	0x080cf81f, /* 0008(:658):    DRD2B1: idx0 = EU3(); EU3(idx0)  */
+	0x8198801b, /* 000C(:659):    LCD: idx1 = var3; idx1 once var0; idx1 += inc3 */
+	0x6000000e, /* 0010(:660):      DRD2A: EU0=0 EU1=0 EU2=0 EU3=14 EXT init=0 WS=0 RS=0 */
+	0x084cf85f, /* 0014(:660):      DRD2B1: idx1 = EU3(); EU3(idx1)  */
+	0x000001f8, /* 0018(:0):    NOP */
+	0x8298001b, /* 001C(:664):  LCD: idx0 = var5; idx0 once var0; idx0 += inc3 */
+	0x7000000d, /* 0020(:665):    DRD2A: EU0=0 EU1=0 EU2=0 EU3=13 EXT MORE init=0 WS=0 RS=0 */
+	0x010cf81f, /* 0024(:665):    DRD2B1: var4 = EU3(); EU3(idx0)  */
+	0x6000000e, /* 0028(:666):    DRD2A: EU0=0 EU1=0 EU2=0 EU3=14 EXT init=0 WS=0 RS=0 */
+	0x018cf81f, /* 002C(:666):    DRD2B1: var6 = EU3(); EU3(idx0)  */
+	0xc202601b, /* 0030(:669):  LCDEXT: idx0 = var4, idx1 = var4; ; idx0 += inc3, idx1 += inc3 */
+	0xc002221c, /* 0034(:669):  LCDEXT: idx2 = var0, idx3 = var4; idx3 == var8; idx2 += inc3, idx3 += inc4 */
+	0x809a601b, /* 0038(:670):  LCD: idx4 = var1; ; idx4 += inc3 */
+	0xc10420c2, /* 003C(:673):    LCDEXT: idx5 = var2, idx6 = var8; idx6 < var3; idx5 += inc0, idx6 += inc2 */
+	0x839be009, /* 0040(:673):    LCD: idx7 = var7; ; idx7 += inc1 */
+	0x03fed7b8, /* 0044(:676):      DRD1A: *idx7; FN=0 init=31 WS=3 RS=3 */
+	0xda9b001b, /* 0048(:678):    LCDEXT: idx5 = idx5, idx6 = idx6; idx5 once var0; idx5 += inc3, idx6 += inc3 */
+	0x9b9be01b, /* 004C(:678):    LCD: idx7 = idx7; ; idx7 += inc3 */
+	0x70000006, /* 0050(:680):      DRD2A: EU0=0 EU1=0 EU2=0 EU3=6 EXT MORE init=0 WS=0 RS=0 */
+	0x088cf889, /* 0054(:680):      DRD2B1: idx2 = EU3(); EU3(idx2,var9)  */
+	0x1000cb28, /* 0058(:681):      DRD1A: *idx2 = idx5; FN=0 MORE init=0 WS=0 RS=0 */
+	0x70000006, /* 005C(:682):      DRD2A: EU0=0 EU1=0 EU2=0 EU3=6 EXT MORE init=0 WS=0 RS=0 */
+	0x088cf889, /* 0060(:682):      DRD2B1: idx2 = EU3(); EU3(idx2,var9)  */
+	0x1000cb30, /* 0064(:683):      DRD1A: *idx2 = idx6; FN=0 MORE init=0 WS=0 RS=0 */
+	0x70000006, /* 0068(:684):      DRD2A: EU0=0 EU1=0 EU2=0 EU3=6 EXT MORE init=0 WS=0 RS=0 */
+	0x088cf889, /* 006C(:684):      DRD2B1: idx2 = EU3(); EU3(idx2,var9)  */
+	0x0000cb38, /* 0070(:685):      DRD1A: *idx2 = idx7; FN=0 init=0 WS=0 RS=0 */
+	0x000001f8, /* 0074(:0):    NOP */
+	0xc202601b, /* 0078(:689):  LCDEXT: idx0 = var4, idx1 = var4; ; idx0 += inc3, idx1 += inc3 */
+	0xc002229c, /* 007C(:689):  LCDEXT: idx2 = var0, idx3 = var4; idx3 == var10; idx2 += inc3, idx3 += inc4 */
+	0x809a601b, /* 0080(:690):  LCD: idx4 = var1; ; idx4 += inc3 */
+	0xda9b001b, /* 0084(:693):    LCDEXT: idx5 = idx5, idx6 = idx6; idx5 once var0; idx5 += inc3, idx6 += inc3 */
+	0x9b9be01b, /* 0088(:693):    LCD: idx7 = idx7; ; idx7 += inc3 */
+	0x0000d3a0, /* 008C(:694):      DRD1A: *idx4; FN=0 init=0 WS=0 RS=0 */
+	0xc10420c2, /* 0090(:696):    LCDEXT: idx5 = var2, idx6 = var8; idx6 < var3; idx5 += inc0, idx6 += inc2 */
+	0x839be009, /* 0094(:696):    LCD: idx7 = var7; ; idx7 += inc1 */
+	0x0bfed7b8, /* 0098(:699):      DRD1A: *idx7; FN=0 TFD init=31 WS=3 RS=3 */
+	0xda9b001b, /* 009C(:701):    LCDEXT: idx5 = idx5, idx6 = idx6; idx5 once var0; idx5 += inc3, idx6 += inc3 */
+	0x9b9be01b, /* 00A0(:701):    LCD: idx7 = idx7; ; idx7 += inc3 */
+	0x70000006, /* 00A4(:703):      DRD2A: EU0=0 EU1=0 EU2=0 EU3=6 EXT MORE init=0 WS=0 RS=0 */
+	0x088cf889, /* 00A8(:703):      DRD2B1: idx2 = EU3(); EU3(idx2,var9)  */
+	0x1000cb28, /* 00AC(:704):      DRD1A: *idx2 = idx5; FN=0 MORE init=0 WS=0 RS=0 */
+	0x70000006, /* 00B0(:705):      DRD2A: EU0=0 EU1=0 EU2=0 EU3=6 EXT MORE init=0 WS=0 RS=0 */
+	0x088cf889, /* 00B4(:705):      DRD2B1: idx2 = EU3(); EU3(idx2,var9)  */
+	0x1000cb30, /* 00B8(:706):      DRD1A: *idx2 = idx6; FN=0 MORE init=0 WS=0 RS=0 */
+	0x70000006, /* 00BC(:707):      DRD2A: EU0=0 EU1=0 EU2=0 EU3=6 EXT MORE init=0 WS=0 RS=0 */
+	0x088cf889, /* 00C0(:707):      DRD2B1: idx2 = EU3(); EU3(idx2,var9)  */
+	0x0000cb38, /* 00C4(:708):      DRD1A: *idx2 = idx7; FN=0 init=0 WS=0 RS=0 */
+	0x000001f8, /* 00C8(:0):    NOP */
+	0xc318022d, /* 00CC(:712):  LCDEXT: idx0 = var6; idx0 > var8; idx0 += inc5 */
+	0x8018801b, /* 00D0(:712):  LCD: idx1 = var0; idx1 once var0; idx1 += inc3 */
+	0x040001f8, /* 00D4(:713):    DRD1A: FN=0 INT init=0 WS=0 RS=0 */
+};
+#ifdef MCD_INCLUDE_EU
+u32 MCD_ChainEu_TDT[] = {
+	0x80004000, /* 0000(:947):  LCDEXT: idx0 = 0x00000000; ; */
+	0x8198801b, /* 0004(:947):  LCD: idx1 = var3; idx1 once var0; idx1 += inc3 */
+	0xb8c68018, /* 0008(:948):    LCD: idx2 = *(idx1 + var13); idx2 once var0; idx2 += inc3 */
+	0x10002f10, /* 000C(:949):      DRD1A: var11 = idx2; FN=0 MORE init=0 WS=0 RS=0 */
+	0x7000000d, /* 0010(:950):      DRD2A: EU0=0 EU1=0 EU2=0 EU3=13 EXT MORE init=0 WS=0 RS=0 */
+	0x01ccf89f, /* 0014(:950):      DRD2B1: var7 = EU3(); EU3(idx2)  */
+	0x6000000a, /* 0018(:951):      DRD2A: EU0=0 EU1=0 EU2=0 EU3=10 EXT init=0 WS=0 RS=0 */
+	0x080cf89f, /* 001C(:951):      DRD2B1: idx0 = EU3(); EU3(idx2)  */
+	0x000001f8, /* 0020(:0):    NOP */
+	0x981803a4, /* 0024(:955):  LCD: idx0 = idx0; idx0 == var14; idx0 += inc4 */
+	0x8198801b, /* 0028(:957):    LCD: idx1 = var3; idx1 once var0; idx1 += inc3 */
+	0xf8c6801a, /* 002C(:958):      LCDEXT: idx2 = *(idx1 + var13 + 8); idx2 once var0; idx2 += inc3 */
+	0xb8c6e01b, /* 0030(:959):      LCD: idx3 = *(idx1 + var13 + 12); ; idx3 += inc3 */
+	0x10002b10, /* 0034(:961):        DRD1A: var10 = idx2; FN=0 MORE init=0 WS=0 RS=0 */
+	0x00001318, /* 0038(:962):        DRD1A: var4 = idx3; FN=0 init=0 WS=0 RS=0 */
+	0xb8c6801d, /* 003C(:964):      LCD: idx2 = *(idx1 + var13 + 20); idx2 once var0; idx2 += inc3 */
+	0x10001710, /* 0040(:965):        DRD1A: var5 = idx2; FN=0 MORE init=0 WS=0 RS=0 */
+	0x60000007, /* 0044(:966):        DRD2A: EU0=0 EU1=0 EU2=0 EU3=7 EXT init=0 WS=0 RS=0 */
+	0x018cf88c, /* 0048(:966):        DRD2B1: var6 = EU3(); EU3(idx2,var12)  */
+	0x98c6801c, /* 004C(:968):      LCD: idx2 = idx1 + var13 + 4; idx2 once var0; idx2 += inc3 */
+	0x00000b10, /* 0050(:969):        DRD1A: var2 = idx2; FN=0 init=0 WS=0 RS=0 */
+	0x98c78018, /* 0054(:970):      LCD: idx2 = idx1 + var15; idx2 once var0; idx2 += inc3 */
+	0x10002310, /* 0058(:971):        DRD1A: var8 = idx2; FN=0 MORE init=0 WS=0 RS=0 */
+	0x0000c820, /* 005C(:972):        DRD1A: *idx2 = var4; FN=0 init=0 WS=0 RS=0 */
+	0x000001f8, /* 0060(:0):      NOP */
+	0x8698801b, /* 0064(:976):    LCD: idx1 = var13; idx1 once var0; idx1 += inc3 */
+	0x7000000f, /* 0068(:977):      DRD2A: EU0=0 EU1=0 EU2=0 EU3=15 EXT MORE init=0 WS=0 RS=0 */
+	0x084cf2df, /* 006C(:977):      DRD2B1: idx1 = EU3(); EU3(var11)  */
+	0xd899042d, /* 0070(:978):      LCDEXT: idx2 = idx1; idx2 >= var16; idx2 += inc5 */
+	0x8019801b, /* 0074(:978):      LCD: idx3 = var0; idx3 once var0; idx3 += inc3 */
+	0x60000003, /* 0078(:979):        DRD2A: EU0=0 EU1=0 EU2=0 EU3=3 EXT init=0 WS=0 RS=0 */
+	0x2cd7c7df, /* 007C(:979):        DRD2B2: EU3(var13)  */
+	0xd8990364, /* 0080(:980):      LCDEXT: idx2 = idx1; idx2 == var13; idx2 += inc4 */
+	0x8019801b, /* 0084(:980):      LCD: idx3 = var0; idx3 once var0; idx3 += inc3 */
+	0x60000003, /* 0088(:981):        DRD2A: EU0=0 EU1=0 EU2=0 EU3=3 EXT init=0 WS=0 RS=0 */
+	0x2c17c7df, /* 008C(:981):        DRD2B2: EU3(var1)  */
+	0x000001f8, /* 0090(:0):      NOP */
+	0xc1c7e018, /* 0094(:984):    LCDEXT: idx1 = var3 + var15; ; idx1 += inc3 */
+	0xc003a35e, /* 0098(:984):    LCDEXT: idx2 = var0, idx3 = var7; idx3 == var13; idx2 += inc3, idx3 += inc6 */
+	0x819a601b, /* 009C(:985):    LCD: idx4 = var3; ; idx4 += inc3 */
+	0xc206a142, /* 00A0(:988):      LCDEXT: idx5 = var4, idx6 = var13; idx6 < var5; idx5 += inc0, idx6 += inc2 */
+	0x851be009, /* 00A4(:988):      LCD: idx7 = var10; ; idx7 += inc1 */
+	0x63fe0000, /* 00A8(:991):        DRD2A: EU0=0 EU1=0 EU2=0 EU3=0 EXT init=31 WS=3 RS=3 */
+	0x0d4cfddf, /* 00AC(:991):        DRD2B1: *idx5 = EU3(); EU3(*idx7)  */
+	0xda9b001b, /* 00B0(:993):      LCDEXT: idx5 = idx5, idx6 = idx6; idx5 once var0; idx5 += inc3, idx6 += inc3 */
+	0x9b9be01b, /* 00B4(:993):      LCD: idx7 = idx7; ; idx7 += inc3 */
+	0x70000002, /* 00B8(:994):        DRD2A: EU0=0 EU1=0 EU2=0 EU3=2 EXT MORE init=0 WS=0 RS=0 */
+	0x004cf81f, /* 00BC(:994):        DRD2B1: var1 = EU3(); EU3(idx0)  */
+	0x1000cb20, /* 00C0(:995):        DRD1A: *idx2 = idx4; FN=0 MORE init=0 WS=0 RS=0 */
+	0x70000006, /* 00C4(:996):        DRD2A: EU0=0 EU1=0 EU2=0 EU3=6 EXT MORE init=0 WS=0 RS=0 */
+	0x088cf891, /* 00C8(:996):        DRD2B1: idx2 = EU3(); EU3(idx2,var17)  */
+	0x1000cb28, /* 00CC(:997):        DRD1A: *idx2 = idx5; FN=0 MORE init=0 WS=0 RS=0 */
+	0x70000006, /* 00D0(:998):        DRD2A: EU0=0 EU1=0 EU2=0 EU3=6 EXT MORE init=0 WS=0 RS=0 */
+	0x088cf891, /* 00D4(:998):        DRD2B1: idx2 = EU3(); EU3(idx2,var17)  */
+	0x1000cb30, /* 00D8(:999):        DRD1A: *idx2 = idx6; FN=0 MORE init=0 WS=0 RS=0 */
+	0x70000006, /* 00DC(:1000):        DRD2A: EU0=0 EU1=0 EU2=0 EU3=6 EXT MORE init=0 WS=0 RS=0 */
+	0x088cf891, /* 00E0(:1000):        DRD2B1: idx2 = EU3(); EU3(idx2,var17)  */
+	0x1000cb38, /* 00E4(:1001):        DRD1A: *idx2 = idx7; FN=0 MORE init=0 WS=0 RS=0 */
+	0x0000c728, /* 00E8(:1002):        DRD1A: *idx1 = idx5; FN=0 init=0 WS=0 RS=0 */
+	0x000001f8, /* 00EC(:0):      NOP */
+	0xc1c7e018, /* 00F0(:1006):    LCDEXT: idx1 = var3 + var15; ; idx1 += inc3 */
+	0xc003a49e, /* 00F4(:1006):    LCDEXT: idx2 = var0, idx3 = var7; idx3 == var18; idx2 += inc3, idx3 += inc6 */
+	0x819a601b, /* 00F8(:1007):    LCD: idx4 = var3; ; idx4 += inc3 */
+	0xda9b001b, /* 00FC(:1010):      LCDEXT: idx5 = idx5, idx6 = idx6; idx5 once var0; idx5 += inc3, idx6 += inc3 */
+	0x9b9be01b, /* 0100(:1010):      LCD: idx7 = idx7; ; idx7 += inc3 */
+	0x0000d3a0, /* 0104(:1011):        DRD1A: *idx4; FN=0 init=0 WS=0 RS=0 */
+	0xc206a142, /* 0108(:1013):      LCDEXT: idx5 = var4, idx6 = var13; idx6 < var5; idx5 += inc0, idx6 += inc2 */
+	0x851be009, /* 010C(:1013):      LCD: idx7 = var10; ; idx7 += inc1 */
+	0x6bfe0000, /* 0110(:1016):        DRD2A: EU0=0 EU1=0 EU2=0 EU3=0 TFD EXT init=31 WS=3 RS=3 */
+	0x0d4cfddf, /* 0114(:1016):        DRD2B1: *idx5 = EU3(); EU3(*idx7)  */
+	0xda9b001b, /* 0118(:1018):      LCDEXT: idx5 = idx5, idx6 = idx6; idx5 once var0; idx5 += inc3, idx6 += inc3 */
+	0x9b9be01b, /* 011C(:1018):      LCD: idx7 = idx7; ; idx7 += inc3 */
+	0x70000002, /* 0120(:1019):        DRD2A: EU0=0 EU1=0 EU2=0 EU3=2 EXT MORE init=0 WS=0 RS=0 */
+	0x004cf81f, /* 0124(:1019):        DRD2B1: var1 = EU3(); EU3(idx0)  */
+	0x1000cb20, /* 0128(:1020):        DRD1A: *idx2 = idx4; FN=0 MORE init=0 WS=0 RS=0 */
+	0x70000006, /* 012C(:1021):        DRD2A: EU0=0 EU1=0 EU2=0 EU3=6 EXT MORE init=0 WS=0 RS=0 */
+	0x088cf891, /* 0130(:1021):        DRD2B1: idx2 = EU3(); EU3(idx2,var17)  */
+	0x1000cb28, /* 0134(:1022):        DRD1A: *idx2 = idx5; FN=0 MORE init=0 WS=0 RS=0 */
+	0x70000006, /* 0138(:1023):        DRD2A: EU0=0 EU1=0 EU2=0 EU3=6 EXT MORE init=0 WS=0 RS=0 */
+	0x088cf891, /* 013C(:1023):        DRD2B1: idx2 = EU3(); EU3(idx2,var17)  */
+	0x1000cb30, /* 0140(:1024):        DRD1A: *idx2 = idx6; FN=0 MORE init=0 WS=0 RS=0 */
+	0x70000006, /* 0144(:1025):        DRD2A: EU0=0 EU1=0 EU2=0 EU3=6 EXT MORE init=0 WS=0 RS=0 */
+	0x088cf891, /* 0148(:1025):        DRD2B1: idx2 = EU3(); EU3(idx2,var17)  */
+	0x1000cb38, /* 014C(:1026):        DRD1A: *idx2 = idx7; FN=0 MORE init=0 WS=0 RS=0 */
+	0x0000c728, /* 0150(:1027):        DRD1A: *idx1 = idx5; FN=0 init=0 WS=0 RS=0 */
+	0x000001f8, /* 0154(:0):      NOP */
+	0x8198801b, /* 0158(:1031):    LCD: idx1 = var3; idx1 once var0; idx1 += inc3 */
+	0xd8c68018, /* 015C(:1033):      LCDEXT: idx2 = idx1 + var13; idx2 once var0; idx2 += inc3 */
+	0x98c6e01c, /* 0160(:1033):      LCD: idx3 = idx1 + var13 + 4; ; idx3 += inc3 */
+	0x6000000b, /* 0164(:1034):        DRD2A: EU0=0 EU1=0 EU2=0 EU3=11 EXT init=0 WS=0 RS=0 */
+	0x0c8cfc9f, /* 0168(:1034):        DRD2B1: *idx2 = EU3(); EU3(*idx2)  */
+	0x0000cc08, /* 016C(:1035):      DRD1A: *idx3 = var1; FN=0 init=0 WS=0 RS=0 */
+	0xa1c6801e, /* 0170(:1038):    LCD: idx1 = *(var3 + var13 + 24); idx1 once var0; idx1 += inc3 */
+	0x10000f08, /* 0174(:1039):      DRD1A: var3 = idx1; FN=0 MORE init=0 WS=0 RS=0 */
+	0x10002458, /* 0178(:1040):      DRD1A: var9 = var11; FN=0 MORE init=0 WS=0 RS=0 */
+	0xb8c68018, /* 017C(:1041):      LCD: idx2 = *(idx1 + var13); idx2 once var0; idx2 += inc3 */
+	0x10002f10, /* 0180(:1042):        DRD1A: var11 = idx2; FN=0 MORE init=0 WS=0 RS=0 */
+	0x7000000a, /* 0184(:1043):        DRD2A: EU0=0 EU1=0 EU2=0 EU3=10 EXT MORE init=0 WS=0 RS=0 */
+	0x080cf89f, /* 0188(:1043):        DRD2B1: idx0 = EU3(); EU3(idx2)  */
+	0x6000000d, /* 018C(:1044):        DRD2A: EU0=0 EU1=0 EU2=0 EU3=13 EXT init=0 WS=0 RS=0 */
+	0x01ccf89f, /* 0190(:1044):        DRD2B1: var7 = EU3(); EU3(idx2)  */
+	0x000001f8, /* 0194(:0):      NOP */
+	0x8698801b, /* 0198(:1050):    LCD: idx1 = var13; idx1 once var0; idx1 += inc3 */
+	0x7000000e, /* 019C(:1051):      DRD2A: EU0=0 EU1=0 EU2=0 EU3=14 EXT MORE init=0 WS=0 RS=0 */
+	0x084cf25f, /* 01A0(:1051):      DRD2B1: idx1 = EU3(); EU3(var9)  */
+	0xd899037f, /* 01A4(:1052):      LCDEXT: idx2 = idx1; idx2 > var13; idx2 += inc7 */
+	0x8019801b, /* 01A8(:1052):      LCD: idx3 = var0; idx3 once var0; idx3 += inc3 */
+	0x040001f8, /* 01AC(:1053):        DRD1A: FN=0 INT init=0 WS=0 RS=0 */
+	0x000001f8, /* 01B0(:0):      NOP */
+	0x000001f8, /* 01B4(:0):    NOP */
+};
+u32 MCD_SingleEu_TDT[] = {
+	0x8218001b, /* 0000(:1248):  LCD: idx0 = var4; idx0 once var0; idx0 += inc3 */
+	0x7000000d, /* 0004(:1249):    DRD2A: EU0=0 EU1=0 EU2=0 EU3=13 EXT MORE init=0 WS=0 RS=0 */
+	0x080cf81f, /* 0008(:1249):    DRD2B1: idx0 = EU3(); EU3(idx0)  */
+	0x8218801b, /* 000C(:1250):    LCD: idx1 = var4; idx1 once var0; idx1 += inc3 */
+	0x6000000e, /* 0010(:1251):      DRD2A: EU0=0 EU1=0 EU2=0 EU3=14 EXT init=0 WS=0 RS=0 */
+	0x084cf85f, /* 0014(:1251):      DRD2B1: idx1 = EU3(); EU3(idx1)  */
+	0x000001f8, /* 0018(:0):    NOP */
+	0x8318001b, /* 001C(:1255):  LCD: idx0 = var6; idx0 once var0; idx0 += inc3 */
+	0x7000000d, /* 0020(:1256):    DRD2A: EU0=0 EU1=0 EU2=0 EU3=13 EXT MORE init=0 WS=0 RS=0 */
+	0x014cf81f, /* 0024(:1256):    DRD2B1: var5 = EU3(); EU3(idx0)  */
+	0x6000000e, /* 0028(:1257):    DRD2A: EU0=0 EU1=0 EU2=0 EU3=14 EXT init=0 WS=0 RS=0 */
+	0x01ccf81f, /* 002C(:1257):    DRD2B1: var7 = EU3(); EU3(idx0)  */
+	0x8498001b, /* 0030(:1260):  LCD: idx0 = var9; idx0 once var0; idx0 += inc3 */
+	0x7000000f, /* 0034(:1261):    DRD2A: EU0=0 EU1=0 EU2=0 EU3=15 EXT MORE init=0 WS=0 RS=0 */
+	0x080cf19f, /* 0038(:1261):    DRD2B1: idx0 = EU3(); EU3(var6)  */
+	0xd81882a4, /* 003C(:1262):    LCDEXT: idx1 = idx0; idx1 >= var10; idx1 += inc4 */
+	0x8019001b, /* 0040(:1262):    LCD: idx2 = var0; idx2 once var0; idx2 += inc3 */
+	0x60000003, /* 0044(:1263):      DRD2A: EU0=0 EU1=0 EU2=0 EU3=3 EXT init=0 WS=0 RS=0 */
+	0x2c97c7df, /* 0048(:1263):      DRD2B2: EU3(var9)  */
+	0xd818826d, /* 004C(:1264):    LCDEXT: idx1 = idx0; idx1 == var9; idx1 += inc5 */
+	0x8019001b, /* 0050(:1264):    LCD: idx2 = var0; idx2 once var0; idx2 += inc3 */
+	0x60000003, /* 0054(:1265):      DRD2A: EU0=0 EU1=0 EU2=0 EU3=3 EXT init=0 WS=0 RS=0 */
+	0x2c17c7df, /* 0058(:1265):      DRD2B2: EU3(var1)  */
+	0x000001f8, /* 005C(:0):    NOP */
+	0xc282e01b, /* 0060(:1268):  LCDEXT: idx0 = var5, idx1 = var5; ; idx0 += inc3, idx1 += inc3 */
+	0xc002a25e, /* 0064(:1268):  LCDEXT: idx2 = var0, idx3 = var5; idx3 == var9; idx2 += inc3, idx3 += inc6 */
+	0x811a601b, /* 0068(:1269):  LCD: idx4 = var2; ; idx4 += inc3 */
+	0xc184a102, /* 006C(:1272):    LCDEXT: idx5 = var3, idx6 = var9; idx6 < var4; idx5 += inc0, idx6 += inc2 */
+	0x841be009, /* 0070(:1272):    LCD: idx7 = var8; ; idx7 += inc1 */
+	0x63fe0000, /* 0074(:1275):      DRD2A: EU0=0 EU1=0 EU2=0 EU3=0 EXT init=31 WS=3 RS=3 */
+	0x0d4cfddf, /* 0078(:1275):      DRD2B1: *idx5 = EU3(); EU3(*idx7)  */
+	0xda9b001b, /* 007C(:1277):    LCDEXT: idx5 = idx5, idx6 = idx6; idx5 once var0; idx5 += inc3, idx6 += inc3 */
+	0x9b9be01b, /* 0080(:1277):    LCD: idx7 = idx7; ; idx7 += inc3 */
+	0x70000002, /* 0084(:1279):      DRD2A: EU0=0 EU1=0 EU2=0 EU3=2 EXT MORE init=0 WS=0 RS=0 */
+	0x004cf99f, /* 0088(:1279):      DRD2B1: var1 = EU3(); EU3(idx6)  */
+	0x70000006, /* 008C(:1280):      DRD2A: EU0=0 EU1=0 EU2=0 EU3=6 EXT MORE init=0 WS=0 RS=0 */
+	0x088cf88b, /* 0090(:1280):      DRD2B1: idx2 = EU3(); EU3(idx2,var11)  */
+	0x1000cb28, /* 0094(:1281):      DRD1A: *idx2 = idx5; FN=0 MORE init=0 WS=0 RS=0 */
+	0x70000006, /* 0098(:1282):      DRD2A: EU0=0 EU1=0 EU2=0 EU3=6 EXT MORE init=0 WS=0 RS=0 */
+	0x088cf88b, /* 009C(:1282):      DRD2B1: idx2 = EU3(); EU3(idx2,var11)  */
+	0x1000cb30, /* 00A0(:1283):      DRD1A: *idx2 = idx6; FN=0 MORE init=0 WS=0 RS=0 */
+	0x70000006, /* 00A4(:1284):      DRD2A: EU0=0 EU1=0 EU2=0 EU3=6 EXT MORE init=0 WS=0 RS=0 */
+	0x088cf88b, /* 00A8(:1284):      DRD2B1: idx2 = EU3(); EU3(idx2,var11)  */
+	0x0000cb38, /* 00AC(:1285):      DRD1A: *idx2 = idx7; FN=0 init=0 WS=0 RS=0 */
+	0x000001f8, /* 00B0(:0):    NOP */
+	0xc282e01b, /* 00B4(:1289):  LCDEXT: idx0 = var5, idx1 = var5; ; idx0 += inc3, idx1 += inc3 */
+	0xc002a31e, /* 00B8(:1289):  LCDEXT: idx2 = var0, idx3 = var5; idx3 == var12; idx2 += inc3, idx3 += inc6 */
+	0x811a601b, /* 00BC(:1290):  LCD: idx4 = var2; ; idx4 += inc3 */
+	0xda9b001b, /* 00C0(:1293):    LCDEXT: idx5 = idx5, idx6 = idx6; idx5 once var0; idx5 += inc3, idx6 += inc3 */
+	0x9b9be01b, /* 00C4(:1293):    LCD: idx7 = idx7; ; idx7 += inc3 */
+	0x0000d3a0, /* 00C8(:1294):      DRD1A: *idx4; FN=0 init=0 WS=0 RS=0 */
+	0xc184a102, /* 00CC(:1296):    LCDEXT: idx5 = var3, idx6 = var9; idx6 < var4; idx5 += inc0, idx6 += inc2 */
+	0x841be009, /* 00D0(:1296):    LCD: idx7 = var8; ; idx7 += inc1 */
+	0x6bfe0000, /* 00D4(:1299):      DRD2A: EU0=0 EU1=0 EU2=0 EU3=0 TFD EXT init=31 WS=3 RS=3 */
+	0x0d4cfddf, /* 00D8(:1299):      DRD2B1: *idx5 = EU3(); EU3(*idx7)  */
+	0xda9b001b, /* 00DC(:1301):    LCDEXT: idx5 = idx5, idx6 = idx6; idx5 once var0; idx5 += inc3, idx6 += inc3 */
+	0x9b9be01b, /* 00E0(:1301):    LCD: idx7 = idx7; ; idx7 += inc3 */
+	0x70000002, /* 00E4(:1303):      DRD2A: EU0=0 EU1=0 EU2=0 EU3=2 EXT MORE init=0 WS=0 RS=0 */
+	0x004cf99f, /* 00E8(:1303):      DRD2B1: var1 = EU3(); EU3(idx6)  */
+	0x70000006, /* 00EC(:1304):      DRD2A: EU0=0 EU1=0 EU2=0 EU3=6 EXT MORE init=0 WS=0 RS=0 */
+	0x088cf88b, /* 00F0(:1304):      DRD2B1: idx2 = EU3(); EU3(idx2,var11)  */
+	0x1000cb28, /* 00F4(:1305):      DRD1A: *idx2 = idx5; FN=0 MORE init=0 WS=0 RS=0 */
+	0x70000006, /* 00F8(:1306):      DRD2A: EU0=0 EU1=0 EU2=0 EU3=6 EXT MORE init=0 WS=0 RS=0 */
+	0x088cf88b, /* 00FC(:1306):      DRD2B1: idx2 = EU3(); EU3(idx2,var11)  */
+	0x1000cb30, /* 0100(:1307):      DRD1A: *idx2 = idx6; FN=0 MORE init=0 WS=0 RS=0 */
+	0x70000006, /* 0104(:1308):      DRD2A: EU0=0 EU1=0 EU2=0 EU3=6 EXT MORE init=0 WS=0 RS=0 */
+	0x088cf88b, /* 0108(:1308):      DRD2B1: idx2 = EU3(); EU3(idx2,var11)  */
+	0x0000cb38, /* 010C(:1309):      DRD1A: *idx2 = idx7; FN=0 init=0 WS=0 RS=0 */
+	0x000001f8, /* 0110(:0):    NOP */
+	0x8144801c, /* 0114(:1312):  LCD: idx0 = var2 + var9 + 4; idx0 once var0; idx0 += inc3 */
+	0x0000c008, /* 0118(:1313):    DRD1A: *idx0 = var1; FN=0 init=0 WS=0 RS=0 */
+	0xc398027f, /* 011C(:1315):  LCDEXT: idx0 = var7; idx0 > var9; idx0 += inc7 */
+	0x8018801b, /* 0120(:1315):  LCD: idx1 = var0; idx1 once var0; idx1 += inc3 */
+	0x040001f8, /* 0124(:1316):    DRD1A: FN=0 INT init=0 WS=0 RS=0 */
+};
+#endif
+u32 MCD_ENetRcv_TDT[] = {
+	0x80004000, /* 0000(:1389):  LCDEXT: idx0 = 0x00000000; ; */
+	0x81988000, /* 0004(:1389):  LCD: idx1 = var3; idx1 once var0; idx1 += inc0 */
+	0x10000788, /* 0008(:1390):    DRD1A: var1 = *idx1; FN=0 MORE init=0 WS=0 RS=0 */
+	0x6000000a, /* 000C(:1391):    DRD2A: EU0=0 EU1=0 EU2=0 EU3=10 EXT init=0 WS=0 RS=0 */
+	0x080cf05f, /* 0010(:1391):    DRD2B1: idx0 = EU3(); EU3(var1)  */
+	0x98180209, /* 0014(:1394):  LCD: idx0 = idx0; idx0 != var8; idx0 += inc1 */
+	0x81c40004, /* 0018(:1396):    LCD: idx1 = var3 + var8 + 4; idx1 once var0; idx1 += inc0 */
+	0x7000000e, /* 001C(:1397):      DRD2A: EU0=0 EU1=0 EU2=0 EU3=14 EXT MORE init=0 WS=0 RS=0 */
+	0x010cf05f, /* 0020(:1397):      DRD2B1: var4 = EU3(); EU3(var1)  */
+	0x7000000c, /* 0024(:1398):      DRD2A: EU0=0 EU1=0 EU2=0 EU3=12 EXT MORE init=0 WS=0 RS=0 */
+	0x01ccf05f, /* 0028(:1398):      DRD2B1: var7 = EU3(); EU3(var1)  */
+	0x70000004, /* 002C(:1399):      DRD2A: EU0=0 EU1=0 EU2=0 EU3=4 EXT MORE init=0 WS=0 RS=0 */
+	0x014cf049, /* 0030(:1399):      DRD2B1: var5 = EU3(); EU3(var1,var9)  */
+	0x70000004, /* 0034(:1400):      DRD2A: EU0=0 EU1=0 EU2=0 EU3=4 EXT MORE init=0 WS=0 RS=0 */
+	0x004cf04a, /* 0038(:1400):      DRD2B1: var1 = EU3(); EU3(var1,var10)  */
+	0x00000b88, /* 003C(:1403):      DRD1A: var2 = *idx1; FN=0 init=0 WS=0 RS=0 */
+	0xc4030150, /* 0040(:1406):    LCDEXT: idx1 = var8, idx2 = var6; idx1 < var5; idx1 += inc2, idx2 += inc0 */
+	0x8119e012, /* 0044(:1406):    LCD: idx3 = var2; ; idx3 += inc2 */
+	0x03e0cf90, /* 0048(:1409):      DRD1A: *idx3 = *idx2; FN=0 init=31 WS=0 RS=0 */
+	0x81188000, /* 004C(:1412):    LCD: idx1 = var2; idx1 once var0; idx1 += inc0 */
+	0x000ac788, /* 0050(:1413):      DRD1A: *idx1 = *idx1; FN=0 init=0 WS=1 RS=1 */
+	0xc4030000, /* 0054(:1415):    LCDEXT: idx1 = var8, idx2 = var6; idx1 once var0; idx1 += inc0, idx2 += inc0 */
+	0x8199e000, /* 0058(:1415):    LCD: idx3 = var3; ; idx3 += inc0 */
+	0x63e00004, /* 005C(:1418):      DRD2A: EU0=0 EU1=0 EU2=0 EU3=4 EXT init=31 WS=0 RS=0 */
+	0x084cfc8b, /* 0060(:1418):      DRD2B1: idx1 = EU3(); EU3(*idx2,var11)  */
+	0xd8990000, /* 0064(:1421):    LCDEXT: idx1 = idx1, idx2 = idx2; idx1 once var0; idx1 += inc0, idx2 += inc0 */
+	0x9999e000, /* 0068(:1421):    LCD: idx3 = idx3; ; idx3 += inc0 */
+	0x60000005, /* 006C(:1422):      DRD2A: EU0=0 EU1=0 EU2=0 EU3=5 EXT init=0 WS=0 RS=0 */
+	0x0cccf841, /* 0070(:1422):      DRD2B1: *idx3 = EU3(); EU3(idx1,var1)  */
+	0x81c60000, /* 0074(:1427):    LCD: idx1 = var3 + var12; idx1 once var0; idx1 += inc0 */
+	0xc399021b, /* 0078(:1429):      LCDEXT: idx2 = var7; idx2 > var8; idx2 += inc3 */
+	0x80198000, /* 007C(:1429):      LCD: idx3 = var0; idx3 once var0; idx3 += inc0 */
+	0x00008400, /* 0080(:1430):        DRD1A: idx1 = var0; FN=0 init=0 WS=0 RS=0 */
+	0x00000f08, /* 0084(:1431):      DRD1A: var3 = idx1; FN=0 init=0 WS=0 RS=0 */
+	0x81988000, /* 0088(:1434):    LCD: idx1 = var3; idx1 once var0; idx1 += inc0 */
+	0x10000788, /* 008C(:1435):      DRD1A: var1 = *idx1; FN=0 MORE init=0 WS=0 RS=0 */
+	0x6000000a, /* 0090(:1436):      DRD2A: EU0=0 EU1=0 EU2=0 EU3=10 EXT init=0 WS=0 RS=0 */
+	0x080cf05f, /* 0094(:1436):      DRD2B1: idx0 = EU3(); EU3(var1)  */
+	0xc2188209, /* 0098(:1439):    LCDEXT: idx1 = var4; idx1 != var8; idx1 += inc1 */
+	0x80190000, /* 009C(:1439):    LCD: idx2 = var0; idx2 once var0; idx2 += inc0 */
+	0x040001f8, /* 00A0(:1440):      DRD1A: FN=0 INT init=0 WS=0 RS=0 */
+	0x000001f8, /* 00A4(:0):    NOP */
+};
+u32 MCD_ENetXmit_TDT[] = {
+	0x80004000, /* 0000(:1515):  LCDEXT: idx0 = 0x00000000; ; */
+	0x81988000, /* 0004(:1515):  LCD: idx1 = var3; idx1 once var0; idx1 += inc0 */
+	0x10000788, /* 0008(:1516):    DRD1A: var1 = *idx1; FN=0 MORE init=0 WS=0 RS=0 */
+	0x6000000a, /* 000C(:1517):    DRD2A: EU0=0 EU1=0 EU2=0 EU3=10 EXT init=0 WS=0 RS=0 */
+	0x080cf05f, /* 0010(:1517):    DRD2B1: idx0 = EU3(); EU3(var1)  */
+	0x98180309, /* 0014(:1520):  LCD: idx0 = idx0; idx0 != var12; idx0 += inc1 */
+	0x80004003, /* 0018(:1522):    LCDEXT: idx1 = 0x00000003; ; */
+	0x81c60004, /* 001C(:1522):    LCD: idx2 = var3 + var12 + 4; idx2 once var0; idx2 += inc0 */
+	0x7000000e, /* 0020(:1523):      DRD2A: EU0=0 EU1=0 EU2=0 EU3=14 EXT MORE init=0 WS=0 RS=0 */
+	0x014cf05f, /* 0024(:1523):      DRD2B1: var5 = EU3(); EU3(var1)  */
+	0x7000000c, /* 0028(:1524):      DRD2A: EU0=0 EU1=0 EU2=0 EU3=12 EXT MORE init=0 WS=0 RS=0 */
+	0x028cf05f, /* 002C(:1524):      DRD2B1: var10 = EU3(); EU3(var1)  */
+	0x7000000d, /* 0030(:1525):      DRD2A: EU0=0 EU1=0 EU2=0 EU3=13 EXT MORE init=0 WS=0 RS=0 */
+	0x018cf05f, /* 0034(:1525):      DRD2B1: var6 = EU3(); EU3(var1)  */
+	0x70000004, /* 0038(:1526):      DRD2A: EU0=0 EU1=0 EU2=0 EU3=4 EXT MORE init=0 WS=0 RS=0 */
+	0x01ccf04d, /* 003C(:1526):      DRD2B1: var7 = EU3(); EU3(var1,var13)  */
+	0x10000b90, /* 0040(:1527):      DRD1A: var2 = *idx2; FN=0 MORE init=0 WS=0 RS=0 */
+	0x60000004, /* 0044(:1528):      DRD2A: EU0=0 EU1=0 EU2=0 EU3=4 EXT init=0 WS=0 RS=0 */
+	0x020cf0a1, /* 0048(:1528):      DRD2B1: var8 = EU3(); EU3(var2,idx1)  */
+	0xc3188312, /* 004C(:1531):    LCDEXT: idx1 = var6; idx1 > var12; idx1 += inc2 */
+	0x83c70000, /* 0050(:1531):    LCD: idx2 = var7 + var14; idx2 once var0; idx2 += inc0 */
+	0x00001f10, /* 0054(:1532):      DRD1A: var7 = idx2; FN=0 init=0 WS=0 RS=0 */
+	0xc583a3c3, /* 0058(:1534):    LCDEXT: idx1 = var11, idx2 = var7; idx2 >= var15; idx1 += inc0, idx2 += inc3 */
+	0x81042325, /* 005C(:1534):    LCD: idx3 = var2, idx4 = var8; idx4 == var12; idx3 += inc4, idx4 += inc5 */
+	0x03e0c798, /* 0060(:1539):      DRD1A: *idx1 = *idx3; FN=0 init=31 WS=0 RS=0 */
+	0xd8990000, /* 0064(:1542):    LCDEXT: idx1 = idx1, idx2 = idx2; idx1 once var0; idx1 += inc0, idx2 += inc0 */
+	0x9999e000, /* 0068(:1542):    LCD: idx3 = idx3; ; idx3 += inc0 */
+	0x000acf98, /* 006C(:1543):      DRD1A: *idx3 = *idx3; FN=0 init=0 WS=1 RS=1 */
+	0xd8992306, /* 0070(:1545):    LCDEXT: idx1 = idx1, idx2 = idx2; idx2 > var12; idx1 += inc0, idx2 += inc6 */
+	0x9999e03f, /* 0074(:1545):    LCD: idx3 = idx3; ; idx3 += inc7 */
+	0x03eac798, /* 0078(:1548):      DRD1A: *idx1 = *idx3; FN=0 init=31 WS=1 RS=1 */
+	0xd8990000, /* 007C(:1551):    LCDEXT: idx1 = idx1, idx2 = idx2; idx1 once var0; idx1 += inc0, idx2 += inc0 */
+	0x9999e000, /* 0080(:1551):    LCD: idx3 = idx3; ; idx3 += inc0 */
+	0x000acf98, /* 0084(:1552):      DRD1A: *idx3 = *idx3; FN=0 init=0 WS=1 RS=1 */
+	0xd8990000, /* 0088(:1554):    LCDEXT: idx1 = idx1, idx2 = idx2; idx1 once var0; idx1 += inc0, idx2 += inc0 */
+	0x99832302, /* 008C(:1554):    LCD: idx3 = idx3, idx4 = var6; idx4 > var12; idx3 += inc0, idx4 += inc2 */
+	0x0beac798, /* 0090(:1557):      DRD1A: *idx1 = *idx3; FN=0 TFD init=31 WS=1 RS=1 */
+	0x81988000, /* 0094(:1559):    LCD: idx1 = var3; idx1 once var0; idx1 += inc0 */
+	0x6000000b, /* 0098(:1560):      DRD2A: EU0=0 EU1=0 EU2=0 EU3=11 EXT init=0 WS=0 RS=0 */
+	0x0c4cfc5f, /* 009C(:1560):      DRD2B1: *idx1 = EU3(); EU3(*idx1)  */
+	0x81c80000, /* 00A0(:1562):    LCD: idx1 = var3 + var16; idx1 once var0; idx1 += inc0 */
+	0xc5190312, /* 00A4(:1564):      LCDEXT: idx2 = var10; idx2 > var12; idx2 += inc2 */
+	0x80198000, /* 00A8(:1564):      LCD: idx3 = var0; idx3 once var0; idx3 += inc0 */
+	0x00008400, /* 00AC(:1565):        DRD1A: idx1 = var0; FN=0 init=0 WS=0 RS=0 */
+	0x00000f08, /* 00B0(:1566):      DRD1A: var3 = idx1; FN=0 init=0 WS=0 RS=0 */
+	0x81988000, /* 00B4(:1569):    LCD: idx1 = var3; idx1 once var0; idx1 += inc0 */
+	0x10000788, /* 00B8(:1570):      DRD1A: var1 = *idx1; FN=0 MORE init=0 WS=0 RS=0 */
+	0x6000000a, /* 00BC(:1571):      DRD2A: EU0=0 EU1=0 EU2=0 EU3=10 EXT init=0 WS=0 RS=0 */
+	0x080cf05f, /* 00C0(:1571):      DRD2B1: idx0 = EU3(); EU3(var1)  */
+	0xc2988309, /* 00C4(:1574):    LCDEXT: idx1 = var5; idx1 != var12; idx1 += inc1 */
+	0x80190000, /* 00C8(:1574):    LCD: idx2 = var0; idx2 once var0; idx2 += inc0 */
+	0x040001f8, /* 00CC(:1575):      DRD1A: FN=0 INT init=0 WS=0 RS=0 */
+	0x000001f8, /* 00D0(:0):    NOP */
+};
+
+#ifdef MCD_INCLUDE_EU
+MCD_bufDesc MCD_singleBufDescs[NCHANNELS];
+#endif
diff --git a/drivers/dma/fsl_mcd_dma/MCD_tasksInit.c b/drivers/dma/fsl_mcd_dma/MCD_tasksInit.c
new file mode 100644
index 0000000..28b9717
--- /dev/null
+++ b/drivers/dma/fsl_mcd_dma/MCD_tasksInit.c
@@ -0,0 +1,274 @@
+/*
+ * drivers/dma/MCD_tasksInit.c
+ *
+ * Copyright (C) 2004-2008 Freescale Semiconductor, Inc.
+ *     Kurt Mahan <kmahan@freescale.com>
+ * readl/writel conversion and other cleanup
+ * (C) Copyright 2010-2012 Philippe De Muyter <phdm@macqel.be> Macq SA
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+ * MA 02111-1307 USA
+ */
+
+/*
+ * Autogenerated - Do not edit!
+ */
+
+#include <linux/MCD_dma.h>
+#include <linux/io.h>
+#include "MCD_tasksInit.h"
+
+#define MCD_SET_VAR(varTab, idx, value) writel(value, (u32 *)(varTab) + idx)
+
+#define U16PAIR(m, l) ((u32)(m << 16) | (0xffff & l))
+
+
+/*
+ * Task 0
+ */
+
+void MCD_startDmaChainNoEu(int *currBD, short srcIncr, short destIncr,
+			   int xferSize, short xferSizeIncr, int *cSave,
+			   struct TaskTableEntry *taskTable, int channel)
+{
+	u32 var = taskTable[channel].varTab;
+	u16 tcrValue;
+
+	MCD_SET_VAR(var, 2, (u32)currBD); /* var[2] */
+	MCD_SET_VAR(var, 25, U16PAIR(0xe000, srcIncr));   /* inc[1] */
+	MCD_SET_VAR(var, 24, U16PAIR(0xe000, destIncr));  /* inc[0] */
+	MCD_SET_VAR(var, 11, (u32)xferSize);  /* var[11] */
+	MCD_SET_VAR(var, 26, U16PAIR(0x2000, xferSizeIncr));  /* inc[2] */
+	MCD_SET_VAR(var, 0, (u32)cSave);  /* var[0] */
+	MCD_SET_VAR(var, 1, (u32)0x00000000); /* var[1] */
+	MCD_SET_VAR(var, 3, (u32)0x00000000); /* var[3] */
+	MCD_SET_VAR(var, 4, (u32)0x00000000); /* var[4] */
+	MCD_SET_VAR(var, 5, (u32)0x00000000); /* var[5] */
+	MCD_SET_VAR(var, 6, (u32)0x00000000); /* var[6] */
+	MCD_SET_VAR(var, 7, (u32)0x00000000); /* var[7] */
+	MCD_SET_VAR(var, 8, (u32)0x00000000); /* var[8] */
+	MCD_SET_VAR(var, 9, (u32)0x00000000); /* var[9] */
+	MCD_SET_VAR(var, 10, (u32)0x00000000);    /* var[10] */
+	MCD_SET_VAR(var, 12, (u32)0x00000000);    /* var[12] */
+	MCD_SET_VAR(var, 13, (u32)0x80000000);    /* var[13] */
+	MCD_SET_VAR(var, 14, (u32)0x00000010);    /* var[14] */
+	MCD_SET_VAR(var, 15, (u32)0x00000004);    /* var[15] */
+	MCD_SET_VAR(var, 16, (u32)0x08000000);    /* var[16] */
+	MCD_SET_VAR(var, 27, (u32)0x00000000);    /* inc[3] */
+	MCD_SET_VAR(var, 28, (u32)0x80000000);    /* inc[4] */
+	MCD_SET_VAR(var, 29, (u32)0x80000001);    /* inc[5] */
+	MCD_SET_VAR(var, 30, (u32)0x40000000);    /* inc[6] */
+
+	/* Set the task's Enable bit in its Task Control Register */
+	tcrValue = readw(&MCD_dmaBar->taskControl[channel]);
+	writew(tcrValue | 0x8000, &MCD_dmaBar->taskControl[channel]);
+}
+
+
+/*
+ * Task 1
+ */
+
+void MCD_startDmaSingleNoEu(char *srcAddr, short srcIncr, char *destAddr,
+			    short destIncr, int dmaSize, short xferSizeIncr,
+			    int flags, int *currBD, int *cSave,
+			    struct TaskTableEntry *taskTable, int channel)
+{
+	u32 var = taskTable[channel].varTab;
+	u16 tcrValue;
+
+	MCD_SET_VAR(var, 7, (u32)srcAddr);    /* var[7] */
+	MCD_SET_VAR(var, 25, U16PAIR(0xe000, srcIncr));   /* inc[1] */
+	MCD_SET_VAR(var, 2, (u32)destAddr);   /* var[2] */
+	MCD_SET_VAR(var, 24, U16PAIR(0xe000, destIncr));  /* inc[0] */
+	MCD_SET_VAR(var, 3, (u32)dmaSize);    /* var[3] */
+	MCD_SET_VAR(var, 26, U16PAIR(0x2000, xferSizeIncr));  /* inc[2] */
+	MCD_SET_VAR(var, 5, (u32)flags);  /* var[5] */
+	MCD_SET_VAR(var, 1, (u32)currBD); /* var[1] */
+	MCD_SET_VAR(var, 0, (u32)cSave);  /* var[0] */
+	MCD_SET_VAR(var, 4, (u32)0x00000000); /* var[4] */
+	MCD_SET_VAR(var, 6, (u32)0x00000000); /* var[6] */
+	MCD_SET_VAR(var, 8, (u32)0x00000000); /* var[8] */
+	MCD_SET_VAR(var, 9, (u32)0x00000004); /* var[9] */
+	MCD_SET_VAR(var, 10, (u32)0x08000000);    /* var[10] */
+	MCD_SET_VAR(var, 27, (u32)0x00000000);    /* inc[3] */
+	MCD_SET_VAR(var, 28, (u32)0x80000001);    /* inc[4] */
+	MCD_SET_VAR(var, 29, (u32)0x40000000);    /* inc[5] */
+
+	/* Set the task's Enable bit in its Task Control Register */
+	tcrValue = readw(&MCD_dmaBar->taskControl[channel]);
+	writew(tcrValue | 0x8000, &MCD_dmaBar->taskControl[channel]);
+}
+
+
+/*
+ * Task 2
+ */
+
+void MCD_startDmaChainEu(int *currBD, short srcIncr, short destIncr,
+			 int xferSize, short xferSizeIncr, int *cSave,
+			 struct TaskTableEntry *taskTable, int channel)
+{
+	u32 var = taskTable[channel].varTab;
+	u16 tcrValue;
+
+	MCD_SET_VAR(var, 3, (u32)currBD); /* var[3] */
+	MCD_SET_VAR(var, 25, U16PAIR(0xe000, srcIncr));   /* inc[1] */
+	MCD_SET_VAR(var, 24, U16PAIR(0xe000, destIncr));  /* inc[0] */
+	MCD_SET_VAR(var, 12, (u32)xferSize);  /* var[12] */
+	MCD_SET_VAR(var, 26, U16PAIR(0x2000, xferSizeIncr));  /* inc[2] */
+	MCD_SET_VAR(var, 0, (u32)cSave);  /* var[0] */
+	MCD_SET_VAR(var, 1, (u32)0x00000000); /* var[1] */
+	MCD_SET_VAR(var, 2, (u32)0x00000000); /* var[2] */
+	MCD_SET_VAR(var, 4, (u32)0x00000000); /* var[4] */
+	MCD_SET_VAR(var, 5, (u32)0x00000000); /* var[5] */
+	MCD_SET_VAR(var, 6, (u32)0x00000000); /* var[6] */
+	MCD_SET_VAR(var, 7, (u32)0x00000000); /* var[7] */
+	MCD_SET_VAR(var, 8, (u32)0x00000000); /* var[8] */
+	MCD_SET_VAR(var, 9, (u32)0x00000000); /* var[9] */
+	MCD_SET_VAR(var, 10, (u32)0x00000000);    /* var[10] */
+	MCD_SET_VAR(var, 11, (u32)0x00000000);    /* var[11] */
+	MCD_SET_VAR(var, 13, (u32)0x00000000);    /* var[13] */
+	MCD_SET_VAR(var, 14, (u32)0x80000000);    /* var[14] */
+	MCD_SET_VAR(var, 15, (u32)0x00000010);    /* var[15] */
+	MCD_SET_VAR(var, 16, (u32)0x00000001);    /* var[16] */
+	MCD_SET_VAR(var, 17, (u32)0x00000004);    /* var[17] */
+	MCD_SET_VAR(var, 18, (u32)0x08000000);    /* var[18] */
+	MCD_SET_VAR(var, 27, (u32)0x00000000);    /* inc[3] */
+	MCD_SET_VAR(var, 28, (u32)0x80000000);    /* inc[4] */
+	MCD_SET_VAR(var, 29, (u32)0xc0000000);    /* inc[5] */
+	MCD_SET_VAR(var, 30, (u32)0x80000001);    /* inc[6] */
+	MCD_SET_VAR(var, 31, (u32)0x40000000);    /* inc[7] */
+
+	/* Set the task's Enable bit in its Task Control Register */
+	tcrValue = readw(&MCD_dmaBar->taskControl[channel]);
+	writew(tcrValue | 0x8000, &MCD_dmaBar->taskControl[channel]);
+}
+
+
+/*
+ * Task 3
+ */
+
+void MCD_startDmaSingleEu(char *srcAddr, short srcIncr, char *destAddr,
+			  short destIncr, int dmaSize, short xferSizeIncr,
+			  int flags, int *currBD, int *cSave,
+			  struct TaskTableEntry *taskTable, int channel)
+{
+	u32 var = taskTable[channel].varTab;
+	u16 tcrValue;
+
+	MCD_SET_VAR(var, 8, (u32)srcAddr);    /* var[8] */
+	MCD_SET_VAR(var, 25, U16PAIR(0xe000, srcIncr));   /* inc[1] */
+	MCD_SET_VAR(var, 3, (u32)destAddr);   /* var[3] */
+	MCD_SET_VAR(var, 24, U16PAIR(0xe000, destIncr));  /* inc[0] */
+	MCD_SET_VAR(var, 4, (u32)dmaSize);    /* var[4] */
+	MCD_SET_VAR(var, 26, U16PAIR(0x2000, xferSizeIncr));  /* inc[2] */
+	MCD_SET_VAR(var, 6, (u32)flags);  /* var[6] */
+	MCD_SET_VAR(var, 2, (u32)currBD); /* var[2] */
+	MCD_SET_VAR(var, 0, (u32)cSave);  /* var[0] */
+	MCD_SET_VAR(var, 1, (u32)0x00000000); /* var[1] */
+	MCD_SET_VAR(var, 5, (u32)0x00000000); /* var[5] */
+	MCD_SET_VAR(var, 7, (u32)0x00000000); /* var[7] */
+	MCD_SET_VAR(var, 9, (u32)0x00000000); /* var[9] */
+	MCD_SET_VAR(var, 10, (u32)0x00000001);    /* var[10] */
+	MCD_SET_VAR(var, 11, (u32)0x00000004);    /* var[11] */
+	MCD_SET_VAR(var, 12, (u32)0x08000000);    /* var[12] */
+	MCD_SET_VAR(var, 27, (u32)0x00000000);    /* inc[3] */
+	MCD_SET_VAR(var, 28, (u32)0xc0000000);    /* inc[4] */
+	MCD_SET_VAR(var, 29, (u32)0x80000000);    /* inc[5] */
+	MCD_SET_VAR(var, 30, (u32)0x80000001);    /* inc[6] */
+	MCD_SET_VAR(var, 31, (u32)0x40000000);    /* inc[7] */
+
+	/* Set the task's Enable bit in its Task Control Register */
+	tcrValue = readw(&MCD_dmaBar->taskControl[channel]);
+	writew(tcrValue | 0x8000, &MCD_dmaBar->taskControl[channel]);
+}
+
+
+/*
+ * Task 4
+ */
+
+void MCD_startDmaENetRcv(char *bDBase, char *currBD, char *rcvFifoPtr,
+			 struct TaskTableEntry *taskTable, int channel)
+{
+	u32 var = taskTable[channel].varTab;
+	u16 tcrValue;
+
+	MCD_SET_VAR(var, 0, (u32)bDBase); /* var[0] */
+	MCD_SET_VAR(var, 3, (u32)currBD); /* var[3] */
+	MCD_SET_VAR(var, 6, (u32)rcvFifoPtr); /* var[6] */
+	MCD_SET_VAR(var, 1, (u32)0x00000000); /* var[1] */
+	MCD_SET_VAR(var, 2, (u32)0x00000000); /* var[2] */
+	MCD_SET_VAR(var, 4, (u32)0x00000000); /* var[4] */
+	MCD_SET_VAR(var, 5, (u32)0x00000000); /* var[5] */
+	MCD_SET_VAR(var, 7, (u32)0x00000000); /* var[7] */
+	MCD_SET_VAR(var, 8, (u32)0x00000000); /* var[8] */
+	MCD_SET_VAR(var, 9, (u32)0x0000ffff); /* var[9] */
+	MCD_SET_VAR(var, 10, (u32)0x30000000);    /* var[10] */
+	MCD_SET_VAR(var, 11, (u32)0x0fffffff);    /* var[11] */
+	MCD_SET_VAR(var, 12, (u32)0x00000008);    /* var[12] */
+	MCD_SET_VAR(var, 24, (u32)0x00000000);    /* inc[0] */
+	MCD_SET_VAR(var, 25, (u32)0x60000000);    /* inc[1] */
+	MCD_SET_VAR(var, 26, (u32)0x20000004);    /* inc[2] */
+	MCD_SET_VAR(var, 27, (u32)0x40000000);    /* inc[3] */
+
+	/* Set the task's Enable bit in its Task Control Register */
+	tcrValue = readw(&MCD_dmaBar->taskControl[channel]);
+	writew(tcrValue | 0x8000, &MCD_dmaBar->taskControl[channel]);
+}
+
+
+/*
+ * Task 5
+ */
+
+void MCD_startDmaENetXmit(char *bDBase, char *currBD, char *xmitFifoPtr,
+			  struct TaskTableEntry *taskTable, int channel)
+{
+	u32 var = taskTable[channel].varTab;
+	u16 tcrValue;
+
+	MCD_SET_VAR(var, 0, (u32)bDBase); /* var[0] */
+	MCD_SET_VAR(var, 3, (u32)currBD); /* var[3] */
+	MCD_SET_VAR(var, 11, (u32)xmitFifoPtr);   /* var[11] */
+	MCD_SET_VAR(var, 1, (u32)0x00000000); /* var[1] */
+	MCD_SET_VAR(var, 2, (u32)0x00000000); /* var[2] */
+	MCD_SET_VAR(var, 4, (u32)0x00000000); /* var[4] */
+	MCD_SET_VAR(var, 5, (u32)0x00000000); /* var[5] */
+	MCD_SET_VAR(var, 6, (u32)0x00000000); /* var[6] */
+	MCD_SET_VAR(var, 7, (u32)0x00000000); /* var[7] */
+	MCD_SET_VAR(var, 8, (u32)0x00000000); /* var[8] */
+	MCD_SET_VAR(var, 9, (u32)0x00000000); /* var[9] */
+	MCD_SET_VAR(var, 10, (u32)0x00000000);    /* var[10] */
+	MCD_SET_VAR(var, 12, (u32)0x00000000);    /* var[12] */
+	MCD_SET_VAR(var, 13, (u32)0x0000ffff);    /* var[13] */
+	MCD_SET_VAR(var, 14, (u32)0xffffffff);    /* var[14] */
+	MCD_SET_VAR(var, 15, (u32)0x00000004);    /* var[15] */
+	MCD_SET_VAR(var, 16, (u32)0x00000008);    /* var[16] */
+	MCD_SET_VAR(var, 24, (u32)0x00000000);    /* inc[0] */
+	MCD_SET_VAR(var, 25, (u32)0x60000000);    /* inc[1] */
+	MCD_SET_VAR(var, 26, (u32)0x40000000);    /* inc[2] */
+	MCD_SET_VAR(var, 27, (u32)0xc000fffc);    /* inc[3] */
+	MCD_SET_VAR(var, 28, (u32)0xe0000004);    /* inc[4] */
+	MCD_SET_VAR(var, 29, (u32)0x80000000);    /* inc[5] */
+	MCD_SET_VAR(var, 30, (u32)0x4000ffff);    /* inc[6] */
+	MCD_SET_VAR(var, 31, (u32)0xe0000001);    /* inc[7] */
+
+	/* Set the task's Enable bit in its Task Control Register */
+	tcrValue = readw(&MCD_dmaBar->taskControl[channel]);
+	writew(tcrValue | 0x8000, &MCD_dmaBar->taskControl[channel]);
+}
diff --git a/drivers/dma/fsl_mcd_dma/MCD_tasksInit.h b/drivers/dma/fsl_mcd_dma/MCD_tasksInit.h
new file mode 100644
index 0000000..0a9722c
--- /dev/null
+++ b/drivers/dma/fsl_mcd_dma/MCD_tasksInit.h
@@ -0,0 +1,76 @@
+/*
+ * drivers/dma/MCD_tasksInit.h
+ *
+ * Copyright (C) 2004-2008 Freescale Semiconductor, Inc.
+ *     Kurt Mahan <kmahan@freescale.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+ * MA 02111-1307 USA
+ */
+#ifndef MCD_TSK_INIT_H
+#define MCD_TSK_INIT_H 1
+
+/*
+ * Autogenerated - Do not edit!
+ */
+
+/*
+ * Task 0
+ */
+void  MCD_startDmaChainNoEu(int *currBD, short srcIncr, short destIncr,
+			    int xferSize, short xferSizeIncr, int *cSave,
+			    struct TaskTableEntry *taskTable, int channel);
+
+
+/*
+ * Task 1
+ */
+void  MCD_startDmaSingleNoEu(char *srcAddr, short srcIncr, char *destAddr,
+			     short destIncr, int dmaSize, short xferSizeIncr,
+			     int flags, int *currBD, int *cSave,
+			     struct TaskTableEntry *taskTable, int channel);
+
+
+/*
+ * Task 2
+ */
+void  MCD_startDmaChainEu(int *currBD, short srcIncr, short destIncr,
+			  int xferSize, short xferSizeIncr, int *cSave,
+			  struct TaskTableEntry *taskTable, int channel);
+
+
+/*
+ * Task 3
+ */
+void  MCD_startDmaSingleEu(char *srcAddr, short srcIncr, char *destAddr,
+			   short destIncr, int dmaSize, short xferSizeIncr,
+			   int flags, int *currBD, int *cSave,
+			   struct TaskTableEntry *taskTable, int channel);
+
+
+/*
+ * Task 4
+ */
+void  MCD_startDmaENetRcv(char *bDBase, char *currBD, char *rcvFifoPtr,
+			  struct TaskTableEntry *taskTable, int channel);
+
+
+/*
+ * Task 5
+ */
+void  MCD_startDmaENetXmit(char *bDBase, char *currBD, char *xmitFifoPtr,
+			   struct TaskTableEntry *taskTable, int channel);
+
+#endif  /* MCD_TSK_INIT_H */
diff --git a/drivers/dma/fsl_mcd_dma/Makefile b/drivers/dma/fsl_mcd_dma/Makefile
new file mode 100644
index 0000000..6bdd725
--- /dev/null
+++ b/drivers/dma/fsl_mcd_dma/Makefile
@@ -0,0 +1 @@
+obj-y	+= MCD_dmaApi.o MCD_tasks.o MCD_tasksInit.o
diff --git a/include/linux/MCD_dma.h b/include/linux/MCD_dma.h
new file mode 100644
index 0000000..da0a928
--- /dev/null
+++ b/include/linux/MCD_dma.h
@@ -0,0 +1,376 @@
+/*
+ * drivers/dma/MCD_dma.h
+ *
+ * Copyright (C) 2004-2008 Freescale Semiconductor, Inc.
+ *     Kurt Mahan <kmahan@freescale.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+ * MA 02111-1307 USA
+ */
+#ifndef _MCD_API_H
+#define _MCD_API_H
+
+/*
+ * Turn Execution Unit tasks ON (#define) or OFF (#undef)
+ */
+#undef MCD_INCLUDE_EU
+
+/*
+ * Number of DMA channels
+ */
+#define NCHANNELS 16
+
+/*
+ * Total number of variants
+ */
+#ifdef MCD_INCLUDE_EU
+#define NUMOFVARIANTS   6
+#else
+#define NUMOFVARIANTS   4
+#endif
+
+/*
+ * Define sizes of the various tables
+ */
+#define TASK_TABLE_SIZE     (NCHANNELS*32)
+#define VAR_TAB_SIZE        (128)
+#define CONTEXT_SAVE_SIZE   (128)
+#define FUNCDESC_TAB_SIZE   (256)
+
+#ifdef MCD_INCLUDE_EU
+#define FUNCDESC_TAB_NUM    16
+#else
+#define FUNCDESC_TAB_NUM    1
+#endif
+
+
+#ifndef DEFINESONLY
+
+#include <asm-generic/int-ll64.h>
+
+/*
+ * These structures represent the internal registers of the
+ * multi-channel DMA
+ */
+struct dmaRegs {
+	u32 taskbar;         /* task table base address register */
+	u32 currPtr;
+	u32 endPtr;
+	u32 varTablePtr;
+	u16 dma_rsvd0;
+	u16 ptdControl;      /* ptd control */
+	u32 intPending;      /* interrupt pending register */
+	u32 intMask;         /* interrupt mask register */
+	u16 taskControl[16]; /* task control registers */
+	u8  priority[32];    /* priority registers */
+	u32 initiatorMux;    /* initiator mux control */
+	u32 taskSize0;       /* task size control register 0. */
+	u32 taskSize1;       /* task size control register 1. */
+	u32 dma_rsvd1;       /* reserved */
+	u32 dma_rsvd2;       /* reserved */
+	u32 debugComp1;      /* debug comparator 1 */
+	u32 debugComp2;      /* debug comparator 2 */
+	u32 debugControl;    /* debug control */
+	u32 debugStatus;     /* debug status */
+	u32 ptdDebug;        /* priority task decode debug */
+	u32 dma_rsvd3[31];   /* reserved */
+};
+
+extern struct dmaRegs *MCD_dmaBar;
+
+#endif
+
+/*
+ * PTD contrl reg bits
+ */
+#define PTD_CTL_TSK_PRI         0x8000
+#define PTD_CTL_COMM_PREFETCH   0x0001
+
+/*
+ * Task Control reg bits and field masks
+ */
+#define TASK_CTL_EN             0x8000
+#define TASK_CTL_VALID          0x4000
+#define TASK_CTL_ALWAYS         0x2000
+#define TASK_CTL_INIT_MASK      0x1f00
+#define TASK_CTL_ASTRT          0x0080
+#define TASK_CTL_HIPRITSKEN     0x0040
+#define TASK_CTL_HLDINITNUM     0x0020
+#define TASK_CTL_ASTSKNUM_MASK  0x000f
+
+/*
+ * Priority reg bits and field masks
+ */
+#define PRIORITY_HLD            0x80
+#define PRIORITY_PRI_MASK       0x07
+
+/*
+ * Debug Control reg bits and field masks
+ */
+#define DBG_CTL_BLOCK_TASKS_MASK    0xffff0000
+#define DBG_CTL_AUTO_ARM            0x00008000
+#define DBG_CTL_BREAK               0x00004000
+#define DBG_CTL_COMP1_TYP_MASK      0x00003800
+#define DBG_CTL_COMP2_TYP_MASK      0x00000070
+#define DBG_CTL_EXT_BREAK           0x00000004
+#define DBG_CTL_INT_BREAK           0x00000002
+
+/*
+ * PTD Debug reg selector addresses
+ * This reg must be written with a value to show the contents of
+ * one of the desired internal register.
+ */
+#define PTD_DBG_REQ             0x00 /* shows the state of 31 initiators */
+#define PTD_DBG_TSK_VLD_INIT    0x01 /* shows which 16 tasks are valid and
+					have initiators asserted */
+
+
+/*
+ * General return values
+ */
+#define MCD_OK                   0
+#define MCD_ERROR               -1
+#define MCD_TABLE_UNALIGNED     -2
+#define MCD_CHANNEL_INVALID     -3
+
+/*
+ * MCD_initDma input flags
+ */
+#define MCD_RELOC_TASKS         0x00000001
+#define MCD_NO_RELOC_TASKS      0x00000000
+#define MCD_COMM_PREFETCH_EN    0x00000002  /* Commbus Prefetching - MCF547x/548x ONLY */
+
+/*
+ * MCD_dmaStatus Status Values for each channel
+ */
+#define MCD_NO_DMA  1 /* No DMA has been requested since reset */
+#define MCD_IDLE    2 /* DMA active, but the initiator is currently inactive */
+#define MCD_RUNNING 3 /* DMA active, and the initiator is currently active */
+#define MCD_PAUSED  4 /* DMA active but it is currently paused */
+#define MCD_HALTED  5 /* the most recent DMA has been killed with MCD_killTask() */
+#define MCD_DONE    6 /* the most recent DMA has completed. */
+
+
+/*
+ * MCD_startDma parameter defines
+ */
+
+/*
+ * Constants for the funcDesc parameter
+ */
+/* Byte swapping: */
+#define MCD_NO_BYTE_SWAP    0x00045670  /* to disable byte swapping. */
+#define MCD_BYTE_REVERSE    0x00076540  /* to reverse the bytes of each u32 of the DMAed data. */
+#define MCD_U16_REVERSE     0x00067450  /* to reverse the 16-bit halves of
+					   each 32-bit data value being DMAed.*/
+#define MCD_U16_BYTE_REVERSE    0x00054760 /* to reverse the byte halves of each
+					    16-bit half of each 32-bit data value DMAed */
+#define MCD_NO_BIT_REV  0x00000000  /* do not reverse the bits of each byte DMAed. */
+#define MCD_BIT_REV     0x00088880  /* reverse the bits of each byte DMAed */
+/* CRCing: */
+#define MCD_CRC16       0xc0100000  /* to perform CRC-16 on DMAed data. */
+#define MCD_CRCCCITT    0xc0200000  /* to perform CRC-CCITT on DMAed data. */
+#define MCD_CRC32       0xc0300000  /* to perform CRC-32 on DMAed data. */
+#define MCD_CSUMINET    0xc0400000  /* to perform internet checksums on DMAed data.*/
+#define MCD_NO_CSUM     0xa0000000  /* to perform no checksumming. */
+
+#define MCD_FUNC_NOEU1 (MCD_NO_BYTE_SWAP | MCD_NO_BIT_REV | MCD_NO_CSUM)
+#define MCD_FUNC_NOEU2 (MCD_NO_BYTE_SWAP | MCD_NO_CSUM)
+
+/*
+ * Constants for the flags parameter
+ */
+#define MCD_TT_FLAGS_RL   0x00000001 /* Read line */
+#define MCD_TT_FLAGS_CW   0x00000002 /* Combine Writes */
+#define MCD_TT_FLAGS_SP   0x00000004 /* Speculative prefetch(XLB) MCF547x/548x ONLY  */
+#define MCD_TT_FLAGS_PI   0x00000040 /* Precise Increment */
+#define MCD_TT_FLAGS_MASK 0x000000ff
+#define MCD_TT_FLAGS_DEF  (MCD_TT_FLAGS_RL | MCD_TT_FLAGS_CW)
+
+#define MCD_SINGLE_DMA  0x00000100 /* Unchained DMA */
+#define MCD_CHAIN_DMA              /* TBD */
+#define MCD_EU_DMA                 /* TBD */
+#define MCD_FECTX_DMA   0x00001000 /* FEC TX ring DMA */
+#define MCD_FECRX_DMA   0x00002000 /* FEC RX ring DMA */
+
+
+/* these flags are valid for MCD_startDma and the chained buffer descriptors */
+#define MCD_BUF_READY   0x80000000 /* indicates that this buffer is now under the DMA's control */
+#define MCD_WRAP        0x20000000 /* to tell the FEC Dmas to wrap to the first BD */
+#define MCD_INTERRUPT   0x10000000 /* to generate an interrupt after completion of the DMA. */
+#define MCD_END_FRAME   0x08000000 /* tell the DMA to end the frame when transferring
+				      last byte of data in buffer */
+#define MCD_CRC_RESTART 0x40000000 /* to empty out the accumulated checksum
+				      prior to performing the DMA. */
+
+/* Defines for the FEC buffer descriptor control/status word */
+#define MCD_FEC_BUF_READY   0x8000
+#define MCD_FEC_WRAP        0x2000
+#define MCD_FEC_INTERRUPT   0x1000
+#define MCD_FEC_END_FRAME   0x0800
+
+
+/*
+ * Defines for general intuitiveness
+ */
+
+#define MCD_TRUE  1
+#define MCD_FALSE 0
+
+/*
+ * Three different cases for destination and source.
+ */
+#define MINUS1          -1
+#define ZERO            0
+#define PLUS1           1
+
+#ifndef DEFINESONLY
+
+/* Task Table Entry struct */
+struct TaskTableEntry {
+	u32 TDTstart;   /* task descriptor table start */
+	u32 TDTend;     /* task descriptor table end */
+	u32 varTab;     /* variable table start */
+	u32 FDTandFlags;    /* function descriptor table start and flags */
+	u32 descAddrAndStatus;
+	u32 modifiedVarTab;
+	u32 contextSaveSpace;   /* context save space start */
+	u32 literalBases;
+};
+
+/*
+ * These are the real and model task tables as generated by the
+ * build process
+ */
+/* let's match the current definition in MCD_tasks.c */
+extern const u32 MCD_realTaskTableSrc[];
+extern const u32 MCD_modelTaskTableSrc[];
+
+extern u32 MCD_funcDescTab0[];
+
+/* Chained buffer descriptor */
+struct MCD_bufDesc {
+	u32 flags;         /* flags describing the DMA */
+	u32 csumResult;    /* checksum from checksumming performed since last checksum reset */
+	s8  *srcAddr;      /* the address to move data from */
+	s8  *destAddr;     /* the address to move data to */
+	s8  *lastDestAddr; /* the last address written to */
+	u32 dmaSize;       /* the number of bytes to transfer independent of the transfer size */
+	struct MCD_bufDesc *next; /* next buffer descriptor in chain */
+	u32 info;          /* private information about this descriptor;  DMA does not affect it */
+};
+
+extern struct MCD_bufDesc MCD_singleBufDescs[NCHANNELS];
+
+/* Progress Query struct */
+struct MCD_XferProg {
+	s8 *lastSrcAddr;         /* the most-recent or last, post-increment source address */
+	s8 *lastDestAddr;        /* the most-recent or last, post-increment destination address */
+	u32  dmaSize;            /* the amount of data transferred for the current buffer */
+	struct MCD_bufDesc *currBufDesc;/* pointer to the current buffer descriptor being DMAed */
+};
+
+
+/* FEC buffer descriptor */
+struct MCD_bufDescFec {
+	u16 statCtrl;
+	u16 length;
+	u32 dataPointer;
+};
+
+
+/*************************************************************************/
+/*
+ * API function Prototypes  - see MCD_dmaApi.c for further notes
+ */
+
+/*
+ * MCD_startDma starts a particular kind of DMA .
+ */
+int MCD_startDma(
+	int channel,   /* the channel on which to run the DMA */
+	s8  *srcAddr,  /* the address to move data from, or buffer-descriptor address */
+	s16 srcIncr,   /* the amount to increment the source address per transfer */
+	s8  *destAddr, /* the address to move data to */
+	s16 destIncr,  /* the amount to increment the destination address per transfer */
+	u32 dmaSize,   /* the number of bytes to transfer independent of the transfer size */
+	u32 xferSize,  /* the number of bytes in each data movement (1, 2, or 4) */
+	u32 initiator, /* what device initiates the DMA */
+	int priority,  /* priority of the DMA */
+	u32 flags,     /* flags describing the DMA */
+	u32 funcDesc   /* a description of byte swapping, bit swapping, and CRC actions */
+);
+
+/*
+ * MCD_initDma() initializes the DMA API by setting up a pointer to the DMA
+ * registers, relocating and creating the appropriate task structures, and
+ * setting up some global settings
+ */
+int MCD_initDma(struct dmaRegs *sDmaBarAddr, void *taskTableDest, u32 flags);
+
+/*
+ * MCD_dmaStatus() returns the status of the DMA on the requested channel.
+ */
+int MCD_dmaStatus(int channel);
+
+/*
+ * MCD_XferProgrQuery() returns progress of DMA on requested channel
+ */
+int MCD_XferProgrQuery(int channel, struct MCD_XferProg *progRep);
+
+/*
+ * MCD_killDma() halts the DMA on the requested channel, without any
+ * intention of resuming the DMA.
+ */
+int MCD_killDma(int channel);
+
+/*
+ * MCD_continDma() continues a DMA which as stopped due to encountering an
+ * unready buffer descriptor.
+ */
+int MCD_continDma(int channel);
+
+/*
+ * MCD_pauseDma() pauses the DMA on the given channel ( if any DMA is
+ * running on that channel).
+ */
+int MCD_pauseDma(int channel);
+
+/*
+ * MCD_resumeDma() resumes the DMA on a given channel (if any DMA is
+ * running on that channel).
+ */
+int MCD_resumeDma(int channel);
+
+/*
+ * MCD_csumQuery provides the checksum/CRC after performing a non-chained DMA
+ */
+int MCD_csumQuery(int channel, u32 *csum);
+
+/*
+ * MCD_getCodeSize provides the packed size required by the microcoded task
+ * and structures.
+ */
+int MCD_getCodeSize(void);
+
+/*
+ * MCD_getVersion provides a pointer to a version string and returns a
+ * version number.
+ */
+int MCD_getVersion(char **longVersion);
+
+#endif  /* DEFINESONLY */
+
+#endif /* _MCD_API_H */
-- 
1.7.1

