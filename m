Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab3K1IQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 03:16:41 -0500
Received: from mout.gmx.net ([212.227.17.20]:54101 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835Ab3K1IQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 03:16:37 -0500
Date: Thu, 28 Nov 2013 09:16:33 +0100
From: Helge Deller <deller@gmx.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] kernel/extable: fix address-checks for core_kernel and init
 areas
Message-ID: <20131128081633.GA2111@ls3530.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:buApxeexuXLACsI16fEXOKQb2pNXjt8yd5s1+QrrqBNF/+ay6uI
 NrxNfZLjGkGf9oiOz1sQX/vrMaI3plf5npZ9vrmjmYqj0nwxAT4hCso1p2SzP3R2/733Nwc
 Yj6o7b9yjD4cGza+Mg7xOO5YuTC9d7DfbDk+Jrms/It18zgaaaReqKubNZWhoW9jmJyipVK
 lHIVDWlJs3GpnJW/poN1Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The init_kernel_text() and core_kernel_text() functions should not include the
labels _einittext and _etext when checking if an address is inside the .text or
.init sections.

Signed-off-by: Helge Deller <deller@gmx.de>

diff --git a/kernel/extable.c b/kernel/extable.c
index 832cb28..763faf0 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -61,7 +61,7 @@ const struct exception_table_entry *search_exception_tables(unsigned long addr)
 static inline int init_kernel_text(unsigned long addr)
 {
 	if (addr >= (unsigned long)_sinittext &&
-	    addr <= (unsigned long)_einittext)
+	    addr < (unsigned long)_einittext)
 		return 1;
 	return 0;
 }
@@ -69,7 +69,7 @@ static inline int init_kernel_text(unsigned long addr)
 int core_kernel_text(unsigned long addr)
 {
 	if (addr >= (unsigned long)_stext &&
-	    addr <= (unsigned long)_etext)
+	    addr < (unsigned long)_etext)
 		return 1;
 
 	if (system_state == SYSTEM_BOOTING &&
