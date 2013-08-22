Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab3HVHiJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 03:38:09 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:57705 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642Ab3HVHiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 03:38:06 -0400
Message-ID: <1377157075.2633.63.camel@ThinkPad-T5421>
Subject: [RFC PATCH v2 next]module: Fix mod->mkobj.kobj potentially freed
 too early
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-next list <linux-next@vger.kernel.org>, rusty@rustcorp.com.au,
        LKML <linux-kernel@vger.kernel.org>, rmk+kernel@arm.linux.org.uk
Date: Thu, 22 Aug 2013 15:37:55 +0800
In-Reply-To: <20130822040333.GB4821@kroah.com>
References: <1377078598.2709.25.camel@ThinkPad-T5421>
	 <20130821161819.GA14364@kroah.com>
	 <1377138846.2633.25.camel@ThinkPad-T5421> <20130822040333.GB4821@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082207-9574-0000-0000-00000948FAFD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DEBUG_KOBJECT_RELEASE helps to find the issue attached below.

After some investigation, it seems the reason is:
The mod->mkobj.kobj(ffffffffa01600d0 below) is freed together with mod
itself by module_free(mod, mod->module_core) in free_module(). However,
its children still hold references to it, as the delay caused by
DEBUG_KOBJECT_RELEASE. So when the child('holders' below) tries to
decrease the reference count to its parent in kobject_del(), BUG happens
as it tries to access already freed memory.

v2: 
Greg suggested to make the kobject as a pointer. But it seems a little
hard to make kobj(kobject) embedded in mkobj(module_kobject) a pointer,
as that seems to cause getting the mkobj from the kobj impossible --
to_module_kobject() is used in several places to derive mkobj from its
member kobj. 

So in this version, I made the whole mkobj(module_kobject) as a pointer
in mod(module).

The mkobj is then allocated in mod_sysfs_init(), and freed in its member
kobj's release function -- it seems that there is no mkobj usage after
its kobj is released? 

