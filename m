Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261AbaH1Lcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 07:32:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbaH1Lcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 07:32:42 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20140826154129.GA4481@ada>
References: <20140826154129.GA4481@ada>
To: Andreea-Cristina Bernat <bernat.ada@gmail.com>
Cc: dhowells@redhat.com, shemming@brocade.com, linux-kernel@vger.kernel.org,
        paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH RFC] rcu: assoc_array: Add critical section to avoid a bug
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3613.1409225551.1@warthog.procyon.org.uk>
Date: Thu, 28 Aug 2014 12:32:31 +0100
Message-ID: <3614.1409225551@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreea-Cristina Bernat <bernat.ada@gmail.com> wrote:

> * The function "assoc_array_gc()" could be preempted between the call to
> "assoc_array_apply_edit()" call and the assignment
> "edit->array->nr_leaves_on_tree = nr_leaves_on_tree;", so the grace
> period could complete.

The bug is real, but this patch isn't the right solution.

The edit script should be considered inaccessible to a function the moment it
calls assoc_array_apply_edit() or assoc_array_cancel_edit().  I think this is
a better way.

David
---
 assoc_array.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

commit 10c26fcc224c0515e15272515e7b9006cb08adc8
Author: David Howells <dhowells@redhat.com>
Date:   Wed Aug 27 18:39:44 2014 +0100

    KEYS: Fix use-after-free in assoc_array_gc()
    
    An edit script should be considered inaccessible by a function once it has
    called assoc_array_apply_edit() or assoc_array_cancel_edit().
    
    However, assoc_array_gc() is accessing the edit script just after the
    gc_complete: label.
    
    Reported-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
    Signed-off-by: David Howells <dhowells@redhat.com>

diff --git a/lib/assoc_array.c b/lib/assoc_array.c
index c0b1007011e1..ae146f0734eb 100644
--- a/lib/assoc_array.c
+++ b/lib/assoc_array.c
@@ -1735,7 +1735,7 @@ ascend_old_tree:
 gc_complete:
 	edit->set[0].to = new_root;
 	assoc_array_apply_edit(edit);
-	edit->array->nr_leaves_on_tree = nr_leaves_on_tree;
+	array->nr_leaves_on_tree = nr_leaves_on_tree;
 	return 0;
 
 enomem:
