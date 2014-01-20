Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbaATVWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 16:22:31 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:36653 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbaATVWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 16:22:23 -0500
From: Jean Pihet <jean.pihet@linaro.org>
To: libunwind-devel <libunwind-devel@nongnu.org>
Cc: Will Deacon <will.deacon@arm.com>, Jiri Olsa <jolsa@redhat.com>,
        patches@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 3/3] Dwarf: unwind the recorded stack frame of different target address sizes
Date: Mon, 20 Jan 2014 22:22:02 +0100
Message-Id: <1390252922-25889-4-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1390252922-25889-1-git-send-email-jean.pihet@linaro.org>
References: <1390252922-25889-1-git-send-email-jean.pihet@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When in compat mode, correctly unwind the recorded stack frame. The
returned pointers are cast to the desired target address size.

Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
---
 src/dwarf/Gparser.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/src/dwarf/Gparser.c b/src/dwarf/Gparser.c
index b251e31..d676861 100644
--- a/src/dwarf/Gparser.c
+++ b/src/dwarf/Gparser.c
@@ -706,6 +706,29 @@ eval_location_expr (struct dwarf_cursor *c, unw_addr_space_t as,
   return 0;
 }
 
+/* Cast pointer content to the type of target address size */
+static inline int cast_value_to_addr_size(unw_word_t *val, int addr_size)
+{
+    switch (addr_size) {
+    /*
+     * Return the value of the type found at binary load time (e.g. from the
+     * ELF format)...
+     */
+    case TARGET_ADDR_SIZE_32:
+	*val = (uint32_t) *val;
+	break;
+    case TARGET_ADDR_SIZE_64:
+	*val = (uint64_t) *val;
+	break;
+    /* ... otherwise leave it as is */
+    case TARGET_ADDR_SIZE_DEFAULT:
+    default:
+	break;
+    }
+
+    return 0;
+}
+
 static int
 apply_reg_state (struct dwarf_cursor *c, struct dwarf_reg_state *rs)
 {
@@ -743,6 +766,8 @@ apply_reg_state (struct dwarf_cursor *c, struct dwarf_reg_state *rs)
 	  regnum = dwarf_to_unw_regnum (rs->reg[DWARF_CFA_REG_COLUMN].val);
 	  if ((ret = unw_get_reg ((unw_cursor_t *) c, regnum, &cfa)) < 0)
 	    return ret;
+	  /* Cast value to the type as found in the ELF binary format */
+	  cast_value_to_addr_size(&cfa, as->target_addr_size);
 	}
       cfa += rs->reg[DWARF_CFA_OFF_COLUMN].val;
     }
@@ -797,6 +822,8 @@ apply_reg_state (struct dwarf_cursor *c, struct dwarf_reg_state *rs)
     ret = dwarf_get (c, c->loc[c->ret_addr_column], &ip);
     if (ret < 0)
       return ret;
+    /* Cast value to the type as found in the ELF binary format */
+    cast_value_to_addr_size(&ip, as->target_addr_size);
     c->ip = ip;
   }
 
-- 
1.7.11.7

