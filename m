Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbaCaPCZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 11:02:25 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:47849 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474AbaCaPCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 11:02:23 -0400
Message-ID: <53398379.8000203@linux.vnet.ibm.com>
Date: Mon, 31 Mar 2014 10:02:17 -0500
From: Nathan Fontenot <nfont@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Greg Kurz <gkurz@linux.vnet.ibm.com>, benh@kernel.crashing.org
CC: linux-kernel@vger.kernel.org, tony@bakeyournoodle.com, paulus@samba.org,
        anton@samba.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [RFC PATCH] powerpc/le: enable RTAS events support
References: <20140328073344.26823.32931.stgit@bahia.local>
In-Reply-To: <20140328073344.26823.32931.stgit@bahia.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14033115-9332-0000-0000-0000004BB287
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the patch that I worked up at the same time as Greg, the
biggest difference being that I took the approach of doing and's,
and shifting as opposed to re-defining the bit fields for LE.

One other difference is that I left out defines for bits in the
error log structures that we currently do not use. I did leave the
comments in the structs describing the bit layout for future reference
but did not feel we needed to provide a define for all of them.

NOTE: This patch has not been tested.

-Nathan

---
 arch/powerpc/include/asm/rtas.h           |   92 +++++++++++++++++++---------
 arch/powerpc/kernel/rtas.c                |   24 ++++++--
 arch/powerpc/kernel/rtasd.c               |   11 ++--
 arch/powerpc/platforms/pseries/mobility.c |    2 +-
 arch/powerpc/platforms/pseries/ras.c      |   18 ++++--
 5 files changed, 97 insertions(+), 50 deletions(-)

