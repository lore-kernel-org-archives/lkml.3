Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab3DKJ4L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 05:56:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050Ab3DKJ4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 05:56:07 -0400
Date: Thu, 11 Apr 2013 11:55:37 +0200
From: Veaceslav Falico <vfalico@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        gregkh@linuxfoundation.org, bhelgaas@google.com
Subject: Re: [PATCH] module: add kset_obj_exists() and use it
Message-ID: <20130411095537.GC21320@redhat.com>
References: <1365506529-8396-1-git-send-email-vfalico@redhat.com>
 <87y5cq6ei9.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <87y5cq6ei9.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 04:47:34PM +0930, Rusty Russell wrote:
>Veaceslav Falico <vfalico@redhat.com> writes:
>> Add a new function, kset_obj_exists(), which is identical to
>> kset_find_obj() but doesn't take a reference to the kobject
>> found and only returns bool if found/not found.
>>
>> The main purpose would be to avoid the possible race scenario,
>> when we could get the reference in between the kref_put() and
>> kobject_release() functions (i.e. kref_put() already ran,
>> refcount became 0, but the kobject_release() function still
>> didn't run, and we try to get via kobject_get() and thus ending
>> up with a released kobject).
>
>What?  If refcount is zero, there should be no more references to it.
>That's what 0 means.
>
>If you want 0-and-then-cleanup, you need atomic_dec_and_lock().

Yep, you're right, I was trying to fix consequences instead of fixing the
cause. What I've encountered was:

rmmod:
  #5 [ffff88005a073d78] __delay at ffffffff813a940f
  #6 [ffff88005a073d80] do_raw_spin_lock at ffffffff813b1d2e
  #7 [ffff88005a073db0] _raw_spin_lock at ffffffff816f8e76
  #8 [ffff88005a073de0] kobj_kset_leave at ffffffff8139ee5a
  #9 [ffff88005a073e00] kobject_del at ffffffff8139eeb2
#10 [ffff88005a073e20] kobject_cleanup at ffffffff8139ef32
#11 [ffff88005a073e50] kobject_release at ffffffff8139f08d
#12 [ffff88005a073e60] kobject_put at ffffffff8139eddc
#13 [ffff88005a073e80] mod_sysfs_teardown at ffffffff810ed9cc
#14 [ffff88005a073eb0] free_module at ffffffff810edf57
#15 [ffff88005a073ed0] sys_delete_module at ffffffff810ee508
#16 [ffff88005a073f80] system_call_fastpath at ffffffff81703819

insmod:
[exception RIP: kobject_get+63]
  #7 [ffff88005a0f3db0] kset_find_obj at ffffffff8139f139
  #8 [ffff88005a0f3de0] mod_sysfs_init at ffffffff810ed5f3
  #9 [ffff88005a0f3e20] mod_sysfs_setup at ffffffff810f1872
#10 [ffff88005a0f3e80] load_module at ffffffff810f2003
#11 [ffff88005a0f3ef0] sys_init_module at ffffffff810f22e4
#12 [ffff88005a0f3f80] system_call_fastpath at ffffffff81703819

So I've thought it was a race in kset_find_obj(), and I've been wrong (I've
replaced the WARN_ON(refcount) with BUG_ON - we'd anyway BUG somewhere
further in kobject_put() ).

However, I think my patch still adds something good, cause now we have 2
cases where we basically do:

k = kset_find_obj();
if (!k)
	return;
kobject_put(k);

which adds useless overhead (by using kobject_get()/kobject_put(), and
kobject_release() - which is called from kobject_put()) - where we should
only verify if there exists a kobject with the specified name.

Should I resend it with a properly fixed commit message, or it's really not
needed?

>
>> It can be triggered, for example,
>> by running insmod/rmmod bonding in parallel, which ends up in
>> a race between kset_obj_find() in mod_sysfs_init() and rmmod's
>> mod_sysfs_fini()/kobject_put().
>
>That's a bug.  We should be cleaning up sysfs before we unlike the
>removed module from the list.
>
>Because the same thing applies to ddebug info, which is also keyed by
>module name.
>
>Something like this (untested!):

Sorry for the late response - I wanted to test it for a longer time.

Your patch works flawlessly and fixes this race, with just a small
addition, cause otherwise we could BUG() in show_initstate().

Can you apply this patch or should I (re-)send it somehow?

Thank you!

diff --git a/kernel/module.c b/kernel/module.c
index d0afe23..8be6e97 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1063,6 +1063,9 @@ static ssize_t show_initstate(struct module_attribute *mattr,
  	case MODULE_STATE_GOING:
  		state = "going";
  		break;
+	case MODULE_STATE_UNFORMED:
+		state = "unformed";
+		break;
  	default:
  		BUG();
  	}

