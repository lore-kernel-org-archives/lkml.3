Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab3LKMnW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:43:22 -0500
Received: from mga09.intel.com ([134.134.136.24]:4721 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902Ab3LKMnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:43:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="422887629"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v0 66/71] perf tools: Add Intel PT packet decoder
Date: Wed, 11 Dec 2013 14:37:18 +0200
Message-Id: <1386765443-26966-67-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add support for decoding Intel Processor Trace
packets.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Makefile.perf                           |   2 +
 .../util/intel-pt-decoder/intel-pt-pkt-decoder.c   | 404 +++++++++++++++++++++
 .../util/intel-pt-decoder/intel-pt-pkt-decoder.h   |  68 ++++
 3 files changed, 474 insertions(+)
 create mode 100644 tools/perf/util/intel-pt-decoder/intel-pt-pkt-decoder.c
 create mode 100644 tools/perf/util/intel-pt-decoder/intel-pt-pkt-decoder.h

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 6ef50f9..a006fac 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -294,6 +294,7 @@ LIB_H += util/unwind.h
 LIB_H += util/vdso.h
 LIB_H += util/tsc.h
 LIB_H += util/itrace.h
+LIB_H += util/intel-pt-decoder/intel-pt-pkt-decoder.h
 LIB_H += ui/helpline.h
 LIB_H += ui/progress.h
 LIB_H += ui/util.h
@@ -374,6 +375,7 @@ LIB_OBJS += $(OUTPUT)util/srcline.o
 LIB_OBJS += $(OUTPUT)util/data.o
 LIB_OBJS += $(OUTPUT)util/tsc.o
 LIB_OBJS += $(OUTPUT)util/itrace.o
+LIB_OBJS += $(OUTPUT)util/intel-pt-decoder/intel-pt-pkt-decoder.o
 
 LIB_OBJS += $(OUTPUT)ui/setup.o
 LIB_OBJS += $(OUTPUT)ui/helpline.o