[ 1844.175287] kobject: 'holders' (ffff88007c1f1600): kobject_release, parent ffffffffa01600d0 (delayed)
[ 1844.178991] kobject: 'notes' (ffff8800370b2a00): kobject_release, parent ffffffffa01600d0 (delayed)
[ 1845.180118] kobject: 'holders' (ffff88007c1f1600): kobject_cleanup, parent ffffffffa01600d0
[ 1845.182130] kobject: 'holders' (ffff88007c1f1600): auto cleanup kobject_del
[ 1845.184120] BUG: unable to handle kernel paging request at ffffffffa01601d0
[ 1845.185026] IP: [<ffffffff812cda81>] kobject_put+0x11/0x60
[ 1845.185026] PGD 1a13067 PUD 1a14063 PMD 7bd30067 PTE 0
[ 1845.185026] Oops: 0000 [#1] PREEMPT 
[ 1845.185026] Modules linked in: xfs libcrc32c [last unloaded: kprobe_example]
[ 1845.185026] CPU: 0 PID: 18 Comm: kworker/0:1 Tainted: G           O 3.11.0-rc6-next-20130819+ #1
[ 1845.185026] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[ 1845.185026] Workqueue: events kobject_delayed_cleanup
[ 1845.185026] task: ffff88007ca51f00 ti: ffff88007ca5c000 task.ti: ffff88007ca5c000
[ 1845.185026] RIP: 0010:[<ffffffff812cda81>]  [<ffffffff812cda81>] kobject_put+0x11/0x60
[ 1845.185026] RSP: 0018:ffff88007ca5dd08  EFLAGS: 00010282
[ 1845.185026] RAX: 0000000000002000 RBX: ffffffffa01600d0 RCX: ffffffff8177d638
[ 1845.185026] RDX: ffff88007ca5dc18 RSI: 0000000000000000 RDI: ffffffffa01600d0
[ 1845.185026] RBP: ffff88007ca5dd18 R08: ffffffff824e9810 R09: ffffffffffffffff
[ 1845.185026] R10: ffff8800ffffffff R11: dead4ead00000001 R12: ffffffff81a95040
[ 1845.185026] R13: ffff88007b27a960 R14: ffff88007c1f1600 R15: 0000000000000000
[ 1845.185026] FS:  0000000000000000(0000) GS:ffffffff81a23000(0000) knlGS:0000000000000000
[ 1845.185026] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1845.185026] CR2: ffffffffa01601d0 CR3: 0000000037207000 CR4: 00000000000006b0
[ 1845.185026] Stack:
[ 1845.185026]  ffff88007c1f1600 ffff88007c1f1600 ffff88007ca5dd38 ffffffff812cdb7e
[ 1845.185026]  0000000000000000 ffff88007c1f1640 ffff88007ca5dd68 ffffffff812cdbfe
[ 1845.185026]  ffff88007c974800 ffff88007c1f1640 ffff88007ff61a00 0000000000000000
[ 1845.185026] Call Trace:
[ 1845.185026]  [<ffffffff812cdb7e>] kobject_del+0x2e/0x40
[ 1845.185026]  [<ffffffff812cdbfe>] kobject_delayed_cleanup+0x6e/0x1d0
[ 1845.185026]  [<ffffffff81063a45>] process_one_work+0x1e5/0x670
[ 1845.185026]  [<ffffffff810639e3>] ? process_one_work+0x183/0x670
[ 1845.185026]  [<ffffffff810642b3>] worker_thread+0x113/0x370
[ 1845.185026]  [<ffffffff810641a0>] ? rescuer_thread+0x290/0x290
[ 1845.185026]  [<ffffffff8106bfba>] kthread+0xda/0xe0
[ 1845.185026]  [<ffffffff814ff0f0>] ? _raw_spin_unlock_irq+0x30/0x60
[ 1845.185026]  [<ffffffff8106bee0>] ? kthread_create_on_node+0x130/0x130
[ 1845.185026]  [<ffffffff8150751a>] ret_from_fork+0x7a/0xb0
[ 1845.185026]  [<ffffffff8106bee0>] ? kthread_create_on_node+0x130/0x130
[ 1845.185026] Code: 81 48 c7 c7 28 95 ad 81 31 c0 e8 9b da 01 00 e9 4f ff ff ff 66 0f 1f 44 00 00 55 48 89 e5 53 48 89 fb 48 83 ec 08 48 85 ff 74 1d <f6> 87 00 01 00 00 01 74 1e 48 8d 7b 38 83 6b 38 01 0f 94 c0 84 
[ 1845.185026] RIP  [<ffffffff812cda81>] kobject_put+0x11/0x60
[ 1845.185026]  RSP <ffff88007ca5dd08>
[ 1845.185026] CR2: ffffffffa01601d0
[ 1845.185026] ---[ end trace 49a70afd109f5653 ]---

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 drivers/base/core.c    |  2 +-
 drivers/base/module.c  |  4 ++--
 include/linux/module.h |  2 +-
 kernel/module.c        | 37 +++++++++++++++++++++----------------
 kernel/params.c        | 19 +++++++++++++------
 5 files changed, 38 insertions(+), 26 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 09a99d6..b8a1fc6 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1629,7 +1629,7 @@ struct device *__root_device_register(const char *name, struct module *owner)
 
 #ifdef CONFIG_MODULES	/* gotta find a "cleaner" way to do this */
 	if (owner) {
-		struct module_kobject *mk = &owner->mkobj;
+		struct module_kobject *mk = owner->mkobj;
 
 		err = sysfs_create_link(&root->dev.kobj, &mk->kobj, "module");
 		if (err) {
diff --git a/drivers/base/module.c b/drivers/base/module.c
index db930d3..7b7bd5a 100644
--- a/drivers/base/module.c
+++ b/drivers/base/module.c
@@ -40,7 +40,7 @@ void module_add_driver(struct module *mod, struct device_driver *drv)
 		return;
 
 	if (mod)
-		mk = &mod->mkobj;
+		mk = mod->mkobj;
 	else if (drv->mod_name) {
 		struct kobject *mkobj;
 
@@ -80,7 +80,7 @@ void module_remove_driver(struct device_driver *drv)
 	sysfs_remove_link(&drv->p->kobj, "module");
 
 	if (drv->owner)
-		mk = &drv->owner->mkobj;
+		mk = drv->owner->mkobj;
 	else if (drv->p->mkobj)
 		mk = drv->p->mkobj;
 	if (mk && mk->drivers_dir) {
diff --git a/include/linux/module.h b/include/linux/module.h
index 504035f..a499db6 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -236,7 +236,7 @@ struct module
 	char name[MODULE_NAME_LEN];
 
 	/* Sysfs stuff. */
-	struct module_kobject mkobj;
+	struct module_kobject *mkobj;
 	struct module_attribute *modinfo_attrs;
 	const char *version;
 	const char *srcversion;
diff --git a/kernel/module.c b/kernel/module.c
index 2069158..48060b4 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1402,7 +1402,7 @@ static void add_sect_attrs(struct module *mod, const struct load_info *info)
 	}
 	*gattr = NULL;
 
-	if (sysfs_create_group(&mod->mkobj.kobj, &sect_attrs->grp))
+	if (sysfs_create_group(&mod->mkobj->kobj, &sect_attrs->grp))
 		goto out;
 
 	mod->sect_attrs = sect_attrs;
@@ -1414,7 +1414,7 @@ static void add_sect_attrs(struct module *mod, const struct load_info *info)
 static void remove_sect_attrs(struct module *mod)
 {
 	if (mod->sect_attrs) {
-		sysfs_remove_group(&mod->mkobj.kobj,
+		sysfs_remove_group(&mod->mkobj->kobj,
 				   &mod->sect_attrs->grp);
 		/* We are positive that no one is using any sect attrs
 		 * at this point.  Deallocate immediately. */
@@ -1499,7 +1499,7 @@ static void add_notes_attrs(struct module *mod, const struct load_info *info)
 		++loaded;
 	}
 
-	notes_attrs->dir = kobject_create_and_add("notes", &mod->mkobj.kobj);
+	notes_attrs->dir = kobject_create_and_add("notes", &mod->mkobj->kobj);
 	if (!notes_attrs->dir)
 		goto out;
 
@@ -1551,7 +1551,7 @@ static void add_usage_links(struct module *mod)
 	mutex_lock(&module_mutex);
 	list_for_each_entry(use, &mod->target_list, target_list) {
 		nowarn = sysfs_create_link(use->target->holders_dir,
-					   &mod->mkobj.kobj, mod->name);
+					   &mod->mkobj->kobj, mod->name);
 	}
 	mutex_unlock(&module_mutex);
 #endif
@@ -1588,7 +1588,8 @@ static int module_add_modinfo_attrs(struct module *mod)
 		    (attr->test && attr->test(mod))) {
 			memcpy(temp_attr, attr, sizeof(*temp_attr));
 			sysfs_attr_init(&temp_attr->attr);
-			error = sysfs_create_file(&mod->mkobj.kobj,&temp_attr->attr);
+			error = sysfs_create_file(&mod->mkobj->kobj,
+						    &temp_attr->attr);
 			++temp_attr;
 		}
 	}
@@ -1604,7 +1605,7 @@ static void module_remove_modinfo_attrs(struct module *mod)
 		/* pick a field to test for end of list */
 		if (!attr->attr.name)
 			break;
-		sysfs_remove_file(&mod->mkobj.kobj,&attr->attr);
+		sysfs_remove_file(&mod->mkobj->kobj, &attr->attr);
 		if (attr->free)
 			attr->free(mod);
 	}
@@ -1630,15 +1631,19 @@ static int mod_sysfs_init(struct module *mod)
 		err = -EINVAL;
 		goto out;
 	}
