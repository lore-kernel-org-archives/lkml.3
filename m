Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbaJ1DkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:40:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44799 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836AbaJ1DkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:40:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 3.17 113/146] powerpc: Fix warning reported by verify_cpu_node_mapping()
Date: Tue, 28 Oct 2014 11:34:15 +0800
Message-Id: <20141028033348.351071950@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zhong <zhong@linux.vnet.ibm.com>

commit 70ad237515d99595ed03848bd8e549e50e83c4f2 upstream.

With commit 2fabf084b6ad ("powerpc: reorder per-cpu NUMA information's
initialization"), during boottime, cpu_numa_callback() is called
earlier(before their online) for each cpu, and verify_cpu_node_mapping()
uses cpu_to_node() to check whether siblings are in the same node.

It skips the checking for siblings that are not online yet. So the only
check done here is for the bootcpu, which is online at that time. But
the per-cpu numa_node cpu_to_node() uses hasn't been set up yet (which
will be set up in smp_prepare_cpus()).

So I saw something like following reported:
[    0.000000] CPU thread siblings 1/2/3 and 0 don't belong to the same
node!

As we don't actually do the checking during this early stage, so maybe
we could directly call numa_setup_cpu() in do_init_bootmem().

Cc: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
Acked-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/mm/numa.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -1128,8 +1128,7 @@ void __init do_init_bootmem(void)
 	 * early in boot, cf. smp_prepare_cpus().
 	 */
 	for_each_possible_cpu(cpu) {
-		cpu_numa_callback(&ppc64_numa_nb, CPU_UP_PREPARE,
-				  (void *)(unsigned long)cpu);
+		numa_setup_cpu((unsigned long)cpu);
 	}
 }
 


