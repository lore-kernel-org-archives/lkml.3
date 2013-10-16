Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760576Ab3JPPVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 11:21:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:30644 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755398Ab3JPPVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 11:21:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,508,1378882800"; 
   d="asc'?scan'208";a="375594318"
Date: Wed, 16 Oct 2013 11:06:41 -0400
From: Chen Gong <gong.chen@linux.intel.com>
To: tony.luck@intel.com, bp@alien8.de, joe@perches.com,
        naveen.n.rao@linux.vnet.ibm.com, m.chehab@samsung.com
Cc: arozansk@redhat.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] Extended H/W error log driver
Message-ID: <20131016150641.GA11836@gchen.bj.intel.com>
Mail-Followup-To: tony.luck@intel.com, bp@alien8.de, joe@perches.com,
	naveen.n.rao@linux.vnet.ibm.com, m.chehab@samsung.com,
	arozansk@redhat.com, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1381935366-11731-1-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
In-Reply-To: <1381935366-11731-1-git-send-email-gong.chen@linux.intel.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[...]
>=20
> dmesg output format has been updated based on the suggestion from Boris.
> For trace output format we still need further discussion. In the last
> patch(support trace interface) I have to reserve previous Kconfig format
> because I find once I put trace_event interface in the module, it will
> not work. I will paste another trace patch(it only works when acpi_extlog=
 is
> builtin) for your answer.
> --

I put my bogus trace patch here.


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
8<=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D

Subject: ACPI / trace: Add trace interface for eMCA driver (bogus patch)

Use trace interface to elaborate all H/W error related
information.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 drivers/acpi/Kconfig       |   3 +-
 drivers/acpi/acpi_extlog.c | 131 +++++++++++++++++++++++++++++++++++++++++=
+++-
 drivers/acpi/apei/cper.c   |  13 +++--
 include/linux/cper.h       |   2 +
 include/ras/ras_event.h    |  61 +++++++++++++++++++++
 5 files changed, 204 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 819c06b..eee0258 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -379,6 +379,7 @@ config ACPI_EXTLOG
 	help
 	  Enhanced MCA Logging allows firmware to provide additional error
 	  information to system software, synchronous with MCE or CMCI. This
-	  driver adds support for that functionality.
+	  driver adds support for that functionality plus an additional special
+	  tracepoint which carries that information to userspace.
=20
 endif	# ACPI
diff --git a/drivers/acpi/acpi_extlog.c b/drivers/acpi/acpi_extlog.c
index d55b072..108f4ae 100644
--- a/drivers/acpi/acpi_extlog.c
+++ b/drivers/acpi/acpi_extlog.c
@@ -11,11 +11,19 @@
 #include <linux/acpi.h>
 #include <acpi/acpi_bus.h>
 #include <linux/cper.h>
+#include <linux/dmi.h>
 #include <linux/ratelimit.h>
 #include <asm/mce.h>
=20
 #include "apei/apei-internal.h"
=20
+#define CREATE_TRACE_POINTS
+#define TRACE_INCLUDE_PATH ../../include/ras
+#include <ras/ras_event.h>
+
+static char mem_location[LOC_LEN];
+static char dimm_location[LOC_LEN];
+
 #define EXT_ELOG_ENTRY_MASK	GENMASK_ULL(52, 0) /* elog entry address mask =
*/
=20
 #define EXTLOG_DSM_REV		0x0
