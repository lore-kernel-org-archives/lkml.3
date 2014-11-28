Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbaK1PTr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 10:19:47 -0500
Received: from sender1.zohomail.com ([72.5.230.103]:29955 "EHLO
	sender1.zohomail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbaK1PTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 10:19:43 -0500
From: =?UTF-8?q?Javier=20Gonz=C3=A1lez?= <javier@javigon.com>
To: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, joshc@codeaurora.org,
        johannes.thumshirn@men.de, kheitke@codeaurora.org,
        laurent.pinchart+renesas@ideasonboard.com, geert+renesas@glider.be,
        horms+renesas@verge.net.au, damm@opensource.se, tomi.valkeinen@ti.com,
        mbohan@codeaurora.org, michal.simek@xilinx.com
Cc: pawel.moll@arm.com, Andrew.Thoelke@arm.com, javier@javigon.com
Subject: [RFC PATCH 2/3] Open Virtualization driver
Date: Fri, 28 Nov 2014 16:03:35 +0100
Message-Id: <1417187016-7731-3-git-send-email-javier@javigon.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417187016-7731-1-git-send-email-javier@javigon.com>
References: <1417187016-7731-1-git-send-email-javier@javigon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
X-ZohoMail: Ss  SS_10 UW UB CHF_INT_SMD_EXT  SGR4_1_19114_170
X-ZohoMail-Owner: <1417187016-7731-3-git-send-email-javier@javigon.com>+zmo_0_<javier@javigon.com>
X-ZohoMail-Sender: 130.226.133.124
X-Zoho-Virus-Status: 2
X-ZohoMailClient: External
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Javier Gonzalez <javier@javigon.com>

Sierraware's Open Virtualization driver. It allows to communicate to Open
Virtualization's TEE to execute sensitive tasks in the secure world.

This patch is based on SierraWare's Open Virtualization kernel driver and header
files. This code is not directly usable in kernel space; the intention behind
this patch is to give Sierraware the recognition of creating the base driver to
communicate to Open Virtualization.

Copyright and contribution belongs to Sierraware. Documentation can be found at
www.openvirtualization.org

Signed-off-by: Javier Gonzalez <javier@javigon.com>
---
 drivers/sechw/trustzone/otz_api.h         | 1381 +++++++++++++++++
 drivers/sechw/trustzone/otz_client.h      |  131 ++
 drivers/sechw/trustzone/otz_client_main.c | 2315 +++++++++++++++++++++++++++++
 drivers/sechw/trustzone/otz_common.h      |  119 ++
 drivers/sechw/trustzone/otz_id.h          |  178 +++
 drivers/sechw/trustzone/smc_id.h          |   66 +
 drivers/sechw/trustzone/sw_common_types.h |   31 +
 drivers/sechw/trustzone/sw_config.h       |   16 +
 8 files changed, 4237 insertions(+)
 create mode 100644 drivers/sechw/trustzone/otz_api.h
 create mode 100644 drivers/sechw/trustzone/otz_client.h
 create mode 100644 drivers/sechw/trustzone/otz_client_main.c
 create mode 100644 drivers/sechw/trustzone/otz_common.h
 create mode 100644 drivers/sechw/trustzone/otz_id.h
 create mode 100644 drivers/sechw/trustzone/smc_id.h
 create mode 100644 drivers/sechw/trustzone/sw_common_types.h
 create mode 100644 drivers/sechw/trustzone/sw_config.h

diff --git a/drivers/sechw/trustzone/otz_api.h b/drivers/sechw/trustzone/otz_api.h
new file mode 100644
index 0000000..f769634
--- /dev/null
+++ b/drivers/sechw/trustzone/otz_api.h
@@ -0,0 +1,1381 @@
+/* 
+ * OpenVirtualization: 
+ * For additional details and support contact developer@sierraware.com.
+ * Additional documentation can be found at www.openvirtualization.org
+ * 
+ * Copyright (C) 2011 SierraWare
+ * 
+ * This library is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ * 
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ * 
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ * 
+ * Header file for trustzone API
+ */
+
+#ifndef __OTZ_API_H_
+#define __OTZ_API_H_
+#include <sw_common_types.h>
+#include <sw_list.h>
+
+#define TYPE_UINT_DEFINED 1
+
+typedef unsigned int uint32_t;
+typedef unsigned short uint16_t;
+
+#ifndef _STDINT_H
+typedef char uint8_t;
+#endif
+
+#define MAX_MEMBLOCKS_PER_OPERATION 4
+
+/**
+* @brief Error codes
+*
+*/
+enum otz_error_codes {
+/*!The operation succeeded. */
+    OTZ_SUCCESS = 0x0,             
+/*!The asynchronous operation is still pending. */
+    OTZ_PENDING ,
+/*!Access has been denied, or the item cannot be found.*/
+    OTZ_ERROR_ACCESS_DENIED ,
+/*!The system is busy.*/
+    OTZ_ERROR_BUSY ,
+/*!The execution was cancelled.*/
+    OTZ_ERROR_CANCEL , 
+/*!There is a system communication error.*/
+    OTZ_ERROR_COMMUNICATION ,
+/*!The decoder ran out of data.*/
+    OTZ_ERROR_DECODE_NO_DATA ,
+/*!The decoder hit a type error.*/
+    OTZ_ERROR_DECODE_TYPE ,
+/*!The encoded data is of a bad format.*/
+    OTZ_ERROR_ENCODE_FORMAT , 
+/*!The encoder ran out of memory.*/
+    OTZ_ERROR_ENCODE_MEMORY ,
+/*!An unspecified error has occurred.*/
+    OTZ_ERROR_GENERIC ,
+/*!A bad parameter has been specified.*/
+    OTZ_ERROR_ILLEGAL_ARGUMENT ,
+/*!A state machine has been violated.*/
+    OTZ_ERROR_ILLEGAL_STATE ,
+/*!There is not enough memory to perform the operation.*/
+    OTZ_ERROR_MEMORY ,
+/*!The functionality is not implemented.*/
+    OTZ_ERROR_NOT_IMPLEMENTED ,
+/*!There is a security error.*/
+    OTZ_ERROR_SECURITY ,
+/*!The service has returned an error in the service return code.*/
+    OTZ_ERROR_SERVICE ,
+/*!The input buffer is not long enough.*/
+    OTZ_ERROR_SHORT_BUFFER ,
+/*!The implementation has reached an UNDEFINED condition.*/
+    OTZ_ERROR_UNDEFINED 
+};
+
+/**
+* @brief State machine constants
+*
+*/
+enum otz_state_machine_state_const {
+/*! Structures in the UNDEFINED state may have any value for their state 
+* constant; it may not exist as an explicit value.Clients should never make
+* use of this constant, although an implementation
+* may use it internally for debugging purposes.
+*/
+    OTZ_STATE_UNDEFINED = 0x0,
+/*! The state is in a safe invalid state. */
+    OTZ_STATE_INVALID ,
+/*! The state is open.*/
+    OTZ_STATE_OPEN ,
+/*! The state is closing, but not yet closed.*/
+    OTZ_STATE_CLOSING ,
+/*! The state an operation that is not running and 
+* can accept data to be encoded.
+*/
+    OTZ_STATE_ENCODE ,
+/*! The state of an operation that is not running, but which cannot accept 
+* data to be encoded. This state applies only to close operations.
+*/
+    OTZ_STATE_PERFORMABLE ,
+/*! The state of an operation that is executing synchronously.*/
+    OTZ_STATE_RUNNING ,
+/*! The state of an operation that is executing asynchronously.*/
+    OTZ_STATE_RUNNING_ASYNC ,
+/*! The state of an operation that can have data read using the 
+* decoder functions.
+*/
+    OTZ_STATE_DECODE 
+};
+
+/**
+* @brief Login flag constants
+*
+*
+*/
+enum otz_login_flags {
+/*! No login is to be used.*/
+    OTZ_LOGIN_PUBLIC = 0x0,
+/*! A buffer of client data is to be provided.*/
+    OTZ_LOGIN_CLIENT_DATA ,
+/*! The user executing the application is provided.*/
+    OTZ_LOGIN_USER ,
+/*! The user group executing the application is provided.*/
+    OTZ_LOGIN_GROUP ,
+/*! The name of the application is provided; may include path.*/
+    OTZ_LOGIN_NAME ,
+/*! The digest of the client application is provided.*/
+    OTZ_LOGIN_DIGEST , 
+/*! A utility constant indicating all available login types should be used.*/
+    OTZ_LOGIN_ALL
+};
+
+/**
+* @brief Shared memory flag constants
+*
+*
+*/
+enum otz_shared_mem_flags {
+/*! Service can only read from the memory block.*/
+    OTZ_MEM_SERVICE_RO = 0x0,
+/*! Service can only write from the memory block.*/
+    OTZ_MEM_SERVICE_WO ,
+/*! Service can read and write from the memory block.*/
+    OTZ_MEM_SERVICE_RW,
+/*! Invalid flag */
+    OTZ_MEM_SERVICE_UNDEFINED
+};
+
+/**
+* @brief Operation type constants
+*
+*/
+enum otz_type_of_operation {
+/*! Open operation */
+    OTZ_OPERATION_OPEN = 0x0,
+/*! Invoke operation */
+    OTZ_OPERATION_INVOKE ,
+/*! Close operation */
+    OTZ_OPERATION_CLOSE ,
+/*! No operation will be performed */
+    OTZ_OPERATION_NONE
+};
+
+/**
+* @brief Param type constants
+*
+*/
+enum otz_param_type {
+/*! In parameter for read operations. */
+    OTZ_PARAM_IN = 0x0,
+/*! Out parameter for write operations. */
+    OTZ_PARAM_OUT
+};
+
+/**
+* @brief Decode type constants
+*
+*/
+enum otz_decode_type {
+/*! There is no more data in the decode stream. */
+    OTZ_TYPE_NONE = 0x0,
+/*! The next data type in the stream is a uint32_t. */
+    OTZ_TYPE_UINT32,
+/*! The next data type in the stream is an array. */
+    OTZ_TYPE_ARRAY
+};
+
+typedef uint32_t otz_return_t;
+typedef uint32_t otz_state_t;
+
+/* Trust zone client API */
+
+/**
+* @brief Universally Unique IDentifier (UUID) type as defined in 
+* [RFC4122].A
+*
+* UUID is the mechanism by which a service is identified.
+*/
+typedef struct otz_uuid_t
+{
+    uint32_t ui_time_low;
+    uint32_t ui_time_mid;
+    uint16_t ui_time_hi_and_version;
+    uint8_t  aui_clock_seq_and_node[8];
+}otz_uuid_t;
+
+/**
+* @brief Login credentials to be provided to the service
+*
+*/
+typedef struct otz_login_t
+{
+/*! Bit field specifying which login credentials must 
+* be provided to the service. This must be one of the following options:\n
+* OTZ_LOGIN_PUBLIC: no credentials are provided.\n
+* OR\n
+* One or more of the following flags:\n
+* OTZ_LOGIN_CLIENT_DATA: supply the client buffer specified by pBuff and
+*  uiBuffLen.\n
+* OTZ_LOGIN_USER: supply the identity of the “user” executing the
+* client.\n
+* OTZ_LOGIN_GROUP: supply the identity of the “group” executing the
+* client.\n
+* OTZ_LOGIN_NAME: supply the “name” of the client executable. This may
+* include path information to strengthen the differentiation between
+* executables with the same name.\n
+* OTZ_LOGIN_DIGEST: supply the cryptographic “digest” of the currently 
+* running client process to the service. This enables the service to 
+* compare the digest with a known good value to ensure that the client 
+* has not been tampered with. \n
+* OR \n
+* OTZ_LOGIN_ALL: A utility constant which indicates that all of the available
+* login flags have been specified.
+*/
+    uint32_t ui_type; 
+
+/*! Buffer of login information sent to the service when the
+* OTZ_LOGIN_CLIENT_DATA login flag is specified. The required content of this
+* buffer is defined by the client-service protocol defined by the service that
+* the client is attempting to connect to.
+*/
+    void*   p_buff; 
+
+/*!
+The length of the buffer in bytes. This field should be zero if
+* p_buff is NULL.
+*/
+    uint32_t ui_buff_len;
+}otz_login_t;
+
+/**
+* @brief 
+*/
+typedef struct {
+	uint32_t objectType;
+	uint32_t objectSize;
+	uint32_t maxObjectSize;
+	uint32_t objectUsage;
+	uint32_t dataSize;
+	uint32_t dataPosition;
+	uint32_t handleFlags;
+} TEE_ObjectInfo;
+
+/**
+ * @brief 
+ */
+typedef struct {
+	uint32_t attributeID;
+	union {
+	struct {
+	void* buffer; size_t length;
+	} ref;
+	struct
+	{
+	uint32_t a, b;
+	} value;
+	} content;
+} TEE_Attribute;
+
+
+/**
+ *
+ * @brief opaque structure definition for an object handle.
+ *        TODO - Fill it with something appropriate
+ */
+struct __TEE_ObjectHandle {
+	void* dataPtr;
+	uint32_t dataLen;
+	uint8_t dataName[255];
+	TEE_ObjectInfo *ObjectInfo;
+	TEE_Attribute *Attribute;
+	uint32_t attributesLen;
+
+};
+typedef struct __TEE_ObjectHandle TEE_ObjectHandle;
+/**
+* @brief Name value pairs
+*
+*/
+typedef struct otz_property_t
+{
+/*! The numeric namespace of properties. */
+    uint32_t ui_namespace;
+/*! The numeric name of the property. */
+    uint32_t ui_name;
+/*! A binary buffer of containing the property value. The content of this
+* buffer is defined by the specification of the property that is loaded.
+*/
+    void*    p_value;
+/*! The length of the binary buffer in bytes, or zero if pValue is NULL */
+    uint32_t ui_length;
+}otz_property_t;
+
+/* Lists the functions exposed to the client by the system or service */
+/**
+* @brief Service property 
+*
+*/
+
+typedef struct otz_property_name_t
+{
+/*! The numeric namespace of properties. */
+    uint32_t ui_namespace;
+/*! The numeric name of the property. */
+    uint32_t ui_name;
+}otz_property_name_t;
+
+/**
+* @brief Absolute time since an arbitary origin.
+*
+*
+*/
+typedef struct otz_timelimit_t otz_timelimit_t; /*Implementation Defined */
+
+
+/**
+ * @brief 
+ */
+typedef struct otz_operation_t otz_operation_t;
+/**
+ * @brief 
+ */
+typedef struct otz_session_t otz_session_t;
+/**
+ * @brief 
+ */
+typedef struct otz_device_t otz_device_t;
+/**
+ * @brief 
+ */
+typedef struct otz_shared_mem_t otz_shared_mem_t;
+
+/**
+* @brief Encoder and decoder state
+*
+*/
+struct otz_enc_dec_t
+{
+    int cmd_id;             /*!< Command id */
+    int encode_id;          /*!< Identifier for encode or decode operations */
+    int enc_error_state;    /*!< Error value of last encoded operation */
+    int dec_error_state;    /*!< Error value of last decoded operation */
+};
+
+/**
+* @brief Shared memory reference 
+*
+*/
+struct otz_mem_reference
+{
+/*! Shared memory context */
+    void            *shared_mem;
+/*! Offset from the allocated Shared memory for reference */
+    uint32_t        offset;
+/*! Shared memory reference length */
+    uint32_t        length;
+/*! In or out parameter */
+    int             param_type;
+};
+
+/**
+* @brief The otz_operation_t structure is used to contain control information
+* related to an operation that is to be invoked with the security environment.
+*
+*/
+struct otz_operation_t
+{
+/*! State of the operation */
+    otz_state_t ui_state;
+/*! Session context*/
+    otz_session_t* session;
+/*! Type of operation*/
+    uint32_t type;
+/*! Session id for the operation*/
+    int session_id;
+/*! Encoder and decoder state*/    
+    struct otz_enc_dec_t enc_dec;
+/*! Shared memory referred during this operation*/    
+    struct otz_mem_reference shared_mem[MAX_MEMBLOCKS_PER_OPERATION];
+/*! Shared memory referred count*/
+    int shared_mem_ref_count;
+/*! Temporary shared memory referred during this operation*/
+    struct otz_mem_reference temp_mem[MAX_MEMBLOCKS_PER_OPERATION];
+/*! Temporary shared memory referred count*/
+    int temp_mem_ref_count;
+/*! Error number from the client driver*/
+    int s_errno;
+/*! Implementation defined structure */
+    /*struct {
+    }s_imp;*/ /* Implementation Defined */
+
+};
+
+/**
+* @brief The otz_session_t structure is used to contain control information
+* related to a session between a client and a service.
+*
+*/
+struct otz_session_t
+{
+/*! State of the session */
+    otz_state_t ui_state;
+/*! Reference count of operations*/
+    int operation_count;
+/*! Session id obtained for the  service*/
+    int session_id;
+/*! Unique service id */
+    int service_id;
+/*! Shared memory counter which got created for this session */
+    uint32_t shared_mem_cnt;    
+/*! Device context */
+    otz_device_t* device;
+/*! Shared memory list */
+    struct list shared_mem_list;
+/*! Implementation defined structure */
+    /*struct {
+    }s_imp;*/ /* Implementation Defined */
+
+};
+
+/**
+* @brief The otz_device_t structure is used to contain control information
+* related to the device
+*
+*/
+struct otz_device_t
+{ 
+/*! State of the device */
+    otz_state_t ui_state;
+/*! Device identifier */
+    uint32_t fd;
+/*! Sessions count of the device*/
+    int session_count;
+/*! Error number from the client driver*/
+    int s_errno;
+/*! Implementation defined */
+    /*struct {
+    }s_imp;*/ /* Implementation Defined */
+};
+
+/**
+* @brief The otz_shared_memory_t structure is used to contain control information
+* related to a block of shared memory that is mapped between the client and the
+* service.
+*
+*/
+
+struct otz_shared_mem_t
+{
+/*! he state of this structure. For shared memory only the following
+* states are used: \n
+*   OTZ_STATE_INVALID: Shared memory block is not valid, but in a known state 
+*   which can be freed. \n
+*   OTZ_STATE_OPEN: Shared memory block is valid and references to it can be
+* encoded in structured messages.\n
+*   OTZ_STATE_UNDEFINED: Pseudo state covering all other behavior. A structure in
+* this state must not be used unless explicitly specified, otherwise UNDEFINED
+* behavior may occur 
+*/
+    otz_state_t ui_state;
+/*! The length of the shared memory block in bytes. Should not be zero */
+    uint32_t ui_length;
+/*! The sharing flags of the shared memory block, indicating direction of
+* data sharing. \n
+* Note that these access flags cannot usually be enforced by the hardware. If a
+* client or a service ignores the flags specified for a shared memory block, or
+* a corresponding memory reference, UNDEFINED behavior results. \n
+*  Exactly one of the following flags must be specified:\n
+*  OTZ_MEM_SERVICE_RO: The service can only read from the memory block.\n
+*  OTZ_MEM_SERVICE_WO: The service can only write to the memory block.\n
+*  OTZ_MEM_SERVICE_RW: The service can both read from and write to the memory
+*  block.
+*/
+    uint32_t ui_flags;
+/*! The pointer to the block of shared memory. */
+    void*   p_block;
+/*! Session context */
+    otz_session_t* session;
+/*! Session identifier */
+    int session_id;
+/*! Operation count */
+    int operation_count;
+/*! Service error number */
+    int s_errno;
+/*! List head used by Session */
+    struct list head_ref;
+/*! Implementation defined structure */
+    /*struct {
+    }s_imp;*/ /* Implementation Defined */
+};
+
+
+
+/**
+* @brief Open the device
+*
+* This function opens a connection with the device in the underlying operating
+* environment that represents the secure environment. When the client no longer
+* requires the device it must call otz_device_close to close the connection and
+* free any associated resources. This function accepts a pointer to a
+* otz_device_t structure assumed to be in the OTZ_STATE_UNDEFINED state. On
+* success this function must set the device structure *ps_device to the state
+* OTZ_STATE_OPEN with a session count of zero. On failure, the device is set to
+* the state OTZ_STATE_INVALID. It is possible to create multiple concurrent
+* device connections from a single client. The number of devices that can be
+* supported globally within the entire system, or locally within a single
+* client, is implementation-defined.
+* 
+* Undefined Behavior:
+*  The following situations result in UNDEFINED behavior: \n
+*  Calling with device set to NULL. \n
+*
+* @param pk_device_name: An implementation-defined binary buffer, used to
+* identify the underlying device to connect to. If this is NULL, the
+* implementation will use an internally defined default device name.
+* 
+* @param pk_init: An implementation-defined binary block used to configure the
+* implementation. If this is NULL, the implementation will use predefined
+* default values for the library configuration
+*
+* @param ps_device: A pointer to the device structure.
+*
+* @return otz_return_t:
+* OTZ_SUCCESS: The device was successfully opened. \n
+* OTZ_ERROR_*: An implementation-defined error code for any other error.
+*
+*
+*/
+otz_return_t otz_device_open(void const* pk_device_name, void const* pk_init,
+                            otz_device_t* ps_device);
+
+/**
+* @brief Get local time limit
+*
+* Calling this function generates a device-local absolute time limit in the
+* structure pointed to by ps_time_limit  from a timeout value ui_timeout. 
+* The absolute time limit is equal to the  current time plus 
+* the specified timeout.
+* 
+* Undefined Behavior:
+* The following situations result in UNDEFINED behavior: \n
+*      Calling with device set to NULL.\n
+*      Calling with device pointing to a device in the state OTZ_STATE_INVALID.\n
+*      Calling with time_limit set to NULL. \n
+*      Use of the time limit outside of the device in which it was created.\n
+* @param ps_device: A pointer to the device
+* @param ui_timeout: The required relative timeout, in milliseconds.
+* @param ps_timelimit: A pointer to the time limit structure to populate.
+*
+* @return 
+* OTZ_SUCCESS: the time limit was created successfully.\n
+* OTZ_ERROR_*: an implementation-defined error code for any other error.
+*
+*/
+otz_return_t otz_device_get_timelimit(otz_device_t* ps_device,
+                                    uint32_t ui_timeout,
+                                    otz_timelimit_t* ps_timelimit);
+
+/**
+* @brief Prepare open operation
+*
+* This function is responsible for locally preparing an operation that can be
+* used to connect with the service  defined by the UUID 
+* pointed to by pks_service, using the timeout pointed to by
+* pks_time_limit and the login credentials specified in pks_login.\n
+*
+* This function accepts a session and an operation structure assumed to be in
+* the state OTZ_STATE_UNDEFINED.\n
+* 
+* When this function returns OTZ_SUCCESS it must increment the session count of
+* the device. The count may subsequently need to be decremented by the 
+* otz_operation_release function –  releasing this operation if the
+* corresponding perform operation failed or was never executed.\n
+*
+* When this function returns OTZ_SUCCESS the operation is set to the state
+* OTZ_STATE_ENCODE; this state allows the client to encode a 
+* message to be exchanged with the service using the encoder 
+* functions of the OTZ_API. Once the message has been encoded 
+* the client must call the function otz_operation_perform, or the
+* asynchronous equivalent, to issue the open session command to the security
+* environment.\n
+*
+* When this function returns OTZ_SUCCESS the session must be in the state
+* OTZ_STATE_INVALID. The state transitions to OTZ_STATE_OPEN after the perform 
+* function related to the open  session operation has returned
+* * OTZ_SUCCESS; only at this point does the session become usable. If the perform
+* function returns any error code,
+* the session is not opened and remains in the state OTZ_STATE_INVALID.\n
+*
+* When this function fails it can return any error code. In these conditions,
+* the state of the device must be  unchanged, 
+* including the session count. The state of the session is OTZ_STATE_UNDEFINED 
+* and the operation  must be set to OTZ_STATE_INVALID.\n
+*
+* Note that if the perform function fails, the client must still call
+* otz_operation_release to release resources
+* associated with the operation. \n
+*
+* Undefined Behavior:\n
+* The following situations result in UNDEFINED behavior:\n
+*     Calling with device set to NULL.\n
+*     Calling with device pointing to a device in the state OTZ_STATE_INVALID.\n
+*     Calling with service set to NULL.\n
+*     Calling with session set to NULL.\n
+*     Calling with operation set to NULL.\n
+*
+* @param ps_device: A pointer to the device.
+* @param pks_service: A pointer to the service UUID.
+* @param pks_login: A pointer to the login control structure, or NULL.
+* @param pks_timelimit: A pointer to the time limit, or NULL.
+* @param ps_session: A pointer to the session.
+* @param ps_operation: A pointer to the operation.
+*
+* @return 
+* OTZ_SUCCESS: The operation has been prepared successfully.\n
+* OTZ_ERROR_*: An implementation-defined error code for any other error.\n
+*
+*
+*/
+otz_return_t otz_operation_prepare_open(otz_device_t* ps_device,
+/*                                      otz_uuid_t const* pks_service, */
+                                      int pks_service,
+                                      otz_login_t const* pks_login,
+                                      otz_timelimit_t const* pks_timelimit,
+                                      otz_session_t* ps_session,
+                                      otz_operation_t* ps_operation );
+
+/**
+* @brief Prepare operation for service request
+*
+* This function is responsible for locally preparing an operation that can be
+* used to issue a command to a service  with which the client has 
+* already created a session.
+*
+* This function accepts an operation assumed to be in the state
+* OTZ_STATE_UNDEFINED.
+*
+* When this function returns OTZ_SUCCESS the operation is set to the state
+* OTZ_STATE_ENCODE; this state allows
+* the client to encode a message to be exchanged with the service using the
+* encoder functions of the OTZ_API.  Once the message has been encoded the client 
+* must call the function  otz_operation_perform, or the asynchronous equivalent, 
+* to issue the command to the service.
+*
+* When this function fails it can return any error code. In these conditions the
+* state of the session must be unchanged, 
+* including the operation count. The state the operation must be set
+* to the state OTZ_STATE_INVALID.
+*
+* The pks_time_limit parameter defines the absolute time by which the operation
+* must be complete, after which the implementation should attempt to cancel it. 
+* This parameter may be NULL which implies no timeout it used.
+*
+* Note that if the perform function fails the client must still call
+* otz_operation_release to release resources associated with the operation.\n
+*
+* Undefined Behavior\n
+* The following situations result in UNDEFINED behavior:\n
+*    Calling with session set to NULL.\n
+*    Calling with session pointing to a session in a state other than 
+*    OTZ_STATE_OPEN.\n
+*    Calling with operation set to NULL.\n
+*
+* @param ps_session: A pointer to the open session.
+* @param ui_command: The identifier of the command to execute, defined by the
+* client-service protocol.
+* @param pks_timelimit: A pointer to the time limit, or NULL.
+* @param ps_operation: A pointer to the operation.
+*
+* @return
+* OTZ_SUCCESS: The operation has been prepared successfully.\n
+* OTZ_ERROR_*: An implementation-defined error code for any other error.\n
+*
+*/
+otz_return_t otz_operation_prepare_invoke(otz_session_t* ps_session,
+                                        uint32_t ui_command,
+                                        otz_timelimit_t const* pks_timelimit,
+                                        otz_operation_t* ps_operation);
+
+/**
+* @brief Performs the previously prepared operation
+*
+* This function performs a previously prepared operation – issuing it to the
+* secure environment.\n
+* There are three kinds of operations that can be issued: opening a client
+* session, invoking a service command,
+* and closing a client session. Each type of operation is prepared with its
+* respective function, which returns the
+* operation structure to be used:\n
+*    otz_operation_prepare_open prepares an open session operation.\n
+*    otz_operation_prepare_invoke prepares an invoke service command operation.\n
+*    otz_operation_prepare_close prepares a close session operation.\n
+* 
+* When calling this function, the operation must be in the state OTZ_STATE_ENCODE
+* or OTZ_STATE_PERFORMABLE.\n
+*
+* For operations that support a structured message it is not required that a
+* message has actually been encoded  by the client. 
+* Once this function has been called, the state transitions to
+* OTZ_STATE_RUNNING and it is no longer possible to use to the 
+* encoder functions on the operation.\n
+*
+* If an error is detected by the system before the operation reaches the
+* service, then an error code is returned by otz_operation_perform and 
+* the value OTZ_ERROR_GENERIC is assigned to *pui_service_return. 
+* In this case the operation will be in the state OTZ_STATE_INVALID 
+* when the function returns and the decoder functions cannot be
+* used on the operation.\n
+*
+* The most common causes for an error occurring before the command reaches the
+* service are:\n
+*  The encoder ran out of space – error returned is OTZ_ERROR_ENCODE_MEMORY.\n
+*  The service does not exist – error returned is OTZ_ERROR_ACCESS_DENIED.\n
+*  The system rejects a new session due to bad login credentials – error
+*  return is OTZ_ERROR_ACCESS_DENIED.\n
+*  The operation has timed out, or been cancelled; error return is
+*  OTZ_ERROR_CANCEL.\n
+*  The secure environment is busy or low on resource and cannot handle 
+*  the request.\n
+*
+*  For open and invoke operations, if the operation reaches the service, but the
+*  service returns an error, then otz_operation_perform 
+*  returns OTZ_ERROR_SERVICE. The error code from the service
+*  is assigned to  *pui_service_return. \n
+*
+*  Unlike the case where a system error occurs, the service
+*  can return a message: the operation transitions to the 
+*  state OTZ_STATE_DECODE and the decoder functions can be used.\n
+*
+*  For open and invoke operations, if the operation succeeds then
+*  otz_operation_perform returns OTZ_SUCCESS and
+*  the value OTZ_SUCCESS is also assigned to *pui_service_return. The operation
+*  transitions to the state OTZ_STATE_DECODE and the client can use the decoder 
+*  functions to retrieve the message, if present, from the service.\n
+*  
+*  For close operations the service cannot return a structured message, and the
+*  operation will always transition to OTZ_STATE_INVALID. 
+*  The decoder functions cannot be used on a close operation.
+*  A close operation cannot be performed while the session has other operations 
+*  open, or has allocated shared memory blocks – this results in
+*  UNDEFINED behavior.\n
+*  
+*  Regardless of the success or failure of the function the client code must
+*  always call otz_operation_release to
+*  release any resources used by the operation.\n
+*  Undefined Behavior:\n
+*  The following situations result in UNDEFINED behavior:\n
+*   Calling with operation set to NULL.\n
+*   Calling with operation pointing to an operation not in the state 
+*       OTZ_STATE_ENCODE.\n
+*   Calling with operation pointing to a close operation, where the session 
+*       being closed still has other operations open, or has allocated 
+*       shared memory blocks.\n
+*       Calling with service_return set to NULL.
+*
+* @param ps_operation: A pointer to the operation.
+* @param pui_service_return: A pointer to the variable that will contain the
+* service return code.
+*
+* @return 
+* OTZ_SUCCESS: The operation was executed successfully.\n
+* OTZ_ERROR_ENCODE_MEMORY: The encoder is in an error condition – it ran out of
+* memory space.\n
+* OTZ_ERROR_ACCESS_DENIED: The service was not found or the client was not
+* authorized to access it.\n
+* OTZ_ERROR_SERVICE: The service itself threw an error, which can be found in
+* *pui_service_return.\n
+* OTZ_ERROR_CANCEL: The operation timed out, or was explicitly cancelled.\n
+* OTZ_ERROR_*: An implementation-defined error code for any other error.
+*
+*/
+otz_return_t otz_operation_perform(otz_operation_t* ps_operation,
+                                 otz_return_t* pui_service_return);
+
+/**
+* @brief Release operation
+*
+* This function releases an operation, freeing any associated resources.
+* The behavior of this function varies slightly depending on the state of the
+* operation:\n
+*     OTZ_STATE_ENCODE or OTZ_STATE_PERFORMABLE: The operation has not been issued
+* to the system, and is destroyed without being issued. 
+* In this case it may be required to unwind some of the state change made to 
+* related structures, for example if the operation is a session closure 
+* the session state must transition back to OTZ_STATE_OPEN.\n     
+*     OTZ_STATE_DECODE: The operation has been issued to the system and a
+* response has been returned.
+* After destroying an operation in this state, any messages in its 
+* decoder are lost, including unread entries and arrays that have been 
+* decoded by reference. If the client needs to keep any data from the message
+* it must copy it out of the decoder owned memory before calling this
+* function.\n
+*   OTZ_STATE_INVALID: This function does nothing.
+* 
+* After this function returns the operation must be considered to be
+* in the state OTZ_STATE_UNDEFINED.\n
+*
+* Undefined Behavior:\n
+* The following situations result in UNDEFINED behavior:\n
+*   Calling with operation set to NULL.\n
+*   Calling with operation pointing to an operation in a state other than 
+*       OTZ_STATE_ENCODE, OTZ_STATE_PERFORMABLE, OTZ_STATE_DECODE or 
+*       OTZ_STATE_INVALID.
+*
+* @param ps_operation: A pointer to the operation to release.
+*
+*
+*/
+void otz_operation_release(otz_operation_t* ps_operation);
+
+/**
+* @brief Prepare the operation for close session 
+*
+* This function is responsible for locally preparing an operation that can be
+* used to close a session between the client and a service.
+*
+* This function accepts an operation assumed to be in the state
+* OTZ_STATE_UNDEFINED.
+*
+* When this function returns OTZ_SUCCESS the state of the session is changed to
+* OTZ_STATE_CLOSING. In this state any operation still running or shared memory 
+* block still allocated can stillbe used, but it is not possible to create
+* new shared memory blocks or prepare new operations within the session. If this
+* operation is never issued, otz_operation_release must transition 
+* the session state back to OTZ_STATE_OPEN.
+*
+* Note that performing a close operation while other operations exist with a
+* session, or while shared memory blocks are still allocated within it, 
+* results in UNDEFINED behavior.
+*
+* When this function returns OTZ_SUCCESS the operation is set to the state
+* OTZ_STATE_PERFORMABLE; this state allows the client to perform the close 
+* operation, but not to encode a message to be exchanged with the service.
+* The client must call the function otz_operation_perform, or the asynchronous
+* equivalent, to issue the operation to the security environment.
+*
+* When this function fails it can return any error code. In these conditions the
+* state of the session must be unchanged, including the operation count. 
+* The state the operation must be set to OTZ_STATE_INVALID.
+*
+* Note that the perform operation for a session closure cannot be canceled or
+* timed-out by the client. When otz_operation_perform completes, 
+* whether with success or failure, the session is considered closed.
+* 
+* On failure of the perform function the client must still call
+* otz_operation_release to release resources associated
+* with the operation.
+*
+* Undefined Behavior\n
+* The following situations result in UNDEFINED behavior:\n
+*    Calling with session set to NULL.\n
+*    Calling with session pointing to a session in a state other than 
+*       OTZ_STATE_OPEN.\n
+*    Calling with operation set to NULL.
+*
+* @param ps_session: A pointer to session.
+* @param ps_operation: A pointer to the operation.
+*
+* @return 
+* OTZ_SUCCESS: The operation has been prepared successfully.\n
+* OTZ_ERROR_*: An implementation-defined error code for any other error.\n
+
+*/
+otz_return_t otz_operation_prepare_close(otz_session_t* ps_session,
+                                       otz_operation_t* ps_operation);
+
+/**
+* @brief Close the device connection
+* 
+* This function closes a connection with a device, freeing any associated
+* resources.
+* If the passed device is in the state OTZ_STATE_INVALID this function must set
+* to the state to OTZ_STATE_UNDEFINED and return OTZ_SUCCESS.
+*
+* If the passed device is in the state OTZ_STATE_OPEN with a session count of
+* zero this function must delete the device. This operation cannot fail; 
+* the function must always set the state to OTZ_STATE_UNDEFINED and return
+* OTZ_SUCCESS.
+*
+* If the passed device is in the state OTZ_STATE_OPEN with a non-zero session
+* count, this function must return OTZ_ERROR_ILLEGAL_STATE 
+* and leave the device unmodified.
+*
+* Undefined Behavior\n
+* The following situations result in UNDEFINED behavior:\n
+*    Calling with device set to NULL.\n
+*
+* @param ps_device: A pointer to the device to delete.
+*
+* @return 
+* OTZ_SUCCESS: The device is successfully closed.\n
+* OTZ_ERROR_ILLEGAL_STATE: The device is in the state OTZ_STATE_OPEN and has a
+* non-zero session count.\n
+* OTZ_ERROR_*: An implementation-defined error code for any other error.\n*
+*/
+otz_return_t otz_device_close(otz_device_t* ps_device);
+
+
+/**
+* @brief This function allocates a block of memory, defined by the structure
+* pointed to by ps_shared_mem, which is shared 
+* between the client and the service it is connected to.
+*
+* This function allocates a block of memory, defined by the structure pointed to
+* by ps_shared_mem, which is shared
+* between the client and the service it is connected to.
+*
+* Once a block is allocated, the client and the service can exchange references
+* to the allocated block in messages encoded using structured messages. 
+* Depending on the implementation of the secure environment, this may
+* allow the service to directly access this block of memory without the need for
+* a copy; this allows for high-bandwidth non-structured communications.
+*
+* On entry to this function the session must be in the state OTZ_STATE_OPEN.
+*
+* On entry to this function the fields ui_flags and ui_length of the 
+* shared memory structure must have been  filled in with the required values. 
+* Other fields of the shared memory structure have UNDEFINED state on entry to
+* this function and are filled in by the time the function returns.
+*
+* If this function returns OTZ_SUCCESS, the value ps_shared_mem->p_block will
+* contain the address of the shared
+* memory allocation and the shared memory structure will be in the state
+* OTZ_STATE_OPEN. The implementation  must guarantee that the 
+* returned buffer allocation is aligned on an 8-byte address boundary.
+*
+* If this function returns any other value, the state of the structure is
+* OTZ_STATE_INVALID and ps_shared_mem->p_block will be NULL.
+*
+* After successful allocation of a block the client may subsequently pass the
+* shared memory structure to the
+* function otz_encode_memory_reference to create a reference to a portion of the
+* block.
+*
+* Blocks are flagged with the intended direction of data flow, as described by
+* the ps_shared_mem->ui_flags parameter. If an attempt is later made to encode 
+* a memory reference with incompatible sharing attributes an
+* encoder error is thrown when the operation is performed.
+*
+* The structure must be passed to the function otz_shared_memory_release when the
+* block is no longer needed
+*
+* Undefined Behavior :\n
+* The following situations result in UNDEFINED behavior:\n
+*       Calling with session set to NULL.\n
+*       Calling with session in a state other than OTZ_STATE_OPEN.\n
+*       Calling with shared_mem set to NULL.\n
+*       Calling with shared_mem->flags set to an invalid set of flags.\n
+*       Calling with shared_mem->length set to 0.\n
+*
+* @param ps_session: A pointer to the session.
+* @param ps_shared_mem: A pointer to the shared memory block structure.
+*
+* @return 
+* OTZ_SUCCESS: the memory was allocated successfully.\n
+* OTZ_ERROR_MEMORY: there is not enough memory to meet the allocation request.\n
+* OTZ_ERROR_*: an implementation-defined error code for any other error.\n
+*/
+otz_return_t otz_shared_memory_allocate(otz_session_t* ps_session ,
+                                        otz_shared_mem_t* ps_shared_mem);
+
+/**
+* @brief This function allocates a block of memory, defined by the structure
+* pointed to by ps_shared_mem, which is shared
+* between the client and the service it is connected to.
+* This function marks a block of shared memory associated with a session as 
+* no longer shared.
+*
+* If the input shared memory structure is in the state OTZ_STATE_INVALID 
+* this function does nothing, otherwise it frees the memory block. 
+* The caller must not access the memory buffer after calling this function.
+*
+* The shared memory structure returned by this function will be in the state 
+* OTZ_STATE_UNDEFINED.
+*
+* When this function is called, the shared memory block must not be referenced 
+* by any operation, otherwise UNDEFINED behavior will occur.
+*
+* Note that shared memory blocks must always be freed by calling this function; 
+* all memory blocks must be freed before a session can closed.
+*
+* Undefined Behavior\n
+* The following situations result in UNDEFINED behavior:\n
+*   Calling with shared_mem set to NULL.\n
+*   Calling with shared_mem pointing to a shared memory block that is still 
+*       referenced by an operation.
+*  
+* @param ps_shared_mem - A pointer to the shared memory block to free.
+*/
+void otz_shared_memory_release(otz_shared_mem_t* ps_shared_mem);
+
+/**
+* @brief Encode unsigned 32-bit integer
+*
+* Calling this function appends the value of the passed uint32_t, pk_data, 
+* to the end of the encoded message.
+*
+* This function can only be called when the operation is in the 
+* state OTZ_STATE_ENCODE. This occurs after the operation has been prepared, 
+* but before it has been performed.
+*
+* If an error occurs, for example if there is no more space in the 
+* encoder buffer, this function sets the error state of the encoder.
+*
+* This function does nothing if the error state of the encoder is 
+* already set upon entry.
+*
+* Undefined Behavior\n
+* The following situations result in UNDEFINED behavior:\n
+*   Calling with operation set to NULL.\n
+*   Calling with operation pointing to an operation in a state other 
+*       than OTZ_STATE_ENCODE.
+*
+* @param ps_operation - A pointer to the operation for which we are encoding.
+* @param data - The value to encode in the buffer.
+* @param param_type - In or out 
+*/
+void otz_encode_uint32( otz_operation_t* ps_operation,  
+                        void const* data, 
+                        int param_type);
+
+/**
+* @brief Encode binary array to the encoded message
+*
+* Calling this function appends a binary array pointed to by array and of length
+* length bytes to the end ofthe encoded message. The implementation must 
+* guarantee that when decoding the array in the service the base pointer 
+* is eight byte aligned to enable any basic C data structure to be 
+* exchanged using this method.
+*
+* It is valid behavior to encode a zero length array, where array is not NULL 
+* but uiLength is 0, and a NULL array, where array is NULL and length is zero, 
+* using this function.
+*
+* This function can only be called when the operation is in the state 
+* OTZ_STATE_ENCODE. This occurs after the operation has been prepared, 
+* but before it has been performed.
+*
+* If an error occurs, for example if there is no more space in the encoder 
+* buffer, this function sets the error state of the encoder.
+*
+* This function does nothing if the error state of the encoder is already 
+* set upon entry.
+*
+* Undefined Behavior\n
+* The following situations result in UNDEFINED behavior:\n
+*   Calling with operation set to NULL.\n
+*   Calling with operation pointing to an operation in a state other than 
+*       OTZ_STATE_ENCODE.\n
+*   Calling with array set to NULL when length is a length other than 0.
+*
+* Output\n
+* This function may set the state of the encoder to OTZ_ERROR_ENCODE_MEMORY 
+* if there is insufficient space to encode the array.
+*
+* @param ps_operation - A pointer to the operation for which we are encoding.
+* @param pk_array - A pointer to the binary buffer to encode.
+* @param length - The length of the binary buffer in bytes.
+* @param param_type - In or out data 
+*/
+void otz_encode_array( otz_operation_t* ps_operation,  
+                        void const* pk_array, 
+                        uint32_t length, 
+                        int param_type);
+
+/**
+* @brief Encode empty binary array to the encoded message
+*
+* Calling this function appends an empty binary array of length "length" bytes 
+* to the end of the encoded message and returns the pointer to this array 
+* to the client. This allows an implementation with fewer copies, as
+* the encoder buffer can be filled directly by the client without needing a 
+* copy from an intermediate buffer into the real encoder buffer.
+*
+* The implementation must guarantee that the returned buffer allocation is 
+* aligned on an eight byte boundary, enabling direct sharing of any C data type 
+* in accordance with the ARM Application Binary Interface [ARM IHI
+* 0036A].
+*
+* It is valid behavior to allocate space for a zero length array in the 
+* encoder stream. This will return a pointer that is not NULL, 
+* but this pointer must never be dereferenced by the client code or UNDEFINED 
+* behavior may result.
+*
+* This function can only be called when the operation is in the state 
+* OTZ_STATE_ENCODE. This occurs after the operation has been prepared, 
+* but before it has been performed. Once the operation transitions out of the 
+* state OTZ_STATE_ENCODE, which occurs if the operation is performed or 
+* is released, then the client must no longer access this buffer or 
+* UNDEFINED behavior may result.
+*
+* If an error occurs, for example if there is no more space in the 
+* encoder buffer, this function sets the error state of the encoder and 
+* returns NULL.
+*
+* This function does nothing if the error state of the encoder is already 
+* set upon entry, and will return NULL.
+*
+* Undefined Behavior\n
+* The following situations result in UNDEFINED behavior:\n
+*   Calling with operation set to NULL.\n
+*   Calling with operation pointing to an operation in a state other 
+*       than OTZ_STATE_ENCODE.
+*
+* Output\n
+* This function may set the state of the encoder to OTZ_ERROR_ENCODE_MEMORY 
+* if there is insufficient space to encode the array space.
+*
+* @param ps_operation - A pointer to the operation for which we are encoding.
+* @param length - The length of the desired binary buffer in bytes.
+* @param param_type - In or Out data
+*
+* @return  - A pointer to the buffer, or NULL upon error.
+*/
+void* otz_encode_array_space( otz_operation_t* ps_operation,  
+                        uint32_t length,
+                        int param_type);
+
+
+
+/**
+* @brief Appends a reference of previously allocated shared block to the encoded
+* buffer
+*
+* Calling this function appends a reference to a range of a previously created 
+* shared memory block.
+*
+* Memory references are used to provide a synchronization token protocol which 
+* informs the service when it can read from or write to a portion of the shared 
+* memory block. A memory reference is associated with a specific operation and 
+* is valid only during the execution of that operation.
+*
+* When the otz_encode_memory_reference function completes successfully the 
+* shared memory block is said to be “referenced”. This reference is destroyed 
+* when the operation perform function completes (with or without an error). 
+* If the operation is never performed for any reason, the reference is destroyed
+* when the operation is released. A shared memory block cannot be released 
+* while is it still referenced in an operation. Once a memory reference 
+* has been created the client must not read from, or write to, 
+* the referenced range until the reference is destroyed.
+*
+* Some implementations of the secure environment may not be able to implement 
+* genuine shared memory and/or may make use of device hardware 
+* outside of the core. In these cases the system may require data copies or
+* cache maintenance operations to ensure visibility of the data in a 
+* coherent manner. For this reason the memory reference is marked with a 
+* number of flags which can be used to ensure the correct copies and cache
+* maintenance operations occur. Primarily these indicate the memory operations 
+* that the service is allowed to perform. 
+* Exactly one of the following flags must be specified:
+*
+* OTZ_MEM_SERVICE_RO: The service can only read from the memory block.\n
+* OTZ_MEM_SERVICE_WO: The service can only write to the memory block.\n
+* OTZ_MEM_SERVICE_RW: The service can both read from and write to the 
+* memory block.
+*
+* These flags must be a sub-set of the service permissions specified 
+* when the block was created using otz_shared_memory_allocate, 
+* otherwise the encoder error OTZ_ERROR_ENCODE_FORMAT will be raised.
+*
+* If an error occurs, for example if there no more space in the encoder buffer 
+* or the range lies outside of the memory block, this function sets 
+* the error state of the encoder. Additionally, there is a restriction 
+* whereby the client cannot have multiple concurrent references to any address 
+* in the memory block. Attempting to write a memory reference that overlaps an 
+* existing one will result in the encoder entering an error state. 
+* In any of these cases the shared memory block is not referenced by 
+* calling this function.
+*
+* This function does nothing if the error state of the encoder is already 
+* set upon entry.
+*
+* Undefined Behavior\n
+* The following situations result in UNDEFINED behavior:\n
+*   Calling with psOperation set to NULL.\n
+*   Calling with psOperation pointing to an operation in a state other than 
+*       OTZ_STATE_ENCODE.\n
+*   Calling with ps_shared_mem set to NULL.
+*   Calling with ps_shared_mem pointing to a memory block in a state other than 
+*       OTZ_STATE_OPEN.
+*
+* @param ps_operation - A pointer to the operation for which we are encoding.
+* @param ps_shared_mem - A pointer to the shared memory block structure.
+* @param offset - The offset, in bytes, from the start of the 
+*                 shared memory block to the start of the memory range.
+* @param length - The length, in bytes, of the memory range.
+* @param flags - The access flags for this memory reference.
+* @param param_type - In or Out data
+*/
+void otz_encode_memory_reference( otz_operation_t* ps_operation,  
+                        otz_shared_mem_t* ps_shared_mem,
+                        uint32_t offset,
+                        uint32_t length,
+                        uint32_t flags,
+                        int param_type);
+
+
+/**
+* @brief Decode a unsigned 32-bit integer value from message
+*
+* This function decodes a single item of type uint32_t from the current offset 
+* in the structured message returned by the service.
+*
+* If on entry the decoder is in an error state this function does nothing 
+* and returns 0. The state of the decoder remains unchanged.
+*
+* If the decoder error state is not set on entry, the system attempts to decode 
+* the data item at the current offset in the decoder and return the result. 
+*
+* If an error occurs this function returns 0 and sets the error state of the
+* decoder. Otherwise the data value is returned by the function and the decoder 
+* offset is incremented past the item that has been decoded.
+*
+* The decoder may set its error state in the following situations:\n
+*   There are no more items in the decoder.\n
+*   The item in the decoder is not of the type requested.\n
+*
+* Undefined Behavior\n
+* The following situations result in UNDEFINED behavior:\n
+*   Calling with "operation" set to NULL.\n
+*   Calling with "operation" pointing to an operation not in the 
+*       state OTZ_STATE_DECODE.
+*
+* Output\n
+* This function will set the state of the decoder to OTZ_ERROR_DECODE_NO_DATA 
+* if there is no further data to decode.
+*
+* This function may optionally check the type of the data returned and may set 
+* the state of the decoder to OTZ_ERROR_DECODE_TYPE if there is a type mismatch. 
+* The presence of type checking in the library is implementation-defined; 
+* to ensure safety, clients must check the value of returned data to ensure 
+* that it meets any critical criteria.
+*
+* @param ps_operation - The operation from which we decoding the integer.
+*
+* @return - The value of the data item on success, 0 on any error.
+*/
+uint32_t otz_decode_uint32( otz_operation_t* ps_operation);
+
+
+/**
+* @brief  Decode a block of binary data from the message
+*
+* This function decodes a block of binary data from the current offset 
+* in the structured message returned by the service. 
+* The length of the block is returned in *pui_length and the base pointer is 
+* the function return value.
+*
+* The implementation must guarantee that the returned buffer allocation is 
+* aligned on an eight byte boundary, enabling direct sharing of any C data type 
+* in accordance with the ARM Application Binary Interface [ARM IHI
+* 0036A].
+*
+* It is expected that this function will return a pointer to the binary data 
+* in the encoder buffer. The client must make use of this memory before 
+* the operation is released. After the operation is released the client 
+* must not access the buffer again. If the data is needed locally after the 
+* operation has been released it must first be copied into a
+* client allocated memory block.
+*
+* If on entry the decoder is in an error state this function does nothing 
+* and returns NULL, with pui_length set to 0. 
+* The state of the decoder remains unchanged.
+*
+* If the decoder error state is not set on entry, the system attempts to 
+* decode the data item at the current offset in the decoder and 
+* return the result. If an error occurs this function returns NULL as the 
+* base pointer, sets the length to 0, and sets the error state of the decoder. 
+* Otherwise the data value is returned by the function, and the
+* decoder offset is incremented past the array item in the decoder.
+*
+* Note that this function may decode a NULL array and a zero length array 
+* as valid types. In the former case the return value is NULL 
+* and the length is zero. In the second case the return value is non-NULL 
+* and the length is zero – the pointer must not be dereferenced by the client.
+*
+* The decoder may return errors in the following situations:\n
+*       • There are no more items in the decoder.\n
+*       • The item in the decoder is not of the type requested.
+*
+* Undefined Behavior\n
+* The following situations result in UNDEFINED behavior:\n
+*       Calling with psOperation set to NULL.\n
+*       Calling with psOperation pointing to an operation not in the state 
+*           OTZ_STATE_DECODE. \n
+*       Calling with puiLength set to NULL.\n
+*
+* Output:\n
+* This function will set the state of the decoder to OTZ_ERROR_DECODE_NO_DATA 
+* if there is no further data to decode.
+*
+* This function may optionally check the type of the data returned, 
+* and may set the state of the decoder to OTZ_ERROR_DECODE_TYPE 
+* if there is a type mismatch. The presence of type checking in the library is
+* implementation-defined; to ensure safety, clients must check the value of 
+* returned data to ensure that it meets any critical criteria.
+*
+* @param ps_operation - The operation from which we are decoding the array.
+* @param plength - The pointer to the variable that will contain the 
+* array length on exit.
+*
+* @return  - The value of the data item on success, 0 on any error.
+*/
+void* otz_decode_array_space(otz_operation_t* ps_operation, uint32_t *plength);
+
+
+
+/**
+* @brief Returns the decoder stream data type
+*
+* This function returns the type of the data at the current offset 
+* in the decoder stream.
+*
+* This function does not affect the error state of the decoder.
+* 
+* Undefined Behavior\n
+* The following situations result in UNDEFINED behavior:\n
+*       Calling with psOperation set to NULL.\n
+*       Calling with psOperation pointing to an operation not in the state 
+*           OTZ_STATE_DECODE.\n
+*
+* @param ps_operation - The operation from which we are retrieving the result.
+*
+* @return -  OTZ_TYPE_NONE: There is no more data.\n
+*       OTZ_TYPE_UINT32: The next item in the decode stream is a uint32.\n
+*       OTZ_TYPE_ARRAY: The next item in the decode string is an array.\n
+*/
+uint32_t otz_decode_get_type(otz_operation_t* ps_operation);
+
+/**
+* @brief Get decode error
+*
+* This function returns the error state of the decoder associated 
+* with the given operation.
+*
+* This function does not affect the error state of the decoder.
+*
+* Undefined Behavior\n
+* The following situations result in UNDEFINED behavior:\n
+*       Calling with psOperation set to NULL.\n
+*       Calling with psOperation pointing to an operation not in the state 
+*           OTZ_STATE_DECODE.
+*
+* @param ps_operation - The operation from which we are retrieving the result.
+*
+* @return - OTZ_SUCCESS: There have been no decoding errors.\n
+*           OTZ_ERROR_*: The first decoder error to occur.
+*/
+otz_return_t otz_decode_get_error(otz_operation_t* ps_operation);
+
+#endif
diff --git a/drivers/sechw/trustzone/otz_client.h b/drivers/sechw/trustzone/otz_client.h
new file mode 100644
index 0000000..af0e59a
--- /dev/null
+++ b/drivers/sechw/trustzone/otz_client.h
@@ -0,0 +1,131 @@
+/* 
+ * OpenVirtualization: 
+ * For additional details and support contact developer@sierraware.com.
+ * Additional documentation can be found at www.openvirtualization.org
+ * 
+ * Copyright (C) 2011 SierraWare
+ * 
+ * This library is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ * 
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ * 
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ * 
+ * Trustzone client driver defintions.
+ */
+
+#ifndef __OTZ_CLIENT_H_
+#define __OTZ_CLIENT_H_
+
+#define OTZ_CLIENT_FULL_PATH_DEV_NAME "/dev/otz_client"
+#define OTZ_CLIENT_DEV "otz_client"
+
+#define OTZ_CLIENT_IOC_MAGIC 0x775B777F /* "OTZ Client" */
+
+#undef TDEBUG
+#ifdef OTZ_DEBUG
+#define TDEBUG(fmt, args...) printk(KERN_DEBUG "%s(%i, %s): " fmt "\n", \
+        __func__, current->pid, current->comm, ## args)
+#else
+#define TDEBUG(fmt, args...)
+#endif
+
+#undef TERR
+#define TERR(fmt, args...) printk(KERN_ERR "%s(%i, %s): " fmt "\n", \
+        __func__, current->pid, current->comm, ## args)
+
+/** IOCTL request */
+
+
+/**
+ * @brief Encode command structure
+ */
+struct otz_client_encode_cmd {
+    unsigned int len;
+    void* data;
+    int   offset;
+    int   flags;
+    int   param_type;
+
+    int encode_id;
+    int service_id;
+    int session_id;
+    unsigned int cmd_id;    
+};
+
+/**
+ * @brief Session details structure
+ */
+struct ser_ses_id{
+    int service_id;
+    int session_id;
+};
+
+/**
+ * @brief Shared memory information for the session
+ */
+struct otz_session_shared_mem_info{
+    int service_id;
+    int session_id;
+    unsigned int user_mem_addr;
+};
+
+/**
+ * @brief Shared memory used for smc processing
+ */
+struct otz_smc_cdata {
+    int cmd_addr;
+    int ret_val;    
+};
+
+void *memncpy(void *dst, const void *src, unsigned int count,
+		unsigned int dst_len, unsigned int src_len);
+
+/**
+* @brief copies n size of string src to string dst
+*
+* @param dst destination string
+* @param src source string
+* @param n length of string to be copied
+*/
+void strncpy_safe(char* dst, const char* src, size_t n);
+
+/* For general service */
+#define OTZ_CLIENT_IOCTL_SEND_CMD_REQ \
+    _IOWR(OTZ_CLIENT_IOC_MAGIC, 3, struct otz_client_encode_cmd)
+#define OTZ_CLIENT_IOCTL_SES_OPEN_REQ \
+    _IOW(OTZ_CLIENT_IOC_MAGIC, 4, struct ser_ses_id)
+#define OTZ_CLIENT_IOCTL_SES_CLOSE_REQ \
+    _IOWR(OTZ_CLIENT_IOC_MAGIC, 5, struct ser_ses_id)
+#define OTZ_CLIENT_IOCTL_SHR_MEM_FREE_REQ \
+    _IOWR(OTZ_CLIENT_IOC_MAGIC, 6, struct otz_session_shared_mem_info )
+
+#define OTZ_CLIENT_IOCTL_ENC_UINT32 \
+    _IOWR(OTZ_CLIENT_IOC_MAGIC, 7, struct otz_client_encode_cmd)
+#define OTZ_CLIENT_IOCTL_ENC_ARRAY \
+    _IOWR(OTZ_CLIENT_IOC_MAGIC, 8, struct otz_client_encode_cmd)
+#define OTZ_CLIENT_IOCTL_ENC_ARRAY_SPACE \
+    _IOWR(OTZ_CLIENT_IOC_MAGIC, 9, struct otz_client_encode_cmd)
+#define OTZ_CLIENT_IOCTL_ENC_MEM_REF \
+    _IOWR(OTZ_CLIENT_IOC_MAGIC, 10, struct otz_client_encode_cmd)
+
+#define OTZ_CLIENT_IOCTL_DEC_UINT32 \
+    _IOWR(OTZ_CLIENT_IOC_MAGIC, 11, struct otz_client_encode_cmd)
+#define OTZ_CLIENT_IOCTL_DEC_ARRAY_SPACE \
+    _IOWR(OTZ_CLIENT_IOC_MAGIC, 12, struct otz_client_encode_cmd)
+#define OTZ_CLIENT_IOCTL_OPERATION_RELEASE \
+    _IOWR(OTZ_CLIENT_IOC_MAGIC, 13, struct otz_client_encode_cmd)
+#define OTZ_CLIENT_IOCTL_SHR_MEM_ALLOCATE_REQ \
+    _IOWR(OTZ_CLIENT_IOC_MAGIC, 14, struct otz_session_shared_mem_info)
+#define OTZ_CLIENT_IOCTL_GET_DECODE_TYPE \
+    _IOWR(OTZ_CLIENT_IOC_MAGIC, 15, struct otz_client_encode_cmd)
+
+#endif /* __OTZ_CLIENT_H_ */    
diff --git a/drivers/sechw/trustzone/otz_client_main.c b/drivers/sechw/trustzone/otz_client_main.c
new file mode 100644
index 0000000..f7aca03
--- /dev/null
+++ b/drivers/sechw/trustzone/otz_client_main.c
@@ -0,0 +1,2315 @@
+/* 
+ * OpenVirtualization: 
+ * For additional details and support contact developer@sierraware.com.
+ * Additional documentation can be found at www.openvirtualization.org
+ * 
+ * Copyright (C) 2011 SierraWare
+ * 
+ * This library is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ * 
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ * 
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ * 
+ * Trustzone API interface driver.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/platform_device.h>
+#include <linux/debugfs.h>
+#include <linux/cdev.h>
+#include <linux/uaccess.h>
+#include <linux/sched.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/wait.h>
+#include <asm/cacheflush.h>
+
+
+#include <otz_client.h>
+#include <otz_common.h>
+#include <otz_id.h>
+#include <smc_id.h>
+#include <sw_config.h>
+
+#ifdef OTZONE_ASYNC_NOTIFY_SUPPORT
+#include <linux/smp.h>
+#endif
+
+#define ROUND_UP(N, S) ((((N) + (S) - 1) / (S)) * (S))
+
+
+static struct class *driver_class;
+static dev_t otz_client_device_no;
+static struct cdev otz_client_cdev;
+
+static u32 cacheline_size;
+static u32 device_file_cnt = 0;
+
+#ifdef OTZONE_ASYNC_NOTIFY_SUPPORT
+static struct otzc_notify_data *notify_data = NULL;
+#endif
+
+static struct otz_smc_cdata otz_smc_cd[NR_CPUS];
+
+/**
+ * @brief 
+ *
+ * @param in_lock
+ */
+static DEFINE_MUTEX(in_lock);
+
+/**
+ * @brief 
+ *
+ * @param send_cmd_lock
+ */
+static DEFINE_MUTEX(send_cmd_lock);
+
+/**
+ * @brief 
+ *
+ * @param smc_lock
+ */
+static DEFINE_MUTEX(smc_lock);
+
+/**
+ * @brief 
+ *
+ * @param encode_cmd_lock
+ */
+static DEFINE_MUTEX(encode_cmd_lock);
+
+/**
+ * @brief 
+ *
+ * @param decode_cmd_lock
+ */
+static DEFINE_MUTEX(decode_cmd_lock);
+
+/**
+ * @brief 
+ *
+ * @param ses_open_lock
+ */
+static DEFINE_MUTEX(ses_open_lock);
+
+/**
+ * @brief 
+ *
+ * @param ses_close_lock
+ */
+static DEFINE_MUTEX(ses_close_lock);
+
+/**
+ * @brief 
+ *
+ * @param mem_free_lock
+ */
+static DEFINE_MUTEX(mem_free_lock);
+
+/**
+ * @brief 
+ *
+ * @param mem_alloc_lock
+ */
+static DEFINE_MUTEX(mem_alloc_lock);
+
+/**
+ * @brief 
+ */
+static struct otz_dev_file_head{
+    u32 dev_file_cnt;
+    struct list_head dev_file_list;
+} otzc_dev_file_head;
+
+/**
+ * @brief 
+ */
+typedef struct otzc_shrd_mem_head{
+
+    int shared_mem_cnt;
+    struct list_head shared_mem_list;
+} otzc_shared_mem_head;
+
+/**
+ * @brief 
+ */
+typedef struct otz_dev_file{
+    struct list_head head;
+    u32 dev_file_id;
+    u32 service_cnt;
+    struct list_head services_list;
+	otzc_shared_mem_head dev_shared_mem_head;
+} otzc_dev_file;
+
+/**
+ * @brief 
+ */
+typedef struct otzc_service{
+    struct list_head head;
+    u32 service_id;
+    struct list_head sessions_list;
+} otzc_service;
+
+
+/**
+ * @brief 
+ */
+typedef struct otzc_session{
+    struct list_head head;
+    int session_id;
+
+    struct list_head encode_list;
+    struct list_head shared_mem_list;
+} otzc_session;
+
+/**
+ * @brief 
+ */
+struct otz_wait_data {
+    wait_queue_head_t send_cmd_wq;
+    int               send_wait_flag;
+};
+
+/**
+ * @brief 
+ */
+typedef struct otzc_encode{
+
+    struct list_head head;
+
+    int encode_id;
+
+    void* ker_req_data_addr;
+    void* ker_res_data_addr;
+
+    u32  enc_req_offset;
+    u32  enc_res_offset;
+    u32  enc_req_pos;
+    u32  enc_res_pos;
+    u32  dec_res_pos;
+
+    u32  dec_offset;
+
+    struct otz_wait_data wait_data;
+
+    struct otzc_encode_meta *meta;
+} otzc_encode;
+
+
+
+/**
+ * @brief 
+ */
+typedef struct otzc_shared_mem{
+
+    struct list_head head;
+    struct list_head s_head;
+
+    void* index;
+
+    void* k_addr;
+    void* u_addr;
+    u32  len;
+} otzc_shared_mem;
+
+static int otz_client_prepare_encode(void* private_data,
+                                     struct otz_client_encode_cmd *enc,
+                                            otzc_encode **penc_context,
+                                            otzc_session **psession);
+
+/**
+ * @brief secure monitor call 
+ *
+ * @param cmd_addr
+ *
+ * @return 
+ */
+static u32 _otz_smc(u32 cmd_addr)
+{
+    register u32 r0 asm("r0") = CALL_TRUSTZONE_API;
+    register u32 r1 asm("r1") = cmd_addr;
+    register u32 r2 asm("r2") = OTZ_CMD_TYPE_NS_TO_SECURE;
+    do {
+        asm volatile(
+#if USE_ARCH_EXTENSION_SEC
+	".arch_extension sec\n\t"
+#endif
+            __asmeq("%0", "r0")
+            __asmeq("%1", "r0")
+            __asmeq("%2", "r1")
+            __asmeq("%3", "r2")
+
+            "smc    #0  @ switch to secure world\n"
+            : "=r" (r0)
+            : "r" (r0), "r" (r1), "r" (r2));
+    } while (0);
+
+    return r0;
+}
+
+/**
+ * @brief otz_smc handler for secondary cores
+ *
+ * @param info
+ */
+static void secondary_otz_smc_handler(void *info)
+{
+	struct otz_smc_cdata *cd = (struct otz_smc_cdata *)info;
+
+	rmb();
+
+	TDEBUG("secondary otz smc handler...");
+
+	cd->ret_val = _otz_smc(cd->cmd_addr);
+	wmb();
+
+	TDEBUG("done smc on primary \n");
+}
+
+/**
+ * @brief This function takes care of posting the smc to the 
+ *        primary core
+ *
+ * @param cpu_id
+ * @param cmd_addr
+ *
+ * @return 
+ */
+static u32 post_otz_smc(int cpu_id, u32 cmd_addr)
+{
+	struct otz_smc_cdata *cd = &otz_smc_cd[cpu_id];
+
+	TDEBUG("Post from secondary ...");
+
+	cd->cmd_addr = cmd_addr;
+	cd->ret_val  = 0;
+	wmb();
+
+	smp_call_function_single(0, secondary_otz_smc_handler, 
+				 (void *)cd, 1);
+	rmb();
+
+	TDEBUG("completed smc on secondary \n");
+
+	return cd->ret_val;
+}
+
+/**
+* @brief otz_smc wrapper to handle the multi core case
+*
+* @param cmd_addr
+*
+* @return 
+*/
+static u32 otz_smc(u32 cmd_addr)
+{
+	int cpu_id = smp_processor_id();
+
+	if (cpu_id != 0) {
+		mb();
+		return post_otz_smc(cpu_id, cmd_addr); /* post it to primary */
+	} else {
+		return _otz_smc(cmd_addr); /* called directly on primary core */
+	}
+}
+
+/**
+ * @brief Call SMC
+ *
+ * When the processor executes the Secure Monitor Call (SMC),
+ * the core enters Secure Monitor mode to execute the Secure Monitor code
+ *
+ * @param svc_id  - service identifier
+ * @param cmd_id  - command identifier
+ * @param context - session context
+ * @param enc_id - encoder identifier
+ * @param cmd_buf - command buffer 
+ * @param cmd_len - command buffer length
+ * @param resp_buf - response buffer
+ * @param resp_len - response buffer length
+ * @param meta_data
+ * @param ret_resp_len
+ *
+ * @return 
+ */
+static int otz_smc_call(u32 dev_file_id, u32 svc_id, u32 cmd_id,
+                    u32 context, u32 enc_id, const void *cmd_buf,
+                    size_t cmd_len, void *resp_buf, size_t resp_len, 
+                    const void *meta_data, int *ret_resp_len, 
+                    struct otz_wait_data* wq, void* arg_lock)
+{
+    int ret;
+    u32 smc_cmd_phys;
+
+    static struct otz_smc_cmd *smc_cmd;
+
+    smc_cmd = (struct otz_smc_cmd*)kmalloc(sizeof(struct otz_smc_cmd), 
+                                            GFP_KERNEL);
+   if(!smc_cmd){
+       TERR("kmalloc failed for smc command\n");
+       ret = -ENOMEM;
+       goto out;
+   }
+
+    if(ret_resp_len)
+        *ret_resp_len = 0;
+
+    smc_cmd->src_id = (svc_id << 10) | cmd_id;
+    smc_cmd->src_context = task_tgid_vnr(current);
+
+    smc_cmd->id = (svc_id << 10) | cmd_id;
+    smc_cmd->context = context;
+    smc_cmd->enc_id = enc_id;
+    smc_cmd->dev_file_id = dev_file_id;
+    smc_cmd->req_buf_len = cmd_len;
+    smc_cmd->resp_buf_len = resp_len;
+    smc_cmd->ret_resp_buf_len = 0;
+
+    if(cmd_buf)
+        smc_cmd->req_buf_phys = virt_to_phys((void*)cmd_buf);
+    else
+        smc_cmd->req_buf_phys = 0;
+
+    if(resp_buf)
+        smc_cmd->resp_buf_phys = virt_to_phys((void*)resp_buf);
+    else
+        smc_cmd->resp_buf_phys = 0;
+
+    if(meta_data)
+        smc_cmd->meta_data_phys = virt_to_phys(meta_data);
+    else
+        smc_cmd->meta_data_phys = 0;        
+
+    smc_cmd_phys = virt_to_phys((void*)smc_cmd);
+
+    mutex_lock(&smc_lock);
+    ret = otz_smc(smc_cmd_phys);
+    mutex_unlock(&smc_lock);
+
+#ifdef  OTZONE_ASYNC_NOTIFY_SUPPORT
+    if(ret == SMC_PENDING){
+        if(arg_lock)
+            mutex_unlock(arg_lock);
+
+        if(wq){
+            if(wait_event_interruptible(wq->send_cmd_wq,
+                wq->send_wait_flag)) {
+                ret = -ERESTARTSYS;
+                goto out;
+            }
+            wq->send_wait_flag = 0;
+        }
+
+        if(arg_lock)
+            mutex_lock(arg_lock);
+
+
+        svc_id = OTZ_SVC_GLOBAL;
+        cmd_id = OTZ_GLOBAL_CMD_ID_RESUME_ASYNC_TASK;
+        smc_cmd->src_id = (svc_id << 10) | cmd_id;
+        smc_cmd->id = (svc_id << 10) | cmd_id;
+
+        mutex_lock(&smc_lock);
+
+        ret = otz_smc(smc_cmd_phys);
+        mutex_unlock(&smc_lock);
+
+    }
+#endif
+
+    if (ret) {
+        TERR("smc_call returns error\n");
+        /*printk("%s \n", otz_strerror(ret));*/
+        goto out;
+    }
+    
+    if(ret_resp_len) {
+        *ret_resp_len = smc_cmd->ret_resp_buf_len;
+    }
+
+out:
+    if(smc_cmd)
+        kfree(smc_cmd);
+    return ret;
+}
+
+#ifdef OTZONE_ASYNC_NOTIFY_SUPPORT
+static void ipi_secure_notify( struct pt_regs *regs)
+{
+    otzc_dev_file *temp_dev_file;
+    otzc_service *temp_svc;
+    otzc_session *temp_ses;
+    otzc_encode *enc_temp;
+
+    int enc_found = 0;
+
+    if(!notify_data)
+        return;
+
+    TDEBUG("otz_client pid 0x%x\n", notify_data->client_pid);
+    TDEBUG("otz_client_notify_handler service id 0x%x \
+session id 0x%x and encoder id 0x%x\n", 
+notify_data->service_id, notify_data->session_id, notify_data->enc_id); 
+
+    list_for_each_entry(temp_dev_file, &otzc_dev_file_head.dev_file_list,
+                                                                    head) {
+        if(temp_dev_file->dev_file_id == notify_data->dev_file_id){
+            TDEBUG("dev file id %d \n",temp_dev_file->dev_file_id);
+
+            list_for_each_entry(temp_svc, &temp_dev_file->services_list, head){
+                if(temp_svc->service_id == notify_data->service_id) {
+                    TDEBUG("send cmd ser id %d \n",temp_svc->service_id);
+
+                    list_for_each_entry(temp_ses, &temp_svc->sessions_list, head) {
+                        if(temp_ses->session_id == notify_data->session_id) {
+                            TDEBUG("send cmd ses id %d \n",temp_ses->session_id);
+
+                            list_for_each_entry(enc_temp,&temp_ses->encode_list, head) {
+                                if(enc_temp->encode_id == notify_data->enc_id) {
+                                TDEBUG("send cmd enc id 0x%x\n",
+                                                        enc_temp->encode_id);
+                                    enc_found = 1;
+                                    break;
+                                }
+                            }
+                        }
+                        break;        
+                    }
+                    break;
+                }
+            }
+            break;
+        }
+    }
+
+    if(enc_found) {
+        enc_temp->wait_data.send_wait_flag = 1;
+        wake_up_interruptible(&enc_temp->wait_data.send_cmd_wq);
+    }
+
+    return;
+}
+#endif
+
+/**
+ * @brief
+ * 
+ * Clears session id and closes the session 
+ *
+ * @param private_data
+ * @param temp_svc
+ * @param temp_ses
+ *
+ */
+static void otz_client_close_session_for_service(
+                        void* private_data,
+                        otzc_service* temp_svc, 
+                        otzc_session *temp_ses)
+{
+    int ret_val;
+    otzc_encode *temp_encode, *enc_context;
+    otzc_shared_mem *shared_mem, *temp_shared;
+    u32 dev_file_id = (u32)private_data;
+
+    if(!temp_svc || !temp_ses)
+        return;
+    
+    TDEBUG("freeing ses_id %d \n",temp_ses->session_id); 
+
+    ret_val = otz_smc_call(dev_file_id, OTZ_SVC_GLOBAL, 
+        OTZ_GLOBAL_CMD_ID_CLOSE_SESSION, 0, 0,
+        &temp_svc->service_id,
+        sizeof(temp_svc->service_id),&temp_ses->session_id,
+        sizeof(temp_ses->session_id), NULL, NULL, NULL, NULL); 
+
+    list_del(&temp_ses->head);
+            
+    if (!list_empty(&temp_ses->encode_list)) {
+        list_for_each_entry_safe(enc_context, temp_encode, 
+                    &temp_ses->encode_list, head) {
+            list_del(&enc_context->head);   
+            kfree(enc_context);
+        }
+    }
+
+    if (!list_empty(&temp_ses->shared_mem_list)) {
+        list_for_each_entry_safe(shared_mem, temp_shared, 
+                    &temp_ses->shared_mem_list, s_head) {
+            list_del(&shared_mem->s_head);   
+
+            if(shared_mem->k_addr)
+                free_pages((u32)shared_mem->k_addr,
+                    get_order(ROUND_UP(shared_mem->len, SZ_4K)));
+
+            kfree(shared_mem);
+        }
+    }
+
+    kfree(temp_ses);
+}
+
+
+/**
+* @brief Client Service Initialization
+*
+* @param dev_file
+* @param service_id
+*
+* @return 
+*/
+static int otz_client_service_init(otzc_dev_file* dev_file, int service_id)
+{
+    int ret_code = 0;
+    otzc_service* svc_new;
+    otzc_service* temp_pos;
+    svc_new = (otzc_service*)kmalloc(sizeof(otzc_service), GFP_KERNEL);
+    if(!svc_new){
+        TERR("kmalloc failed \n");
+        ret_code = -ENOMEM;
+        goto clean_prev_malloc;
+    }
+
+    svc_new->service_id = service_id;
+    dev_file->service_cnt++;
+    INIT_LIST_HEAD(&svc_new->sessions_list);
+    list_add(&svc_new->head, &dev_file->services_list);
+    goto return_func;
+
+clean_prev_malloc:
+    if (!list_empty(&dev_file->services_list)) {
+        list_for_each_entry_safe(svc_new, temp_pos, 
+                        &dev_file->services_list, head) {
+            list_del(&svc_new->head);   
+            kfree(svc_new);
+        }
+    }
+
+return_func:
+    return ret_code;
+}
+
+
+/**
+* @brief Client service exit
+*
+* @param private_data
+*
+* @return 
+*/
+static int otz_client_service_exit(void* private_data)
+{
+    otzc_shared_mem* temp_shared_mem;
+    otzc_shared_mem  *temp_pos;
+    otzc_dev_file *tem_dev_file, *tem_dev_file_pos;
+    otzc_session *temp_ses, *temp_ses_pos;
+    otzc_service* tmp_svc = NULL, *tmp_pos;
+    u32 dev_file_id;
+
+    dev_file_id = (u32)(private_data);
+    list_for_each_entry_safe(tem_dev_file, tem_dev_file_pos,
+                &otzc_dev_file_head.dev_file_list, head) {
+        if(tem_dev_file->dev_file_id == dev_file_id){
+            
+			list_for_each_entry_safe(temp_shared_mem, temp_pos, 
+						&tem_dev_file->dev_shared_mem_head.shared_mem_list, head){
+				list_del(&temp_shared_mem->head);
+
+				if(temp_shared_mem->k_addr)
+					free_pages((u32)temp_shared_mem->k_addr,
+						get_order(ROUND_UP(temp_shared_mem->len, SZ_4K)));
+
+				if(temp_shared_mem)
+					kfree(temp_shared_mem);
+			}
+            if (!list_empty(&tem_dev_file->services_list)) {
+
+                list_for_each_entry_safe(tmp_svc, tmp_pos,
+                                        &tem_dev_file->services_list, head) {
+
+                    list_for_each_entry_safe(temp_ses, temp_ses_pos, 
+                                    &tmp_svc->sessions_list, head) {
+                        otz_client_close_session_for_service(private_data, 
+                                                            tmp_svc, temp_ses);
+                    }
+                    list_del(&tmp_svc->head);   
+                    kfree(tmp_svc);
+                }
+            }
+
+            list_del(&tem_dev_file->head);   
+            kfree(tem_dev_file);
+            break;
+        }
+    }
+
+    return 0;
+}
+
+/**
+ * @brief 
+ *
+ * Opens session for the requested service by getting the service ID
+ * form the user. After opening the session, the session ID is copied back
+ * to the user space.
+ *
+ * @param private_data - Holds the device file ID
+ * @param argp - Contains the Service ID
+ *
+ * @return 
+ */
+static int otz_client_session_open(void* private_data, void* argp)
+{
+    otzc_service* svc;
+    otzc_dev_file *temp_dev_file;
+    otzc_session* ses_new;
+    struct ser_ses_id ses_open;
+    int svc_found = 0;
+    int ret_val = 0, ret_resp_len;
+    u32 dev_file_id = (u32)private_data;
+    
+    TDEBUG("inside session open\n");
+
+    if(copy_from_user(&ses_open, argp, sizeof(ses_open))){
+        TERR("copy from user failed\n");
+        ret_val =  -EFAULT;
+        goto return_func;
+    }
+
+    TDEBUG("service_id = %d\n",ses_open.service_id);
+
+    list_for_each_entry(temp_dev_file, &otzc_dev_file_head.dev_file_list,
+                                                                    head) {
+        if(temp_dev_file->dev_file_id == dev_file_id){
+
+            list_for_each_entry(svc, &temp_dev_file->services_list, head){
+                if( svc->service_id == ses_open.service_id){
+                    svc_found = 1;
+                    break;
+                }
+            }
+            break;
+        }
+    }
+
+    if(!svc_found) {
+        ret_val =  -EINVAL;
+        goto return_func;
+    }
+
+    ses_new = (otzc_session*)kmalloc(sizeof(otzc_session), GFP_KERNEL);
+    if(!ses_new) {
+        TERR("kmalloc failed\n");
+        ret_val =  -ENOMEM;
+        goto return_func;
+    }
+
+    TDEBUG("service id 0x%x\n", ses_open.service_id);
+
+    ret_val = otz_smc_call(dev_file_id, OTZ_SVC_GLOBAL,
+            OTZ_GLOBAL_CMD_ID_OPEN_SESSION, 0, 0,
+        &ses_open.service_id, sizeof(ses_open.service_id), &ses_new->session_id,
+        sizeof(ses_new->session_id), NULL, &ret_resp_len, NULL, NULL);      
+
+    if(ret_val != SMC_SUCCESS) {
+        goto clean_session;
+    }
+
+    if(ses_new->session_id == -1) {
+        TERR("invalid session id\n");
+        ret_val =  -EINVAL;
+        goto clean_session;
+    }
+
+    TDEBUG("session id 0x%x for service id 0x%x\n", ses_new->session_id,
+            ses_open.service_id);
+
+    ses_open.session_id = ses_new->session_id;
+
+    INIT_LIST_HEAD(&ses_new->encode_list);
+    INIT_LIST_HEAD(&ses_new->shared_mem_list);
+    list_add_tail(&ses_new->head, &svc->sessions_list);
+
+    if(copy_to_user(argp, &ses_open, sizeof(ses_open))) {
+        TERR("copy from user failed\n");
+        ret_val =  -EFAULT;
+        goto clean_hdr_buf;
+    }
+
+ /*   TDEBUG("session created from service \n"); */
+    goto return_func;
+
+clean_hdr_buf:
+    list_del(&ses_new->head);
+
+clean_session:
+    kfree(ses_new);
+
+return_func:
+
+    return ret_val;
+}
+
+/**
+ * @brief 
+ *
+ * Closes the client session by getting the service ID and
+ * session ID from user space.
+ *
+ * @param private_data - Contains the device file ID
+ * @param argp - Contains the service ID and Session ID
+ *
+ * @return 
+ */
+static int otz_client_session_close(void* private_data, void* argp)
+{
+    otzc_dev_file *temp_dev_file;
+    otzc_service *temp_svc;
+    otzc_session *temp_ses;
+    int ret_val = 0;
+    u32 dev_file_id = (u32)private_data;
+
+    struct ser_ses_id ses_close;
+
+    TDEBUG("inside session close\n");
+
+    if(copy_from_user(&ses_close, argp, sizeof(ses_close))) {
+        TERR("copy from user failed \n");
+        ret_val = -EFAULT;
+        goto return_func;
+    }
+
+    list_for_each_entry(temp_dev_file, &otzc_dev_file_head.dev_file_list,
+                                                                    head) {
+        if(temp_dev_file->dev_file_id == dev_file_id){
+
+            list_for_each_entry(temp_svc, &temp_dev_file->services_list, head) {
+                if( temp_svc->service_id == ses_close.service_id) {
+
+                    list_for_each_entry(temp_ses,
+                                        &temp_svc->sessions_list, head) {
+                        if(temp_ses->session_id == ses_close.session_id) {
+                            otz_client_close_session_for_service(private_data, 
+                                                            temp_svc, temp_ses);
+                            break;
+                        }                      
+                    }
+                    break;
+                }
+            }
+            break;
+        }
+    }
+
+    TDEBUG("return from close\n");
+
+return_func:
+    return ret_val;
+}
+
+
+/**
+ * @brief 
+ *
+ * @return 
+ */
+int otz_client_register_service(void)
+{
+/* Query secure and find out */
+    return 0;
+}
+
+/**
+ * @brief 
+ *
+ * @return 
+ */
+int otz_client_unregister_service(void)
+{
+/*query secure and do*/
+    return 0;
+}
+
+/**
+ * @brief 
+ * 
+ * Creates shared memory between non secure world applicaion
+ * and non secure world kernel.
+ * 
+ * @param filp
+ * @param vma
+ *
+ * @return 
+ */
+static int otz_client_mmap(struct file *filp, struct vm_area_struct *vma)
+{
+    int ret = 0;
+    otzc_shared_mem *mem_new;
+    u32*  alloc_addr;
+    otzc_dev_file *temp_dev_file;    
+
+    long length = vma->vm_end - vma->vm_start;
+
+    TDEBUG("Inside otz_client mmap\n");
+
+    alloc_addr =  (void*) __get_free_pages(GFP_KERNEL,
+                        get_order(ROUND_UP(length, SZ_4K)));
+    if(!alloc_addr) {
+        TERR("get free pages failed \n");
+        ret = -ENOMEM;
+        goto return_func;
+    }
+
+    TDEBUG("mmap k_addr %p \n",alloc_addr);
+
+    if (remap_pfn_range(vma,
+                vma->vm_start,
+                ((virt_to_phys(alloc_addr)) >> PAGE_SHIFT),
+                length,
+                vma->vm_page_prot)) {
+        ret = -EAGAIN;
+        goto return_func;
+    }
+    
+    mem_new = kmalloc(sizeof(otzc_shared_mem), GFP_KERNEL); 
+    if(!mem_new) {
+        TERR("kmalloc failed\n");
+        ret = -ENOMEM;
+        goto return_func;
+    }
+
+    mem_new->k_addr = alloc_addr;
+    mem_new->len = length;
+    mem_new->u_addr = (void*)vma->vm_start;
+    mem_new->index = mem_new->u_addr;
+    
+    list_for_each_entry(temp_dev_file, &otzc_dev_file_head.dev_file_list,
+                                                                    head) {
+        if(temp_dev_file->dev_file_id == (u32)filp->private_data){
+			break;
+		}
+	}
+    temp_dev_file->dev_shared_mem_head.shared_mem_cnt++;
+    list_add_tail( &mem_new->head ,&temp_dev_file->dev_shared_mem_head.shared_mem_list);
+
+return_func:
+    return ret;
+}
+
+/**
+ * @brief 
+ *
+ * Sends a command from the non secure application
+ * to the secure world.
+ *
+ * @param private_data
+ * @param argp
+ *
+ * @return 
+ */
+static int otz_client_send_cmd(void* private_data, void* argp)
+{
+    int ret = 0;
+    int ret_resp_len = 0;
+    struct otz_client_encode_cmd enc;
+    int dev_file_id;
+
+    otzc_dev_file *temp_dev_file;
+    otzc_service *temp_svc;
+    otzc_session *temp_ses;
+    otzc_encode *enc_temp;
+
+    int enc_found = 0;
+    dev_file_id = (u32)private_data;
+
+    TDEBUG("inside send cmd \n");
+
+    if(copy_from_user(&enc, argp, sizeof(enc))) {
+        TERR("copy from user failed \n");
+        ret = -EFAULT;
+        goto return_func;
+    }
+
+    TDEBUG("enc id %d\n",enc.encode_id);
+    TDEBUG("dev file id %d\n",dev_file_id);
+    TDEBUG("ser id %d\n",enc.service_id);
+    TDEBUG("ses id %d\n",enc.session_id);
+
+    list_for_each_entry(temp_dev_file, &otzc_dev_file_head.dev_file_list,
+                                                                    head) {
+        if(temp_dev_file->dev_file_id == dev_file_id){
+
+            list_for_each_entry(temp_svc, &temp_dev_file->services_list, head){
+                if(temp_svc->service_id == enc.service_id) {
+                    TDEBUG("send cmd ser id %d \n",temp_svc->service_id);
+
+                    list_for_each_entry(temp_ses, &temp_svc->sessions_list, 
+                            head) {
+                        if(temp_ses->session_id == enc.session_id) {
+                            TDEBUG("send cmd ses id %d \n",
+                                    temp_ses->session_id);
+
+                            if(enc.encode_id != -1) {
+                                list_for_each_entry(enc_temp, 
+                                    &temp_ses->encode_list, head) {
+                                    if(enc_temp->encode_id == enc.encode_id) {
+                                        TDEBUG("send cmd enc id 0x%x\n",
+                                                        enc_temp->encode_id);
+                                        enc_found = 1;
+                                        break;
+                                    }
+                                }
+                            }
+                            else {
+                                    ret = otz_client_prepare_encode(
+                                            private_data,
+                                            &enc, &enc_temp, &temp_ses);
+                                    if(!ret) {
+                                        enc_found = 1;
+                                    }
+                                    break;
+                            }
+                        }
+                        break;        
+                    }
+                    break;
+                }
+            }
+            break;
+        }
+    }
+    
+    if(!enc_found){
+        ret = -EINVAL;
+        goto return_func;
+    }
+
+  
+    ret = otz_smc_call(dev_file_id, enc.service_id, enc.cmd_id, enc.session_id, 
+        enc.encode_id,
+        enc_temp->ker_req_data_addr, enc_temp->enc_req_offset, 
+        enc_temp->ker_res_data_addr, enc_temp->enc_res_offset, 
+        enc_temp->meta, &ret_resp_len, &enc_temp->wait_data , &send_cmd_lock);
+
+    if(ret != SMC_SUCCESS) {
+         TERR("send cmd secure call failed \n");
+         goto return_func;
+    }
+
+    TDEBUG("smc_success\n");
+
+    if(copy_to_user(argp, &enc, sizeof(enc))) {
+        TERR("copy to user failed \n");
+        ret = -EFAULT;
+        goto return_func;
+    }
+
+return_func:
+   return ret; 
+
+}
+
+/**
+ * @brief Frees the encode context associated with a particular device and session
+ * This is for non-secure application
+ *
+ * @param private_data
+ * @param argp
+ *
+ * @return 
+ */
+static int otz_client_operation_release(void* private_data, void *argp)
+{
+    struct otz_client_encode_cmd enc;
+    otzc_encode *enc_context;
+    otzc_dev_file *temp_dev_file;
+    otzc_service *temp_svc;
+    otzc_session *temp_ses;
+    int  session_found = 0, enc_found = 0;
+    int ret =0;
+    u32 dev_file_id = (u32)private_data;
+
+    if(copy_from_user(&enc, argp, sizeof(enc))) {
+        TERR("copy from user failed \n");
+        ret = -EFAULT;
+        goto return_func;
+    }
+
+    list_for_each_entry(temp_dev_file, &otzc_dev_file_head.dev_file_list,
+                                                                    head) {
+        if(temp_dev_file->dev_file_id == dev_file_id){
+
+            list_for_each_entry(temp_svc, &temp_dev_file->services_list, head) {
+                if( temp_svc->service_id == enc.service_id) {
+                    list_for_each_entry(temp_ses, &temp_svc->sessions_list, head) {
+                        if(temp_ses->session_id == enc.session_id) {
+                            session_found = 1;
+                            break;        
+                        }
+                    }
+                    break;
+                }
+            }
+            break;
+        }
+    }
+
+    if(!session_found) {
+        ret = -EINVAL;
+        goto return_func;
+    }
+
+    if(enc.encode_id != -1) {
+        list_for_each_entry(enc_context,&temp_ses->encode_list, head) {
+            if(enc_context->encode_id == enc.encode_id) {
+                enc_found = 1;
+                break;        
+            }
+        }
+    }
+
+    if(enc_found && enc_context) {
+       if(enc_context->ker_req_data_addr) 
+         kfree(enc_context->ker_req_data_addr);
+
+        if(enc_context->ker_res_data_addr) 
+            kfree(enc_context->ker_res_data_addr);
+
+        list_del(&enc_context->head);
+
+        kfree(enc_context->meta);
+        kfree(enc_context);
+    }
+return_func: 
+    return ret;
+}
+
+/**
+ * @brief 
+ *
+ * Prepares and initializes the encode context.
+ *
+ * @param private_data
+ * @param enc
+ * @param penc_context
+ * @param psession
+ *
+ * @return 
+ */
+static int otz_client_prepare_encode( void* private_data,
+                                      struct otz_client_encode_cmd *enc,
+                                      otzc_encode **penc_context,
+                                      otzc_session **psession) 
+{
+    otzc_dev_file *temp_dev_file;
+    otzc_service *temp_svc;
+    otzc_session *temp_ses;
+    otzc_encode *enc_context;
+    int  session_found = 0, enc_found = 0;
+    int ret = 0;
+    u32 dev_file_id = (u32)private_data;
+
+    list_for_each_entry(temp_dev_file, &otzc_dev_file_head.dev_file_list,
+                                                                    head) {
+        if(temp_dev_file->dev_file_id == dev_file_id){
+
+
+            list_for_each_entry(temp_svc, &temp_dev_file->services_list, head) {
+                if( temp_svc->service_id == enc->service_id) {
+                    list_for_each_entry(temp_ses, &temp_svc->sessions_list,
+                                                                        head) {
+                        if(temp_ses->session_id == enc->session_id) {
+                            TDEBUG("enc cmd ses id %d \n",temp_ses->session_id);
+                            session_found = 1;
+                            break;        
+                        }
+                    }
+                    break;
+                }
+            }
+            break;
+        }
+    }
+
+    if(!session_found) {
+        TERR("session not found\n");
+        ret = -EINVAL;
+        goto return_func;
+    }
+
+    if(enc->encode_id != -1) {
+        list_for_each_entry(enc_context,&temp_ses->encode_list, head) {
+            if(enc_context->encode_id == enc->encode_id) {
+                enc_found = 1;
+                break;        
+            }
+        }
+    }
+
+    if(!enc_found) {
+        enc_context = kmalloc(sizeof(otzc_encode), GFP_KERNEL);
+        if(!enc_context) {
+            TERR("kmalloc failed \n");
+            ret = -ENOMEM;
+            goto return_func;
+        }
+        enc_context->meta = kmalloc(sizeof(struct otzc_encode_meta ) * 
+            (OTZ_MAX_RES_PARAMS + OTZ_MAX_REQ_PARAMS),
+            GFP_KERNEL);
+        if(!enc_context->meta) {
+            TERR("kmalloc failed \n");
+            kfree(enc_context);
+            ret = -ENOMEM;
+            goto return_func;
+        }
+        enc_context->encode_id = (int)enc_context;
+        enc->encode_id = enc_context->encode_id;
+        enc_context->ker_req_data_addr = NULL;
+        enc_context->ker_res_data_addr = NULL;
+        enc_context->enc_req_offset = 0;
+        enc_context->enc_res_offset = 0;
+        enc_context->enc_req_pos = 0;
+        enc_context->enc_res_pos = OTZ_MAX_REQ_PARAMS;
+        enc_context->dec_res_pos = OTZ_MAX_REQ_PARAMS;
+        enc_context->dec_offset = 0;
+#ifdef OTZONE_ASYNC_NOTIFY_SUPPORT
+        enc_context->wait_data.send_wait_flag = 0; 
+        init_waitqueue_head(&enc_context->wait_data.send_cmd_wq);
+#endif
+        list_add_tail(&enc_context->head, &temp_ses->encode_list);    
+    }
+
+    *penc_context = enc_context;
+    *psession = temp_ses;
+
+return_func:
+    return ret;
+}
+
+/**
+ * @brief 
+ *
+ * Funcion to encode uint32
+ * 
+ * @param private_data
+ * @param argp
+ * 
+ * @return 
+ */
+static int otz_client_encode_uint32(void* private_data, void* argp)
+{
+    struct otz_client_encode_cmd enc;
+    int ret = 0;
+    otzc_session *session;
+    otzc_encode *enc_context;
+
+
+    if(copy_from_user(&enc, argp, sizeof(enc))) {
+        TERR("copy from user failed \n");
+        ret = -EFAULT;
+        goto return_func;
+    }
+    
+    ret = otz_client_prepare_encode(private_data, &enc, &enc_context, &session);
+
+    if(ret){
+        goto return_func;
+    }
+
+    if(enc.param_type == OTZC_PARAM_IN) {
+        if(!enc_context->ker_req_data_addr) {
+           enc_context->ker_req_data_addr = 
+                kmalloc(OTZ_1K_SIZE, GFP_KERNEL);
+            if(!enc_context->ker_req_data_addr) {
+                TERR("kmalloc failed \n");
+                ret =  -ENOMEM;
+                goto ret_encode_u32;
+            }
+        }
+        if( (enc_context->enc_req_offset + sizeof(u32) <= OTZ_1K_SIZE) &&
+            (enc_context->enc_req_pos < OTZ_MAX_REQ_PARAMS)) {
+            *(u32*)(enc_context->ker_req_data_addr + 
+                enc_context->enc_req_offset) = *((u32*)enc.data);
+            enc_context->enc_req_offset += sizeof(u32);
+            enc_context->meta[enc_context->enc_req_pos].type 
+                = OTZ_ENC_UINT32;
+            enc_context->meta[enc_context->enc_req_pos].len = sizeof(u32);
+            enc_context->enc_req_pos++;
+        }
+        else {
+            ret =  -ENOMEM;/* Check this */
+            goto ret_encode_u32;
+        }
+    }
+    else if(enc.param_type == OTZC_PARAM_OUT) {
+        if(!enc_context->ker_res_data_addr) {
+            enc_context->ker_res_data_addr = 
+                kmalloc(OTZ_1K_SIZE, GFP_KERNEL);
+            if(!enc_context->ker_res_data_addr) {
+                TERR("kmalloc failed \n");
+                ret = -ENOMEM;
+                goto ret_encode_u32;
+            }
+        }
+        if( (enc_context->enc_res_offset + sizeof(u32) <= OTZ_1K_SIZE) &&
+            (enc_context->enc_res_pos < 
+            (OTZ_MAX_RES_PARAMS + OTZ_MAX_REQ_PARAMS ))) {
+
+            if(enc.data != NULL) {
+                enc_context->meta[enc_context->enc_res_pos].usr_addr 
+                    = (u32)enc.data;
+            }
+            else {
+                enc_context->meta[enc_context->enc_res_pos].usr_addr = 0;
+            }
+            enc_context->enc_res_offset += sizeof(u32);
+            enc_context->meta[enc_context->enc_res_pos].type = OTZ_ENC_UINT32;
+            enc_context->meta[enc_context->enc_res_pos].len = sizeof(u32);
+            enc_context->enc_res_pos++;
+        }
+        else {
+            ret =  -ENOMEM; /* check this */
+            goto ret_encode_u32;
+        }
+    }
+
+
+ret_encode_u32:
+    if(copy_to_user(argp, &enc, sizeof(enc))){
+        TERR("copy from user failed \n");
+        return -EFAULT;
+    }
+
+return_func:
+    return ret;
+}
+
+
+/**
+* @brief Function to encode an array
+*
+* @param private_data
+* @param argp
+*
+* @return 
+*/
+static int otz_client_encode_array(void* private_data, void* argp)
+{
+    struct otz_client_encode_cmd enc;
+    int ret = 0;
+    otzc_encode *enc_context;
+    otzc_session *session;
+
+    if(copy_from_user(&enc, argp, sizeof(enc))) {
+        TERR("copy from user failed \n");
+        ret = -EFAULT;
+        goto return_func;
+    }
+    
+    ret = otz_client_prepare_encode(private_data, &enc, &enc_context, &session);
+
+    if(ret){
+        goto return_func;
+    }
+    TDEBUG("enc_id 0x%x\n",enc_context->encode_id);
+
+    if(enc.param_type == OTZC_PARAM_IN) {
+        if(!enc_context->ker_req_data_addr) {
+            TDEBUG("allocate req data\n");
+            enc_context->ker_req_data_addr = kmalloc(OTZ_1K_SIZE, GFP_KERNEL);
+            if(!enc_context->ker_req_data_addr) {
+                TERR("kmalloc failed \n");
+                ret = -ENOMEM;
+                goto ret_encode_array;
+             }
+        }
+        TDEBUG("append encode data\n");
+
+        if((enc_context->enc_req_offset + enc.len <= OTZ_1K_SIZE) &&
+              (enc_context->enc_req_pos < OTZ_MAX_REQ_PARAMS)) {
+            if(copy_from_user(
+                enc_context->ker_req_data_addr + enc_context->enc_req_offset, 
+                enc.data , 
+                enc.len)) {
+                TERR("copy from user failed \n");
+                    ret = -EFAULT;
+                    goto ret_encode_array;
+            }
+            enc_context->enc_req_offset += enc.len;
+        
+            enc_context->meta[enc_context->enc_req_pos].type = OTZ_ENC_ARRAY;
+            enc_context->meta[enc_context->enc_req_pos].len = enc.len;
+            enc_context->enc_req_pos++;
+        }
+        else {
+            ret = -ENOMEM; /* Check this */
+            goto ret_encode_array;
+        }
+    }
+    else if(enc.param_type == OTZC_PARAM_OUT) {
+        if(!enc_context->ker_res_data_addr) {
+            enc_context->ker_res_data_addr = kmalloc(OTZ_1K_SIZE, GFP_KERNEL);
+            if(!enc_context->ker_res_data_addr) {
+                TERR("kmalloc failed \n");
+                ret = -ENOMEM;
+                goto ret_encode_array;
+            }
+        }
+        if((enc_context->enc_res_offset + enc.len <= OTZ_1K_SIZE) &&
+            (enc_context->enc_res_pos < 
+            (OTZ_MAX_RES_PARAMS + OTZ_MAX_REQ_PARAMS ))) {
+            if(enc.data != NULL) {
+                enc_context->meta[enc_context->enc_res_pos].usr_addr 
+                    = (u32)enc.data;
+            }
+            else {
+                enc_context->meta[enc_context->enc_res_pos].usr_addr = 0;
+            }
+            enc_context->enc_res_offset += enc.len;
+            enc_context->meta[enc_context->enc_res_pos].type = OTZ_ENC_ARRAY;
+            enc_context->meta[enc_context->enc_res_pos].len = enc.len;
+        
+            enc_context->enc_res_pos++;
+        }
+        else {
+            ret = -ENOMEM;/* Check this */
+            goto ret_encode_array;
+        }
+    }
+
+ret_encode_array:
+    if(copy_to_user(argp, &enc, sizeof(enc))){
+        TERR("copy from user failed \n");
+        return -EFAULT;
+    }
+
+return_func:
+    return ret;
+}
+
+/**
+ * @brief 
+ *
+ * Function to encode a memory reference (from kernel)
+ *
+ * @param private_data
+ * @param argp
+ *
+ * @return 
+ */
+static int otz_client_encode_mem_ref(void* private_data, void* argp)
+{
+    struct otz_client_encode_cmd enc;
+    int ret = 0, shared_mem_found = 0;
+    otzc_encode *enc_context;
+    otzc_session *session;
+    otzc_shared_mem* temp_shared_mem;
+
+    if(copy_from_user(&enc, argp, sizeof(enc))) {
+        TERR("copy from user failed \n");
+        ret = -EFAULT;
+        goto return_func;
+    }
+    
+    ret = otz_client_prepare_encode(private_data, &enc, &enc_context, &session);
+
+    if(ret){
+        goto return_func;
+    }
+    TDEBUG("enc_id 0x%x\n",enc_context->encode_id);
+    list_for_each_entry(temp_shared_mem, &session->shared_mem_list,s_head){
+        if(temp_shared_mem->index == (u32*)enc.data){
+            shared_mem_found = 1;
+            break;
+        }
+    }
+
+    if(!shared_mem_found) {
+		otzc_dev_file *temp_dev_file;
+		list_for_each_entry(temp_dev_file, &otzc_dev_file_head.dev_file_list,
+																		head) {
+			if(temp_dev_file->dev_file_id == (u32)private_data){
+				break;
+			}
+		}
+        list_for_each_entry(temp_shared_mem, 
+                    &temp_dev_file->dev_shared_mem_head.shared_mem_list ,head) {
+			TDEBUG("dev id : %d shrd_mem_index : 0x%x\n",
+					temp_dev_file->dev_file_id, temp_shared_mem->index);
+            if(temp_shared_mem->index == (u32*)enc.data){
+                shared_mem_found = 1;
+                break;
+            }
+        }
+    }
+
+    if(!shared_mem_found) {
+
+        TERR("shared memory not registered for \
+this session 0x%x\n", session->session_id);
+        ret = -EINVAL;
+        goto return_func;
+    }
+
+    if(enc.param_type == OTZC_PARAM_IN) {
+        if(!enc_context->ker_req_data_addr) {
+            enc_context->ker_req_data_addr = kmalloc(OTZ_1K_SIZE, GFP_KERNEL);
+            if(!enc_context->ker_req_data_addr) {
+                TERR("kmalloc failed \n");
+                ret = -ENOMEM;
+                goto ret_encode_array;
+             }
+        }
+    
+        if((enc_context->enc_req_offset + sizeof(u32) <= 
+              OTZ_1K_SIZE) &&
+              (enc_context->enc_req_pos < OTZ_MAX_REQ_PARAMS)) {
+            *((u32*)enc_context->ker_req_data_addr + 
+                enc_context->enc_req_offset) 
+                     = virt_to_phys(temp_shared_mem->k_addr+enc.offset);
+            enc_context->enc_req_offset += sizeof(u32);
+            enc_context->meta[enc_context->enc_req_pos].usr_addr
+                              = (u32)(temp_shared_mem->u_addr + enc.offset);
+            enc_context->meta[enc_context->enc_req_pos].type = OTZ_MEM_REF;
+            enc_context->meta[enc_context->enc_req_pos].len = enc.len;
+
+            enc_context->enc_req_pos++;
+        }
+        else {
+            ret = -ENOMEM; /* Check this */
+            goto ret_encode_array;
+        }
+    }
+    else if(enc.param_type == OTZC_PARAM_OUT) {
+        if(!enc_context->ker_res_data_addr) {
+            enc_context->ker_res_data_addr = kmalloc(OTZ_1K_SIZE, GFP_KERNEL);
+            if(!enc_context->ker_res_data_addr) {
+                TERR("kmalloc failed \n");
+                ret = -ENOMEM;
+                goto ret_encode_array;
+            }
+        }
+        if((enc_context->enc_res_offset + sizeof(u32)
+            <= OTZ_1K_SIZE) &&
+            (enc_context->enc_res_pos < 
+            (OTZ_MAX_RES_PARAMS + OTZ_MAX_REQ_PARAMS ))) {
+            *((u32*)enc_context->ker_res_data_addr + 
+                    enc_context->enc_res_offset) 
+                        = virt_to_phys(temp_shared_mem->k_addr + enc.offset);
+            enc_context->enc_res_offset += sizeof(u32);
+            enc_context->meta[enc_context->enc_res_pos].usr_addr
+                        = (u32)(temp_shared_mem->u_addr + enc.offset);
+            enc_context->meta[enc_context->enc_res_pos].type 
+                                                =  OTZ_MEM_REF;
+            enc_context->meta[enc_context->enc_res_pos].len = enc.len;
+            enc_context->enc_res_pos++;
+        }
+        else {
+            ret = -ENOMEM; /*Check this */
+            goto ret_encode_array;
+        }
+    }
+
+ret_encode_array:
+    if(copy_to_user(argp, &enc, sizeof(enc))){
+        TERR("copy from user failed \n");
+        return -EFAULT;
+    }
+
+return_func:
+    return ret;
+}
+
+
+/**
+* @brief Prepares and initializes the encode context.
+*
+* @param private_data
+* @param dec
+* @param pdec_context
+*
+* @return 
+*/
+static int otz_client_prepare_decode(void* private_data, 
+                                     struct otz_client_encode_cmd *dec,
+                                     otzc_encode **pdec_context) 
+{
+    otzc_dev_file *temp_dev_file;
+    otzc_service *temp_svc;
+    otzc_session *temp_ses;
+    otzc_encode *dec_context;
+    int  session_found = 0, enc_found = 0;
+    int ret = 0;
+    u32 dev_file_id = (u32)private_data;
+
+    list_for_each_entry(temp_dev_file, &otzc_dev_file_head.dev_file_list,
+                                                                    head) {
+        if(temp_dev_file->dev_file_id == dev_file_id){
+
+            list_for_each_entry(temp_svc, &temp_dev_file->services_list, head) {
+                if( temp_svc->service_id == dec->service_id) {
+                    list_for_each_entry(temp_ses, &temp_svc->sessions_list, 
+                                                                    head) {
+                        if(temp_ses->session_id == dec->session_id) {
+                            TDEBUG("enc cmd ses id %d \n",temp_ses->session_id);
+                            session_found = 1;
+                            break;        
+                        }
+                    }
+                    break;
+                }
+            }
+            break;
+        }
+    }
+
+    if(!session_found) {
+        TERR("session not found\n");
+        ret = -EINVAL;
+        goto return_func;
+    }
+
+    if(dec->encode_id != -1) {
+        list_for_each_entry(dec_context,&temp_ses->encode_list, head) {
+            if(dec_context->encode_id == dec->encode_id){
+                enc_found = 1;
+                break;        
+            }
+        }
+    }
+
+    if(!enc_found) {
+        ret =  -EINVAL;
+        goto return_func;
+    }
+
+    *pdec_context = dec_context;
+return_func:
+    return ret;
+}
+
+/**
+* @brief Function to decode uint32
+*
+* @param private_data
+* @param argp
+*
+* @return 
+*/
+static int otz_client_decode_uint32(void* private_data, void* argp)
+{
+    struct otz_client_encode_cmd dec;
+    int ret = 0;
+    otzc_encode *dec_context;
+
+
+    if(copy_from_user(&dec, argp, sizeof(dec))) {
+        TERR("copy from user failed \n");
+        ret = -EFAULT;
+        goto return_func;
+    }
+    
+    ret = otz_client_prepare_decode(private_data, &dec, &dec_context);
+
+    if(ret) {
+        goto return_func;
+    }
+
+    if((dec_context->dec_res_pos <= dec_context->enc_res_pos) && 
+      (dec_context->meta[dec_context->dec_res_pos].type
+                                                == OTZ_ENC_UINT32)){ 
+
+        if(dec_context->meta[dec_context->dec_res_pos].usr_addr) {
+            dec.data = 
+                (void*)dec_context->meta[dec_context->dec_res_pos].usr_addr;
+         }
+
+        *(u32*)dec.data =  *((u32*)(dec_context->ker_res_data_addr
+                                     + dec_context->dec_offset));
+        dec_context->dec_offset += sizeof(u32);
+        dec_context->dec_res_pos++;
+    }
+    if(copy_to_user(argp, &dec, sizeof(dec))){
+        TERR("copy to user failed \n");
+        return -EFAULT;
+    }
+
+return_func:
+    return ret;
+}
+
+/**
+* @brief Function to decode an array
+*
+* @param private_data
+* @param argp
+*
+* @return 
+*/
+static int otz_client_decode_array_space(void* private_data, void* argp)
+{
+    struct otz_client_encode_cmd dec;
+    int ret = 0;
+    otzc_encode *dec_context;
+
+
+    if(copy_from_user(&dec, argp, sizeof(dec))) {
+        TERR("copy from user failed \n");
+        ret = -EFAULT;
+        goto return_func;
+    }
+    
+    ret = otz_client_prepare_decode(private_data, &dec, &dec_context);
+
+    if(ret){
+        goto return_func;
+    }
+
+    if((dec_context->dec_res_pos <= dec_context->enc_res_pos) && 
+            (dec_context->meta[dec_context->dec_res_pos].type 
+                    == OTZ_ENC_ARRAY)) {
+        if (dec_context->meta[dec_context->dec_res_pos].len >=
+                    dec_context->meta[dec_context->dec_res_pos].ret_len) {
+            if(dec_context->meta[dec_context->dec_res_pos].usr_addr) {
+                dec.data = 
+                    (void*)dec_context->meta[dec_context->dec_res_pos].usr_addr;
+            }
+            if(copy_to_user(dec.data, 
+            dec_context->ker_res_data_addr + dec_context->dec_offset,
+            dec_context->meta[dec_context->dec_res_pos].ret_len)){
+                TERR("copy from user failed while copying array\n");
+                ret = -EFAULT;
+                goto return_func;
+            } 
+        }
+        else {
+            TERR("buffer length is small. Length required %d \
+and supplied length %d\n", 
+            dec_context->meta[dec_context->dec_res_pos].ret_len,
+            dec_context->meta[dec_context->dec_res_pos].len);
+            ret = -EFAULT; /* check this */
+            goto return_func;
+        }
+         
+        dec.len = dec_context->meta[dec_context->dec_res_pos].ret_len;
+        dec_context->dec_offset +=  
+                            dec_context->meta[dec_context->dec_res_pos].len;
+        dec_context->dec_res_pos++;
+    }
+    else if((dec_context->dec_res_pos <= dec_context->enc_res_pos) && 
+            (dec_context->meta[dec_context->dec_res_pos].type 
+                    == OTZ_MEM_REF)) {
+        if (dec_context->meta[dec_context->dec_res_pos].len >=
+                    dec_context->meta[dec_context->dec_res_pos].ret_len) {
+            dec.data = 
+                (void*)dec_context->meta[dec_context->dec_res_pos].usr_addr;
+        }
+        else {
+            TERR("buffer length is small. Length required %d \
+and supplied length %d\n", 
+            dec_context->meta[dec_context->dec_res_pos].ret_len,
+            dec_context->meta[dec_context->dec_res_pos].len);
+            ret = -EFAULT;/* Check this */
+            goto return_func;
+        }
+         
+        dec.len = dec_context->meta[dec_context->dec_res_pos].ret_len;
+        dec_context->dec_offset += sizeof(u32);
+        dec_context->dec_res_pos++;
+    }
+    
+    else {
+        TERR("invalid data type or decoder at wrong position\n");
+        ret = -EINVAL;
+        goto return_func;
+    }
+
+     if(copy_to_user(argp, &dec, sizeof(dec))){
+        TERR("copy from user failed \n");
+        ret = -EFAULT;
+       goto return_func;
+    }
+
+return_func:
+    return ret;
+}
+
+
+/**
+* @brief Gets the type of the decoded data 
+*
+* @param private_data
+* @param argp
+*
+* @return 
+*/
+static int otz_client_get_decode_type(void* private_data, void* argp)
+{
+    struct otz_client_encode_cmd dec;
+    int ret = 0;
+    otzc_encode *dec_context;
+
+
+    if(copy_from_user(&dec, argp, sizeof(dec))){
+        TERR("copy from user failed \n");
+        ret = -EFAULT;
+        goto return_func;
+    }
+    
+    ret = otz_client_prepare_decode(private_data, &dec, &dec_context);
+
+    if(ret){
+        goto return_func;
+    }
+
+    TDEBUG("decoder pos 0x%x and encoder pos 0x%x\n",
+        dec_context->dec_res_pos, dec_context->enc_res_pos);
+
+    if(dec_context->dec_res_pos <= dec_context->enc_res_pos) 
+        dec.data = (void*)dec_context->meta[dec_context->dec_res_pos].type;
+    else {
+        ret = -EINVAL; /* check this */
+        goto return_func;
+    }
+
+   if(copy_to_user(argp, &dec, sizeof(dec))){
+        TERR("copy to user failed \n");
+        ret = -EFAULT;
+        goto return_func;
+    }
+
+return_func:
+    return ret;
+}
+
+
+/**
+* @brief Allocates shared memory for client application
+*
+* @param private_data
+* @param argp
+*
+* @return 
+*/
+static int otz_client_shared_mem_alloc(void* private_data, void* argp)
+{
+    otzc_shared_mem* temp_shared_mem;
+    struct otz_session_shared_mem_info mem_info;
+
+    otzc_dev_file *temp_dev_file;
+    otzc_service *temp_svc;
+    otzc_session *temp_ses;
+
+    int  session_found = 0;
+    int ret = 0;
+    u32 dev_file_id = (u32)private_data;
+
+    if(copy_from_user(&mem_info, argp, sizeof(mem_info))){
+        TERR("copy from user failed \n");
+        ret = -EFAULT;
+        goto return_func;
+    }    
+
+    TDEBUG("service id 0x%x session id 0x%x user mem addr 0x%x \n", 
+            mem_info.service_id,
+            mem_info.session_id,
+            mem_info.user_mem_addr);
+    list_for_each_entry(temp_dev_file, &otzc_dev_file_head.dev_file_list,
+                                                                    head) {
+        if(temp_dev_file->dev_file_id == dev_file_id){
+
+            list_for_each_entry(temp_svc, &temp_dev_file->services_list, head) {
+                if( temp_svc->service_id == mem_info.service_id) {
+                    list_for_each_entry(temp_ses, &temp_svc->sessions_list, head) {
+                        if(temp_ses->session_id == mem_info.session_id) {
+                            session_found = 1;
+                            break;        
+                        }
+                    }
+                    break;
+                }
+            }
+            break;
+        }
+    }
+
+    if(!session_found) {
+        TERR("session not found\n");
+        ret = -EINVAL;
+        goto return_func;
+    }
+
+    list_for_each_entry(temp_shared_mem, &temp_dev_file->dev_shared_mem_head.shared_mem_list , 
+                                                                       head){
+        if(temp_shared_mem->index == (u32*)mem_info.user_mem_addr){
+            list_del(&temp_shared_mem->head);
+            temp_dev_file->dev_shared_mem_head.shared_mem_cnt--;
+            list_add_tail( &temp_shared_mem->s_head ,
+                                    &temp_ses->shared_mem_list);
+            break;
+        }
+    }
+return_func:
+    return ret;
+}
+
+/**
+ * @brief 
+ *
+ * Frees the shared memory for a particular session for the device
+ *
+ * @param private_data - Contains the device file ID
+ * @param argp - Contains shared memory information for the session
+ *
+ * @return 
+ */
+static int otz_client_shared_mem_free(void* private_data, void* argp)
+{
+    otzc_shared_mem* temp_shared_mem;
+    struct otz_session_shared_mem_info mem_info;
+
+    otzc_dev_file *temp_dev_file;
+    otzc_service *temp_svc;
+    otzc_session *temp_ses;
+
+    int  session_found = 0;
+    int ret = 0;
+    u32 dev_file_id = (u32)private_data;
+
+    if(copy_from_user(&mem_info, argp, sizeof(mem_info))){
+        TERR("copy from user failed \n");
+        ret = -EFAULT;
+        goto return_func;
+    }     
+
+    TDEBUG("service id 0x%x session id 0x%x user mem addr 0x%x \n", 
+            mem_info.service_id,
+            mem_info.session_id,
+            mem_info.user_mem_addr);
+    list_for_each_entry(temp_dev_file, &otzc_dev_file_head.dev_file_list,
+                                                                    head) {
+        if(temp_dev_file->dev_file_id == dev_file_id){
+
+            list_for_each_entry(temp_svc, &temp_dev_file->services_list, head) {
+                if( temp_svc->service_id == mem_info.service_id) {
+                    list_for_each_entry(temp_ses, &temp_svc->sessions_list, head) {
+                        if(temp_ses->session_id == mem_info.session_id) {
+                            session_found = 1;
+                            break;        
+                        }
+                    }
+                    break;
+                }
+            }
+            break;
+        }
+    }
+
+    if(!session_found) {
+        TERR("session not found\n");
+        ret = -EINVAL;
+        goto return_func;
+    }
+
+    list_for_each_entry(temp_shared_mem, &temp_ses->shared_mem_list,s_head){
+        if(temp_shared_mem->index == (u32*)mem_info.user_mem_addr){
+            list_del(&temp_shared_mem->s_head);
+
+            if(temp_shared_mem->k_addr)
+                free_pages((u32)temp_shared_mem->k_addr,
+                    get_order(ROUND_UP(temp_shared_mem->len, SZ_4K)));
+
+            if(temp_shared_mem)
+                kfree(temp_shared_mem);            
+            break;
+        }
+    }
+return_func:
+    return ret;
+}
+
+/**
+ * @brief Function which resolves the ioctl ID's and carries out
+ * 			the corresponding task.
+ *
+ * @param file
+ * @param cmd
+ * @param arg
+ *
+ * @return 
+ */
+static long otz_client_ioctl(struct file *file, unsigned cmd,
+        unsigned long arg)
+{
+    int ret = -EINVAL;
+    void *argp = (void __user *) arg;
+
+    switch (cmd) {
+    case OTZ_CLIENT_IOCTL_SEND_CMD_REQ: {
+        /* Only one client allowed here at a time */
+        mutex_lock(&send_cmd_lock);
+        ret = otz_client_send_cmd(file->private_data, argp);
+        mutex_unlock(&send_cmd_lock);
+
+        if (ret)
+            TDEBUG("failed otz_client_send_cmd: %d", ret);
+        break;
+    }
+
+    case OTZ_CLIENT_IOCTL_ENC_UINT32: {
+        /* Only one client allowed here at a time */
+        mutex_lock(&encode_cmd_lock);
+        ret = otz_client_encode_uint32(file->private_data, argp);
+        mutex_unlock(&encode_cmd_lock);
+        if (ret)
+            TDEBUG("failed otz_client_encode_cmd: %d", ret);
+        break;
+    }
+    case OTZ_CLIENT_IOCTL_DEC_UINT32: {
+        /* Only one client allowed here at a time */
+        mutex_lock(&decode_cmd_lock);
+        ret = otz_client_decode_uint32(file->private_data, argp);
+        mutex_unlock(&decode_cmd_lock);
+        if (ret)
+            TDEBUG("failed otz_client_decode_cmd: %d", ret);
+        break;
+    }
+    case OTZ_CLIENT_IOCTL_ENC_ARRAY: {
+        /* Only one client allowed here at a time */
+        mutex_lock(&encode_cmd_lock);
+        ret = otz_client_encode_array(file->private_data, argp);
+        mutex_unlock(&encode_cmd_lock);
+        if (ret)
+            TDEBUG("failed otz_client_encode_cmd: %d", ret);
+        break;
+    }
+    case OTZ_CLIENT_IOCTL_DEC_ARRAY_SPACE: {
+        /* Only one client allowed here at a time */
+        mutex_lock(&decode_cmd_lock);
+        ret = otz_client_decode_array_space(file->private_data, argp);
+        mutex_unlock(&decode_cmd_lock);
+        if (ret)
+            TDEBUG("failed otz_client_decode_cmd: %d", ret);
+        break;
+    }
+    case OTZ_CLIENT_IOCTL_ENC_MEM_REF: {
+        /* Only one client allowed here at a time */
+        mutex_lock(&encode_cmd_lock);
+        ret = otz_client_encode_mem_ref(file->private_data, argp);
+        mutex_unlock(&encode_cmd_lock);
+        if (ret)
+            TDEBUG("failed otz_client_encode_cmd: %d", ret);
+        break;
+    }   
+    case OTZ_CLIENT_IOCTL_ENC_ARRAY_SPACE: {
+        /* Only one client allowed here at a time */
+        mutex_lock(&encode_cmd_lock);
+        ret = otz_client_encode_mem_ref(file->private_data, argp);
+        mutex_unlock(&encode_cmd_lock);
+        if (ret)
+            TDEBUG("failed otz_client_encode_cmd: %d", ret);
+        break;
+    }   
+    case OTZ_CLIENT_IOCTL_GET_DECODE_TYPE: {
+        /* Only one client allowed here at a time */
+        mutex_lock(&decode_cmd_lock);
+        ret = otz_client_get_decode_type(file->private_data, argp);
+        mutex_unlock(&decode_cmd_lock);
+        if (ret)
+            TDEBUG("failed otz_client_decode_cmd: %d", ret);
+        break;
+    }   
+    case OTZ_CLIENT_IOCTL_SES_OPEN_REQ: {
+        /* Only one client allowed here at a time */
+        mutex_lock(&ses_open_lock);
+        ret = otz_client_session_open(file->private_data, argp);
+        mutex_unlock(&ses_open_lock);
+        if (ret)
+            TDEBUG("failed otz_client_session_open: %d", ret);
+        break;
+    }
+    case OTZ_CLIENT_IOCTL_SES_CLOSE_REQ: {
+        /* Only one client allowed here at a time */
+        mutex_lock(&ses_close_lock);
+        ret = otz_client_session_close(file->private_data, argp);
+        mutex_unlock(&ses_close_lock);
+        if (ret)
+            TDEBUG("failed otz_client_session_close: %d", ret);
+        break;
+    }
+    case OTZ_CLIENT_IOCTL_SHR_MEM_ALLOCATE_REQ: {
+        /* Only one client allowed here at a time */
+        mutex_lock(&mem_alloc_lock);
+        ret = otz_client_shared_mem_alloc(file->private_data, argp);
+        mutex_unlock(&mem_alloc_lock);
+        if (ret)
+            TDEBUG("failed otz_client_shared_mem_alloc: %d", ret);
+        break;
+    }
+    case OTZ_CLIENT_IOCTL_SHR_MEM_FREE_REQ: {
+        /* Only one client allowed here at a time */
+        mutex_lock(&mem_free_lock);
+        ret = otz_client_shared_mem_free(file->private_data, argp);
+        mutex_unlock(&mem_free_lock);
+        if (ret)
+            TDEBUG("failed otz_client_shared_mem_free: %d", ret);
+        break;
+    }
+    case OTZ_CLIENT_IOCTL_OPERATION_RELEASE: {
+        ret = otz_client_operation_release(file->private_data, argp);
+        if (ret)
+            TDEBUG("failed operation release: %d", ret);
+        break;
+    }
+    default:
+        return -EINVAL;
+    }
+    return ret;
+}
+
+/**
+ * @brief This function opens a service for a client application 
+ *
+ * @param inode
+ * @param file
+ *
+ * @return 
+ */
+static int otz_client_open(struct inode *inode, struct file *file)
+{
+    int ret;
+    otzc_dev_file *new_dev;
+
+    device_file_cnt++;
+    file->private_data = (void*)device_file_cnt;
+
+    new_dev = (otzc_dev_file*)kmalloc(sizeof(otzc_dev_file), GFP_KERNEL);
+    if(!new_dev){
+       TERR("kmalloc failed for new dev file allocation\n");
+       ret = -ENOMEM;
+       goto ret_func;
+    }
+    new_dev->dev_file_id = device_file_cnt;
+    new_dev->service_cnt = 0;
+    INIT_LIST_HEAD(&new_dev->services_list);
+    
+	memset(&new_dev->dev_shared_mem_head, 0, sizeof(otzc_shared_mem_head));
+    new_dev->dev_shared_mem_head.shared_mem_cnt = 0;
+    INIT_LIST_HEAD(&new_dev->dev_shared_mem_head.shared_mem_list);
+
+
+    list_add(&new_dev->head, &otzc_dev_file_head.dev_file_list);
+    otzc_dev_file_head.dev_file_cnt++;
+
+    if((ret = otz_client_service_init(new_dev, OTZ_SVC_GLOBAL)) != 0) {
+        goto ret_func;
+    } else if((ret = otz_client_service_init(new_dev, OTZ_SVC_ECHO)) != 0) {
+        goto ret_func;
+    } else if((ret = otz_client_service_init(new_dev, OTZ_SVC_CRYPT)) != 0) {
+        goto ret_func;
+    } else if((ret = otz_client_service_init(new_dev, OTZ_SVC_MUTEX_TEST)) != 0) {
+        goto ret_func;
+    } else if((ret = otz_client_service_init(new_dev, OTZ_SVC_VIRTUAL_KEYBOARD)) != 0) {
+        goto ret_func;
+    } else if((ret = otz_client_service_init(new_dev, OTZ_SVC_DRM)) != 0) {
+        goto ret_func;
+    }
+
+#ifdef OTZONE_ASYNC_NOTIFY_SUPPORT
+    if(!notify_data){
+       notify_data = (struct otzc_notify_data*)kmalloc(
+                                        sizeof(struct otzc_notify_data),
+                                        GFP_KERNEL);
+       if(!notify_data){
+           TERR("kmalloc failed for notification data\n");
+           ret = -ENOMEM;
+           goto ret_func;
+       }
+    }
+
+
+    ret = otz_smc_call(new_dev->dev_file_id, OTZ_SVC_GLOBAL, 
+        OTZ_GLOBAL_CMD_ID_REGISTER_NOTIFY_MEMORY, 
+        0, 0,
+        notify_data, sizeof(struct otzc_notify_data), NULL, 
+        0, NULL, NULL, NULL, NULL);      
+
+    if(ret != SMC_SUCCESS) {
+        TERR("Shared memory registration for \
+secure world notification failed\n");
+        goto ret_func;
+    }
+#endif
+ret_func:
+    return ret;
+}
+
+/**
+ * @brief This function releases the service associated with a client 
+ *
+ * @param inode
+ * @param file
+ *
+ * @return 
+ */
+static int otz_client_release(struct inode *inode, struct file *file)
+{
+        u32 dev_file_id = (u32)file->private_data;
+#ifdef OTZONE_ASYNC_NOTIFY_SUPPORT
+    int ret;
+    ret = otz_smc_call(dev_file_id, OTZ_SVC_GLOBAL, 
+        OTZ_GLOBAL_CMD_ID_UNREGISTER_NOTIFY_MEMORY, 
+        0, 0,
+        NULL, 0, NULL, 
+        0, NULL, NULL, NULL, NULL);      
+
+    if(ret != SMC_SUCCESS) {
+        TERR("Shared memory un-registration for \
+secure world notification failed\n");
+    }
+
+#endif
+
+    TDEBUG("otz_client_release\n");
+    otz_client_service_exit(file->private_data);
+    if(list_empty(&otzc_dev_file_head.dev_file_list)){
+#ifdef OTZONE_ASYNC_NOTIFY_SUPPORT
+        kfree(notify_data);
+        notify_data = NULL;
+#endif
+    }
+    return 0;
+}
+
+/**
+ * @brief 
+ *
+ * @return 
+ */
+static int otz_client_smc_init(void)
+{
+    u32 ctr;
+
+    asm volatile("mrc p15, 0, %0, c0, c0, 1" : "=r" (ctr));
+    cacheline_size =  4 << ((ctr >> 16) & 0xf);
+
+    return 0;
+}
+
+
+/**
+ * @brief 
+ */
+static const struct file_operations otz_client_fops = {
+        .owner = THIS_MODULE,
+        .unlocked_ioctl = otz_client_ioctl,
+        .open = otz_client_open,
+        .mmap = otz_client_mmap,
+        .release = otz_client_release
+};
+
+/**
+ * @brief Initializes the services and sessions for a client application
+ *
+ * @return 
+ */
+static int otz_client_init(void)
+{
+    int ret_code = 0;
+    struct device *class_dev;
+
+    TDEBUG("open otzclient init");
+    otz_client_smc_init();
+
+    ret_code = alloc_chrdev_region(&otz_client_device_no, 0, 1,
+                                                    OTZ_CLIENT_DEV);
+    if (ret_code < 0) {
+        TERR("alloc_chrdev_region failed %d", ret_code);
+        return ret_code;
+    }
+
+    driver_class = class_create(THIS_MODULE, OTZ_CLIENT_DEV);
+    if (IS_ERR(driver_class)) {
+        ret_code = -ENOMEM;
+        TERR("class_create failed %d", ret_code);
+        goto unregister_chrdev_region;
+    }
+
+    class_dev = device_create(driver_class, NULL, otz_client_device_no, NULL,
+            OTZ_CLIENT_DEV);
+    if (!class_dev) {
+        TERR("class_device_create failed %d", ret_code);
+        ret_code = -ENOMEM;
+        goto class_destroy;
+    }
+
+    cdev_init(&otz_client_cdev, &otz_client_fops);
+    otz_client_cdev.owner = THIS_MODULE;
+
+    ret_code = cdev_add(&otz_client_cdev,
+                        MKDEV(MAJOR(otz_client_device_no), 0), 1);
+    if (ret_code < 0) {
+        TERR("cdev_add failed %d", ret_code);
+        goto class_device_destroy;
+    }
+
+/* Initialize structure for services and sessions*/
+    TDEBUG("Initializing list for services\n");
+    memset(&otzc_dev_file_head, 0, sizeof(otzc_dev_file_head));
+    otzc_dev_file_head.dev_file_cnt = 0;
+    INIT_LIST_HEAD(&otzc_dev_file_head.dev_file_list);
+
+#ifdef OTZONE_ASYNC_NOTIFY_SUPPORT
+    register_secure_notify_handler(ipi_secure_notify);
+#endif
+    goto return_fn;
+
+class_device_destroy:
+    device_destroy(driver_class, otz_client_device_no);
+class_destroy:
+    class_destroy(driver_class);
+unregister_chrdev_region:
+    unregister_chrdev_region(otz_client_device_no, 1);
+return_fn:
+    return ret_code;
+}
+
+/**
+ * @brief Exits from the running client application 
+ */
+static void otz_client_exit(void)
+{
+    TDEBUG("otz_client exit");
+
+#ifdef OTZONE_ASYNC_NOTIFY_SUPPORT
+    unregister_secure_notify_handler();
+#endif
+    device_destroy(driver_class, otz_client_device_no);
+    class_destroy(driver_class);
+    unregister_chrdev_region(otz_client_device_no, 1);
+}
+
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Test  <sierraware.org>");
+MODULE_DESCRIPTION("Sierraware TrustZone Communicator");
+MODULE_VERSION("1.00");
+
+module_init(otz_client_init);
+
+module_exit(otz_client_exit);
diff --git a/drivers/sechw/trustzone/otz_common.h b/drivers/sechw/trustzone/otz_common.h
new file mode 100644
index 0000000..b3d1b1e
--- /dev/null
+++ b/drivers/sechw/trustzone/otz_common.h
@@ -0,0 +1,119 @@
+/* 
+ * OpenVirtualization: 
+ * For additional details and support contact developer@sierraware.com.
+ * Additional documentation can be found at www.openvirtualization.org
+ * 
+ * Copyright (C) 2011 SierraWare
+ * 
+ * This library is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ * 
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ * 
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ * 
+ * Trustzone client driver defintions.
+ */
+
+#ifndef __OTZ_COMMON_H_
+#define __OTZ_COMMON_H_
+
+
+#define OTZ_MAX_REQ_PARAMS  12
+#define OTZ_MAX_RES_PARAMS  4
+#define OTZ_1K_SIZE 1024
+
+/**
+ * @brief SMC return values
+ */
+/*enum otz_smc_ret {
+    SMC_ENOMEM = -5,
+    SMC_EOPNOTSUPP = -4,
+    SMC_EINVAL_ADDR = -3,
+    SMC_EINVAL_ARG = -2,
+    SMC_ERROR = -1,
+    SMC_INTERRUPTED = 1,
+    SMC_PENDING = 2,
+    SMC_SUCCESS = 0
+};
+*/
+
+
+/**
+ * @brief Command status 
+ */
+enum otz_cmd_status {
+    OTZ_STATUS_INCOMPLETE = 0,
+    OTZ_STATUS_COMPLETE,
+    OTZ_STATUS_MAX  = 0x7FFFFFFF
+};
+
+/**
+ * @brief Command type
+ */
+enum otz_cmd_type {
+    OTZ_CMD_TYPE_INVALID = 0,
+    OTZ_CMD_TYPE_NS_TO_SECURE,
+    OTZ_CMD_TYPE_SECURE_TO_NS,
+    OTZ_CMD_TYPE_SECURE_TO_SECURE,
+    OTZ_CMD_TYPE_MAX  = 0x7FFFFFFF
+};
+
+/**
+ * @brief Parameters type
+ */
+enum otzc_param_type {
+    OTZC_PARAM_IN = 0,
+    OTZC_PARAM_OUT
+};
+
+/**
+ * @brief Shared memory for Notification
+ */
+struct otzc_notify_data {
+    int dev_file_id;
+    int service_id;
+    int client_pid;
+    int session_id;
+    int enc_id;
+};
+
+/**
+ * @brief Metadata used for encoding/decoding
+ */
+struct otzc_encode_meta {
+    int type;
+    int len;
+    unsigned int usr_addr;
+    int ret_len;
+};
+
+/**
+ * @brief SMC command structure
+ */
+struct otz_smc_cmd {
+    unsigned int    id;
+    unsigned int    context;
+    unsigned int    enc_id;
+   
+    unsigned int    src_id;
+    unsigned int    src_context;
+
+    unsigned int    req_buf_len;
+    unsigned int    resp_buf_len;
+    unsigned int    ret_resp_buf_len;
+    unsigned int    cmd_status;
+    unsigned int    req_buf_phys;
+    unsigned int    resp_buf_phys;
+    unsigned int    meta_data_phys;
+    unsigned int    dev_file_id;
+};
+
+#endif /* __OTZ_COMMON_H_ */    
diff --git a/drivers/sechw/trustzone/otz_id.h b/drivers/sechw/trustzone/otz_id.h
new file mode 100644
index 0000000..5500586
--- /dev/null
+++ b/drivers/sechw/trustzone/otz_id.h
@@ -0,0 +1,178 @@
+/* 
+ * OpenVirtualization: 
+ * For additional details and support contact developer@sierraware.com.
+ * Additional documentation can be found at www.openvirtualization.org
+ * 
+ * Copyright (C) 2011 SierraWare
+ * 
+ * This library is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ * 
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ * 
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ * 
+ * Trustzone client driver defintions.
+ */
+
+#ifndef __OTZ_ID_H_
+#define __OTZ_ID_H_
+
+#define SMC_ENOMEM          7
+#define SMC_EOPNOTSUPP      6
+#define SMC_EINVAL_ADDR     5
+#define SMC_EINVAL_ARG      4
+#define SMC_ERROR           3
+#define SMC_INTERRUPTED     2
+#define SMC_PENDING         1
+#define SMC_SUCCESS         0
+
+/**
+ * @brief Encoding data type
+ */
+enum otz_enc_data_type {
+    OTZ_ENC_INVALID_TYPE = 0,
+    OTZ_ENC_UINT32,
+    OTZ_ENC_ARRAY,
+    OTZ_MEM_REF,
+    OTZ_SECURE_MEM_REF
+};
+
+/**
+ * @brief Service identifiers
+ */
+enum otz_svc_id {
+    OTZ_SVC_INVALID = 0x0,
+    OTZ_SVC_GLOBAL,
+    OTZ_SVC_ECHO,
+    OTZ_SVC_DRM,
+    OTZ_SVC_CRYPT,
+    OTZ_SVC_MUTEX_TEST,
+    OTZ_SVC_VIRTUAL_KEYBOARD
+};
+
+/**
+ * @brief Command ID's for global service
+ */
+enum otz_global_cmd_id {
+    OTZ_GLOBAL_CMD_ID_INVALID = 0x0,
+    OTZ_GLOBAL_CMD_ID_BOOT_ACK,
+    OTZ_GLOBAL_CMD_ID_OPEN_SESSION,
+    OTZ_GLOBAL_CMD_ID_CLOSE_SESSION,
+#ifdef OTZONE_ASYNC_NOTIFY_SUPPORT
+    OTZ_GLOBAL_CMD_ID_REGISTER_NOTIFY_MEMORY,
+    OTZ_GLOBAL_CMD_ID_UNREGISTER_NOTIFY_MEMORY,
+#endif
+    OTZ_GLOBAL_CMD_ID_RESUME_ASYNC_TASK,
+    OTZ_GLOBAL_CMD_ID_UNKNOWN         = 0x7FFFFFFE,
+    OTZ_GLOBAL_CMD_ID_MAX             = 0x7FFFFFFF
+};
+
+/**
+ * @brief Enums used for crypto service task
+ */
+enum otz_crypt_cmd_id {
+	OTZ_CRYPT_CMD_ID_INVALID = 0x0,
+    OTZ_CRYPT_CMD_ID_LOAD_LIBS,
+    OTZ_CRYPT_CMD_ID_UNLOAD_LIBS,
+    OTZ_CRYPT_CMD_ID_ENCRYPT,
+    OTZ_CRYPT_CMD_ID_DECRYPT,
+    OTZ_CRYPT_CMD_ID_MD5,
+    OTZ_CRYPT_CMD_ID_SHA1,
+    OTZ_CRYPT_CMD_ID_SHA224,
+    OTZ_CRYPT_CMD_ID_SHA256,
+    OTZ_CRYPT_CMD_ID_SHA384,
+    OTZ_CRYPT_CMD_ID_SHA512,
+    OTZ_CRYPT_CMD_ID_HMAC_MD5,
+    OTZ_CRYPT_CMD_ID_HMAC_SHA1,
+    OTZ_CRYPT_CMD_ID_HMAC_SHA224,
+    OTZ_CRYPT_CMD_ID_HMAC_SHA256,
+    OTZ_CRYPT_CMD_ID_HMAC_SHA384,
+    OTZ_CRYPT_CMD_ID_HMAC_SHA512,
+    OTZ_CRYPT_CMD_ID_CIPHER_AES_128_CBC,
+    OTZ_CRYPT_CMD_ID_CIPHER_AES_128_ECB,
+    OTZ_CRYPT_CMD_ID_CIPHER_AES_128_CTR,
+    OTZ_CRYPT_CMD_ID_CIPHER_AES_128_XTS,
+    OTZ_CRYPT_CMD_ID_CIPHER_DES_ECB,
+    OTZ_CRYPT_CMD_ID_CIPHER_DES_CBC,
+    OTZ_CRYPT_CMD_ID_CIPHER_DES3_ECB,
+	OTZ_CRYPT_CMD_ID_CIPHER_DES3_CBC,
+    OTZ_CRYPT_CMD_ID_UNKNOWN = 0x7FFFFFFE,
+    OTZ_CRYPT_CMD_ID_MAX = 0x7FFFFFFF
+};
+
+#define MD5_OUTPUT_LEN 16
+#define SHA1_OUTPUT_LEN 20
+#define SHA224_OUTPUT_LEN 28
+#define SHA256_OUTPUT_LEN 32
+#define SHA384_OUTPUT_LEN 48
+#define SHA512_OUTPUT_LEN 64
+#define HMAC_KEY_LEN 16
+#define HMAC_DATA_LEN 50
+#define HMAC_OUTPUT_LEN 16
+#define AES_128_CBC_LEN 16
+#define AES_128_ECB_LEN 16
+#define AES_128_CTR_LEN 16
+#define AES_128_XTS_LEN 16
+#define DES_ECB_LEN 8
+#define DES_CBC_LEN 8
+#define DES3_CBC_LEN 8
+#define DES3_ECB_LEN 8
+#define CIPHER_ENCRYPT 2
+#define CIPHER_DECRYPT 1
+#define IGNORE_PARAM  0xff
+
+
+/**
+ * @brief Enums used for mutex test task
+ *
+ **/
+enum open_tz_mutex_test_cmd_id {
+    OTZ_MUTEX_TEST_CMD_ID_INVALID = 0x0,
+    OTZ_MUTEX_TEST_CMD_ID_TEST,
+    OTZ_MUTEX_TEST_CMD_ID_UNKNOWN = 0x7FFFFFFE,
+    OTZ_MUTEX_TEST_CMD_ID_MAX = 0x7FFFFFFF
+};
+
+
+/**
+ * @brief Enums used for echo service task
+ */
+enum otz_echo_cmd_id {
+    OTZ_ECHO_CMD_ID_INVALID = 0x0,
+    OTZ_ECHO_CMD_ID_SEND_CMD,
+    OTZ_ECHO_CMD_ID_SEND_CMD_SHARED_BUF,
+    OTZ_ECHO_CMD_ID_SEND_CMD_ARRAY_SPACE,
+    OTZ_ECHO_CMD_ID_IPI_SEND_CMD,
+#ifdef OTZONE_ASYNC_NOTIFY_SUPPORT
+    OTZ_ECHO_CMD_ID_TEST_ASYNC_SEND_CMD,
+#endif
+    OTZ_ECHO_CMD_ID_UNKNOWN         = 0x7FFFFFFE,
+    OTZ_ECHO_CMD_ID_MAX             = 0x7FFFFFFF
+};
+
+/**
+ * @brief 
+ */
+enum otz_virtual_keyboard_cmd_id {
+    OTZ_VIRTUAL_KEYBOARD_CMD_ID_INVALID = 0x0,
+    OTZ_VIRTUAL_CMD_ID_PLAY_MEDIA,
+    OTZ_VIRTUAL_KEYBOARD_CMD_ID_SHOW
+};
+
+/**
+ * @brief 
+ */
+enum otz_drm_cmd_id {
+    OTZ_DRM_CMD_ID_INVALID = 0x0,
+    OTZ_DRM_CMD_ID_SEND_CMD,
+    OTZ_DRM_CMD_ID_SEND_CMD_SHARED_BUF
+};
+#endif /* __OPEN_OTZ_ID_H_ */   
diff --git a/drivers/sechw/trustzone/smc_id.h b/drivers/sechw/trustzone/smc_id.h
new file mode 100644
index 0000000..2c7387b
--- /dev/null
+++ b/drivers/sechw/trustzone/smc_id.h
@@ -0,0 +1,66 @@
+/* 
+ * OpenVirtualization: 
+ * For additional details and support contact developer@sierraware.com.
+ * Additional documentation can be found at www.openvirtualization.org
+ * 
+ * Copyright (C) 2011 SierraWare
+ * 
+ * This library is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ * 
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ * 
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ * 
+ * Header file for SMC identifiers 
+ *
+ */
+
+#ifndef __OTZ_SMC_ID_H__
+#define __OTZ_SMC_ID_H__
+
+
+/* SMC Identifiers for non-secure world functions */
+#define CALL_TRUSTZONE_API  0x1
+#if defined( CONFIG_S5PV310_BOARD) || defined (CONFIG_MVV4412_BOARD)
+/* Based arch/arm/mach-exynos/include/mach/smc.h */
+#define SMC_CMD_INIT		(-1)
+#define SMC_CMD_INFO		(-2)
+/* For Power Management */
+#define SMC_CMD_SLEEP		(-3)
+#define SMC_CMD_CPU1BOOT	(-4)
+#define SMC_CMD_CPU0AFTR	(-5)
+/* For CP15 Access */
+#define SMC_CMD_C15RESUME	(-11)
+/* For L2 Cache Access */
+#define SMC_CMD_L2X0CTRL	(-21)
+#define SMC_CMD_L2X0SETUP1	(-22)
+#define SMC_CMD_L2X0SETUP2	(-23)
+#define SMC_CMD_L2X0INVALL	(-24)
+#define SMC_CMD_L2X0DEBUG	(-25)
+#define SMC_CMD_L2X0FLUSHALL (-26)
+#define SMC_CMD_L2X0CLEANALL (-27)
+#define SMC_CMD_L2X0FLUSHRANGE (-28)
+/* For Framebuffer */
+#define SMC_CMD_INIT_SECURE_WINDOW (-29)
+
+#define SMC_CP15_REG			(-102)
+#define SMC_CP15_AUX_CTRL		0x1
+#define SMC_CP15_L2_PREFETCH	0x2
+#define SMC_CACHE_CTRL			0x3
+#endif
+
+#ifdef CONFIG_ZYNQ7_BOARD
+#define SMC_CMD_CPU1BOOT       (-4)
+#define SMC_CMD_SECURE_READ		(-30)
+#define SMC_CMD_SECURE_WRITE	(-31)
+#endif
+
+#endif /* __OTZ_SMC_ID__ */
diff --git a/drivers/sechw/trustzone/sw_common_types.h b/drivers/sechw/trustzone/sw_common_types.h
new file mode 100644
index 0000000..c97d091
--- /dev/null
+++ b/drivers/sechw/trustzone/sw_common_types.h
@@ -0,0 +1,31 @@
+/* 
+ * OpenVirtualization: 
+ * For additional details and support contact developer@sierraware.com.
+ * Additional documentation can be found at www.openvirtualization.org
+ * 
+ * Copyright (C) 2011 SierraWare
+ *
+ * This file is part of the Sierraware OpenTrustPlatform.
+ *
+ * Sierraware OpenTrustPlatform is free software: you can redistribute it 
+ * and/or modify it under the terms of the GNU Lesser General Public License 
+ * as published by the Free Software Foundation, either version 3 of the
+ * License, or (at your option) any later version.
+ *
+ * Sierraware OpenTrustPlatform is distributed in the hope that it 
+ * will be useful, but WITHOUT ANY WARRANTY; without even the implied
+ * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public License
+ * along with Sierraware OpenTrustPlatform.  If not, 
+ * see <http://www.gnu.org/licenses/>.
+ * 
+ * common types declaration
+ */
+
+#ifndef SW_COMMON_TYPES_H
+#define SW_COMMON_TYPES_H
+#include <sw_config.h>
+typedef unsigned int size_t;
+#endif
diff --git a/drivers/sechw/trustzone/sw_config.h b/drivers/sechw/trustzone/sw_config.h
new file mode 100644
index 0000000..9d598ed
--- /dev/null
+++ b/drivers/sechw/trustzone/sw_config.h
@@ -0,0 +1,16 @@
+/* 
+ * config variable declaration
+ */
+
+#ifndef SW_CONFIG
+#define SW_CONFIG
+#if defined(__GNUC__) && \
+        defined(__GNUC_MINOR__) && \
+defined(__GNUC_PATCHLEVEL__) && \
+((__GNUC__ * 10000 + __GNUC_MINOR__ * 100 + __GNUC_PATCHLEVEL__)) \
+> 40600
+#define USE_ARCH_EXTENSION_SEC 1
+#else
+#define USE_ARCH_EXTENSION_SEC 0
+#endif
+#endif
-- 
1.9.1


