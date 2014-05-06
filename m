Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970AbaEFODl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 10:03:41 -0400
Received: from mail1.bemta12.messagelabs.com ([216.82.251.2]:37063 "EHLO
	mail1.bemta12.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756671AbaEFODh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 10:03:37 -0400
X-Env-Sender: Benjamin.Romer@unisys.com
X-Msg-Ref: server-15.tower-29.messagelabs.com!1399385002!24561199!22
X-Originating-IP: [192.61.61.104]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
From: Benjamin Romer <benjamin.romer@unisys.com>
To: <gregkh@linuxfoundation.org>, <sparmaintainer@unisys.com>,
        <linux-kernel@vger.kernel.org>, <jkc@redhat.com>,
        <devel@driverdev.osuosl.org>
CC: Benjamin Romer <benjamin.romer@unisys.com>
Subject: [PATCH] staging: unisys: Replace GUID with uuid_le
Date: Tue, 6 May 2014 09:58:23 -0400
Message-ID: <1399384703-27651-1-git-send-email-benjamin.romer@unisys.com>
X-Mailer: git-send-email 1.9.1
X-OriginalArrivalTime: 06 May 2014 14:03:05.0576 (UTC) FILETIME=[E6EFD680:01CF6933]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the GUID type with uuid_le. It removes the header file
guidutils.h, updates all uses of the GUID type to uuid_le, and replaces all
function calls that used the GUID type with their uuid_le equivalents.

Signed-off-by: Benjamin Romer <benjamin.romer@unisys.com>
---
 .../unisys/common-spar/include/channels/channel.h  |  27 +--
 .../common-spar/include/channels/channel_guid.h    |  28 +--
 .../include/channels/controlvmchannel.h            |  19 +-
 .../common-spar/include/channels/diagchannel.h     |  10 +-
 .../common-spar/include/channels/iochannel.h       |  10 +-
 .../common-spar/include/channels/vbuschannel.h     |  10 +-
 drivers/staging/unisys/include/commontypes.h       |  47 ++---
 drivers/staging/unisys/include/guidutils.h         | 203 ---------------------
 drivers/staging/unisys/include/uisqueue.h          |  13 +-
 drivers/staging/unisys/include/uisutils.h          |  21 ++-
 drivers/staging/unisys/uislib/uislib.c             |  53 ++----
 drivers/staging/unisys/uislib/uisutils.c           |  53 +++---
 drivers/staging/unisys/virtpci/virtpci.c           |  13 +-
 drivers/staging/unisys/virtpci/virtpci.h           |   3 +-
 drivers/staging/unisys/visorchannel/visorchannel.h |  14 +-
 .../unisys/visorchannel/visorchannel_funcs.c       |  39 ++--
 .../unisys/visorchannel/visorchannel_main.c        |   2 +-
 drivers/staging/unisys/visorchipset/parser.c       |   5 +-
 drivers/staging/unisys/visorchipset/parser.h       |   4 +-
 drivers/staging/unisys/visorchipset/testing.h      |   5 +-
 drivers/staging/unisys/visorchipset/visorchipset.h |  16 +-
 .../unisys/visorchipset/visorchipset_main.c        |  15 +-
 22 files changed, 182 insertions(+), 428 deletions(-)
 delete mode 100644 drivers/staging/unisys/include/guidutils.h

diff --git a/drivers/staging/unisys/common-spar/include/channels/channel.h b/drivers/staging/unisys/common-spar/include/channels/channel.h
index baa0e50..237a852 100644
--- a/drivers/staging/unisys/common-spar/include/channels/channel.h
+++ b/drivers/staging/unisys/common-spar/include/channels/channel.h
@@ -16,6 +16,8 @@
 #ifndef __CHANNEL_H__
 #define __CHANNEL_H__
 
+#include <linux/uuid.h>
+
 /*
 * Whenever this file is changed a corresponding change must be made in
 * the Console/ServicePart/visordiag_early/supervisor_channel.h file
@@ -46,19 +48,6 @@
 #define COVER(v, d)   ((d)*COVERQ(v, d))
 #endif
 
-#ifndef GUID0
-#define GUID0 {0, 0, 0, {0, 0, 0, 0, 0, 0, 0, 0} }
-#endif
-
-/*  The C language is inconsistent with respect to where it allows literal
- *  constants, especially literal constant structs.  Literal constant structs
- *  are allowed for initialization only, whereas other types of literal
- *  constants are allowed anywhere.  We get around this inconsistency by
- *  declaring a "static const" variable for each GUID.  This variable can be
- *  used in expressions where the literal constant would not be allowed.
- */
-static const GUID Guid0 = GUID0;
-
 #define ULTRA_CHANNEL_PROTOCOL_SIGNATURE  SIGNATURE_32('E', 'C', 'N', 'L')
 
 typedef enum {
@@ -226,13 +215,13 @@ typedef struct _CHANNEL_HEADER {
 	U32 HeaderSize;		/* sizeof(CHANNEL_HEADER) */
 	U64 Size;		/* Total size of this channel in bytes */
 	U64 Features;		/* Flags to modify behavior */
-	GUID Type;		/* Channel type: data, bus, control, etc. */
+	uuid_le Type;		/* Channel type: data, bus, control, etc. */
 	U64 PartitionHandle;	/* ID of guest partition */
 	U64 Handle;		/* Device number of this channel in client */
 	U64 oChannelSpace;	/* Offset in bytes to channel specific area */
 	U32 VersionId;		/* CHANNEL_HEADER Version ID */
 	U32 PartitionIndex;	/* Index of guest partition */
-	GUID ZoneGuid;		/* Guid of Channel's zone */
+	uuid_le ZoneGuid;		/* Guid of Channel's zone */
 	U32 oClientString;	/* offset from channel header to
 				 * nul-terminated ClientString (0 if
 				 * ClientString not present) */
@@ -320,17 +309,17 @@ typedef struct _SIGNAL_QUEUE_HEADER {
  */
 static inline int
 ULTRA_check_channel_client(void __iomem *pChannel,
-			   GUID expectedTypeGuid,
+			   uuid_le expectedTypeGuid,
 			   char *channelName,
 			   U64 expectedMinBytes,
 			   U32 expectedVersionId,
 			   U64 expectedSignature,
 			   char *fileName, int lineNumber, void *logCtx)
 {
-	if (MEMCMP(&expectedTypeGuid, &Guid0, sizeof(GUID)) != 0)
+	if (uuid_le_cmp(expectedTypeGuid, NULL_UUID_LE) != 0)
 		/* caller wants us to verify type GUID */
 		if (MEMCMP_IO(&(((CHANNEL_HEADER __iomem *) (pChannel))->Type),
-			   &expectedTypeGuid, sizeof(GUID)) != 0) {
+			   &expectedTypeGuid, sizeof(uuid_le)) != 0) {
 			CHANNEL_GUID_MISMATCH(expectedTypeGuid, channelName,
 					      "type", expectedTypeGuid,
 					      ((CHANNEL_HEADER __iomem *)
@@ -380,7 +369,7 @@ ULTRA_check_channel_client(void __iomem *pChannel,
  * is used to pass the EFI_DIAG_CAPTURE_PROTOCOL needed to log messages.
  */
 static inline int
-ULTRA_check_channel_server(GUID typeGuid,
+ULTRA_check_channel_server(uuid_le typeGuid,
 			   char *channelName,
 			   U64 expectedMinBytes,
 			   U64 actualBytes,
diff --git a/drivers/staging/unisys/common-spar/include/channels/channel_guid.h b/drivers/staging/unisys/common-spar/include/channels/channel_guid.h
index 1f1f48e..63c67ca 100644
--- a/drivers/staging/unisys/common-spar/include/channels/channel_guid.h
+++ b/drivers/staging/unisys/common-spar/include/channels/channel_guid.h
@@ -21,44 +21,44 @@
  * {414815ed-c58c-11da-95a9-00e08161165f}
  */
 #define ULTRA_VHBA_CHANNEL_PROTOCOL_GUID \
-	{ 0x414815ed, 0xc58c, 0x11da, \
-		{ 0x95, 0xa9, 0x0, 0xe0, 0x81, 0x61, 0x16, 0x5f } }
-static const GUID UltraVhbaChannelProtocolGuid =
+		UUID_LE(0x414815ed, 0xc58c, 0x11da, \
+				0x95, 0xa9, 0x0, 0xe0, 0x81, 0x61, 0x16, 0x5f)
+static const uuid_le UltraVhbaChannelProtocolGuid =
 	ULTRA_VHBA_CHANNEL_PROTOCOL_GUID;
 
 /* Used in IOChannel
  * {8cd5994d-c58e-11da-95a9-00e08161165f}
  */
 #define ULTRA_VNIC_CHANNEL_PROTOCOL_GUID \
-	{ 0x8cd5994d, 0xc58e, 0x11da, \
-		{ 0x95, 0xa9, 0x0, 0xe0, 0x81, 0x61, 0x16, 0x5f } }
-static const GUID UltraVnicChannelProtocolGuid =
+		UUID_LE(0x8cd5994d, 0xc58e, 0x11da, \
+				0x95, 0xa9, 0x0, 0xe0, 0x81, 0x61, 0x16, 0x5f)
+static const uuid_le UltraVnicChannelProtocolGuid =
 	ULTRA_VNIC_CHANNEL_PROTOCOL_GUID;
 
 /* Used in IOChannel
  * {72120008-4AAB-11DC-8530-444553544200}
  */
 #define ULTRA_SIOVM_GUID \
-	{ 0x72120008, 0x4AAB, 0x11DC,					\
-		{ 0x85, 0x30, 0x44, 0x45, 0x53, 0x54, 0x42, 0x00 } }
-static const GUID UltraSIOVMGuid = ULTRA_SIOVM_GUID;
+		UUID_LE(0x72120008, 0x4AAB, 0x11DC, \
+				0x85, 0x30, 0x44, 0x45, 0x53, 0x54, 0x42, 0x00)
+static const uuid_le UltraSIOVMGuid = ULTRA_SIOVM_GUID;
 
 
 /* Used in visornoop/visornoop_main.c
  * {5b52c5ac-e5f5-4d42-8dff-429eaecd221f}
  */
 #define ULTRA_CONTROLDIRECTOR_CHANNEL_PROTOCOL_GUID  \
-	{ 0x5b52c5ac, 0xe5f5, 0x4d42, \
-		{ 0x8d, 0xff, 0x42, 0x9e, 0xae, 0xcd, 0x22, 0x1f } }
+		UUID_LE(0x5b52c5ac, 0xe5f5, 0x4d42, \
+				0x8d, 0xff, 0x42, 0x9e, 0xae, 0xcd, 0x22, 0x1f)
 
-static const GUID UltraControlDirectorChannelProtocolGuid =
+static const uuid_le UltraControlDirectorChannelProtocolGuid =
 	ULTRA_CONTROLDIRECTOR_CHANNEL_PROTOCOL_GUID;
 
 /* Used in visorchipset/visorchipset_main.c
  * {B4E79625-AEDE-4EAA-9E11-D3EDDCD4504C}
  */
 #define ULTRA_DIAG_POOL_CHANNEL_PROTOCOL_GUID				\
-	{0xb4e79625, 0xaede, 0x4eaa,					\
-		{ 0x9e, 0x11, 0xd3, 0xed, 0xdc, 0xd4, 0x50, 0x4c } }
+		UUID_LE(0xb4e79625, 0xaede, 0x4eaa, \
+				0x9e, 0x11, 0xd3, 0xed, 0xdc, 0xd4, 0x50, 0x4c)
 
 
diff --git a/drivers/staging/unisys/common-spar/include/channels/controlvmchannel.h b/drivers/staging/unisys/common-spar/include/channels/controlvmchannel.h
index 17beec2..d8b12a7 100644
--- a/drivers/staging/unisys/common-spar/include/channels/controlvmchannel.h
+++ b/drivers/staging/unisys/common-spar/include/channels/controlvmchannel.h
@@ -16,6 +16,7 @@
 #ifndef __CONTROLVMCHANNEL_H__
 #define __CONTROLVMCHANNEL_H__
 
+#include <linux/uuid.h>
 #include "commontypes.h"
 #include "channel.h"
 #include "controlframework.h"
@@ -25,10 +26,10 @@ enum { INVALID_GUEST_FIRMWARE, SAMPLE_GUEST_FIRMWARE,
 
 /* {2B3C2D10-7EF5-4ad8-B966-3448B7386B3D} */
 #define ULTRA_CONTROLVM_CHANNEL_PROTOCOL_GUID	\
-	{0x2b3c2d10, 0x7ef5, 0x4ad8, \
-		{0xb9, 0x66, 0x34, 0x48, 0xb7, 0x38, 0x6b, 0x3d} }
+		UUID_LE(0x2b3c2d10, 0x7ef5, 0x4ad8, \
+				0xb9, 0x66, 0x34, 0x48, 0xb7, 0x38, 0x6b, 0x3d)
 
-static const GUID UltraControlvmChannelProtocolGuid =
+static const uuid_le UltraControlvmChannelProtocolGuid =
 	ULTRA_CONTROLVM_CHANNEL_PROTOCOL_GUID;
 
 #define ULTRA_CONTROLVM_CHANNEL_PROTOCOL_SIGNATURE \
@@ -293,8 +294,8 @@ typedef struct _CONTROLVM_PACKET_DEVICE_CREATE  {
 			*   can be dereferenced by the receiver
 			*   of this ControlVm command */
 	U64 channelBytes; /**< specifies size of the channel in bytes */
-	GUID dataTypeGuid;/**< specifies format of data in channel */
-	GUID devInstGuid; /**< instance guid for the device */
+	uuid_le dataTypeGuid;/**< specifies format of data in channel */
+	uuid_le devInstGuid; /**< instance guid for the device */
 	struct InterruptInfo intr; /**< specifies interrupt information */
 } CONTROLVM_PACKET_DEVICE_CREATE;	/* for CONTROLVM_DEVICE_CREATE */
 
@@ -333,9 +334,9 @@ typedef struct _CONTROLVM_MESSAGE_PACKET  {
 					      *   dereferenced by the receiver
 					      *   of this ControlVm command */
 			U64 channelBytes;    /*< size of the channel in bytes */
-			GUID busDataTypeGuid;/*< indicates format of data in bus
-					      * channel */
-			GUID busInstGuid;    /*< instance guid for the bus */
+			uuid_le busDataTypeGuid;/*< indicates format of data in
+						    bus channel */
+			uuid_le busInstGuid;    /*< instance guid for the bus */
 		} createBus;	/* for CONTROLVM_BUS_CREATE */
 		struct  {
 			U32 busNo;	      /*< bus # (0..n-1) from the msg
@@ -611,7 +612,7 @@ typedef struct _ULTRA_CONTROLVM_PARAMETERS_HEADER  {
 	U32 ClientLength;
 	U32 NameOffset;
 	U32 NameLength;
-	GUID Id;
+	uuid_le Id;
 	U32 Revision;
 	U32 Reserved;		/* Natural alignment */
 } ULTRA_CONTROLVM_PARAMETERS_HEADER;
diff --git a/drivers/staging/unisys/common-spar/include/channels/diagchannel.h b/drivers/staging/unisys/common-spar/include/channels/diagchannel.h
index 83f1cc7..1bea2f7 100644
--- a/drivers/staging/unisys/common-spar/include/channels/diagchannel.h
+++ b/drivers/staging/unisys/common-spar/include/channels/diagchannel.h
@@ -38,16 +38,16 @@
 
 /* {EEA7A573-DB82-447c-8716-EFBEAAAE4858} */
 #define ULTRA_DIAG_CHANNEL_PROTOCOL_GUID \
-	{0xeea7a573, 0xdb82, 0x447c, \
-		{0x87, 0x16, 0xef, 0xbe, 0xaa, 0xae, 0x48, 0x58} }
+		UUID_LE(0xeea7a573, 0xdb82, 0x447c, \
+				0x87, 0x16, 0xef, 0xbe, 0xaa, 0xae, 0x48, 0x58)
 
-static const GUID UltraDiagChannelProtocolGuid =
+static const uuid_le UltraDiagChannelProtocolGuid =
 	ULTRA_DIAG_CHANNEL_PROTOCOL_GUID;
 
 /* {E850F968-3263-4484-8CA5-2A35D087A5A8} */
 #define ULTRA_DIAG_ROOT_CHANNEL_PROTOCOL_GUID \
-	{0xe850f968, 0x3263, 0x4484, \
-		{0x8c, 0xa5, 0x2a, 0x35, 0xd0, 0x87, 0xa5, 0xa8} }
+		UUID_LE(0xe850f968, 0x3263, 0x4484, \
+				0x8c, 0xa5, 0x2a, 0x35, 0xd0, 0x87, 0xa5, 0xa8)
 
 #define ULTRA_DIAG_CHANNEL_PROTOCOL_SIGNATURE  ULTRA_CHANNEL_PROTOCOL_SIGNATURE
 
diff --git a/drivers/staging/unisys/common-spar/include/channels/iochannel.h b/drivers/staging/unisys/common-spar/include/channels/iochannel.h
index 8cbf04d..6dcfa6e 100644
--- a/drivers/staging/unisys/common-spar/include/channels/iochannel.h
+++ b/drivers/staging/unisys/common-spar/include/channels/iochannel.h
@@ -29,6 +29,8 @@
 *        CHANNEL_ATTACHED -> CHANNEL_OPENED (performed only by GuestPart)
 */
 
+#include <linux/uuid.h>
+
 #include "commontypes.h"
 #include "vmcallinterface.h"
 
@@ -696,7 +698,7 @@ typedef struct _ULTRA_IO_CHANNEL_PROTOCOL {
 			U8 macaddr[MAX_MACADDR_LEN];	/* 6 bytes */
 			U32 num_rcv_bufs;	/* 4 */
 			U32 mtu;	/* 4 */
-			GUID zoneGuid;	/* 16 */
+			uuid_le zoneGuid;	/* 16 */
 		} vnic;		/* total     30 */
 	};
 
@@ -807,7 +809,7 @@ static inline int ULTRA_VHBA_init_channel(ULTRA_IO_CHANNEL_PROTOCOL *x,
 	x->ChannelHeader.HeaderSize = sizeof(x->ChannelHeader);
 	x->ChannelHeader.Size = COVER(bytes, 4096);
 	x->ChannelHeader.Type = UltraVhbaChannelProtocolGuid;
-	x->ChannelHeader.ZoneGuid = Guid0;
+	x->ChannelHeader.ZoneGuid = NULL_UUID_LE;
 	x->vhba.wwnn = *wwnn;
 	x->vhba.max = *max;
 	INIT_CLIENTSTRING(x, ULTRA_IO_CHANNEL_PROTOCOL, clientStr,
@@ -832,7 +834,7 @@ static inline void ULTRA_VHBA_set_max(ULTRA_IO_CHANNEL_PROTOCOL *x,
 static inline int ULTRA_VNIC_init_channel(ULTRA_IO_CHANNEL_PROTOCOL *x,
 						 unsigned char *macaddr,
 						 U32 num_rcv_bufs, U32 mtu,
-						 GUID zoneGuid,
+						 uuid_le zoneGuid,
 						 unsigned char *clientStr,
 						 U32 clientStrLen,
 						 U64 bytes)  {
@@ -843,7 +845,7 @@ static inline int ULTRA_VNIC_init_channel(ULTRA_IO_CHANNEL_PROTOCOL *x,
 	x->ChannelHeader.HeaderSize = sizeof(x->ChannelHeader);
 	x->ChannelHeader.Size = COVER(bytes, 4096);
 	x->ChannelHeader.Type = UltraVnicChannelProtocolGuid;
-	x->ChannelHeader.ZoneGuid = Guid0;
+	x->ChannelHeader.ZoneGuid = NULL_UUID_LE;
 	MEMCPY(x->vnic.macaddr, macaddr, MAX_MACADDR_LEN);
 	x->vnic.num_rcv_bufs = num_rcv_bufs;
 	x->vnic.mtu = mtu;
diff --git a/drivers/staging/unisys/common-spar/include/channels/vbuschannel.h b/drivers/staging/unisys/common-spar/include/channels/vbuschannel.h
index 7643042..0dd3e2d 100644
--- a/drivers/staging/unisys/common-spar/include/channels/vbuschannel.h
+++ b/drivers/staging/unisys/common-spar/include/channels/vbuschannel.h
@@ -23,15 +23,16 @@
  *  We currently use this for the client to provide various information about
  *  the client devices and client drivers for the server end to see.
  */
+#include <linux/uuid.h>
 #include "commontypes.h"
 #include "vbusdeviceinfo.h"
 #include "channel.h"
 
 /* {193b331b-c58f-11da-95a9-00e08161165f} */
 #define ULTRA_VBUS_CHANNEL_PROTOCOL_GUID \
-	{0x193b331b, 0xc58f, 0x11da, \
-		{0x95, 0xa9, 0x0, 0xe0, 0x81, 0x61, 0x16, 0x5f} }
-static const GUID UltraVbusChannelProtocolGuid =
+		UUID_LE(0x193b331b, 0xc58f, 0x11da, \
+				0x95, 0xa9, 0x0, 0xe0, 0x81, 0x61, 0x16, 0x5f)
+static const uuid_le UltraVbusChannelProtocolGuid =
 	ULTRA_VBUS_CHANNEL_PROTOCOL_GUID;
 
 #define ULTRA_VBUS_CHANNEL_PROTOCOL_SIGNATURE ULTRA_CHANNEL_PROTOCOL_SIGNATURE
@@ -112,8 +113,7 @@ ULTRA_VBUS_init_channel(ULTRA_VBUS_CHANNEL_PROTOCOL __iomem *x,
 	writeq(bytesAllocated, &x->ChannelHeader.Size);
 	memcpy_toio(&x->ChannelHeader.Type, &UltraVbusChannelProtocolGuid,
 		    sizeof(x->ChannelHeader.Type));
-	memcpy_toio(&x->ChannelHeader.ZoneGuid, &Guid0,
-		    sizeof(x->ChannelHeader.ZoneGuid));
+	memcpy_toio(&x->ChannelHeader.ZoneGuid, &NULL_UUID_LE, sizeof(uuid_le));
 	writel(sizeof(ULTRA_VBUS_HEADERINFO), &x->HdrInfo.structBytes);
 	writel(sizeof(ULTRA_VBUS_HEADERINFO), &x->HdrInfo.chpInfoByteOffset);
 	writel(readl(&x->HdrInfo.chpInfoByteOffset) +
diff --git a/drivers/staging/unisys/include/commontypes.h b/drivers/staging/unisys/include/commontypes.h
index 3a8f302..9de6f9d 100644
--- a/drivers/staging/unisys/include/commontypes.h
+++ b/drivers/staging/unisys/include/commontypes.h
@@ -24,6 +24,7 @@
 #include <linux/types.h>
 #include <linux/version.h>
 #include <linux/io.h>
+#include <linux/uuid.h>
 #else
 #include <stdint.h>
 #include <syslog.h>
@@ -59,16 +60,6 @@
 
 #endif
 
-typedef struct {
-	U32 data1;
-	U16 data2;
-	U16 data3;
-	U8 data4[8];
-} __attribute__ ((__packed__)) GUID;
-
-#ifndef GUID0
-#define GUID0 {0, 0, 0, {0, 0, 0, 0, 0, 0, 0, 0} }
-#endif
 typedef U64 GUEST_PHYSICAL_ADDRESS;
 
 #define MEMSET(ptr, val, len) memset(ptr, val, len)
@@ -89,18 +80,16 @@ typedef U64 GUEST_PHYSICAL_ADDRESS;
 #define CHANNEL_GUID_MISMATCH(chType, chName, field, expected, actual, fil, \
 			      lin, logCtx)				\
 	do {								\
-		char s1[50], s2[50], s3[50];				\
-		pr_err("Channel mismatch on channel=%s(%s) field=%s expected=%s actual=%s @%s:%d\n", \
-		       chName, GUID_format2(&chType, s1), field,	\
-		       GUID_format2(&expected, s2), GUID_format2(&actual, s3), \
+		pr_err("Channel mismatch on channel=%s(%pUL) field=%s expected=%pUL actual=%pUL @%s:%d\n", \
+		       chName, &chType, field,	\
+		       &expected, &actual, \
 		       fil, lin);					\
 	} while (0)
 #define CHANNEL_U32_MISMATCH(chType, chName, field, expected, actual, fil, \
 			     lin, logCtx)				\
 	do {								\
-		char s1[50];						\
-		pr_err("Channel mismatch on channel=%s(%s) field=%s expected=0x%-8.8lx actual=0x%-8.8lx @%s:%d\n", \
-		       chName, GUID_format2(&chType, s1), field,	\
+		pr_err("Channel mismatch on channel=%s(%pUL) field=%s expected=0x%-8.8lx actual=0x%-8.8lx @%s:%d\n", \
+		       chName, &chType, field,	\
 		       (unsigned long)expected, (unsigned long)actual,	\
 		       fil, lin);					\
 	} while (0)
@@ -108,9 +97,8 @@ typedef U64 GUEST_PHYSICAL_ADDRESS;
 #define CHANNEL_U64_MISMATCH(chType, chName, field, expected, actual, fil, \
 			     lin, logCtx)				\
 	do {								\
-		char s1[50];						\
-		pr_err("Channel mismatch on channel=%s(%s) field=%s expected=0x%-8.8Lx actual=0x%-8.8Lx @%s:%d\n", \
-		       chName, GUID_format2(&chType, s1), field,	\
+		pr_err("Channel mismatch on channel=%s(%pUL) field=%s expected=0x%-8.8Lx actual=0x%-8.8Lx @%s:%d\n", \
+		       chName, &chType, field,	\
 		       (unsigned long long)expected,			\
 		       (unsigned long long)actual,			\
 		       fil, lin);					\
@@ -128,21 +116,19 @@ typedef U64 GUEST_PHYSICAL_ADDRESS;
 #define CHANNEL_GUID_MISMATCH(chType, chName, field, expected, actual, fil, \
 			      lin, logCtx)				\
 	do {								\
-		char s1[50], s2[50], s3[50];				\
 		syslog(LOG_USER | LOG_ERR,				\
-		       "Channel mismatch on channel=%s(%s) field=%s expected=%s actual=%s @%s:%d", \
-		       chName, GUID_format2(&chType, s1), field,	\
-		       GUID_format2(&expected, s2), GUID_format2(&actual, s3), \
+		       "Channel mismatch on channel=%s(%pUL) field=%s expected=%pUL actual=%pUL @%s:%d", \
+		       chName, &chType, field,	\
+		       &expected, &actual, \
 		       fil, lin);					\
 	} while (0)
 
 #define CHANNEL_U32_MISMATCH(chType, chName, field, expected, actual, fil, \
 			     lin, logCtx)				\
 	do {								\
-		char s1[50];						\
 		syslog(LOG_USER | LOG_ERR,				\
-		       "Channel mismatch on channel=%s(%s) field=%s expected=0x%-8.8lx actual=0x%-8.8lx @%s:%d", \
-		       chName, GUID_format2(&chType, s1), field,	\
+		       "Channel mismatch on channel=%s(%pUL) field=%s expected=0x%-8.8lx actual=0x%-8.8lx @%s:%d", \
+		       chName, chType, field,	\
 		       (unsigned long)expected, (unsigned long)actual,	\
 		       fil, lin);					\
 	} while (0)
@@ -150,10 +136,9 @@ typedef U64 GUEST_PHYSICAL_ADDRESS;
 #define CHANNEL_U64_MISMATCH(chType, chName, field, expected, actual, fil, \
 			     lin, logCtx)				\
 	do {								\
-		char s1[50];						\
 		syslog(LOG_USER | LOG_ERR,				\
-		       "Channel mismatch on channel=%s(%s) field=%s expected=0x%-8.8Lx actual=0x%-8.8Lx @%s:%d", \
-		       chName, GUID_format2(&chType, s1), field,	\
+		       "Channel mismatch on channel=%s(%pUL) field=%s expected=0x%-8.8Lx actual=0x%-8.8Lx @%s:%d", \
+		       chName, chType, field,	\
 		       (unsigned long long)expected,			\
 		       (unsigned long long)actual,			\
 		       fil, lin);					\
@@ -167,4 +152,4 @@ typedef U64 GUEST_PHYSICAL_ADDRESS;
 #define VolatileBarrier() MEMORYBARRIER
 
 #endif
-#include "guidutils.h"
+
diff --git a/drivers/staging/unisys/include/guidutils.h b/drivers/staging/unisys/include/guidutils.h
deleted file mode 100644
index adeb92d..0000000
--- a/drivers/staging/unisys/include/guidutils.h
+++ /dev/null
@@ -1,203 +0,0 @@
-/* Copyright (C) 2010 - 2013 UNISYS CORPORATION
- * All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or (at
- * your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
- * NON INFRINGEMENT.  See the GNU General Public License for more
- * details.
- */
-
-/* guidutils.h
- *
- * These are GUID manipulation inlines that can be used from either
- * kernel-mode or user-mode.
- *
- */
-#ifndef __GUIDUTILS_H__
-#define __GUIDUTILS_H__
-
-#ifdef __KERNEL__
-#include <linux/kernel.h>
-#include <linux/string.h>
-#include <linux/ctype.h>
-#define GUID_STRTOUL kstrtoul
-#else
-#include <stdio.h>
-#include <ctype.h>
-#include <string.h>
-#include <stdlib.h>
-
-#define GUID_STRTOUL strtoul
-#endif
-
-static inline char *
-GUID_format1(const GUID *guid, char *s)
-{
-	sprintf(s, "{%-8.8lx-%-4.4x-%-4.4x-%-2.2x%-2.2x%-2.2x%-2.2x%-2.2x%-2.2x%-2.2x%-2.2x}",
-		(ulong) guid->data1,
-		guid->data2,
-		guid->data3,
-		guid->data4[0],
-		guid->data4[1],
-		guid->data4[2],
-		guid->data4[3],
-		guid->data4[4], guid->data4[5], guid->data4[6], guid->data4[7]);
-	return s;
-}
-
-/** Format a GUID in Microsoft's 'what in the world were they thinking'
- *  format.
- */
-static inline char *
-GUID_format2(const GUID *guid, char *s)
-{
-	sprintf(s, "{%-8.8lx-%-4.4x-%-4.4x-%-2.2x%-2.2x-%-2.2x%-2.2x%-2.2x%-2.2x%-2.2x%-2.2x}",
-		(ulong) guid->data1,
-		guid->data2,
-		guid->data3,
-		guid->data4[0],
-		guid->data4[1],
-		guid->data4[2],
-		guid->data4[3],
-		guid->data4[4], guid->data4[5], guid->data4[6], guid->data4[7]);
-	return s;
-}
-
-/**
- * Like GUID_format2 but without the curly braces and the
- * hex digits in upper case
- */
-static inline char *
-GUID_format3(const GUID *guid, char *s)
-{
-	sprintf(s, "%-8.8lX-%-4.4X-%-4.4X-%-2.2X%-2.2X-%-2.2X%-2.2X%-2.2X%-2.2X%-2.2X%-2.2X",
-		(ulong) guid->data1,
-		guid->data2,
-		guid->data3,
-		guid->data4[0],
-		guid->data4[1],
-		guid->data4[2],
-		guid->data4[3],
-		guid->data4[4], guid->data4[5], guid->data4[6], guid->data4[7]);
-	return s;
-}
-
-/** Parse a guid string in any of these forms:
- *      {11111111-2222-3333-4455-66778899aabb}
- *      {11111111-2222-3333-445566778899aabb}
- *      11111111-2222-3333-4455-66778899aabb
- *      11111111-2222-3333-445566778899aabb
- */
-static inline GUID
-GUID_scan(U8 *p)
-{
-	GUID guid = GUID0;
-	U8 x[33];
-	int count = 0;
-	int c, i = 0;
-	U8 cdata1[9];
-	U8 cdata2[5];
-	U8 cdata3[5];
-	U8 cdata4[3];
-	int dashcount = 0;
-	int brace = 0;
-	unsigned long uldata;
-
-	if (!p)
-		return guid;
-	if (*p == '{') {
-		p++;
-		brace = 1;
-	}
-	while (count < 32) {
-		if (*p == '}')
-			return guid;
-		if (*p == '\0')
-			return guid;
-		c = toupper(*p);
-		p++;
-		if (c == '-') {
-			switch (dashcount) {
-			case 0:
-				if (i != 8)
-					return guid;
-				break;
-			case 1:
-				if (i != 4)
-					return guid;
-				break;
-			case 2:
-				if (i != 4)
-					return guid;
-				break;
-			case 3:
-				if (i != 4)
-					return guid;
-				break;
-			default:
-				return guid;
-			}
-			dashcount++;
-			i = 0;
-			continue;
-		}
-		if ((c >= '0' && c <= '9') || (c >= 'A' && c <= 'F'))
-			i++;
-		else
-			return guid;
-		x[count++] = c;
-	}
-	x[count] = '\0';
-	if (brace) {
-		if (*p == '}')
-			p++;
-		else
-			return guid;
-	}
-	if (dashcount == 3 || dashcount == 4)
-		;
-	else
-		return guid;
-	memset(cdata1, 0, sizeof(cdata1));
-	memset(cdata2, 0, sizeof(cdata2));
-	memset(cdata3, 0, sizeof(cdata3));
-	memset(cdata4, 0, sizeof(cdata4));
-	memcpy(cdata1, x + 0, 8);
-	memcpy(cdata2, x + 8, 4);
-	memcpy(cdata3, x + 12, 4);
-
-	if (GUID_STRTOUL((char *) cdata1, 16, &uldata) == 0)
-		guid.data1 = (U32)uldata;
-	if (GUID_STRTOUL((char *) cdata2, 16, &uldata) == 0)
-		guid.data2 = (U16)uldata;
-	if (GUID_STRTOUL((char *) cdata3, 16, &uldata) == 0)
-		guid.data3 = (U16)uldata;
-
-	for (i = 0; i < 8; i++) {
-		memcpy(cdata4, x + 16 + (i * 2), 2);
-		if (GUID_STRTOUL((char *) cdata4, 16, &uldata) == 0)
-			guid.data4[i] = (U8) uldata;
-	}
-
-	return guid;
-}
-
-static inline char *
-GUID_sanitize(char *inputGuidStr, char *outputGuidStr)
-{
-	GUID g;
-	GUID guid0 = GUID0;
-	*outputGuidStr = '\0';
-	g = GUID_scan((U8 *) inputGuidStr);
-	if (memcmp(&g, &guid0, sizeof(GUID)) == 0)
-		return outputGuidStr;	/* bad GUID format */
-	return GUID_format1(&g, outputGuidStr);
-}
-
-#endif
diff --git a/drivers/staging/unisys/include/uisqueue.h b/drivers/staging/unisys/include/uisqueue.h
index d7793a8..2a5bea3 100644
--- a/drivers/staging/unisys/include/uisqueue.h
+++ b/drivers/staging/unisys/include/uisqueue.h
@@ -28,6 +28,7 @@
 #include "uniklog.h"
 #include <linux/atomic.h>
 #include <linux/semaphore.h>
+#include <linux/uuid.h>
 
 #include "controlvmchannel.h"
 #include "controlvmcompletionstatus.h"
@@ -136,8 +137,8 @@ struct device_info {
 	void __iomem *chanptr;
 	U64 channelAddr;
 	U64 channelBytes;
-	GUID channelTypeGuid;
-	GUID devInstGuid;
+	uuid_le channelTypeGuid;
+	uuid_le devInstGuid;
 	struct InterruptInfo intr;
 	struct switch_info *swtch;
 	char devid[30];		/* "vbus<busno>:dev<devno>" */
@@ -163,7 +164,7 @@ struct bus_info {
 	U32 busNo, deviceCount;
 	struct device_info **device;
 	U64 guestHandle, recvBusInterruptHandle;
-	GUID busInstGuid;
+	uuid_le busInstGuid;
 	ULTRA_VBUS_CHANNEL_PROTOCOL __iomem *pBusChannel;
 	int busChannelBytes;
 	struct proc_dir_entry *proc_dir;	/* proc/uislib/vbus/<x> */
@@ -356,8 +357,8 @@ struct add_vbus_guestpart {
 					 * NOT YET USED */
 	U32 busNo;		/* bus number to be created/deleted */
 	U32 deviceCount;	/* max num of devices on bus */
-	GUID busTypeGuid;	/* indicates type of bus */
-	GUID busInstGuid;	/* instance guid for device */
+	uuid_le busTypeGuid;	/* indicates type of bus */
+	uuid_le busInstGuid;	/* instance guid for device */
 };
 
 struct del_vbus_guestpart {
@@ -371,7 +372,7 @@ struct add_virt_guestpart {
 	void __iomem *chanptr;		/* pointer to data channel */
 	U32 busNo;		/* bus number for the operation */
 	U32 deviceNo;		/* number of device on the bus */
-	GUID devInstGuid;	/* instance guid for device */
+	uuid_le devInstGuid;	/* instance guid for device */
 	struct InterruptInfo intr;	/* recv/send interrupt info */
 	/* recvInterruptHandle contains info needed in order to
 	 * register to receive interrupts on the data channel.
diff --git a/drivers/staging/unisys/include/uisutils.h b/drivers/staging/unisys/include/uisutils.h
index f4774c0..f4845f2 100644
--- a/drivers/staging/unisys/include/uisutils.h
+++ b/drivers/staging/unisys/include/uisutils.h
@@ -25,6 +25,7 @@
 #include <linux/io.h>
 #include <linux/sched.h>
 #include <linux/gfp.h>
+#include <linux/uuid.h>
 
 #include "vmcallinterface.h"
 #include "channel.h"
@@ -54,7 +55,7 @@ extern atomic_t UisUtils_Registered_Services;
 
 typedef unsigned int MACARRAY[MAX_MACADDR_LEN];
 typedef struct ReqHandlerInfo_struct {
-	GUID switchTypeGuid;
+	uuid_le switchTypeGuid;
 	int (*controlfunc)(struct io_msgs *);
 	unsigned long min_channel_bytes;
 	int (*Server_Channel_Ok)(unsigned long channelBytes);
@@ -64,7 +65,7 @@ typedef struct ReqHandlerInfo_struct {
 	struct list_head list_link;	/* links into ReqHandlerInfo_list */
 } ReqHandlerInfo_t;
 
-ReqHandlerInfo_t *ReqHandlerAdd(GUID switchTypeGuid,
+ReqHandlerInfo_t *ReqHandlerAdd(uuid_le switchTypeGuid,
 				const char *switch_type_name,
 				int (*controlfunc)(struct io_msgs *),
 				unsigned long min_channel_bytes,
@@ -73,8 +74,8 @@ ReqHandlerInfo_t *ReqHandlerAdd(GUID switchTypeGuid,
 				int (*Server_Channel_Init)
 				 (void *x, unsigned char *clientStr,
 				  U32 clientStrLen, U64 bytes));
-ReqHandlerInfo_t *ReqHandlerFind(GUID switchTypeGuid);
-int ReqHandlerDel(GUID switchTypeGuid);
+ReqHandlerInfo_t *ReqHandlerFind(uuid_le switchTypeGuid);
+int ReqHandlerDel(uuid_le switchTypeGuid);
 
 #define uislib_ioremap_cache(addr, size) \
 	dbg_ioremap_cache(addr, size, __FILE__, __LINE__)
@@ -112,7 +113,7 @@ int uisutil_add_proc_line_ex(int *total, char **buffer, int *buffer_remaining,
 
 int uisctrl_register_req_handler(int type, void *fptr,
 				 ULTRA_VBUS_DEVICEINFO *chipset_DriverInfo);
-int uisctrl_register_req_handler_ex(GUID switchTypeGuid,
+int uisctrl_register_req_handler_ex(uuid_le switchTypeGuid,
 				    const char *switch_type_name,
 				    int (*fptr)(struct io_msgs *),
 				    unsigned long min_channel_bytes,
@@ -123,7 +124,7 @@ int uisctrl_register_req_handler_ex(GUID switchTypeGuid,
 				     U32 clientStrLen, U64 bytes),
 				    ULTRA_VBUS_DEVICEINFO *chipset_DriverInfo);
 
-int uisctrl_unregister_req_handler_ex(GUID switchTypeGuid);
+int uisctrl_unregister_req_handler_ex(uuid_le switchTypeGuid);
 unsigned char *util_map_virt(struct phys_info *sg);
 void util_unmap_virt(struct phys_info *sg);
 unsigned char *util_map_virt_atomic(struct phys_info *sg);
@@ -133,20 +134,20 @@ int uislib_server_inject_add_vnic(U32 switchNo, U32 BusNo, U32 numIntPorts,
 				  pCHANNEL_HEADER **chan);
 void uislib_server_inject_del_vnic(U32 switchNo, U32 busNo, U32 numIntPorts,
 				   U32 numExtPorts);
-int uislib_client_inject_add_bus(U32 busNo, GUID instGuid,
+int uislib_client_inject_add_bus(U32 busNo, uuid_le instGuid,
 				 U64 channelAddr, ulong nChannelBytes);
 int  uislib_client_inject_del_bus(U32 busNo);
 
 int uislib_client_inject_add_vhba(U32 busNo, U32 devNo,
 				  U64 phys_chan_addr, U32 chan_bytes,
-				  int is_test_addr, GUID instGuid,
+				  int is_test_addr, uuid_le instGuid,
 				  struct InterruptInfo *intr);
 int  uislib_client_inject_pause_vhba(U32 busNo, U32 devNo);
 int  uislib_client_inject_resume_vhba(U32 busNo, U32 devNo);
 int uislib_client_inject_del_vhba(U32 busNo, U32 devNo);
 int uislib_client_inject_add_vnic(U32 busNo, U32 devNo,
 				  U64 phys_chan_addr, U32 chan_bytes,
-				  int is_test_addr, GUID instGuid,
+				  int is_test_addr, uuid_le instGuid,
 				  struct InterruptInfo *intr);
 int uislib_client_inject_pause_vnic(U32 busNo, U32 devNo);
 int uislib_client_inject_resume_vnic(U32 busNo, U32 devNo);
@@ -195,7 +196,7 @@ struct chaninfo {
  */
 #define WAIT_FOR_VALID_GUID(guid) \
 	do {						   \
-		while (MEMCMP_IO(&guid, &Guid0, sizeof(Guid0)) == 0) {	\
+		while (uuid_le_cmp(guid, NULL_UUID_LE) == 0) {	\
 			LOGERR("Waiting for non-0 GUID (why???)...\n"); \
 			UIS_THREAD_WAIT_SEC(5);				\
 		}							\
diff --git a/drivers/staging/unisys/uislib/uislib.c b/drivers/staging/unisys/uislib/uislib.c
index 0e1a58a..885857e 100644
--- a/drivers/staging/unisys/uislib/uislib.c
+++ b/drivers/staging/unisys/uislib/uislib.c
@@ -587,10 +587,8 @@ create_device(CONTROLVM_MESSAGE *msg, char *buf)
 			 */
 			if (!msg->hdr.Flags.server) {
 				struct guest_msgs cmd;
-				if (!memcmp
-				    (&dev->channelTypeGuid,
-				     &UltraVhbaChannelProtocolGuid,
-				     sizeof(GUID))) {
+				if (!uuid_le_cmp(dev->channelTypeGuid,
+				     UltraVhbaChannelProtocolGuid)) {
 					WAIT_FOR_VALID_GUID(((CHANNEL_HEADER
 							      __iomem *) (dev->
 								  chanptr))->
@@ -614,10 +612,8 @@ create_device(CONTROLVM_MESSAGE *msg, char *buf)
 					    dev->devInstGuid;
 					cmd.add_vhba.intr = dev->intr;
 				} else
-				    if (!memcmp
-					(&dev->channelTypeGuid,
-					 &UltraVnicChannelProtocolGuid,
-					 sizeof(GUID))) {
+				    if (!uuid_le_cmp(dev->channelTypeGuid,
+					 UltraVnicChannelProtocolGuid)) {
 					WAIT_FOR_VALID_GUID(((CHANNEL_HEADER
 							      __iomem *) (dev->
 								  chanptr))->
@@ -723,16 +719,13 @@ pause_device(CONTROLVM_MESSAGE *msg)
 			/* the msg is bound for virtpci; send
 			 * guest_msgs struct to callback
 			 */
-			if (!memcmp
-			    (&dev->channelTypeGuid,
-			     &UltraVhbaChannelProtocolGuid, sizeof(GUID))) {
+			if (!uuid_le_cmp(dev->channelTypeGuid,
+					UltraVhbaChannelProtocolGuid)) {
 				cmd.msgtype = GUEST_PAUSE_VHBA;
 				cmd.pause_vhba.chanptr = dev->chanptr;
 			} else
-			    if (!memcmp
-				(&dev->channelTypeGuid,
-				 &UltraVnicChannelProtocolGuid,
-				 sizeof(GUID))) {
+			    if (!uuid_le_cmp(dev->channelTypeGuid,
+					    UltraVnicChannelProtocolGuid)) {
 				cmd.msgtype = GUEST_PAUSE_VNIC;
 				cmd.pause_vnic.chanptr = dev->chanptr;
 			} else {
@@ -798,15 +791,13 @@ resume_device(CONTROLVM_MESSAGE *msg)
 			/* the msg is bound for virtpci; send
 			 * guest_msgs struct to callback
 			 */
-			if (!memcmp(&dev->channelTypeGuid,
-				    &UltraVhbaChannelProtocolGuid,
-				    sizeof(GUID))) {
+			if (!uuid_le_cmp(dev->channelTypeGuid,
+					UltraVhbaChannelProtocolGuid)) {
 				cmd.msgtype = GUEST_RESUME_VHBA;
 				cmd.resume_vhba.chanptr = dev->chanptr;
 			} else
-			    if (!memcmp(&dev->channelTypeGuid,
-					&UltraVnicChannelProtocolGuid,
-					sizeof(GUID))) {
+			    if (!uuid_le_cmp(dev->channelTypeGuid,
+					    UltraVnicChannelProtocolGuid)) {
 				cmd.msgtype = GUEST_RESUME_VNIC;
 				cmd.resume_vnic.chanptr = dev->chanptr;
 			} else {
@@ -873,16 +864,13 @@ destroy_device(CONTROLVM_MESSAGE *msg, char *buf)
 			/* the msg is bound for virtpci; send
 			 * guest_msgs struct to callback
 			 */
-			if (!memcmp
-			    (&dev->channelTypeGuid,
-			     &UltraVhbaChannelProtocolGuid, sizeof(GUID))) {
+			if (!uuid_le_cmp(dev->channelTypeGuid,
+					UltraVhbaChannelProtocolGuid)) {
 				cmd.msgtype = GUEST_DEL_VHBA;
 				cmd.del_vhba.chanptr = dev->chanptr;
 			} else
-			    if (!memcmp
-				(&dev->channelTypeGuid,
-				 &UltraVnicChannelProtocolGuid,
-				 sizeof(GUID))) {
+			    if (!uuid_le_cmp(dev->channelTypeGuid,
+					    UltraVnicChannelProtocolGuid)) {
 				cmd.msgtype = GUEST_DEL_VNIC;
 				cmd.del_vnic.chanptr = dev->chanptr;
 			} else {
@@ -1008,7 +996,7 @@ delete_device_glue(U32 busNo, U32 devNo)
 }
 
 int
-uislib_client_inject_add_bus(U32 busNo, GUID instGuid,
+uislib_client_inject_add_bus(U32 busNo, uuid_le instGuid,
 			     U64 channelAddr, ulong nChannelBytes)
 {
 	CONTROLVM_MESSAGE msg;
@@ -1109,7 +1097,7 @@ EXPORT_SYMBOL_GPL(uislib_client_inject_resume_vhba);
 int
 uislib_client_inject_add_vhba(U32 busNo, U32 devNo,
 			      U64 phys_chan_addr, U32 chan_bytes,
-			      int is_test_addr, GUID instGuid,
+			      int is_test_addr, uuid_le instGuid,
 			      struct InterruptInfo *intr)
 {
 	CONTROLVM_MESSAGE msg;
@@ -1168,7 +1156,7 @@ EXPORT_SYMBOL_GPL(uislib_client_inject_del_vhba);
 int
 uislib_client_inject_add_vnic(U32 busNo, U32 devNo,
 			      U64 phys_chan_addr, U32 chan_bytes,
-			      int is_test_addr, GUID instGuid,
+			      int is_test_addr, uuid_le instGuid,
 			      struct InterruptInfo *intr)
 {
 	CONTROLVM_MESSAGE msg;
@@ -1272,7 +1260,6 @@ uislib_client_add_vnic(U32 busNo)
 	BOOL busCreated = FALSE;
 	int devNo = 0;		/* Default to 0, since only one device
 				 * will be created for this bus... */
-	GUID dummyGuid = GUID0;
 	CONTROLVM_MESSAGE msg;
 
 	init_msg_header(&msg, CONTROLVM_BUS_CREATE, 0, 0);
@@ -1291,7 +1278,7 @@ uislib_client_add_vnic(U32 busNo)
 	msg.hdr.Flags.testMessage = 1;
 	msg.cmd.createDevice.busNo = busNo;
 	msg.cmd.createDevice.devNo = devNo;
-	msg.cmd.createDevice.devInstGuid = dummyGuid;
+	msg.cmd.createDevice.devInstGuid = NULL_UUID_LE;
 	memset(&msg.cmd.createDevice.intr, 0, sizeof(struct InterruptInfo));
 	msg.cmd.createDevice.channelAddr = PhysicalDataChan;
 	msg.cmd.createDevice.channelBytes = MIN_IO_CHANNEL_SIZE;
diff --git a/drivers/staging/unisys/uislib/uisutils.c b/drivers/staging/unisys/uislib/uisutils.c
index b49647c..0f1bb73 100644
--- a/drivers/staging/unisys/uislib/uisutils.c
+++ b/drivers/staging/unisys/uislib/uisutils.c
@@ -24,8 +24,9 @@
 #include "uisutils.h"
 #include "version.h"
 #include "vbushelper.h"
-#include "guidutils.h"
+#include <linux/uuid.h>
 #include <linux/skbuff.h>
+#include <linux/uuid.h>
 #ifdef CONFIG_HIGHMEM
 #include <linux/highmem.h>
 #endif
@@ -104,7 +105,7 @@ uisctrl_register_req_handler(int type, void *fptr,
 EXPORT_SYMBOL_GPL(uisctrl_register_req_handler);
 
 int
-uisctrl_register_req_handler_ex(GUID switchTypeGuid,
+uisctrl_register_req_handler_ex(uuid_le switchTypeGuid,
 				const char *switch_type_name,
 				int (*controlfunc)(struct io_msgs *),
 				unsigned long min_channel_bytes,
@@ -115,24 +116,22 @@ uisctrl_register_req_handler_ex(GUID switchTypeGuid,
 				  U32 clientStrLen, U64 bytes),
 				ULTRA_VBUS_DEVICEINFO *chipset_DriverInfo)
 {
-	char s[99];
 	ReqHandlerInfo_t *pReqHandlerInfo;
 	int rc = 0;		/* assume failure */
-	LOGINF("type=%s, controlfunc=0x%p.\n",
-	       GUID_format1(&switchTypeGuid, s), controlfunc);
+	LOGINF("type=%pUL, controlfunc=0x%p.\n",
+	       &switchTypeGuid, controlfunc);
 	if (!controlfunc) {
-		LOGERR("%s: controlfunc must be supplied\n",
-		       GUID_format1(&switchTypeGuid, s));
+		LOGERR("%pUL: controlfunc must be supplied\n", &switchTypeGuid);
 		goto Away;
 	}
 	if (!Server_Channel_Ok) {
-		LOGERR("%s: Server_Channel_Ok must be supplied\n",
-		       GUID_format1(&switchTypeGuid, s));
+		LOGERR("%pUL: Server_Channel_Ok must be supplied\n",
+				&switchTypeGuid);
 		goto Away;
 	}
 	if (!Server_Channel_Init) {
-		LOGERR("%s: Server_Channel_Init must be supplied\n",
-		       GUID_format1(&switchTypeGuid, s));
+		LOGERR("%pUL: Server_Channel_Init must be supplied\n",
+				&switchTypeGuid);
 		goto Away;
 	}
 	pReqHandlerInfo = ReqHandlerAdd(switchTypeGuid,
@@ -141,8 +140,7 @@ uisctrl_register_req_handler_ex(GUID switchTypeGuid,
 					min_channel_bytes,
 					Server_Channel_Ok, Server_Channel_Init);
 	if (!pReqHandlerInfo) {
-		LOGERR("failed to add %s to server list\n",
-		       GUID_format1(&switchTypeGuid, s));
+		LOGERR("failed to add %pUL to server list\n", &switchTypeGuid);
 		goto Away;
 	}
 
@@ -156,30 +154,27 @@ Away:
 					   VERSION, NULL,
 					   __DATE__, __TIME__);
 	} else
-		LOGERR("failed to register type %s.\n",
-		       GUID_format1(&switchTypeGuid, s));
+		LOGERR("failed to register type %pUL.\n", &switchTypeGuid);
 
 	return rc;
 }
 EXPORT_SYMBOL_GPL(uisctrl_register_req_handler_ex);
 
 int
-uisctrl_unregister_req_handler_ex(GUID switchTypeGuid)
+uisctrl_unregister_req_handler_ex(uuid_le switchTypeGuid)
 {
-	char s[99];
 	int rc = 0;		/* assume failure */
-	LOGINF("type=%s.\n", GUID_format1(&switchTypeGuid, s));
+	LOGINF("type=%pUL.\n", &switchTypeGuid);
 	if (ReqHandlerDel(switchTypeGuid) < 0) {
-		LOGERR("failed to remove %s from server list\n",
-		       GUID_format1(&switchTypeGuid, s));
+		LOGERR("failed to remove %pUL from server list\n",
+				&switchTypeGuid);
 		goto Away;
 	}
 	atomic_dec(&UisUtils_Registered_Services);
 	rc = 1;			/* success */
 Away:
 	if (!rc)
-		LOGERR("failed to unregister type %s.\n",
-		       GUID_format1(&switchTypeGuid, s));
+		LOGERR("failed to unregister type %pUL.\n", &switchTypeGuid);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(uisctrl_unregister_req_handler_ex);
@@ -281,7 +276,7 @@ static LIST_HEAD(ReqHandlerInfo_list);	/* list of ReqHandlerInfo_t */
 static DEFINE_SPINLOCK(ReqHandlerInfo_list_lock);
 
 ReqHandlerInfo_t *
-ReqHandlerAdd(GUID switchTypeGuid,
+ReqHandlerAdd(uuid_le switchTypeGuid,
 	      const char *switch_type_name,
 	      int (*controlfunc)(struct io_msgs *),
 	      unsigned long min_channel_bytes,
@@ -310,16 +305,14 @@ ReqHandlerAdd(GUID switchTypeGuid,
 }
 
 ReqHandlerInfo_t *
-ReqHandlerFind(GUID switchTypeGuid)
+ReqHandlerFind(uuid_le switchTypeGuid)
 {
 	struct list_head *lelt, *tmp;
 	ReqHandlerInfo_t *entry = NULL;
 	spin_lock(&ReqHandlerInfo_list_lock);
 	list_for_each_safe(lelt, tmp, &ReqHandlerInfo_list) {
 		entry = list_entry(lelt, ReqHandlerInfo_t, list_link);
-		if (memcmp
-		    (&entry->switchTypeGuid, &switchTypeGuid,
-		     sizeof(GUID)) == 0) {
+		if (uuid_le_cmp(entry->switchTypeGuid, switchTypeGuid) == 0) {
 			spin_unlock(&ReqHandlerInfo_list_lock);
 			return entry;
 		}
@@ -329,7 +322,7 @@ ReqHandlerFind(GUID switchTypeGuid)
 }
 
 int
-ReqHandlerDel(GUID switchTypeGuid)
+ReqHandlerDel(uuid_le switchTypeGuid)
 {
 	struct list_head *lelt, *tmp;
 	ReqHandlerInfo_t *entry = NULL;
@@ -337,9 +330,7 @@ ReqHandlerDel(GUID switchTypeGuid)
 	spin_lock(&ReqHandlerInfo_list_lock);
 	list_for_each_safe(lelt, tmp, &ReqHandlerInfo_list) {
 		entry = list_entry(lelt, ReqHandlerInfo_t, list_link);
-		if (memcmp
-		    (&entry->switchTypeGuid, &switchTypeGuid,
-		     sizeof(GUID)) == 0) {
+		if (uuid_le_cmp(entry->switchTypeGuid, switchTypeGuid) == 0) {
 			list_del(lelt);
 			kfree(entry);
 			rc++;
diff --git a/drivers/staging/unisys/virtpci/virtpci.c b/drivers/staging/unisys/virtpci/virtpci.c
index 21f8bd5..2d29c8c 100644
--- a/drivers/staging/unisys/virtpci/virtpci.c
+++ b/drivers/staging/unisys/virtpci/virtpci.c
@@ -364,7 +364,7 @@ static int add_vhba(struct add_virt_guestpart *addparams)
 		memcpy_fromio(&net.zoneGuid, \
 			      &((ULTRA_IO_CHANNEL_PROTOCOL __iomem *)	\
 				chanptr)->vnic.zoneGuid,		\
-			      sizeof(GUID));				\
+			      sizeof(uuid_le));				\
 }
 
 /* adds a vnic
@@ -390,14 +390,10 @@ add_vnic(struct add_virt_guestpart *addparams)
 
 	GET_BUS_DEV(addparams->busNo);
 
-	LOGINF("Adding vnic macaddr:%02x:%02x:%02x:%02x:%02x:%02x rcvbufs:%d mtu:%d chanptr:%p{%-8.8lx-%-4.4x-%-4.4x-%-2.2x%-2.2x%-2.2x%-2.2x%-2.2x%-2.2x%-2.2x%-2.2x}\n",
+	LOGINF("Adding vnic macaddr:%02x:%02x:%02x:%02x:%02x:%02x rcvbufs:%d mtu:%d chanptr:%p%pUL\n",
 	     net.mac_addr[0], net.mac_addr[1], net.mac_addr[2], net.mac_addr[3],
 	     net.mac_addr[4], net.mac_addr[5], net.num_rcv_bufs, net.mtu,
-	     addparams->chanptr, (ulong) net.zoneGuid.data1, net.zoneGuid.data2,
-	     net.zoneGuid.data3, net.zoneGuid.data4[0], net.zoneGuid.data4[1],
-	     net.zoneGuid.data4[2], net.zoneGuid.data4[3],
-	     net.zoneGuid.data4[4], net.zoneGuid.data4[5],
-	     net.zoneGuid.data4[6], net.zoneGuid.data4[7]);
+	     addparams->chanptr, &net.zoneGuid);
 	i = virtpci_device_add(vbus, VIRTNIC_TYPE, addparams, NULL, &net);
 	if (i) {
 		LOGINF("Added vnic macaddr:%02x:%02x:%02x:%02x:%02x:%02x\n",
@@ -1509,7 +1505,6 @@ static ssize_t virt_proc_write(struct file *file, const char __user *buffer,
 	struct add_virt_guestpart addparams;
 	struct del_vbus_guestpart busdelparams;
 	struct del_virt_guestpart delparams;
-	GUID dummyGuid = GUID0;
 #ifdef STORAGE_CHANNEL
 	U64 storagechannel;
 #endif
@@ -1560,7 +1555,7 @@ static ssize_t virt_proc_write(struct file *file, const char __user *buffer,
 						   __pa(chanptr),
 						   MIN_IO_CHANNEL_SIZE,
 						   1, /* test msg */
-						   dummyGuid, /* inst guid */
+						   NULL_UUID_LE, /* inst guid */
 						   NULL)) { /*interrupt info */
 			LOGERR("FAILED to inject add vnic\n");
 			return -EFAULT;
diff --git a/drivers/staging/unisys/virtpci/virtpci.h b/drivers/staging/unisys/virtpci/virtpci.h
index b695c4b..f7be17b 100644
--- a/drivers/staging/unisys/virtpci/virtpci.h
+++ b/drivers/staging/unisys/virtpci/virtpci.h
@@ -24,6 +24,7 @@
 
 #include "uisqueue.h"
 #include <linux/version.h>
+#include <linux/uuid.h>
 
 #define PCI_DEVICE_ID_VIRTHBA 0xAA00
 #define PCI_DEVICE_ID_VIRTNIC 0xAB00
@@ -41,7 +42,7 @@ struct net_adap_info {
 	u8 mac_addr[MAX_MACADDR_LEN];
 	int num_rcv_bufs;
 	unsigned mtu;
-	GUID zoneGuid;
+	uuid_le zoneGuid;
 };
 
 typedef enum {
diff --git a/drivers/staging/unisys/visorchannel/visorchannel.h b/drivers/staging/unisys/visorchannel/visorchannel.h
index a8c2ebd..a00dfb5 100644
--- a/drivers/staging/unisys/visorchannel/visorchannel.h
+++ b/drivers/staging/unisys/visorchannel/visorchannel.h
@@ -18,6 +18,8 @@
 #ifndef __VISORCHANNEL_H__
 #define __VISORCHANNEL_H__
 
+#include <linux/uuid.h>
+
 #include "commontypes.h"
 #include "memregion.h"
 #include "channel.h"
@@ -38,15 +40,15 @@ typedef struct VISORCHANNEL_Tag VISORCHANNEL;
  * In this case, the values can simply be read from the channel header.
  */
 VISORCHANNEL *visorchannel_create(HOSTADDRESS physaddr,
-				  ulong channelBytes, GUID guid);
+				  ulong channelBytes, uuid_le guid);
 VISORCHANNEL *visorchannel_create_overlapped(ulong channelBytes,
 					     VISORCHANNEL *parent, ulong off,
-					     GUID guid);
+					     uuid_le guid);
 VISORCHANNEL *visorchannel_create_with_lock(HOSTADDRESS physaddr,
-					    ulong channelBytes, GUID guid);
+					    ulong channelBytes, uuid_le guid);
 VISORCHANNEL *visorchannel_create_overlapped_with_lock(ulong channelBytes,
 						       VISORCHANNEL *parent,
-						       ulong off, GUID guid);
+						       ulong off, uuid_le guid);
 void visorchannel_destroy(VISORCHANNEL *channel);
 int visorchannel_read(VISORCHANNEL *channel, ulong offset,
 		      void *local, ulong nbytes);
@@ -64,9 +66,9 @@ ulong visorchannel_get_nbytes(VISORCHANNEL *channel);
 char *visorchannel_id(VISORCHANNEL *channel, char *s);
 char *visorchannel_zoneid(VISORCHANNEL *channel, char *s);
 U64 visorchannel_get_clientpartition(VISORCHANNEL *channel);
-GUID visorchannel_get_GUID(VISORCHANNEL *channel);
+uuid_le visorchannel_get_uuid(VISORCHANNEL *channel);
 MEMREGION *visorchannel_get_memregion(VISORCHANNEL *channel);
-char *visorchannel_GUID_id(GUID *guid, char *s);
+char *visorchannel_uuid_id(uuid_le *guid, char *s);
 void visorchannel_debug(VISORCHANNEL *channel, int nQueues,
 			struct seq_file *seq, U32 off);
 void visorchannel_dump_section(VISORCHANNEL *chan, char *s,
diff --git a/drivers/staging/unisys/visorchannel/visorchannel_funcs.c b/drivers/staging/unisys/visorchannel/visorchannel_funcs.c
index 4427d01..bc4fc67 100644
--- a/drivers/staging/unisys/visorchannel/visorchannel_funcs.c
+++ b/drivers/staging/unisys/visorchannel/visorchannel_funcs.c
@@ -24,14 +24,14 @@
 
 #include "globals.h"
 #include "visorchannel.h"
-#include "guidutils.h"
+#include <linux/uuid.h>
 
 #define MYDRVNAME "visorchannel"
 
 struct VISORCHANNEL_Tag {
 	MEMREGION *memregion;	/* from visor_memregion_create() */
 	CHANNEL_HEADER chan_hdr;
-	GUID guid;
+	uuid_le guid;
 	ulong size;
 	BOOL needs_lock;
 	spinlock_t insert_lock;
@@ -50,7 +50,7 @@ struct VISORCHANNEL_Tag {
  */
 static VISORCHANNEL *
 visorchannel_create_guts(HOSTADDRESS physaddr, ulong channelBytes,
-			 VISORCHANNEL *parent, ulong off, GUID guid,
+			 VISORCHANNEL *parent, ulong off, uuid_le guid,
 			 BOOL needs_lock)
 {
 	VISORCHANNEL *p = NULL;
@@ -90,7 +90,7 @@ visorchannel_create_guts(HOSTADDRESS physaddr, ulong channelBytes,
 	if (channelBytes == 0)
 		/* we had better be a CLIENT of this channel */
 		channelBytes = (ulong) p->chan_hdr.Size;
-	if (STRUCTSEQUAL(guid, Guid0))
+	if (uuid_le_cmp(guid, NULL_UUID_LE) == 0)
 		/* we had better be a CLIENT of this channel */
 		guid = p->chan_hdr.Type;
 	if (visor_memregion_resize(p->memregion, channelBytes) < 0) {
@@ -114,7 +114,7 @@ Away:
 }
 
 VISORCHANNEL *
-visorchannel_create(HOSTADDRESS physaddr, ulong channelBytes, GUID guid)
+visorchannel_create(HOSTADDRESS physaddr, ulong channelBytes, uuid_le guid)
 {
 	return visorchannel_create_guts(physaddr, channelBytes, NULL, 0, guid,
 					FALSE);
@@ -123,7 +123,7 @@ EXPORT_SYMBOL_GPL(visorchannel_create);
 
 VISORCHANNEL *
 visorchannel_create_with_lock(HOSTADDRESS physaddr, ulong channelBytes,
-			      GUID guid)
+			      uuid_le guid)
 {
 	return visorchannel_create_guts(physaddr, channelBytes, NULL, 0, guid,
 					TRUE);
@@ -132,7 +132,7 @@ EXPORT_SYMBOL_GPL(visorchannel_create_with_lock);
 
 VISORCHANNEL *
 visorchannel_create_overlapped(ulong channelBytes,
-			       VISORCHANNEL *parent, ulong off, GUID guid)
+			       VISORCHANNEL *parent, ulong off, uuid_le guid)
 {
 	return visorchannel_create_guts(0, channelBytes, parent, off, guid,
 					FALSE);
@@ -142,7 +142,7 @@ EXPORT_SYMBOL_GPL(visorchannel_create_overlapped);
 VISORCHANNEL *
 visorchannel_create_overlapped_with_lock(ulong channelBytes,
 					 VISORCHANNEL *parent, ulong off,
-					 GUID guid)
+					 uuid_le guid)
 {
 	return visorchannel_create_guts(0, channelBytes, parent, off, guid,
 					TRUE);
@@ -177,23 +177,24 @@ visorchannel_get_nbytes(VISORCHANNEL *channel)
 EXPORT_SYMBOL_GPL(visorchannel_get_nbytes);
 
 char *
-visorchannel_GUID_id(GUID *guid, char *s)
+visorchannel_uuid_id(uuid_le *guid, char *s)
 {
-	return GUID_format1(guid, s);
+	sprintf(s, "%pUL", guid);
+	return s;
 }
-EXPORT_SYMBOL_GPL(visorchannel_GUID_id);
+EXPORT_SYMBOL_GPL(visorchannel_uuid_id);
 
 char *
 visorchannel_id(VISORCHANNEL *channel, char *s)
 {
-	return visorchannel_GUID_id(&channel->guid, s);
+	return visorchannel_uuid_id(&channel->guid, s);
 }
 EXPORT_SYMBOL_GPL(visorchannel_id);
 
 char *
 visorchannel_zoneid(VISORCHANNEL *channel, char *s)
 {
-	return visorchannel_GUID_id(&channel->chan_hdr.ZoneGuid, s);
+	return visorchannel_uuid_id(&channel->chan_hdr.ZoneGuid, s);
 }
 EXPORT_SYMBOL_GPL(visorchannel_zoneid);
 
@@ -204,12 +205,12 @@ visorchannel_get_clientpartition(VISORCHANNEL *channel)
 }
 EXPORT_SYMBOL_GPL(visorchannel_get_clientpartition);
 
-GUID
-visorchannel_get_GUID(VISORCHANNEL *channel)
+uuid_le
+visorchannel_get_uuid(VISORCHANNEL *channel)
 {
 	return channel->guid;
 }
-EXPORT_SYMBOL_GPL(visorchannel_get_GUID);
+EXPORT_SYMBOL_GPL(visorchannel_get_uuid);
 
 MEMREGION *
 visorchannel_get_memregion(VISORCHANNEL *channel)
@@ -558,7 +559,6 @@ visorchannel_debug(VISORCHANNEL *channel, int nQueues,
 	MEMREGION *memregion = NULL;
 	CHANNEL_HEADER hdr;
 	CHANNEL_HEADER *phdr = &hdr;
-	char s[99];
 	int i = 0;
 	int errcode = 0;
 
@@ -588,9 +588,8 @@ visorchannel_debug(VISORCHANNEL *channel, int nQueues,
 	nbytes = (ulong) (phdr->Size);
 	seq_printf(seq, "--- Begin channel @0x%-16.16Lx for 0x%lx bytes (region=0x%lx bytes) ---\n",
 		   addr + off, nbytes, nbytes_region);
-	seq_printf(seq, "Type            = %s\n", GUID_format2(&phdr->Type, s));
-	seq_printf(seq, "ZoneGuid        = %s\n",
-		   GUID_format2(&phdr->ZoneGuid, s));
+	seq_printf(seq, "Type            = %pUL\n", &phdr->Type);
+	seq_printf(seq, "ZoneGuid        = %pUL\n", &phdr->ZoneGuid);
 	seq_printf(seq, "Signature       = 0x%-16.16Lx\n",
 		   (long long) phdr->Signature);
 	seq_printf(seq, "LegacyState     = %lu\n", (ulong) phdr->LegacyState);
diff --git a/drivers/staging/unisys/visorchannel/visorchannel_main.c b/drivers/staging/unisys/visorchannel/visorchannel_main.c
index 1a09257..1eb6591 100644
--- a/drivers/staging/unisys/visorchannel/visorchannel_main.c
+++ b/drivers/staging/unisys/visorchannel/visorchannel_main.c
@@ -22,7 +22,7 @@
 #include "globals.h"
 #include "channel.h"
 #include "visorchannel.h"
-#include "guidutils.h"
+#include <linux/uuid.h>
 
 #define MYDRVNAME "visorchannel"
 
diff --git a/drivers/staging/unisys/visorchipset/parser.c b/drivers/staging/unisys/visorchipset/parser.c
index 948fbb8..4274dd2 100644
--- a/drivers/staging/unisys/visorchipset/parser.c
+++ b/drivers/staging/unisys/visorchipset/parser.c
@@ -20,6 +20,7 @@
 #include "controlvmchannel.h"
 #include <linux/ctype.h>
 #include <linux/mm.h>
+#include <linux/uuid.h>
 
 #define MYDRVNAME "visorchipset_parser"
 #define CURRENT_FILE_PC VISOR_CHIPSET_PC_parser_c
@@ -191,7 +192,7 @@ parser_byteStream_get(PARSER_CONTEXT *ctx, ulong *nbytes)
 	return (void *) ctx->data;
 }
 
-GUID
+uuid_le
 parser_id_get(PARSER_CONTEXT *ctx)
 {
 	ULTRA_CONTROLVM_PARAMETERS_HEADER *phdr = NULL;
@@ -199,7 +200,7 @@ parser_id_get(PARSER_CONTEXT *ctx)
 	if (ctx == NULL) {
 		ERRDRV("%s (%s:%d) - no context",
 		       __func__, __FILE__, __LINE__);
-		return Guid0;
+		return NULL_UUID_LE;
 	}
 	phdr = (ULTRA_CONTROLVM_PARAMETERS_HEADER *) (ctx->data);
 	return phdr->Id;
diff --git a/drivers/staging/unisys/visorchipset/parser.h b/drivers/staging/unisys/visorchipset/parser.h
index 3e4aedc..be85fd6 100644
--- a/drivers/staging/unisys/visorchipset/parser.h
+++ b/drivers/staging/unisys/visorchipset/parser.h
@@ -18,6 +18,8 @@
 #ifndef __PARSER_H__
 #define __PARSER_H__
 
+#include <linux/uuid.h>
+
 #include "uniklog.h"
 #include "timskmod.h"
 #include "channel.h"
@@ -37,7 +39,7 @@ PARSER_CONTEXT *parser_init_byteStream(U64 addr, U32 bytes, BOOL isLocal,
 void parser_param_start(PARSER_CONTEXT *ctx, PARSER_WHICH_STRING which_string);
 void *parser_param_get(PARSER_CONTEXT *ctx, char *nam, int namesize);
 void *parser_string_get(PARSER_CONTEXT *ctx);
-GUID parser_id_get(PARSER_CONTEXT *ctx);
+uuid_le parser_id_get(PARSER_CONTEXT *ctx);
 char *parser_simpleString_get(PARSER_CONTEXT *ctx);
 void *parser_byteStream_get(PARSER_CONTEXT *ctx, ulong *nbytes);
 void parser_done(PARSER_CONTEXT *ctx);
diff --git a/drivers/staging/unisys/visorchipset/testing.h b/drivers/staging/unisys/visorchipset/testing.h
index ad378b8..015d502 100644
--- a/drivers/staging/unisys/visorchipset/testing.h
+++ b/drivers/staging/unisys/visorchipset/testing.h
@@ -19,6 +19,7 @@
 #define __VISORCHIPSET_TESTING_H__
 
 #define VISORCHIPSET_TEST_PROC
+#include <linux/uuid.h>
 #include "globals.h"
 #include "controlvmchannel.h"
 
@@ -28,10 +29,10 @@ void test_manufacture_vnic_client_add(void *p);
 void test_manufacture_vnic_client_add_phys(HOSTADDRESS addr);
 void test_manufacture_preamble_messages(void);
 void test_manufacture_device_attach(ulong busNo, ulong devNo);
-void test_manufacture_device_add(ulong busNo, ulong devNo, GUID dataTypeGuid,
+void test_manufacture_device_add(ulong busNo, ulong devNo, uuid_le dataTypeGuid,
 				 void *pChannel);
 void test_manufacture_add_bus(ulong busNo, ulong maxDevices,
-			      GUID id, u8 *name, BOOL isServer);
+			      uuid_le id, u8 *name, BOOL isServer);
 void test_manufacture_device_destroy(ulong busNo, ulong devNo);
 void test_manufacture_bus_destroy(ulong busNo);
 void test_manufacture_detach_externalPort(ulong switchNo, ulong externalPortNo);
diff --git a/drivers/staging/unisys/visorchipset/visorchipset.h b/drivers/staging/unisys/visorchipset/visorchipset.h
index 06646e4..e01cc72 100644
--- a/drivers/staging/unisys/visorchipset/visorchipset.h
+++ b/drivers/staging/unisys/visorchipset/visorchipset.h
@@ -18,6 +18,8 @@
 #ifndef __VISORCHIPSET_H__
 #define __VISORCHIPSET_H__
 
+#include <linux/uuid.h>
+
 #include "timskmod.h"
 #include "channel.h"
 #include "controlvmchannel.h"
@@ -63,8 +65,8 @@ typedef struct {
 	HOSTADDRESS channelAddr;
 	struct InterruptInfo intr;
 	U64 nChannelBytes;
-	GUID channelTypeGuid;
-	GUID channelInstGuid;
+	uuid_le channelTypeGuid;
+	uuid_le channelInstGuid;
 
 } VISORCHIPSET_CHANNEL_INFO;
 
@@ -77,7 +79,7 @@ typedef struct {
 	struct list_head entry;
 	U32 busNo;
 	U32 devNo;
-	GUID devInstGuid;
+	uuid_le devInstGuid;
 	VISORCHIPSET_STATE state;
 	VISORCHIPSET_CHANNEL_INFO chanInfo;
 	U32 Reserved1;		/* CONTROLVM_ID */
@@ -125,7 +127,7 @@ typedef struct {
 	U32 busNo;
 	VISORCHIPSET_STATE state;
 	VISORCHIPSET_CHANNEL_INFO chanInfo;
-	GUID partitionGuid;
+	uuid_le partitionGuid;
 	U64 partitionHandle;
 	U8 *name;		/* UTF8 */
 	U8 *description;	/* UTF8 */
@@ -161,7 +163,7 @@ findbus(struct list_head *list, U32 busNo)
 typedef struct {
 	U32 switchNo;
 	VISORCHIPSET_STATE state;
-	GUID switchTypeGuid;
+	uuid_le switchTypeGuid;
 	U8 *authService1;
 	U8 *authService2;
 	U8 *authService3;
@@ -181,7 +183,7 @@ typedef struct {
 	U32 switchNo;
 	U32 externalPortNo;
 	VISORCHIPSET_STATE state;
-	GUID networkZoneGuid;
+	uuid_le networkZoneGuid;
 	int pdPort;
 	U8 *ip;
 	U8 *ipNetmask;
@@ -224,7 +226,7 @@ typedef struct {
 	void (*device_destroy)(ulong busNo, ulong devNo);
 	void (*device_pause)(ulong busNo, ulong devNo);
 	void (*device_resume)(ulong busNo, ulong devNo);
-	int (*get_channel_info)(GUID typeGuid, ulong *minSize,
+	int (*get_channel_info)(uuid_le typeGuid, ulong *minSize,
 				 ulong *maxSize);
 } VISORCHIPSET_BUSDEV_NOTIFIERS;
 
diff --git a/drivers/staging/unisys/visorchipset/visorchipset_main.c b/drivers/staging/unisys/visorchipset/visorchipset_main.c
index 1895dc4..7dd17d5 100644
--- a/drivers/staging/unisys/visorchipset/visorchipset_main.c
+++ b/drivers/staging/unisys/visorchipset/visorchipset_main.c
@@ -26,7 +26,6 @@
 #include "parser.h"
 #include "uniklog.h"
 #include "uisutils.h"
-#include "guidutils.h"
 #include "controlvmcompletionstatus.h"
 #include "guestlinuxdebug.h"
 #include "filexfer.h"
@@ -34,6 +33,7 @@
 #include <linux/nls.h>
 #include <linux/netdevice.h>
 #include <linux/platform_device.h>
+#include <linux/uuid.h>
 
 #define CURRENT_FILE_PC VISOR_CHIPSET_PC_visorchipset_main_c
 #define TEST_VNIC_PHYSITF "eth0"	/* physical network itf for
@@ -82,7 +82,7 @@ typedef struct {
 static CONTROLVM_MESSAGE_HEADER g_DiagMsgHdr;
 static CONTROLVM_MESSAGE_HEADER g_ChipSetMsgHdr;
 static CONTROLVM_MESSAGE_HEADER g_DelDumpMsgHdr;
-static const GUID UltraDiagPoolChannelProtocolGuid =
+static const uuid_le UltraDiagPoolChannelProtocolGuid =
 	ULTRA_DIAG_POOL_CHANNEL_PROTOCOL_GUID;
 /* 0xffffff is an invalid Bus/Device number */
 static ulong g_diagpoolBusNo = 0xffffff;
@@ -93,15 +93,12 @@ static CONTROLVM_MESSAGE_PACKET g_DeviceChangeStatePacket;
  * "visorhackbus")
  */
 #define FOR_VISORHACKBUS(channel_type_guid) \
-	((memcmp(&channel_type_guid, &UltraVnicChannelProtocolGuid, \
-		 sizeof(GUID)) == 0) ||				    \
-	 (memcmp(&channel_type_guid, &UltraVhbaChannelProtocolGuid, \
-		 sizeof(GUID)) == 0))
+	(((uuid_le_cmp(channel_type_guid, UltraVnicChannelProtocolGuid) == 0)\
+	|| (uuid_le_cmp(channel_type_guid, UltraVhbaChannelProtocolGuid) == 0)))
 #define FOR_VISORBUS(channel_type_guid) (!(FOR_VISORHACKBUS(channel_type_guid)))
 
 #define is_diagpool_channel(channel_type_guid) \
-	 (memcmp(&channel_type_guid, \
-		 &UltraDiagPoolChannelProtocolGuid, sizeof(GUID)) == 0)
+	 (uuid_le_cmp(channel_type_guid, UltraDiagPoolChannelProtocolGuid) == 0)
 
 typedef enum {
 	PARTPROP_invalid,
@@ -1189,7 +1186,7 @@ bus_configure(CONTROLVM_MESSAGE *inmsg, PARSER_CONTEXT *parser_ctx)
 	parser_param_start(parser_ctx, PARSERSTRING_NAME);
 	pBusInfo->name = parser_string_get(parser_ctx);
 
-	visorchannel_GUID_id(&pBusInfo->partitionGuid, s);
+	visorchannel_uuid_id(&pBusInfo->partitionGuid, s);
 	pBusInfo->procObject =
 	    visor_proc_CreateObject(PartitionType, s, (void *) (pBusInfo));
 	if (pBusInfo->procObject == NULL) {
-- 
1.9.1

