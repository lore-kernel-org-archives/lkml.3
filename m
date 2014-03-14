Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbaCNQQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 12:16:43 -0400
Received: from mail-bn1blp0185.outbound.protection.outlook.com ([207.46.163.185]:15937
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755367AbaCNQQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 12:16:39 -0400
Date: Fri, 14 Mar 2014 21:42:16 +0530
From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
To: <jejb@kernel.org>, <JBottomley@Parallels.com>
CC: <linux-scsi@vger.kernel.org>, <Sathya.Prakash@lsi.com>,
        <Nagalakshmi.Nandigama@lsi.com>, <sreekanth.reddy@lsi.com>,
        <linux-kernel@vger.kernel.org>, <sreekanthreddy0547@gmail.com>
Subject: [PATCH 5/9][SCSI]mpt3sas: MPI2.5 Rev H (2.5.3) specifications
Message-ID: <20140314161216.GA8383@lsi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.19.220.100;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(189002)(199002)(377424004)(87266001)(74876001)(85306002)(87936001)(74706001)(81542001)(33656001)(50466002)(81342001)(69226001)(31966008)(74366001)(92726001)(551934002)(54356001)(53806001)(51856001)(23726002)(46406003)(56776001)(76796001)(83322001)(19580395003)(94316002)(6806004)(44976005)(80976001)(19580405001)(81686001)(63696002)(47776003)(20776003)(36756003)(65816001)(93516002)(86362001)(80022001)(59766001)(93136001)(77982001)(575784001)(54316002)(95416001)(85852003)(95666003)(97186001)(81816001)(83072002)(47446002)(97336001)(77096001)(56816005)(47976001)(79102001)(83506001)(74662001)(76786001)(46102001)(92566001)(76482001)(74502001)(16796002)(97756001)(47736001)(90146001)(4396001)(57986002)(94946001)(50986001)(76176001)(49866001)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR07MB068;H:COSEXCH10.lsi.com;FPR:2054F44F.AE369F2D.EBE0217B.893AFE42.20774;PTR:cosexch10.lsi.com;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0150F3F97D
X-OriginatorOrg: lsi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the change set in MPI2.5 Rev H specification and 2.00.32 header files
1) Added reserved fields to IO Unit Page 7 for future use.
2) Added optional functionality to IOCInit Request so that
   the host may specify a separate base address for each
   Reply Descriptor Post Queue. IOC support for this is
   indicated using a new IOCCapabilities bit in the IOCFacts Reply.
3) Added Toolbox Console Text Display Tool
   The host uses the Console Text Display Tool to send a string to
   IOC's Console using different console types (eg: UART serial terminal or Ethernet terminal).
4) Firmware images can now be signed using an encrypted hash.
5) Added MPI2_SAS_OP_TRANSMIT_PORT_SELECT_SIGNAL
6) Added more details about configuration page restrictions when Host Based Discovery is enabled
   Enabling host based discovery affects the availability of some configuration pages and events.
   The SAS Expander, SAS Device, and SAS Enclosure configuration  pages are not available from the IOC.
   The IOC returns an error status to any Configuration Request message attempting to access these pages.
   The IOC does not send the SAS Discovery Event, the SAS Topology Change List Event, or
   the SAS Enclosure Device Status Change Event when host based discovery is enabled.
7) Bit 13 of the SAS IO Unit Page 1 ControlFlags field is now obsolete.
   It was used to enable limiting direct attached SATA maximum link rate to 1.5 Gbps.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
---
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h |   10 ++++-
 drivers/scsi/mpt3sas/mpi/mpi2_ioc.h  |   62 ++++++++++++++++++++++++++++++++-
 drivers/scsi/mpt3sas/mpi/mpi2_sas.h  |    6 ++-
 drivers/scsi/mpt3sas/mpi/mpi2_tool.h |   43 +++++++++++++++++++++++-
 4 files changed, 114 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
