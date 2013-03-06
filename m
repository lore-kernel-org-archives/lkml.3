Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab3CFUsZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 15:48:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866Ab3CFUsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 15:48:22 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 4/4] UAPI: Fix endianness conditionals in M32R's asm/stat.h
To: torvalds@linux-foundation.org
From: David Howells <dhowells@redhat.com>
Cc: linux-arch@vger.kernel.org, sfr@canb.auug.org.au,
        linux-m32r@ml.linux-m32r.org, Joakim.Tjernlund@transmode.se,
        arnd@arndb.de, Hirokazu Takata <takata@linux-m32r.org>,
        linux-kernel@vger.kernel.org, linux-m32r-ja@ml.linux-m32r.org,
        akpm@linux-foundation.org
Date: Wed, 06 Mar 2013 20:48:00 +0000
Message-ID: <20130306204759.31327.7782.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130306204724.31327.43118.stgit@warthog.procyon.org.uk>
References: <20130306204724.31327.43118.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the UAPI header files, __BIG_ENDIAN and __LITTLE_ENDIAN must be compared
against __BYTE_ORDER in preprocessor conditionals where these are exposed to
userspace (that is they're not inside __KERNEL__ conditionals).

However, in the main kernel the norm is to check for "defined(__XXX_ENDIAN)"
rather than comparing against __BYTE_ORDER and this has incorrectly leaked
into the userspace headers.

The definition of struct stat64 in M32R's asm/stat.h is wrong in this way.
Note that userspace will likely interpret the field order incorrectly as the
big-endian variant on little-endian machines - depending on header inclusion
order.

[!!!] NOTE [!!!]  This patch may adversely change the userspace API.  It might
be better to fix the ordering of st_blocks and __pad4 in struct stat64.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Hirokazu Takata <takata@linux-m32r.org>
cc: linux-m32r@ml.linux-m32r.org
cc: linux-m32r-ja@ml.linux-m32r.org
---

 arch/m32r/include/uapi/asm/stat.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/m32r/include/uapi/asm/stat.h b/arch/m32r/include/uapi/asm/stat.h
index da4518f..98470fe 100644
--- a/arch/m32r/include/uapi/asm/stat.h
+++ b/arch/m32r/include/uapi/asm/stat.h
@@ -63,10 +63,10 @@ struct stat64 {
 	long long	st_size;
 	unsigned long	st_blksize;
 
-#if defined(__BIG_ENDIAN)
+#if defined(__BYTE_ORDER) ? __BYTE_ORDER == __BIG_ENDIAN : defined(__BIG_ENDIAN)
 	unsigned long	__pad4;		/* future possible st_blocks high bits */
 	unsigned long	st_blocks;	/* Number 512-byte blocks allocated. */
-#elif defined(__LITTLE_ENDIAN)
+#elif defined(__BYTE_ORDER) ? __BYTE_ORDER == __LITTLE_ENDIAN : defined(__LITTLE_ENDIAN)
 	unsigned long	st_blocks;	/* Number 512-byte blocks allocated. */
 	unsigned long	__pad4;		/* future possible st_blocks high bits */
 #else

