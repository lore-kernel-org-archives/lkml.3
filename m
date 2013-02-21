Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab3BUMBX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 07:01:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753449Ab3BUMBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 07:01:22 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH] KEYS: Revert one application of "Fix unreachable code"
 patch [ver #2]
To: torvalds@linux-foundation.org
From: David Howells <dhowells@redhat.com>
Cc: akpm@linux-foundation.org, jkosina@suse.cz, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Thu, 21 Feb 2013 12:00:25 +0000
Message-ID: <20130221120025.5605.43099.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A patch to fix some unreachable code in search_my_process_keyrings() got
applied twice by two different routes upstream:

	commit e67eab39bee26f509d38d00ca1a8f24b63f46a31
	Author: Alan Cox <alan@linux.intel.com>
	Date:   Thu Dec 20 15:05:54 2012 -0800
	keys: fix unreachable code

and:

	commit b010520ab3d2c05eb444ed5e01fe6c33842f597a
	Author: Alan Cox <alan@linux.intel.com>
	Date:   Thu Oct 25 15:23:35 2012 +0100
	keys: Fix unreachable code

Unfortunately, the second application removed something it shouldn't have and
this wasn't detected by GIT.  This is due to the patch not having sufficient
lines of context to distinguish the two places of application.

The effect of this is relatively minor: inside the kernel, the keyring search
routines may search multiple keyrings and then prioritise the errors if no keys
or negative keys are found in any of them.  With the extra deletion, the
presence of a negative key in the thread keyring (causing ENOKEY) is
incorrectly overridden by an error searching the process keyring.

So revert the second application of the patch.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jiri Kosina <jkosina@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>
cc: stable@vger.kernel.org
---

 security/keys/process_keys.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index 20e4bf5..58dfe08 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -367,6 +367,8 @@ key_ref_t search_my_process_keyrings(struct key_type *type,
 
 		switch (PTR_ERR(key_ref)) {
 		case -EAGAIN: /* no key */
+			if (ret)
+				break;
 		case -ENOKEY: /* negative key */
 			ret = key_ref;
 			break;

