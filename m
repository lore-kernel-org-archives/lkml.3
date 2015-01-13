Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbbAMKXG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 05:23:06 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:36089 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbbAMKXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 05:23:01 -0500
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc: mpe@ellerman.id.au, benh@kernel.crashing.org, anton@samba.org,
        mikey@neuling.org, shuahkh@osg.samsung.com
Subject: [PATCH V2 04/12] powerpc, dscr: Added some in-code documentation
Date: Tue, 13 Jan 2015 15:52:32 +0530
Message-Id: <1421144560-15901-5-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421144560-15901-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1421144560-15901-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011310-0033-0000-0000-000000EA6C00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds some in-code documentation to the DSCR related
code to make it more readable without having any functional
change to it.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/processor.h |  9 +++++++++
 arch/powerpc/kernel/sysfs.c          | 38 ++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/arch/powerpc/include/asm/processor.h b/arch/powerpc/include/asm/processor.h
index bf117d8..28ded5d 100644
--- a/arch/powerpc/include/asm/processor.h
+++ b/arch/powerpc/include/asm/processor.h
@@ -295,6 +295,15 @@ struct thread_struct {
 #endif
 #ifdef CONFIG_PPC64
 	unsigned long	dscr;
+	/*
+	 * This member element dscr_inherit indicates that the process
+	 * has explicitly attempted and changed the DSCR register value
+	 * for itself. Hence kernel wont use the default CPU DSCR value
+	 * contained in the PACA structure anymore during process context
+	 * switch. Once this variable is set, this behaviour will also be
+	 * inherited to all the children of this process from that point
+	 * onwards.
+	 */
 	int		dscr_inherit;
 	unsigned long	ppr;	/* used to save/restore SMT priority */
 #endif
diff --git a/arch/powerpc/kernel/sysfs.c b/arch/powerpc/kernel/sysfs.c
index fa1fd8a..692873b 100644
--- a/arch/powerpc/kernel/sysfs.c
+++ b/arch/powerpc/kernel/sysfs.c
@@ -496,13 +496,34 @@ static DEVICE_ATTR(spurr, 0400, show_spurr, NULL);
 static DEVICE_ATTR(purr, 0400, show_purr, store_purr);
 static DEVICE_ATTR(pir, 0400, show_pir, NULL);
 
+/*
+ * This is the system wide DSCR register default value. Any
+ * change to this default value through the sysfs interface
+ * will update all per cpu DSCR default values across the
+ * system stored in their respective PACA structures.
+ */
 static unsigned long dscr_default;
 
+/**
+ * read_dscr() - Fetch the cpu specific DSCR default
+ * @val:	Returned cpu specific DSCR default value
+ *
+ * This function returns the per cpu DSCR default value
+ * for any cpu which is contained in it's PACA structure.
+ */
 static void read_dscr(void *val)
 {
 	*(unsigned long *)val = get_paca()->dscr_default;
 }
 
+
+/**
+ * write_dscr() - Update the cpu specific DSCR default
+ * @val:	New cpu specific DSCR default value to update
+ *
+ * This function updates the per cpu DSCR default value
+ * for any cpu which is contained in it's PACA structure.
+ */
 static void write_dscr(void *val)
 {
 	get_paca()->dscr_default = *(unsigned long *)val;
@@ -520,12 +541,29 @@ static void add_write_permission_dev_attr(struct device_attribute *attr)
 	attr->attr.mode |= 0200;
 }
 
+/**
+ * show_dscr_default() - Fetch the system wide DSCR default
+ * @dev:	Device structure
+ * @attr:	Device attribute structure
+ * @buf:	Interface buffer
+ *
+ * This function returns the system wide DSCR default value.
+ */
 static ssize_t show_dscr_default(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	return sprintf(buf, "%lx\n", dscr_default);
 }
 
+/**
+ * store_dscr_default() - Update the system wide DSCR default
+ * @dev:	Device structure
+ * @attr:	Device attribute structure
+ * @buf:	Interface buffer
+ * @count:	Size of the update
+ *
+ * This function updates the system wide DSCR default value.
+ */
 static ssize_t __used store_dscr_default(struct device *dev,
 		struct device_attribute *attr, const char *buf,
 		size_t count)
-- 
1.9.3

