Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbaJNKtG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 06:49:06 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:47622 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbaJNKtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 06:49:05 -0400
Date: Tue, 14 Oct 2014 18:48:55 +0800
From: Real Name <enjoymindful@gmail.com>
To: linux@roeck-us.net
Cc: tj@kernel.org, starvik@axis.com, jesper.nilsson@axis.com,
        linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org
Subject: why commit 3189eddbcafc cause crisv32 panic
Message-ID: <20141014104855.GA1813@name>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

hi, Guenter
 
http://www.gossamer-threads.com/lists/linux/kernel/2011061

>[PATCH] Revert "percpu: free percpu allocation info for uniprocessor system"
>
> The commit causes a hang with a crisv32 image. This may be an architecture
> problem, but at least for now the revert is necessary to be able to boot a
> crisv32 image. 

Yes, it is a crisv32 specific issue. The crisv32 was paniced on the BUG() macro
in function mark_bootmem. The call path is :

pcpu_free_alloc_info
	-> memblock_free_early
		-> free_bootmem
			-> mark_bootmem
				-> BUG()

The root source is that arch/cris/kernel/setup.c:setup_arch compute start_pfn
and max_pfn from *virtual* address.

|---------- arch/cris/kernel/setup.c:setup_arch -----------------------
|	start_pfn = PFN_UP(memory_start);  /* usually c0000000 + kernel + romfs */
|	max_pfn =   PFN_DOWN((unsigned long)high_memory); /* usually c0000000 + dram size */
|---------- arch/cris/kernel/setup.c:setup_arch -----------------------

So, when memblock_free_early pass the *physical* address of ai to mark_bootmem.
The first if statement of mark_bootmem become ture. And then hit the BUG() macro.

After applied the attached patch, pcpu_free_alloc_info works as expect. It had
been test with your toolchain and patches you provided to me.
http://server.roeck-us.net/qemu/crisv32/

cc'ed Mikael and Jesper, as they are Axis staff.

thanks

--G4iJoqBmSsgzjUCe
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="why_3189eddbcafc_cause_crisv32_panic.patch"

diff --git a/mm/percpu.c b/mm/percpu.c
index 2139e30..cbbc946 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1097,7 +1097,12 @@ struct pcpu_alloc_info * __init pcpu_alloc_alloc_info(int nr_groups,
  */
 void __init pcpu_free_alloc_info(struct pcpu_alloc_info *ai)
 {
-	memblock_free_early(__pa(ai), ai->__ai_size);
+	/* This patch is unacceptable, as it broken other arch.
+	* It was created to explain why commit 3189eddbcafc ("percpu:
+	* free percpu allocation info for uniprocessor system") cause
+	* crisv32 panic. PLEASE DO NOT APPLY THIS PATCH.
+	*/
+	memblock_free_early((unsigned long)(ai), ai->__ai_size);
 }
 
 /**
@@ -1932,6 +1937,8 @@ void __init setup_per_cpu_areas(void)
 
 	if (pcpu_setup_first_chunk(ai, fc) < 0)
 		panic("Failed to initialize percpu areas.");
+
+	pcpu_free_alloc_info(ai);
 }
 
 #endif	/* CONFIG_SMP */

--G4iJoqBmSsgzjUCe--
