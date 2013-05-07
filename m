Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932559Ab3EGEBv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:01:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26883 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760380Ab3EGD65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:57 -0400
X-Authority-Analysis: v=2.0 cv=GtrACzJC c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=5cTyq7rrJVsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=gOVSAUkJYJQA:10 a=Z4Rwk6OoAAAA:8 a=pGLkceISAAAA:8 a=ag1SF4gXAAAA:8 a=drOt6m5kAAAA:8 a=VwQbUJbxAAAA:8 a=tfdlz2xZRgWy01eRFB0A:9 a=jbrJJM5MRmoA:10 a=MSl-tDqOz04A:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035849.624085463@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [052/126] kobject: fix kset_find_obj() race with concurrent last kobject_put()
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0052-kobject-fix-kset_find_obj-race-with-concurrent-last-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit a49b7e82cab0f9b41f483359be83f44fbb6b4979 ]

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
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: stable@vger.kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 lib/kobject.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index e07ee1f..a654866 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -529,6 +529,13 @@ struct kobject *kobject_get(struct kobject *kobj)
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
@@ -751,7 +758,7 @@ struct kobject *kset_find_obj(struct kset *kset, const char *name)
 
 	list_for_each_entry(k, &kset->list, entry) {
 		if (kobject_name(k) && !strcmp(kobject_name(k), name)) {
-			ret = kobject_get(k);
+			ret = kobject_get_unless_zero(k);
 			break;
 		}
 	}
-- 
1.7.10.4


