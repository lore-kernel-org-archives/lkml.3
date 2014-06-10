Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbaFJXOI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 19:14:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38711 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbaFJXNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 19:13:49 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH RFC 01/10] tools: Remove double-underscore symbols from user space byteshift functions
Date: Tue, 10 Jun 2014 16:13:05 -0700
Message-Id: <1402441994-16780-2-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1402441994-16780-1-git-send-email-hpa@zytor.com>
References: <1402441994-16780-1-git-send-email-hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should not use double-underscore (or underscore-capital) symbols in
arbitrary user space code, and these include files are specifically
used for user space compilation.  Furthermore, the indirection is
completely unnecessary in this case.

Also, reorder the littleendian put macros to allow the compiler to
generate better code on some architectures (stores in sequence.)

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 tools/include/tools/be_byteshift.h | 62 ++++++++++++++------------------------
 tools/include/tools/le_byteshift.h | 62 ++++++++++++++------------------------
 2 files changed, 44 insertions(+), 80 deletions(-)

diff --git a/tools/include/tools/be_byteshift.h b/tools/include/tools/be_byteshift.h
index 84c17d836578..9850c7df2667 100644
--- a/tools/include/tools/be_byteshift.h
+++ b/tools/include/tools/be_byteshift.h
@@ -3,68 +3,50 @@
 
 #include <stdint.h>
 
-static inline uint16_t __get_unaligned_be16(const uint8_t *p)
+static inline uint16_t get_unaligned_be16(const void *_p)
 {
-	return p[0] << 8 | p[1];
-}
+	const uint8_t *p = _p;
 
-static inline uint32_t __get_unaligned_be32(const uint8_t *p)
-{
-	return p[0] << 24 | p[1] << 16 | p[2] << 8 | p[3];
+	return p[0] << 8 | p[1];
 }
 
-static inline uint64_t __get_unaligned_be64(const uint8_t *p)
+static inline uint32_t get_unaligned_be32(const void *_p)
 {
-	return (uint64_t)__get_unaligned_be32(p) << 32 |
-	       __get_unaligned_be32(p + 4);
-}
+	const uint8_t *p = _p;
 
-static inline void __put_unaligned_be16(uint16_t val, uint8_t *p)
-{
-	*p++ = val >> 8;
-	*p++ = val;
+	return p[0] << 24 | p[1] << 16 | p[2] << 8 | p[3];
 }
 
-static inline void __put_unaligned_be32(uint32_t val, uint8_t *p)
+static inline uint64_t get_unaligned_be64(const void *_p)
 {
-	__put_unaligned_be16(val >> 16, p);
-	__put_unaligned_be16(val, p + 2);
-}
+	const uint8_t *p = _p;
 
-static inline void __put_unaligned_be64(uint64_t val, uint8_t *p)
-{
-	__put_unaligned_be32(val >> 32, p);
-	__put_unaligned_be32(val, p + 4);
+	return (uint64_t)get_unaligned_be32(p) << 32 |
+		get_unaligned_be32(p + 4);
 }
 
-static inline uint16_t get_unaligned_be16(const void *p)
+static inline void put_unaligned_be16(uint16_t val, void *_p)
 {
-	return __get_unaligned_be16((const uint8_t *)p);
-}
+	uint8_t *p = _p;
 
-static inline uint32_t get_unaligned_be32(const void *p)
-{
-	return __get_unaligned_be32((const uint8_t *)p);
+	*p++ = val >> 8;
+	*p++ = val;
 }
 
-static inline uint64_t get_unaligned_be64(const void *p)
+static inline void put_unaligned_be32(uint32_t val, void *_p)
 {
-	return __get_unaligned_be64((const uint8_t *)p);
-}
+	uint8_t *p = _p;
 
-static inline void put_unaligned_be16(uint16_t val, void *p)
-{
-	__put_unaligned_be16(val, p);
+	put_unaligned_be16(val >> 16, p);
+	put_unaligned_be16(val, p + 2);
 }
 
