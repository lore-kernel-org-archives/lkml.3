Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300AbaCSGlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 02:41:49 -0400
Received: from ozlabs.org ([203.10.76.45]:39314 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485AbaCSGlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 02:41:46 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Joe Perches <joe@perches.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, fes@google.com
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] virtio-blk: make the queue depth configurable
In-Reply-To: <1395041214.2556.17.camel@joe-AO722>
References: <1394818263-29947-1-git-send-email-tytso@mit.edu> <1394818720.3253.1.camel@joe-AO722> <20140314180258.GA29201@thunk.org> <87y509scl3.fsf@rustcorp.com.au> <1395032434.2556.10.camel@joe-AO722> <1395041214.2556.17.camel@joe-AO722>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Wed, 19 Mar 2014 17:07:50 +1030
Message-ID: <87zjkmr8w1.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:
> On Sun, 2014-03-16 at 22:00 -0700, Joe Perches wrote:
>> On Mon, 2014-03-17 at 14:25 +1030, Rusty Russell wrote:
>> 
>> > Erk, our tests are insufficient.  Testbuilding an allmodconfig with this
>> > now:
>> 
>> Good idea.
>> 
>> > diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
>> []
>> > @@ -188,6 +188,9 @@ struct kparam_array
>> >  	/* Default value instead of permissions? */			\
>> >  	static int __param_perm_check_##name __attribute__((unused)) =	\
>> >  	BUILD_BUG_ON_ZERO((perm) < 0 || (perm) > 0777 || ((perm) & 2))	\
>> > +	/* User perms >= group perms >= other perms. */			\
>> > +	+ BUILD_BUG_ON_ZERO(((perm) >> 6) < (((perm) >> 3) & 7))	\
>> > +	+ BUILD_BUG_ON_ZERO((((perm) >> 3) & 7) < ((perm) & 7))		\
>> >  	+ BUILD_BUG_ON_ZERO(sizeof(""prefix) > MAX_PARAM_PREFIX_LEN);	\
>> >  	static const char __param_str_##name[] = prefix #name;		\
>> >  	static struct kernel_param __moduleparam_const __param_##name	\
>> 
>> It might make sense to separate this octal permissions
>> test into a new macro for other checks in macros like
>> CLASS_ATTR, DEVICE_ATTR, SENSOR_ATTR and SENSOR_ATTR_2.

OK, I took your bikeshed and re-painted it below.

> #define VERIFY_OCTAL_PERMISSIONS(perms)					\
> ({									\
> 	if (__builtin_constant_p(perms)) {				\
> 		BUILD_BUG_ON((perms) < 0);				\
> 		BUILD_BUG_ON((perms) > 0777);				\
> 		/* User perms >= group perms >= other perms */		\
> 		BUILD_BUG_ON(((perms) >> 6) < (((perms) >> 3) & 7));	\
> 		BUILD_BUG_ON((((perms) >> 3) & 7) < ((perms) & 7));	\
> 	}								\
> 	;								\
> })

Subject: VERIFY_OCTAL_PERMISSIONS: stricter checking for sysfs perms.

Summary of http://lkml.org/lkml/2014/3/14/363 :

  Ted: module_param(queue_depth, int, 444)
  Joe: 0444!
  Rusty: User perms >= group perms >= other perms?
  Joe: CLASS_ATTR, DEVICE_ATTR, SENSOR_ATTR and SENSOR_ATTR_2?

Side effect of stricter permissions means removing the unnecessary
S_IFREG from drivers/pci/slot.c.

Suggested-by: Joe Perches <joe@perches.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/drivers/pci/slot.c b/drivers/pci/slot.c
index 7dd62fa9d0bd..396c200b9ddb 100644
--- a/drivers/pci/slot.c
+++ b/drivers/pci/slot.c
@@ -116,11 +116,11 @@ static void pci_slot_release(struct kobject *kobj)
 }
 
 static struct pci_slot_attribute pci_slot_attr_address =
-	__ATTR(address, (S_IFREG | S_IRUGO), address_read_file, NULL);
+	__ATTR(address, S_IRUGO, address_read_file, NULL);
 static struct pci_slot_attribute pci_slot_attr_max_speed =
-	__ATTR(max_bus_speed, (S_IFREG | S_IRUGO), max_speed_read_file, NULL);
+	__ATTR(max_bus_speed, S_IRUGO, max_speed_read_file, NULL);
 static struct pci_slot_attribute pci_slot_attr_cur_speed =
-	__ATTR(cur_bus_speed, (S_IFREG | S_IRUGO), cur_speed_read_file, NULL);
+	__ATTR(cur_bus_speed, S_IRUGO, cur_speed_read_file, NULL);
 
 static struct attribute *pci_slot_default_attrs[] = {
 	&pci_slot_attr_address.attr,
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 471090093c67..945afeb3058a 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -842,4 +842,13 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
 # define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD
 #endif
 
+/* Permissions on a sysfs file: you didn't miss the 0 prefix did you? */
+#define VERIFY_OCTAL_PERMISSIONS(perms)					\
+	((__builtin_constant_p(perms) ?					\
+	  BUILD_BUG_ON_ZERO((perms) < 0) +				\
+	  BUILD_BUG_ON_ZERO((perms) > 0777) +				\
+	  /* User perms >= group perms >= other perms */		\
+	  BUILD_BUG_ON_ZERO(((perms) >> 6) < (((perms) >> 3) & 7)) +	\
+	  BUILD_BUG_ON_ZERO((((perms) >> 3) & 7) < ((perms) & 7)): 0) +	\
+	 (perms))
 #endif
diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 175f6995d1af..204a67743804 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -186,14 +186,12 @@ struct kparam_array
    parameters. */
 #define __module_param_call(prefix, name, ops, arg, perm, level)	\
 	/* Default value instead of permissions? */			\
-	static int __param_perm_check_##name __attribute__((unused)) =	\
-	BUILD_BUG_ON_ZERO((perm) < 0 || (perm) > 0777 || ((perm) & 2))	\
-	+ BUILD_BUG_ON_ZERO(sizeof(""prefix) > MAX_PARAM_PREFIX_LEN);	\
-	static const char __param_str_##name[] = prefix #name;		\
+	static const char __param_str_##name[] = prefix #name; \
 	static struct kernel_param __moduleparam_const __param_##name	\
 	__used								\
     __attribute__ ((unused,__section__ ("__param"),aligned(sizeof(void *)))) \
-	= { __param_str_##name, ops, perm, level, { arg } }
+	= { __param_str_##name, ops, VERIFY_OCTAL_PERMISSIONS(perm),	\
+	    level, { arg } }
 
 /* Obsolete - use module_param_cb() */
 #define module_param_call(name, set, get, arg, perm)			\
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 30b2ebee6439..f517e6e488c8 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -71,7 +71,8 @@ struct attribute_group {
  */
 
 #define __ATTR(_name, _mode, _show, _store) {				\
-	.attr = {.name = __stringify(_name), .mode = _mode },		\
+	.attr = {.name = __stringify(_name),				\
+		 .mode = VERIFY_OCTAL_PERMISSIONS(_mode) },		\
 	.show	= _show,						\
 	.store	= _store,						\
 }
