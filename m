Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbaFFHTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 03:19:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:6624 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbaFFHTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 03:19:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,987,1392192000"; 
   d="asc'?scan'208";a="550677980"
Date: Fri, 6 Jun 2014 02:51:41 -0400
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7 v6] trace, RAS: Add eMCA trace event interface
Message-ID: <20140606065141.GA10998@gchen.bj.intel.com>
Mail-Followup-To: Steven Rostedt <rostedt@goodmis.org>,
	"Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
	"m.chehab@samsung.com" <m.chehab@samsung.com>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20140528163452.GF17196@pd.tnic>
 <20140528125625.6f6dcf7f@gandalf.local.home>
 <20140530092232.GA13495@gchen.bj.intel.com>
 <20140530100716.GE28131@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F32823D2B@ORSMSX114.amr.corp.intel.com>
 <20140530210759.267a854e@gandalf.local.home>
 <3908561D78D1C84285E8C5FCA982C28F3282545B@ORSMSX114.amr.corp.intel.com>
 <20140602125748.7093ced8@gandalf.local.home>
 <20140603083606.GA15476@gchen.bj.intel.com>
 <20140603103544.207eaa6e@gandalf.local.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
In-Reply-To: <20140603103544.207eaa6e@gandalf.local.home>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 03, 2014 at 10:35:44AM -0400, Steven Rostedt wrote:
> Note, there's a pointer to a trace_seq structure "p" that is available.
> Hmm, I should add a get_dynamic_array_len(field), to give you the
> length. I'll add that now. I also don't like the trace_seq being "p" as
> that is too generic. Maybe I'll change that to "__trace_seq" or
> something not so generic.
>=20
>=20
> Anyway, have something like this:
>=20
>=20
> 	TP_printk("%s", emca_parse_events(p, __get_dynamic_array(field),
> 			__get_dynamic_array_len(field)));
>=20

Hi, Steven & other guys

Here is the new patch for eMCA trace. I post it here as a RFC patch for
discussion. Once it is OK, I will resend a new complete patch series.
Before showing the patch I have something to highlight first:

1. I don't use key/value because it is not most efficient way because
it often has 9+ valid fields in one record, which means at least 9 bytes
for type(assuming packing type via __ffs). But original filed, which
is a bit field combination (an u64 field) is enough to cover everyting
without *ffs* expense. As for those fields with different lenght, it is
a disater to save them in minimum cost.

2. To share more codes like decoding error. If I use key/value I must
rewrite codes & add more obsure enum, definitions etc. Currently I just
adopt a lightweight compact struct to save ring buffer spaces. Please
refer to the codes.

3. I use same buffer to store decoded string, for dimm location, memory
location, even intermediate trace result because in our current desgin,
trace output and demsg output are mutually exclusive, so don't worry
about potential contention.

One more thing, all I saved is just when one reads raw data from user space,
TP_printk part can be bypassed so extra storage expense is none.
Am I right, Steven?

Here is the dmesg log:
[  267.627996] {1}Hardware error detected on CPU15
[  267.628007] {1}It has been corrected by h/w and requires no further acti=
on
[  267.628011] {1}event severity: corrected
[  267.628017] {1} Error 0, type: corrected
[  267.628022] {1}  section_type: memory error
[  267.628026] {1}  physical_address: 0x000000084f5d8000
[  267.628037] {1}  node: 2 card: 0 module: 0 rank: 0 bank: 0 row: 28717 co=
lumn: 1528
[  267.628057] {1}  DIMM location: Memriser3 CHANNEL A DIMM 0
[  316.135078] {2}Hardware error detected on CPU15
[  316.135095] {2}It has been corrected by h/w and requires no further acti=
on
[  316.135102] {2}event severity: corrected
[  316.135107] {2} Error 0, type: corrected
[  316.135111] {2}  section_type: memory error
[  316.135114] {2}  physical_address: 0x000000084f6c0000
[  316.135120] {2}  node: 2 card: 0 module: 0 rank: 0 bank: 0 row: 28732 co=
lumn: 1504
[  316.135124] {2}  DIMM location: Memriser3 CHANNEL A DIMM 0

