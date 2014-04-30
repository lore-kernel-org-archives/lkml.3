Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759425AbaD3Rox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 13:44:53 -0400
Received: from mail-pa0-f74.google.com ([209.85.220.74]:54220 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759285AbaD3Rol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 13:44:41 -0400
From: Doug Anderson <dianders@chromium.org>
To: lee.jones@linaro.org, swarren@nvidia.com, wsa@the-dreams.de
Cc: abrestic@chromium.org, dgreid@chromium.org, olof@lixom.net,
        sjg@chromium.org, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org, Bill Richardson <wfrichar@chromium.org>,
        Doug Anderson <dianders@chromium.org>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 5/7] mfd: cros_ec: Sync to the latest cros_ec_commands.h from EC sources
Date: Wed, 30 Apr 2014 10:44:08 -0700
Message-Id: <1398879850-9111-6-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
In-Reply-To: <1398879850-9111-1-git-send-email-dianders@chromium.org>
References: <1398879850-9111-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bill Richardson <wfrichar@chromium.org>

This just updates include/linux/mfd/cros_ec_commands.h to match the
latest EC version (which is the One True Source for such things).  See
<https://chromium.googlesource.com/chromiumos/platform/ec>

[dianders: took today's ToT version from the Chromium OS EC; deleted
references to cros_ec_dev and cros_ec_lpc since those aren't upstream
yet]

Signed-off-by: Bill Richardson <wfrichar@chromium.org>
Signed-off-by: Doug Anderson <dianders@chromium.org>
Acked-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Simon Glass <sjg@chromium.org>
Tested-by: Andrew Bresticker <abrestic@chromium.org>
Tested-by: Stephen Warren <swarren@nvidia.com>
---
Changes in v3: None
Changes in v2: None

 drivers/mfd/cros_ec.c                |    2 +-
 include/linux/mfd/cros_ec.h          |    4 +-
 include/linux/mfd/cros_ec_commands.h | 1128 +++++++++++++++++++++++++++++++---
 3 files changed, 1059 insertions(+), 75 deletions(-)

