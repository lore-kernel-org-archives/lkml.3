Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965AbbA2GzX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 01:55:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46464 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbbA2GzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 01:55:17 -0500
Date: Wed, 28 Jan 2015 22:54:36 -0800
From: tip-bot for Boris Ostrovsky <tipbot@zytor.com>
Message-ID: <tip-da63865a01c6384d459464e5165d95d4f04878d8@git.kernel.org>
Cc: boris.ostrovsky@oracle.com, mingo@kernel.org, hpa@zytor.com, bp@suse.de,
        tglx@linutronix.de, james@dingwall.me.uk, linux-kernel@vger.kernel.org
Reply-To: mingo@kernel.org, bp@suse.de, hpa@zytor.com,
        boris.ostrovsky@oracle.com, james@dingwall.me.uk,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <1422411669-25147-1-git-send-email-boris.ostrovsky@oracle.com>
References: <1422411669-25147-1-git-send-email-boris.ostrovsky@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, microcode:
  Return error from driver init code when loader is disabled
Git-Commit-ID: da63865a01c6384d459464e5165d95d4f04878d8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  da63865a01c6384d459464e5165d95d4f04878d8
Gitweb:     http://git.kernel.org/tip/da63865a01c6384d459464e5165d95d4f04878d8
Author:     Boris Ostrovsky <boris.ostrovsky@oracle.com>
AuthorDate: Tue, 27 Jan 2015 21:21:09 -0500
Committer:  Borislav Petkov <bp@suse.de>
CommitDate: Wed, 28 Jan 2015 09:23:40 +0100

x86, microcode: Return error from driver init code when loader is disabled

Commits 65cef1311d5d ("x86, microcode: Add a disable chicken bit") and
a18a0f6850d4 ("x86, microcode: Don't initialize microcode code on
paravirt") allow microcode driver skip initialization when microcode
loading is not permitted.

However, they don't prevent the driver from being loaded since the
init code returns 0. If at some point later the driver gets unloaded
this will result in an oops while trying to deregister the (never
registered) device.

To avoid this, make init code return an error on paravirt or when
microcode loading is disabled. The driver will then never be loaded.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: http://lkml.kernel.org/r/1422411669-25147-1-git-send-email-boris.ostrovsky@oracle.com
Reported-by: James Digwall <james@dingwall.me.uk>
Cc: stable@vger.kernel.org # 3.18
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/cpu/microcode/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index 15c2909..36a8361 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -552,7 +552,7 @@ static int __init microcode_init(void)
 	int error;
 
 	if (paravirt_enabled() || dis_ucode_ldr)
-		return 0;
+		return -EINVAL;
 
 	if (c->x86_vendor == X86_VENDOR_INTEL)
 		microcode_ops = init_intel_microcode();
