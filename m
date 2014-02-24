Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133AbaBXWAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 17:00:45 -0500
Received: from smtprelay0013.hostedemail.com ([216.40.44.13]:43892 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753051AbaBXWAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 17:00:40 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:69:355:379:541:960:966:968:973:988:989:1042:1260:1345:1359:1437:1605:1730:1747:1777:1792:2196:2198:2199:2200:2393:2538:2559:2562:2693:2892:2894:2898:2899:2901:2910:2924:2926:3138:3139:3140:3141:3142:3865:3866:3867:3868:3870:3871:3872:3873:4250:4321:4385:4605:5007:6261:7558:7875:7903:7904:8603:9010:9121:9592:10004:10026:10226:10848:11026:11233:11914:12043:12296:12438:12517:12519:12555:12679:12683:13142:13230:13972:14110,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: plate16_2263e46f7e95c
X-Filterd-Recvd-Size: 57626
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>,
        James Morris <james.l.morris@oracle.com>, selinux@tycho.nsa.gov,
        linux-security-module@vger.kernel.org
Subject: [PATCH 5/8] security: selinux: Use a more current logging style
Date: Mon, 24 Feb 2014 13:59:58 -0800
Message-Id: <637b2f31e31f2b0d7a67131f1db125cc0b2bb829.1393279025.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1393279025.git.joe@perches.com>
References: <cover.1393279025.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert printk to pr_<level>.
Add pr_fmt.
Coalesce formats, add missing space where appropriate.
Standardize on one space after "SELinux: " prefix.

Signed-off-by: Joe Perches <joe@perches.com>
---
 security/selinux/avc.c            |   7 +-
 security/selinux/hooks.c          | 130 ++++++++++++++++----------------------
 security/selinux/netif.c          |  14 ++--
 security/selinux/netlink.c        |   5 +-
 security/selinux/netnode.c        |   6 +-
 security/selinux/netport.c        |   7 +-
 security/selinux/selinuxfs.c      |  19 +++---
 security/selinux/ss/avtab.c       |  39 ++++++------
 security/selinux/ss/conditional.c |  18 +++---
 security/selinux/ss/ebitmap.c     |  21 +++---
 security/selinux/ss/policydb.c    | 109 ++++++++++++++------------------
 security/selinux/ss/services.c    | 101 ++++++++++++-----------------
 security/selinux/ss/sidtab.c      |   8 ++-
 13 files changed, 220 insertions(+), 264 deletions(-)

diff --git a/security/selinux/avc.c b/security/selinux/avc.c
index fc3e662..f9bb683 100644
--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -13,6 +13,9 @@
  *	it under the terms of the GNU General Public License version 2,
  *	as published by the Free Software Foundation.
  */
+
+#define pr_fmt(fmt) "SELinux: " KBUILD_MODNAME ": " fmt
+
 #include <linux/types.h>
 #include <linux/stddef.h>
 #include <linux/kernel.h>
@@ -348,8 +351,8 @@ static int avc_latest_notif_update(int seqno, int is_insert)
 	spin_lock_irqsave(&notif_lock, flag);
 	if (is_insert) {
 		if (seqno < avc_cache.latest_notif) {
-			printk(KERN_WARNING "SELinux: avc:  seqno %d < latest_notif %d\n",
-			       seqno, avc_cache.latest_notif);
+			pr_warn("seqno %d < latest_notif %d\n",
+				seqno, avc_cache.latest_notif);
 			ret = -EAGAIN;
 		}
 	} else {
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index d07413d..49a4a3d 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -23,6 +23,8 @@
  *	as published by the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) "SELinux: " fmt
+
 #include <linux/init.h>
 #include <linux/kd.h>
 #include <linux/kernel.h>
@@ -353,7 +355,7 @@ static const match_table_t tokens = {
 	{Opt_error, NULL},
 };
 
-#define SEL_MOUNT_FAIL_MSG "SELinux:  duplicate or incompatible mount options\n"
+#define SEL_MOUNT_FAIL_MSG "duplicate or incompatible mount options\n"
 
 static int may_context_mount_sb_relabel(u32 sid,
 			struct superblock_security_struct *sbsec,
@@ -425,27 +427,25 @@ static int sb_finish_set_opts(struct super_block *sb)
 		   the first boot of the SELinux kernel before we have
 		   assigned xattr values to the filesystem. */
 		if (!root_inode->i_op->getxattr) {
-			printk(KERN_WARNING "SELinux: (dev %s, type %s) has no "
-			       "xattr support\n", sb->s_id, sb->s_type->name);
+			pr_warn("(dev %s, type %s) has no xattr support\n",
+				sb->s_id, sb->s_type->name);
 			rc = -EOPNOTSUPP;
 			goto out;
 		}
 		rc = root_inode->i_op->getxattr(root, XATTR_NAME_SELINUX, NULL, 0);
 		if (rc < 0 && rc != -ENODATA) {
 			if (rc == -EOPNOTSUPP)
-				printk(KERN_WARNING "SELinux: (dev %s, type "
-				       "%s) has no security xattr handler\n",
-				       sb->s_id, sb->s_type->name);
+				pr_warn("(dev %s, type %s) has no security xattr handler\n",
+					sb->s_id, sb->s_type->name);
 			else
-				printk(KERN_WARNING "SELinux: (dev %s, type "
-				       "%s) getxattr errno %d\n", sb->s_id,
-				       sb->s_type->name, -rc);
+				pr_warn("(dev %s, type %s) getxattr errno %d\n",
+					sb->s_id, sb->s_type->name, -rc);
 			goto out;
 		}
 	}
 
 	if (sbsec->behavior > ARRAY_SIZE(labeling_behaviors))
-		printk(KERN_ERR "SELinux: initialized (dev %s, type %s), unknown behavior\n",
+		pr_err("initialized (dev %s, type %s), unknown behavior\n",
 		       sb->s_id, sb->s_type->name);
 	else
 		printk(KERN_DEBUG "SELinux: initialized (dev %s, type %s), %s\n",
@@ -631,8 +631,7 @@ static int selinux_set_mnt_opts(struct super_block *sb,
 			goto out;
 		}
 		rc = -EINVAL;
-		printk(KERN_WARNING "SELinux: Unable to set superblock options "
-			"before the security server is initialized\n");
+		pr_warn("Unable to set superblock options before the security server is initialized\n");
 		goto out;
 	}
 	if (kern_flags && !set_kern_flags) {
@@ -670,9 +669,8 @@ static int selinux_set_mnt_opts(struct super_block *sb,
 		rc = security_context_to_sid(mount_options[i],
 					     strlen(mount_options[i]), &sid);
 		if (rc) {
-			printk(KERN_WARNING "SELinux: security_context_to_sid"
-			       "(%s) failed for (dev %s, type %s) errno=%d\n",
-			       mount_options[i], sb->s_id, name, rc);
+			pr_warn("security_context_to_sid(%s) failed for (dev %s, type %s) errno=%d\n",
+				mount_options[i], sb->s_id, name, rc);
 			goto out;
 		}
 		switch (flags[i]) {
@@ -738,9 +736,8 @@ static int selinux_set_mnt_opts(struct super_block *sb,
 		 */
 		rc = security_fs_use(sb);
 		if (rc) {
-			printk(KERN_WARNING
-				"%s: security_fs_use(%s) returned %d\n",
-					__func__, sb->s_type->name, rc);
+			pr_warn("%s: security_fs_use(%s) returned %d\n",
+				__func__, sb->s_type->name, rc);
 			goto out;
 		}
 	}
@@ -797,8 +794,7 @@ static int selinux_set_mnt_opts(struct super_block *sb,
 		if (sbsec->behavior != SECURITY_FS_USE_XATTR &&
 			sbsec->behavior != SECURITY_FS_USE_NATIVE) {
 			rc = -EINVAL;
-			printk(KERN_WARNING "SELinux: defcontext option is "
-			       "invalid for this filesystem type\n");
+			pr_warn("defcontext option is invalid for this filesystem type\n");
 			goto out;
 		}
 
@@ -818,8 +814,8 @@ out:
 	return rc;
 out_double_mount:
 	rc = -EINVAL;
-	printk(KERN_WARNING "SELinux: mount invalid.  Same superblock, different "
-	       "security settings for (dev %s, type %s)\n", sb->s_id, name);
+	pr_warn("mount invalid - same superblock, different security settings for (dev %s, type %s)\n",
+		sb->s_id, name);
 	goto out;
 }
 
@@ -847,9 +843,8 @@ static int selinux_cmp_sb_context(const struct super_block *oldsb,
 	}
 	return 0;
 mismatch:
-	printk(KERN_WARNING "SELinux: mount invalid.  Same superblock, "
-			    "different security settings for (dev %s, "
-			    "type %s)\n", newsb->s_id, newsb->s_type->name);
+	pr_warn("mount invalid - same superblock, different security settings for (dev %s, type %s)\n",
+		newsb->s_id, newsb->s_type->name);
 	return -EBUSY;
 }
 
@@ -935,7 +930,7 @@ static int selinux_parse_opts_str(char *options,
 		case Opt_context:
 			if (context || defcontext) {
 				rc = -EINVAL;
-				printk(KERN_WARNING SEL_MOUNT_FAIL_MSG);
+				pr_warn(SEL_MOUNT_FAIL_MSG);
 				goto out_err;
 			}
 			context = match_strdup(&args[0]);
@@ -948,7 +943,7 @@ static int selinux_parse_opts_str(char *options,
 		case Opt_fscontext:
 			if (fscontext) {
 				rc = -EINVAL;
-				printk(KERN_WARNING SEL_MOUNT_FAIL_MSG);
+				pr_warn(SEL_MOUNT_FAIL_MSG);
 				goto out_err;
 			}
 			fscontext = match_strdup(&args[0]);
@@ -961,7 +956,7 @@ static int selinux_parse_opts_str(char *options,
 		case Opt_rootcontext:
 			if (rootcontext) {
 				rc = -EINVAL;
-				printk(KERN_WARNING SEL_MOUNT_FAIL_MSG);
+				pr_warn(SEL_MOUNT_FAIL_MSG);
 				goto out_err;
 			}
 			rootcontext = match_strdup(&args[0]);
@@ -974,7 +969,7 @@ static int selinux_parse_opts_str(char *options,
 		case Opt_defcontext:
 			if (context || defcontext) {
 				rc = -EINVAL;
-				printk(KERN_WARNING SEL_MOUNT_FAIL_MSG);
+				pr_warn(SEL_MOUNT_FAIL_MSG);
 				goto out_err;
 			}
 			defcontext = match_strdup(&args[0]);
@@ -987,7 +982,7 @@ static int selinux_parse_opts_str(char *options,
 			break;
 		default:
 			rc = -EINVAL;
-			printk(KERN_WARNING "SELinux:  unknown mount option\n");
+			pr_warn("unknown mount option\n");
 			goto out_err;
 
 		}
@@ -1359,9 +1354,9 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 		dput(dentry);
 		if (rc < 0) {
 			if (rc != -ENODATA) {
-				printk(KERN_WARNING "SELinux: %s:  getxattr returned "
-				       "%d for dev=%s ino=%ld\n", __func__,
-				       -rc, inode->i_sb->s_id, inode->i_ino);
+				pr_warn("%s: getxattr returned %d for dev=%s ino=%ld\n",
+					__func__,
+					-rc, inode->i_sb->s_id, inode->i_ino);
 				kfree(context);
 				goto out_unlock;
 			}
@@ -1378,13 +1373,12 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 
 				if (rc == -EINVAL) {
 					if (printk_ratelimit())
-						printk(KERN_NOTICE "SELinux: inode=%lu on dev=%s was found to have an invalid "
-							"context=%s.  This indicates you may need to relabel the inode or the "
-							"filesystem in question.\n", ino, dev, context);
+						pr_notice("inode=%lu on dev=%s was found to have an invalid context=%s.  This indicates you may need to relabel the inode or the filesystem in question.\n",
+							  ino, dev, context);
 				} else {
-					printk(KERN_WARNING "SELinux: %s:  context_to_sid(%s) "
-					       "returned %d for dev=%s ino=%ld\n",
-					       __func__, context, -rc, dev, ino);
+					pr_warn("%s: context_to_sid(%s) returned %d for dev=%s ino=%ld\n",
+						__func__,
+						context, -rc, dev, ino);
 				}
 				kfree(context);
 				/* Leave with the unlabeled SID */
@@ -1543,8 +1537,7 @@ static int cred_has_capability(const struct cred *cred,
 		sclass = SECCLASS_CAPABILITY2;
 		break;
 	default:
-		printk(KERN_ERR
-		       "SELinux:  out of range capability %d\n", cap);
+		pr_err("out of range capability %d\n", cap);
 		BUG();
 		return -EINVAL;
 	}
@@ -1762,8 +1755,7 @@ static int may_link(struct inode *dir,
 		av = DIR__RMDIR;
 		break;
 	default:
-		printk(KERN_WARNING "SELinux: %s:  unrecognized kind %d\n",
-			__func__, kind);
+		pr_warn("%s: unrecognized kind %d\n", __func__, kind);
 		return 0;
 	}
 
@@ -2491,9 +2483,9 @@ static int selinux_sb_remount(struct super_block *sb, void *data)
 		len = strlen(mount_options[i]);
 		rc = security_context_to_sid(mount_options[i], len, &sid);
 		if (rc) {
-			printk(KERN_WARNING "SELinux: security_context_to_sid"
-			       "(%s) failed for (dev %s, type %s) errno=%d\n",
-			       mount_options[i], sb->s_id, sb->s_type->name, rc);
+			pr_warn("security_context_to_sid(%s) failed for (dev %s, type %s) errno=%d\n",
+				mount_options[i], sb->s_id, sb->s_type->name,
+				rc);
 			goto out_free_opts;
 		}
 		rc = -EINVAL;
@@ -2530,9 +2522,8 @@ out_free_secdata:
 	free_secdata(secdata);
 	return rc;
 out_bad_option:
-	printk(KERN_WARNING "SELinux: unable to change security options "
-	       "during remount (dev %s, type=%s)\n", sb->s_id,
-	       sb->s_type->name);
+	pr_warn("unable to change security options during remount (dev %s, type=%s)\n",
+		sb->s_id, sb->s_type->name);
 	goto out_free_opts;
 }
 
@@ -2624,9 +2615,8 @@ static int selinux_dentry_init_security(struct dentry *dentry, int mode,
 					     name,
 					     &newsid);
 		if (rc) {
-			printk(KERN_WARNING
-				"%s: security_transition_sid failed, rc=%d\n",
-			       __func__, -rc);
+			pr_warn("%s: security_transition_sid failed, rc=%d\n",
+				__func__, -rc);
 			return rc;
 		}
 	}
@@ -2660,11 +2650,8 @@ static int selinux_inode_init_security(struct inode *inode, struct inode *dir,
 					     inode_mode_to_security_class(inode->i_mode),
 					     qstr, &newsid);
 		if (rc) {
-			printk(KERN_WARNING "%s:  "
-			       "security_transition_sid failed, rc=%d (dev=%s "
-			       "ino=%ld)\n",
-			       __func__,
-			       -rc, inode->i_sb->s_id, inode->i_ino);
+			pr_warn("%s: security_transition_sid failed, rc=%d (dev=%s ino=%ld)\n",
+				__func__, -rc, inode->i_sb->s_id, inode->i_ino);
 			return rc;
 		}
 	}
@@ -2957,8 +2944,7 @@ static void selinux_inode_post_setxattr(struct dentry *dentry, const char *name,
 
 	rc = security_context_to_sid_force(value, size, &newsid);
 	if (rc) {
-		printk(KERN_ERR "SELinux:  unable to map context to SID"
-		       "for (%s, %lu), rc=%d\n",
+		pr_err("unable to map context to SID for (%s, %lu), rc=%d\n",
 		       inode->i_sb->s_id, inode->i_ino, -rc);
 		return;
 	}
@@ -3810,9 +3796,7 @@ static int selinux_parse_skb(struct sk_buff *skb, struct common_audit_data *ad,
 	}
 
 parse_error:
-	printk(KERN_WARNING
-	       "SELinux: failure in selinux_parse_skb(),"
-	       " unable to parse packet\n");
+	pr_warn("failure in selinux_parse_skb(), unable to parse packet\n");
 	return ret;
 
 okay:
@@ -3852,9 +3836,7 @@ static int selinux_skb_peerlbl_sid(struct sk_buff *skb, u16 family, u32 *sid)
 
 	err = security_net_peersid_resolve(nlbl_sid, nlbl_type, xfrm_sid, sid);
 	if (unlikely(err)) {
-		printk(KERN_WARNING
-		       "SELinux: failure in selinux_skb_peerlbl_sid(),"
-		       " unable to determine packet's peer label\n");
+		pr_warn("failure in selinux_skb_peerlbl_sid(), unable to determine packet's peer label\n");
 		return -EACCES;
 	}
 
@@ -5956,11 +5938,11 @@ static __init int selinux_init(void)
 	}
 
 	if (!selinux_enabled) {
-		printk(KERN_INFO "SELinux:  Disabled at boot.\n");
+		pr_info("Disabled at boot\n");
 		return 0;
 	}
 
-	printk(KERN_INFO "SELinux:  Initializing.\n");
+	pr_info("Initializing\n");
 
 	/* Set the security state for the initial task. */
 	cred_init_security();
@@ -5976,9 +5958,9 @@ static __init int selinux_init(void)
 		panic("SELinux: Unable to register with kernel.\n");
 
 	if (selinux_enforcing)
-		printk(KERN_DEBUG "SELinux:  Starting in enforcing mode\n");
+		printk(KERN_DEBUG "SELinux: Starting in enforcing mode\n");
 	else
-		printk(KERN_DEBUG "SELinux:  Starting in permissive mode\n");
+		printk(KERN_DEBUG "SELinux: Starting in permissive mode\n");
 
 	return 0;
 }
@@ -5990,10 +5972,10 @@ static void delayed_superblock_init(struct super_block *sb, void *unused)
 
 void selinux_complete_init(void)
 {
-	printk(KERN_DEBUG "SELinux:  Completing initialization.\n");
+	printk(KERN_DEBUG "SELinux: Completing initialization\n");
 
 	/* Set up any superblocks initialized prior to the policy load. */
-	printk(KERN_DEBUG "SELinux:  Setting up existing superblocks.\n");
+	printk(KERN_DEBUG "SELinux: Setting up existing superblocks\n");
 	iterate_supers(delayed_superblock_init, NULL);
 }
 
@@ -6055,7 +6037,7 @@ static int __init selinux_nf_ip_init(void)
 	if (!selinux_enabled)
 		goto out;
 
-	printk(KERN_DEBUG "SELinux:  Registering netfilter hooks\n");
+	printk(KERN_DEBUG "SELinux: Registering netfilter hooks\n");
 
 	err = nf_register_hooks(selinux_ipv4_ops, ARRAY_SIZE(selinux_ipv4_ops));
 	if (err)
@@ -6076,7 +6058,7 @@ __initcall(selinux_nf_ip_init);
 #ifdef CONFIG_SECURITY_SELINUX_DISABLE
 static void selinux_nf_ip_exit(void)
 {
-	printk(KERN_DEBUG "SELinux:  Unregistering netfilter hooks\n");
+	printk(KERN_DEBUG "SELinux: Unregistering netfilter hooks\n");
 
 	nf_unregister_hooks(selinux_ipv4_ops, ARRAY_SIZE(selinux_ipv4_ops));
 #if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
@@ -6108,7 +6090,7 @@ int selinux_disable(void)
 		return -EINVAL;
 	}
 
-	printk(KERN_INFO "SELinux:  Disabled at runtime.\n");
+	pr_info("Disabled at runtime\n");
 
 	selinux_disabled = 1;
 	selinux_enabled = 0;
diff --git a/security/selinux/netif.c b/security/selinux/netif.c
index 694e9e4..17001cc 100644
--- a/security/selinux/netif.c
+++ b/security/selinux/netif.c
@@ -14,6 +14,9 @@
  * it under the terms of the GNU General Public License version 2,
  * as published by the Free Software Foundation.
  */
+
+#define pr_fmt(fmt) "SELinux: " fmt
+
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/slab.h>
@@ -142,9 +145,8 @@ static int sel_netif_sid_slow(int ifindex, u32 *sid)
 
 	dev = dev_get_by_index(&init_net, ifindex);
 	if (unlikely(dev == NULL)) {
-		printk(KERN_WARNING
-		       "SELinux: failure in sel_netif_sid_slow(),"
-		       " invalid network interface (%d)\n", ifindex);
+		pr_warn("failure in sel_netif_sid_slow(), invalid network interface (%d)\n",
+			ifindex);
 		return -ENOENT;
 	}
 
@@ -173,10 +175,8 @@ out:
 	spin_unlock_bh(&sel_netif_lock);
 	dev_put(dev);
 	if (unlikely(ret)) {
-		printk(KERN_WARNING
-		       "SELinux: failure in sel_netif_sid_slow(),"
-		       " unable to determine network interface label (%d)\n",
-		       ifindex);
+		pr_warn("failure in sel_netif_sid_slow(), unable to determine network interface label (%d)\n",
+			ifindex);
 		kfree(new);
 	}
 	return ret;
diff --git a/security/selinux/netlink.c b/security/selinux/netlink.c
index 828fb6a..50bc253 100644
--- a/security/selinux/netlink.c
+++ b/security/selinux/netlink.c
@@ -9,6 +9,9 @@
  * it under the terms of the GNU General Public License version 2,
  * as published by the Free Software Foundation.
  */
+
+#define pr_fmt(fmt) "SELinux: " fmt
+
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/slab.h>
@@ -94,7 +97,7 @@ out:
 out_kfree_skb:
 	kfree_skb(skb);
 oom:
-	printk(KERN_ERR "SELinux:  OOM in %s\n", __func__);
+	pr_err("OOM in %s\n", __func__);
 	goto out;
 }
 
diff --git a/security/selinux/netnode.c b/security/selinux/netnode.c
index 03a72c3..9f8fd79 100644
--- a/security/selinux/netnode.c
+++ b/security/selinux/netnode.c
@@ -28,6 +28,8 @@
  *
  */
 
+#define pr_fmt(fmt) "SELinux: " fmt
+
 #include <linux/types.h>
 #include <linux/rcupdate.h>
 #include <linux/list.h>
@@ -238,9 +240,7 @@ static int sel_netnode_sid_slow(void *addr, u16 family, u32 *sid)
 out:
 	spin_unlock_bh(&sel_netnode_lock);
 	if (unlikely(ret)) {
-		printk(KERN_WARNING
-		       "SELinux: failure in sel_netnode_sid_slow(),"
-		       " unable to determine network node label\n");
+		pr_warn("failure in sel_netnode_sid_slow(), unable to determine network node label\n");
 		kfree(new);
 	}
 	return ret;
diff --git a/security/selinux/netport.c b/security/selinux/netport.c
index d353797..20a4ed0 100644
--- a/security/selinux/netport.c
+++ b/security/selinux/netport.c
@@ -12,7 +12,6 @@
  *   (see security/selinux/netif.c for more information)
  *
  */
-
 /*
  * (c) Copyright Hewlett-Packard Development Company, L.P., 2008
  *
@@ -27,6 +26,8 @@
  *
  */
 
+#define pr_fmt(fmt) "SELinux: " fmt
+
 #include <linux/types.h>
 #include <linux/rcupdate.h>
 #include <linux/list.h>
@@ -173,9 +174,7 @@ static int sel_netport_sid_slow(u8 protocol, u16 pnum, u32 *sid)
 out:
 	spin_unlock_bh(&sel_netport_lock);
 	if (unlikely(ret)) {
-		printk(KERN_WARNING
-		       "SELinux: failure in sel_netport_sid_slow(),"
-		       " unable to determine network port label\n");
+		pr_warn("failure in sel_netport_sid_slow(), unable to determine network port label\n");
 		kfree(new);
 	}
 	return ret;
diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index 170b4b1..78ced2a 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -14,6 +14,8 @@
  *	the Free Software Foundation, version 2.
  */
 
+#define pr_fmt(fmt) "SELinux: " fmt
+
 #include <linux/kernel.h>
 #include <linux/pagemap.h>
 #include <linux/slab.h>
@@ -586,8 +588,8 @@ static ssize_t sel_write_context(struct file *file, char *buf, size_t size)
 
 	length = -ERANGE;
 	if (len > SIMPLE_TRANSACTION_LIMIT) {
-		printk(KERN_ERR "SELinux: %s:  context size (%u) exceeds "
-			"payload max\n", __func__, len);
+		pr_err("%s: context size (%u) exceeds payload max\n",
+		       __func__, len);
 		goto out;
 	}
 
@@ -836,8 +838,8 @@ static ssize_t sel_write_create(struct file *file, char *buf, size_t size)
 
 	length = -ERANGE;
 	if (len > SIMPLE_TRANSACTION_LIMIT) {
-		printk(KERN_ERR "SELinux: %s:  context size (%u) exceeds "
-			"payload max\n", __func__, len);
+		pr_err("%s: context size (%u) exceeds payload max\n",
+		       __func__, len);
 		goto out;
 	}
 
@@ -1012,8 +1014,8 @@ static ssize_t sel_write_member(struct file *file, char *buf, size_t size)
 
 	length = -ERANGE;
 	if (len > SIMPLE_TRANSACTION_LIMIT) {
-		printk(KERN_ERR "SELinux: %s:  context size (%u) exceeds "
-			"payload max\n", __func__, len);
+		pr_err("%s: context size (%u) exceeds payload max\n",
+		       __func__, len);
 		goto out;
 	}
 
@@ -1873,8 +1875,7 @@ static int sel_fill_super(struct super_block *sb, void *data, int silent)
 	}
 	return 0;
 err:
-	printk(KERN_ERR "SELinux: %s:  failed while creating inodes\n",
-		__func__);
+	pr_err("%s: failed while creating inodes\n", __func__);
 	return ret;
 }
 
@@ -1912,7 +1913,7 @@ static int __init init_sel_fs(void)
 
 	selinux_null.mnt = selinuxfs_mount = kern_mount(&sel_fs_type);
 	if (IS_ERR(selinuxfs_mount)) {
-		printk(KERN_ERR "selinuxfs:  could not mount!\n");
+		pr_err("selinuxfs: could not mount!\n");
 		err = PTR_ERR(selinuxfs_mount);
 		selinuxfs_mount = NULL;
 	}
diff --git a/security/selinux/ss/avtab.c b/security/selinux/ss/avtab.c
index a3dd9fa..b805fe2 100644
--- a/security/selinux/ss/avtab.c
+++ b/security/selinux/ss/avtab.c
@@ -17,6 +17,8 @@
  *	Tuned number of hash slots for avtab to reduce memory usage
  */
 
+#define pr_fmt(fmt) "SELinux: avtab: " fmt
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
@@ -343,18 +345,18 @@ int avtab_read_item(struct avtab *a, void *fp, struct policydb *pol,
 	if (vers < POLICYDB_VERSION_AVTAB) {
 		rc = next_entry(buf32, fp, sizeof(u32));
 		if (rc) {
-			printk(KERN_ERR "SELinux: avtab: truncated entry\n");
+			pr_err("truncated entry\n");
 			return rc;
 		}
 		items2 = le32_to_cpu(buf32[0]);
 		if (items2 > ARRAY_SIZE(buf32)) {
-			printk(KERN_ERR "SELinux: avtab: entry overflow\n");
+			pr_err("entry overflow\n");
 			return -EINVAL;
 
 		}
 		rc = next_entry(buf32, fp, sizeof(u32)*items2);
 		if (rc) {
-			printk(KERN_ERR "SELinux: avtab: truncated entry\n");
+			pr_err("truncated entry\n");
 			return rc;
 		}
 		items = 0;
@@ -362,19 +364,19 @@ int avtab_read_item(struct avtab *a, void *fp, struct policydb *pol,
 		val = le32_to_cpu(buf32[items++]);
 		key.source_type = (u16)val;
 		if (key.source_type != val) {
-			printk(KERN_ERR "SELinux: avtab: truncated source type\n");
+			pr_err("truncated source type\n");
 			return -EINVAL;
 		}
 		val = le32_to_cpu(buf32[items++]);
 		key.target_type = (u16)val;
 		if (key.target_type != val) {
-			printk(KERN_ERR "SELinux: avtab: truncated target type\n");
+			pr_err("truncated target type\n");
 			return -EINVAL;
 		}
 		val = le32_to_cpu(buf32[items++]);
 		key.target_class = (u16)val;
 		if (key.target_class != val) {
-			printk(KERN_ERR "SELinux: avtab: truncated target class\n");
+			pr_err("truncated target class\n");
 			return -EINVAL;
 		}
 
@@ -382,12 +384,12 @@ int avtab_read_item(struct avtab *a, void *fp, struct policydb *pol,
 		enabled = (val & AVTAB_ENABLED_OLD) ? AVTAB_ENABLED : 0;
 
 		if (!(val & (AVTAB_AV | AVTAB_TYPE))) {
-			printk(KERN_ERR "SELinux: avtab: null entry\n");
+			pr_err("null entry\n");
 			return -EINVAL;
 		}
 		if ((val & AVTAB_AV) &&
 		    (val & AVTAB_TYPE)) {
-			printk(KERN_ERR "SELinux: avtab: entry has both access vectors and types\n");
+			pr_err("entry has both access vectors and types\n");
 			return -EINVAL;
 		}
 
@@ -402,7 +404,8 @@ int avtab_read_item(struct avtab *a, void *fp, struct policydb *pol,
 		}
 
 		if (items != items2) {
-			printk(KERN_ERR "SELinux: avtab: entry only had %d items, expected %d\n", items2, items);
+			pr_err("entry only had %d items, expected %d\n",
+			       items2, items);
 			return -EINVAL;
 		}
 		return 0;
@@ -410,7 +413,7 @@ int avtab_read_item(struct avtab *a, void *fp, struct policydb *pol,
 
 	rc = next_entry(buf16, fp, sizeof(u16)*4);
 	if (rc) {
-		printk(KERN_ERR "SELinux: avtab: truncated entry\n");
+		pr_err("truncated entry\n");
 		return rc;
 	}
 
@@ -423,7 +426,7 @@ int avtab_read_item(struct avtab *a, void *fp, struct policydb *pol,
 	if (!policydb_type_isvalid(pol, key.source_type) ||
 	    !policydb_type_isvalid(pol, key.target_type) ||
 	    !policydb_class_isvalid(pol, key.target_class)) {
-		printk(KERN_ERR "SELinux: avtab: invalid type or class\n");
+		pr_err("invalid type or class\n");
 		return -EINVAL;
 	}
 
@@ -433,19 +436,19 @@ int avtab_read_item(struct avtab *a, void *fp, struct policydb *pol,
 			set++;
 	}
 	if (!set || set > 1) {
-		printk(KERN_ERR "SELinux:  avtab:  more than one specifier\n");
+		pr_err("more than one specifier\n");
 		return -EINVAL;
 	}
 
 	rc = next_entry(buf32, fp, sizeof(u32));
 	if (rc) {
-		printk(KERN_ERR "SELinux: avtab: truncated entry\n");
+		pr_err("truncated entry\n");
 		return rc;
 	}
 	datum.data = le32_to_cpu(*buf32);
 	if ((key.specified & AVTAB_TYPE) &&
 	    !policydb_type_isvalid(pol, datum.data)) {
-		printk(KERN_ERR "SELinux: avtab: invalid type\n");
+		pr_err("invalid type\n");
 		return -EINVAL;
 	}
 	return insertf(a, &key, &datum, p);
@@ -466,12 +469,12 @@ int avtab_read(struct avtab *a, void *fp, struct policydb *pol)
 
 	rc = next_entry(buf, fp, sizeof(u32));
 	if (rc < 0) {
-		printk(KERN_ERR "SELinux: avtab: truncated table\n");
+		pr_err("truncated table\n");
 		goto bad;
 	}
 	nel = le32_to_cpu(buf[0]);
 	if (!nel) {
-		printk(KERN_ERR "SELinux: avtab: table is empty\n");
+		pr_err("table is empty\n");
 		rc = -EINVAL;
 		goto bad;
 	}
@@ -484,9 +487,9 @@ int avtab_read(struct avtab *a, void *fp, struct policydb *pol)
 		rc = avtab_read_item(a, fp, pol, avtab_insertf, NULL);
 		if (rc) {
 			if (rc == -ENOMEM)
-				printk(KERN_ERR "SELinux: avtab: out of memory\n");
+				pr_err("out of memory\n");
 			else if (rc == -EEXIST)
-				printk(KERN_ERR "SELinux: avtab: duplicate entry\n");
+				pr_err("duplicate entry\n");
 
 			goto bad;
 		}
diff --git a/security/selinux/ss/conditional.c b/security/selinux/ss/conditional.c
index 377d148..9bb2dde 100644
--- a/security/selinux/ss/conditional.c
+++ b/security/selinux/ss/conditional.c
@@ -7,6 +7,8 @@
  *	the Free Software Foundation, version 2.
  */
 
+#define pr_fmt(fmt) "SELinux: " fmt
+
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/string.h>
@@ -95,7 +97,7 @@ int evaluate_cond_node(struct policydb *p, struct cond_node *node)
 	if (new_state != node->cur_state) {
 		node->cur_state = new_state;
 		if (new_state == -1)
-			printk(KERN_ERR "SELinux: expression result was undefined - disabling all rules.\n");
+			pr_err("expression result was undefined - disabling all rules\n");
 		/* turn the rules on or off */
 		for (cur = node->true_list; cur; cur = cur->next) {
 			if (new_state <= 0)
@@ -283,7 +285,7 @@ static int cond_insertf(struct avtab *a, struct avtab_key *k, struct avtab_datum
 	 */
 	if (k->specified & AVTAB_TYPE) {
 		if (avtab_search(&p->te_avtab, k)) {
-			printk(KERN_ERR "SELinux: type rule already exists outside of a conditional.\n");
+			pr_err("type rule already exists outside of a conditional\n");
 			goto err;
 		}
 		/*
@@ -298,7 +300,7 @@ static int cond_insertf(struct avtab *a, struct avtab_key *k, struct avtab_datum
 			node_ptr = avtab_search_node(&p->te_cond_avtab, k);
 			if (node_ptr) {
 				if (avtab_search_node_next(node_ptr, k->specified)) {
-					printk(KERN_ERR "SELinux: too many conflicting type rules.\n");
+					pr_err("too many conflicting type rules\n");
 					goto err;
 				}
 				found = 0;
@@ -309,13 +311,13 @@ static int cond_insertf(struct avtab *a, struct avtab_key *k, struct avtab_datum
 					}
 				}
 				if (!found) {
-					printk(KERN_ERR "SELinux: conflicting type rules.\n");
+					pr_err("conflicting type rules\n");
 					goto err;
 				}
 			}
 		} else {
 			if (avtab_search(&p->te_cond_avtab, k)) {
-				printk(KERN_ERR "SELinux: conflicting type rules when adding type rule for true.\n");
+				pr_err("conflicting type rules when adding type rule for true\n");
 				goto err;
 			}
 		}
@@ -323,7 +325,7 @@ static int cond_insertf(struct avtab *a, struct avtab_key *k, struct avtab_datum
 
 	node_ptr = avtab_insert_nonunique(&p->te_cond_avtab, k, d);
 	if (!node_ptr) {
-		printk(KERN_ERR "SELinux: could not insert rule.\n");
+		pr_err("could not insert rule\n");
 		rc = -ENOMEM;
 		goto err;
 	}
@@ -384,12 +386,12 @@ static int cond_read_av_list(struct policydb *p, void *fp, struct cond_av_list *
 static int expr_isvalid(struct policydb *p, struct cond_expr *expr)
 {
 	if (expr->expr_type <= 0 || expr->expr_type > COND_LAST) {
-		printk(KERN_ERR "SELinux: conditional expressions uses unknown operator.\n");
+		pr_err("conditional expressions uses unknown operator\n");
 		return 0;
 	}
 
 	if (expr->bool > p->p_bools.nprim) {
-		printk(KERN_ERR "SELinux: conditional expressions uses unknown bool.\n");
+		pr_err("conditional expressions uses unknown bool\n");
 		return 0;
 	}
 	return 1;
diff --git a/security/selinux/ss/ebitmap.c b/security/selinux/ss/ebitmap.c
index 820313a..0ea9bbc 100644
--- a/security/selinux/ss/ebitmap.c
+++ b/security/selinux/ss/ebitmap.c
@@ -15,6 +15,8 @@
  *      Applied standard bit operations to improve bitmap scanning.
  */
 
+#define pr_fmt(fmt) "SELinux: ebitmap: " fmt
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
@@ -382,8 +384,7 @@ int ebitmap_read(struct ebitmap *e, void *fp)
 	count = le32_to_cpu(buf[2]);
 
 	if (mapunit != BITS_PER_U64) {
-		printk(KERN_ERR "SELinux: ebitmap: map size %u does not "
-		       "match my size %Zd (high bit was %d)\n",
+		pr_err("map size %u does not match my size %Zd (high bit was %d)\n",
 		       mapunit, BITS_PER_U64, e->highbit);
 		goto bad;
 	}
@@ -400,20 +401,18 @@ int ebitmap_read(struct ebitmap *e, void *fp)
 	for (i = 0; i < count; i++) {
 		rc = next_entry(&startbit, fp, sizeof(u32));
 		if (rc < 0) {
-			printk(KERN_ERR "SELinux: ebitmap: truncated map\n");
+			pr_err("truncated map\n");
 			goto bad;
 		}
 		startbit = le32_to_cpu(startbit);
 
 		if (startbit & (mapunit - 1)) {
-			printk(KERN_ERR "SELinux: ebitmap start bit (%d) is "
-			       "not a multiple of the map unit size (%u)\n",
+			pr_err("start bit (%d) is not a multiple of the map unit size (%u)\n",
 			       startbit, mapunit);
 			goto bad;
 		}
 		if (startbit > e->highbit - mapunit) {
-			printk(KERN_ERR "SELinux: ebitmap start bit (%d) is "
-			       "beyond the end of the bitmap (%u)\n",
+			pr_err("start bit (%d) is beyond the end of the bitmap (%u)\n",
 			       startbit, (e->highbit - mapunit));
 			goto bad;
 		}
@@ -422,8 +421,7 @@ int ebitmap_read(struct ebitmap *e, void *fp)
 			struct ebitmap_node *tmp;
 			tmp = kzalloc(sizeof(*tmp), GFP_KERNEL);
 			if (!tmp) {
-				printk(KERN_ERR
-				       "SELinux: ebitmap: out of memory\n");
+				pr_err("out of memory\n");
 				rc = -ENOMEM;
 				goto bad;
 			}
@@ -435,15 +433,14 @@ int ebitmap_read(struct ebitmap *e, void *fp)
 				e->node = tmp;
 			n = tmp;
 		} else if (startbit <= n->startbit) {
-			printk(KERN_ERR "SELinux: ebitmap: start bit %d"
-			       " comes after start bit %d\n",
+			pr_err("start bit %d comes after start bit %d\n",
 			       startbit, n->startbit);
 			goto bad;
 		}
 
 		rc = next_entry(&map, fp, sizeof(u64));
 		if (rc < 0) {
-			printk(KERN_ERR "SELinux: ebitmap: truncated map\n");
+			pr_err("truncated map\n");
 			goto bad;
 		}
 		map = le64_to_cpu(map);
diff --git a/security/selinux/ss/policydb.c b/security/selinux/ss/policydb.c
index c0f4988..ff9e193 100644
--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -25,6 +25,8 @@
  *	the Free Software Foundation, version 2.
  */
 
+#define pr_fmt(fmt) "SELinux: " fmt
+
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -515,14 +517,14 @@ static int policydb_index(struct policydb *p)
 {
 	int i, rc;
 
-	printk(KERN_DEBUG "SELinux:  %d users, %d roles, %d types, %d bools",
+	printk(KERN_DEBUG "SELinux: %d users, %d roles, %d types, %d bools",
 	       p->p_users.nprim, p->p_roles.nprim, p->p_types.nprim, p->p_bools.nprim);
 	if (p->mls_enabled)
 		printk(", %d sens, %d cats", p->p_levels.nprim,
 		       p->p_cats.nprim);
 	printk("\n");
 
-	printk(KERN_DEBUG "SELinux:  %d classes, %d rules\n",
+	printk(KERN_DEBUG "SELinux: %d classes, %d rules\n",
 	       p->p_classes.nprim, p->te_avtab.nel);
 
 #ifdef DEBUG_HASHES
@@ -886,7 +888,7 @@ int policydb_load_isids(struct policydb *p, struct sidtab *s)
 
 	rc = sidtab_init(s);
 	if (rc) {
-		printk(KERN_ERR "SELinux:  out of memory on SID table init\n");
+		pr_err("out of memory on SID table init\n");
 		goto out;
 	}
 
@@ -894,15 +896,13 @@ int policydb_load_isids(struct policydb *p, struct sidtab *s)
 	for (c = head; c; c = c->next) {
 		rc = -EINVAL;
 		if (!c->context[0].user) {
-			printk(KERN_ERR "SELinux:  SID %s was never defined.\n",
-				c->u.name);
+			pr_err("SID %s was never defined\n", c->u.name);
 			goto out;
 		}
 
 		rc = sidtab_insert(s, c->sid[0], &c->context[0]);
 		if (rc) {
-			printk(KERN_ERR "SELinux:  unable to load initial SID %s.\n",
-				c->u.name);
+			pr_err("unable to load initial SID %s\n", c->u.name);
 			goto out;
 		}
 	}
@@ -994,13 +994,13 @@ static int mls_read_range_helper(struct mls_range *r, void *fp)
 	rc = -EINVAL;
 	items = le32_to_cpu(buf[0]);
 	if (items > ARRAY_SIZE(buf)) {
-		printk(KERN_ERR "SELinux: mls:  range overflow\n");
+		pr_err("mls: range overflow\n");
 		goto out;
 	}
 
 	rc = next_entry(buf, fp, sizeof(u32) * items);
 	if (rc) {
-		printk(KERN_ERR "SELinux: mls:  truncated range\n");
+		pr_err("mls: truncated range\n");
 		goto out;
 	}
 
@@ -1012,19 +1012,19 @@ static int mls_read_range_helper(struct mls_range *r, void *fp)
 
 	rc = ebitmap_read(&r->level[0].cat, fp);
 	if (rc) {
-		printk(KERN_ERR "SELinux: mls:  error reading low categories\n");
+		pr_err("mls: error reading low categories\n");
 		goto out;
 	}
 	if (items > 1) {
 		rc = ebitmap_read(&r->level[1].cat, fp);
 		if (rc) {
-			printk(KERN_ERR "SELinux: mls:  error reading high categories\n");
+			pr_err("mls: error reading high categories\n");
 			goto bad_high;
 		}
 	} else {
 		rc = ebitmap_cpy(&r->level[1].cat, &r->level[0].cat);
 		if (rc) {
-			printk(KERN_ERR "SELinux: mls:  out of memory\n");
+			pr_err("mls: out of memory\n");
 			goto bad_high;
 		}
 	}
@@ -1049,7 +1049,7 @@ static int context_read_and_validate(struct context *c,
 
 	rc = next_entry(buf, fp, sizeof buf);
 	if (rc) {
-		printk(KERN_ERR "SELinux: context truncated\n");
+		pr_err("context truncated\n");
 		goto out;
 	}
 	c->user = le32_to_cpu(buf[0]);
@@ -1058,14 +1058,14 @@ static int context_read_and_validate(struct context *c,
 	if (p->policyvers >= POLICYDB_VERSION_MLS) {
 		rc = mls_read_range_helper(&c->range, fp);
 		if (rc) {
-			printk(KERN_ERR "SELinux: error reading MLS range of context\n");
+			pr_err("error reading MLS range of context\n");
 			goto out;
 		}
 	}
 
 	rc = -EINVAL;
 	if (!policydb_context_isvalid(p, c)) {
-		printk(KERN_ERR "SELinux:  invalid security context\n");
+		pr_err("invalid security context\n");
 		context_destroy(c);
 		goto out;
 	}
@@ -1344,7 +1344,7 @@ static int class_read(struct policydb *p, struct hashtab *h, void *fp)
 		rc = -EINVAL;
 		cladatum->comdatum = hashtab_search(p->p_commons.table, cladatum->comkey);
 		if (!cladatum->comdatum) {
-			printk(KERN_ERR "SELinux:  unknown common %s\n", cladatum->comkey);
+			pr_err("unknown common %s\n", cladatum->comkey);
 			goto bad;
 		}
 	}
@@ -1443,7 +1443,7 @@ static int role_read(struct policydb *p, struct hashtab *h, void *fp)
 	if (strcmp(key, OBJECT_R) == 0) {
 		rc = -EINVAL;
 		if (role->value != OBJECT_R_VAL) {
-			printk(KERN_ERR "SELinux: Role %s has wrong value %d\n",
+			pr_err("Role %s has wrong value %d\n",
 			       OBJECT_R, role->value);
 			goto bad;
 		}
@@ -1527,14 +1527,14 @@ static int mls_read_level(struct mls_level *lp, void *fp)
 
 	rc = next_entry(buf, fp, sizeof buf);
 	if (rc) {
-		printk(KERN_ERR "SELinux: mls: truncated level\n");
+		pr_err("mls: truncated level\n");
 		return rc;
 	}
 	lp->sens = le32_to_cpu(buf[0]);
 
 	rc = ebitmap_read(&lp->cat, fp);
 	if (rc) {
-		printk(KERN_ERR "SELinux: mls:  error reading level categories\n");
+		pr_err("mls: error reading level categories\n");
 		return rc;
 	}
 	return 0;
@@ -1706,8 +1706,7 @@ static int user_bounds_sanity_check(void *key, void *datum, void *datap)
 		unsigned long bit;
 
 		if (++depth == POLICYDB_BOUNDS_MAXDEPTH) {
-			printk(KERN_ERR "SELinux: user %s: "
-			       "too deep or looped boundary",
+			pr_err("user %s: too deep or looped boundary\n",
 			       (char *) key);
 			return -EINVAL;
 		}
@@ -1717,9 +1716,7 @@ static int user_bounds_sanity_check(void *key, void *datum, void *datap)
 			if (ebitmap_get_bit(&upper->roles, bit))
 				continue;
 
-			printk(KERN_ERR
-			       "SELinux: boundary violated policy: "
-			       "user=%s role=%s bounds=%s\n",
+			pr_err("boundary violated policy: user=%s role=%s bounds=%s\n",
 			       sym_name(p, SYM_USERS, user->value - 1),
 			       sym_name(p, SYM_ROLES, bit),
 			       sym_name(p, SYM_USERS, upper->value - 1));
@@ -1743,8 +1740,7 @@ static int role_bounds_sanity_check(void *key, void *datum, void *datap)
 		unsigned long bit;
 
 		if (++depth == POLICYDB_BOUNDS_MAXDEPTH) {
-			printk(KERN_ERR "SELinux: role %s: "
-			       "too deep or looped bounds\n",
+			pr_err("role %s: too deep or looped bounds\n",
 			       (char *) key);
 			return -EINVAL;
 		}
@@ -1754,9 +1750,7 @@ static int role_bounds_sanity_check(void *key, void *datum, void *datap)
 			if (ebitmap_get_bit(&upper->types, bit))
 				continue;
 
-			printk(KERN_ERR
-			       "SELinux: boundary violated policy: "
-			       "role=%s type=%s bounds=%s\n",
+			pr_err("boundary violated policy: role=%s type=%s bounds=%s\n",
 			       sym_name(p, SYM_ROLES, role->value - 1),
 			       sym_name(p, SYM_TYPES, bit),
 			       sym_name(p, SYM_ROLES, upper->value - 1));
@@ -1777,8 +1771,7 @@ static int type_bounds_sanity_check(void *key, void *datum, void *datap)
 	upper = datum;
 	while (upper->bounds) {
 		if (++depth == POLICYDB_BOUNDS_MAXDEPTH) {
-			printk(KERN_ERR "SELinux: type %s: "
-			       "too deep or looped boundary\n",
+			pr_err("type %s: too deep or looped boundary\n",
 			       (char *) key);
 			return -EINVAL;
 		}
@@ -1788,8 +1781,7 @@ static int type_bounds_sanity_check(void *key, void *datum, void *datap)
 		BUG_ON(!upper);
 
 		if (upper->attribute) {
-			printk(KERN_ERR "SELinux: type %s: "
-			       "bounded by attribute %s",
+			pr_err("type %s: bounded by attribute %s\n",
 			       (char *) key,
 			       sym_name(p, SYM_TYPES, upper->value - 1));
 			return -EINVAL;
@@ -1911,7 +1903,7 @@ static int range_read(struct policydb *p, void *fp)
 
 		rc = -EINVAL;
 		if (!mls_range_isvalid(p, r)) {
-			printk(KERN_WARNING "SELinux:  rangetrans:  invalid range\n");
+			pr_warn("rangetrans: invalid range\n");
 			goto out;
 		}
 
@@ -2060,7 +2052,7 @@ static int genfs_read(struct policydb *p, void *fp)
 		     genfs_p = genfs, genfs = genfs->next) {
 			rc = -EINVAL;
 			if (strcmp(newgenfs->fstype, genfs->fstype) == 0) {
-				printk(KERN_ERR "SELinux:  dup genfs fstype %s\n",
+				pr_err("dup genfs fstype %s\n",
 				       newgenfs->fstype);
 				goto out;
 			}
@@ -2116,7 +2108,7 @@ static int genfs_read(struct policydb *p, void *fp)
 				if (!strcmp(newc->u.name, c->u.name) &&
 				    (!c->v.sclass || !newc->v.sclass ||
 				     newc->v.sclass == c->v.sclass)) {
-					printk(KERN_ERR "SELinux:  dup genfs entry (%s,%s)\n",
+					pr_err("dup genfs entry (%s,%s)\n",
 					       genfs->fstype, c->u.name);
 					goto out;
 				}
@@ -2303,8 +2295,7 @@ int policydb_read(struct policydb *p, void *fp)
 
 	rc = -EINVAL;
 	if (le32_to_cpu(buf[0]) != POLICYDB_MAGIC) {
-		printk(KERN_ERR "SELinux:  policydb magic number 0x%x does "
-		       "not match expected magic number 0x%x\n",
+		pr_err("policydb magic number 0x%x does not match expected magic number 0x%x\n",
 		       le32_to_cpu(buf[0]), POLICYDB_MAGIC);
 		goto bad;
 	}
@@ -2312,8 +2303,7 @@ int policydb_read(struct policydb *p, void *fp)
 	rc = -EINVAL;
 	len = le32_to_cpu(buf[1]);
 	if (len != strlen(POLICYDB_STRING)) {
-		printk(KERN_ERR "SELinux:  policydb string length %d does not "
-		       "match expected length %Zu\n",
+		pr_err("policydb string length %d does not match expected length %Zu\n",
 		       len, strlen(POLICYDB_STRING));
 		goto bad;
 	}
@@ -2321,14 +2311,14 @@ int policydb_read(struct policydb *p, void *fp)
 	rc = -ENOMEM;
 	policydb_str = kmalloc(len + 1, GFP_KERNEL);
 	if (!policydb_str) {
-		printk(KERN_ERR "SELinux:  unable to allocate memory for policydb "
-		       "string of length %d\n", len);
+		pr_err("unable to allocate memory for policydb string of length %d\n",
+		       len);
 		goto bad;
 	}
 
 	rc = next_entry(policydb_str, fp, len);
 	if (rc) {
-		printk(KERN_ERR "SELinux:  truncated policydb string identifier\n");
+		pr_err("truncated policydb string identifier\n");
 		kfree(policydb_str);
 		goto bad;
 	}
@@ -2336,8 +2326,8 @@ int policydb_read(struct policydb *p, void *fp)
 	rc = -EINVAL;
 	policydb_str[len] = '\0';
 	if (strcmp(policydb_str, POLICYDB_STRING)) {
-		printk(KERN_ERR "SELinux:  policydb string %s does not match "
-		       "my string %s\n", policydb_str, POLICYDB_STRING);
+		pr_err("policydb string %s does not match my string %s\n",
+		       policydb_str, POLICYDB_STRING);
 		kfree(policydb_str);
 		goto bad;
 	}
@@ -2354,9 +2344,9 @@ int policydb_read(struct policydb *p, void *fp)
 	p->policyvers = le32_to_cpu(buf[0]);
 	if (p->policyvers < POLICYDB_VERSION_MIN ||
 	    p->policyvers > POLICYDB_VERSION_MAX) {
-		printk(KERN_ERR "SELinux:  policydb version %d does not match "
-		       "my version range %d-%d\n",
-		       le32_to_cpu(buf[0]), POLICYDB_VERSION_MIN, POLICYDB_VERSION_MAX);
+		pr_err("policydb version %d does not match my version range %d-%d\n",
+		       le32_to_cpu(buf[0]),
+		       POLICYDB_VERSION_MIN, POLICYDB_VERSION_MAX);
 		goto bad;
 	}
 
@@ -2365,9 +2355,8 @@ int policydb_read(struct policydb *p, void *fp)
 
 		rc = -EINVAL;
 		if (p->policyvers < POLICYDB_VERSION_MLS) {
-			printk(KERN_ERR "SELinux: security policydb version %d "
-				"(MLS) not backwards compatible\n",
-				p->policyvers);
+			pr_err("security policydb version %d (MLS) not backwards compatible\n",
+			       p->policyvers);
 			goto bad;
 		}
 	}
@@ -2389,17 +2378,16 @@ int policydb_read(struct policydb *p, void *fp)
 	rc = -EINVAL;
 	info = policydb_lookup_compat(p->policyvers);
 	if (!info) {
-		printk(KERN_ERR "SELinux:  unable to find policy compat info "
-		       "for version %d\n", p->policyvers);
+		pr_err("unable to find policy compat info for version %d\n",
+		       p->policyvers);
 		goto bad;
 	}
 
 	rc = -EINVAL;
 	if (le32_to_cpu(buf[2]) != info->sym_num ||
 		le32_to_cpu(buf[3]) != info->ocon_num) {
-		printk(KERN_ERR "SELinux:  policydb table sizes (%d,%d) do "
-		       "not match mine (%d,%d)\n", le32_to_cpu(buf[2]),
-			le32_to_cpu(buf[3]),
+		pr_err("policydb table sizes (%d,%d) do not match mine (%d,%d)\n",
+		       le32_to_cpu(buf[2]), le32_to_cpu(buf[3]),
 		       info->sym_num, info->ocon_num);
 		goto bad;
 	}
@@ -3397,9 +3385,8 @@ int policydb_write(struct policydb *p, void *fp)
 	 * careful if you ever try to remove this restriction
 	 */
 	if (p->policyvers < POLICYDB_VERSION_AVTAB) {
-		printk(KERN_ERR "SELinux: refusing to write policy version %d."
-		       "  Because it is less than version %d\n", p->policyvers,
-		       POLICYDB_VERSION_AVTAB);
+		pr_err("refusing to write policy version %d because it is less than version %d\n",
+		       p->policyvers, POLICYDB_VERSION_AVTAB);
 		return -EINVAL;
 	}
 
@@ -3426,8 +3413,8 @@ int policydb_write(struct policydb *p, void *fp)
 	/* Write the version, config, and table sizes. */
 	info = policydb_lookup_compat(p->policyvers);
 	if (!info) {
-		printk(KERN_ERR "SELinux: compatibility lookup failed for policy "
-		    "version %d", p->policyvers);
+		pr_err("compatibility lookup failed for policy version %d\n",
+		       p->policyvers);
 		return -EINVAL;
 	}
 
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index 5d0144e..3cbeff3 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -39,6 +39,9 @@
  *	it under the terms of the GNU General Public License as published by
  *	the Free Software Foundation, version 2.
  */
+
+#define pr_fmt(fmt) "SELinux: " fmt
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/string.h>
@@ -143,9 +146,7 @@ static int selinux_set_mapping(struct policydb *pol,
 
 		p_out->value = string_to_security_class(pol, p_in->name);
 		if (!p_out->value) {
-			printk(KERN_INFO
-			       "SELinux:  Class %s not defined in policy.\n",
-			       p_in->name);
+			pr_info("Class %s not defined in policy\n", p_in->name);
 			if (pol->reject_unknown)
 				goto err;
 			p_out->num_perms = 0;
@@ -163,9 +164,8 @@ static int selinux_set_mapping(struct policydb *pol,
 			p_out->perms[k] = string_to_av_perm(pol, p_out->value,
 							    p_in->perms[k]);
 			if (!p_out->perms[k]) {
-				printk(KERN_INFO
-				       "SELinux:  Permission %s in class %s not defined in policy.\n",
-				       p_in->perms[k], p_in->name);
+				pr_info("Permission %s in class %s not defined in policy\n",
+					p_in->perms[k], p_in->name);
 				if (pol->reject_unknown)
 					goto err;
 				print_unknown_handle = true;
@@ -177,8 +177,8 @@ static int selinux_set_mapping(struct policydb *pol,
 	}
 
 	if (print_unknown_handle)
-		printk(KERN_INFO "SELinux: the above unknown classes and permissions will be %s\n",
-		       pol->allow_unknown ? "allowed" : "denied");
+		pr_info("the above unknown classes and permissions will be %s\n",
+			pol->allow_unknown ? "allowed" : "denied");
 
 	*out_map_p = out_map;
 	*out_map_size = i;
@@ -636,7 +636,7 @@ static void context_struct_compute_av(struct context *scontext,
 
 	if (unlikely(!tclass || tclass > policydb.p_classes.nprim)) {
 		if (printk_ratelimit())
-			printk(KERN_WARNING "SELinux:  Invalid class %hu\n", tclass);
+			pr_warn("Invalid class %hu\n", tclass);
 		return;
 	}
 
@@ -760,8 +760,7 @@ int security_validate_transition(u32 oldsid, u32 newsid, u32 tasksid,
 	tclass = unmap_class(orig_tclass);
 
 	if (!tclass || tclass > policydb.p_classes.nprim) {
-		printk(KERN_ERR "SELinux: %s:  unrecognized class %d\n",
-			__func__, tclass);
+		pr_err("%s: unrecognized class %d\n", __func__, tclass);
 		rc = -EINVAL;
 		goto out;
 	}
@@ -769,24 +768,21 @@ int security_validate_transition(u32 oldsid, u32 newsid, u32 tasksid,
 
 	ocontext = sidtab_search(&sidtab, oldsid);
 	if (!ocontext) {
-		printk(KERN_ERR "SELinux: %s:  unrecognized SID %d\n",
-			__func__, oldsid);
+		pr_err("%s: unrecognized SID %d\n", __func__, oldsid);
 		rc = -EINVAL;
 		goto out;
 	}
 
 	ncontext = sidtab_search(&sidtab, newsid);
 	if (!ncontext) {
-		printk(KERN_ERR "SELinux: %s:  unrecognized SID %d\n",
-			__func__, newsid);
+		pr_err("%s: unrecognized SID %d\n", __func__, newsid);
 		rc = -EINVAL;
 		goto out;
 	}
 
 	tcontext = sidtab_search(&sidtab, tasksid);
 	if (!tcontext) {
-		printk(KERN_ERR "SELinux: %s:  unrecognized SID %d\n",
-			__func__, tasksid);
+		pr_err("%s: unrecognized SID %d\n", __func__, tasksid);
 		rc = -EINVAL;
 		goto out;
 	}
@@ -828,16 +824,14 @@ int security_bounded_transition(u32 old_sid, u32 new_sid)
 	rc = -EINVAL;
 	old_context = sidtab_search(&sidtab, old_sid);
 	if (!old_context) {
-		printk(KERN_ERR "SELinux: %s: unrecognized SID %u\n",
-		       __func__, old_sid);
+		pr_err("%s: unrecognized SID %u\n", __func__, old_sid);
 		goto out;
 	}
 
 	rc = -EINVAL;
 	new_context = sidtab_search(&sidtab, new_sid);
 	if (!new_context) {
-		printk(KERN_ERR "SELinux: %s: unrecognized SID %u\n",
-		       __func__, new_sid);
+		pr_err("%s: unrecognized SID %u\n", __func__, new_sid);
 		goto out;
 	}
 
@@ -925,8 +919,7 @@ void security_compute_av(u32 ssid,
 
 	scontext = sidtab_search(&sidtab, ssid);
 	if (!scontext) {
-		printk(KERN_ERR "SELinux: %s:  unrecognized SID %d\n",
-		       __func__, ssid);
+		pr_err("%s: unrecognized SID %d\n", __func__, ssid);
 		goto out;
 	}
 
@@ -936,8 +929,7 @@ void security_compute_av(u32 ssid,
 
 	tcontext = sidtab_search(&sidtab, tsid);
 	if (!tcontext) {
-		printk(KERN_ERR "SELinux: %s:  unrecognized SID %d\n",
-		       __func__, tsid);
+		pr_err("%s: unrecognized SID %d\n", __func__, tsid);
 		goto out;
 	}
 
@@ -971,8 +963,7 @@ void security_compute_av_user(u32 ssid,
 
 	scontext = sidtab_search(&sidtab, ssid);
 	if (!scontext) {
-		printk(KERN_ERR "SELinux: %s:  unrecognized SID %d\n",
-		       __func__, ssid);
+		pr_err("%s: unrecognized SID %d\n", __func__, ssid);
 		goto out;
 	}
 
@@ -982,8 +973,7 @@ void security_compute_av_user(u32 ssid,
 
 	tcontext = sidtab_search(&sidtab, tsid);
 	if (!tcontext) {
-		printk(KERN_ERR "SELinux: %s:  unrecognized SID %d\n",
-		       __func__, tsid);
+		pr_err("%s: unrecognized SID %d\n", __func__, tsid);
 		goto out;
 	}
 
@@ -1095,8 +1085,8 @@ static int security_sid_to_context_core(u32 sid, char **scontext,
 			*scontext = scontextp;
 			goto out;
 		}
-		printk(KERN_ERR "SELinux: %s:  called before initial "
-		       "load_policy on unknown SID %d\n", __func__, sid);
+		pr_err("%s: called before initial load_policy on unknown SID %d\n",
+		       __func__, sid);
 		rc = -EINVAL;
 		goto out;
 	}
@@ -1106,8 +1096,7 @@ static int security_sid_to_context_core(u32 sid, char **scontext,
 	else
 		context = sidtab_search(&sidtab, sid);
 	if (!context) {
-		printk(KERN_ERR "SELinux: %s:  unrecognized SID %d\n",
-			__func__, sid);
+		pr_err("%s: unrecognized SID %d\n", __func__, sid);
 		rc = -EINVAL;
 		goto out_unlock;
 	}
@@ -1432,15 +1421,13 @@ static int security_compute_sid(u32 ssid,
 
 	scontext = sidtab_search(&sidtab, ssid);
 	if (!scontext) {
-		printk(KERN_ERR "SELinux: %s:  unrecognized SID %d\n",
-		       __func__, ssid);
+		pr_err("%s: unrecognized SID %d\n", __func__, ssid);
 		rc = -EINVAL;
 		goto out_unlock;
 	}
 	tcontext = sidtab_search(&sidtab, tsid);
 	if (!tcontext) {
-		printk(KERN_ERR "SELinux: %s:  unrecognized SID %d\n",
-		       __func__, tsid);
+		pr_err("%s: unrecognized SID %d\n", __func__, tsid);
 		rc = -EINVAL;
 		goto out_unlock;
 	}
@@ -1653,7 +1640,7 @@ static inline int convert_context_handle_invalid_context(struct context *context
 		return -EINVAL;
 
 	if (!context_struct_to_string(context, &s, &len)) {
-		printk(KERN_WARNING "SELinux:  Context %s would be invalid if enforcing\n", s);
+		pr_warn("Context %s would be invalid if enforcing\n", s);
 		kfree(s);
 	}
 	return 0;
@@ -1703,8 +1690,7 @@ static int convert_context(u32 key,
 					      c->len, &ctx, SECSID_NULL);
 		kfree(s);
 		if (!rc) {
-			printk(KERN_INFO "SELinux:  Context %s became valid (mapped).\n",
-			       c->str);
+			pr_info("Context %s became valid (mapped)\n", c->str);
 			/* Replace string with mapped representation. */
 			kfree(c->str);
 			memcpy(c, &ctx, sizeof(*c));
@@ -1715,7 +1701,7 @@ static int convert_context(u32 key,
 			goto out;
 		} else {
 			/* Other error condition, e.g. ENOMEM. */
-			printk(KERN_ERR "SELinux:   Unable to map context %s, rc = %d.\n",
+			pr_err("Unable to map context %s, rc = %d\n",
 			       c->str, -rc);
 			goto out;
 		}
@@ -1774,8 +1760,7 @@ static int convert_context(u32 key,
 			oc = oc->next;
 		rc = -EINVAL;
 		if (!oc) {
-			printk(KERN_ERR "SELinux:  unable to look up"
-				" the initial SIDs list\n");
+			pr_err("unable to look up the initial SIDs list\n");
 			goto bad;
 		}
 		range = &oc->context[0].range;
@@ -1805,8 +1790,7 @@ bad:
 	context_destroy(c);
 	c->str = s;
 	c->len = len;
-	printk(KERN_INFO "SELinux:  Context %s became invalid (unmapped).\n",
-	       c->str);
+	pr_info("Context %s became invalid (unmapped)\n", c->str);
 	rc = 0;
 	goto out;
 }
@@ -1899,13 +1883,13 @@ int security_load_policy(void *data, size_t len)
 	newpolicydb->len = len;
 	/* If switching between different policy types, log MLS status */
 	if (policydb.mls_enabled && !newpolicydb->mls_enabled)
-		printk(KERN_INFO "SELinux: Disabling MLS support...\n");
+		pr_info("Disabling MLS support...\n");
 	else if (!policydb.mls_enabled && newpolicydb->mls_enabled)
-		printk(KERN_INFO "SELinux: Enabling MLS support...\n");
+		pr_info("Enabling MLS support...\n");
 
 	rc = policydb_load_isids(newpolicydb, &newsidtab);
 	if (rc) {
-		printk(KERN_ERR "SELinux:  unable to load the initial SIDs\n");
+		pr_err("unable to load the initial SIDs\n");
 		policydb_destroy(newpolicydb);
 		goto out;
 	}
@@ -1916,7 +1900,7 @@ int security_load_policy(void *data, size_t len)
 
 	rc = security_preserve_bools(newpolicydb);
 	if (rc) {
-		printk(KERN_ERR "SELinux:  unable to preserve booleans\n");
+		pr_err("unable to preserve booleans\n");
 		goto err;
 	}
 
@@ -1935,9 +1919,7 @@ int security_load_policy(void *data, size_t len)
 	args.newp = newpolicydb;
 	rc = sidtab_map(&newsidtab, convert_context, &args);
 	if (rc) {
-		printk(KERN_ERR "SELinux:  unable to convert the internal"
-			" representation of contexts in the new SID"
-			" table\n");
+		pr_err("unable to convert the internal representation of contexts in the new SID table\n");
 		goto err;
 	}
 
@@ -2557,16 +2539,14 @@ int security_sid_mls_copy(u32 sid, u32 mls_sid, u32 *new_sid)
 	rc = -EINVAL;
 	context1 = sidtab_search(&sidtab, sid);
 	if (!context1) {
-		printk(KERN_ERR "SELinux: %s:  unrecognized SID %d\n",
-			__func__, sid);
+		pr_err("%s: unrecognized SID %d\n", __func__, sid);
 		goto out_unlock;
 	}
 
 	rc = -EINVAL;
 	context2 = sidtab_search(&sidtab, mls_sid);
 	if (!context2) {
-		printk(KERN_ERR "SELinux: %s:  unrecognized SID %d\n",
-			__func__, mls_sid);
+		pr_err("%s: unrecognized SID %d\n", __func__, mls_sid);
 		goto out_unlock;
 	}
 
@@ -2654,15 +2634,13 @@ int security_net_peersid_resolve(u32 nlbl_sid, u32 nlbl_type,
 	rc = -EINVAL;
 	nlbl_ctx = sidtab_search(&sidtab, nlbl_sid);
 	if (!nlbl_ctx) {
-		printk(KERN_ERR "SELinux: %s:  unrecognized SID %d\n",
-		       __func__, nlbl_sid);
+		pr_err("%s: unrecognized SID %d\n", __func__, nlbl_sid);
 		goto out;
 	}
 	rc = -EINVAL;
 	xfrm_ctx = sidtab_search(&sidtab, xfrm_sid);
 	if (!xfrm_ctx) {
-		printk(KERN_ERR "SELinux: %s:  unrecognized SID %d\n",
-		       __func__, xfrm_sid);
+		pr_err("%s: unrecognized SID %d\n", __func__, xfrm_sid);
 		goto out;
 	}
 	rc = (mls_context_cmp(nlbl_ctx, xfrm_ctx) ? 0 : -EACCES);
@@ -2742,8 +2720,7 @@ int security_get_permissions(char *class, char ***perms, int *nperms)
 	rc = -EINVAL;
 	match = hashtab_search(policydb.p_classes.table, class);
 	if (!match) {
-		printk(KERN_ERR "SELinux: %s:  unrecognized class %s\n",
-			__func__, class);
+		pr_err("%s: unrecognized class %s\n", __func__, class);
 		goto out;
 	}
 
diff --git a/security/selinux/ss/sidtab.c b/security/selinux/ss/sidtab.c
index 5840a35..aef422a 100644
--- a/security/selinux/ss/sidtab.c
+++ b/security/selinux/ss/sidtab.c
@@ -3,6 +3,9 @@
  *
  * Author : Stephen Smalley, <sds@epoch.ncsc.mil>
  */
+
+#define pr_fmt(fmt) "SELinux: " fmt
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
@@ -220,9 +223,8 @@ int sidtab_context_to_sid(struct sidtab *s,
 		}
 		sid = s->next_sid++;
 		if (context->len)
-			printk(KERN_INFO
-		       "SELinux:  Context %s is not valid (left unmapped).\n",
-			       context->str);
+			pr_info("Context %s is not valid (left unmapped)\n",
+				context->str);
 		ret = sidtab_insert(s, sid, context);
 		if (ret)
 			s->next_sid--;
-- 
1.8.1.2.459.gbcd45b4.dirty

