Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735Ab3AOWfe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:35:34 -0500
Received: from mail.kernel.org ([198.145.19.201]:43573 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932702Ab3AOWf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:35:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Denis Kirjanov <kirjanov@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>
Subject: [ 187/221] EDAC: Fix kernel panic on module unloading
Date: Tue, 15 Jan 2013 10:51:54 -0800
Message-Id: <20130115185011.519323969@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Khlebnikov <khlebnikov@openvz.org>

commit 311bd84247ee0bedae6cdfbfc5e2c3450f9decd1 upstream.

This patch fixes use-after-free and double-free bugs in
edac_mc_sysfs_exit(). mci_pdev has single reference and put_device()
calls mc_attr_release() which calls kfree(). The following
device_del() works with already released memory. An another kfree() in
edac_mc_sysfs_exit() releses the same memory again. Great.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Denis Kirjanov <kirjanov@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Link: http://lkml.kernel.org/r/20121214110310.11019.21098.stgit@zurg
Signed-off-by: Borislav Petkov <bp@alien8.de>
[ a partial 3.7.y backport ]
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/edac/edac_mc_sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -1145,7 +1145,7 @@ int __init edac_mc_sysfs_init(void)
 
 void __exit edac_mc_sysfs_exit(void)
 {
-	put_device(mci_pdev);
 	device_del(mci_pdev);
+	put_device(mci_pdev);
 	edac_put_sysfs_subsys();
 }


