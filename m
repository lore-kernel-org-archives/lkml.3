Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300Ab3CTO5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 10:57:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:44995 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022Ab3CTO5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 10:57:37 -0400
Message-ID: <1363791432.12701.8.camel@pasglop>
Subject: Re: [PATCH 1/2] of: Make device nodes kobjects so they show up in
 sysfs
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>
Date: Wed, 20 Mar 2013 15:57:12 +0100
In-Reply-To: <1363791074-16415-2-git-send-email-grant.likely@secretlab.ca>
References: <1363791074-16415-1-git-send-email-grant.likely@secretlab.ca>
	 <1363791074-16415-2-git-send-email-grant.likely@secretlab.ca>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-20 at 14:51 +0000, Grant Likely wrote:
> Device tree nodes are already treated as objects, and we already want to
> expose them to userspace which is done using the /proc filesystem today.
> Right now the kernel has to do a lot of work to keep the /proc view in
> sync with the in-kernel representation. If device_nodes are switched to
> be kobjects then the device tree code can be a whole lot simpler. It
> also turns out that switching to using /sysfs from /proc results in
> smaller code and data size, and the userspace ABI won't change if
> /proc/device-tree symlinks to /sys/device-tree
> 
> Switching to sysfs does introduce two limitations however. First, normal
> sysfs attributes have a maximum size of PAGE_SIZE. Any properties larger
> than 4k will still show up in sysfs, but attempting to read them will
> result in truncated data. Practically speaking this should not be an
> issue assuming large binary blobs aren't encoded into the device tree.

Unfortunately they occasionally are... VPDs can be pretty big for
example.

> Second, all normal sysfs attributes report their size as 4096 bytes
> instead of the actual property size reported in /proc/device-tree. It is
> possible that this change will cause some userspace tools to break.

This is btw a complete idiocy of sysfs and should/could be fixed.

> Both of the above problems can be worked around by using
> sysfs_create_bin_file() instead of sysfs_create_file(), but doing so
> adds an additional 20 to 40 bytes of overhead per property. A device
> tree has a lot of properties in it. That overhead will very quickly add
> up. The other option is to create a new custom sysfs attribute type
> would solve the problem without additional overhead, but at the cost of
> more complexity in the sysfs support code. However, I'm hopeful that
> these problems are just imaginary and we can stick with normal sysfs
> attributes.

Disagreed. It would break stuff, especially the incorrect file size.

Cheers,
Ben.

> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: David S. Miller <davem@davemloft.net>
> ---
>  Documentation/ABI/testing/sysfs-firmware-ofw |   28 ++++++
>  drivers/of/Kconfig                           |    2 +-
>  drivers/of/base.c                            |  121 ++++++++++++++++++++++++--
>  drivers/of/fdt.c                             |    3 +-
>  drivers/of/pdt.c                             |    4 +-
>  include/linux/of.h                           |    9 +-
>  6 files changed, 154 insertions(+), 13 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-firmware-ofw
> 
> diff --git a/Documentation/ABI/testing/sysfs-firmware-ofw b/Documentation/ABI/testing/sysfs-firmware-ofw
> new file mode 100644
> index 0000000..5ef9a77
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-firmware-ofw
> @@ -0,0 +1,28 @@
> +What:		/sys/firmware/ofw/../device-tree/
> +Date:		March 2013
> +Contact:	Grant Likely <grant.likely@secretlab.ca>
> +Description:
> +		When using OpenFirmware or a Flattened Device Tree to enumerate
> +		hardware, the device tree structure will be exposed in this
> +		directory.
> +
> +		It is possible for multiple device-tree directories to exist.
> +		Some device drivers use a separate detached device tree which
> +		have no attachment to the system tree and will appear in a
> +		different subdirectory under /sys/firmware/ofw.
> +
> +		Userspace must not use the /sys/firmware/ofw/../device-tree
> +		path directly, but instead should follow /proc/device-tree
> +		symlink. It is possible that the absolute path will change
> +		in the future, but the symlink is the stable ABI.
> +
> +		The /proc/device-tree symlink replaces the devicetree /proc
> +		filesystem support, and has largely the same semantics and
> +		should be compatible with existing userspace.
> +
> +		The contents of /sys/firmware/ofw/../device-tree is a
> +		hierarchy of directories, one per device tree node. The
> +		directory name is the resolved path component name (node
> +		name plus address). Properties are represented as files
> +		in the directory. The contents of each file is the exact
> +		binary data from the device tree.
> diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
> index d37bfcf..d2d7be9 100644
> --- a/drivers/of/Kconfig
> +++ b/drivers/of/Kconfig
> @@ -38,7 +38,7 @@ config OF_PROMTREE
>  # Hardly any platforms need this.  It is safe to select, but only do so if you
>  # need it.
>  config OF_DYNAMIC
> -	bool
> +	def_bool y
>  
>  config OF_ADDRESS
>  	def_bool y
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index 321d3ef..363e98b 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -22,6 +22,7 @@
>  #include <linux/of.h>
>  #include <linux/spinlock.h>
>  #include <linux/slab.h>
> +#include <linux/string.h>
>  #include <linux/proc_fs.h>
>  
>  #include "of_private.h"
> @@ -33,6 +34,12 @@ EXPORT_SYMBOL(of_allnodes);
>  struct device_node *of_chosen;
>  struct device_node *of_aliases;
>  
> +static struct kset *of_kset;
> +
> +/*
> + * Used to protect the of_aliases; but also overloaded to hold off addition of
> + * nodes to sysfs
> + */
>  DEFINE_MUTEX(of_aliases_mutex);
>  
>  /* use when traversing tree through the allnext, child, sibling,
> @@ -83,14 +90,14 @@ EXPORT_SYMBOL(of_n_size_cells);
>  struct device_node *of_node_get(struct device_node *node)
>  {
>  	if (node)
> -		kref_get(&node->kref);
> +		kobject_get(&node->kobj);
>  	return node;
>  }
>  EXPORT_SYMBOL(of_node_get);
>  
> -static inline struct device_node *kref_to_device_node(struct kref *kref)
> +static inline struct device_node *kobj_to_device_node(struct kobject *kobj)
>  {
> -	return container_of(kref, struct device_node, kref);
> +	return container_of(kobj, struct device_node, kobj);
>  }
>  
>  /**
> @@ -100,16 +107,15 @@ static inline struct device_node *kref_to_device_node(struct kref *kref)
>   *	In of_node_put() this function is passed to kref_put()
>   *	as the destructor.
>   */
> -static void of_node_release(struct kref *kref)
> +static void of_node_release(struct kobject *kobj)
>  {
> -	struct device_node *node = kref_to_device_node(kref);
> +	struct device_node *node = kobj_to_device_node(kobj);
>  	struct property *prop = node->properties;
>  
>  	/* We should never be releasing nodes that haven't been detached. */
>  	if (!of_node_check_flag(node, OF_DETACHED)) {
>  		pr_err("ERROR: Bad of_node_put() on %s\n", node->full_name);
>  		dump_stack();
> -		kref_init(&node->kref);
>  		return;
>  	}
>  
> @@ -142,11 +148,110 @@ static void of_node_release(struct kref *kref)
>  void of_node_put(struct device_node *node)
>  {
>  	if (node)
> -		kref_put(&node->kref, of_node_release);
> +		kobject_put(&node->kobj);
>  }
>  EXPORT_SYMBOL(of_node_put);
>  #endif /* CONFIG_OF_DYNAMIC */
>  
> +ssize_t of_node_sysfs_show(struct kobject *kobj, struct attribute *attr, char *buf)
> +{
> +	struct property *prop = container_of(attr, struct property, attr);
> +	int length = prop->length;
> +
> +	if (length >= PAGE_SIZE)
> +		length = PAGE_SIZE-1;
> +	memcpy(buf, prop->value, length);
> +	return length;
> +}
> +
> +struct sysfs_ops of_node_sysfs_ops = {
> +	.show = of_node_sysfs_show,
> +};
> +
> +struct kobj_type of_node_ktype = {
> +	.release = of_node_release,
> +	.sysfs_ops = &of_node_sysfs_ops,
> +};
> +
> +static bool of_init_complete = false;
> +static int __of_node_add(struct device_node *np)
> +{
> +	const char *name;
> +	struct property *pp;
> +	static int extra = 0;
> +	int rc;
> +
> +	np->kobj.kset = of_kset;
> +	if (!np->parent) {
> +		/* Nodes without parents are new top level trees */
> +		rc = kobject_add(&np->kobj, NULL, "device-tree-%i", extra++);
> +	} else {
> +		name = kbasename(np->full_name);
> +		if (!name || !name[0])
> +			return -EINVAL;
> +		rc = kobject_add(&np->kobj, &np->parent->kobj, "%s", name);
> +	}
> +	if (rc)
> +		return rc;
> +
> +	for_each_property_of_node(np, pp) {
> +		/*
> +		 * Don't leak password data. Note: if this is ever switched to use
> +		 * sysfs_create_bin_file(), then it is very important to not expose
> +		 * the size of the password in the inode. If 'secure' is set, then
> +		 * the inode length must be reported as '0'
> +		 */
> +		bool secure = strncmp(pp->name, "security-", 9) == 0;
> +		pp->attr.name = pp->name;
> +		pp->attr.mode =  secure ? S_IRUSR : S_IRUGO;
> +		rc = sysfs_create_file(&np->kobj, &pp->attr);
> +		WARN(rc, "error creating device node attribute\n");
> +	}
> +
> +	return 0;
> +}
> +
> +int of_node_add(struct device_node *np)
> +{
> +	int rc = 0;
> +	kobject_init(&np->kobj, &of_node_ktype);
> +	mutex_lock(&of_aliases_mutex);
> +	if (of_init_complete)
> +		rc = __of_node_add(np);
> +	mutex_unlock(&of_aliases_mutex);
> +	return rc;
> +}
> +
> +#if defined(CONFIG_OF_DYNAMIC)
> +static void of_node_remove(struct device_node *np)
> +{
> +	struct property *pp;
> +
> +	for_each_property_of_node(np, pp)
> +		sysfs_remove_file(&np->kobj, &pp->attr);
> +
> +	kobject_del(&np->kobj);
> +}
> +#endif
> +
> +static int __init of_init(void)
> +{
> +	struct device_node *np;
> +
> +	of_kset = kset_create_and_add("ofw", NULL, firmware_kobj);
> +	if (!of_kset)
> +		return -ENOMEM;
> +
> +	/* Make sure all nodes added before this time get added to sysfs */
> +	mutex_lock(&of_aliases_mutex);
> +	for_each_of_allnodes(np)
> +		__of_node_add(np);
> +	of_init_complete = true;
> +	mutex_unlock(&of_aliases_mutex);
> +	return 0;
> +}
> +core_initcall(of_init);
> +
>  static struct property *__of_find_property(const struct device_node *np,
>  					   const char *name, int *lenp)
>  {
> @@ -1445,6 +1550,7 @@ int of_attach_node(struct device_node *np)
>  	of_allnodes = np;
>  	raw_spin_unlock_irqrestore(&devtree_lock, flags);
>  
> +	of_node_add(np);
>  	of_add_proc_dt_entry(np);
>  	return 0;
>  }
> @@ -1526,6 +1632,7 @@ int of_detach_node(struct device_node *np)
>  	raw_spin_unlock_irqrestore(&devtree_lock, flags);
>  
>  	of_remove_proc_dt_entry(np);
> +	of_node_remove(np);
>  	return rc;
>  }
>  #endif /* defined(CONFIG_OF_DYNAMIC) */
> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
> index 808be06..8807059 100644
> --- a/drivers/of/fdt.c
> +++ b/drivers/of/fdt.c
> @@ -232,7 +232,6 @@ static unsigned long unflatten_dt_node(struct boot_param_header *blob,
>  				dad->next->sibling = np;
>  			dad->next = np;
>  		}
> -		kref_init(&np->kref);
>  	}
>  	/* process properties */
>  	while (1) {
> @@ -327,6 +326,8 @@ static unsigned long unflatten_dt_node(struct boot_param_header *blob,
>  			np->name = "<NULL>";
>  		if (!np->type)
>  			np->type = "<NULL>";
> +
> +		of_node_add(np);
>  	}
>  	while (tag == OF_DT_BEGIN_NODE || tag == OF_DT_NOP) {
>  		if (tag == OF_DT_NOP)
> diff --git a/drivers/of/pdt.c b/drivers/of/pdt.c
> index 37b56fd..2d9d7e1 100644
> --- a/drivers/of/pdt.c
> +++ b/drivers/of/pdt.c
> @@ -180,8 +180,6 @@ static struct device_node * __init of_pdt_create_node(phandle node,
>  	of_pdt_incr_unique_id(dp);
>  	dp->parent = parent;
>  
> -	kref_init(&dp->kref);
> -
>  	dp->name = of_pdt_get_one_property(node, "name");
>  	dp->type = of_pdt_get_one_property(node, "device_type");
>  	dp->phandle = node;
> @@ -216,6 +214,7 @@ static struct device_node * __init of_pdt_build_tree(struct device_node *parent,
>  		*nextp = &dp->allnext;
>  
>  		dp->full_name = of_pdt_build_full_name(dp);
> +		of_node_add(dp);
>  
>  		dp->child = of_pdt_build_tree(dp,
>  				of_pdt_prom_ops->getchild(node), nextp);
> @@ -246,6 +245,7 @@ void __init of_pdt_build_devicetree(phandle root_node, struct of_pdt_ops *ops)
>  	of_allnodes->path_component_name = "";
>  #endif
>  	of_allnodes->full_name = "/";
> +	of_node_add(of_allnodes);
>  
>  	nextp = &of_allnodes->allnext;
>  	of_allnodes->child = of_pdt_build_tree(of_allnodes,
> diff --git a/include/linux/of.h b/include/linux/of.h
> index a0f1292..2399c8f 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -18,7 +18,7 @@
>  #include <linux/types.h>
>  #include <linux/bitops.h>
>  #include <linux/errno.h>
> -#include <linux/kref.h>
> +#include <linux/kobject.h>
>  #include <linux/mod_devicetable.h>
>  #include <linux/spinlock.h>
>  #include <linux/topology.h>
> @@ -37,6 +37,7 @@ struct property {
>  	struct property *next;
>  	unsigned long _flags;
>  	unsigned int unique_id;
> +	struct attribute attr;
>  };
>  
>  #if defined(CONFIG_SPARC)
> @@ -57,7 +58,7 @@ struct device_node {
>  	struct	device_node *next;	/* next device of same type */
>  	struct	device_node *allnext;	/* next in list of all nodes */
>  	struct	proc_dir_entry *pde;	/* this node's proc directory */
> -	struct	kref kref;
> +	struct	kobject kobj;
>  	unsigned long _flags;
>  	void	*data;
>  #if defined(CONFIG_SPARC)
> @@ -74,6 +75,8 @@ struct of_phandle_args {
>  	uint32_t args[MAX_PHANDLE_ARGS];
>  };
>  
> +extern int of_node_add(struct device_node *node);
> +
>  #ifdef CONFIG_OF_DYNAMIC
>  extern struct device_node *of_node_get(struct device_node *node);
>  extern void of_node_put(struct device_node *node);
> @@ -165,6 +168,8 @@ static inline const char *of_node_full_name(const struct device_node *np)
>  	return np ? np->full_name : "<no-node>";
>  }
>  
> +#define for_each_of_allnodes(dn) \
> +	for (dn = of_allnodes; dn; dn = dn->allnext)
>  extern struct device_node *of_find_node_by_name(struct device_node *from,
>  	const char *name);
>  #define for_each_node_by_name(dn, name) \