+	mod->mkobj = kzalloc(sizeof(*mod->mkobj), GFP_KERNEL);
+	if (!mod->mkobj) {
+		err = -ENOMEM;
+		goto out;
+	}
 
-	mod->mkobj.mod = mod;
+	mod->mkobj->mod = mod;
 
-	memset(&mod->mkobj.kobj, 0, sizeof(mod->mkobj.kobj));
-	mod->mkobj.kobj.kset = module_kset;
-	err = kobject_init_and_add(&mod->mkobj.kobj, &module_ktype, NULL,
+	mod->mkobj->kobj.kset = module_kset;
+	err = kobject_init_and_add(&mod->mkobj->kobj, &module_ktype, NULL,
 				   "%s", mod->name);
 	if (err)
-		kobject_put(&mod->mkobj.kobj);
+		kobject_put(&mod->mkobj->kobj);
 
 	/* delay uevent until full sysfs population */
 out:
@@ -1656,7 +1661,7 @@ static int mod_sysfs_setup(struct module *mod,
 	if (err)
 		goto out;
 
-	mod->holders_dir = kobject_create_and_add("holders", &mod->mkobj.kobj);
+	mod->holders_dir = kobject_create_and_add("holders", &mod->mkobj->kobj);
 	if (!mod->holders_dir) {
 		err = -ENOMEM;
 		goto out_unreg;
@@ -1674,7 +1679,7 @@ static int mod_sysfs_setup(struct module *mod,
 	add_sect_attrs(mod, info);
 	add_notes_attrs(mod, info);
 
-	kobject_uevent(&mod->mkobj.kobj, KOBJ_ADD);
+	kobject_uevent(&mod->mkobj->kobj, KOBJ_ADD);
 	return 0;
 
 out_unreg_param:
@@ -1682,7 +1687,7 @@ out_unreg_param:
 out_unreg_holders:
 	kobject_put(mod->holders_dir);
 out_unreg:
-	kobject_put(&mod->mkobj.kobj);
+	kobject_put(&mod->mkobj->kobj);
 out:
 	return err;
 }
@@ -1691,7 +1696,7 @@ static void mod_sysfs_fini(struct module *mod)
 {
 	remove_notes_attrs(mod);
 	remove_sect_attrs(mod);
-	kobject_put(&mod->mkobj.kobj);
+	kobject_put(&mod->mkobj->kobj);
 }
 
 #else /* !CONFIG_SYSFS */
@@ -1723,7 +1728,7 @@ static void mod_sysfs_teardown(struct module *mod)
 	del_usage_links(mod);
 	module_remove_modinfo_attrs(mod);
 	module_param_sysfs_remove(mod);
-	kobject_put(mod->mkobj.drivers_dir);
+	kobject_put(mod->mkobj->drivers_dir);
 	kobject_put(mod->holders_dir);
 	mod_sysfs_fini(mod);
 }
diff --git a/kernel/params.c b/kernel/params.c
index 1f228a3..6bce9db 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -684,7 +684,7 @@ int module_param_sysfs_setup(struct module *mod,
 	for (i = 0; i < num_params; i++) {
 		if (kparam[i].perm == 0)
 			continue;
-		err = add_sysfs_param(&mod->mkobj, &kparam[i], kparam[i].name);
+		err = add_sysfs_param(mod->mkobj, &kparam[i], kparam[i].name);
 		if (err)
 			return err;
 		params = true;
@@ -694,9 +694,9 @@ int module_param_sysfs_setup(struct module *mod,
 		return 0;
 
 	/* Create the param group. */
-	err = sysfs_create_group(&mod->mkobj.kobj, &mod->mkobj.mp->grp);
+	err = sysfs_create_group(&mod->mkobj->kobj, &mod->mkobj->mp->grp);
 	if (err)
-		free_module_param_attrs(&mod->mkobj);
+		free_module_param_attrs(mod->mkobj);
 	return err;
 }
 
@@ -709,11 +709,11 @@ int module_param_sysfs_setup(struct module *mod,
  */
 void module_param_sysfs_remove(struct module *mod)
 {
-	if (mod->mkobj.mp) {
-		sysfs_remove_group(&mod->mkobj.kobj, &mod->mkobj.mp->grp);
+	if (mod->mkobj->mp) {
+		sysfs_remove_group(&mod->mkobj->kobj, &mod->mkobj->mp->grp);
 		/* We are positive that no one is using any param
 		 * attrs at this point.  Deallocate immediately. */
-		free_module_param_attrs(&mod->mkobj);
+		free_module_param_attrs(mod->mkobj);
 	}
 }
 #endif
@@ -912,7 +912,14 @@ static const struct kset_uevent_ops module_uevent_ops = {
 struct kset *module_kset;
 int module_sysfs_initialized;
 
+static void module_kobj_release(struct kobject *kobj)
+{
+	struct module_kobject *mk = to_module_kobject(kobj);
+	kfree(mk);
+}
+
 struct kobj_type module_ktype = {
+	.release   =	module_kobj_release,
 	.sysfs_ops =	&module_sysfs_ops,
 };
 


