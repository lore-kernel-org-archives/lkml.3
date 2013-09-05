Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab3IEVo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 17:44:57 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53183 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab3IEVoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 17:44:55 -0400
Date: Thu, 5 Sep 2013 22:44:34 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dave Jones <davej@redhat.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kobject: delayed kobject release: help find buggy drivers
Message-ID: <20130905214434.GL6617@n2100.arm.linux.org.uk>
References: <20130903204442.GA22222@redhat.com> <20130903205527.GA6358@kroah.com> <87zjrt6tz4.fsf@rustcorp.com.au> <20130905041338.GA21090@redhat.com> <20130905045745.GA18876@kroah.com> <20130905051945.GB23209@redhat.com> <20130905173540.GK6617@n2100.arm.linux.org.uk> <20130905192917.GA9339@redhat.com> <20130905211113.GA22201@redhat.com> <20130905212606.GA22584@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130905212606.GA22584@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 05:26:06PM -0400, Dave Jones wrote:
> On Thu, Sep 05, 2013 at 05:11:13PM -0400, Dave Jones wrote:
>  >  > Trying without serial console next..
>  > 
>  > rebuilt with all serial turned off.
>  > 
>  > no luck, then it oopses somewhere else. I'm suspecting something isn't
>  > right with that debug patch, as the next trace is also in kobject_release

You're right about that - I had assumed that it was necessary for all
kobjects to be 'added' before they're released, but that is not so.
Mea culpa.  They just need to be initialised - the problem with putting
a kmalloc into kobject_init() is that if it fails, we have no way to
report that failure...

Updated patch attached... though it sounds like you got it working
anyway.

> I managed to get to userspace on one boot, and got this.
> 
> kobject ffff88023d93f518 has been corrupted (magic 0x6b6b6b6b).  Please
> enable kobject debugging for full debug.

Okay, so this is definitely a case that someone has kfree'd the kobject
without waiting for the ->release function to be called.

> That looks like SLAB_POISON. Incompatibility between the two options ?
> 
> For some reason, even though I have DEBUG_KOBJECT on, I didn't get
> extra messages output.

Hmm.

ifeq ($(CONFIG_DEBUG_KOBJECT),y)
CFLAGS_kobject.o += -DDEBUG
CFLAGS_kobject_uevent.o += -DDEBUG
endif

should enable the pr_debug()'s in lib/kobject.c... which should at least
appear in the dmesg log.  Being debug level, of course, they won't appear
during normal kernel boot unless 'debug' is passed on the kernel command
line.

It seems to work for me - but... produces rather a lot of debug messages,
so you may also wish to ensure that you have LOG_BUF_SHIFT set to
something large.

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
index 1d46c15..a700d4f 100644
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
@@ -283,6 +290,15 @@ void kobject_init(struct kobject *kobj, struct kobj_type *ktype)
 		       "object, something is seriously wrong.\n", kobj);
 		dump_stack();
 	}
+#ifdef CONFIG_DEBUG_KOBJECT_RELEASE
+	kobj->release = kmalloc(sizeof(*kobj->release), GFP_KERNEL);
+	WARN_ON(!kobj->release);
+	if (kobj->release) {
+		kobj->release->kobj = kobj;
+		kobj->magic = KOBJ_MAGIC;
+	}
+#endif
+
 
 	kobject_init_internal(kobj);
 	kobj->ktype = ktype;
@@ -583,8 +599,20 @@ static void kobject_cleanup(struct kobject *kobj)
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
 
@@ -594,8 +622,8 @@ static void kobject_release(struct kref *kref)
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

