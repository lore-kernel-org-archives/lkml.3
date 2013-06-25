Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab3FYTK5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 15:10:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40875 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab3FYSdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:33:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Helge Deller <deller@gmx.de>
Subject: [ 22/95] parisc: fix kernel BUG at arch/parisc/include/asm/mmzone.h:50
Date: Tue, 25 Jun 2013 11:32:09 -0700
Message-Id: <20130625182156.160754876@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit ae249b5fa27f9fba25aa59664d4338efc2dd2394 upstream.

With CONFIG_DISCONTIGMEM=y and multiple physical memory areas,
cat /proc/kpageflags triggers this kernel bug:

kernel BUG at arch/parisc/include/asm/mmzone.h:50!
CPU: 2 PID: 7848 Comm: cat Tainted: G      D W 3.10.0-rc3-64bit #44
 IAOQ[0]: kpageflags_read0x128/0x238
 IAOQ[1]: kpageflags_read0x12c/0x238
 RP(r2): proc_reg_read0xbc/0x130
Backtrace:
 [<00000000402ca2d4>] proc_reg_read0xbc/0x130
 [<0000000040235bcc>] vfs_read0xc4/0x1d0
 [<0000000040235f0c>] SyS_read0x94/0xf0
 [<0000000040105fc0>] syscall_exit0x0/0x14

kpageflags_read() walks through the whole memory, even if some memory
areas are physically not available. So, we should better not BUG on an
unavailable pfn in pfn_to_nid() but just return the expected value -1 or
0.

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/include/asm/mmzone.h |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/arch/parisc/include/asm/mmzone.h
+++ b/arch/parisc/include/asm/mmzone.h
@@ -39,17 +39,14 @@ extern unsigned char pfnnid_map[PFNNID_M
 static inline int pfn_to_nid(unsigned long pfn)
 {
 	unsigned int i;
-	unsigned char r;
 
 	if (unlikely(pfn_is_io(pfn)))
 		return 0;
 
 	i = pfn >> PFNNID_SHIFT;
 	BUG_ON(i >= ARRAY_SIZE(pfnnid_map));
-	r = pfnnid_map[i];
-	BUG_ON(r == 0xff);
 
-	return (int)r;
+	return (int)pfnnid_map[i];
 }
 
 static inline int pfn_valid(int pfn)