-static inline void put_unaligned_be32(uint32_t val, void *p)
+static inline void put_unaligned_be64(uint64_t val, void *_p)
 {
-	__put_unaligned_be32(val, p);
-}
+	uint8_t *p = _p;
 
-static inline void put_unaligned_be64(uint64_t val, void *p)
-{
-	__put_unaligned_be64(val, p);
+	put_unaligned_be32(val >> 32, p);
+	put_unaligned_be32(val, p + 4);
 }
 
 #endif /* _TOOLS_BE_BYTESHIFT_H */
diff --git a/tools/include/tools/le_byteshift.h b/tools/include/tools/le_byteshift.h
index 8fe9f2488ec7..819ba186ede5 100644
--- a/tools/include/tools/le_byteshift.h
+++ b/tools/include/tools/le_byteshift.h
@@ -3,68 +3,50 @@
 
 #include <stdint.h>
 
-static inline uint16_t __get_unaligned_le16(const uint8_t *p)
+static inline uint16_t get_unaligned_le16(const void *_p)
 {
-	return p[0] | p[1] << 8;
-}
+	const uint8_t *p = _p;
 
-static inline uint32_t __get_unaligned_le32(const uint8_t *p)
-{
-	return p[0] | p[1] << 8 | p[2] << 16 | p[3] << 24;
+	return p[0] | p[1] << 8;
 }
 
-static inline uint64_t __get_unaligned_le64(const uint8_t *p)
+static inline uint32_t get_unaligned_le32(const void *_p)
 {
-	return (uint64_t)__get_unaligned_le32(p + 4) << 32 |
-	       __get_unaligned_le32(p);
-}
+	const uint8_t *p = _p;
 
-static inline void __put_unaligned_le16(uint16_t val, uint8_t *p)
-{
-	*p++ = val;
-	*p++ = val >> 8;
+	return p[0] | p[1] << 8 | p[2] << 16 | p[3] << 24;
 }
 
-static inline void __put_unaligned_le32(uint32_t val, uint8_t *p)
+static inline uint64_t get_unaligned_le64(const void *_p)
 {
-	__put_unaligned_le16(val >> 16, p + 2);
-	__put_unaligned_le16(val, p);
-}
+	const uint8_t *p = _p;
 
-static inline void __put_unaligned_le64(uint64_t val, uint8_t *p)
-{
-	__put_unaligned_le32(val >> 32, p + 4);
-	__put_unaligned_le32(val, p);
+	return (uint64_t)get_unaligned_le32(p + 4) << 32 |
+		get_unaligned_le32(p);
 }
 
-static inline uint16_t get_unaligned_le16(const void *p)
+static inline void put_unaligned_le16(uint16_t val, void *_p)
 {
-	return __get_unaligned_le16((const uint8_t *)p);
-}
+	uint8_t *p = _p;
 
-static inline uint32_t get_unaligned_le32(const void *p)
-{
-	return __get_unaligned_le32((const uint8_t *)p);
+	*p++ = val;
+	*p++ = val >> 8;
 }
 
-static inline uint64_t get_unaligned_le64(const void *p)
+static inline void put_unaligned_le32(uint32_t val, void *_p)
 {
-	return __get_unaligned_le64((const uint8_t *)p);
-}
+	uint8_t *p = _p;
 
-static inline void put_unaligned_le16(uint16_t val, void *p)
-{
-	__put_unaligned_le16(val, p);
+	put_unaligned_le16(val, p);
+	put_unaligned_le16(val >> 16, p + 2);
 }
 
-static inline void put_unaligned_le32(uint32_t val, void *p)
+static inline void put_unaligned_le64(uint64_t val, void *_p)
 {
-	__put_unaligned_le32(val, p);
-}
+	uint8_t *p = _p;
 
-static inline void put_unaligned_le64(uint64_t val, void *p)
-{
-	__put_unaligned_le64(val, p);
+	put_unaligned_le32(val, p);
+	put_unaligned_le32(val >> 32, p + 4);
 }
 
 #endif /* _TOOLS_LE_BYTESHIFT_H */
-- 
1.9.3

