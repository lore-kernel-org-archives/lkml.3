Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759772AbaGPFLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 01:11:25 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:47976 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756816AbaGPFLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 01:11:22 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: kvm@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, x86@kernel.org
Cc: Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH kvm-unit-tests] Add a test case for MSR_KVM_GET_RNG_SEED
Date: Tue, 15 Jul 2014 22:11:16 -0700
Message-Id: <d15eb210fc4f8ff5b8e2a82300be49df159d1aac.1405487456.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 config/config-x86-common.mak |  5 ++++-
 x86/get_rng_seed.c           | 50 ++++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg            |  3 +++
 3 files changed, 57 insertions(+), 1 deletion(-)
 create mode 100644 x86/get_rng_seed.c

diff --git a/config/config-x86-common.mak b/config/config-x86-common.mak
index 0b0da85..201a029 100644
--- a/config/config-x86-common.mak
+++ b/config/config-x86-common.mak
@@ -35,7 +35,8 @@ tests-common = $(TEST_DIR)/vmexit.flat $(TEST_DIR)/tsc.flat \
                $(TEST_DIR)/kvmclock_test.flat  $(TEST_DIR)/eventinj.flat \
                $(TEST_DIR)/s3.flat $(TEST_DIR)/pmu.flat \
                $(TEST_DIR)/tsc_adjust.flat $(TEST_DIR)/asyncpf.flat \
-               $(TEST_DIR)/init.flat $(TEST_DIR)/smap.flat
+               $(TEST_DIR)/init.flat $(TEST_DIR)/smap.flat \
+               $(TEST_DIR)/get_rng_seed.flat
 
 ifdef API
 tests-common += api/api-sample
@@ -105,6 +106,8 @@ $(TEST_DIR)/vmx.elf: $(cstart.o) $(TEST_DIR)/vmx.o $(TEST_DIR)/vmx_tests.o
 
 $(TEST_DIR)/debug.elf: $(cstart.o) $(TEST_DIR)/debug.o
 
+$(TEST_DIR)/get_rng_seed.elf: $(cstart.o) $(TEST_DIR)/get_rng_seed.o
+
 arch_clean:
 	$(RM) $(TEST_DIR)/*.o $(TEST_DIR)/*.flat $(TEST_DIR)/*.elf \
 	$(TEST_DIR)/.*.d lib/x86/.*.d
diff --git a/x86/get_rng_seed.c b/x86/get_rng_seed.c
new file mode 100644
index 0000000..b2e1b01
--- /dev/null
+++ b/x86/get_rng_seed.c
@@ -0,0 +1,50 @@
+/*
+ * Simple test for MSR_KVM_GET_RNG_SEED.
+ */
+#include "x86/msr.h"
+#include "x86/processor.h"
+#include "x86/apic-defs.h"
+#include "x86/apic.h"
+#include "x86/desc.h"
+#include "x86/isr.h"
+#include "x86/vm.h"
+
+#include "libcflat.h"
+#include <stdint.h>
+
+#define MSR_KVM_GET_RNG_SEED 0x4b564d05
+
+volatile int ngpfs;
+bool fail;
+
+static void gpf_isr(struct ex_regs *r)
+{
+	ngpfs++;
+	r->rip += 2;
+}
+
+int main(int ac, char **av)
+{
+	int loop = 3;
+	u64 val, prev = 0;
+
+	setup_vm();
+	setup_idt();
+	while(loop--) {
+		val = rdmsr(MSR_KVM_GET_RNG_SEED);
+		printf("rng seed: %llx\n", (unsigned long)val);
+		if (val == prev)
+			fail = true;
+		prev = val;
+	}
+
+	handle_exception(13, gpf_isr);
+	wrmsr(MSR_KVM_GET_RNG_SEED, 0);
+	if (ngpfs != 1) {
+		printf("error: wrmsr(MSR_KVM_GET_RNG_SEED) should not work\n");
+		fail = true;
+	}
+
+	printf("%s\n", fail ? "FAIL" : "PASS");
+	return fail;
+}
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index d78fe0e..98e5c7b 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -158,3 +158,6 @@ arch = x86_64
 [debug]
 file = debug.flat
 arch = x86_64
+
+[get_rng_seed]
+file = get_rnd_seed.flat
-- 
1.9.3