diff --git a/arch/powerpc/include/asm/rtas.h b/arch/powerpc/include/asm/rtas.h
index a0e1add..6efa1b6 100644
--- a/arch/powerpc/include/asm/rtas.h
+++ b/arch/powerpc/include/asm/rtas.h
@@ -150,19 +150,45 @@ struct rtas_suspend_me_data {
 #define RTAS_VECTOR_EXTERNAL_INTERRUPT	0x500
 
 struct rtas_error_log {
-	unsigned long version:8;		/* Architectural version */
-	unsigned long severity:3;		/* Severity level of error */
-	unsigned long disposition:2;		/* Degree of recovery */
-	unsigned long extended:1;		/* extended log present? */
-	unsigned long /* reserved */ :2;	/* Reserved for future use */
-	unsigned long initiator:4;		/* Initiator of event */
-	unsigned long target:4;			/* Target of failed operation */
-	unsigned long type:8;			/* General event or error*/
-	unsigned long extended_log_length:32;	/* length in bytes */
-	unsigned char buffer[1];		/* Start of extended log */
+	/* Byte 0 */
+	uint8_t		version;		/* Architectural version */
+
+	/* Byte 1 */
+	uint8_t		severity;
+	/* XXXXXXXX
+	 * XXX		3: Severity level of error
+	 *    XX	2: Degree of recovery
+	 *      X	1: Extended log present?
+	 *       XX	2: Reserved
+	 */
+	
+	/* Byte 2 */
+	uint8_t		:8;
+	/* XXXXXXXX
+	 * XXXX		4: Initiator of event
+	 *     XXXX	4: Target of failed operation
+	 */
+	uint8_t		type;			/* General event or error*/
+	uint32_t	extended_log_length;	/* length in bytes */
+	unsigned char	buffer[1];		/* Start of extended log */
 						/* Variable length.      */
 };
 
+static inline uint8_t rtas_error_severity(struct rtas_error_log *elog)
+{
+	return (elog->severity & 0xE0) >> 5;
+}
+
+static inline uint8_t rtas_error_disposition(struct rtas_error_log *elog)
+{
+	return (elog->severity & 0x18) >> 3;
+}
+
+static inline uint8_t rtas_error_extended(struct rtas_error_log *elog)
+{
+	return elog->severity & 0x04;
+}
+
 #define RTAS_V6EXT_LOG_FORMAT_EVENT_LOG	14
 
 #define RTAS_V6EXT_COMPANY_ID_IBM	(('I' << 24) | ('B' << 16) | ('M' << 8))
@@ -172,34 +198,40 @@ struct rtas_error_log {
  */
 struct rtas_ext_event_log_v6 {
 	/* Byte 0 */
-	uint32_t log_valid:1;		/* 1:Log valid */
-	uint32_t unrecoverable_error:1;	/* 1:Unrecoverable error */
-	uint32_t recoverable_error:1;	/* 1:recoverable (correctable	*/
-					/*   or successfully retried)	*/
-	uint32_t degraded_operation:1;	/* 1:Unrecoverable err, bypassed*/
-					/*   - degraded operation (e.g.	*/
-					/*   CPU or mem taken off-line)	*/
-	uint32_t predictive_error:1;
-	uint32_t new_log:1;		/* 1:"New" log (Always 1 for	*/
-					/*   data returned from RTAS	*/
-	uint32_t big_endian:1;		/* 1: Big endian */
-	uint32_t :1;			/* reserved */
+	uint8_t	:8;
+	/* XXXXXXXX
+	 * X		1: Log valid
+	 *  X		1: Unrecoverable error
+	 *   X		1: Recoverable (correctable or successfully retried)
+	 *    X		1: Unrecoverable err, bypassed - degraded operation
+	 *		   (e.g. CPU or mem taken off-line)
+	 *     X	1: Preduictive error
+	 *      X	1: "New" log (Always 1 for data returned from RTAS)
+	 *       X	1: Big endian
+	 *        X	1: reserved
+	 */
+	
 	/* Byte 1 */
-	uint32_t :8;			/* reserved */
+	uint8_t :8;			/* reserved */
 	/* Byte 2 */
-	uint32_t powerpc_format:1;	/* Set to 1 (indicating log is	*/
-					/* in PowerPC format		*/
-	uint32_t :3;			/* reserved */
-	uint32_t log_format:4;		/* Log format indicator. Define	*/
-					/* format used for byte 12-2047	*/
+	uint8_t	format;
+	/* XXXXXXXX
+	 * X		1: Set to 1 (indicating log is in PowerPC format)
+	 *  XXX		3: Reserved
+	 *     XXXX	4: Log format indicator. Define format used for
+	 *		   byte 12-2047
+	 */
+	
 	/* Byte 3 */
-	uint32_t :8;			/* reserved */
+	uint8_t :8;			/* reserved */
 	/* Byte 4-11 */
 	uint8_t reserved[8];		/* reserved */
+	
 	/* Byte 12-15 */
-	uint32_t company_id;		/* Company ID of the company	*/
+	char	company_id[4];		/* Company ID of the company	*/
 					/* that defines the format for	*/
 					/* the vendor specific log type	*/
+
 	/* Byte 16-end of log */
 	uint8_t vendor_log[1];		/* Start of vendor specific log	*/
 					/* Variable length.		*/
diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index f386296..314e3c9 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -979,6 +979,17 @@ int rtas_ibm_suspend_me(struct rtas_args *args)
 }
 #endif
 
+const char *rtas_v6ext_company_id = "IBM";
+/**
+ * Validate the company_id specified in the rtas extended event log
+ */
+static int rtas_valid_extv6_company_id(struct rtas_ext_event_log_v6 *extlog)
+{
+	return (extlog->company_id[0] == 'I' &&
+		extlog->company_id[1] == 'B' &&
+		extlog->company_id[2] == 'M');
+}
+
 /**
  * Find a specific pseries error log in an RTAS extended event log.
  * @log: RTAS error/event log
@@ -993,21 +1004,22 @@ struct pseries_errorlog *get_pseries_errorlog(struct rtas_error_log *log,
 		(struct rtas_ext_event_log_v6 *)log->buffer;
 	struct pseries_errorlog *sect;
 	unsigned char *p, *log_end;
+	uint32_t ext_log_length = be32_to_cpu(log->extended_log_length);
 
 	/* Check that we understand the format */
-	if (log->extended_log_length < sizeof(struct rtas_ext_event_log_v6) ||
-	    ext_log->log_format != RTAS_V6EXT_LOG_FORMAT_EVENT_LOG ||
-	    ext_log->company_id != RTAS_V6EXT_COMPANY_ID_IBM)
+	if (ext_log_length < sizeof(struct rtas_ext_event_log_v6) ||
+	    (ext_log->format & 0x0f) != RTAS_V6EXT_LOG_FORMAT_EVENT_LOG ||
+	    !rtas_valid_extv6_company_id(ext_log))
 		return NULL;
 
-	log_end = log->buffer + log->extended_log_length;
+	log_end = log->buffer + ext_log_length;
 	p = ext_log->vendor_log;
 
 	while (p < log_end) {
 		sect = (struct pseries_errorlog *)p;
-		if (sect->id == section_id)
+		if (be16_to_cpu(sect->id) == section_id)
 			return sect;
-		p += sect->length;
+		p += be16_to_cpu(sect->length);
 	}
 
 	return NULL;
diff --git a/arch/powerpc/kernel/rtasd.c b/arch/powerpc/kernel/rtasd.c
index 1130c53..6940e26 100644
--- a/arch/powerpc/kernel/rtasd.c
+++ b/arch/powerpc/kernel/rtasd.c
@@ -151,7 +151,7 @@ static void printk_log_rtas(char *buf, int len)
 
 		printk(RTAS_DEBUG "event: %d, Type: %s, Severity: %d\n",
 		       error_log_cnt, rtas_event_type(errlog->type),
-		       errlog->severity);
+		       rtas_error_severity(errlog));
 	}
 }
 
@@ -163,10 +163,10 @@ static int log_rtas_len(char * buf)
 	/* rtas fixed header */
 	len = 8;
 	err = (struct rtas_error_log *)buf;
