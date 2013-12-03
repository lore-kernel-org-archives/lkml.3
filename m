Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab3LCOxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:53:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754849Ab3LCOxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:53:02 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH1/5] KEYS: Pre-clear struct key on allocation
From: David Howells <dhowells@redhat.com>
To: torvalds@linux-foundation.org, jmorris@namei.org
Cc: Stephen Gallagher <sgallagh@redhat.com>, keyrings@linux-nfs.org,
        Patrik Kis <pkis@redhat.com>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 03 Dec 2013 14:52:58 +0000
Message-ID: <20131203145258.30689.87874.stgit@warthog.procyon.org.uk>
In-Reply-To: <20131203145250.30689.28039.stgit@warthog.procyon.org.uk>
References: <20131203145250.30689.28039.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The second word of key->payload does not get initialised in key_alloc(), but
the big_key type is relying on it having been cleared.  The problem comes when
big_key fails to instantiate a large key and doesn't then set the payload.  The
big_key_destroy() op is called from the garbage collector and this assumes that
the dentry pointer stored in the second word will be NULL if instantiation did
not complete.

Therefore just pre-clear the entire struct key on allocation rather than trying
to be clever and only initialising to 0 only those bits that aren't otherwise
initialised.

The lack of initialisation can lead to a bug report like the following if
big_key failed to initialise its file:

	general protection fault: 0000 [#1] SMP
	Modules linked in: ...
	CPU: 0 PID: 51 Comm: kworker/0:1 Not tainted 3.10.0-53.el7.x86_64 #1
	Hardware name: Dell Inc. PowerEdge 1955/0HC513, BIOS 1.4.4 12/09/2008
	Workqueue: events key_garbage_collector
	task: ffff8801294f5680 ti: ffff8801296e2000 task.ti: ffff8801296e2000
	RIP: 0010:[<ffffffff811b4a51>] dput+0x21/0x2d0
	...
	Call Trace:
	 [<ffffffff811a7b06>] path_put+0x16/0x30
	 [<ffffffff81235604>] big_key_destroy+0x44/0x60
	 [<ffffffff8122dc4b>] key_gc_unused_keys.constprop.2+0x5b/0xe0
	 [<ffffffff8122df2f>] key_garbage_collector+0x1df/0x3c0
	 [<ffffffff8107759b>] process_one_work+0x17b/0x460
	 [<ffffffff8107834b>] worker_thread+0x11b/0x400
	 [<ffffffff81078230>] ? rescuer_thread+0x3e0/0x3e0
	 [<ffffffff8107eb00>] kthread+0xc0/0xd0
	 [<ffffffff8107ea40>] ? kthread_create_on_node+0x110/0x110
	 [<ffffffff815c4bec>] ret_from_fork+0x7c/0xb0
	 [<ffffffff8107ea40>] ? kthread_create_on_node+0x110/0x110

Reported-by: Patrik Kis <pkis@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Stephen Gallagher <sgallagh@redhat.com>
---

 security/keys/key.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/security/keys/key.c b/security/keys/key.c
index 55d110f0aced..6e21c11e48bc 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -272,7 +272,7 @@ struct key *key_alloc(struct key_type *type, const char *desc,
 	}
 
 	/* allocate and initialise the key and its description */
-	key = kmem_cache_alloc(key_jar, GFP_KERNEL);
+	key = kmem_cache_zalloc(key_jar, GFP_KERNEL);
 	if (!key)
 		goto no_memory_2;
 
@@ -293,18 +293,12 @@ struct key *key_alloc(struct key_type *type, const char *desc,
 	key->uid = uid;
 	key->gid = gid;
 	key->perm = perm;
-	key->flags = 0;
-	key->expiry = 0;
-	key->payload.data = NULL;
-	key->security = NULL;
 
 	if (!(flags & KEY_ALLOC_NOT_IN_QUOTA))
 		key->flags |= 1 << KEY_FLAG_IN_QUOTA;
 	if (flags & KEY_ALLOC_TRUSTED)
 		key->flags |= 1 << KEY_FLAG_TRUSTED;
 
-	memset(&key->type_data, 0, sizeof(key->type_data));
-
 #ifdef KEY_DEBUGGING
 	key->magic = KEY_DEBUG_MAGIC;
 #endif

