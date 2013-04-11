Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935697Ab3DKNyM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:54:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934557Ab3DKNyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:54:09 -0400
Date: Thu, 11 Apr 2013 15:53:40 +0200
From: Veaceslav Falico <vfalico@redhat.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, bhelgaas@google.com
Subject: Re: [PATCH] module: add kset_obj_exists() and use it
Message-ID: <20130411135340.GF21320@redhat.com>
References: <1365506529-8396-1-git-send-email-vfalico@redhat.com>
 <87y5cq6ei9.fsf@rustcorp.com.au>
 <20130411095537.GC21320@redhat.com>
 <20130411132831.GC2909@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20130411132831.GC2909@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 06:28:31AM -0700, Greg KH wrote:
>On Thu, Apr 11, 2013 at 11:55:37AM +0200, Veaceslav Falico wrote:
>> However, I think my patch still adds something good, cause now we have 2
>> cases where we basically do:
>>
>> k = kset_find_obj();
>> if (!k)
>> 	return;
>> kobject_put(k);
>>
>> which adds useless overhead (by using kobject_get()/kobject_put(), and
>> kobject_release() - which is called from kobject_put()) - where we should
>> only verify if there exists a kobject with the specified name.
>>
>> Should I resend it with a properly fixed commit message, or it's really not
>> needed?
>
>I don't think it's really needed, there is no speed/overhead issue here
>and you need to do the kobject_get/put stuff anyway if you are trying to
>look at a kobject.

This is the point, actually, that we don't need to look at a kobject. We
only need to know if it existed that time or not, here are those two
examples of code:

static int mod_sysfs_init(struct module *mod)
{
         int err;
         struct kobject *kobj;

	...

         kobj = kset_find_obj(module_kset, mod->name);
         if (kobj) {
                 printk(KERN_ERR "%s: module is already loaded\n", mod->name);
                 kobject_put(kobj);
                 err = -EINVAL;
                 goto out;
         }

	...

So we just verify if there's a kobject with mod->name, and if it exists -
_put() it back and return, otherwise do nothing (with it).

Same here:

static char *make_slot_name(const char *name)
{
	...

         for (;;) {
                 struct kobject *dup_slot;
                 dup_slot = kset_find_obj(pci_slots_kset, new_name);
                 if (!dup_slot)
                         break;
                 kobject_put(dup_slot);

	...

We look if there exists a kobject named new_name in pci_slots_kset, if yes
- free it and try another name, if not - then we're good to go.

In both examples we don't look at that kobject, and only uselessly
_get()/_put() it. And it looks a bit ugly. After the patch, in both cases,
it takes only one call to kset_obj_exists() to find out if the object
exists at that time.

However, I have absolutely no knowledge/experience in this domain and might
for sure be missing something. Sorry if it's the case.

>
>thanks,
>
>greg k-h
