Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbaHFWcG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 18:32:06 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:45452 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291AbaHFWcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 18:32:05 -0400
X-Originating-IP: 173.246.103.110
Date: Wed, 6 Aug 2014 15:31:54 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        David Rientjes <rientjes@google.com>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] x86: Add "make tinyconfig" to configure the tiniest
 possible kernel
Message-ID: <20140806223152.GA14348@jtriplet-mobl1>
References: <20140806222419.GA2566@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140806222419.GA2566@jtriplet-mobl1>
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

v2: Based this on Luis's helper, added in patch 1/2, which eliminates
the previously duplicated implementation from kvmconfig.

 arch/x86/Makefile            | 5 +++++
 arch/x86/configs/tiny.config | 5 +++++
 2 files changed, 10 insertions(+)
 create mode 100644 arch/x86/configs/tiny.config

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 1568678..2b5ca16 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -257,6 +257,10 @@ PHONY += kvmconfig
 kvmconfig:
 	$(call mergeconfig,kvm_guest)
 
+PHONY += tinyconfig
+tinyconfig: allnoconfig
+	$(call mergeconfig,tiny)
+
 define archhelp
   echo  '* bzImage      - Compressed kernel image (arch/x86/boot/bzImage)'
   echo  '  install      - Install kernel using'
@@ -271,4 +275,5 @@ define archhelp
   echo  '                  FDARGS="..."  arguments for the booted kernel'
   echo  '                  FDINITRD=file initrd for the booted kernel'
   echo  '  kvmconfig	- Enable additional options for guest kernel support'
+  echo  '  tinyconfig   - Configure the tiniest possible kernel'
 endef
diff --git a/arch/x86/configs/tiny.config b/arch/x86/configs/tiny.config
new file mode 100644
index 0000000..8f0e54c
--- /dev/null
+++ b/arch/x86/configs/tiny.config
@@ -0,0 +1,5 @@
+CONFIG_CC_OPTIMIZE_FOR_SIZE=y
+CONFIG_KERNEL_XZ=y
+CONFIG_NOHIGHMEM=y
+CONFIG_OPTIMIZE_INLINING=y
+CONFIG_SLOB=y
-- 
2.1.0.rc1

