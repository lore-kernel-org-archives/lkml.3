Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbaLOOvJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:51:09 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:40519 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbaLOOvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:51:04 -0500
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        acme@kernel.org, mpe@ellerman.id.au
Cc: ananth@in.ibm.com
Subject: [PATCHv2 3/8] perf probe powerpc: Fix symbol fixup issues due to ELF type
Date: Mon, 15 Dec 2014 20:20:33 +0530
Message-Id: <a31f3cfd0841bea8e615ebd6f8f0ec5a0d1f1eaa.1418654436.git.naveen.n.rao@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <cover.1418654435.git.naveen.n.rao@linux.vnet.ibm.com>
References: <cover.1418654435.git.naveen.n.rao@linux.vnet.ibm.com>
In-Reply-To: <cover.1418654435.git.naveen.n.rao@linux.vnet.ibm.com>
References: <cover.1418654435.git.naveen.n.rao@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121514-0025-0000-0000-000000BD8B24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If using the symbol table, symbol addresses are not being fixed up
properly, resulting in probes being placed at wrong addresses:

  # perf probe do_fork
  Added new event:
    probe:do_fork        (on do_fork)

  You can now use it in all perf tools, such as:

	  perf record -e probe:do_fork -aR sleep 1

  # cat /sys/kernel/debug/tracing/kprobe_events
  p:probe/do_fork _text+635952
  # printf "%x" 635952
  9b430
  # grep do_fork /boot/System.map
  c0000000000ab430 T .do_fork

Fix by checking for ELF type ET_DYN used by ppc64 kernels.

Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
 tools/perf/util/symbol-elf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 06fcd1b..7ac4e4c 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -683,7 +683,8 @@ int symsrc__init(struct symsrc *ss, struct dso *dso, const char *name,
 						     NULL) != NULL);
 	} else {
 		ss->adjust_symbols = ehdr.e_type == ET_EXEC ||
-				     ehdr.e_type == ET_REL;
+				     ehdr.e_type == ET_REL ||
+				     ehdr.e_type == ET_DYN;
 	}
 
 	ss->name   = strdup(name);
-- 
2.1.3