Here is the trace log (when dmesg is disabled):
          <idle>-0     [015] d.h3   207.156998: extlog_mem_event: {1} corre=
cted error: unknown physical addr: 00000008527e2000 (mask lsb: ff) node: 2 =
card: 0 module: 0 rank: 0 bank: 0 row: 29758 column: 1616 DIMM location: Me=
mriser3 CHANNEL A DIMM 0 FRU: 00000000-0000-0000-0000-000000000000
          <idle>-0     [015] d.h3   339.574445: extlog_mem_event: {2} corre=
cted error: unknown physical addr: 0000000851dba000 (mask lsb: ff) node: 2 =
card: 0 module: 0 rank: 0 bank: 0 row: 29803 column: 1592 DIMM location: Me=
mriser3 CHANNEL A DIMM 0 FRU: 00000000-0000-0000-0000-000000000000

--------8<--------
=46rom 864bd0f2d2121b8c7a941e6e776952378a6c636c Mon Sep 17 00:00:00 2001
=46rom: "Chen, Gong" <gong.chen@linux.intel.com>
Date: Fri, 6 Jun 2014 01:46:45 -0400
Subject: [PATCH 5/7] trace, RAS: Add eMCA trace event interface

Add trace interface to elaborate all H/W error related information.

v7 -> v6: compact trace info to save some trace buffer space
v6 -> v5: format adjustment.
v5 -> v4: Add physical mask(LSB) in trace.
v4 -> v3: change ras trace dependency rule.
v3 -> v2: minor adjustment according to the suggestion from Boris.
v2 -> v1: spinlock is not needed anymore.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 drivers/acpi/Kconfig        |  4 ++-
 drivers/acpi/acpi_extlog.c  | 27 +++++++++++++++++---
 drivers/firmware/efi/cper.c | 48 ++++++++++++++++++++++++++++++++---
 drivers/ras/ras.c           |  1 +
 include/linux/cper.h        | 21 +++++++++++++++
 include/ras/ras_event.h     | 62 +++++++++++++++++++++++++++++++++++++++++=
++++
 6 files changed, 155 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index a34a228..099a2d5 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -370,6 +370,7 @@ config ACPI_EXTLOG
 	tristate "Extended Error Log support"
 	depends on X86_MCE && X86_LOCAL_APIC
 	select UEFI_CPER
+	select RAS_TRACE
 	default n
 	help
 	  Certain usages such as Predictive Failure Analysis (PFA) require
@@ -384,6 +385,7 @@ config ACPI_EXTLOG
=20
 	  Enhanced MCA Logging allows firmware to provide additional error
 	  information to system software, synchronous with MCE or CMCI. This
-	  driver adds support for that functionality.
+	  driver adds support for that functionality with corresponding
+	  tracepoint which carries that information to userspace.
=20
 endif	# ACPI
diff --git a/drivers/acpi/acpi_extlog.c b/drivers/acpi/acpi_extlog.c
index c4a5d87..3c4a8aa 100644
--- a/drivers/acpi/acpi_extlog.c
+++ b/drivers/acpi/acpi_extlog.c
@@ -16,6 +16,7 @@
 #include <asm/mce.h>
=20
 #include "apei/apei-internal.h"
+#include <ras/ras_event.h>
=20
 #define EXT_ELOG_ENTRY_MASK	GENMASK_ULL(51, 0) /* elog entry address mask =
