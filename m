Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab3LCOyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:54:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482Ab3LCOxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:53:25 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH4/5] KEYS: Fix searching of nested keyrings
From: David Howells <dhowells@redhat.com>
To: torvalds@linux-foundation.org, jmorris@namei.org
Cc: Stephen Gallagher <sgallagh@redhat.com>, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 03 Dec 2013 14:53:20 +0000
Message-ID: <20131203145320.30689.27703.stgit@warthog.procyon.org.uk>
In-Reply-To: <20131203145250.30689.28039.stgit@warthog.procyon.org.uk>
References: <20131203145250.30689.28039.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a keyring contains more than 16 keyrings (the capacity of a single node in
the associative array) then those keyrings are split over multiple nodes
arranged as a tree.

If search_nested_keyrings() is called to search the keyring then it will
attempt to manually walk over just the 0 branch of the associative array tree
where all the keyring links are stored.  This works provided the key is found
before the algorithm steps from one node containing keyrings to a child node
or if there are sufficiently few keyring links that the keyrings are all in
one node.

However, if the algorithm does need to step from a node to a child node, it
doesn't change the node pointer unless a shortcut also gets transited.  This
means that the algorithm will keep scanning the same node over and over again
without terminating and without returning.

To fix this, move the internal-pointer-to-node translation from inside the
shortcut transit handler so that it applies it to node arrival as well.

This can be tested by:

	r=`keyctl newring sandbox @s`
	for ((i=0; i<=16; i++)); do keyctl newring ring$i $r; done
	for ((i=0; i<=16; i++)); do keyctl add user a$i a %:ring$i; done
	for ((i=0; i<=16; i++)); do keyctl search $r user a$i; done
	for ((i=17; i<=20; i++)); do keyctl search $r user a$i; done

The searches should all complete successfully (or with an error for 17-20),
but instead one or more of them will hang.

Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Stephen Gallagher <sgallagh@redhat.com>
---

 security/keys/keyring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index 3dd8445cd489..d46cbc5e335e 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -690,8 +690,8 @@ descend_to_node:
 		smp_read_barrier_depends();
 		ptr = ACCESS_ONCE(shortcut->next_node);
 		BUG_ON(!assoc_array_ptr_is_node(ptr));
-		node = assoc_array_ptr_to_node(ptr);
 	}
+	node = assoc_array_ptr_to_node(ptr);
 
 begin_node:
 	kdebug("begin_node");