index 5b0e5c1..becee07 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
@@ -6,7 +6,7 @@
  *         Title:  MPI Configuration messages and pages
  * Creation Date:  November 10, 2006
  *
- *   mpi2_cnfg.h Version:  02.00.25
+ *   mpi2_cnfg.h Version:  02.00.26
  *
  * NOTE: Names (typedefs, defines, etc.) beginning with an MPI25 or Mpi25
  *       prefix are for use only on MPI v2.5 products, and must not be used
@@ -163,6 +163,8 @@
  * 04-09-13  02.00.25  Added MPI2_IOUNITPAGE1_ATA_SECURITY_FREEZE_LOCK.
  *                     Fixed MPI2_IOUNITPAGE5_DMA_CAP_MASK_MAX_REQUESTS to
  *                     match the specification.
+ * 08-19-13  02.00.26  Added reserved words to MPI2_CONFIG_PAGE_IO_UNIT_7 for
+ *			future use.
  * --------------------------------------------------------------------------
  */
 
@@ -924,11 +926,15 @@ typedef struct _MPI2_CONFIG_PAGE_IO_UNIT_7 {
 	U8
 		BoardTemperatureUnits;                  /*0x16 */
 	U8                      Reserved3;              /*0x17 */
+	U32			Reserved4;		/* 0x18 */
+	U32			Reserved5;		/* 0x1C */
+	U32			Reserved6;		/* 0x20 */
+	U32			Reserved7;		/* 0x24 */
 } MPI2_CONFIG_PAGE_IO_UNIT_7,
 	*PTR_MPI2_CONFIG_PAGE_IO_UNIT_7,
 	Mpi2IOUnitPage7_t, *pMpi2IOUnitPage7_t;
 
-#define MPI2_IOUNITPAGE7_PAGEVERSION                    (0x02)
+#define MPI2_IOUNITPAGE7_PAGEVERSION			(0x04)
 
 /*defines for IO Unit Page 7 CurrentPowerMode and PreviousPowerMode fields */
 #define MPI25_IOUNITPAGE7_PM_INIT_MASK              (0xC0)
diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_ioc.h b/drivers/scsi/mpt3sas/mpi/mpi2_ioc.h
index e2bb821..15813f3 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2_ioc.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_ioc.h
@@ -6,7 +6,7 @@
  *         Title:  MPI IOC, Port, Event, FW Download, and FW Upload messages
  * Creation Date:  October 11, 2006
  *
- * mpi2_ioc.h Version:  02.00.22
+ * mpi2_ioc.h Version:  02.00.23
  *
  * NOTE: Names (typedefs, defines, etc.) beginning with an MPI25 or Mpi25
  *       prefix are for use only on MPI v2.5 products, and must not be used
@@ -127,6 +127,11 @@
  * 07-26-12  02.00.22  Added MPI2_IOCFACTS_EXCEPT_PARTIAL_MEMORY_FAILURE.
  *                     Added ElapsedSeconds field to
  *                     MPI2_EVENT_DATA_IR_OPERATION_STATUS.
+ * 08-19-13  02.00.23  For IOCInit, added MPI2_IOCINIT_MSGFLAG_RDPQ_ARRAY_MODE
+ *			and MPI2_IOC_INIT_RDPQ_ARRAY_ENTRY.
+ *			Added MPI2_IOCFACTS_CAPABILITY_RDPQ_ARRAY_CAPABLE.
+ *			Added MPI2_FW_DOWNLOAD_ITYPE_PUBLIC_KEY.
+ *			Added Encrypted Hash Extended Image.
  * --------------------------------------------------------------------------
  */
 
