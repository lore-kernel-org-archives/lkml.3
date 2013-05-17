Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076Ab3EQEeU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 00:34:20 -0400
Received: from intranet.asianux.com ([58.214.24.6]:47034 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab3EQEeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 00:34:19 -0400
X-Spam-Score: -100.8
Message-ID: <5195B317.9030905@asianux.com>
Date: Fri, 17 May 2013 12:33:27 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] kernel/module.c: need return the first error code to upper
 caller when error occurs
References: <51889EE4.4070504@asianux.com> <87ip2unwkt.fsf@rustcorp.com.au> <5189C1D6.1040209@asianux.com> <87li7j3cgw.fsf@rustcorp.com.au> <51905EEF.2050901@asianux.com> <5190DB74.6050100@asianux.com> <51919E64.8020409@asianux.com>
In-Reply-To: <51919E64.8020409@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When multiple errors occur, simplify_symbols() will return the last
error code to the upper caller.

In this case, better to return the first error code to the upper caller.

Just like "using compiler": it will print all errors and warnings as
much as it can, but the user usually mainly focus on the first error or
warning. Since 'user' only can get one error return code, 'he/she'
usually assume the error code will match the first error print line.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/module.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index e4ee1bf..9e6c96d 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1976,7 +1976,8 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
 			pr_debug("Common symbol: %s\n", name);
 			printk("%s: please compile with -fno-common\n",
 			       mod->name);
-			ret = -ENOEXEC;
+			if (!ret)
+				ret = -ENOEXEC;
 			break;
 
 		case SHN_ABS:
@@ -1999,7 +2000,8 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
 
 			printk(KERN_WARNING "%s: Unknown symbol %s (err %li)\n",
 			       mod->name, name, PTR_ERR(ksym));
-			ret = PTR_ERR(ksym) ?: -ENOENT;
+			if (!ret)
+				ret = PTR_ERR(ksym) ?: -ENOENT;
 			break;
 
 		default:
-- 
1.7.7.6
