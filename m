Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab3AKJyy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 04:54:54 -0500
Received: from csamuel.org ([74.50.50.137]:34129 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591Ab3AKJyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 04:54:52 -0500
Message-ID: <50EFDF15.4080606@csamuel.org>
Date: Fri, 11 Jan 2013 20:44:53 +1100
From: Chris Samuel <chris@csamuel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Rusty Russell <rusty@rustcorp.com.au>, dhowells@redhat.com
Subject: [PATCH] MODSIGN: Warn when sign check fails due to -ENOKEY
Content-Type: multipart/mixed;
 boundary="------------010902080901090701080407"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010902080901090701080407
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

/* Please CC me in responses, I am not subscribed to LKML */

Currently if a signature check fails on module load due to not having
the appropriate key (-ENOKEY) and we are not doing strict checking
there is no information provided to the user other than the lock debug
taint warning:

Disabling lock debugging due to kernel taint

This patch causes a single warning to be emitted to explain why the
kernel is being tainted, before the above taint warning occurs.

Module verification failed, required key not present, tainting kernel

Found whilst trying to work out why all the 3.8 development kernels
I was building and testing were warning about taints and why all modules
were listed as forced load (F) in /proc/modules when that wasn't the
case in the 3.5, 3.6 or 3.7 kernels I'd tried.

Signed-off-by: Christopher Samuel <chris@csamuel.org>
---
  kernel/module.c |    4 +++-
  1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/module.c b/kernel/module.c
index 250092c..27de534 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2443,8 +2443,10 @@ static int module_sig_check(struct load_info *info)
  	if (err < 0 && fips_enabled)
  		panic("Module verification failed with error %d in FIPS mode\n",
  		      err);
-	if (err == -ENOKEY && !sig_enforce)
+	if (err == -ENOKEY && !sig_enforce) {
+		printk_once(KERN_DEBUG "Module verification failed, required key not 
present, tainting kernel\n");
  		err = 0;
+	}
   	return err;
  }
-- 
1.7.10.4


--------------010902080901090701080407
Content-Type: text/plain; charset=UTF-8;
 name="Attached Message Part"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="Attached Message Part"


--------------010902080901090701080407--
