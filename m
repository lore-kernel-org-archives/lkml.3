Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249AbaFJXOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 19:14:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38713 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087AbaFJXNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 19:13:50 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH RFC 10/10] tools: Use reasonable defaults for the default access
Date: Tue, 10 Jun 2014 16:13:14 -0700
Message-Id: <1402441994-16780-11-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1402441994-16780-1-git-send-email-hpa@zytor.com>
References: <1402441994-16780-1-git-send-email-hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By default, as long as we are using gcc, use struct access for the
native byte order and byte swap it for the reverse byte order.  This
works well on most gcc targets.  If we are not compiling with gcc,
then we cannot assume that struct access is safe, and so fall back to
the most generic portable form ([bl]e_byteshift.h).

However, there are some architectures on which this generates poor
code even with gcc, and so some architectures may want to implement
specific overrides in this header file.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 tools/include/tools/unaligned.h | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/tools/include/tools/unaligned.h b/tools/include/tools/unaligned.h
index a3d43989bd25..1ef19a1ca9b4 100644
--- a/tools/include/tools/unaligned.h
+++ b/tools/include/tools/unaligned.h
@@ -30,7 +30,21 @@ struct _packed_u64_struct {
 
 #endif /* __GNUC__ */
 
-#include <tools/unaligned/le_byteshift.h>
-#include <tools/unaligned/be_byteshift.h>
+#if defined(__GNUC__) && (__BYTE_ORDER == __LITTLE_ENDIAN)
+
+# include <tools/unaligned/le_struct.h>
+# include <tools/unaligned/be_swap.h>
+
+#elif defined(__GNUC__) && (__BYTE_ORDER == __BIG_ENDIAN)
+
+# include <tools/unaligned/be_struct.h>
+# include <tools/unaligned/le_swap.h>
+
+#else /* No idea what we actually are dealing with */
+
+# include <tools/unaligned/be_byteshift.h>
+# include <tools/unaligned/le_byteshift.h>
+
+#endif
 
 #endif /* TOOLS_UNALIGNED_H */
-- 
1.9.3