diff --git a/tools/perf/util/intel-pt-decoder/intel-pt-pkt-decoder.c b/tools/perf/util/intel-pt-decoder/intel-pt-pkt-decoder.c
new file mode 100644
index 0000000..c15eaf3
--- /dev/null
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-pkt-decoder.c
@@ -0,0 +1,404 @@
+/*
+ * intel_pt_pkt_decoder.c: Intel Processor Trace support
+ * Copyright (c) 2013, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+
+#include <stdio.h>
+#include <string.h>
+#include <endian.h>
+#include <byteswap.h>
+
+#include "intel-pt-pkt-decoder.h"
+
+#define BIT(n)		(1 << (n))
+
+#define BIT63		((uint64_t)1 << 63)
+
+#if __BYTE_ORDER == __BIG_ENDIAN
+#define le16_to_cpu bswap_16
+#define le32_to_cpu bswap_32
+#define le64_to_cpu bswap_64
+#define memcpy_le64(d, s, n) do { \
+	memcpy((d), (s), (n));    \
+	*(d) = le64_to_cpu(*(d)); \
+} while (0)
+#else
+#define le16_to_cpu
+#define le32_to_cpu
+#define le64_to_cpu
+#define memcpy_le64 memcpy
+#endif
+
+static const char * const packet_name[] = {
+	[INTEL_PT_BAD]		= "Bad Packet!",
+	[INTEL_PT_PAD]		= "PAD",
+	[INTEL_PT_TNT]		= "TNT",
+	[INTEL_PT_TIP_PGD]	= "TIP.PGD",
+	[INTEL_PT_TIP_PGE]	= "TIP.PGE",
+	[INTEL_PT_TSC]		= "TSC",
+	[INTEL_PT_MODE_EXEC]	= "MODE.Exec",
+	[INTEL_PT_MODE_TSX]	= "MODE.TSX",
+	[INTEL_PT_TIP]		= "TIP",
+	[INTEL_PT_FUP]		= "FUP",
+	[INTEL_PT_PSB]		= "PSB",
+	[INTEL_PT_PSBEND]	= "PSBEND",
+	[INTEL_PT_CBR]		= "CBR",
+	[INTEL_PT_PIP]		= "PIP",
+	[INTEL_PT_OVF]		= "OVF",
+};
+
+const char *intel_pt_pkt_name(enum intel_pt_pkt_type type)
+{
+	return packet_name[type];
+}
+
+static int intel_pt_get_long_tnt(const unsigned char *buf, size_t len,
+				 struct intel_pt_pkt *packet)
+{
+	uint64_t payload;
+	int count;
+
+	if (len < 8)
+		return INTEL_PT_NEED_MORE_BYTES;
+
+	payload = le64_to_cpu(*(uint64_t *)buf);
+
+	for (count = 47; count; count--) {
+		if (payload & BIT63)
+			break;
+		payload <<= 1;
+	}
+
+	packet->type = INTEL_PT_TNT;
+	packet->count = count;
+	packet->payload = payload << 1;
+	return 8;
+}
+
+static int intel_pt_get_pip(const unsigned char *buf, size_t len,
+			    struct intel_pt_pkt *packet)
+{
+	uint64_t payload = 0;
+
+	if (len < 8)
+		return INTEL_PT_NEED_MORE_BYTES;
+
+	packet->type = INTEL_PT_PIP;
+	memcpy_le64(&payload, buf + 2, 6);
+	packet->payload = payload >> 1;
+
+	return 8;
+}
+
+static int intel_pt_get_cbr(const unsigned char *buf, size_t len,
+			    struct intel_pt_pkt *packet)
+{
+	if (len < 4)
+		return INTEL_PT_NEED_MORE_BYTES;
+	packet->type = INTEL_PT_CBR;
+	packet->payload = buf[2];
+	return 4;
+}
+
+static int intel_pt_get_ovf(struct intel_pt_pkt *packet)
+{
+	packet->type = INTEL_PT_OVF;
+	return 2;
+}
+
+static int intel_pt_get_psb(const unsigned char *buf, size_t len,
+			    struct intel_pt_pkt *packet)
+{
+	int i;
+
+	if (len < 16)
+		return INTEL_PT_NEED_MORE_BYTES;
+
+	for (i = 2; i < 16; i += 2) {
+		if (buf[i] != 2 || buf[i + 1] != 0x82)
+			return INTEL_PT_BAD_PACKET;
+	}
+
+	packet->type = INTEL_PT_PSB;
+	return 16;
+}
+
+static int intel_pt_get_psbend(struct intel_pt_pkt *packet)
+{
+	packet->type = INTEL_PT_PSBEND;
+	return 2;
+}
+
+static int intel_pt_get_pad(struct intel_pt_pkt *packet)
+{
+	packet->type = INTEL_PT_PAD;
+	return 1;
+}
+
+static int intel_pt_get_ext(const unsigned char *buf, size_t len,
+			    struct intel_pt_pkt *packet)
+{
+	if (len < 2)
+		return INTEL_PT_NEED_MORE_BYTES;
+
+	switch (buf[1]) {
+	case 0xa3: /* Long TNT */
+		return intel_pt_get_long_tnt(buf, len, packet);
+	case 0x43: /* PIP */
+		return intel_pt_get_pip(buf, len, packet);
+	case 0x03: /* CBR */
+		return intel_pt_get_cbr(buf, len, packet);
+	case 0xf3: /* OVF */
+		return intel_pt_get_ovf(packet);
+	case 0x82: /* PSB */
+		return intel_pt_get_psb(buf, len, packet);
+	case 0x23: /* PSBEND */
+		return intel_pt_get_psbend(packet);
+	default:
+		return INTEL_PT_BAD_PACKET;
+	}
+}
+
+static int intel_pt_get_short_tnt(unsigned int byte,
+				  struct intel_pt_pkt *packet)
+{
+	int count;
+
+	for (count = 6; count; count--) {
+		if (byte & BIT(7))
+			break;
+		byte <<= 1;
+	}
+
+	packet->type = INTEL_PT_TNT;
+	packet->count = count;
+	packet->payload = (uint64_t)byte << 57;
+
+	return 1;
+}
+
+static int intel_pt_get_ip(enum intel_pt_pkt_type type, unsigned int byte,
+		       const unsigned char *buf, size_t len,
+		       struct intel_pt_pkt *packet)
+{
+	switch (byte >> 5) {
+	case 0:
+		packet->count = 0;
+		break;
+	case 1:
+		if (len < 3)
+			return INTEL_PT_NEED_MORE_BYTES;
+		packet->count = 2;
+		packet->payload = le16_to_cpu(*(uint16_t *)(buf + 1));
+		break;
+	case 2:
+		if (len < 5)
+			return INTEL_PT_NEED_MORE_BYTES;
+		packet->count = 4;
+		packet->payload = le32_to_cpu(*(uint32_t *)(buf + 1));
+		break;
+	case 3:
+	case 6:
+		if (len < 7)
+			return INTEL_PT_NEED_MORE_BYTES;
+		packet->count = 6;
+		memcpy_le64(&packet->payload, buf + 1, 6);
+		break;
+	default:
+		return INTEL_PT_BAD_PACKET;
+	}
+
+	packet->type = type;
+
+	return packet->count + 1;
+}
+
+static int intel_pt_get_mode(const unsigned char *buf, size_t len,
+			     struct intel_pt_pkt *packet)
+{
+	if (len < 2)
+		return INTEL_PT_NEED_MORE_BYTES;
+
+	switch (buf[1] >> 5) {
+	case 0:
+		packet->type = INTEL_PT_MODE_EXEC;
+		switch (buf[1] & 3) {
+		case 0:
+			packet->payload = 16;
+			break;
+		case 1:
+			packet->payload = 64;
+			break;
+		case 2:
+			packet->payload = 32;
+			break;
+		default:
+			return INTEL_PT_BAD_PACKET;
+		}
+		break;
+	case 1:
+		packet->type = INTEL_PT_MODE_TSX;
+		if ((buf[1] & 3) == 3)
+			return INTEL_PT_BAD_PACKET;
+		packet->payload = buf[1] & 3;
+		break;
+	default:
+		return INTEL_PT_BAD_PACKET;
+	}
+
+	return 2;
+}
+
+static int intel_pt_get_tsc(const unsigned char *buf, size_t len,
+			    struct intel_pt_pkt *packet)
+{
+	if (len < 8)
+		return INTEL_PT_NEED_MORE_BYTES;
+	packet->type = INTEL_PT_TSC;
+	memcpy_le64(&packet->payload, buf + 1, 7);
+	return 8;
+}
+
+static int intel_pt_do_get_packet(const unsigned char *buf, size_t len,
+				  struct intel_pt_pkt *packet)
+{
+	unsigned int byte;
+
+	memset(packet, 0, sizeof(struct intel_pt_pkt));
+
+	if (!len)
+		return INTEL_PT_NEED_MORE_BYTES;
+
+	byte = buf[0];
+	if (!(byte & BIT(0))) {
+		if (byte == 0)
+			return intel_pt_get_pad(packet);
+		if (byte == 2)
+			return intel_pt_get_ext(buf, len, packet);
+		return intel_pt_get_short_tnt(byte, packet);
+	}
+
+	switch (byte & 0x3f) {
+	case 0x0D:
+		return intel_pt_get_ip(INTEL_PT_TIP, byte, buf, len, packet);
+	case 0x11:
+		return intel_pt_get_ip(INTEL_PT_TIP_PGE, byte, buf, len,
+				       packet);
+	case 0x01:
+		return intel_pt_get_ip(INTEL_PT_TIP_PGD, byte, buf, len,
+				       packet);
+	case 0x1D:
+		return intel_pt_get_ip(INTEL_PT_FUP, byte, buf, len, packet);
+	case 0x19:
+		switch (byte) {
+		case 0x99:
+			return intel_pt_get_mode(buf, len, packet);
+		case 0x19:
+			return intel_pt_get_tsc(buf, len, packet);
+		default:
+			return INTEL_PT_BAD_PACKET;
+		}
+	default:
+		return INTEL_PT_BAD_PACKET;
+	}
+}
+
+int intel_pt_get_packet(const unsigned char *buf, size_t len,
+			struct intel_pt_pkt *packet)
+{
+	int ret;
+
+	ret = intel_pt_do_get_packet(buf, len, packet);
+	if (ret > 0) {
+		while (ret < 8 && len > (size_t)ret && !buf[ret])
+			ret += 1;
+	}
+	return ret;
+}
+
+int intel_pt_pkt_desc(const struct intel_pt_pkt *packet, char *buf,
+		      size_t buf_len)
+{
+	int ret, i;
+	unsigned long long payload = packet->payload;
+	const char *name = intel_pt_pkt_name(packet->type);
+
+	switch (packet->type) {
+	case INTEL_PT_BAD:
+	case INTEL_PT_PAD:
+	case INTEL_PT_PSB:
+	case INTEL_PT_PSBEND:
+	case INTEL_PT_OVF:
+		return snprintf(buf, buf_len, "%s", name);
+	case INTEL_PT_TNT: {
+		size_t blen = buf_len;
+
+		ret = snprintf(buf, blen, "%s ", name);
+		if (ret < 0)
+			return ret;
+		buf += ret;
+		blen -= ret;
+		for (i = 0; i < packet->count; i++) {
+			if (payload & BIT63)
+				ret = snprintf(buf, blen, "T");
+			else
+				ret = snprintf(buf, blen, "N");
+			if (ret < 0)
+				return ret;
+			buf += ret;
+			blen -= ret;
+			payload <<= 1;
+		}
+		ret = snprintf(buf, blen, " (%d)", packet->count);
+		if (ret < 0)
+			return ret;
+		blen -= ret;
+		return buf_len - blen;
+	}
+	case INTEL_PT_TIP_PGD:
+	case INTEL_PT_TIP_PGE:
+	case INTEL_PT_TIP:
+	case INTEL_PT_FUP:
+		if (!(packet->count))
+			return snprintf(buf, buf_len, "%s no ip", name);
+	case INTEL_PT_CBR:
+		return snprintf(buf, buf_len, "%s 0x%llx", name, payload);
+	case INTEL_PT_TSC:
+		if (packet->count)
+			return snprintf(buf, buf_len,
+					"%s 0x%llx CTC 0x%x FC 0x%x",
+					name, payload, packet->count & 0xffff,
+					(packet->count >> 16) & 0x1ff);
+		else
+			return snprintf(buf, buf_len, "%s 0x%llx",
+					name, payload);
+	case INTEL_PT_MODE_EXEC:
+		return snprintf(buf, buf_len, "%s %lld", name, payload);
+	case INTEL_PT_MODE_TSX:
+		return snprintf(buf, buf_len, "%s TXAbort:%u InTX:%u",
+				name, (unsigned)(payload >> 1) & 1,
+				(unsigned)payload & 1);
+	case INTEL_PT_PIP:
+		ret = snprintf(buf, buf_len, "%s 0x%llx",
+			       name, payload);
+		return ret;
+	default:
+		break;
+	}
+	return snprintf(buf, buf_len, "%s 0x%llx (%d)",
+			name, payload, packet->count);
+}
diff --git a/tools/perf/util/intel-pt-decoder/intel-pt-pkt-decoder.h b/tools/perf/util/intel-pt-decoder/intel-pt-pkt-decoder.h
new file mode 100644
index 0000000..89a691f
--- /dev/null
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-pkt-decoder.h
@@ -0,0 +1,68 @@
+/*
+ * intel_pt_pkt_decoder.h: Intel Processor Trace support
+ * Copyright (c) 2013, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+
+#ifndef INCLUDE__INTEL_PT_PKT_DECODER_H__
+#define INCLUDE__INTEL_PT_PKT_DECODER_H__
+
+#include <stddef.h>
+#include <stdint.h>
+
+#define INTEL_PT_PKT_DESC_MAX	256
+
+#define INTEL_PT_NEED_MORE_BYTES	-1
+#define INTEL_PT_BAD_PACKET		-2
+
+#define INTEL_PT_PSB_STR		"\002\202\002\202\002\202\002\202" \
+					"\002\202\002\202\002\202\002\202"
+#define INTEL_PT_PSB_LEN		16
+
+#define INTEL_PT_PKT_MAX_SZ		16
+
+enum intel_pt_pkt_type {
+	INTEL_PT_BAD,
+	INTEL_PT_PAD,
+	INTEL_PT_TNT,
+	INTEL_PT_TIP_PGD,
+	INTEL_PT_TIP_PGE,
+	INTEL_PT_TSC,
+	INTEL_PT_MODE_EXEC,
+	INTEL_PT_MODE_TSX,
+	INTEL_PT_TIP,
+	INTEL_PT_FUP,
+	INTEL_PT_PSB,
+	INTEL_PT_PSBEND,
+	INTEL_PT_CBR,
+	INTEL_PT_PIP,
+	INTEL_PT_OVF,
+};
+
+struct intel_pt_pkt {
+	enum intel_pt_pkt_type	type;
+	int			count;
+	uint64_t		payload;
+};
+
+const char *intel_pt_pkt_name(enum intel_pt_pkt_type);
+
+int intel_pt_get_packet(const unsigned char *buf, size_t len,
+			struct intel_pt_pkt *packet);
+
+int intel_pt_pkt_desc(const struct intel_pt_pkt *packet, char *buf, size_t len);
+
+#endif
-- 
1.8.5.1

