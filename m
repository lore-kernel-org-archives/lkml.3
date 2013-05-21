Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab3EUFtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 01:49:50 -0400
Received: from intranet.asianux.com ([58.214.24.6]:42353 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533Ab3EUFtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 01:49:49 -0400
X-Spam-Score: -100.8
Message-ID: <519B0ACA.6090008@asianux.com>
Date: Tue, 21 May 2013 13:48:58 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "paulus@samba.org" <paulus@samba.org>, zhangyanfei@cn.fujitsu.com,
        Jiri Kosina <jkosina@suse.cz>,
        Michael Ellerman <michael@ellerman.id.au>
CC: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] PowerPC: kernel: need return the related error code when
 failure occurs.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When error occurs, need return the related error code to let upper
caller know about it.

ppc_md.nvram_size() can return the error code (e.g. core99_nvram_size()
in 'arch/powerpc/platforms/powermac/nvram.c').

And when '*ppos >= size', need return -ESPIPE (Illegal seek)

The original related patch: "f9ce299 [PATCH] powerpc: fix large nvram
access"


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/powerpc/kernel/nvram_64.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/nvram_64.c b/arch/powerpc/kernel/nvram_64.c
index 48fbc2b..db2a636 100644
--- a/arch/powerpc/kernel/nvram_64.c
+++ b/arch/powerpc/kernel/nvram_64.c
@@ -88,10 +88,15 @@ static ssize_t dev_nvram_read(struct file *file, char __user *buf,
 	if (!ppc_md.nvram_size)
 		goto out;
 
-	ret = 0;
 	size = ppc_md.nvram_size();
-	if (*ppos >= size || size < 0)
+	if (size < 0) {
+		ret = size;
 		goto out;
+	}
+	if (*ppos >= size) {
+		ret = -ESPIPE;
+		goto out;
+	}
 
 	count = min_t(size_t, count, size - *ppos);
 	count = min(count, PAGE_SIZE);
-- 
1.7.7.6