diff --git a/drivers/mfd/cros_ec.c b/drivers/mfd/cros_ec.c
index 783fe2e..c58ab96 100644
--- a/drivers/mfd/cros_ec.c
+++ b/drivers/mfd/cros_ec.c
@@ -30,7 +30,7 @@ int cros_ec_prepare_tx(struct cros_ec_device *ec_dev,
 	uint8_t *out;
 	int csum, i;
 
-	BUG_ON(msg->out_len > EC_HOST_PARAM_SIZE);
+	BUG_ON(msg->out_len > EC_PROTO2_MAX_PARAM_SIZE);
 	out = ec_dev->dout;
 	out[0] = EC_CMD_VERSION0 + msg->version;
 	out[1] = msg->cmd;
diff --git a/include/linux/mfd/cros_ec.h b/include/linux/mfd/cros_ec.h
index 032af7f..887ef4f 100644
--- a/include/linux/mfd/cros_ec.h
+++ b/include/linux/mfd/cros_ec.h
@@ -29,8 +29,8 @@ enum {
 	EC_MSG_RX_PROTO_BYTES	= 3,
 
 	/* Max length of messages */
-	EC_MSG_BYTES		= EC_HOST_PARAM_SIZE + EC_MSG_TX_PROTO_BYTES,
-
+	EC_MSG_BYTES		= EC_PROTO2_MAX_PARAM_SIZE +
+					EC_MSG_TX_PROTO_BYTES,
 };
 
 /**
diff --git a/include/linux/mfd/cros_ec_commands.h b/include/linux/mfd/cros_ec_commands.h
index 86fd069..7853a64 100644
--- a/include/linux/mfd/cros_ec_commands.h
+++ b/include/linux/mfd/cros_ec_commands.h
@@ -24,25 +24,12 @@
 #define __CROS_EC_COMMANDS_H
 
 /*
- * Protocol overview
+ * Current version of this protocol
  *
- * request:  CMD [ P0 P1 P2 ... Pn S ]
- * response: ERR [ P0 P1 P2 ... Pn S ]
- *
- * where the bytes are defined as follow :
- *      - CMD is the command code. (defined by EC_CMD_ constants)
- *      - ERR is the error code. (defined by EC_RES_ constants)
- *      - Px is the optional payload.
- *        it is not sent if the error code is not success.
- *        (defined by ec_params_ and ec_response_ structures)
- *      - S is the checksum which is the sum of all payload bytes.
- *
- * On LPC, CMD and ERR are sent/received at EC_LPC_ADDR_KERNEL|USER_CMD
- * and the payloads are sent/received at EC_LPC_ADDR_KERNEL|USER_PARAM.
- * On I2C, all bytes are sent serially in the same message.
+ * TODO(crosbug.com/p/11223): This is effectively useless; protocol is
+ * determined in other ways.  Remove this once the kernel code no longer
+ * depends on it.
  */
-
-/* Current version of this protocol */
 #define EC_PROTO_VERSION          0x00000002
 
 /* Command version mask */
@@ -57,13 +44,19 @@
 #define EC_LPC_ADDR_HOST_CMD   0x204
 
 /* I/O addresses for host command args and params */
-#define EC_LPC_ADDR_HOST_ARGS  0x800
-#define EC_LPC_ADDR_HOST_PARAM 0x804
-#define EC_HOST_PARAM_SIZE     0x0fc  /* Size of param area in bytes */
-
-/* I/O addresses for host command params, old interface */
-#define EC_LPC_ADDR_OLD_PARAM  0x880
-#define EC_OLD_PARAM_SIZE      0x080  /* Size of param area in bytes */
+/* Protocol version 2 */
+#define EC_LPC_ADDR_HOST_ARGS    0x800  /* And 0x801, 0x802, 0x803 */
+#define EC_LPC_ADDR_HOST_PARAM   0x804  /* For version 2 params; size is
+					 * EC_PROTO2_MAX_PARAM_SIZE */
+/* Protocol version 3 */
+#define EC_LPC_ADDR_HOST_PACKET  0x800  /* Offset of version 3 packet */
+#define EC_LPC_HOST_PACKET_SIZE  0x100  /* Max size of version 3 packet */
+
+/* The actual block is 0x800-0x8ff, but some BIOSes think it's 0x880-0x8ff
+ * and they tell the kernel that so we have to think of it as two parts. */
+#define EC_HOST_CMD_REGION0    0x800
+#define EC_HOST_CMD_REGION1    0x880
+#define EC_HOST_CMD_REGION_SIZE 0x80
 
 /* EC command register bit functions */
 #define EC_LPC_CMDR_DATA	(1 << 0)  /* Data ready for host to read */
@@ -79,18 +72,22 @@
 #define EC_MEMMAP_TEXT_MAX     8   /* Size of a string in the memory map */
 
 /* The offset address of each type of data in mapped memory. */
-#define EC_MEMMAP_TEMP_SENSOR      0x00 /* Temp sensors */
-#define EC_MEMMAP_FAN              0x10 /* Fan speeds */
-#define EC_MEMMAP_TEMP_SENSOR_B    0x18 /* Temp sensors (second set) */
-#define EC_MEMMAP_ID               0x20 /* 'E' 'C' */
+#define EC_MEMMAP_TEMP_SENSOR      0x00 /* Temp sensors 0x00 - 0x0f */
+#define EC_MEMMAP_FAN              0x10 /* Fan speeds 0x10 - 0x17 */
+#define EC_MEMMAP_TEMP_SENSOR_B    0x18 /* More temp sensors 0x18 - 0x1f */
+#define EC_MEMMAP_ID               0x20 /* 0x20 == 'E', 0x21 == 'C' */
 #define EC_MEMMAP_ID_VERSION       0x22 /* Version of data in 0x20 - 0x2f */
 #define EC_MEMMAP_THERMAL_VERSION  0x23 /* Version of data in 0x00 - 0x1f */
 #define EC_MEMMAP_BATTERY_VERSION  0x24 /* Version of data in 0x40 - 0x7f */
 #define EC_MEMMAP_SWITCHES_VERSION 0x25 /* Version of data in 0x30 - 0x33 */
 #define EC_MEMMAP_EVENTS_VERSION   0x26 /* Version of data in 0x34 - 0x3f */
-#define EC_MEMMAP_HOST_CMD_FLAGS   0x27 /* Host command interface flags */
-#define EC_MEMMAP_SWITCHES         0x30
-#define EC_MEMMAP_HOST_EVENTS      0x34
+#define EC_MEMMAP_HOST_CMD_FLAGS   0x27 /* Host cmd interface flags (8 bits) */
+/* Unused 0x28 - 0x2f */
+#define EC_MEMMAP_SWITCHES         0x30	/* 8 bits */
+/* Unused 0x31 - 0x33 */
+#define EC_MEMMAP_HOST_EVENTS      0x34 /* 32 bits */
+/* Reserve 0x38 - 0x3f for additional host event-related stuff */
+/* Battery values are all 32 bits */
 #define EC_MEMMAP_BATT_VOLT        0x40 /* Battery Present Voltage */
 #define EC_MEMMAP_BATT_RATE        0x44 /* Battery Present Rate */
 #define EC_MEMMAP_BATT_CAP         0x48 /* Battery Remaining Capacity */
@@ -99,10 +96,24 @@
 #define EC_MEMMAP_BATT_DVLT        0x54 /* Battery Design Voltage */
 #define EC_MEMMAP_BATT_LFCC        0x58 /* Battery Last Full Charge Capacity */
 #define EC_MEMMAP_BATT_CCNT        0x5c /* Battery Cycle Count */
+/* Strings are all 8 bytes (EC_MEMMAP_TEXT_MAX) */
 #define EC_MEMMAP_BATT_MFGR        0x60 /* Battery Manufacturer String */
 #define EC_MEMMAP_BATT_MODEL       0x68 /* Battery Model Number String */
 #define EC_MEMMAP_BATT_SERIAL      0x70 /* Battery Serial Number String */
 #define EC_MEMMAP_BATT_TYPE        0x78 /* Battery Type String */
+#define EC_MEMMAP_ALS              0x80 /* ALS readings in lux (2 X 16 bits) */
+/* Unused 0x84 - 0x8f */
+#define EC_MEMMAP_ACC_STATUS       0x90 /* Accelerometer status (8 bits )*/
+/* Unused 0x91 */
+#define EC_MEMMAP_ACC_DATA         0x92 /* Accelerometer data 0x92 - 0x9f */
+#define EC_MEMMAP_GYRO_DATA        0xa0 /* Gyroscope data 0xa0 - 0xa5 */
+/* Unused 0xa6 - 0xfe (remember, 0xff is NOT part of the memmap region) */
+
+
+/* Define the format of the accelerometer mapped memory status byte. */
+#define EC_MEMMAP_ACC_STATUS_SAMPLE_ID_MASK  0x0f
+#define EC_MEMMAP_ACC_STATUS_BUSY_BIT        (1 << 4)
+#define EC_MEMMAP_ACC_STATUS_PRESENCE_BIT    (1 << 7)
 
 /* Number of temp sensors at EC_MEMMAP_TEMP_SENSOR */
 #define EC_TEMP_SENSOR_ENTRIES     16
@@ -112,6 +123,8 @@
  * Valid only if EC_MEMMAP_THERMAL_VERSION returns >= 2.
  */
 #define EC_TEMP_SENSOR_B_ENTRIES      8
+
+/* Special values for mapped temperature sensors */
 #define EC_TEMP_SENSOR_NOT_PRESENT    0xff
 #define EC_TEMP_SENSOR_ERROR          0xfe
 #define EC_TEMP_SENSOR_NOT_POWERED    0xfd
@@ -122,6 +135,18 @@
  */
 #define EC_TEMP_SENSOR_OFFSET      200
 
+/*
+ * Number of ALS readings at EC_MEMMAP_ALS
+ */
+#define EC_ALS_ENTRIES             2
+
+/*
+ * The default value a temperature sensor will return when it is present but
+ * has not been read this boot.  This is a reasonable number to avoid
+ * triggering alarms on the host.
+ */
+#define EC_TEMP_SENSOR_DEFAULT     (296 - EC_TEMP_SENSOR_OFFSET)
+
 #define EC_FAN_SPEED_ENTRIES       4       /* Number of fans at EC_MEMMAP_FAN */
 #define EC_FAN_SPEED_NOT_PRESENT   0xffff  /* Entry not present */
 #define EC_FAN_SPEED_STALLED       0xfffe  /* Fan stalled */
@@ -137,8 +162,8 @@
 #define EC_SWITCH_LID_OPEN               0x01
 #define EC_SWITCH_POWER_BUTTON_PRESSED   0x02
 #define EC_SWITCH_WRITE_PROTECT_DISABLED 0x04
-/* Recovery requested via keyboard */
-#define EC_SWITCH_KEYBOARD_RECOVERY      0x08
+/* Was recovery requested via keyboard; now unused. */
+#define EC_SWITCH_IGNORE1		 0x08
 /* Recovery requested via dedicated signal (from servo board) */
 #define EC_SWITCH_DEDICATED_RECOVERY     0x10
 /* Was fake developer mode switch; now unused.  Remove in next refactor. */
@@ -147,10 +172,15 @@
 /* Host command interface flags */
 /* Host command interface supports LPC args (LPC interface only) */
 #define EC_HOST_CMD_FLAG_LPC_ARGS_SUPPORTED  0x01
+/* Host command interface supports version 3 protocol */
+#define EC_HOST_CMD_FLAG_VERSION_3   0x02
 
 /* Wireless switch flags */
-#define EC_WIRELESS_SWITCH_WLAN      0x01
-#define EC_WIRELESS_SWITCH_BLUETOOTH 0x02
+#define EC_WIRELESS_SWITCH_ALL       ~0x00  /* All flags */
+#define EC_WIRELESS_SWITCH_WLAN       0x01  /* WLAN radio */
+#define EC_WIRELESS_SWITCH_BLUETOOTH  0x02  /* Bluetooth radio */
+#define EC_WIRELESS_SWITCH_WWAN       0x04  /* WWAN power */
+#define EC_WIRELESS_SWITCH_WLAN_POWER 0x08  /* WLAN power */
 
 /*
  * This header file is used in coreboot both in C and ACPI code.  The ACPI code
@@ -159,6 +189,14 @@
  */
 #ifndef __ACPI__
 
+/*
+ * Define __packed if someone hasn't beat us to it.  Linux kernel style
+ * checking prefers __packed over __attribute__((packed)).
+ */
+#ifndef __packed
+#define __packed __attribute__((packed))
+#endif
+
 /* LPC command status byte masks */
 /* EC has written a byte in the data register and host hasn't read it yet */
 #define EC_LPC_STATUS_TO_HOST     0x01
@@ -198,6 +236,9 @@ enum ec_status {
 	EC_RES_UNAVAILABLE = 9,		/* No response available */
 	EC_RES_TIMEOUT = 10,		/* We got a timeout */
 	EC_RES_OVERFLOW = 11,		/* Table / data overflow */
+	EC_RES_INVALID_HEADER = 12,     /* Header contains invalid data */
+	EC_RES_REQUEST_TRUNCATED = 13,  /* Didn't get the entire request */
+	EC_RES_RESPONSE_TOO_BIG = 14    /* Response was too big to handle */
 };
 
 /*
@@ -235,6 +276,16 @@ enum host_event_code {
 	/* Shutdown due to battery level too low */
 	EC_HOST_EVENT_BATTERY_SHUTDOWN = 17,
 
+	/* Suggest that the AP throttle itself */
+	EC_HOST_EVENT_THROTTLE_START = 18,
+	/* Suggest that the AP resume normal speed */
+	EC_HOST_EVENT_THROTTLE_STOP = 19,
+
+	/* Hang detect logic detected a hang and host event timeout expired */
+	EC_HOST_EVENT_HANG_DETECT = 20,
+	/* Hang detect logic detected a hang and warm rebooted the AP */
+	EC_HOST_EVENT_HANG_REBOOT = 21,
+
 	/*
 	 * The high bit of the event mask is not used as a host event code.  If
 	 * it reads back as set, then the entire event mask should be
@@ -279,6 +330,188 @@ struct ec_lpc_host_args {
  */
 #define EC_HOST_ARGS_FLAG_TO_HOST   0x02
 
+/*****************************************************************************/
+/*
+ * Byte codes returned by EC over SPI interface.
+ *
+ * These can be used by the AP to debug the EC interface, and to determine
+ * when the EC is not in a state where it will ever get around to responding
+ * to the AP.
+ *
+ * Example of sequence of bytes read from EC for a current good transfer:
+ *   1. -                  - AP asserts chip select (CS#)
+ *   2. EC_SPI_OLD_READY   - AP sends first byte(s) of request
+ *   3. -                  - EC starts handling CS# interrupt
+ *   4. EC_SPI_RECEIVING   - AP sends remaining byte(s) of request
+ *   5. EC_SPI_PROCESSING  - EC starts processing request; AP is clocking in
+ *                           bytes looking for EC_SPI_FRAME_START
+ *   6. -                  - EC finishes processing and sets up response
+ *   7. EC_SPI_FRAME_START - AP reads frame byte
+ *   8. (response packet)  - AP reads response packet
+ *   9. EC_SPI_PAST_END    - Any additional bytes read by AP
+ *   10 -                  - AP deasserts chip select
+ *   11 -                  - EC processes CS# interrupt and sets up DMA for
+ *                           next request
+ *
+ * If the AP is waiting for EC_SPI_FRAME_START and sees any value other than
+ * the following byte values:
+ *   EC_SPI_OLD_READY
+ *   EC_SPI_RX_READY
+ *   EC_SPI_RECEIVING
+ *   EC_SPI_PROCESSING
+ *
+ * Then the EC found an error in the request, or was not ready for the request
+ * and lost data.  The AP should give up waiting for EC_SPI_FRAME_START,
+ * because the EC is unable to tell when the AP is done sending its request.
+ */
+
+/*
+ * Framing byte which precedes a response packet from the EC.  After sending a
+ * request, the AP will clock in bytes until it sees the framing byte, then
+ * clock in the response packet.
+ */
+#define EC_SPI_FRAME_START    0xec
+
+/*
+ * Padding bytes which are clocked out after the end of a response packet.
+ */
+#define EC_SPI_PAST_END       0xed
+
+/*
+ * EC is ready to receive, and has ignored the byte sent by the AP.  EC expects
+ * that the AP will send a valid packet header (starting with
+ * EC_COMMAND_PROTOCOL_3) in the next 32 bytes.
+ */
+#define EC_SPI_RX_READY       0xf8
+
+/*
+ * EC has started receiving the request from the AP, but hasn't started
+ * processing it yet.
+ */
+#define EC_SPI_RECEIVING      0xf9
+
+/* EC has received the entire request from the AP and is processing it. */
+#define EC_SPI_PROCESSING     0xfa
+
+/*
+ * EC received bad data from the AP, such as a packet header with an invalid
+ * length.  EC will ignore all data until chip select deasserts.
+ */
+#define EC_SPI_RX_BAD_DATA    0xfb
+
+/*
+ * EC received data from the AP before it was ready.  That is, the AP asserted
+ * chip select and started clocking data before the EC was ready to receive it.
+ * EC will ignore all data until chip select deasserts.
+ */
+#define EC_SPI_NOT_READY      0xfc
+
+/*
+ * EC was ready to receive a request from the AP.  EC has treated the byte sent
+ * by the AP as part of a request packet, or (for old-style ECs) is processing
+ * a fully received packet but is not ready to respond yet.
+ */
+#define EC_SPI_OLD_READY      0xfd
+
+/*****************************************************************************/
+
+/*
+ * Protocol version 2 for I2C and SPI send a request this way:
+ *
+ *	0	EC_CMD_VERSION0 + (command version)
+ *	1	Command number
+ *	2	Length of params = N
+ *	3..N+2	Params, if any
+ *	N+3	8-bit checksum of bytes 0..N+2
+ *
+ * The corresponding response is:
+ *
+ *	0	Result code (EC_RES_*)
+ *	1	Length of params = M
+ *	2..M+1	Params, if any
+ *	M+2	8-bit checksum of bytes 0..M+1
+ */
+#define EC_PROTO2_REQUEST_HEADER_BYTES 3
+#define EC_PROTO2_REQUEST_TRAILER_BYTES 1
+#define EC_PROTO2_REQUEST_OVERHEAD (EC_PROTO2_REQUEST_HEADER_BYTES +	\
+				    EC_PROTO2_REQUEST_TRAILER_BYTES)
+
+#define EC_PROTO2_RESPONSE_HEADER_BYTES 2
+#define EC_PROTO2_RESPONSE_TRAILER_BYTES 1
+#define EC_PROTO2_RESPONSE_OVERHEAD (EC_PROTO2_RESPONSE_HEADER_BYTES +	\
+				     EC_PROTO2_RESPONSE_TRAILER_BYTES)
+
+/* Parameter length was limited by the LPC interface */
+#define EC_PROTO2_MAX_PARAM_SIZE 0xfc
+
+/* Maximum request and response packet sizes for protocol version 2 */
+#define EC_PROTO2_MAX_REQUEST_SIZE (EC_PROTO2_REQUEST_OVERHEAD +	\
+				    EC_PROTO2_MAX_PARAM_SIZE)
+#define EC_PROTO2_MAX_RESPONSE_SIZE (EC_PROTO2_RESPONSE_OVERHEAD +	\
+				     EC_PROTO2_MAX_PARAM_SIZE)
+
+/*****************************************************************************/
+
+/*
+ * Value written to legacy command port / prefix byte to indicate protocol
+ * 3+ structs are being used.  Usage is bus-dependent.
+ */
+#define EC_COMMAND_PROTOCOL_3 0xda
+
+#define EC_HOST_REQUEST_VERSION 3
+
+/* Version 3 request from host */
+struct ec_host_request {
+	/* Struct version (=3)
+	 *
+	 * EC will return EC_RES_INVALID_HEADER if it receives a header with a
+	 * version it doesn't know how to parse.
+	 */
+	uint8_t struct_version;
+
+	/*
+	 * Checksum of request and data; sum of all bytes including checksum
+	 * should total to 0.
+	 */
+	uint8_t checksum;
+
+	/* Command code */
+	uint16_t command;
+
+	/* Command version */
+	uint8_t command_version;
+
+	/* Unused byte in current protocol version; set to 0 */
+	uint8_t reserved;
+
+	/* Length of data which follows this header */
+	uint16_t data_len;
+} __packed;
+
+#define EC_HOST_RESPONSE_VERSION 3
+
+/* Version 3 response from EC */
+struct ec_host_response {
+	/* Struct version (=3) */
+	uint8_t struct_version;
+
+	/*
+	 * Checksum of response and data; sum of all bytes including checksum
+	 * should total to 0.
+	 */
+	uint8_t checksum;
+
+	/* Result code (EC_RES_*) */
+	uint16_t result;
+
+	/* Length of data which follows this header */
+	uint16_t data_len;
+
+	/* Unused bytes in current protocol version; set to 0 */
+	uint16_t reserved;
+} __packed;
+
+/*****************************************************************************/
 /*
  * Notes on commands:
  *
@@ -418,6 +651,68 @@ struct ec_response_get_comms_status {
 	uint32_t flags;		/* Mask of enum ec_comms_status */
 } __packed;
 
