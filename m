Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341AbaAYO2u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 09:28:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52458 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbaAYOYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 09:24:23 -0500
Date: Sat, 25 Jan 2014 06:23:40 -0800
From: tip-bot for Dan Carpenter <tipbot@zytor.com>
Message-ID: <tip-2993ae3305ad10b41e0d0bc2662f7754ee8e30fa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        bp@alien8.de, tglx@linutronix.de, bp@suse.de, dan.carpenter@oracle.com,
        daniel@numascale-asia.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        bp@alien8.de, tglx@linutronix.de, bp@suse.de, dan.carpenter@oracle.com,
        daniel@numascale-asia.com
In-Reply-To: <20140121072209.GA22095@elgon.mountain>
References: <20140121072209.GA22095@elgon.mountain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/AMD/NB: Fix amd_set_subcaches()
  parameter type
Git-Commit-ID: 2993ae3305ad10b41e0d0bc2662f7754ee8e30fa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 25 Jan 2014 06:23:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2993ae3305ad10b41e0d0bc2662f7754ee8e30fa
Gitweb:     http://git.kernel.org/tip/2993ae3305ad10b41e0d0bc2662f7754ee8e30fa
Author:     Dan Carpenter <dan.carpenter@oracle.com>
AuthorDate: Tue, 21 Jan 2014 10:22:09 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 25 Jan 2014 08:50:09 +0100

x86/AMD/NB: Fix amd_set_subcaches() parameter type

This is under CAP_SYS_ADMIN, but Smatch complains that mask comes
from the user and the test for "mask > 0xf" can underflow.

The fix is simple: amd_set_subcaches() should hand down not an 'int'
but an 'unsigned long' like it was originally indended to do.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Borislav Petkov <bp@suse.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Daniel J Blueman <daniel@numascale-asia.com>
Link: http://lkml.kernel.org/r/20140121072209.GA22095@elgon.mountain
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/amd_nb.h | 2 +-
 arch/x86/kernel/amd_nb.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
index a54ee1d..aaac3b2 100644
--- a/arch/x86/include/asm/amd_nb.h
+++ b/arch/x86/include/asm/amd_nb.h
@@ -19,7 +19,7 @@ extern int amd_cache_northbridges(void);
 extern void amd_flush_garts(void);
 extern int amd_numa_init(void);
 extern int amd_get_subcaches(int);
-extern int amd_set_subcaches(int, int);
+extern int amd_set_subcaches(int, unsigned long);
 
 struct amd_l3_cache {
 	unsigned indices;
diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index 59554dc..dec8de4 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -179,7 +179,7 @@ int amd_get_subcaches(int cpu)
 	return (mask >> (4 * cuid)) & 0xf;
 }
 
-int amd_set_subcaches(int cpu, int mask)
+int amd_set_subcaches(int cpu, unsigned long mask)
 {
 	static unsigned int reset, ban;
 	struct amd_northbridge *nb = node_to_amd_nb(amd_get_nb_id(cpu));
