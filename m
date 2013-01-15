Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673Ab3AOWpT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:45:19 -0500
Received: from mail.kernel.org ([198.145.19.201]:44910 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932512Ab3AOWpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:45:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Huacai Chen <chenhc@lemote.com>, Hongliang Tao <taohl@lemote.com>,
        Hua Yan <yanh@lemote.com>, Yong Zhang <yong.zhang@windriver.com>,
        Fuxin Zhang <zhangfx@lemote.com>, Zhangjin Wu <wuzhangjin@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [ 009/171] MIPS: Fix poweroff failure when HOTPLUG_CPU configured.
Date: Tue, 15 Jan 2013 14:42:54 -0800
Message-Id: <20130115224314.085680764@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhc@lemote.com>

commit 8add1ecb81f541ef2fcb0b85a5470ad9ecfb4a84 upstream.

When poweroff machine, kernel_power_off() call disable_nonboot_cpus().
And if we have HOTPLUG_CPU configured, disable_nonboot_cpus() is not an
empty function but attempt to actually disable the nonboot cpus. Since
system state is SYSTEM_POWER_OFF, play_dead() won't be called and thus
disable_nonboot_cpus() hangs. Therefore, we make this patch to avoid
poweroff failure.

Signed-off-by: Huacai Chen <chenhc@lemote.com>
Signed-off-by: Hongliang Tao <taohl@lemote.com>
Signed-off-by: Hua Yan <yanh@lemote.com>
Cc: Yong Zhang <yong.zhang@windriver.com>
Cc: Fuxin Zhang <zhangfx@lemote.com>
Cc: Zhangjin Wu <wuzhangjin@gmail.com>
Patchwork: https://patchwork.linux-mips.org/patch/4211/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/kernel/process.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/arch/mips/kernel/process.c
+++ b/arch/mips/kernel/process.c
@@ -72,9 +72,7 @@ void __noreturn cpu_idle(void)
 			}
 		}
 #ifdef CONFIG_HOTPLUG_CPU
-		if (!cpu_online(cpu) && !cpu_isset(cpu, cpu_callin_map) &&
-		    (system_state == SYSTEM_RUNNING ||
-		     system_state == SYSTEM_BOOTING))
+		if (!cpu_online(cpu) && !cpu_isset(cpu, cpu_callin_map))
 			play_dead();
 #endif
 		rcu_idle_exit();


