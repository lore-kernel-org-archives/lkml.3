Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab3G2PWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 11:22:37 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43988 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445Ab3G2PWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 11:22:33 -0400
Date: Mon, 29 Jul 2013 17:22:30 +0200
From: Borislav Petkov <bp@alien8.de>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>, Kees Cook <keescook@chromium.org>,
        Tony Luck <tony.luck@intel.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH] APEI/ERST: Fix error message formatting
Message-ID: <20130729152230.GG6634@pd.tnic>
References: <1374526866-6813-1-git-send-email-bp@alien8.de>
 <20130724171347.GB29756@naverao1-tp.watson.ibm.com>
 <1374686598.18818.18.camel@joe-AO722>
 <51F10AA8.2050901@linux.vnet.ibm.com>
 <CAErSpo5vLbsM5BXjrCVy1AKBxRRSH33TthyyK3O35Mghqw81nQ@mail.gmail.com>
 <20130729135812.GD6634@pd.tnic>
 <CAErSpo6fbMmicX95j_wYkJRnQeJEZ_jQSm76j9ZN4sHP0C2Yhg@mail.gmail.com>
 <20130729144046.GE6634@pd.tnic>
 <CAErSpo69wNc1h6PyJhFfhdFzz0GOiM=SCCfrm-WO5XDFTFzcHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAErSpo69wNc1h6PyJhFfhdFzz0GOiM=SCCfrm-WO5XDFTFzcHw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 08:50:19AM -0600, Bjorn Helgaas wrote:
> If I were the firmware developer and got a report about this message,
> I think the information I would want is ctx->ip, so I could identify
> the corresponding source code. But I don't know much about the ERST
> interpreter, so I don't know if "ctx->ip" is the right place to look.

Well, __apei_exec_run() really does update ctx->ip when executing
actions but if you read the comment in that function, it says it
actually points to the next RIP to be executed. Which is not what we
want in that case, IMO.

> Maybe there's a method name or table name that would be needed in
> addition.
>
> It just seems like "ERST: Too long stall time for stall instruction:
> 4732." all by itself doesn't really contain any actionable
> information.

Right, I'll make it be a hex "0x" in both stall-functions and leave it
to someone more ACPI-knowledgeable to decide what goes in there - my
patch is a simple cleanup anyway.

Here's an updated version:

---
From: Borislav Petkov <bp@suse.de>
Date: Mon, 29 Jul 2013 15:51:35 +0200
Subject: [PATCH] [PATCH] APEI/ERST: Fix error message formatting

... according to acpi/apei/ conventions. Use standard pr_fmt prefix
while at it.

Also, make add the "0x" prefix to the stalled instruction functions
error path and make the iomem region closed on both ends.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 drivers/acpi/apei/erst.c | 47 +++++++++++++++++++++--------------------------
 1 file changed, 21 insertions(+), 26 deletions(-)

diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index 88d0b0f9f92b..4e342692d304 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -39,7 +39,8 @@
 
 #include "apei-internal.h"
 
-#define ERST_PFX "ERST: "
+#undef pr_fmt
+#define pr_fmt(fmt) "ERST: " fmt
 
 /* ERST command status */
 #define ERST_STATUS_SUCCESS			0x0
