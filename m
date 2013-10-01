Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751336Ab3JAFxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 01:53:52 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:56014 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab3JAFxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 01:53:50 -0400
Date: Mon, 30 Sep 2013 22:53:46 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Veaceslav Falico <vfalico@redhat.com>
Cc: linux-pci@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2] msi: free msi_desc entry only after we've released
 the kobject
Message-ID: <20131001055346.GA4759@google.com>
References: <1380189591-1368-1-git-send-email-vfalico@redhat.com>
 <20130928213727.GC32063@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130928213727.GC32063@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Russell]

On Sat, Sep 28, 2013 at 11:37:27PM +0200, Veaceslav Falico wrote:
> On Thu, Sep 26, 2013 at 11:59:51AM +0200, Veaceslav Falico wrote:
> >Currently, we first do kobject_put(&entry->kobj) and the kfree(entry),
> >however kobject_put() doesn't guarantee us that it was the last reference
> >and that the kobj isn't used currently by someone else, so after we
> >kfree(entry) with the struct kobject - other users will begin using the
> >freed memory, instead of the actual kobject.
> 
> Hi Bjorn,
> 
> I've seen that you've dropped this bugfix (and the 3 cleanup patches) with
> "Changes Requested", however I don't recall any request to change this.

Oh, sorry, I didn't realize anybody else really looked at patchwork,
much less the reason codes.  I just intended to dispose of those for
now because I think we'll have several more revisions while we sort
things out.  I definitely think this is a serious issue that needs to
be fixed.  But you're right: I haven't given you any specific feedback
yet because I'm not confident about what the right fix is.

I think the current kobject delayed release is too aggressive, in the
sense that even after we've released all references, the object can
still be in sysfs, which causes future creates to fail.  E.g., this
fails:

    kset = kset_create_and_add("kobj_test", NULL, NULL);
    kset_unregister(kset);
    kset = kset_create_and_add("kobj_test", NULL, NULL);  // FAILS

when I think it should succeed.  We don't have a way for the caller to
determine when it's safe to do the second kset_create_and_add().

After we release all references, I think it's OK for the kobject
itself to continue to exist, i.e., we can delay calling t->release().
But it should be impossible to find a kobject with refcount == 0 via
sysfs, so we should be able to create a new one with the same name.

In terms of code, I'm suggesting something like the following:

diff --git a/lib/kobject.c b/lib/kobject.c
index 9621751..4e1c608 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -536,6 +536,32 @@ static struct kobject * __must_check kobject_get_unless_zero(struct kobject *kob
 	return kobj;
 }
 
+static void kobject_free(struct kobject *kobj)
+{
+	struct kobj_type *t = get_ktype(kobj);
+	const char *name = kobj->name;
+
+	if (t && t->release) {
+		pr_debug("kobject: '%s' (%p): calling ktype release\n",
+			 kobject_name(kobj), kobj);
+		t->release(kobj);
+	}
+
+	/* free name if we allocated it */
+	if (name) {
+		pr_debug("kobject: '%s': free name\n", name);
+		kfree(name);
+	}
+}
+
+#ifdef CONFIG_DEBUG_KOBJECT_RELEASE
+static void kobject_delayed_free(struct work_struct *work)
+{
+	kobject_free(container_of(to_delayed_work(work),
+		     struct kobject, release));
+}
+#endif
+
 /*
  * kobject_cleanup - free kobject resources.
  * @kobj: object to cleanup
@@ -543,7 +569,6 @@ static struct kobject * __must_check kobject_get_unless_zero(struct kobject *kob
 static void kobject_cleanup(struct kobject *kobj)
 {
 	struct kobj_type *t = get_ktype(kobj);
-	const char *name = kobj->name;
 
 	pr_debug("kobject: '%s' (%p): %s, parent %p\n",
 		 kobject_name(kobj), kobj, __func__, kobj->parent);
@@ -567,40 +592,21 @@ static void kobject_cleanup(struct kobject *kobj)
 		kobject_del(kobj);
 	}
 
-	if (t && t->release) {
-		pr_debug("kobject: '%s' (%p): calling ktype release\n",
-			 kobject_name(kobj), kobj);
-		t->release(kobj);
-	}
-
-	/* free name if we allocated it */
-	if (name) {
-		pr_debug("kobject: '%s': free name\n", name);
-		kfree(name);
-	}
-}
-
-#ifdef CONFIG_DEBUG_KOBJECT_RELEASE
-static void kobject_delayed_cleanup(struct work_struct *work)
-{
-	kobject_cleanup(container_of(to_delayed_work(work),
-				     struct kobject, release));
-}
-#endif
-
-static void kobject_release(struct kref *kref)
-{
-	struct kobject *kobj = container_of(kref, struct kobject, kref);
 #ifdef CONFIG_DEBUG_KOBJECT_RELEASE
 	pr_debug("kobject: '%s' (%p): %s, parent %p (delayed)\n",
 		 kobject_name(kobj), kobj, __func__, kobj->parent);
-	INIT_DELAYED_WORK(&kobj->release, kobject_delayed_cleanup);
+	INIT_DELAYED_WORK(&kobj->release, kobject_delayed_free);
 	schedule_delayed_work(&kobj->release, HZ);
 #else
-	kobject_cleanup(kobj);
+	kobject_free(kobj);
 #endif
 }
 
+static void kobject_release(struct kref *kref)
+{
+	kobject_cleanup(container_of(kref, struct kobject, kref));
+}
+
 /**
  * kobject_put - decrement refcount for object.
  * @kobj: object.
