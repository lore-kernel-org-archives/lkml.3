Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbaH0Hg1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 03:36:27 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:35479 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbaH0Hg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 03:36:26 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH/RFC 0/2] lib: string: Remove duplicated function
Date: Wed, 27 Aug 2014 09:36:00 +0200
Message-Id: <1409124962-11527-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lib/string.c contains two functions, strnicmp and strncasecmp, which
do roughly the same thing, namely compare two strings
case-insensitively up to a given bound. They have slightly different
implementations, but the only important difference is that strncasecmp
doesn't handle len==0 appropriately; it effectively becomes strcasecmp
in that case. strnicmp correctly says that two strings are always
equal in their first 0 characters.

strncasecmp is the POSIX name for this functionality. The first patch
renames the non-broken version to the standard name, and makes
strnicmp into a wrapper for strncasecmp. In order not to cause in-tree
users of strnicmp to pay the cost of the extra indirection, the second
patch replaces the declaration of strnicmp in string.h with a
macro. When and if all callers of strnicmp have been updated, that
hack can be removed.

Arch-specific versions of these functions could complicate matters,
but fortunately the only #define of either __HAVE macro is in a
!__KERNEL__ section in arch/frv/include/asm/string.h.

The other problem is how to deal with modules that may be using
strnicmp. The proper fix would probably involve some alias/linker
magic, but I have no idea how to do that (hence the RFC).


Rasmus Villemoes (2):
  lib: string: Remove duplicated function
  lib: string: Make all calls to strnicmp into calls to strncasecmp

 include/linux/string.h |  2 +-
 lib/string.c           | 28 +++++++++++-----------------
 2 files changed, 12 insertions(+), 18 deletions(-)

-- 
2.0.4

