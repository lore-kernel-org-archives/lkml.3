Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751046Ab3FVF1J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 01:27:09 -0400
Received: from intranet.asianux.com ([58.214.24.6]:5755 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab3FVF1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 01:27:05 -0400
X-Spam-Score: -100.8
Message-ID: <51C53571.9070403@asianux.com>
Date: Sat, 22 Jun 2013 13:26:09 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>, zhaohongjiang@huawei.com
CC: David Miller <davem@davemloft.net>, Greg KH <gregkh@linuxfoundation.org>,
        sparclinux@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: [PATCH] arch: sparc: kernel: check the memory length before use strcpy().
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For the related next strcpy(), the destination length is less than 512,
but the source maximize length may be 'OPROMMAXPARAM' (4096) which is
more than 512.

One work flow may:
  openprom_sunos_ioctl() ->  if (cmd == OPROMSETOPT)
    getstrings() ->  will alloc buffer with size 'OPROMMAXPARAM'.
    opromsetopt() ->  devide the buffer into 'var' and 'value'
      of_set_property() -> pass
        prom_setprop() -> pass
          ldom_set_var()

And do not mind the additional 4 alignment buffer increasing, since
'sizeof(pkt) - sizeof(pkt.header)' is 4 alignment at least.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/sparc/kernel/ds.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/sparc/kernel/ds.c b/arch/sparc/kernel/ds.c
index 5ef48da..11d460f 100644
--- a/arch/sparc/kernel/ds.c
+++ b/arch/sparc/kernel/ds.c
@@ -783,6 +783,16 @@ void ldom_set_var(const char *var, const char *value)
 		char  *base, *p;
 		int msg_len, loops;
 
+		if (strlen(var) + strlen(value) + 2 >
+		    sizeof(pkt) - sizeof(pkt.header)) {
+			printk(KERN_ERR PFX
+				"contents length: %zu, which more than max: %lu,"
+				"so could not set (%s) variable to (%s).\n",
+				strlen(var) + strlen(value) + 2,
+				sizeof(pkt) - sizeof(pkt.header), var, value);
+			return;
+		}
+
 		memset(&pkt, 0, sizeof(pkt));
 		pkt.header.data.tag.type = DS_DATA;
 		pkt.header.data.handle = cp->handle;
-- 
1.7.11.7
