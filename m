Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbaAUHXB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 02:23:01 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:22531 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaAUHWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 02:22:52 -0500
Date: Tue, 21 Jan 2014 10:22:09 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Borislav Petkov <bp@alien8.de>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] x86, AMD, NB: silence an underflow test
Message-ID: <20140121072209.GA22095@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is under CAP_SYS_ADMIN but Smatch complains that mask comes from
the user and the test for "mask > 0xf" can underflow.  The fix is
simple.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
index a54ee1d054d9..0c4e3e47d462 100644
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
index 59554dca96ec..d9fceb697322 100644
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