+/* Fake a variety of responses, purely for testing purposes. */
+#define EC_CMD_TEST_PROTOCOL		0x0a
+
+/* Tell the EC what to send back to us. */
+struct ec_params_test_protocol {
+	uint32_t ec_result;
+	uint32_t ret_len;
+	uint8_t buf[32];
+} __packed;
+
+/* Here it comes... */
+struct ec_response_test_protocol {
+	uint8_t buf[32];
+} __packed;
+
+/* Get prococol information */
+#define EC_CMD_GET_PROTOCOL_INFO	0x0b
+
+/* Flags for ec_response_get_protocol_info.flags */
+/* EC_RES_IN_PROGRESS may be returned if a command is slow */
+#define EC_PROTOCOL_INFO_IN_PROGRESS_SUPPORTED (1 << 0)
+
+struct ec_response_get_protocol_info {
+	/* Fields which exist if at least protocol version 3 supported */
+
+	/* Bitmask of protocol versions supported (1 << n means version n)*/
+	uint32_t protocol_versions;
+
+	/* Maximum request packet size, in bytes */
+	uint16_t max_request_packet_size;
+
+	/* Maximum response packet size, in bytes */
+	uint16_t max_response_packet_size;
+
+	/* Flags; see EC_PROTOCOL_INFO_* */
+	uint32_t flags;
+} __packed;
+
+
+/*****************************************************************************/
+/* Get/Set miscellaneous values */
+
+/* The upper byte of .flags tells what to do (nothing means "get") */
+#define EC_GSV_SET        0x80000000
+
+/* The lower three bytes of .flags identifies the parameter, if that has
+   meaning for an individual command. */
+#define EC_GSV_PARAM_MASK 0x00ffffff
+
+struct ec_params_get_set_value {
+	uint32_t flags;
+	uint32_t value;
+} __packed;
+
+struct ec_response_get_set_value {
+	uint32_t flags;
+	uint32_t value;
+} __packed;
+
+/* More than one command can use these structs to get/set paramters. */
+#define EC_CMD_GSV_PAUSE_IN_S5	0x0c
+
 
 /*****************************************************************************/
 /* Flash commands */