-	if (err->extended && err->extended_log_length) {
+	if (rtas_error_extended(err) && err->extended_log_length) {
 
 		/* extended header */
-		len += err->extended_log_length;
+		len += be32_to_cpu(err->extended_log_length);
 	}
 
 	if (rtas_error_log_max == 0)
@@ -293,12 +293,11 @@ void prrn_schedule_update(u32 scope)
 
 static void handle_rtas_event(const struct rtas_error_log *log)
 {
-	if (log->type == RTAS_TYPE_PRRN) {
+	if (log->type == RTAS_TYPE_PRRN && prrn_is_enabled()) {
 		/* For PRRN Events the extended log length is used to denote
 		 * the scope for calling rtas update-nodes.
 		 */
-		if (prrn_is_enabled())
-			prrn_schedule_update(log->extended_log_length);
+		prrn_schedule_update(be32_to_cpu(log->extended_log_length));
 	}
 
 	return;
diff --git a/arch/powerpc/platforms/pseries/mobility.c b/arch/powerpc/platforms/pseries/mobility.c
index bde7eba..ef08cda 100644
--- a/arch/powerpc/platforms/pseries/mobility.c
+++ b/arch/powerpc/platforms/pseries/mobility.c
@@ -46,7 +46,7 @@ static int mobility_rtas_call(int token, char *buf, s32 scope)
 	spin_lock(&rtas_data_buf_lock);
 
 	memcpy(rtas_data_buf, buf, RTAS_DATA_BUF_SIZE);
-	rc = rtas_call(token, 2, 1, NULL, rtas_data_buf, scope);
+	rc = rtas_call(token, 2, 1, NULL, rtas_data_buf, cpu_to_be32(scope));
 	memcpy(buf, rtas_data_buf, RTAS_DATA_BUF_SIZE);
 
 	spin_unlock(&rtas_data_buf_lock);
diff --git a/arch/powerpc/platforms/pseries/ras.c b/arch/powerpc/platforms/pseries/ras.c
index 721c058..0940734 100644
--- a/arch/powerpc/platforms/pseries/ras.c
+++ b/arch/powerpc/platforms/pseries/ras.c
@@ -236,7 +236,8 @@ static irqreturn_t ras_error_interrupt(int irq, void *dev_id)
 
 	rtas_elog = (struct rtas_error_log *)ras_log_buf;
 
-	if ((status == 0) && (rtas_elog->severity >= RTAS_SEVERITY_ERROR_SYNC))
+	if ((status == 0) &&
+	    (rtas_error_severity(rtas_elog) >= RTAS_SEVERITY_ERROR_SYNC))
 		fatal = 1;
 	else
 		fatal = 0;
@@ -300,13 +301,15 @@ static struct rtas_error_log *fwnmi_get_errinfo(struct pt_regs *regs)
 
 	/* If it isn't an extended log we can use the per cpu 64bit buffer */
 	h = (struct rtas_error_log *)&savep[1];
-	if (!h->extended) {
+	if (!rtas_error_extended(h)) {
 		memcpy(&__get_cpu_var(mce_data_buf), h, sizeof(__u64));
 		errhdr = (struct rtas_error_log *)&__get_cpu_var(mce_data_buf);
 	} else {
-		int len;
+		int len, error_log_length;
+
+		error_log_length = 8 + be32_to_cpu(h->extended_log_length);
+		len = max_t(int, error_log_length, RTAS_ERROR_LOG_MAX);
 
-		len = max_t(int, 8+h->extended_log_length, RTAS_ERROR_LOG_MAX);
 		memset(global_mce_data_buf, 0, RTAS_ERROR_LOG_MAX);
 		memcpy(global_mce_data_buf, h, len);
 		errhdr = (struct rtas_error_log *)global_mce_data_buf;
@@ -350,23 +353,24 @@ int pSeries_system_reset_exception(struct pt_regs *regs)
 static int recover_mce(struct pt_regs *regs, struct rtas_error_log *err)
 {
 	int recovered = 0;
+	int disposition = rtas_error_disposition(err);
 
 	if (!(regs->msr & MSR_RI)) {
 		/* If MSR_RI isn't set, we cannot recover */
 		recovered = 0;
 
-	} else if (err->disposition == RTAS_DISP_FULLY_RECOVERED) {
+	} else if (disposition == RTAS_DISP_FULLY_RECOVERED) {
 		/* Platform corrected itself */
 		recovered = 1;
 
-	} else if (err->disposition == RTAS_DISP_LIMITED_RECOVERY) {
+	} else if (disposition == RTAS_DISP_LIMITED_RECOVERY) {
 		/* Platform corrected itself but could be degraded */
 		printk(KERN_ERR "MCE: limited recovery, system may "
 		       "be degraded\n");
 		recovered = 1;
 
 	} else if (user_mode(regs) && !is_global_init(current) &&
-		   err->severity == RTAS_SEVERITY_ERROR_SYNC) {
+		   rtas_error_severity(err) == RTAS_SEVERITY_ERROR_SYNC) {
 
 		/*
 		 * If we received a synchronous error when in userspace

