Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbaIINHZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 09:07:25 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:53760 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475AbaIINHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 09:07:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] binfmt_misc: work around gcc-4.9 warning
Date: Tue, 09 Sep 2014 15:06:47 +0200
Message-ID: <36592637.GQ9Dnm0IKp@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:kNps+cr+pHSgyyY3NOPgg//EOMo/BkryMz/0KXO0y86
 qzdNmav6LLEcM/vnjv6q7rRXaaQRz9Hat6JfoehDDtXnmPq2xR
 qQp0jTZHcEGUXloYY8M7FrLfYrwD2I113bbGKUoVLpxFCKBVq+
 9TdfyFf1wnYHDs9ko48T6TyPjaWEs7A87PalvMMnCO/qF09UYl
 T38finQXJCoMjCPRHoRdhUQVx1pyxVOenAVKCt+U+zsWw5J+9g
 82ICjsHKakuqPP7tld5Z437T+WlecXwyXF2bQfS2f43+DR54sD
 MmpI1NPpobjchmCx3+OAXvkTquA/HR0jeYxvrIjrQZn3m8GWSb
 XGQHKWrR1er0gzJRXRX0=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc-4.9 on ARM gives us a mysterious warning about the binfmt_misc
parse_command function:

fs/binfmt_misc.c: In function 'parse_command.part.3':
fs/binfmt_misc.c:405:7: warning: array subscript is above array bounds [-Warray-bounds]

I've managed to trace this back to the ARM implementation of memset,
which is called from copy_from_user in case of a fault and which does

 #define memset(p,v,n)                                                  \
        ({                                                              \
                void *__p = (p); size_t __n = n;                        \
                if ((__n) != 0) {                                       \
                        if (__builtin_constant_p((v)) && (v) == 0)      \
                                __memzero((__p),(__n));                 \
                        else                                            \
                                memset((__p),(v),(__n));                \
                }                                                       \
                (__p);                                                  \
        })

Apparently gcc gets confused by the check for "size != 0" and believes
that the size might be zero when it gets to the line that does
"if (s[count-1] == '\n')", so it would access data outside of the
array.

gcc is clearly wrong here, since this condition was already checked
earlier in the function and the 'size' value can not change in the
meantime.

Fortunately, we can work around it and get rid of the warning by
rearranging the function to check for zero size after doing the
copy_from_user. It is still safe to pass a zero size into
copy_from_user, so it does not cause any side effects.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index b60500300dd7..1fc2b028d504 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -396,12 +396,12 @@ static int parse_command(const char __user *buffer, size_t count)
 {
 	char s[4];
 
-	if (!count)
-		return 0;
 	if (count > 3)
 		return -EINVAL;
 	if (copy_from_user(s, buffer, count))
 		return -EFAULT;
+	if (!count)
+		return 0;
 	if (s[count-1] == '\n')
 		count--;
 	if (count == 1 && s[0] == '0')