@@ -425,6 +720,7 @@ struct ec_response_get_comms_status {
 /* Get flash info */
 #define EC_CMD_FLASH_INFO 0x10
 
+/* Version 0 returns these fields */
 struct ec_response_flash_info {
 	/* Usable flash size, in bytes */
 	uint32_t flash_size;
@@ -445,6 +741,37 @@ struct ec_response_flash_info {
 	uint32_t protect_block_size;
 } __packed;
 
+/* Flags for version 1+ flash info command */
+/* EC flash erases bits to 0 instead of 1 */
+#define EC_FLASH_INFO_ERASE_TO_0 (1 << 0)
+
+/*
+ * Version 1 returns the same initial fields as version 0, with additional
+ * fields following.
+ *
+ * gcc anonymous structs don't seem to get along with the __packed directive;
+ * if they did we'd define the version 0 struct as a sub-struct of this one.
+ */
+struct ec_response_flash_info_1 {
+	/* Version 0 fields; see above for description */
+	uint32_t flash_size;
+	uint32_t write_block_size;
+	uint32_t erase_block_size;
+	uint32_t protect_block_size;
+
+	/* Version 1 adds these fields: */
+	/*
+	 * Ideal write size in bytes.  Writes will be fastest if size is
+	 * exactly this and offset is a multiple of this.  For example, an EC
+	 * may have a write buffer which can do half-page operations if data is
+	 * aligned, and a slower word-at-a-time write mode.
+	 */
+	uint32_t write_ideal_size;
+
+	/* Flags; see EC_FLASH_INFO_* */
+	uint32_t flags;
+} __packed;
+
 /*
  * Read flash
  *
@@ -459,15 +786,15 @@ struct ec_params_flash_read {
 
 /* Write flash */
 #define EC_CMD_FLASH_WRITE 0x12
+#define EC_VER_FLASH_WRITE 1
+
+/* Version 0 of the flash command supported only 64 bytes of data */
+#define EC_FLASH_WRITE_VER0_SIZE 64
 
 struct ec_params_flash_write {
 	uint32_t offset;   /* Byte offset to write */
 	uint32_t size;     /* Size to write in bytes */
-	/*
-	 * Data to write.  Could really use EC_PARAM_SIZE - 8, but tidiest to
-	 * use a power of 2 so writes stay aligned.
-	 */
-	uint8_t data[64];
+	/* Followed by data to write */
 } __packed;
 
 /* Erase flash */
@@ -543,7 +870,7 @@ struct ec_response_flash_protect {
 
 enum ec_flash_region {
 	/* Region which holds read-only EC image */
-	EC_FLASH_REGION_RO,
+	EC_FLASH_REGION_RO = 0,
 	/* Region which holds rewritable EC image */
 	EC_FLASH_REGION_RW,
 	/*
@@ -551,6 +878,8 @@ enum ec_flash_region {
 	 * EC_FLASH_REGION_RO)
 	 */
 	EC_FLASH_REGION_WP_RO,
+	/* Number of regions */
+	EC_FLASH_REGION_COUNT,
 };
 
 struct ec_params_flash_region_info {
@@ -639,15 +968,15 @@ struct rgb_s {
  */
 struct lightbar_params {
 	/* Timing */
-	int google_ramp_up;
-	int google_ramp_down;
-	int s3s0_ramp_up;
-	int s0_tick_delay[2];			/* AC=0/1 */
-	int s0a_tick_delay[2];			/* AC=0/1 */
-	int s0s3_ramp_down;
-	int s3_sleep_for;
-	int s3_ramp_up;
-	int s3_ramp_down;
+	int32_t google_ramp_up;
+	int32_t google_ramp_down;
+	int32_t s3s0_ramp_up;
+	int32_t s0_tick_delay[2];		/* AC=0/1 */
+	int32_t s0a_tick_delay[2];		/* AC=0/1 */
+	int32_t s0s3_ramp_down;
+	int32_t s3_sleep_for;
+	int32_t s3_ramp_up;
+	int32_t s3_ramp_down;
 
 	/* Oscillation */
 	uint8_t new_s0;
@@ -676,7 +1005,7 @@ struct ec_params_lightbar {
 	union {
 		struct {
 			/* no args */
-		} dump, off, on, init, get_seq, get_params;
+		} dump, off, on, init, get_seq, get_params, version;
 
 		struct num {
 			uint8_t num;
@@ -710,6 +1039,11 @@ struct ec_response_lightbar {
 
 		struct lightbar_params get_params;
 
+		struct version {
+			uint32_t num;
+			uint32_t flags;
+		} version;
+
 		struct {
 			/* no return params */
 		} off, on, init, brightness, seq, reg, rgb, demo, set_params;
@@ -730,10 +1064,62 @@ enum lightbar_command {
 	LIGHTBAR_CMD_DEMO = 9,
 	LIGHTBAR_CMD_GET_PARAMS = 10,
 	LIGHTBAR_CMD_SET_PARAMS = 11,
+	LIGHTBAR_CMD_VERSION = 12,
 	LIGHTBAR_NUM_CMDS
 };
 
 /*****************************************************************************/
+/* LED control commands */
+
+#define EC_CMD_LED_CONTROL 0x29
+
+enum ec_led_id {
+	/* LED to indicate battery state of charge */
+	EC_LED_ID_BATTERY_LED = 0,
+	/*
+	 * LED to indicate system power state (on or in suspend).
+	 * May be on power button or on C-panel.
+	 */
+	EC_LED_ID_POWER_LED,
+	/* LED on power adapter or its plug */
+	EC_LED_ID_ADAPTER_LED,
+
+	EC_LED_ID_COUNT
+};
+
+/* LED control flags */
+#define EC_LED_FLAGS_QUERY (1 << 0) /* Query LED capability only */
+#define EC_LED_FLAGS_AUTO  (1 << 1) /* Switch LED back to automatic control */
+
+enum ec_led_colors {
+	EC_LED_COLOR_RED = 0,
+	EC_LED_COLOR_GREEN,
+	EC_LED_COLOR_BLUE,
+	EC_LED_COLOR_YELLOW,
+	EC_LED_COLOR_WHITE,
+
+	EC_LED_COLOR_COUNT
+};
+
+struct ec_params_led_control {
+	uint8_t led_id;     /* Which LED to control */
+	uint8_t flags;      /* Control flags */
+
+	uint8_t brightness[EC_LED_COLOR_COUNT];
+} __packed;
+
+struct ec_response_led_control {
+	/*
+	 * Available brightness value range.
+	 *
+	 * Range 0 means color channel not present.
+	 * Range 1 means on/off control.
+	 * Other values means the LED is control by PWM.
+	 */
+	uint8_t brightness_range[EC_LED_COLOR_COUNT];
+} __packed;
+
+/*****************************************************************************/
 /* Verified boot commands */
 
 /*
@@ -790,6 +1176,181 @@ enum ec_vboot_hash_status {
 #define EC_VBOOT_HASH_OFFSET_RW 0xfffffffd
 
 /*****************************************************************************/
+/*
+ * Motion sense commands. We'll make separate structs for sub-commands with
+ * different input args, so that we know how much to expect.
+ */
+#define EC_CMD_MOTION_SENSE_CMD 0x2B
+
+/* Motion sense commands */
+enum motionsense_command {
+	/*
+	 * Dump command returns all motion sensor data including motion sense
+	 * module flags and individual sensor flags.
+	 */
+	MOTIONSENSE_CMD_DUMP = 0,
+
+	/*
+	 * Info command returns data describing the details of a given sensor,
+	 * including enum motionsensor_type, enum motionsensor_location, and
+	 * enum motionsensor_chip.
+	 */
+	MOTIONSENSE_CMD_INFO = 1,
+
+	/*
+	 * EC Rate command is a setter/getter command for the EC sampling rate
+	 * of all motion sensors in milliseconds.
+	 */
+	MOTIONSENSE_CMD_EC_RATE = 2,
+
+	/*
+	 * Sensor ODR command is a setter/getter command for the output data
+	 * rate of a specific motion sensor in millihertz.
+	 */
+	MOTIONSENSE_CMD_SENSOR_ODR = 3,
+
+	/*
+	 * Sensor range command is a setter/getter command for the range of
+	 * a specified motion sensor in +/-G's or +/- deg/s.
+	 */
+	MOTIONSENSE_CMD_SENSOR_RANGE = 4,
+
+	/*
+	 * Setter/getter command for the keyboard wake angle. When the lid
+	 * angle is greater than this value, keyboard wake is disabled in S3,
+	 * and when the lid angle goes less than this value, keyboard wake is
+	 * enabled. Note, the lid angle measurement is an approximate,
+	 * un-calibrated value, hence the wake angle isn't exact.
+	 */
+	MOTIONSENSE_CMD_KB_WAKE_ANGLE = 5,
+
+	/* Number of motionsense sub-commands. */
+	MOTIONSENSE_NUM_CMDS
+};
+
+enum motionsensor_id {
+	EC_MOTION_SENSOR_ACCEL_BASE = 0,
+	EC_MOTION_SENSOR_ACCEL_LID = 1,
+	EC_MOTION_SENSOR_GYRO = 2,
+
+	/*
+	 * Note, if more sensors are added and this count changes, the padding
+	 * in ec_response_motion_sense dump command must be modified.
+	 */
+	EC_MOTION_SENSOR_COUNT = 3
+};
+
+/* List of motion sensor types. */
+enum motionsensor_type {
+	MOTIONSENSE_TYPE_ACCEL = 0,
+	MOTIONSENSE_TYPE_GYRO = 1,
+};
+
+/* List of motion sensor locations. */
+enum motionsensor_location {
+	MOTIONSENSE_LOC_BASE = 0,
+	MOTIONSENSE_LOC_LID = 1,
+};
+
+/* List of motion sensor chips. */
+enum motionsensor_chip {
+	MOTIONSENSE_CHIP_KXCJ9 = 0,
+};
+
+/* Module flag masks used for the dump sub-command. */
+#define MOTIONSENSE_MODULE_FLAG_ACTIVE (1<<0)
+
+/* Sensor flag masks used for the dump sub-command. */
+#define MOTIONSENSE_SENSOR_FLAG_PRESENT (1<<0)
+
+/*
+ * Send this value for the data element to only perform a read. If you
+ * send any other value, the EC will interpret it as data to set and will
+ * return the actual value set.
+ */
+#define EC_MOTION_SENSE_NO_VALUE -1
+
+struct ec_params_motion_sense {
+	uint8_t cmd;
+	union {
+		/* Used for MOTIONSENSE_CMD_DUMP. */
+		struct {
+			/* no args */
+		} dump;
+
+		/*
+		 * Used for MOTIONSENSE_CMD_EC_RATE and
+		 * MOTIONSENSE_CMD_KB_WAKE_ANGLE.
+		 */
+		struct {
+			/* Data to set or EC_MOTION_SENSE_NO_VALUE to read. */
+			int16_t data;
+		} ec_rate, kb_wake_angle;
+
+		/* Used for MOTIONSENSE_CMD_INFO. */
+		struct {
+			/* Should be element of enum motionsensor_id. */
+			uint8_t sensor_num;
+		} info;
+
+		/*
+		 * Used for MOTIONSENSE_CMD_SENSOR_ODR and
+		 * MOTIONSENSE_CMD_SENSOR_RANGE.
+		 */
+		struct {
+			/* Should be element of enum motionsensor_id. */
+			uint8_t sensor_num;
+
+			/* Rounding flag, true for round-up, false for down. */
+			uint8_t roundup;
+
+			uint16_t reserved;
+
+			/* Data to set or EC_MOTION_SENSE_NO_VALUE to read. */
+			int32_t data;
+		} sensor_odr, sensor_range;
+	};
+} __packed;
+
+struct ec_response_motion_sense {
+	union {
+		/* Used for MOTIONSENSE_CMD_DUMP. */
+		struct {
+			/* Flags representing the motion sensor module. */
+			uint8_t module_flags;
+
+			/* Flags for each sensor in enum motionsensor_id. */
+			uint8_t sensor_flags[EC_MOTION_SENSOR_COUNT];
+
+			/* Array of all sensor data. Each sensor is 3-axis. */
+			int16_t data[3*EC_MOTION_SENSOR_COUNT];
+		} dump;
+
+		/* Used for MOTIONSENSE_CMD_INFO. */
+		struct {
+			/* Should be element of enum motionsensor_type. */
+			uint8_t type;
+
+			/* Should be element of enum motionsensor_location. */
+			uint8_t location;
+
+			/* Should be element of enum motionsensor_chip. */
+			uint8_t chip;
+		} info;
+
+		/*
+		 * Used for MOTIONSENSE_CMD_EC_RATE, MOTIONSENSE_CMD_SENSOR_ODR,
+		 * MOTIONSENSE_CMD_SENSOR_RANGE, and
+		 * MOTIONSENSE_CMD_KB_WAKE_ANGLE.
+		 */
+		struct {
+			/* Current value of the parameter queried. */
+			int32_t ret;
+		} ec_rate, sensor_odr, sensor_range, kb_wake_angle;
+	};
+} __packed;
+
+/*****************************************************************************/
 /* USB charging control commands */
 
 /* Set USB port charging mode */
@@ -868,20 +1429,27 @@ struct ec_response_port80_last_boot {
 } __packed;
 
 /*****************************************************************************/
-/* Thermal engine commands */
+/* Thermal engine commands. Note that there are two implementations. We'll
+ * reuse the command number, but the data and behavior is incompatible.
+ * Version 0 is what originally shipped on Link.
+ * Version 1 separates the CPU thermal limits from the fan control.
+ */
 
-/* Set thershold value */
 #define EC_CMD_THERMAL_SET_THRESHOLD 0x50
+#define EC_CMD_THERMAL_GET_THRESHOLD 0x51
+
+/* The version 0 structs are opaque. You have to know what they are for
+ * the get/set commands to make any sense.
+ */
 
+/* Version 0 - set */
 struct ec_params_thermal_set_threshold {
 	uint8_t sensor_type;
 	uint8_t threshold_id;
 	uint16_t value;
 } __packed;
 
-/* Get threshold value */
-#define EC_CMD_THERMAL_GET_THRESHOLD 0x51
-
+/* Version 0 - get */
 struct ec_params_thermal_get_threshold {
 	uint8_t sensor_type;
 	uint8_t threshold_id;
@@ -891,6 +1459,41 @@ struct ec_response_thermal_get_threshold {
 	uint16_t value;
 } __packed;
 
+
+/* The version 1 structs are visible. */
+enum ec_temp_thresholds {
+	EC_TEMP_THRESH_WARN = 0,
+	EC_TEMP_THRESH_HIGH,
+	EC_TEMP_THRESH_HALT,
+
+	EC_TEMP_THRESH_COUNT
+};
+
+/* Thermal configuration for one temperature sensor. Temps are in degrees K.
+ * Zero values will be silently ignored by the thermal task.
+ */
+struct ec_thermal_config {
+	uint32_t temp_host[EC_TEMP_THRESH_COUNT]; /* levels of hotness */
+	uint32_t temp_fan_off;		/* no active cooling needed */
+	uint32_t temp_fan_max;		/* max active cooling needed */
+} __packed;
+
+/* Version 1 - get config for one sensor. */
+struct ec_params_thermal_get_threshold_v1 {
+	uint32_t sensor_num;
+} __packed;
+/* This returns a struct ec_thermal_config */
+
+/* Version 1 - set config for one sensor.
+ * Use read-modify-write for best results! */
+struct ec_params_thermal_set_threshold_v1 {
+	uint32_t sensor_num;
+	struct ec_thermal_config cfg;
+} __packed;
+/* This returns no data */
+
+/****************************************************************************/
+
 /* Toggle automatic fan control */
 #define EC_CMD_THERMAL_AUTO_FAN_CTRL 0x52
 
@@ -920,6 +1523,18 @@ struct ec_params_tmp006_set_calibration {
 	float b2;
 } __packed;
 
+/* Read raw TMP006 data */
+#define EC_CMD_TMP006_GET_RAW 0x55
+
+struct ec_params_tmp006_get_raw {
+	uint8_t index;
+} __packed;
+
+struct ec_response_tmp006_get_raw {
+	int32_t t;  /* In 1/100 K */
+	int32_t v;  /* In nV */
+};
+
 /*****************************************************************************/
 /* MKBP - Matrix KeyBoard Protocol */
 
@@ -1118,11 +1733,41 @@ struct ec_params_switch_enable_backlight {
 
 /* Enable/disable WLAN/Bluetooth */
 #define EC_CMD_SWITCH_ENABLE_WIRELESS 0x91
+#define EC_VER_SWITCH_ENABLE_WIRELESS 1
 
-struct ec_params_switch_enable_wireless {
+/* Version 0 params; no response */
+struct ec_params_switch_enable_wireless_v0 {
 	uint8_t enabled;
 } __packed;
 
+/* Version 1 params */
+struct ec_params_switch_enable_wireless_v1 {
+	/* Flags to enable now */
+	uint8_t now_flags;
+
+	/* Which flags to copy from now_flags */
+	uint8_t now_mask;
+
+	/*
+	 * Flags to leave enabled in S3, if they're on at the S0->S3
+	 * transition.  (Other flags will be disabled by the S0->S3
+	 * transition.)
+	 */
+	uint8_t suspend_flags;
+
+	/* Which flags to copy from suspend_flags */
+	uint8_t suspend_mask;
+} __packed;
+
+/* Version 1 response */
+struct ec_response_switch_enable_wireless_v1 {
+	/* Flags to enable now */
+	uint8_t now_flags;
+
+	/* Flags to leave enabled in S3 */
+	uint8_t suspend_flags;
+} __packed;
+
 /*****************************************************************************/
 /* GPIO commands. Only available on EC if write protect has been disabled. */
 
@@ -1147,11 +1792,16 @@ struct ec_response_gpio_get {
 /*****************************************************************************/
 /* I2C commands. Only available when flash write protect is unlocked. */
 
+/*
+ * TODO(crosbug.com/p/23570): These commands are deprecated, and will be
+ * removed soon.  Use EC_CMD_I2C_XFER instead.
+ */
+
 /* Read I2C bus */
 #define EC_CMD_I2C_READ 0x94
 
 struct ec_params_i2c_read {
-	uint16_t addr;
+	uint16_t addr; /* 8-bit address (7-bit shifted << 1) */
 	uint8_t read_size; /* Either 8 or 16. */
 	uint8_t port;
 	uint8_t offset;
@@ -1165,7 +1815,7 @@ struct ec_response_i2c_read {
 
 struct ec_params_i2c_write {
 	uint16_t data;
-	uint16_t addr;
+	uint16_t addr; /* 8-bit address (7-bit shifted << 1) */
 	uint8_t write_size; /* Either 8 or 16. */
 	uint8_t port;
 	uint8_t offset;
@@ -1174,11 +1824,20 @@ struct ec_params_i2c_write {
 /*****************************************************************************/
 /* Charge state commands. Only available when flash write protect unlocked. */
 
-/* Force charge state machine to stop in idle mode */
-#define EC_CMD_CHARGE_FORCE_IDLE 0x96
+/* Force charge state machine to stop charging the battery or force it to
+ * discharge the battery.
+ */
+#define EC_CMD_CHARGE_CONTROL 0x96
+#define EC_VER_CHARGE_CONTROL 1
 
-struct ec_params_force_idle {
-	uint8_t enabled;
+enum ec_charge_control_mode {
+	CHARGE_CONTROL_NORMAL = 0,
+	CHARGE_CONTROL_IDLE,
+	CHARGE_CONTROL_DISCHARGE,
+};
+
+struct ec_params_charge_control {
+	uint32_t mode;  /* enum charge_control_mode */
 } __packed;
 
 /*****************************************************************************/
@@ -1206,14 +1865,231 @@ struct ec_params_force_idle {
 #define EC_CMD_BATTERY_CUT_OFF 0x99
 
 /*****************************************************************************/
-/* Temporary debug commands. TODO: remove this crosbug.com/p/13849 */
+/* USB port mux control. */
 
 /*
- * Dump charge state machine context.
- *
- * Response is a binary dump of charge state machine context.
+ * Switch USB mux or return to automatic switching.
+ */
+#define EC_CMD_USB_MUX 0x9a
+
+struct ec_params_usb_mux {
+	uint8_t mux;
+} __packed;
+
+/*****************************************************************************/
+/* LDOs / FETs control. */
+
+enum ec_ldo_state {
+	EC_LDO_STATE_OFF = 0,	/* the LDO / FET is shut down */
+	EC_LDO_STATE_ON = 1,	/* the LDO / FET is ON / providing power */
+};
+
+/*
+ * Switch on/off a LDO.
+ */
+#define EC_CMD_LDO_SET 0x9b
+
+struct ec_params_ldo_set {
+	uint8_t index;
+	uint8_t state;
+} __packed;
+
+/*
+ * Get LDO state.
+ */
+#define EC_CMD_LDO_GET 0x9c
+
+struct ec_params_ldo_get {
+	uint8_t index;
+} __packed;
+
+struct ec_response_ldo_get {
+	uint8_t state;
+} __packed;
+
+/*****************************************************************************/
+/* Power info. */
+
+/*
+ * Get power info.
+ */
+#define EC_CMD_POWER_INFO 0x9d
+
+struct ec_response_power_info {
+	uint32_t usb_dev_type;
+	uint16_t voltage_ac;
+	uint16_t voltage_system;
+	uint16_t current_system;
+	uint16_t usb_current_limit;
+} __packed;
+
+/*****************************************************************************/
+/* I2C passthru command */
+
+#define EC_CMD_I2C_PASSTHRU 0x9e
+
+/* Slave address is 10 (not 7) bit */
+#define EC_I2C_FLAG_10BIT	(1 << 16)
+
+/* Read data; if not present, message is a write */
+#define EC_I2C_FLAG_READ	(1 << 15)
+
+/* Mask for address */
+#define EC_I2C_ADDR_MASK	0x3ff
+
+#define EC_I2C_STATUS_NAK	(1 << 0) /* Transfer was not acknowledged */
+#define EC_I2C_STATUS_TIMEOUT	(1 << 1) /* Timeout during transfer */
+
+/* Any error */
+#define EC_I2C_STATUS_ERROR	(EC_I2C_STATUS_NAK | EC_I2C_STATUS_TIMEOUT)
+
+struct ec_params_i2c_passthru_msg {
+	uint16_t addr_flags;	/* I2C slave address (7 or 10 bits) and flags */
+	uint16_t len;		/* Number of bytes to read or write */
+} __packed;
+
+struct ec_params_i2c_passthru {
+	uint8_t port;		/* I2C port number */
+	uint8_t num_msgs;	/* Number of messages */
+	struct ec_params_i2c_passthru_msg msg[];
+	/* Data to write for all messages is concatenated here */
+} __packed;
+
+struct ec_response_i2c_passthru {
+	uint8_t i2c_status;	/* Status flags (EC_I2C_STATUS_...) */
+	uint8_t num_msgs;	/* Number of messages processed */
+	uint8_t data[];		/* Data read by messages concatenated here */
+} __packed;
+
+/*****************************************************************************/
+/* Power button hang detect */
+
+#define EC_CMD_HANG_DETECT 0x9f
+
+/* Reasons to start hang detection timer */
+/* Power button pressed */
+#define EC_HANG_START_ON_POWER_PRESS  (1 << 0)
+
+/* Lid closed */
+#define EC_HANG_START_ON_LID_CLOSE    (1 << 1)
+
+ /* Lid opened */
+#define EC_HANG_START_ON_LID_OPEN     (1 << 2)
+
+/* Start of AP S3->S0 transition (booting or resuming from suspend) */
+#define EC_HANG_START_ON_RESUME       (1 << 3)
+
+/* Reasons to cancel hang detection */
+
+/* Power button released */
+#define EC_HANG_STOP_ON_POWER_RELEASE (1 << 8)
+
+/* Any host command from AP received */
+#define EC_HANG_STOP_ON_HOST_COMMAND  (1 << 9)
+
+/* Stop on end of AP S0->S3 transition (suspending or shutting down) */
+#define EC_HANG_STOP_ON_SUSPEND       (1 << 10)
+
+/*
+ * If this flag is set, all the other fields are ignored, and the hang detect
+ * timer is started.  This provides the AP a way to start the hang timer
+ * without reconfiguring any of the other hang detect settings.  Note that
+ * you must previously have configured the timeouts.
+ */
+#define EC_HANG_START_NOW             (1 << 30)
+
+/*
+ * If this flag is set, all the other fields are ignored (including
+ * EC_HANG_START_NOW).  This provides the AP a way to stop the hang timer
+ * without reconfiguring any of the other hang detect settings.
  */
-#define EC_CMD_CHARGE_DUMP 0xa0
+#define EC_HANG_STOP_NOW              (1 << 31)
+
+struct ec_params_hang_detect {
+	/* Flags; see EC_HANG_* */
+	uint32_t flags;
+
+	/* Timeout in msec before generating host event, if enabled */
+	uint16_t host_event_timeout_msec;
+
+	/* Timeout in msec before generating warm reboot, if enabled */
+	uint16_t warm_reboot_timeout_msec;
+} __packed;
+
+/*****************************************************************************/
+/* Commands for battery charging */
+
+/*
+ * This is the single catch-all host command to exchange data regarding the
+ * charge state machine (v2 and up).
+ */
+#define EC_CMD_CHARGE_STATE 0xa0
+
+/* Subcommands for this host command */
+enum charge_state_command {
+	CHARGE_STATE_CMD_GET_STATE,
+	CHARGE_STATE_CMD_GET_PARAM,
+	CHARGE_STATE_CMD_SET_PARAM,
+	CHARGE_STATE_NUM_CMDS
+};
+
+/*
+ * Known param numbers are defined here. Ranges are reserved for board-specific
+ * params, which are handled by the particular implementations.
+ */
+enum charge_state_params {
+	CS_PARAM_CHG_VOLTAGE,	      /* charger voltage limit */
+	CS_PARAM_CHG_CURRENT,	      /* charger current limit */
+	CS_PARAM_CHG_INPUT_CURRENT,   /* charger input current limit */
+	CS_PARAM_CHG_STATUS,	      /* charger-specific status */
+	CS_PARAM_CHG_OPTION,	      /* charger-specific options */
+	/* How many so far? */
+	CS_NUM_BASE_PARAMS,
+
+	/* Range for CONFIG_CHARGER_PROFILE_OVERRIDE params */
+	CS_PARAM_CUSTOM_PROFILE_MIN = 0x10000,
+	CS_PARAM_CUSTOM_PROFILE_MAX = 0x1ffff,
+
+	/* Other custom param ranges go here... */
+};
+
+struct ec_params_charge_state {
+	uint8_t cmd;				/* enum charge_state_command */
+	union {
+		struct {
+			/* no args */
+		} get_state;
+
+		struct {
+			uint32_t param;		/* enum charge_state_param */
+		} get_param;
+
+		struct {
+			uint32_t param;		/* param to set */
+			uint32_t value;		/* value to set */
+		} set_param;
+	};
+} __packed;
+
+struct ec_response_charge_state {
+	union {
+		struct {
+			int ac;
+			int chg_voltage;
+			int chg_current;
+			int chg_input_current;
+			int batt_state_of_charge;
+		} get_state;
+
+		struct {
+			uint32_t value;
+		} get_param;
+		struct {
+			/* no return values */
+		} set_param;
+	};
+} __packed;
+
 
 /*
  * Set maximum battery charging current.
@@ -1221,15 +2097,59 @@ struct ec_params_force_idle {
 #define EC_CMD_CHARGE_CURRENT_LIMIT 0xa1
 
 struct ec_params_current_limit {
-	uint32_t limit;
+	uint32_t limit; /* in mA */
+} __packed;
+
+/*
+ * Set maximum external power current.
+ */
+#define EC_CMD_EXT_POWER_CURRENT_LIMIT 0xa2
+
+struct ec_params_ext_power_current_limit {
+	uint32_t limit; /* in mA */
+} __packed;
+
+/*****************************************************************************/
+/* Smart battery pass-through */
+
+/* Get / Set 16-bit smart battery registers */
+#define EC_CMD_SB_READ_WORD   0xb0
+#define EC_CMD_SB_WRITE_WORD  0xb1
+
+/* Get / Set string smart battery parameters
+ * formatted as SMBUS "block".
+ */
+#define EC_CMD_SB_READ_BLOCK  0xb2
+#define EC_CMD_SB_WRITE_BLOCK 0xb3
+
+struct ec_params_sb_rd {
+	uint8_t reg;
+} __packed;
+
+struct ec_response_sb_rd_word {
+	uint16_t value;
+} __packed;
+
+struct ec_params_sb_wr_word {
+	uint8_t reg;
+	uint16_t value;
+} __packed;
+
+struct ec_response_sb_rd_block {
+	uint8_t data[32];
+} __packed;
+
+struct ec_params_sb_wr_block {
+	uint8_t reg;
+	uint16_t data[32];
 } __packed;
 
 /*****************************************************************************/
 /* System commands */
 
 /*
- * TODO: this is a confusing name, since it doesn't necessarily reboot the EC.
- * Rename to "set image" or something similar.
+ * TODO(crosbug.com/p/23747): This is a confusing name, since it doesn't
+ * necessarily reboot the EC.  Rename to "image" or something similar?
  */
 #define EC_CMD_REBOOT_EC 0xd2
 
@@ -1308,6 +2228,7 @@ struct ec_params_reboot_ec {
 #define EC_CMD_ACPI_QUERY_EVENT 0x84
 
 /* Valid addresses in ACPI memory space, for read/write commands */
+
 /* Memory space version; set to EC_ACPI_MEM_VERSION_CURRENT */
 #define EC_ACPI_MEM_VERSION            0x00
 /*
@@ -1317,8 +2238,60 @@ struct ec_params_reboot_ec {
 #define EC_ACPI_MEM_TEST               0x01
 /* Test compliment; writes here are ignored. */
 #define EC_ACPI_MEM_TEST_COMPLIMENT    0x02
+
 /* Keyboard backlight brightness percent (0 - 100) */
 #define EC_ACPI_MEM_KEYBOARD_BACKLIGHT 0x03
+/* DPTF Target Fan Duty (0-100, 0xff for auto/none) */
+#define EC_ACPI_MEM_FAN_DUTY           0x04
+
+/*
+ * DPTF temp thresholds. Any of the EC's temp sensors can have up to two
+ * independent thresholds attached to them. The current value of the ID
+ * register determines which sensor is affected by the THRESHOLD and COMMIT
+ * registers. The THRESHOLD register uses the same EC_TEMP_SENSOR_OFFSET scheme
+ * as the memory-mapped sensors. The COMMIT register applies those settings.
+ *
+ * The spec does not mandate any way to read back the threshold settings
+ * themselves, but when a threshold is crossed the AP needs a way to determine
+ * which sensor(s) are responsible. Each reading of the ID register clears and
+ * returns one sensor ID that has crossed one of its threshold (in either
+ * direction) since the last read. A value of 0xFF means "no new thresholds
+ * have tripped". Setting or enabling the thresholds for a sensor will clear
+ * the unread event count for that sensor.
+ */
+#define EC_ACPI_MEM_TEMP_ID            0x05
+#define EC_ACPI_MEM_TEMP_THRESHOLD     0x06
+#define EC_ACPI_MEM_TEMP_COMMIT        0x07
+/*
+ * Here are the bits for the COMMIT register:
+ *   bit 0 selects the threshold index for the chosen sensor (0/1)
+ *   bit 1 enables/disables the selected threshold (0 = off, 1 = on)
+ * Each write to the commit register affects one threshold.
+ */
+#define EC_ACPI_MEM_TEMP_COMMIT_SELECT_MASK (1 << 0)
+#define EC_ACPI_MEM_TEMP_COMMIT_ENABLE_MASK (1 << 1)
+/*
+ * Example:
+ *
+ * Set the thresholds for sensor 2 to 50 C and 60 C:
+ *   write 2 to [0x05]      --  select temp sensor 2
+ *   write 0x7b to [0x06]   --  C_TO_K(50) - EC_TEMP_SENSOR_OFFSET
+ *   write 0x2 to [0x07]    --  enable threshold 0 with this value
+ *   write 0x85 to [0x06]   --  C_TO_K(60) - EC_TEMP_SENSOR_OFFSET
+ *   write 0x3 to [0x07]    --  enable threshold 1 with this value
+ *
+ * Disable the 60 C threshold, leaving the 50 C threshold unchanged:
+ *   write 2 to [0x05]      --  select temp sensor 2
+ *   write 0x1 to [0x07]    --  disable threshold 1
+ */
+
+/* DPTF battery charging current limit */
+#define EC_ACPI_MEM_CHARGING_LIMIT     0x08
+
+/* Charging limit is specified in 64 mA steps */
+#define EC_ACPI_MEM_CHARGING_LIMIT_STEP_MA   64
+/* Value to disable DPTF battery charging limit */
+#define EC_ACPI_MEM_CHARGING_LIMIT_DISABLED  0xff
 
 /* Current version of ACPI memory address space */
 #define EC_ACPI_MEM_VERSION_CURRENT 1
@@ -1360,10 +2333,21 @@ struct ec_params_reboot_ec {
  * Header bytes greater than this indicate a later version. For example,
  * EC_CMD_VERSION0 + 1 means we are using version 1.
  *
- * The old EC interface must not use commands 0dc or higher.
+ * The old EC interface must not use commands 0xdc or higher.
  */
 #define EC_CMD_VERSION0 0xdc
 
 #endif  /* !__ACPI__ */
 
+/*****************************************************************************/
+/*
+ * Deprecated constants. These constants have been renamed for clarity. The
+ * meaning and size has not changed. Programs that use the old names should
+ * switch to the new names soon, as the old names may not be carried forward
+ * forever.
+ */
+#define EC_HOST_PARAM_SIZE      EC_PROTO2_MAX_PARAM_SIZE
+#define EC_LPC_ADDR_OLD_PARAM   EC_HOST_CMD_REGION1
+#define EC_OLD_PARAM_SIZE       EC_HOST_CMD_REGION_SIZE
+
 #endif  /* __CROS_EC_COMMANDS_H */
-- 
1.9.1.423.g4596e3a

