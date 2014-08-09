Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbaHIAKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 20:10:24 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:50378 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaHIAKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 20:10:23 -0400
X-Originating-IP: 173.246.103.110
Date: Fri, 8 Aug 2014 17:10:12 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        Sam Ravnborg <sam@ravnborg.org>, David Rientjes <rientjes@google.com>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] x86: Add "make tinyconfig" to configure the tiniest
 possible kernel
Message-ID: <20140809001010.GA9437@jtriplet-mobl1>
References: <20140807190243.GA5580@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140807190243.GA5580@jtriplet-mobl1>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 5d2acfc7b974bbd3858b4dd3f2cdc6362dd8843a ("kconfig: make
allnoconfig disable options behind EMBEDDED and EXPERT") in 3.15-rc1,
"make allnoconfig" disables every possible config option.

However, a few configuration options (CC_OPTIMIZE_FOR_SIZE,
OPTIMIZE_INLINING) produce a smaller kernel when turned on, and a few
choices exist (compression, highmem, allocator) for which a non-default
option produces a smaller kernel.

Add a "tinyconfig" option, which starts from allnoconfig and then sets
these options to configure the tiniest possible kernel.  This provides a
better baseline for embedded systems or efforts to reduce kernel size.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---

Any architecture with architecture-specific tinification options just
needs to create arch/${arch}/configs/tiny.config, and "make tinyconfig"
will automatically pick up those options in addition to the
architecture-independent ones in kernel/configs/tiny.config.

 arch/x86/configs/tiny.config | 1 +
 kernel/configs/tiny.config   | 4 ++++
 scripts/kconfig/Makefile     | 5 +++++
 3 files changed, 10 insertions(+)
 create mode 100644 arch/x86/configs/tiny.config
 create mode 100644 kernel/configs/tiny.config

diff --git a/arch/x86/configs/tiny.config b/arch/x86/configs/tiny.config
new file mode 100644
index 0000000..4e2ecfa
--- /dev/null
+++ b/arch/x86/configs/tiny.config
@@ -0,0 +1 @@
+CONFIG_NOHIGHMEM=y
diff --git a/kernel/configs/tiny.config b/kernel/configs/tiny.config
new file mode 100644
index 0000000..c2de56a
--- /dev/null
+++ b/kernel/configs/tiny.config
@@ -0,0 +1,4 @@
+CONFIG_CC_OPTIMIZE_FOR_SIZE=y
+CONFIG_KERNEL_XZ=y
+CONFIG_OPTIMIZE_INLINING=y
+CONFIG_SLOB=y
diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 8083b94..ebf40f6 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -117,6 +117,10 @@ PHONY += kvmconfig
 kvmconfig:
 	$(call mergeconfig,kvm_guest)
 
+PHONY += tinyconfig
+tinyconfig: allnoconfig
+	$(call mergeconfig,tiny)
+
 # Help text used by make help
 help:
 	@echo  '  config	  - Update current config utilising a line-oriented program'
@@ -138,6 +142,7 @@ help:
 	@echo  '  listnewconfig   - List new options'
 	@echo  '  olddefconfig	  - Same as silentoldconfig but sets new symbols to their default value'
 	@echo  '  kvmconfig	  - Enable additional options for guest kernel support'
+	@echo  '  tinyconfig	  - Configure the tiniest possible kernel'
 
 # lxdialog stuff
 check-lxdialog  := $(srctree)/$(src)/lxdialog/check-lxdialog.sh
-- 
2.1.0.rc1

