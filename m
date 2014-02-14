Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbaBNWCc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 17:02:32 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:33690 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951AbaBNWCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 17:02:31 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH v2 03/11] sysfs: create bin_attributes under the requested group
Date: Fri, 14 Feb 2014 14:02:07 -0800
Message-Id: <1392415338-16288-4-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.4
In-Reply-To: <1392415338-16288-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1392415338-16288-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021422-0320-0000-0000-000002781659
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bin_attributes created/updated in create_files() (such as those listed
via (struct device).attribute_groups) were not placed under the
specified group, and instead appeared in the base kobj directory.

Fix this by making bin_attributes use creating code similar to normal
attributes.

A quick grep shows that no one is using bin_attrs in a named attribute
group yet, so we can do this without breaking anything in usespace.

Note that I do not add is_visible() support to
bin_attributes, though that could be done as well.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 fs/sysfs/group.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index 6b57938..aa04068 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -70,8 +70,11 @@ static int create_files(struct kernfs_node *parent, struct kobject *kobj,
 	if (grp->bin_attrs) {
 		for (bin_attr = grp->bin_attrs; *bin_attr; bin_attr++) {
 			if (update)
-				sysfs_remove_bin_file(kobj, *bin_attr);
-			error = sysfs_create_bin_file(kobj, *bin_attr);
+				kernfs_remove_by_name(parent,
+						(*bin_attr)->attr.name);
+			error = sysfs_add_file_mode_ns(parent,
+					&(*bin_attr)->attr, true,
+					(*bin_attr)->attr.mode, NULL);
 			if (error)
 				break;
 		}
-- 
1.8.5.4