*/
=20
@@ -137,8 +138,12 @@ static int extlog_print(struct notifier_block *nb, uns=
igned long val,
 	struct mce *mce =3D (struct mce *)data;
 	int	bank =3D mce->bank;
 	int	cpu =3D mce->extcpu;
-	struct acpi_generic_status *estatus;
-	int rc;
+	struct acpi_generic_status *estatus, *tmp;
+	struct acpi_generic_data *gdata;
+	const uuid_le *fru_id =3D &NULL_UUID_LE;
+	char *fru_text =3D "";
+	uuid_le *sec_type;
+	static u32 err_seq;
=20
 	estatus =3D extlog_elog_entry_check(cpu, bank);
 	if (estatus =3D=3D NULL)
@@ -148,7 +153,23 @@ static int extlog_print(struct notifier_block *nb, uns=
igned long val,
 	/* clear record status to enable BIOS to update it again */
 	estatus->block_status =3D 0;
=20
-	rc =3D print_extlog_rcd(NULL, (struct acpi_generic_status *)elog_buf, cpu=
);
+	tmp =3D (struct acpi_generic_status *)elog_buf;
+	print_extlog_rcd(NULL, tmp, cpu);
+
+	/* log event via trace */
+	err_seq++;
+	gdata =3D (struct acpi_generic_data *)(tmp + 1);
+	if (gdata->validation_bits & CPER_SEC_VALID_FRU_ID)
+		fru_id =3D (uuid_le *)gdata->fru_id;
+	if (gdata->validation_bits & CPER_SEC_VALID_FRU_TEXT)
+		fru_text =3D gdata->fru_text;
+	sec_type =3D (uuid_le *)gdata->section_type;
+	if (!uuid_le_cmp(*sec_type, CPER_SEC_PLATFORM_MEM)) {
+		struct cper_sec_mem_err *mem =3D (void *)(gdata + 1);
+		if (gdata->error_data_length >=3D sizeof(*mem))
+			trace_extlog_mem_event(mem, err_seq, fru_id, fru_text,
+					       (u8)gdata->error_severity);
+	}
=20
 	return NOTIFY_STOP;
 }
diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index 64d182f..23d0cef 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -207,7 +207,7 @@ const char *cper_mem_err_type_str(unsigned int etype)
 }
 EXPORT_SYMBOL_GPL(cper_mem_err_type_str);
=20
-int cper_mem_err_location(const struct cper_sec_mem_err *mem, char *msg)
+int cper_mem_err_location(struct cper_mem_err_compact *mem, char *msg)
 {
 	u32 len, n;
=20
@@ -249,7 +249,7 @@ int cper_mem_err_location(const struct cper_sec_mem_err=
 *mem, char *msg)
 	return n;
 }
=20
-int cper_dimm_err_location(const struct cper_sec_mem_err *mem, char *msg)
+int cper_dimm_err_location(struct cper_mem_err_compact *mem, char *msg)
 {
 	u32 len, n;
 	const char *bank =3D NULL, *device =3D NULL;
@@ -271,8 +271,47 @@ int cper_dimm_err_location(const struct cper_sec_mem_e=
rr *mem, char *msg)
 	return n;
 }