@@ -109,8 +110,7 @@ static inline int erst_errno(int command_status)
 static int erst_timedout(u64 *t, u64 spin_unit)
 {
 	if ((s64)*t < spin_unit) {
-		pr_warning(FW_WARN ERST_PFX
-			   "Firmware does not respond in time\n");
+		pr_warn(FW_WARN "Firmware does not respond in time\n");
 		return 1;
 	}
 	*t -= spin_unit;
@@ -186,8 +186,8 @@ static int erst_exec_stall(struct apei_exec_context *ctx,
 
 	if (ctx->value > FIRMWARE_MAX_STALL) {
 		if (!in_nmi())
-			pr_warning(FW_WARN ERST_PFX
-			"Too long stall time for stall instruction: %llx.\n",
+			pr_warn(FW_WARN
+			"Too long stall time for stall instruction: 0x%llx.\n",
 				   ctx->value);
 		stall_time = FIRMWARE_MAX_STALL;
 	} else
@@ -206,8 +206,8 @@ static int erst_exec_stall_while_true(struct apei_exec_context *ctx,
 
 	if (ctx->var1 > FIRMWARE_MAX_STALL) {
 		if (!in_nmi())
-			pr_warning(FW_WARN ERST_PFX
-		"Too long stall time for stall while true instruction: %llx.\n",
+			pr_warn(FW_WARN
+		"Too long stall time for stall while true instruction: 0x%llx.\n",
 				   ctx->var1);
 		stall_time = FIRMWARE_MAX_STALL;
 	} else
@@ -271,8 +271,7 @@ static int erst_exec_move_data(struct apei_exec_context *ctx,
 
 	/* ioremap does not work in interrupt context */
 	if (in_interrupt()) {
-		pr_warning(ERST_PFX
-			   "MOVE_DATA can not be used in interrupt context");
+		pr_warn("MOVE_DATA can not be used in interrupt context");
 		return -EBUSY;
 	}
 
@@ -522,8 +521,7 @@ retry:
 				     ERST_RECORD_ID_CACHE_SIZE_MAX);
 		if (new_size <= erst_record_id_cache.size) {
 			if (printk_ratelimit())
-				pr_warning(FW_WARN ERST_PFX
-					   "too many record ID!\n");
+				pr_warn(FW_WARN "too many record IDs!\n");
 			return 0;
 		}
 		alloc_size = new_size * sizeof(entries[0]);
@@ -759,8 +757,7 @@ static int __erst_clear_from_storage(u64 record_id)
 static void pr_unimpl_nvram(void)
 {
 	if (printk_ratelimit())
-		pr_warning(ERST_PFX
-		"NVRAM ERST Log Address Range is not implemented yet\n");
+		pr_warn("NVRAM ERST Log Address Range is not implemented yet\n");
 }
 
 static int __erst_write_to_nvram(const struct cper_record_header *record)
@@ -1120,7 +1117,7 @@ static int __init erst_init(void)
 		goto err;
 
 	if (erst_disable) {
-		pr_info(ERST_PFX
+		pr_info(
 	"Error Record Serialization Table (ERST) support is disabled.\n");
 		goto err;
 	}
@@ -1131,14 +1128,14 @@ static int __init erst_init(void)
 		goto err;
 	else if (ACPI_FAILURE(status)) {
 		const char *msg = acpi_format_exception(status);
-		pr_err(ERST_PFX "Failed to get table, %s\n", msg);
+		pr_err("Failed to get table, %s\n", msg);
 		rc = -EINVAL;
 		goto err;
 	}
 
 	rc = erst_check_table(erst_tab);
 	if (rc) {
-		pr_err(FW_BUG ERST_PFX "ERST table is invalid\n");
+		pr_err(FW_BUG "ERST table is invalid\n");
 		goto err;
 	}
 
@@ -1156,21 +1153,19 @@ static int __init erst_init(void)
 	rc = erst_get_erange(&erst_erange);
 	if (rc) {
 		if (rc == -ENODEV)
-			pr_info(ERST_PFX
+			pr_info(
 	"The corresponding hardware device or firmware implementation "
 	"is not available.\n");
 		else
-			pr_err(ERST_PFX
-			       "Failed to get Error Log Address Range.\n");
+			pr_err("Failed to get Error Log Address Range.\n");
 		goto err_unmap_reg;
 	}
 
 	r = request_mem_region(erst_erange.base, erst_erange.size, "APEI ERST");
 	if (!r) {
-		pr_err(ERST_PFX
-		"Can not request iomem region <0x%16llx-0x%16llx> for ERST.\n",
-		(unsigned long long)erst_erange.base,
-		(unsigned long long)erst_erange.base + erst_erange.size);
+		pr_err("Can not request [mem %#010llx-%#010llx] for ERST.\n",
+		       (unsigned long long)erst_erange.base,
+		       (unsigned long long)erst_erange.base + erst_erange.size - 1);
 		rc = -EIO;
 		goto err_unmap_reg;
 	}
@@ -1180,7 +1175,7 @@ static int __init erst_init(void)
 	if (!erst_erange.vaddr)
 		goto err_release_erange;
 
-	pr_info(ERST_PFX
+	pr_info(
 	"Error Record Serialization Table (ERST) support is initialized.\n");
 
 	buf = kmalloc(erst_erange.size, GFP_KERNEL);
@@ -1192,14 +1187,14 @@ static int __init erst_init(void)
 		rc = pstore_register(&erst_info);
 		if (rc) {
 			if (rc != -EPERM)
-				pr_info(ERST_PFX
+				pr_info(
 				"Could not register with persistent store\n");
 			erst_info.buf = NULL;
 			erst_info.bufsize = 0;
 			kfree(buf);
 		}
 	} else
-		pr_err(ERST_PFX
+		pr_err(
 		"Failed to allocate %lld bytes for persistent store error log\n",
 		erst_erange.size);
 
-- 
1.8.3



-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine. --
