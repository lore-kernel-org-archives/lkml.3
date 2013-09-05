Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab3IERgE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 13:36:04 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53068 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab3IERgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 13:36:01 -0400
Date: Thu, 5 Sep 2013 18:35:40 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dave Jones <davej@redhat.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kobject: delayed kobject release: help find buggy drivers
Message-ID: <20130905173540.GK6617@n2100.arm.linux.org.uk>
References: <20130903185924.046EE660E91@gitolite.kernel.org> <20130903204442.GA22222@redhat.com> <20130903205527.GA6358@kroah.com> <87zjrt6tz4.fsf@rustcorp.com.au> <20130905041338.GA21090@redhat.com> <20130905045745.GA18876@kroah.com> <20130905051945.GB23209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130905051945.GB23209@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 01:19:45AM -0400, Dave Jones wrote:
> Got it. (I think I was getting tracebacks from multiple cpus, hence
> the spewing). Adding a check for tainted() = infinite loop to
> show_backtrace() combined with boot_delay gave me a really long oops
> that I had to grab video to record.

How complete is this trace?  If accurate, I suspect that this is an oops
caused by the timer expiring, but the memory associated with the timer
has already been overwritten.  That would make it particularly hard to
debug.

Given that we run the delayed release 1 second after the object release,
I'm thinking that this has nothing to do with AHCI.

So, there's not a lot to go on here.

I'm wondering if there's any milage to allocating the kobject release
information inside kobject_add_internal(), so that we can at least run
the timer list and delayed work queues safely, and add debugging to
print the kobject pointer before we end up oopsing.  If we also add a
magic value to the beginning of the kobject, we can check whether it
looks like it may still be valid before we try and treat it as a kobject,
which may save us from oopsing on boot.

With the kobject debugging already there, it should be possible to match
the pointer value with previous debugging from kobject_add_internal()
and work out what kobject causes this.

Maybe the patch below will allow Dave to boot to a prompt and capture
the full dmesg - I've only just cooked up this patch so it may need
a bit of work to get it to build.  Please ensure that kobject debugging
is enabled, so we can translate from kobject addresses to names.

Dave - thanks for your patience and effort in trying to track this down.
Hopefully the patch below will make it easier.

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index de6dcbcc..30821f1 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -58,7 +58,13 @@ enum kobject_action {
 	KOBJ_MAX
 };
 
+struct kobject_release;
+
 struct kobject {
+#ifdef CONFIG_DEBUG_KOBJECT_RELEASE
+	unsigned int		magic;
+	struct kobject_release	*release;
+#endif
 	const char		*name;
 	struct list_head	entry;
 	struct kobject		*parent;
@@ -66,9 +72,6 @@ struct kobject {
 	struct kobj_type	*ktype;
 	struct sysfs_dirent	*sd;
 	struct kref		kref;
-#ifdef CONFIG_DEBUG_KOBJECT_RELEASE
-	struct delayed_work	release;
-#endif
 	unsigned int state_initialized:1;
 	unsigned int state_in_sysfs:1;
 	unsigned int state_add_uevent_sent:1;
diff --git a/lib/kobject.c b/lib/kobject.c
index 1d46c15..e5b5998 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -153,6 +153,13 @@ static void kobject_init_internal(struct kobject *kobj)
 }
 
 
+#ifdef CONFIG_DEBUG_KOBJECT_RELEASE
+#define KOBJ_MAGIC	('k' | 'o' << 8 | 'b' << 16 | 'j' << 24)
+struct kobject_release {
+	struct delayed_work work;
+	struct kobject *kobj;
+};
+#endif
 static int kobject_add_internal(struct kobject *kobj)
 {
 	int error = 0;
@@ -169,6 +176,14 @@ static int kobject_add_internal(struct kobject *kobj)
 
 	parent = kobject_get(kobj->parent);
 
+#ifdef CONFIG_DEBUG_KOBJECT_RELEASE
+	kobj->release = kmalloc(sizeof(*kobj->release), GFP_KERNEL);
+	if (!kobj->release)
+		return -ENOMEM;
+	kobj->release->kobj = kobj;
+	kobj->magic = KOBJ_MAGIC;
+#endif
+
 	/* join kset if set, use it as parent if we do not already have one */
 	if (kobj->kset) {
 		if (!parent)
@@ -198,6 +213,9 @@ static int kobject_add_internal(struct kobject *kobj)
 			WARN(1, "%s failed for %s (error: %d parent: %s)\n",
 			     __func__, kobject_name(kobj), error,
 			     parent ? kobject_name(parent) : "'none'");
+		kfree(kobj->release);
+		kobj->release = NULL;
+		kobj->magic = 0;
 	} else
 		kobj->state_in_sysfs = 1;
 
@@ -583,8 +601,20 @@ static void kobject_cleanup(struct kobject *kobj)
 #ifdef CONFIG_DEBUG_KOBJECT_RELEASE
 static void kobject_delayed_cleanup(struct work_struct *work)
 {
-	kobject_cleanup(container_of(to_delayed_work(work),
-				     struct kobject, release));
+	struct kobject_release *release = container_of(to_delayed_work(work),
+						struct kobject_release, work);
+	struct kobject *kobj = release->kobj;
+
+	kfree(release);
+	if (kobj->magic == KOBJ_MAGIC) {
+		pr_debug("kobject: '%s' (%p): %s\n",
+			 kobject_name(kobj), kobj, __func__);
+		kobject_cleanup(kobj);
+	} else {
+		pr_err("kobject %p has been corrupted (magic 0x%08x).  Please enable kobject debugging for full debug.\n",
+			kobj, kobj->magic);
+		/* We end up leaking the kobject */
+	}
 }
 #endif
 
@@ -594,8 +624,8 @@ static void kobject_release(struct kref *kref)
 #ifdef CONFIG_DEBUG_KOBJECT_RELEASE
 	pr_debug("kobject: '%s' (%p): %s, parent %p (delayed)\n",
 		 kobject_name(kobj), kobj, __func__, kobj->parent);
-	INIT_DELAYED_WORK(&kobj->release, kobject_delayed_cleanup);
-	schedule_delayed_work(&kobj->release, HZ);
+	INIT_DELAYED_WORK(&kobj->release->work, kobject_delayed_cleanup);
+	schedule_delayed_work(&kobj->release->work, HZ);
 #else
 	kobject_cleanup(kobj);
 #endif