=20
+void cper_mem_err_pack(const struct cper_sec_mem_err *mem, void *data)
+{
+	struct cper_mem_err_compact *cmem =3D (struct cper_mem_err_compact *)data;
+
+	cmem->validation_bits =3D mem->validation_bits;
+	cmem->node =3D mem->node;
+	cmem->card =3D mem->card;
+	cmem->module =3D mem->module;
+	cmem->bank =3D mem->bank;
+	cmem->device =3D mem->device;
+	cmem->row =3D mem->row;
+	cmem->column =3D mem->column;
+	cmem->bit_pos =3D mem->bit_pos;
+	cmem->requestor_id =3D mem->requestor_id;
+	cmem->responder_id =3D mem->responder_id;
+	cmem->target_id =3D mem->target_id;
+	cmem->rank =3D mem->rank;
+	cmem->mem_array_handle =3D mem->mem_array_handle;
+	cmem->mem_dev_handle =3D mem->mem_dev_handle;
+}
+EXPORT_SYMBOL_GPL(cper_mem_err_pack);
+
+const char *cper_mem_err_unpack(struct trace_seq *p, void *data)
+{
+	struct cper_mem_err_compact *cmem =3D (struct cper_mem_err_compact *)data;
+	const char *ret =3D p->buffer + p->len;
+
+	if (cper_mem_err_location(cmem, rcd_decode_str))
+		trace_seq_printf(p, "%s", rcd_decode_str);
+	if (cper_dimm_err_location(cmem, rcd_decode_str))
+		trace_seq_printf(p, "%s", rcd_decode_str);
+	trace_seq_putc(p, '\0');
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(cper_mem_err_unpack);
+
 static void cper_print_mem(const char *pfx, const struct cper_sec_mem_err =
*mem)
 {
+	struct cper_mem_err_compact cmem;
+
 	if (mem->validation_bits & CPER_MEM_VALID_ERROR_STATUS)
 		printk("%s""error_status: 0x%016llx\n", pfx, mem->error_status);
 	if (mem->validation_bits & CPER_MEM_VALID_PA)
@@ -281,14 +320,15 @@ static void cper_print_mem(const char *pfx, const str=
uct cper_sec_mem_err *mem)
 	if (mem->validation_bits & CPER_MEM_VALID_PA_MASK)
 		printk("%s""physical_address_mask: 0x%016llx\n",
 		       pfx, mem->physical_addr_mask);
-	if (cper_mem_err_location(mem, rcd_decode_str))
+	cper_mem_err_pack(mem, &cmem);
+	if (cper_mem_err_location(&cmem, rcd_decode_str))
 		printk("%s%s\n", pfx, rcd_decode_str);
 	if (mem->validation_bits & CPER_MEM_VALID_ERROR_TYPE) {
 		u8 etype =3D mem->error_type;
 		printk("%s""error_type: %d, %s\n", pfx, etype,
 		       cper_mem_err_type_str(etype));
 	}
-	if (cper_dimm_err_location(mem, rcd_decode_str))
+	if (cper_dimm_err_location(&cmem, rcd_decode_str))
 		printk("%s%s\n", pfx, rcd_decode_str);
 }
=20
diff --git a/drivers/ras/ras.c b/drivers/ras/ras.c
index 4cac43a..da227a3 100644
--- a/drivers/ras/ras.c
+++ b/drivers/ras/ras.c
@@ -23,4 +23,5 @@ static int __init ras_init(void)
 }
 subsys_initcall(ras_init);
=20
+EXPORT_TRACEPOINT_SYMBOL_GPL(extlog_mem_event);
 EXPORT_TRACEPOINT_SYMBOL_GPL(mc_event);
diff --git a/include/linux/cper.h b/include/linux/cper.h
index ed088b9..3548160 100644
--- a/include/linux/cper.h
+++ b/include/linux/cper.h
@@ -22,6 +22,7 @@
 #define LINUX_CPER_H
=20
 #include <linux/uuid.h>
+#include <linux/trace_seq.h>
=20
 /* CPER record signature and the size */
 #define CPER_SIG_RECORD				"CPER"
@@ -363,6 +364,24 @@ struct cper_sec_mem_err {
 	__u16	mem_dev_handle;		/* module handle in UEFI 2.4 */
 };
