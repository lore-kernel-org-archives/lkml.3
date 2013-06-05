Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113Ab3FEVqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:46:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37995 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933032Ab3FEVgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:36:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Adam Lackorzynski <adam@os.inf.tu-dresden.de>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 094/127] powerpc/pseries: Always enable CONFIG_HOTPLUG_CPU on PSERIES SMP
Date: Wed,  5 Jun 2013 14:34:21 -0700
Message-Id: <20130605213228.648115217@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/pseries/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/powerpc/platforms/pseries/Kconfig
+++ b/arch/powerpc/platforms/pseries/Kconfig
@@ -18,6 +18,8 @@ config PPC_PSERIES
 	select PPC_PCI_CHOICE if EXPERT
 	select ZLIB_DEFLATE
 	select PPC_DOORBELL
+	select HOTPLUG if SMP
+	select HOTPLUG_CPU if SMP
 	default y
 
 config PPC_SPLPAR


