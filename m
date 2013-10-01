Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab3JALKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 07:10:42 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:51513 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab3JALJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 07:09:17 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the driver-core tree
Date: Tue,  1 Oct 2013 13:07:20 +0200
Message-Id: <1380625644-11331-4-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <20131001110344.GA20249@ulmo.nvidia.com>
References: <20131001110344.GA20249@ulmo.nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's linux-next merge of the driver-core tree got conflicts in

	include/linux/netdevice.h

I fixed it up (see below). Please check if the resolution looks correct.

Thanks,
Thierry
---
diff --cc drivers/mtd/nand/atmel_nand.c
index ef9c9f5,bd1ce7d..2dbd913
--- a/drivers/mtd/nand/atmel_nand.c
+++ b/drivers/mtd/nand/atmel_nand.c
@@@ -1511,8 -1540,15 +1511,8 @@@ static int atmel_of_init_port(struct at
  
  	return 0;
  }
 -#else
 -static int atmel_of_init_port(struct atmel_nand_host *host,
 -			      struct device_node *np)
 -{
 -	return -EINVAL;
 -}
 -#endif
  
- static int __init atmel_hw_nand_init_params(struct platform_device *pdev,
+ static int atmel_hw_nand_init_params(struct platform_device *pdev,
  					 struct atmel_nand_host *host)
  {
  	struct mtd_info *mtd = &host->mtd;
diff --cc drivers/net/bonding/bond_sysfs.c
index e06c644,ec9b646..6f5f413
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@@ -165,9 -157,43 +157,8 @@@ static const struct class_attribute cla
  	},
  	.show = bonding_show_bonds,
  	.store = bonding_store_bonds,
- 	.namespace = bonding_namespace,
  };
  
 -int bond_create_slave_symlinks(struct net_device *master,
 -			       struct net_device *slave)
 -{
 -	char linkname[IFNAMSIZ+7];
 -	int ret = 0;
 -
 -	/* first, create a link from the slave back to the master */
 -	ret = sysfs_create_link(&(slave->dev.kobj), &(master->dev.kobj),
 -				"master");
 -	if (ret)
 -		return ret;
 -	/* next, create a link from the master to the slave */
 -	sprintf(linkname, "slave_%s", slave->name);
 -	ret = sysfs_create_link(&(master->dev.kobj), &(slave->dev.kobj),
 -				linkname);
 -
 -	/* free the master link created earlier in case of error */
 -	if (ret)
 -		sysfs_remove_link(&(slave->dev.kobj), "master");
 -
 -	return ret;
 -
 -}
 -
 -void bond_destroy_slave_symlinks(struct net_device *master,
 -				 struct net_device *slave)
 -{
 -	char linkname[IFNAMSIZ+7];
 -
 -	sysfs_remove_link(&(slave->dev.kobj), "master");
 -	sprintf(linkname, "slave_%s", slave->name);
 -	sysfs_remove_link(&(master->dev.kobj), linkname);
 -}
 -
 -
  /*
   * Show the slaves in the current bond.
   */
diff --cc include/linux/netdevice.h
index f5cd464,42421ed..51fdaf6
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@@ -2893,8 -2873,20 +2893,20 @@@ int __init dev_proc_init(void)
  #define dev_proc_init() 0
  #endif
  
- int netdev_class_create_file(struct class_attribute *class_attr);
- void netdev_class_remove_file(struct class_attribute *class_attr);
 -extern int netdev_class_create_file_ns(struct class_attribute *class_attr,
 -				       const void *ns);
 -extern void netdev_class_remove_file_ns(struct class_attribute *class_attr,
 -					const void *ns);
++int netdev_class_create_file_ns(struct class_attribute *class_attr,
++				const void *ns);
++void netdev_class_remove_file_ns(struct class_attribute *class_attr,
++				 const void *ns);
+ 
+ static inline int netdev_class_create_file(struct class_attribute *class_attr)
+ {
+ 	return netdev_class_create_file_ns(class_attr, NULL);
+ }
+ 
+ static inline void netdev_class_remove_file(struct class_attribute *class_attr)
+ {
+ 	netdev_class_remove_file_ns(class_attr, NULL);
+ }
  
  extern struct kobj_ns_type_operations net_ns_type_operations;
  