@@ -182,6 +187,10 @@ typedef struct _MPI2_IOC_INIT_REQUEST {
 #define MPI2_WHOINIT_HOST_DRIVER                (0x04)
 #define MPI2_WHOINIT_MANUFACTURER               (0x05)
 
+/* MsgFlags */
+#define MPI2_IOCINIT_MSGFLAG_RDPQ_ARRAY_MODE    (0x01)
+
+
 /*MsgVersion */
 #define MPI2_IOCINIT_MSGVERSION_MAJOR_MASK      (0xFF00)
 #define MPI2_IOCINIT_MSGVERSION_MAJOR_SHIFT     (8)
@@ -194,9 +203,19 @@ typedef struct _MPI2_IOC_INIT_REQUEST {
 #define MPI2_IOCINIT_HDRVERSION_DEV_MASK        (0x00FF)
 #define MPI2_IOCINIT_HDRVERSION_DEV_SHIFT       (0)
 
-/*minimum depth for the Reply Descriptor Post Queue */
+/*minimum depth for a Reply Descriptor Post Queue */
 #define MPI2_RDPQ_DEPTH_MIN                     (16)
 
+/* Reply Descriptor Post Queue Array Entry */
+typedef struct _MPI2_IOC_INIT_RDPQ_ARRAY_ENTRY {
+	U64                 RDPQBaseAddress;                    /* 0x00 */
+	U32                 Reserved1;                          /* 0x08 */
+	U32                 Reserved2;                          /* 0x0C */
+} MPI2_IOC_INIT_RDPQ_ARRAY_ENTRY,
+*PTR_MPI2_IOC_INIT_RDPQ_ARRAY_ENTRY,
+Mpi2IOCInitRDPQArrayEntry, *pMpi2IOCInitRDPQArrayEntry;
+
+
 /*IOCInit Reply message */
 typedef struct _MPI2_IOC_INIT_REPLY {
 	U8 WhoInit;		/*0x00 */
@@ -306,6 +325,7 @@ typedef struct _MPI2_IOC_FACTS_REPLY {
 /*ProductID field uses MPI2_FW_HEADER_PID_ */
 
 /*IOCCapabilities */
+#define MPI2_IOCFACTS_CAPABILITY_RDPQ_ARRAY_CAPABLE     (0x00040000)
 #define MPI25_IOCFACTS_CAPABILITY_FAST_PATH_CAPABLE     (0x00020000)
 #define MPI2_IOCFACTS_CAPABILITY_HOST_BASED_DISCOVERY   (0x00010000)
 #define MPI2_IOCFACTS_CAPABILITY_MSI_X_INDEX            (0x00008000)
@@ -1140,6 +1160,7 @@ typedef struct _MPI2_FW_DOWNLOAD_REQUEST {
 #define MPI2_FW_DOWNLOAD_ITYPE_MEGARAID             (0x09)
 #define MPI2_FW_DOWNLOAD_ITYPE_COMPLETE             (0x0A)
 #define MPI2_FW_DOWNLOAD_ITYPE_COMMON_BOOT_BLOCK    (0x0B)
+#define MPI2_FW_DOWNLOAD_ITYPE_PUBLIC_KEY           (0x0C)
 #define MPI2_FW_DOWNLOAD_ITYPE_MIN_PRODUCT_SPECIFIC (0xF0)
 
 /*MPI v2.0 FWDownload TransactionContext Element */
@@ -1404,6 +1425,7 @@ typedef struct _MPI2_EXT_IMAGE_HEADER {
 #define MPI2_EXT_IMAGE_TYPE_FLASH_LAYOUT            (0x06)
 #define MPI2_EXT_IMAGE_TYPE_SUPPORTED_DEVICES       (0x07)
 #define MPI2_EXT_IMAGE_TYPE_MEGARAID                (0x08)
+#define MPI2_EXT_IMAGE_TYPE_ENCRYPTED_HASH          (0x09)
 #define MPI2_EXT_IMAGE_TYPE_MIN_PRODUCT_SPECIFIC    (0x80)
 #define MPI2_EXT_IMAGE_TYPE_MAX_PRODUCT_SPECIFIC    (0xFF)
 
@@ -1560,6 +1582,42 @@ typedef struct _MPI2_INIT_IMAGE_FOOTER {
 /*defines for the ResetVector field */
 #define MPI2_INIT_IMAGE_RESETVECTOR_OFFSET      (0x14)
 
+
+/* Encrypted Hash Extended Image Data */
+
+typedef struct _MPI25_ENCRYPTED_HASH_ENTRY {
+	U8		HashImageType;		/* 0x00 */
+	U8		HashAlgorithm;		/* 0x01 */
+	U8		EncryptionAlgorithm;	/* 0x02 */
+	U8		Reserved1;		/* 0x03 */
+	U32		Reserved2;		/* 0x04 */
+	U32		EncryptedHash[1];	/* 0x08 */ /* variable length */
+} MPI25_ENCRYPTED_HASH_ENTRY, *PTR_MPI25_ENCRYPTED_HASH_ENTRY,
+Mpi25EncryptedHashEntry_t, *pMpi25EncryptedHashEntry_t;
+
+/* values for HashImageType */
+#define MPI25_HASH_IMAGE_TYPE_UNUSED		(0x00)
+#define MPI25_HASH_IMAGE_TYPE_FIRMWARE		(0x01)
+
+/* values for HashAlgorithm */
+#define MPI25_HASH_ALGORITHM_UNUSED		(0x00)
+#define MPI25_HASH_ALGORITHM_SHA256		(0x01)
+
+/* values for EncryptionAlgorithm */
+#define MPI25_ENCRYPTION_ALG_UNUSED		(0x00)
+#define MPI25_ENCRYPTION_ALG_RSA256		(0x01)
+
+typedef struct _MPI25_ENCRYPTED_HASH_DATA {
+	U8				ImageVersion;		/* 0x00 */
+	U8				NumHash;		/* 0x01 */
+	U16				Reserved1;		/* 0x02 */
+	U32				Reserved2;		/* 0x04 */
+	MPI25_ENCRYPTED_HASH_ENTRY	EncryptedHashEntry[1];  /* 0x08 */
+} MPI25_ENCRYPTED_HASH_DATA, *PTR_MPI25_ENCRYPTED_HASH_DATA,
+Mpi25EncryptedHashData_t, *pMpi25EncryptedHashData_t;
+
+
+
 /****************************************************************************
 * PowerManagementControl message
 ****************************************************************************/
diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_sas.h b/drivers/scsi/mpt3sas/mpi/mpi2_sas.h
index cba046f..361a275 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2_sas.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_sas.h
@@ -6,7 +6,7 @@
  *         Title:  MPI Serial Attached SCSI structures and definitions
  * Creation Date:  February 9, 2007
  *
- * mpi2_sas.h Version:  02.00.07
+ * mpi2_sas.h Version:  02.00.08
  *
  * NOTE: Names (typedefs, defines, etc.) beginning with an MPI25 or Mpi25
  *       prefix are for use only on MPI v2.5 products, and must not be used
@@ -30,6 +30,8 @@
  * 11-18-11  02.00.06  Incorporating additions for MPI v2.5.
  * 07-10-12  02.00.07  Added MPI2_SATA_PT_SGE_UNION for use in the SATA
  *                     Passthrough Request message.
+ * 08-19-13  02.00.08  Made MPI2_SAS_OP_TRANSMIT_PORT_SELECT_SIGNAL obsolete
+ *			for anything newer than MPI v2.0.
  * --------------------------------------------------------------------------
  */
 
@@ -251,7 +253,7 @@ typedef struct _MPI2_SAS_IOUNIT_CONTROL_REQUEST {
 #define MPI2_SAS_OP_PHY_CLEAR_ERROR_LOG         (0x08)
 #define MPI2_SAS_OP_SEND_PRIMITIVE              (0x0A)
 #define MPI2_SAS_OP_FORCE_FULL_DISCOVERY        (0x0B)
-#define MPI2_SAS_OP_TRANSMIT_PORT_SELECT_SIGNAL (0x0C)
+#define MPI2_SAS_OP_TRANSMIT_PORT_SELECT_SIGNAL (0x0C) /* MPI v2.0 only */
 #define MPI2_SAS_OP_REMOVE_DEVICE               (0x0D)
 #define MPI2_SAS_OP_LOOKUP_MAPPING              (0x0E)
 #define MPI2_SAS_OP_SET_IOC_PARAMETER           (0x0F)
diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_tool.h b/drivers/scsi/mpt3sas/mpi/mpi2_tool.h
index 34e9a7b..94e32c2 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2_tool.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_tool.h
@@ -6,7 +6,7 @@
  *         Title:  MPI diagnostic tool structures and definitions
  * Creation Date:  March 26, 2007
  *
- *   mpi2_tool.h Version:  02.00.10
+ *   mpi2_tool.h Version:  02.00.11
  *
  * Version History
  * ---------------
@@ -32,6 +32,7 @@
  *                     message.
  * 07-26-12  02.00.10  Modified MPI2_TOOLBOX_DIAGNOSTIC_CLI_REQUEST so that
  *                     it uses MPI Chain SGE as well as MPI Simple SGE.
+ * 08-19-13  02.00.11  Added MPI2_TOOLBOX_TEXT_DISPLAY_TOOL and related info.
  * --------------------------------------------------------------------------
  */
 
@@ -51,6 +52,7 @@
 #define MPI2_TOOLBOX_ISTWI_READ_WRITE_TOOL          (0x03)
 #define MPI2_TOOLBOX_BEACON_TOOL                    (0x05)
 #define MPI2_TOOLBOX_DIAGNOSTIC_CLI_TOOL            (0x06)
+#define MPI2_TOOLBOX_TEXT_DISPLAY_TOOL              (0x07)
 
 /****************************************************************************
 * Toolbox reply
@@ -331,6 +333,45 @@ typedef struct _MPI2_TOOLBOX_DIAGNOSTIC_CLI_REPLY {
 	Mpi2ToolboxDiagnosticCliReply_t,
 	*pMpi2ToolboxDiagnosticCliReply_t;
 
+
+/****************************************************************************
+*  Toolbox Console Text Display Tool
+****************************************************************************/
+
+/* Toolbox Console Text Display Tool request message */
+typedef struct _MPI2_TOOLBOX_TEXT_DISPLAY_REQUEST {
+	U8			Tool;			/* 0x00 */
+	U8			Reserved1;		/* 0x01 */
+	U8			ChainOffset;		/* 0x02 */
+	U8			Function;		/* 0x03 */
+	U16			Reserved2;		/* 0x04 */
+	U8			Reserved3;		/* 0x06 */
+	U8			MsgFlags;		/* 0x07 */
+	U8			VP_ID;			/* 0x08 */
+	U8			VF_ID;			/* 0x09 */
+	U16			Reserved4;		/* 0x0A */
+	U8			Console;		/* 0x0C */
+	U8			Flags;			/* 0x0D */
+	U16			Reserved6;		/* 0x0E */
+	U8			TextToDisplay[4];	/* 0x10 */
+} MPI2_TOOLBOX_TEXT_DISPLAY_REQUEST,
+*PTR_MPI2_TOOLBOX_TEXT_DISPLAY_REQUEST,
+Mpi2ToolboxTextDisplayRequest_t,
+*pMpi2ToolboxTextDisplayRequest_t;
+
+/* defines for the Console field */
+#define MPI2_TOOLBOX_CONSOLE_TYPE_MASK          (0xF0)
+#define MPI2_TOOLBOX_CONSOLE_TYPE_DEFAULT       (0x00)
+#define MPI2_TOOLBOX_CONSOLE_TYPE_UART          (0x10)
+#define MPI2_TOOLBOX_CONSOLE_TYPE_ETHERNET      (0x20)
+
+#define MPI2_TOOLBOX_CONSOLE_NUMBER_MASK        (0x0F)
+
+/* defines for the Flags field */
+#define MPI2_TOOLBOX_CONSOLE_FLAG_TIMESTAMP     (0x01)
+
+
+
 /*****************************************************************************
 *
 *      Diagnostic Buffer Messages
-- 
1.7.1

