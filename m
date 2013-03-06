Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab3CFUry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 15:47:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21145 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554Ab3CFUrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 15:47:52 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 2/4] UAPI: Fix endianness conditionals in linux/acct.h
To: torvalds@linux-foundation.org
From: David Howells <dhowells@redhat.com>
Cc: linux-arch@vger.kernel.org, sfr@canb.auug.org.au,
        Joakim.Tjernlund@transmode.se, arnd@arndb.de,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Date: Wed, 06 Mar 2013 20:47:43 +0000
Message-ID: <20130306204742.31327.46737.stgit@warthog.procyon.org.uk>
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

The definition of ACCT_BYTEORDER in linux/acct.h is wrong in this way.  Note
that userspace will likely interpret this incorrectly as the big-endian variant
on little-endian machines - depending on header inclusion order.

[!!!] NOTE [!!!]  This patch may adversely change the userspace API.  It might
be better to fix the value of ACCT_BYTEORDER.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/uapi/linux/acct.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/acct.h b/include/uapi/linux/acct.h
index 11b6ca3..df2f9a0 100644
--- a/include/uapi/linux/acct.h
+++ b/include/uapi/linux/acct.h
@@ -107,10 +107,12 @@ struct acct_v3
 #define ACORE		0x08	/* ... dumped core */
 #define AXSIG		0x10	/* ... was killed by a signal */
 
-#ifdef __BIG_ENDIAN
+#if defined(__BYTE_ORDER) ? __BYTE_ORDER == __BIG_ENDIAN : defined(__BIG_ENDIAN)
 #define ACCT_BYTEORDER	0x80	/* accounting file is big endian */
-#else
+#elif defined(__BYTE_ORDER) ? __BYTE_ORDER == __LITTLE_ENDIAN : defined(__LITTLE_ENDIAN)
 #define ACCT_BYTEORDER	0x00	/* accounting file is little endian */
+#else
+#error unspecified endianness
 #endif
 
 #ifndef __KERNEL__

