Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760657AbbA1BfB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:35:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41108 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760096AbbA1B2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:28:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH 3.18 49/61] KEYS: close race between key lookup and freeing
Date: Tue, 27 Jan 2015 17:27:01 -0800
Message-Id: <20150128012642.249594645@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012636.936333725@linuxfoundation.org>
References: <20150128012636.936333725@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/keys/gc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/security/keys/gc.c
+++ b/security/keys/gc.c
@@ -148,12 +148,12 @@ static noinline void key_gc_unused_keys(
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


