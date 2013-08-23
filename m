Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab3HWPP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 11:15:26 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:34498 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906Ab3HWPPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 11:15:23 -0400
Message-ID: <52177C87.4090003@linux.vnet.ibm.com>
Date: Fri, 23 Aug 2013 17:15:19 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
MIME-Version: 1.0
To: Frantisek Hrbata <fhrbata@redhat.com>
CC: linux-kernel@vger.kernel.org, jstancek@redhat.com, keescook@chromium.org,
        rusty@rustcorp.com.au, linux-arch@vger.kernel.org, arnd@arndb.de,
        mgahagan@redhat.com, agospoda@redhat.com
Subject: Re: [RFC PATCH 3/4] gcov: compile specific gcov implementation based
 on gcc version
References: <1377247176-13537-1-git-send-email-fhrbata@redhat.com> <1377247176-13537-4-git-send-email-fhrbata@redhat.com>
In-Reply-To: <1377247176-13537-4-git-send-email-fhrbata@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082315-5024-0000-0000-000006FF6468
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.08.2013 10:39, Frantisek Hrbata wrote:
> Compile the correct gcov implementation file for a specific gcc version. In
> the future, if another file is added, the conditions will need to be somehow
> adjusted to if-elif-else case, but at this point the simple cc-ifversion should
> be enough.

Looks good, though I think this could be merged into the main 4.7 format patch,
since without it, the 4.7 code will never be reached.

Also it is my understanding that there are some distribution-specific versions
of GCC that include the 4.7. gcov format code but report GCC version 4.6. With
the auto-detection code implemented like this, gcov-kernel won't work correctly.
For that purpose I've implemented a configuration option to allow users to
force a specific version of gcov format.

I'm attaching the corresponding patch below:

---
kernel: gcov: make data format configurable

Make the format of the generated gcov data configurable. This may be
required for example for pre-4.7 GCCs that contain the 4.7 gcov data
format changes.

Signed-off-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
---
 kernel/gcov/Kconfig  |   30 ++++++++++++++++++++++++++++++
 kernel/gcov/Makefile |   21 +++++++++++++++++++--
 2 files changed, 49 insertions(+), 2 deletions(-)

--- a/kernel/gcov/Kconfig
+++ b/kernel/gcov/Kconfig
@@ -46,4 +46,34 @@ config GCOV_PROFILE_ALL
 	larger and run slower. Also be sure to exclude files from profiling
 	which are not linked to the kernel image to prevent linker errors.

+choice
+	prompt "Specify GCOV format"
+	depends on GCOV_KERNEL
+	default GCOV_FORMAT_AUTODETECT
+	---help---
+	The gcov format is usually determined by the GCC version, but there are
+	exceptions where format changes are integrated in lower-version GCCs.
+	In such a case use this option to adjust the format used in the kernel
+	accordingly.
+
+	If unsure, choose "Autodetect".
+
+config GCOV_FORMAT_AUTODETECT
+	bool "Autodetect"
+	---help---
+	Select this option to use the format that corresponds to your GCC
+	version.
+
+config GCOV_FORMAT_3_4
+	bool "GCC 3.4 format"
+	---help---
+	Select this option to use the format defined by GCC 3.4.
+
+config GCOV_FORMAT_4_7
+	bool "GCC 4.7 format"
+	---help---
+	Select this option to use the format defined by GCC 4.7.
+
+endchoice
+
 endmenu
--- a/kernel/gcov/Makefile
+++ b/kernel/gcov/Makefile
@@ -1,5 +1,22 @@
 ccflags-y := -DSRCTREE='"$(srctree)"' -DOBJTREE='"$(objtree)"'

+# if-lt
+# Usage VAR := $(call if-lt, $(a), $(b))
+# Returns 1 if (a < b)
+if-lt = $(shell [ $(1) -lt $(2) ] && echo 1)
+
+ifeq ($(CONFIG_GCOV_FORMAT_3_4),y)
+  cc-ver := 0304
+else ifeq ($(CONFIG_GCOV_FORMAT_4_7),y)
+  cc-ver := 0407
+else
+  cc-ver := $(call cc-version)
+endif
+
 obj-$(CONFIG_GCOV_KERNEL) := base.o fs.o
-obj-$(CONFIG_GCOV_KERNEL) += $(call cc-ifversion, -lt, 0407, gcc_3_4.o)
-obj-$(CONFIG_GCOV_KERNEL) += $(call cc-ifversion, -ge, 0407, gcc_4_7.o)
+
+ifeq ($(call if-lt, $(cc-ver), 0407),1)
+  obj-$(CONFIG_GCOV_KERNEL) += gcc_3_4.o
+else
+  obj-$(CONFIG_GCOV_KERNEL) += gcc_4_7.o
+endif


-- 
Peter Oberparleiter
Linux on System z Development - IBM Germany

