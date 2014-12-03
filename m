Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaLCPXr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 10:23:47 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:49900 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbaLCPXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 10:23:45 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Mel Gorman <mgorman@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LinuxPPC-dev <linuxppc-dev@lists.ozlabs.org>,
        Hugh Dickins <hughd@google.com>, Dave Jones <davej@redhat.com>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Paul Mackerras <paulus@samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 03/10] mm: Convert p[te|md]_numa users to p[te|md]_protnone_numa
In-Reply-To: <1417551115.27448.7.camel@kernel.crashing.org>
References: <1416578268-19597-1-git-send-email-mgorman@suse.de> <1416578268-19597-4-git-send-email-mgorman@suse.de> <1417473762.7182.8.camel@kernel.crashing.org> <87k32ah5q3.fsf@linux.vnet.ibm.com> <1417551115.27448.7.camel@kernel.crashing.org>
User-Agent: Notmuch/0.19+2~g32855b9 (http://notmuchmail.org) Emacs/25.0.50.1 (x86_64-pc-linux-gnu)
Date: Wed, 03 Dec 2014 20:53:37 +0530
Message-ID: <87lhmobvuu.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120315-4790-0000-0000-0000055BD9F5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:

> On Tue, 2014-12-02 at 12:57 +0530, Aneesh Kumar K.V wrote:
>> Now, hash_preload can possibly insert an hpte in hash page table even if
>> the access is not allowed by the pte permissions. But i guess even that
>> is ok. because we will fault again, end-up calling hash_page_mm where we
>> handle that part correctly.
>
> I think we need a test case...
>

I ran the subpageprot test that Paul had written. I modified it to ran
with selftest. 

commit 0cd3756bce6880a13de49406ce5c8537712c9bf8
Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date:   Wed Dec 3 20:40:06 2014 +0530

    selftest/ppc: Add subpage protection self test.
    
    Originally written by  Paul Mackerras <paulus@samba.org>
    
    Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

diff --git a/tools/testing/selftests/powerpc/mm/Makefile b/tools/testing/selftests/powerpc/mm/Makefile
index 357ccbd6bad9..fb00c6f7d675 100644
--- a/tools/testing/selftests/powerpc/mm/Makefile
+++ b/tools/testing/selftests/powerpc/mm/Makefile
@@ -1,7 +1,7 @@
 noarg:
 	$(MAKE) -C ../
 
-PROGS := hugetlb_vs_thp_test
+PROGS := hugetlb_vs_thp_test subpage_prot
 
 all: $(PROGS)
 
diff --git a/tools/testing/selftests/powerpc/mm/subpage_prot.c b/tools/testing/selftests/powerpc/mm/subpage_prot.c
new file mode 100644
index 000000000000..1efeafc2e175
--- /dev/null
+++ b/tools/testing/selftests/powerpc/mm/subpage_prot.c
@@ -0,0 +1,150 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <signal.h>
+#include <stdarg.h>
+#include <sys/ptrace.h>
+#include <sys/mman.h>
+#include <errno.h>
+#include <ucontext.h>
+#include <assert.h>
+
+#include "utils.h"
+
+void *mallocblock;
+unsigned long mallocsize;
+void *fileblock;
+off_t filesize;
+
+int in_test;
+volatile int faulted;
+volatile void *dar;
+int errors;
+
+static void segv(int signum, siginfo_t *info, void *ctxt_v)
+{
+	ucontext_t *ctxt = (ucontext_t *)ctxt_v;
+	struct pt_regs *regs = ctxt->uc_mcontext.regs;
+
+	if (!in_test) {
+		fprintf(stderr, "Segfault outside of test !\n");
+		exit(1);
+	}
+	faulted = 1;
+	dar = (void *)regs->dar;
+	regs->nip += 4;
+}
+
+static inline void do_read(const volatile void *addr)
+{
+	int ret;
+	asm volatile("lwz %0,0(%1); twi 0,%0,0; isync;\n"
+		     : "=r" (ret) : "r" (addr) : "memory");
+}
+
+static inline void do_write(const volatile void *addr)
+{
+	int val = 0x1234567;
+	asm volatile("stw %0,0(%1); sync; \n"
+		     : : "r" (val), "r" (addr) : "memory");
+}
+
+static inline void check_faulted(void *addr, long page, long subpage, int write)
+{
+	int want_fault = (subpage == ((page + 3) % 16));
+
+	if (write)
+		want_fault |= (subpage == ((page + 1) % 16));
+
+	if (faulted != want_fault) {
+		printf("Failed at 0x%p (p=%ld,sp=%ld,w=%d), want=%s, got=%s !\n",
+		       addr, page, subpage, write,
+		       want_fault ? "fault" : "pass",
+		       faulted ? "fault" : "pass");
+		++errors;
+	}
+	if (faulted) {
+		if (dar != addr) {
+			printf("Fault expected at 0x%p and happened at 0x%p !\n",
+			       addr, dar);
+		}
+		faulted = 0;
+		asm volatile("sync" : : : "memory");
+	}
+}
+
+static int run_test(void *addr, unsigned long size)
+{
+	unsigned int *map;
+	long i, j, pages, err;
+
+	pages = size / 0x10000;
+	map = malloc(pages * 4);
+	assert(map);
+
+	/* for each page, mark subpage i % 16 read only and subpage
+	 * (i + 3) % 16 inaccessible
+	 */
+	for (i = 0; i < pages; i++)
+		map[i] = (0x40000000 >> (((i + 1) * 2) % 32)) |
+			(0xc0000000 >> (((i + 3) * 2) % 32));
+	err = syscall(310, addr, size, map);
+	if (err) {
+		perror("subpage_perm");
+		return 1;
+	}
+	free(map);
+
+	in_test = 1;
+	errors = 0;
+	for (i = 0; i < pages; i++)
+		for (j = 0; j < 16; j++, addr += 0x1000) {
+			do_read(addr);
+			check_faulted(addr, i, j, 0);
+			do_write(addr);
+			check_faulted(addr, i, j, 1);
+		}
+	in_test = 0;
+	if (errors) {
+		printf("%d errors detected\n", errors);
+		return 1;
+	}
+	printf("OK\n");
+	return 0;
+}
+
+int test_main(void)
+{
+	unsigned long align;
+
+	if (getpagesize() != 0x10000) {
+		fprintf(stderr, "Kernel page size must be 64K!\n");
+		return 1;
+	}
+
+	struct sigaction act = {
+		.sa_sigaction = segv,
+		.sa_flags = SA_SIGINFO
+	};
+	sigaction(SIGSEGV, &act, NULL);
+
+	mallocsize = 4*16*1024*1024;
+	posix_memalign(&mallocblock, 64*1024, mallocsize);
+	assert(mallocblock);
+	align = (unsigned long)mallocblock;
+	if (align & 0xffff)
+		align = (align | 0xffff) + 1;
+	mallocblock = (void *)align;
+
+	printf("allocated malloc block of 0x%lx bytes at 0x%p\n",
+	       mallocsize, mallocblock);
+
+	printf("testing malloc block...\n");
+	return run_test(mallocblock, mallocsize);
+}
+
+int main(void)
+{
+	return test_harness(test_main, "subpage_prot");
+}

