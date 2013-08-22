Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab3HVCeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 22:34:20 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:37183 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab3HVCeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 22:34:18 -0400
Message-ID: <1377138846.2633.25.camel@ThinkPad-T5421>
Subject: Re: [RFC PATCH next]module: Fix mod->mkobj.kobj potentially freed
 too early
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-next list <linux-next@vger.kernel.org>, rusty@rustcorp.com.au,
        LKML <linux-kernel@vger.kernel.org>, rmk+kernel@arm.linux.org.uk
Date: Thu, 22 Aug 2013 10:34:06 +0800
In-Reply-To: <20130821161819.GA14364@kroah.com>
References: <1377078598.2709.25.camel@ThinkPad-T5421>
	 <20130821161819.GA14364@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082202-1618-0000-0000-0000047E8AD8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-21 at 09:18 -0700, Greg KH wrote:
> On Wed, Aug 21, 2013 at 05:49:58PM +0800, Li Zhong wrote:
> > DEBUG_KOBJECT_RELEASE helps to find the issue attached below.
> > 
> > After some investigation, it seems the reason is:
> > The mod->mkobj.kobj(ffffffffa01600d0 below) is freed together with mod
> > itself in free_module(). However, its children still hold references to
> > it, as the delay caused by DEBUG_KOBJECT_RELEASE. So when the
> > child(holders below) tries to decrease the reference count to its parent
> > in kobject_del(), BUG happens as it tries to access already freed memory.
> 
> Ah, thanks for tracking this down.  I had seen this in my local testing,
> but wasn't able to figure out the offending code.
> 
> > This patch tries to fix it by waiting for the mod->mkobj.kobj to be
> > really released in the module removing process (and some error code
> > paths).
> 
> Nasty, we should just be freeing the structure in the release function,
> why doesn't that work?

Hi Greg,

It seems I didn't describe it clearly in the previous mail. I'm trying
to do it better below: 

