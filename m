Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbaHZPlo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 11:41:44 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:64548 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbaHZPll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 11:41:41 -0400
Date: Tue, 26 Aug 2014 18:41:29 +0300
From: Andreea-Cristina Bernat <bernat.ada@gmail.com>
To: dhowells@redhat.com, shemming@brocade.com, linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH RFC] rcu: assoc_array: Add critical section to avoid a bug
Message-ID: <20140826154129.GA4481@ada>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* The function "assoc_array_apply_edit()" passes "edit->rcu" to "call_rcu()".
* "assoc_array_apply_edit()'s" callers do not call it under an RCU
read-side critical section.
* The function "assoc_array_gc()" could be preempted between the call to
"assoc_array_apply_edit()" call and the assignment
"edit->array->nr_leaves_on_tree = nr_leaves_on_tree;", so the grace
period could complete.
* The problem is that the assignment could access the freelist.
* Solution:
 Put the call to the "assoc_array_apply_edit()" function and the
 assignment between "rcu_read_lock()" and "rcu_read_unlock()". In this
 way, the callback function provided by the "call_rcu()" call will be
 invoked after all pre-existing critical sections end which means after
 the added critical section.

The first step to detect this was made with the following Coccinelle
semantic patch which looks for calls of functions which have in their bodies a
call to "call_rcu()" with a global first parameter:

@ locally @
identifier l;
type t;
position p;
@@

t l;
... when any
call_rcu@p((<+...l...+>), ...);

@ globally @
identifier fn;
identifier g != locally.l;
position p2 != locally.p;
@@

fn(...) {
... when any
call_rcu@p2((<+...g...+>), ...);
... when any
}

@ other_func @
identifier globally.fn, ff;
@@

ff(...) {
... when any
* fn(...)
... when any
}

The second step was looking at the uses of the functions found and see if the
parameter of interest is used after the call of the function.

Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
---
 lib/assoc_array.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/assoc_array.c b/lib/assoc_array.c
index c0b1007..45d11c0 100644
--- a/lib/assoc_array.c
+++ b/lib/assoc_array.c
@@ -1734,8 +1734,10 @@ ascend_old_tree:
 
 gc_complete:
 	edit->set[0].to = new_root;
+	rcu_read_lock();
 	assoc_array_apply_edit(edit);
 	edit->array->nr_leaves_on_tree = nr_leaves_on_tree;
+	rcu_read_unlock();
 	return 0;
 
 enomem:
-- 
1.9.1

