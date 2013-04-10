Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936747Ab3DJWYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:24:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55848 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935383Ab3DJWYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:24:06 -0400
Date: Wed, 10 Apr 2013 15:24:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Toshi Kani <toshi.kani@hp.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linuxram@us.ibm.com,
        guz.fnst@cn.fujitsu.com, tmac@hp.com, isimatu.yasuaki@jp.fujitsu.com,
        wency@cn.fujitsu.com, tangchen@cn.fujitsu.com, jiang.liu@huawei.com
Subject: Re: [PATCH v3 2/3] resource: Add release_mem_region_adjustable()
Message-Id: <20130410152404.e0836af597ba3545b9846672@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.02.1304101505250.1526@chino.kir.corp.google.com>
References: <1365614221-685-1-git-send-email-toshi.kani@hp.com>
	<1365614221-685-3-git-send-email-toshi.kani@hp.com>
	<20130410144412.395bf9f2fb8192920175e30a@linux-foundation.org>
	<1365630585.32127.110.camel@misato.fc.hp.com>
	<alpine.DEB.2.02.1304101505250.1526@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Apr 2013 15:08:29 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:

> On Wed, 10 Apr 2013, Toshi Kani wrote:
> 
> > > I'll switch it to GFP_ATOMIC.  Which is horridly lame but the
> > > allocation is small and alternatives are unobvious.
> > 
> > Great!  Again, thanks for the update!
> 
> release_mem_region_adjustable() allocates at most one struct resource, so 
> why not do kmalloc(sizeof(struct resource), GFP_KERNEL) before taking 
> resource_lock and then testing whether it's NULL or not when splitting?  
> It unnecessarily allocates memory when there's no split, but 
> __remove_pages() shouldn't be a hotpath.

yup.

--- a/kernel/resource.c~resource-add-release_mem_region_adjustable-fix-fix
+++ a/kernel/resource.c
@@ -1046,7 +1046,8 @@ int release_mem_region_adjustable(struct
 			resource_size_t start, resource_size_t size)
 {
 	struct resource **p;
-	struct resource *res, *new;
+	struct resource *res;
+	struct resource *new_res;
 	resource_size_t end;
 	int ret = -EINVAL;
 
@@ -1054,6 +1055,9 @@ int release_mem_region_adjustable(struct
 	if ((start < parent->start) || (end > parent->end))
 		return ret;
 
+	/* The kzalloc() result gets checked later */
+	new_res = kzalloc(sizeof(struct resource), GFP_KERNEL);
+
 	p = &parent->child;
 	write_lock(&resource_lock);
 
@@ -1091,32 +1095,33 @@ int release_mem_region_adjustable(struct
 						start - res->start);
 		} else {
 			/* split into two entries */
-			new = kzalloc(sizeof(struct resource), GFP_ATOMIC);
-			if (!new) {
+			if (!new_res) {
 				ret = -ENOMEM;
 				break;
 			}
-			new->name = res->name;
-			new->start = end + 1;
-			new->end = res->end;
-			new->flags = res->flags;
-			new->parent = res->parent;
-			new->sibling = res->sibling;
-			new->child = NULL;
+			new_res->name = res->name;
+			new_res->start = end + 1;
+			new_res->end = res->end;
+			new_res->flags = res->flags;
+			new_res->parent = res->parent;
+			new_res->sibling = res->sibling;
+			new_res->child = NULL;
 
 			ret = __adjust_resource(res, res->start,
 						start - res->start);
 			if (ret) {
-				kfree(new);
+				kfree(new_res);
 				break;
 			}
-			res->sibling = new;
+			res->sibling = new_res;
+			new_res = NULL;
 		}
 
 		break;
 	}
 
 	write_unlock(&resource_lock);
+	kfree(new_res);
 	return ret;
 }
 #endif	/* CONFIG_MEMORY_HOTPLUG */
_