mod->mkobj.kobj is embedded in module_kobject(not a pointer):
struct module_kobject {
        struct kobject kobj;
	...

and allocated with the module memory. So we could see the parent below
ffffffffa01600d0 is between MODULES_VADDR (ffffffffa0000000) and
MODULES_END(ffffffffff000000). 

It seem to me that the mkobj.kobj is freed by module_free(mod,
mod->module_core). 

So in free_module(), we need delay the call of module_free(), until
mkobj.kobj finishes its cleanup. 

> > [ 1844.175287] kobject: 'holders' (ffff88007c1f1600): kobject_release, parent ffffffffa01600d0 (delayed)
> > [ 1844.178991] kobject: 'notes' (ffff8800370b2a00): kobject_release, parent ffffffffa01600d0 (delayed)
> > [ 1845.180118] kobject: 'holders' (ffff88007c1f1600): kobject_cleanup, parent ffffffffa01600d0
> > [ 1845.182130] kobject: 'holders' (ffff88007c1f1600): auto cleanup kobject_del
> > [ 1845.184120] BUG: unable to handle kernel paging request at ffffffffa01601d0
> > [ 1845.185026] IP: [<ffffffff812cda81>] kobject_put+0x11/0x60
> > [ 1845.185026] PGD 1a13067 PUD 1a14063 PMD 7bd30067 PTE 0
> > [ 1845.185026] Oops: 0000 [#1] PREEMPT 
> > [ 1845.185026] Modules linked in: xfs libcrc32c [last unloaded: kprobe_example]
> > [ 1845.185026] CPU: 0 PID: 18 Comm: kworker/0:1 Tainted: G           O 3.11.0-rc6-next-20130819+ #1
> > [ 1845.185026] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
> > [ 1845.185026] Workqueue: events kobject_delayed_cleanup
> > [ 1845.185026] task: ffff88007ca51f00 ti: ffff88007ca5c000 task.ti: ffff88007ca5c000
> > [ 1845.185026] RIP: 0010:[<ffffffff812cda81>]  [<ffffffff812cda81>] kobject_put+0x11/0x60
> > [ 1845.185026] RSP: 0018:ffff88007ca5dd08  EFLAGS: 00010282
> > [ 1845.185026] RAX: 0000000000002000 RBX: ffffffffa01600d0 RCX: ffffffff8177d638
> > [ 1845.185026] RDX: ffff88007ca5dc18 RSI: 0000000000000000 RDI: ffffffffa01600d0
> > [ 1845.185026] RBP: ffff88007ca5dd18 R08: ffffffff824e9810 R09: ffffffffffffffff
> > [ 1845.185026] R10: ffff8800ffffffff R11: dead4ead00000001 R12: ffffffff81a95040
> > [ 1845.185026] R13: ffff88007b27a960 R14: ffff88007c1f1600 R15: 0000000000000000
> > [ 1845.185026] FS:  0000000000000000(0000) GS:ffffffff81a23000(0000) knlGS:0000000000000000
> > [ 1845.185026] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > [ 1845.185026] CR2: ffffffffa01601d0 CR3: 0000000037207000 CR4: 00000000000006b0
> > [ 1845.185026] Stack:
> > [ 1845.185026]  ffff88007c1f1600 ffff88007c1f1600 ffff88007ca5dd38 ffffffff812cdb7e
> > [ 1845.185026]  0000000000000000 ffff88007c1f1640 ffff88007ca5dd68 ffffffff812cdbfe
> > [ 1845.185026]  ffff88007c974800 ffff88007c1f1640 ffff88007ff61a00 0000000000000000
> > [ 1845.185026] Call Trace:
> > [ 1845.185026]  [<ffffffff812cdb7e>] kobject_del+0x2e/0x40
> > [ 1845.185026]  [<ffffffff812cdbfe>] kobject_delayed_cleanup+0x6e/0x1d0
> > [ 1845.185026]  [<ffffffff81063a45>] process_one_work+0x1e5/0x670
> > [ 1845.185026]  [<ffffffff810639e3>] ? process_one_work+0x183/0x670
> > [ 1845.185026]  [<ffffffff810642b3>] worker_thread+0x113/0x370
> > [ 1845.185026]  [<ffffffff810641a0>] ? rescuer_thread+0x290/0x290
> > [ 1845.185026]  [<ffffffff8106bfba>] kthread+0xda/0xe0
> > [ 1845.185026]  [<ffffffff814ff0f0>] ? _raw_spin_unlock_irq+0x30/0x60
> > [ 1845.185026]  [<ffffffff8106bee0>] ? kthread_create_on_node+0x130/0x130
> > [ 1845.185026]  [<ffffffff8150751a>] ret_from_fork+0x7a/0xb0
> > [ 1845.185026]  [<ffffffff8106bee0>] ? kthread_create_on_node+0x130/0x130
> > [ 1845.185026] Code: 81 48 c7 c7 28 95 ad 81 31 c0 e8 9b da 01 00 e9 4f ff ff ff 66 0f 1f 44 00 00 55 48 89 e5 53 48 89 fb 48 83 ec 08 48 85 ff 74 1d <f6> 87 00 01 00 00 01 74 1e 48 8d 7b 38 83 6b 38 01 0f 94 c0 84 
> > [ 1845.185026] RIP  [<ffffffff812cda81>] kobject_put+0x11/0x60
> > [ 1845.185026]  RSP <ffff88007ca5dd08>
> > [ 1845.185026] CR2: ffffffffa01601d0
> > [ 1845.185026] ---[ end trace 49a70afd109f5653 ]---
> > 
> > Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
> > ---
> >  include/linux/module.h |  1 +
> >  kernel/module.c        | 14 +++++++++++---
> >  kernel/params.c        |  7 +++++++
> >  3 files changed, 19 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/linux/module.h b/include/linux/module.h
> > index 504035f..05f2447 100644
> > --- a/include/linux/module.h
> > +++ b/include/linux/module.h
> > @@ -42,6 +42,7 @@ struct module_kobject {
> >  	struct module *mod;
> >  	struct kobject *drivers_dir;
> >  	struct module_param_attrs *mp;
> > +	struct completion *kobj_completion;
> >  };
> >  
> >  struct module_attribute {
> > diff --git a/kernel/module.c b/kernel/module.c
> > index 2069158..b5e2baa 100644
> > --- a/kernel/module.c
> > +++ b/kernel/module.c
> > @@ -1611,6 +1611,14 @@ static void module_remove_modinfo_attrs(struct module *mod)
> >  	kfree(mod->modinfo_attrs);
> >  }
> >  
> > +static void mod_kobject_put(struct module *mod)
> > +{
> > +	DECLARE_COMPLETION_ONSTACK(c);
> > +	mod->mkobj.kobj_completion = &c;
> > +	kobject_put(&mod->mkobj.kobj);
> > +	wait_for_completion(&c);
> > +}
> > +
> >  static int mod_sysfs_init(struct module *mod)
> >  {
> >  	int err;
> > @@ -1638,7 +1646,7 @@ static int mod_sysfs_init(struct module *mod)
> >  	err = kobject_init_and_add(&mod->mkobj.kobj, &module_ktype, NULL,
> >  				   "%s", mod->name);
> >  	if (err)
> > -		kobject_put(&mod->mkobj.kobj);
> > +		mod_kobject_put(mod);
> >  
> >  	/* delay uevent until full sysfs population */
> >  out:
> > @@ -1682,7 +1690,7 @@ out_unreg_param:
> >  out_unreg_holders:
> >  	kobject_put(mod->holders_dir);
> >  out_unreg:
> > -	kobject_put(&mod->mkobj.kobj);
> > +	mod_kobject_put(mod);
> >  out:
> >  	return err;
> >  }
> > @@ -1691,7 +1699,7 @@ static void mod_sysfs_fini(struct module *mod)
> >  {
> >  	remove_notes_attrs(mod);
> >  	remove_sect_attrs(mod);
> > -	kobject_put(&mod->mkobj.kobj);
> > +	mod_kobject_put(mod);
> >  }
> >  
> >  #else /* !CONFIG_SYSFS */
> > diff --git a/kernel/params.c b/kernel/params.c
> > index 1f228a3..b8cab65 100644
> > --- a/kernel/params.c
> > +++ b/kernel/params.c
> > @@ -912,7 +912,14 @@ static const struct kset_uevent_ops module_uevent_ops = {
> >  struct kset *module_kset;
> >  int module_sysfs_initialized;
> >  
> > +static void module_kobj_release(struct kobject *kobj)
> > +{
> > +	struct module_kobject *mk = to_module_kobject(kobj);
> > +	complete(mk->kobj_completion);
> > +}
> > +
> >  struct kobj_type module_ktype = {
> > +	.release   =	module_kobj_release,
> >  	.sysfs_ops =	&module_sysfs_ops,
> >  };
> >  
> > 
> 
> 
> Wait, as there is no release function here for the kobject (a different
> problem), why is the deferred release function causing any problems?
> There is no release function to call, so what is causing the oops?
> 
I think that's because, kobject_cleanup() is delayed, 
which needs access to the contents in the kobj, and also needs to
kobject_put() its parent's reference counter (in kobject_del()). 

But mkobj.kobj is already freed by module_free(mod, mod->module_core).

So its children have problem calling kobject_put(kobj->parent), and
itself has problem calling kobject_cleanup().

Thanks, Zhong

> confused,
> 
> greg k-h
> 


