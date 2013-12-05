Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295Ab3LEXqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 18:46:44 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:33364 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137Ab3LEXqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 18:46:38 -0500
Subject: [PATCH 2/2] firmware: dmi-sysfs: Remove "dmi" directory on module
 exit
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, Mike Waychison <mikew@google.com>
Date: Thu, 05 Dec 2013 16:46:35 -0700
Message-ID: <20131205234635.26412.9670.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20131205234448.26412.62189.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20131205234448.26412.62189.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With CONFIG_DEBUG_KOBJECT_RELEASE=y, removing and immediately reloading the
dmi-sysfs module causes the following warning:

  sysfs: cannot create duplicate filename '/firmware/dmi'
  kobject_add_internal failed for dmi with -EEXIST, don't try to register things with the same name in the same directory.

The "dmi" directory stays in sysfs until the dmi_kobj is released, and
DEBUG_KOBJECT_RELEASE delays that.

I don't think we can hit this problem in normal usage because dmi_kobj is
static and nothing outside dmi-sysfs can get a reference to it, so the
only way to delay the "dmi" release is with DEBUG_KOBJECT_RELEASE.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/firmware/dmi-sysfs.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/dmi-sysfs.c b/drivers/firmware/dmi-sysfs.c
index 66200ed5e6a1..e0f1cb3d3598 100644
--- a/drivers/firmware/dmi-sysfs.c
+++ b/drivers/firmware/dmi-sysfs.c
@@ -685,6 +685,7 @@ static void __exit dmi_sysfs_exit(void)
 	pr_debug("dmi-sysfs: unloading.\n");
 	cleanup_entry_list();
 	kset_unregister(dmi_kset);
+	kobject_del(dmi_kobj);
 	kobject_put(dmi_kobj);
 }
 

