Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab3IQXIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 19:08:35 -0400
Received: from nm26-vm7.access.bullet.mail.gq1.yahoo.com ([216.39.63.204]:40630
	"EHLO nm26-vm7.access.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754231Ab3IQXId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 19:08:33 -0400
X-Yahoo-Newman-Id: 301219.3357.bm@smtp117.sbc.mail.gq1.yahoo.com
X-Rocket-Received: from localhost.localdomain (danielfsantos@99.70.244.137 with )
        by smtp117.sbc.mail.gq1.yahoo.com with SMTP; 17 Sep 2013 23:08:32 +0000 UTC
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: QRaakOMVM1nw6iljduDLl9Jyws8TnsRQHGgFlwqJ_1BvGzz
 jekbSh4a4.sUkNDtHoleS0LPCAAeWR3KovbNcyGJFHQj4T2z58gffgiWLALs
 MxgpYVeQU4VKqtjKYUGKArITGnkeh.TXnq.BTdnzEM7ZG._qRE1iHPA_AuI1
 Xg_79DVBTdx1yZu82cdxOzAppa5xTMXzFqS06gtmfKiGPimyXsxArp4_uEo0
 X4AkGAJWYWOhRjsN066cQsvSre0PMCh4WBOcr94hE2Q2H2A.7b7GphSyt6Rm
 0yugR9jZYLTpGeTufp1e2KyTqjKsTXfpTK_mMejL3hFkG3ZxwH9NyY5mRyli
 0n9LLsyM3zLUBicuSNhu520XcybrgSHLwrZDxywUVVobEF2mC1hMujYxUAj5
 rQAH5L7bLCKsjlPBz5gpzIVr5e8jTIwo7iuJwszR6X1e3e9AwaigrEIYqB.c
 VKyZAn9osWrYGqHKvUCxQMcGsiKvL1anXfDvHi_cEO4XHFlxkKe58xbaWr6k
 05v1oCaDPV612InecuHq66D1gFtNGbtXTfINIVTk06tABVifFrDKR5ybc5zy
 jEsH1xOQvItw7I6o-
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: danielfsantos@att.net
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        George Spelvin <linux@horizon.com>
Cc: Daniel Santos <daniel.santos@pobox.com>
Subject: [PATCH 4/5] lib: Add strerror and strerror_name functions
Date: Tue, 17 Sep 2013 18:08:36 -0500
Message-Id: <1379459317-13046-5-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1379459317-13046-1-git-send-email-daniel.santos@pobox.com>
References: <1379459317-13046-1-git-send-email-daniel.santos@pobox.com>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 include/linux/string.h |  8 +++++++
 lib/string.c           | 60 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+)

diff --git a/include/linux/string.h b/include/linux/string.h
index ac889c5..76ce2ff 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -154,4 +154,12 @@ static inline const char *kbasename(const char *path)
 	return tail ? tail + 1 : path;
 }
 
+#ifdef CONFIG_STRERROR
+extern const char *strerror(int error);
+#endif
+
+#ifdef CONFIG_STRERROR_NAME
+extern const char *strerror_name(int error);
+#endif
+
 #endif /* _LINUX_STRING_H_ */
diff --git a/lib/string.c b/lib/string.c
index e5878de..7fd2704 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -27,6 +27,10 @@
 #include <linux/bug.h>
 #include <linux/errno.h>
 
+#if defined(CONFIG_STRERROR) || defined(CONFIG_STRERROR_NAME)
+# include <generated/error_strings.h>
+#endif
+
 #ifndef __HAVE_ARCH_STRNICMP
 /**
  * strnicmp - Case insensitive, length-limited string comparison
@@ -824,3 +828,59 @@ void *memchr_inv(const void *start, int c, size_t bytes)
 	return check_bytes8(start, value, bytes % 8);
 }
 EXPORT_SYMBOL(memchr_inv);
+
+#if defined(CONFIG_STRERROR) || defined(CONFIG_STRERROR_NAME)
+static const char *_strerror(int error, unsigned index)
+{
+	unsigned uerror = error < 0 ? -error : error;
+	const struct error_strings *es;
+	const struct error_strings *es_end = &error_strings[
+			sizeof(error_strings) / sizeof(*error_strings)];
+	const char *ret;
+	unsigned i;
+
+	for (es = error_strings; es != es_end; ++es) {
+		if (uerror >= es->first && uerror <= es->last)
+			break;
+	}
+
+	if (es == es_end)
+		return NULL;
+
+	for (i = es->first, ret = es->desc[index]; i < uerror; ++ret)
+		i += !*ret;
+
+	BUG_ON(i > es->last);
+	BUG_ON(i != uerror);
+
+	return *ret ? ret : NULL;
+}
+#endif /* defined(CONFIG_STRERROR) || defined(CONFIG_STRERROR_NAME) */
+
+#ifdef CONFIG_STRERROR
+/**
+ * strerror - Translates an error code into a description.
+ * @error:	The error to describe (may be positive or negative)
+ *
+ * Returns a pointer to the error description or NULL if none is found.
+ */
+const char *strerror(int error)
+{
+	return _strerror(error, 1);
+}
+EXPORT_SYMBOL(strerror);
+#endif
+
+#ifdef CONFIG_STRERROR_NAME
+/**
+ * strerror_name - Translates an error code into a name
+ * @error:	The error to describe (may be positive or negative)
+ *
+ * Returns a pointer to the error name or NULL if none is found.
+ */
+const char *strerror_name(int error)
+{
+	return _strerror(error, 0);
+}
+EXPORT_SYMBOL(strerror_name);
+#endif
-- 
1.8.1.5

