Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbbALSbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:31:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58541 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400AbbALSbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:31:17 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sasha Levin <sasha.levin@oracle.com>, David Howells <dhowells@redhat.com>,
        Moritz Muehlenhoff <jmm@inutil.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 216/216] KEYS: close race between key lookup and freeing
Date: Mon, 12 Jan 2015 18:29:54 +0000
Message-Id: <1421087394-2712-104-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <sasha.levin@oracle.com>

commit a3a8784454692dd72e5d5d34dcdab17b4420e74c upstream.

When a key is being garbage collected, it's key->user would get put before
the ->destroy() callback is called, where the key is removed from it's
respective tracking structures.

This leaves a key hanging in a semi-invalid state which leaves a window open
for a different task to try an access key->user. An example is
find_keyring_by_name() which would dereference key->user for a key that is
in the process of being garbage collected (where key->user was freed but
->destroy() wasn't called yet - so it's still present in the linked list).

This would cause either a panic, or corrupt memory.

Fixes CVE-2014-9529.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Moritz Muehlenhoff <jmm@inutil.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 security/keys/gc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/keys/gc.c b/security/keys/gc.c
index d3222b6d7d59..009d9370c8fd 100644
--- a/security/keys/gc.c
+++ b/security/keys/gc.c
@@ -157,12 +157,12 @@ static noinline void key_gc_unused_keys(struct list_head *keys)
 		if (test_bit(KEY_FLAG_INSTANTIATED, &key->flags))
 			atomic_dec(&key->user->nikeys);
 
-		key_user_put(key->user);
-
 		/* now throw away the key memory */
 		if (key->type->destroy)
 			key->type->destroy(key);
 
+		key_user_put(key->user);
+
 		kfree(key->description);
 
 #ifdef KEY_DEBUGGING
-- 
2.1.4