=20
+struct cper_mem_err_compact {
+	__u64	validation_bits;
+	__u16	node;
+	__u16	card;
+	__u16	module;
+	__u16	bank;
+	__u16	device;
+	__u16	row;
+	__u16	column;
+	__u16	bit_pos;
+	__u64	requestor_id;
+	__u64	responder_id;
+	__u64	target_id;
+	__u16	rank;
+	__u16	mem_array_handle;
+	__u16	mem_dev_handle;
+};
+
 struct cper_sec_pcie {
 	__u64		validation_bits;
 	__u32		port_type;
@@ -406,5 +425,7 @@ const char *cper_severity_str(unsigned int);
 const char *cper_mem_err_type_str(unsigned int);
 void cper_print_bits(const char *prefix, unsigned int bits,
 		     const char * const strs[], unsigned int strs_size);
+void cper_mem_err_pack(const struct cper_sec_mem_err *, void *);
+const char *cper_mem_err_unpack(struct trace_seq *, void *);
=20
 #endif
diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
index acbcbb8..66cd7bb 100644
--- a/include/ras/ras_event.h
+++ b/include/ras/ras_event.h
@@ -9,6 +9,68 @@
 #include <linux/edac.h>
 #include <linux/ktime.h>
 #include <linux/aer.h>
+#include <linux/cper.h>
+
+/*
+ * MCE Extended Error Log trace event
+ *
+ * These events are generated when hardware detects a corrected or
+ * uncorrected event.
+ */
+
+/* memory trace event */
+
+TRACE_EVENT(extlog_mem_event,
+	TP_PROTO(struct cper_sec_mem_err *mem,
+		 u32 err_seq,
+		 const uuid_le *fru_id,
+		 const char *fru_text,
+		 u8 sev),
+
+	TP_ARGS(mem, err_seq, fru_id, fru_text, sev),
+
+	TP_STRUCT__entry(
+		__field(u32, err_seq)
+		__field(u8, etype)
+		__field(u8, sev)
+		__field(u64, pa)
+		__field(u8, pa_mask_lsb)
+		__dynamic_array(char, fru, 48)
+		__dynamic_array(u8, data, sizeof(struct cper_mem_err_compact))
+	),
+
+	TP_fast_assign(
+		__entry->err_seq =3D err_seq;
+		if (mem->validation_bits & CPER_MEM_VALID_ERROR_TYPE)
+			__entry->etype =3D mem->error_type;
+		else
+			__entry->etype =3D ~0;
+		__entry->sev =3D sev;
+		if (mem->validation_bits & CPER_MEM_VALID_PA)
+			__entry->pa =3D mem->physical_addr;
+		else
+			__entry->pa =3D ~0ull;
+
+		if (mem->validation_bits & CPER_MEM_VALID_PA_MASK)
+			__entry->pa_mask_lsb =3D
+				(u8)__ffs64(mem->physical_addr_mask);
+		else
+			__entry->pa_mask_lsb =3D ~0;
+		snprintf(__get_dynamic_array(fru), 47,
+			 "FRU: %pUl %.20s", fru_id, fru_text);
+		cper_mem_err_pack(mem, __get_dynamic_array(data));
+	),
+
+	TP_printk("{%d} %s error: %s physical addr: %016llx (mask lsb: %x) %s%s",
+		  __entry->err_seq,
+		  cper_severity_str(__entry->sev),
+		  cper_mem_err_type_str(__entry->etype),
+		  __entry->pa,
+		  __entry->pa_mask_lsb,
+		  cper_mem_err_unpack(p, __get_dynamic_array(data)),
+		  __get_str(fru))
+);
=20
 /*
  * Hardware Events Report
--=20
2.0.0.rc2

--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTkWT9AAoJEI01n1+kOSLHdcsQAKnBieKJhtmJ+75gvA/k6nVm
ZFMMrpPZXwsHF3pVRwNCFJTdaaPO6CCQ5FvFk111W+AlY74FFcLwhBQ9mQSJV9aq
097Il4axBCbwoDPuJXKxbrwM5vL+ydFa2M7dvGyDg7rpT1NeuvZ7jpGb7cr1n4zh
clhXZn5jT52BhAy14x//Hf1ltIIGUCsUWH3NUnQYnRxnZ1dJYxcUMAjy7GdWD5bt
k6dchBsvskKnK1fhN5pLGIPLmvgah6eiPt/Cdcjsu0Nufy+bbexVQ+kp/BcQS3ql
uic+g8ULpbYe4IoxPNNOll8zTZcowFxN/aCjlyyfZa6Hw55aNAbMZrUuyCO9qQHs
RT29O13mJAJcJ3x7++SDQ+9RYQfVXbzbUGDlTB2rCPaYVA4Ia8pXcasjLu7uyTmK
mgx8fT+UxIoE3gp3WHbMO9INe+Qp6CHDdiytrNVHQZSwoBuK+zZOEnFQNC1J+qds
4A5iHTawklvwvVmSBy17RfT91oy8Quz1JBZm/8jiFH9B2rvnWuBZDpv89zngW1Sj
/+17zSef9qxpA/jq/ez3LVZWkcGvNrb52a6lUWmKOBOJD9feTX2n1Benu8z4uVBa
7R38LA6PaawAQCu7etueF9mOsYAUznh8xC8fbASrrT4K2MrdawHEhbRv4RBOS1d2
0PaAEAkWNA8GJIv43pN+
=umib
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
