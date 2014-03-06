Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbaCFVLy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 16:11:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753646AbaCFVLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 16:11:53 -0500
Date: Thu, 6 Mar 2014 16:11:41 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: linux-mm@kvack.org, cl@linux-foundation.org, penberg@kernel.org
Subject: slub: fix leak of 'name' in sysfs_slab_add
Message-ID: <20140306211141.GA17009@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
	cl@linux-foundation.org, penberg@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The failure paths of sysfs_slab_add don't release the allocation of 'name'
made by create_unique_id() a few lines above the context of the diff below.
Create a common exit path to make it more obvious what needs freeing.

Signed-off-by: Dave Jones <davej@fedoraproject.org>

diff --git a/mm/slub.c b/mm/slub.c
index 25f14ad8f817..b2181d2682ac 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5197,17 +5197,13 @@ static int sysfs_slab_add(struct kmem_cache *s)
 
 	s->kobj.kset = slab_kset;
 	err = kobject_init_and_add(&s->kobj, &slab_ktype, NULL, "%s", name);
-	if (err) {
-		kobject_put(&s->kobj);
-		return err;
-	}
+	if (err)
+		goto err_out;
 
 	err = sysfs_create_group(&s->kobj, &slab_attr_group);
-	if (err) {
-		kobject_del(&s->kobj);
-		kobject_put(&s->kobj);
-		return err;
-	}
+	if (err)
+		goto err_sysfs;
+
 	kobject_uevent(&s->kobj, KOBJ_ADD);
 	if (!unmergeable) {
 		/* Setup first alias */
@@ -5215,6 +5211,13 @@ static int sysfs_slab_add(struct kmem_cache *s)
 		kfree(name);
 	}
 	return 0;
+
+err_sysfs:
+	kobject_del(&s->kobj);
+err_out:
+	kobject_put(&s->kobj);
+	kfree(name);
+	return err;
 }
 
 static void sysfs_slab_remove(struct kmem_cache *s)