>
>diff --git a/kernel/module.c b/kernel/module.c
>index 3c2c72d..8d4de82 100644
>--- a/kernel/module.c
>+++ b/kernel/module.c
>@@ -1862,10 +1862,10 @@ static void free_module(struct module *mod)
> {
> 	trace_module_free(mod);
>
>-	/* Delete from various lists */
>-	mutex_lock(&module_mutex);
>-	stop_machine(__unlink_module, mod, NULL);
>-	mutex_unlock(&module_mutex);
>+	/* We leave it in list to prevent duplicate loads while we clean
>+	 * up sysfs, ddebug and any other external exposure. */
>+	mod->state = MODULE_STATE_UNFORMED;
>+
> 	mod_sysfs_teardown(mod);
>
> 	/* Remove dynamic debug info */
>@@ -1880,6 +1880,11 @@ static void free_module(struct module *mod)
> 	/* Free any allocated parameters. */
> 	destroy_params(mod->kp, mod->num_kp);
>
>+	/* Now we can delete it from the lists */
>+	mutex_lock(&module_mutex);
>+	stop_machine(__unlink_module, mod, NULL);
>+	mutex_unlock(&module_mutex);
>+
> 	/* This may be NULL, but that's OK */
> 	unset_module_init_ro_nx(mod);
> 	module_free(mod, mod->module_init);
>
>> It also saves us some CPU time in several places where we don't
>> need the kobject itself and only need to verify if it actually
>> exists, by not taking the kref (and thus we don't need to
>> kobject_put() afterwards).
>>
>> Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
>> ---
>>  drivers/pci/slot.c      |    5 +----
>>  include/linux/kobject.h |    1 +
>>  kernel/module.c         |    5 +----
>>  lib/kobject.c           |   28 ++++++++++++++++++++++++++++
>>  4 files changed, 31 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/pci/slot.c b/drivers/pci/slot.c
>> index ac6412f..3988d75 100644
>> --- a/drivers/pci/slot.c
>> +++ b/drivers/pci/slot.c
>> @@ -154,11 +154,8 @@ static char *make_slot_name(const char *name)
>>  	dup = 1;
>>
>>  	for (;;) {
>> -		struct kobject *dup_slot;
>> -		dup_slot = kset_find_obj(pci_slots_kset, new_name);
>> -		if (!dup_slot)
>> +		if (!kset_obj_exists(pci_slots_kset, new_name))
>>  			break;
>> -		kobject_put(dup_slot);
>>  		if (dup == max) {
>>  			len++;
>>  			max *= 10;
>> diff --git a/include/linux/kobject.h b/include/linux/kobject.h
>> index 939b112..7cde72c 100644
>> --- a/include/linux/kobject.h
>> +++ b/include/linux/kobject.h
>> @@ -191,6 +191,7 @@ static inline struct kobj_type *get_ktype(struct kobject *kobj)
>>  }
>>
>>  extern struct kobject *kset_find_obj(struct kset *, const char *);
>> +extern bool kset_obj_exists(struct kset *, const char *);
>>
>>  /* The global /sys/kernel/ kobject for people to chain off of */
>>  extern struct kobject *kernel_kobj;
>> diff --git a/kernel/module.c b/kernel/module.c
>> index 0925c9a..1df13a3 100644
>> --- a/kernel/module.c
>> +++ b/kernel/module.c
>> @@ -1606,7 +1606,6 @@ static void module_remove_modinfo_attrs(struct module *mod)
>>  static int mod_sysfs_init(struct module *mod)
>>  {
>>  	int err;
>> -	struct kobject *kobj;
>>
>>  	if (!module_sysfs_initialized) {
>>  		printk(KERN_ERR "%s: module sysfs not initialized\n",
>> @@ -1615,10 +1614,8 @@ static int mod_sysfs_init(struct module *mod)
>>  		goto out;
>>  	}
>>
>> -	kobj = kset_find_obj(module_kset, mod->name);
>> -	if (kobj) {
>> +	if (kset_obj_exists(module_kset, mod->name)) {
>>  		printk(KERN_ERR "%s: module is already loaded\n", mod->name);
>> -		kobject_put(kobj);
>>  		err = -EINVAL;
>>  		goto out;
>>  	}
>> diff --git a/lib/kobject.c b/lib/kobject.c
>> index e07ee1f..b82633f 100644
>> --- a/lib/kobject.c
>> +++ b/lib/kobject.c
>> @@ -760,6 +760,34 @@ struct kobject *kset_find_obj(struct kset *kset, const char *name)
>>  	return ret;
>>  }
>>
>> +/**
>> + * kset_obj_exists - verify if an object exists in kset
>> + * @kset: kset we're looking in.
>> + * @name: object's name.
>> + *
>> + * Lock kset via @kset->subsys, and iterate over @kset->list,
>> + * looking for a matching kobject. Returns bool, found/not found.
>> + * This function does not take a reference and thus doesn't
>> + * guarantee that the object won't go away any time after.
>> + */
>> +
>> +bool kset_obj_exists(struct kset *kset, const char *name)
>> +{
>> +	struct kobject *k;
>> +
>> +	spin_lock(&kset->list_lock);
>> +
>> +	list_for_each_entry(k, &kset->list, entry) {
>> +		if (kobject_name(k) && !strcmp(kobject_name(k), name)) {
>> +			spin_unlock(&kset->list_lock);
>> +			return true;
>> +		}
>> +	}
>> +
>> +	spin_unlock(&kset->list_lock);
>> +	return false;
>> +}
>> +
>>  static void kset_release(struct kobject *kobj)
>>  {
>>  	struct kset *kset = container_of(kobj, struct kset, kobj);
>> --
>> 1.7.1
