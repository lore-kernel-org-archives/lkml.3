Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084Ab3EGG2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 02:28:38 -0400
Received: from intranet.asianux.com ([58.214.24.6]:36066 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170Ab3EGG2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 02:28:37 -0400
X-Spam-Score: -100.8
Message-ID: <51889EE4.4070504@asianux.com>
Date: Tue, 07 May 2013 14:27:48 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel/module.c: for looping, need use 'goto' instead of
 'break' to jump out in time
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In the 'for' looping, when error occurs, the 'break' only jump out of
'switch', and still in 'for' looping.  If error occurs multiple times,
the original error value will be overwrite.

Currently, that will not cause issue, but still better to improve it,
so that let it return the first real error code in time.

The related commit: "1da177e Linux-2.6.12-rc"


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/module.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index b049939..7e012ff 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1977,7 +1977,7 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
 			printk("%s: please compile with -fno-common\n",
 			       mod->name);
 			ret = -ENOEXEC;
-			break;
+			goto tail;
 
 		case SHN_ABS:
 			/* Don't need to do anything */
@@ -2000,7 +2000,7 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
 			printk(KERN_WARNING "%s: Unknown symbol %s (err %li)\n",
 			       mod->name, name, PTR_ERR(ksym));
 			ret = PTR_ERR(ksym) ?: -ENOENT;
-			break;
+			goto tail;
 
 		default:
 			/* Divert to percpu allocation if a percpu var. */
@@ -2013,6 +2013,7 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
 		}
 	}
 
+tail:
 	return ret;
 }
 
-- 
1.7.7.6
