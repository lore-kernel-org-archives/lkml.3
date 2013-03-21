Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933176Ab3CUMxC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 08:53:02 -0400
Received: from gate.crashing.org ([63.228.1.57]:49355 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933109Ab3CUMw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 08:52:59 -0400
Message-ID: <1363870366.3312.1.camel@pasglop>
Subject: Re: [PATCH V2 2/2] of: remove /proc/device-tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, davem@davemloft.net
Date: Thu, 21 Mar 2013 13:52:46 +0100
In-Reply-To: <1363865097-32764-3-git-send-email-grant.likely@secretlab.ca>
References: <1363865097-32764-1-git-send-email-grant.likely@secretlab.ca>
	 <1363865097-32764-3-git-send-email-grant.likely@secretlab.ca>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-21 at 11:24 +0000, Grant Likely wrote:
> The same data is now available in sysfs, so we can remove the code
> that exports it in /proc and replace it with a symlink to the sysfs
> version.
> 
> Tested on versatile qemu model and mpc5200 eval board. More testing
> would be appreciated.

This should be delayed until we are 100% confident that the sysfs
variant is totally backward compatible with anything that messes around
with /proc/device-tree.

kexec comes to mind (all 4 variants of fs2dt.c (yuck !)), dtc, various
powerpc-utils (bootloader configuration etc...), and more.

We also need to test the new code with hotplug, I'll see if I can get
somebody at IBM to give it a spin.

Cheers,
Ben.

> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: David S. Miller <davem@davemloft.net>
> ---
>  drivers/of/Kconfig      |    8 --
>  drivers/of/base.c       |   60 ------------
>  fs/proc/Makefile        |    1 -
>  fs/proc/proc_devtree.c  |  243 -----------------------------------------------
>  fs/proc/root.c          |    3 -
>  include/linux/of.h      |    1 -
>  include/linux/proc_fs.h |   16 ----
>  7 files changed, 332 deletions(-)
>  delete mode 100644 fs/proc/proc_devtree.c
> 
> diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
> index d2d7be9..edb97e2 100644
> --- a/drivers/of/Kconfig
> +++ b/drivers/of/Kconfig
> @@ -7,14 +7,6 @@ config OF
>  menu "Device Tree and Open Firmware support"
>  	depends on OF
>  
> -config PROC_DEVICETREE
> -	bool "Support for device tree in /proc"
> -	depends on PROC_FS && !SPARC
> -	help
> -	  This option adds a device-tree directory under /proc which contains
> -	  an image of the device tree that the kernel copies from Open
> -	  Firmware or other boot firmware. If unsure, say Y here.
> -
>  config OF_SELFTEST
>  	bool "Device Tree Runtime self tests"
>  	help
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index f1298cf..3c8c74a 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -177,11 +177,8 @@ static int __of_node_add(struct device_node *np)
>  	if (!np->parent) {
>  		/* Nodes without parents are new top level trees */
>  		rc = kobject_add(&np->kobj, NULL, "device-tree-%i", extra++);
> -#if !defined(CONFIG_PROC_DEVICETREE)
> -		/* Symlink to the new tree when PROC_DEVICETREE is disabled */
>  		if (!rc && extra == 1)
>  			proc_symlink("device-tree", NULL, "/sys/firmware/ofw/device-tree-0");
> -#endif /* CONFIG_PROC_DEVICETREE */
>  	} else {
>  		name = kbasename(np->full_name);
>  		if (!name || !name[0])
> @@ -1370,12 +1367,6 @@ int of_add_property(struct device_node *np, struct property *prop)
>  	*next = prop;
>  	raw_spin_unlock_irqrestore(&devtree_lock, flags);
>  
> -#ifdef CONFIG_PROC_DEVICETREE
> -	/* try to add to proc as well if it was initialized */
> -	if (np->pde)
> -		proc_device_tree_add_prop(np->pde, prop);
> -#endif /* CONFIG_PROC_DEVICETREE */
> -
>  	return 0;
>  }
>  
> @@ -1416,12 +1407,6 @@ int of_remove_property(struct device_node *np, struct property *prop)
>  	if (!found)
>  		return -ENODEV;
>  
> -#ifdef CONFIG_PROC_DEVICETREE
> -	/* try to remove the proc node as well */
> -	if (np->pde)
> -		proc_device_tree_remove_prop(np->pde, prop);
> -#endif /* CONFIG_PROC_DEVICETREE */
> -
>  	return 0;
>  }
>  
> @@ -1470,12 +1455,6 @@ int of_update_property(struct device_node *np, struct property *newprop)
>  	if (!found)
>  		return -ENODEV;
>  
> -#ifdef CONFIG_PROC_DEVICETREE
> -	/* try to add to proc as well if it was initialized */
> -	if (np->pde)
> -		proc_device_tree_update_prop(np->pde, newprop, oldprop);
> -#endif /* CONFIG_PROC_DEVICETREE */
> -
>  	return 0;
>  }
>  
> @@ -1510,22 +1489,6 @@ int of_reconfig_notify(unsigned long action, void *p)
>  	return notifier_to_errno(rc);
>  }
>  
> -#ifdef CONFIG_PROC_DEVICETREE
> -static void of_add_proc_dt_entry(struct device_node *dn)
> -{
> -	struct proc_dir_entry *ent;
> -
> -	ent = proc_mkdir(strrchr(dn->full_name, '/') + 1, dn->parent->pde);
> -	if (ent)
> -		proc_device_tree_add_node(dn, ent);
> -}
> -#else
> -static void of_add_proc_dt_entry(struct device_node *dn)
> -{
> -	return;
> -}
> -#endif
> -
>  /**
>   * of_attach_node - Plug a device node into the tree and global list.
>   */
> @@ -1546,31 +1509,9 @@ int of_attach_node(struct device_node *np)
>  	raw_spin_unlock_irqrestore(&devtree_lock, flags);
>  
>  	of_node_add(np);
> -	of_add_proc_dt_entry(np);
>  	return 0;
>  }
>  
> -#ifdef CONFIG_PROC_DEVICETREE
> -static void of_remove_proc_dt_entry(struct device_node *dn)
> -{
> -	struct device_node *parent = dn->parent;
> -	struct property *prop = dn->properties;
> -
> -	while (prop) {
> -		remove_proc_entry(prop->name, dn->pde);
> -		prop = prop->next;
> -	}
> -
> -	if (dn->pde)
> -		remove_proc_entry(dn->pde->name, parent->pde);
> -}
> -#else
> -static void of_remove_proc_dt_entry(struct device_node *dn)
> -{
> -	return;
> -}
> -#endif
> -
>  /**
>   * of_detach_node - "Unplug" a node from the device tree.
>   *
> @@ -1626,7 +1567,6 @@ int of_detach_node(struct device_node *np)
>  	of_node_set_flag(np, OF_DETACHED);
>  	raw_spin_unlock_irqrestore(&devtree_lock, flags);
>  
> -	of_remove_proc_dt_entry(np);
>  	of_node_remove(np);
>  	return rc;
>  }
> diff --git a/fs/proc/Makefile b/fs/proc/Makefile
> index 712f24d..81d413b 100644
> --- a/fs/proc/Makefile
> +++ b/fs/proc/Makefile
> @@ -27,6 +27,5 @@ proc-$(CONFIG_PROC_SYSCTL)	+= proc_sysctl.o
>  proc-$(CONFIG_NET)		+= proc_net.o
>  proc-$(CONFIG_PROC_KCORE)	+= kcore.o
>  proc-$(CONFIG_PROC_VMCORE)	+= vmcore.o
> -proc-$(CONFIG_PROC_DEVICETREE)	+= proc_devtree.o
>  proc-$(CONFIG_PRINTK)	+= kmsg.o
>  proc-$(CONFIG_PROC_PAGE_MONITOR)	+= page.o
> diff --git a/fs/proc/proc_devtree.c b/fs/proc/proc_devtree.c
> deleted file mode 100644
> index 30b590f..0000000
> --- a/fs/proc/proc_devtree.c
> +++ /dev/null
> @@ -1,243 +0,0 @@
> -/*
> - * proc_devtree.c - handles /proc/device-tree
> - *
> - * Copyright 1997 Paul Mackerras
> - */
> -#include <linux/errno.h>
> -#include <linux/init.h>
> -#include <linux/time.h>
> -#include <linux/proc_fs.h>
> -#include <linux/seq_file.h>
> -#include <linux/printk.h>
> -#include <linux/stat.h>
> -#include <linux/string.h>
> -#include <linux/of.h>
> -#include <linux/module.h>
> -#include <linux/slab.h>
> -#include <asm/prom.h>
> -#include <asm/uaccess.h>
> -#include "internal.h"
> -
> -static inline void set_node_proc_entry(struct device_node *np,
> -				       struct proc_dir_entry *de)
> -{
> -#ifdef HAVE_ARCH_DEVTREE_FIXUPS
> -	np->pde = de;
> -#endif
> -}
> -
> -static struct proc_dir_entry *proc_device_tree;
> -
> -/*
> - * Supply data on a read from /proc/device-tree/node/property.
> - */
> -static int property_proc_show(struct seq_file *m, void *v)
> -{
> -	struct property *pp = m->private;
> -
> -	seq_write(m, pp->value, pp->length);
> -	return 0;
> -}
> -
> -static int property_proc_open(struct inode *inode, struct file *file)
> -{
> -	return single_open(file, property_proc_show, PDE(inode)->data);
> -}
> -
> -static const struct file_operations property_proc_fops = {
> -	.owner		= THIS_MODULE,
> -	.open		= property_proc_open,
> -	.read		= seq_read,
> -	.llseek		= seq_lseek,
> -	.release	= single_release,
> -};
> -
> -/*
> - * For a node with a name like "gc@10", we make symlinks called "gc"
> - * and "@10" to it.
> - */
> -
> -/*
> - * Add a property to a node
> - */
> -static struct proc_dir_entry *
> -__proc_device_tree_add_prop(struct proc_dir_entry *de, struct property *pp,
> -		const char *name)
> -{
> -	struct proc_dir_entry *ent;
> -
> -	/*
> -	 * Unfortunately proc_register puts each new entry
> -	 * at the beginning of the list.  So we rearrange them.
> -	 */
> -	ent = proc_create_data(name,
> -			       strncmp(name, "security-", 9) ? S_IRUGO : S_IRUSR,
> -			       de, &property_proc_fops, pp);
> -	if (ent == NULL)
> -		return NULL;
> -
> -	if (!strncmp(name, "security-", 9))
> -		ent->size = 0; /* don't leak number of password chars */
> -	else
> -		ent->size = pp->length;
> -
> -	return ent;
> -}
> -
> -
> -void proc_device_tree_add_prop(struct proc_dir_entry *pde, struct property *prop)
> -{
> -	__proc_device_tree_add_prop(pde, prop, prop->name);
> -}
> -
> -void proc_device_tree_remove_prop(struct proc_dir_entry *pde,
> -				  struct property *prop)
> -{
> -	remove_proc_entry(prop->name, pde);
> -}
> -
> -void proc_device_tree_update_prop(struct proc_dir_entry *pde,
> -				  struct property *newprop,
> -				  struct property *oldprop)
> -{
> -	struct proc_dir_entry *ent;
> -
> -	if (!oldprop) {
> -		proc_device_tree_add_prop(pde, newprop);
> -		return;
> -	}
> -
> -	for (ent = pde->subdir; ent != NULL; ent = ent->next)
> -		if (ent->data == oldprop)
> -			break;
> -	if (ent == NULL) {
> -		pr_warn("device-tree: property \"%s\" does not exist\n",
> -			oldprop->name);
> -	} else {
> -		ent->data = newprop;
> -		ent->size = newprop->length;
> -	}
> -}
> -
> -/*
> - * Various dodgy firmware might give us nodes and/or properties with
> - * conflicting names. That's generally ok, except for exporting via /proc,
> - * so munge names here to ensure they're unique.
> - */
> -
> -static int duplicate_name(struct proc_dir_entry *de, const char *name)
> -{
> -	struct proc_dir_entry *ent;
> -	int found = 0;
> -
> -	spin_lock(&proc_subdir_lock);
> -
> -	for (ent = de->subdir; ent != NULL; ent = ent->next) {
> -		if (strcmp(ent->name, name) == 0) {
> -			found = 1;
> -			break;
> -		}
> -	}
> -
> -	spin_unlock(&proc_subdir_lock);
> -
> -	return found;
> -}
> -
> -static const char *fixup_name(struct device_node *np, struct proc_dir_entry *de,
> -		const char *name)
> -{
> -	char *fixed_name;
> -	int fixup_len = strlen(name) + 2 + 1; /* name + #x + \0 */
> -	int i = 1, size;
> -
> -realloc:
> -	fixed_name = kmalloc(fixup_len, GFP_KERNEL);
> -	if (fixed_name == NULL) {
> -		pr_err("device-tree: Out of memory trying to fixup "
> -		       "name \"%s\"\n", name);
> -		return name;
> -	}
> -
> -retry:
> -	size = snprintf(fixed_name, fixup_len, "%s#%d", name, i);
> -	size++; /* account for NULL */
> -
> -	if (size > fixup_len) {
> -		/* We ran out of space, free and reallocate. */
> -		kfree(fixed_name);
> -		fixup_len = size;
> -		goto realloc;
> -	}
> -
> -	if (duplicate_name(de, fixed_name)) {
> -		/* Multiple duplicates. Retry with a different offset. */
> -		i++;
> -		goto retry;
> -	}
> -
> -	pr_warn("device-tree: Duplicate name in %s, renamed to \"%s\"\n",
> -		np->full_name, fixed_name);
> -
> -	return fixed_name;
> -}
> -
> -/*
> - * Process a node, adding entries for its children and its properties.
> - */
> -void proc_device_tree_add_node(struct device_node *np,
> -			       struct proc_dir_entry *de)
> -{
> -	struct property *pp;
> -	struct proc_dir_entry *ent;
> -	struct device_node *child;
> -	const char *p;
> -
> -	set_node_proc_entry(np, de);
> -	for (child = NULL; (child = of_get_next_child(np, child));) {
> -		/* Use everything after the last slash, or the full name */
> -		p = kbasename(child->full_name);
> -
> -		if (duplicate_name(de, p))
> -			p = fixup_name(np, de, p);
> -
> -		ent = proc_mkdir(p, de);
> -		if (ent == NULL)
> -			break;
> -		proc_device_tree_add_node(child, ent);
> -	}
> -	of_node_put(child);
> -
> -	for (pp = np->properties; pp != NULL; pp = pp->next) {
> -		p = pp->name;
> -
> -		if (strchr(p, '/'))
> -			continue;
> -
> -		if (duplicate_name(de, p))
> -			p = fixup_name(np, de, p);
> -
> -		ent = __proc_device_tree_add_prop(de, pp, p);
> -		if (ent == NULL)
> -			break;
> -	}
> -}
> -
> -/*
> - * Called on initialization to set up the /proc/device-tree subtree
> - */
> -void __init proc_device_tree_init(void)
> -{
> -	struct device_node *root;
> -
> -	proc_device_tree = proc_mkdir("device-tree", NULL);
> -	if (proc_device_tree == NULL)
> -		return;
> -	root = of_find_node_by_path("/");
> -	if (root == NULL) {
> -		pr_debug("/proc/device-tree: can't find root\n");
> -		return;
> -	}
> -	proc_device_tree_add_node(root, proc_device_tree);
> -	of_node_put(root);
> -}
> diff --git a/fs/proc/root.c b/fs/proc/root.c
> index c6e9fac..04846a4 100644
> --- a/fs/proc/root.c
> +++ b/fs/proc/root.c
> @@ -173,9 +173,6 @@ void __init proc_root_init(void)
>  	proc_mkdir("openprom", NULL);
>  #endif
>  	proc_tty_init();
> -#ifdef CONFIG_PROC_DEVICETREE
> -	proc_device_tree_init();
> -#endif
>  	proc_mkdir("bus", NULL);
>  	proc_sys_init();
>  }
> diff --git a/include/linux/of.h b/include/linux/of.h
> index 0709a5e..b450161 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -57,7 +57,6 @@ struct device_node {
>  	struct	device_node *sibling;
>  	struct	device_node *next;	/* next device of same type */
>  	struct	device_node *allnext;	/* next in list of all nodes */
> -	struct	proc_dir_entry *pde;	/* this node's proc directory */
>  	struct	kobject kobj;
>  	unsigned long _flags;
>  	void	*data;
> diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
> index 8307f2f..90496b5 100644
> --- a/include/linux/proc_fs.h
> +++ b/include/linux/proc_fs.h
> @@ -136,22 +136,6 @@ static inline void proc_tty_init(void)
>  extern void proc_tty_register_driver(struct tty_driver *driver);
>  extern void proc_tty_unregister_driver(struct tty_driver *driver);
>  
> -/*
> - * proc_devtree.c
> - */
> -#ifdef CONFIG_PROC_DEVICETREE
> -struct device_node;
> -struct property;
> -extern void proc_device_tree_init(void);
> -extern void proc_device_tree_add_node(struct device_node *, struct proc_dir_entry *);
> -extern void proc_device_tree_add_prop(struct proc_dir_entry *pde, struct property *prop);
> -extern void proc_device_tree_remove_prop(struct proc_dir_entry *pde,
> -					 struct property *prop);
> -extern void proc_device_tree_update_prop(struct proc_dir_entry *pde,
> -					 struct property *newprop,
> -					 struct property *oldprop);
> -#endif /* CONFIG_PROC_DEVICETREE */
> -
>  extern struct proc_dir_entry *proc_symlink(const char *,
>  		struct proc_dir_entry *, const char *);
>  extern struct proc_dir_entry *proc_mkdir(const char *,struct proc_dir_entry *);


