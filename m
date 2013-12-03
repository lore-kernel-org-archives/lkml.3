Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab3LCWlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 17:41:49 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:61745 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab3LCWlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 17:41:46 -0500
Date: Tue, 3 Dec 2013 15:41:43 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Veaceslav Falico <vfalico@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        Neil Horman <nhorman@tuxdriver.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zdenek Kabelac <zkabelac@redhat.com>,
        Matt Domsch <Matt_Domsch@dell.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] kobject: remove kset from sysfs immediately in
 kset_unregister()
Message-ID: <20131203224143.GA19962@google.com>
References: <20131008201915.19377.34185.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20131008202016.19377.17182.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20131203180425.GC15279@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131203180425.GC15279@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Matt, Tejun]

On Tue, Dec 03, 2013 at 10:04:25AM -0800, Greg Kroah-Hartman wrote:
> On Tue, Oct 08, 2013 at 02:20:16PM -0600, Bjorn Helgaas wrote:
> > There's no explicit "unlink from sysfs" interface for ksets, so I think
> > callers of kset_unregister() expect the kset to be removed from sysfs
> > immediately, without waiting for the last reference to be released.
> > 
> > This patch makes the sysfs removal happen immediately, so the caller may
> > create a new kset with the same name as soon as kset_unregister() returns.
> > 
> > Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> 
> With the PCI MSI attribute change, this patch is no longer needed,
> right?

Well, yes and no.  The attached patch extends Russell's delayed kobject
release to make the delay somewhat random.  I *think* that should be
valid, but correct me if I'm wrong.

With the random delay patch, it's easy to trigger the "sysfs: cannot
create duplicate filename" error, e.g., by unloading and reloading the
edd module, because the module unload only waits for the /sys/module/edd
object to be released.  Other objects, such as the /sys/firmware/edd
kset, may be released later.

Modules like edd could be changed to explicitly call kobject_del() on
the kset kobject.  Maybe that's a better approach, so we consistently
use kobject_del() to remove things from sysfs.  But I don't know whether
it's really useful to allow the kset to hang around in sysfs after
kset_unregister(), and it's sort of subtle to track down problems like
this.

Several other kset_unregister() callers have this situation, so if we
don't change it to call kobject_del() internally, maybe we should add a
note to Documentation/kobject.txt about calling kobject_del() first.
The existing hint only talks about using it when you need a two-stage
delete, which isn't really the case here.

If we *do* decide to change kset_unregister(), I have an updated
documentation patch that makes it more clear that the release may
happen after kset_unregister() returns.

Bjorn

> > ---
> >  Documentation/kobject.txt |    3 ++-
> >  lib/kobject.c             |    1 +
> >  2 files changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/kobject.txt b/Documentation/kobject.txt
> > index c5182bb..8e8b501 100644
> > --- a/Documentation/kobject.txt
> > +++ b/Documentation/kobject.txt
> > @@ -342,7 +342,8 @@ kset use:
> >  
> >  When you are finished with the kset, call:
> >    void kset_unregister(struct kset *kset);
> > -to destroy it.
> > +to destroy it.  This removes the kset from sysfs and, after the kset
> > +reference count goes to zero, releases it.
> >  
> >  An example of using a kset can be seen in the
> >  samples/kobject/kset-example.c file in the kernel tree.
> > diff --git a/lib/kobject.c b/lib/kobject.c
> > index 9621751..9098992 100644
> > --- a/lib/kobject.c
> > +++ b/lib/kobject.c
> > @@ -753,6 +753,7 @@ void kset_unregister(struct kset *k)
> >  {
> >  	if (!k)
> >  		return;
> > +	kobject_del(&k->kobj);
> >  	kobject_put(&k->kobj);
> >  }
> >  



kobject: delay kobject release for random time

From: Bjorn Helgaas <bhelgaas@google.com>

This delays kobject release functions for a random time between 1 and 8
seconds, which effectively changes the order in which they're called.
---
 lib/kobject.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index 5b4b8886435e..c87df2f7dbff 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -18,6 +18,7 @@
 #include <linux/export.h>
 #include <linux/stat.h>
 #include <linux/slab.h>
+#include <linux/random.h>
 
 /**
  * kobject_namespace - return @kobj's namespace tag
@@ -625,10 +626,13 @@ static void kobject_release(struct kref *kref)
 {
 	struct kobject *kobj = container_of(kref, struct kobject, kref);
 #ifdef CONFIG_DEBUG_KOBJECT_RELEASE
-	pr_info("kobject: '%s' (%p): %s, parent %p (delayed)\n",
-		 kobject_name(kobj), kobj, __func__, kobj->parent);
+	unsigned long delay = HZ + HZ * (get_random_int() & 0x3);
+
+	pr_info("kobject: '%s' (%p): %s, parent %p (delayed %ld)\n",
+		 kobject_name(kobj), kobj, __func__, kobj->parent, delay);
 	INIT_DELAYED_WORK(&kobj->release, kobject_delayed_cleanup);
-	schedule_delayed_work(&kobj->release, HZ);
+
+	schedule_delayed_work(&kobj->release, delay);
 #else
 	kobject_cleanup(kobj);
 #endif