@@ -44,6 +52,8 @@ struct extlog_l1_head {
=20
 static u8 extlog_dsm_uuid[] =3D "663E35AF-CC10-41A4-88EA-5470AF055295";
=20
+static const uuid_le invalid_uuid =3D NULL_UUID_LE;
+
 /* L1 table related physical address */
 static u64 elog_base;
 static size_t elog_size;
@@ -130,9 +140,110 @@ static int print_extlog_rcd(const char *pfx,
 	return 1;
 }
=20
+static void mem_err_location(struct cper_sec_mem_err *mem)
+{
+	char *p;
+	u32 n =3D 0;
+
+	memset(mem_location, 0, LOC_LEN);
+	p =3D mem_location;
+	if (mem->validation_bits & CPER_MEM_VALID_NODE)
+		n +=3D sprintf(p + n, " node: %d", mem->node);
+	if (n >=3D LOC_LEN)
+		goto end;
+	if (mem->validation_bits & CPER_MEM_VALID_CARD)
+		n +=3D sprintf(p + n, " card: %d", mem->card);
+	if (n >=3D LOC_LEN)
+		goto end;
+	if (mem->validation_bits & CPER_MEM_VALID_MODULE)
+		n +=3D sprintf(p + n, " module: %d", mem->module);
+	if (n >=3D LOC_LEN)
+		goto end;
+	if (mem->validation_bits & CPER_MEM_VALID_RANK_NUMBER)
+		n +=3D sprintf(p + n, " rank: %d", mem->rank);
+	if (n >=3D LOC_LEN)
+		goto end;
+	if (mem->validation_bits & CPER_MEM_VALID_BANK)
+		n +=3D sprintf(p + n, " bank: %d", mem->bank);
+	if (n >=3D LOC_LEN)
+		goto end;
+	if (mem->validation_bits & CPER_MEM_VALID_DEVICE)
+		n +=3D sprintf(p + n, " device: %d", mem->device);
+	if (n >=3D LOC_LEN)
+		goto end;
+	if (mem->validation_bits & CPER_MEM_VALID_ROW)
+		n +=3D sprintf(p + n, " row: %d", mem->row);
+	if (n >=3D LOC_LEN)
+		goto end;
+	if (mem->validation_bits & CPER_MEM_VALID_COLUMN)
+		n +=3D sprintf(p + n, " column: %d", mem->column);
+	if (n >=3D LOC_LEN)
+		goto end;
+	if (mem->validation_bits & CPER_MEM_VALID_BIT_POSITION)
+		n +=3D sprintf(p + n, " bit_position: %d", mem->bit_pos);
+	if (n >=3D LOC_LEN)
+		goto end;
+	if (mem->validation_bits & CPER_MEM_VALID_REQUESTOR_ID)
+		n +=3D sprintf(p + n, " requestor_id: 0x%016llx",
+				mem->requestor_id);
+	if (n >=3D LOC_LEN)
+		goto end;
+	if (mem->validation_bits & CPER_MEM_VALID_RESPONDER_ID)
+		n +=3D sprintf(p + n, " responder_id: 0x%016llx",
+				mem->responder_id);
+	if (n >=3D LOC_LEN)
+		goto end;
+	if (mem->validation_bits & CPER_MEM_VALID_TARGET_ID)
+		n +=3D sprintf(p + n, " target_id: 0x%016llx", mem->target_id);
+end:
+	return;
+}
+
+static void dimm_err_location(struct cper_sec_mem_err *mem)
+{
+	const char *bank =3D NULL, *device =3D NULL;
+
+	memset(dimm_location, 0, LOC_LEN);
+	if (!(mem->validation_bits & CPER_MEM_VALID_MODULE_HANDLE))
+		return;
+
+	dmi_memdev_name(mem->mem_dev_handle, &bank, &device);
+	if (bank !=3D NULL && device !=3D NULL)
+		snprintf(dimm_location, LOC_LEN - 1, "%s %s", bank, device);
+	else
+		snprintf(dimm_location, LOC_LEN - 1, "DMI handle: 0x%.4x",
+			 mem->mem_dev_handle);
+}
+
+static void trace_mem_error(const uuid_le *fru_id, char *fru_text,
+			    u64 err_count, u32 severity,
+			    struct cper_sec_mem_err *mem)
+{
+	u32 etype =3D ~0U;
+	u64 phy_addr =3D 0;
+
+	if (mem->validation_bits & CPER_MEM_VALID_ERROR_TYPE)
+		etype =3D mem->error_type;
+	if (mem->validation_bits & CPER_MEM_VALID_PA) {
+		phy_addr =3D mem->physical_addr;
+		if (mem->validation_bits & CPER_MEM_VALID_PA_MASK)
+			phy_addr &=3D mem->physical_addr_mask;
+	}
+	mem_err_location(mem);
+	dimm_err_location(mem);
+
+	trace_extlog_mem_event(etype, dimm_location, fru_id, fru_text,
+			       err_count, severity, phy_addr, mem_location);
+}
+
 static int extlog_print(const char *pfx, int cpu, int bank)
 {
-	struct acpi_generic_status *estatus;
+	struct acpi_generic_status *estatus, *tmp;
+	struct acpi_generic_data *gdata;
+	const uuid_le *fru_id =3D &invalid_uuid;
+	char *fru_text =3D "";
+	uuid_le *sec_type;
+	static u64 err_count;
 	int rc;
=20
 	estatus =3D extlog_elog_entry_check(cpu, bank);
@@ -143,7 +254,23 @@ static int extlog_print(const char *pfx, int cpu, int =
bank)
 	/* clear record status to enable BIOS to update it again */
 	estatus->block_status =3D 0;
=20
-	rc =3D print_extlog_rcd(pfx, (struct acpi_generic_status *)elog_buf, cpu);
+	tmp =3D (struct acpi_generic_status *)elog_buf;
+	gdata =3D (struct acpi_generic_data *)(tmp + 1);
+	rc =3D print_extlog_rcd(pfx, tmp, cpu);
+
+	/* trace extended error log */
+	err_count++;
+	if (gdata->validation_bits & CPER_SEC_VALID_FRU_ID)
+		fru_id =3D (uuid_le *)gdata->fru_id;
+	if (gdata->validation_bits & CPER_SEC_VALID_FRU_TEXT)
+		fru_text =3D gdata->fru_text;
+	sec_type =3D (uuid_le *)gdata->section_type;
+	if (!uuid_le_cmp(*sec_type, CPER_SEC_PLATFORM_MEM)) {
+		struct cper_sec_mem_err *mem_err =3D (void *)(gdata + 1);
+		if (gdata->error_data_length >=3D sizeof(*mem_err))
+			trace_mem_error(fru_id, fru_text, err_count,
+					gdata->error_severity, mem_err);
+	}
=20
 	return rc;
 }
diff --git a/drivers/acpi/apei/cper.c b/drivers/acpi/apei/cper.c
index f5bc227..44bde6a 100644
--- a/drivers/acpi/apei/cper.c
+++ b/drivers/acpi/apei/cper.c
@@ -59,11 +59,12 @@ static const char *cper_severity_strs[] =3D {
 	"info",
 };
=20
-static const char *cper_severity_str(unsigned int severity)
+const char *cper_severity_str(unsigned int severity)
 {
 	return severity < ARRAY_SIZE(cper_severity_strs) ?
 		cper_severity_strs[severity] : "unknown";
 }
+EXPORT_SYMBOL_GPL(cper_severity_str);
=20
 /*
  * cper_print_bits - print strings for set bits
@@ -198,6 +199,13 @@ static const char *cper_mem_err_type_strs[] =3D {
 	"physical memory map-out event",
 };
=20
+const char *cper_mem_err_type_str(unsigned int etype)
+{
+	return etype < ARRAY_SIZE(cper_mem_err_type_strs) ?
+		cper_mem_err_type_strs[etype] : "unknown";
+}
+EXPORT_SYMBOL_GPL(cper_mem_err_type_str);
+
 static void cper_print_mem(const char *pfx, const struct cper_sec_mem_err =
*mem)
 {
 	if (mem->validation_bits & CPER_MEM_VALID_ERROR_STATUS)
@@ -235,8 +243,7 @@ static void cper_print_mem(const char *pfx, const struc=
t cper_sec_mem_err *mem)
 	if (mem->validation_bits & CPER_MEM_VALID_ERROR_TYPE) {
 		u8 etype =3D mem->error_type;
 		printk("%s""error_type: %d, %s\n", pfx, etype,
-		       etype < ARRAY_SIZE(cper_mem_err_type_strs) ?
-		       cper_mem_err_type_strs[etype] : "unknown");
+			cper_mem_err_type_str(etype));
 	}
 	if (mem->validation_bits & CPER_MEM_VALID_MODULE_HANDLE) {
 		const char *bank =3D NULL, *device =3D NULL;
diff --git a/include/linux/cper.h b/include/linux/cper.h
index 2fc0ec3..c6d87fc 100644
--- a/include/linux/cper.h
+++ b/include/linux/cper.h
@@ -395,6 +395,8 @@ struct cper_sec_pcie {
 #pragma pack()
=20
 u64 cper_next_record_id(void);
+const char *cper_severity_str(unsigned int);
+const char *cper_mem_err_type_str(unsigned int);
 void cper_print_bits(const char *prefix, unsigned int bits,
 		     const char * const strs[], unsigned int strs_size);
=20
diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
index 21cdb0b..579dbb0 100644
--- a/include/ras/ras_event.h
+++ b/include/ras/ras_event.h
@@ -8,6 +8,67 @@
 #include <linux/tracepoint.h>
 #include <linux/edac.h>
 #include <linux/ktime.h>
+#include <linux/cper.h>
+
+/*
+ * MCE Extended Error Log Trace event
+ *
+ * These events are generated when hardware detects a corrected or
+ * uncorrected event.
+ *
+ */
+
+/* memory trace event */
+
+#define LOC_LEN		512
+#define MSG_LEN		((LOC_LEN) * 2)
+
+TRACE_EVENT(extlog_mem_event,
+	TP_PROTO(u32 etype,
+		char *dimm_loc,
+		const uuid_le *fru_id,
+		char *fru_text,
+		u64 error_count,
+		u32 severity,
+		u64 phy_addr,
+		char *mem_loc),
+
+	TP_ARGS(etype, dimm_loc, fru_id, fru_text, error_count, severity,
+		phy_addr, mem_loc),
+
+	TP_STRUCT__entry(
+		__field(u32, etype)
+		__dynamic_array(char, dimm_info, LOC_LEN)
+		__field(u64, error_count)
+		__field(u32, severity)
+		__dynamic_array(char, msg, MSG_LEN)
+	),
+
+	TP_fast_assign(
+		__entry->error_count =3D error_count;
+		__entry->severity =3D severity;
+		__entry->etype =3D etype;
+		if (dimm_loc[0] !=3D '\0')
+			snprintf(__get_dynamic_array(dimm_info), LOC_LEN - 1,
+				"on %s", dimm_loc);
+		else
+			__assign_str(dimm_info, "");
+		if (phy_addr !=3D 0)
+			snprintf(__get_dynamic_array(msg), MSG_LEN - 1,
+				"(FRU: %pUl %.20s physical addr: 0x%016llx%s)",
+				fru_id, fru_text, phy_addr, mem_loc);
+		else
+			__assign_str(msg, "");
+	),
+
+	TP_printk("%llu %s error%s: %s %s %s",
+			__entry->error_count,
+			cper_severity_str(__entry->severity),
+			__entry->error_count > 1 ? "s" : "",
+			cper_mem_err_type_str(__entry->etype),
+			__get_str(dimm_info),
+			__get_str(msg))
+);
=20
 /*
  * Hardware Events Report
--=20
1.8.4.rc3

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSXquBAAoJEI01n1+kOSLHQNoQAIm94kXuLZeIwh5ZEIK+P79x
R6JL0IpPtaBeeFqhKrKVHhOv10UfB9ktTtZt/VNMZGEJ7UJU8s60DIc41OtUDQUx
QuVW2wFn04jojgbZaNrlyvtULeEbmg1Nlo46vh+cgXjBG0kI0OQ87szynMMJfusW
Xoz+o09rscnnVg98qAgWugePILDveV4fn7iVgIqbqdEjg5KetD7nYz+3qoKiZ8b8
w+Wi8zse8uu0fmDKXHKmDIECDyukm9hlZxkkrZpRoMR7UU0OPY+rbvAqRAlwOWWP
2g4XPjhNontq9mxeM9Jj1JYRYOlwVCW4WiZNdykMZ8gNdAAk/EwnaVo3hfTFzvVx
5vv0hCvwdZHnZlA12g+QT+q9emhaLxBNEOG6999zBNJEwDAj1RGjyAW5p/E+5Y4h
p1YPPun1UMBwi1lJOZYhpBYZD8o6unDB0i/U97WnXGeSManHy7MYo6N9JmvTHDL2
6IWkk8YBCALN1MjcbGz+ekmeCpVgY3nEj2qgRk8eFzEkgQvJNpmS+sjEu3EqBmZi
xLDOon/1Ba1b++vhUoVr5eKnXVvUl3RBzAXbYWjFkgvfdD2n4W2XHWuF9ZGjcWXK
5rS0oXuJL2aj3bg3MNi9+3opXKtHpvyI88SX0ZwfPEwIx7dzHO2HWHr5rMPOQ4NT
pAR3cCKLXufPkjyh8aij
=Ando
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
