Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213Ab3FDRBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:01:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48460 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757178Ab3FDRBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:01:30 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 75/75] powerpc/pseries: Always enable CONFIG_HOTPLUG_CPU on PSERIES SMP
Date: Tue,  4 Jun 2013 09:55:59 -0700
Message-Id: <1370364959-9475-76-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370364959-9475-1-git-send-email-kamal@canonical.com>
References: <1370364959-9475-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>

commit f274ef8747d3be649bba8708696fb31cb00fa75a upstream.

Adam Lackorzynski reported the following build failure on
!CONFIG_HOTPLUG_CPU configuration:

  CC      arch/powerpc/kernel/rtas.o
arch/powerpc/kernel/rtas.c: In function ‘rtas_cpu_state_change_mask’:
arch/powerpc/kernel/rtas.c:843:4: error: implicit declaration of function ‘cpu_down’ [-Werror=implicit-function-declaration]
cc1: all warnings being treated as errors
make[1]: *** [arch/powerpc/kernel/rtas.o] Error 1
make: *** [arch/powerpc/kernel] Error 2

The build fails because cpu_down() is defined only under CONFIG_HOTPLUG_CPU.

Looking further, the mobility code in pseries is one of the call-sites which
uses rtas_ibm_suspend_me(), which in turn calls rtas_cpu_state_change_mask().
And the mobility code is unconditionally compiled-in (it does not fall under
any Kconfig option). And commit 120496ac (powerpc: Bring all threads online
prior to migration/hibernation) which introduced this build regression is
critical for the proper functioning of the migration code. So it appears
that the only solution to this problem is to enable CONFIG_HOTPLUG_CPU if
SMP is enabled on PPC_PSERIES platforms. So make that change in the Kconfig.

Reported-by: Adam Lackorzynski <adam@os.inf.tu-dresden.de>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/powerpc/platforms/pseries/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/platforms/pseries/Kconfig b/arch/powerpc/platforms/pseries/Kconfig
index 837cf49..c7a8425 100644
--- a/arch/powerpc/platforms/pseries/Kconfig
+++ b/arch/powerpc/platforms/pseries/Kconfig
@@ -17,6 +17,8 @@ config PPC_PSERIES
 	select PPC_NATIVE
 	select PPC_PCI_CHOICE if EXPERT
 	select ZLIB_DEFLATE
+	select HOTPLUG if SMP
+	select HOTPLUG_CPU if SMP
 	default y
 
 config PPC_SPLPAR
-- 
1.8.1.2

