Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031702AbaGDXAE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 19:00:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57098 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760612AbaGDWQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:16:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Neuling <mikey@neuling.org>, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.15 49/66] powerpc: Dont setup CPUs with bad status
Date: Fri,  4 Jul 2014 15:14:48 -0700
Message-Id: <20140704221425.038593971@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221422.813435485@linuxfoundation.org>
References: <20140704221422.813435485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Neuling <mikey@neuling.org>

commit 59a53afe70fd530040bdc69581f03d880157f15a upstream.

OPAL will mark a CPU that is guarded as "bad" in the status property of the CPU
node.

Unfortunatley Linux doesn't check this property and will put the bad CPU in the
present map.  This has caused hangs on booting when we try to unsplit the core.

This patch checks the CPU is avaliable via this status property before putting
it in the present map.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Tested-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/setup-common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -461,7 +461,7 @@ void __init smp_setup_cpu_maps(void)
 		for (j = 0; j < nthreads && cpu < nr_cpu_ids; j++) {
 			DBG("    thread %d -> cpu %d (hard id %d)\n",
 			    j, cpu, be32_to_cpu(intserv[j]));
-			set_cpu_present(cpu, true);
+			set_cpu_present(cpu, of_device_is_available(dn));
 			set_hard_smp_processor_id(cpu, be32_to_cpu(intserv[j]));
 			set_cpu_possible(cpu, true);
 			cpu++;


