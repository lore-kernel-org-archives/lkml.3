Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab3LEXqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 18:46:35 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:50651 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab3LEXqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 18:46:31 -0500
Subject: [PATCH 1/2] firmware: dmi-sysfs: Don't remove dmi-sysfs "raw" file
 explicitly
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, Mike Waychison <mikew@google.com>
Date: Thu, 05 Dec 2013 16:46:28 -0700
Message-ID: <20131205234628.26412.27225.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20131205234448.26412.62189.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20131205234448.26412.62189.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing the dmi-sysfs module causes the following warning:

  # modprobe -r dmi_sysfs
  WARNING: CPU: 11 PID: 6785 at fs/sysfs/inode.c:325 sysfs_hash_and_remove+0xa9/0xb0()
  sysfs: can not remove 'raw', no directory

This is because putting the entry kobject, e.g., for
"/sys/firmware/dmi/entries/19-0", removes the directory and all its
contents.  By the time dmi_sysfs_entry_release() runs, the "raw" file
inside ".../19-0/" has already been removed.

Therefore, we don't need to remove the "raw" bin file at all in
dmi_sysfs_entry_release().

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/firmware/dmi-sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/dmi-sysfs.c b/drivers/firmware/dmi-sysfs.c
index eb26d62e5188..66200ed5e6a1 100644
--- a/drivers/firmware/dmi-sysfs.c
+++ b/drivers/firmware/dmi-sysfs.c
@@ -553,7 +553,7 @@ static const struct bin_attribute dmi_entry_raw_attr = {
 static void dmi_sysfs_entry_release(struct kobject *kobj)
 {
 	struct dmi_sysfs_entry *entry = to_entry(kobj);
-	sysfs_remove_bin_file(&entry->kobj, &dmi_entry_raw_attr);
+
 	spin_lock(&entry_list_lock);
 	list_del(&entry->list);
 	spin_unlock(&entry_list_lock);

