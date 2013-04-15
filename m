Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723Ab3DOCqy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 22:46:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36511 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934002Ab3DOCn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 22:43:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 18/27] kobject: fix kset_find_obj() race with concurrent last kobject_put()
Date: Sun, 14 Apr 2013 19:43:17 -0700
Message-Id: <20130415024232.716742509@linuxfoundation.org>
X-Mailer: git-send-email 1.8.2.1.368.g99c2266
In-Reply-To: <20130415024231.351969241@linuxfoundation.org>
References: <20130415024231.351969241@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit a49b7e82cab0f9b41f483359be83f44fbb6b4979 upstream.

Anatol Pomozov identified a race condition that hits module unloading
and re-loading.  To quote Anatol:

 "This is a race codition that exists between kset_find_obj() and
  kobject_put().  kset_find_obj() might return kobject that has refcount
  equal to 0 if this kobject is freeing by kobject_put() in other
  thread.

  Here is timeline for the crash in case if kset_find_obj() searches for
  an object tht nobody holds and other thread is doing kobject_put() on
  the same kobject:

    THREAD A (calls kset_find_obj())     THREAD B (calls kobject_put())
    splin_lock()
                                         atomic_dec_return(kobj->kref), counter gets zero here
                                         ... starts kobject cleanup ....
                                         spin_lock() // WAIT thread A in kobj_kset_leave()
    iterate over kset->list
    atomic_inc(kobj->kref) (counter becomes 1)
    spin_unlock()
                                         spin_lock() // taken
                                         // it does not know that thread A increased counter so it
                                         remove obj from list
                                         spin_unlock()
                                         vfree(module) // frees module object with containing kobj

    // kobj points to freed memory area!!
    kobject_put(kobj) // OOPS!!!!

  The race above happens because module.c tries to use kset_find_obj()
  when somebody unloads module.  The module.c code was introduced in
  commit 6494a93d55fa"

Anatol supplied a patch specific for module.c that worked around the
problem by simply not using kset_find_obj() at all, but rather than make
a local band-aid, this just fixes kset_find_obj() to be thread-safe
using the proper model of refusing the get a new reference if the
refcount has already dropped to zero.

See examples of this proper refcount handling not only in the kref
documentation, but in various other equivalent uses of this pattern by
grepping for atomic_inc_not_zero().

[ Side note: the module race does indicate that module loading and
  unloading is not properly serialized wrt sysfs information using the
  module mutex.  That may require further thought, but this is the
  correct fix at the kobject layer regardless. ]

Reported-analyzed-and-tested-by: Anatol Pomozov <anatol.pomozov@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/kobject.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -529,6 +529,13 @@ struct kobject *kobject_get(struct kobje
 	return kobj;
 }
 
+static struct kobject *kobject_get_unless_zero(struct kobject *kobj)
+{
+	if (!kref_get_unless_zero(&kobj->kref))
+		kobj = NULL;
+	return kobj;
+}
+
 /*
  * kobject_cleanup - free kobject resources.
  * @kobj: object to cleanup
@@ -751,7 +758,7 @@ struct kobject *kset_find_obj(struct kse
 
 	list_for_each_entry(k, &kset->list, entry) {
 		if (kobject_name(k) && !strcmp(kobject_name(k), name)) {
-			ret = kobject_get(k);
+			ret = kobject_get_unless_zero(k);
 			break;
 		}
 	}


