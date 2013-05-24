Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386Ab3EXSYB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 14:24:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57554 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757350Ab3EXSX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 14:23:58 -0400
Date: Fri, 24 May 2013 11:23:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 3.0.80
Message-ID: <20130524182357.GB3110@kroah.com>
References: <20130524182347.GA3110@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130524182347.GA3110@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


diff --git a/Makefile b/Makefile
index f8ade05..dad194f 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION = 3
 PATCHLEVEL = 0
-SUBLEVEL = 79
+SUBLEVEL = 80
 EXTRAVERSION =
 NAME = Sneaky Weasel
 
diff --git a/drivers/hwmon/abituguru.c b/drivers/hwmon/abituguru.c
index 65a35cf..61ab615 100644
--- a/drivers/hwmon/abituguru.c
+++ b/drivers/hwmon/abituguru.c
@@ -1280,14 +1280,18 @@ static int __devinit abituguru_probe(struct platform_device *pdev)
 	pr_info("found Abit uGuru\n");
 
 	/* Register sysfs hooks */
-	for (i = 0; i < sysfs_attr_i; i++)
-		if (device_create_file(&pdev->dev,
-				&data->sysfs_attr[i].dev_attr))
+	for (i = 0; i < sysfs_attr_i; i++) {
+		res = device_create_file(&pdev->dev,
+					 &data->sysfs_attr[i].dev_attr);
+		if (res)
 			goto abituguru_probe_error;
-	for (i = 0; i < ARRAY_SIZE(abituguru_sysfs_attr); i++)
-		if (device_create_file(&pdev->dev,
-				&abituguru_sysfs_attr[i].dev_attr))
+	}
+	for (i = 0; i < ARRAY_SIZE(abituguru_sysfs_attr); i++) {
+		res = device_create_file(&pdev->dev,
+					 &abituguru_sysfs_attr[i].dev_attr);
+		if (res)
 			goto abituguru_probe_error;
+	}
 
 	data->hwmon_dev = hwmon_device_register(&pdev->dev);
 	if (!IS_ERR(data->hwmon_dev))
diff --git a/drivers/media/dvb/mantis/mantis_dvb.c b/drivers/media/dvb/mantis/mantis_dvb.c
index e5180e4..5d15c6b 100644
--- a/drivers/media/dvb/mantis/mantis_dvb.c
+++ b/drivers/media/dvb/mantis/mantis_dvb.c
@@ -248,8 +248,10 @@ int __devinit mantis_dvb_init(struct mantis_pci *mantis)
 err5:
 	tasklet_kill(&mantis->tasklet);
 	dvb_net_release(&mantis->dvbnet);
-	dvb_unregister_frontend(mantis->fe);
-	dvb_frontend_detach(mantis->fe);
+	if (mantis->fe) {
+		dvb_unregister_frontend(mantis->fe);
+		dvb_frontend_detach(mantis->fe);
+	}
 err4:
 	mantis->demux.dmx.remove_frontend(&mantis->demux.dmx, &mantis->fe_mem);
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a3c4751..a205027 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1539,7 +1539,11 @@ static noinline int copy_to_sk(struct btrfs_root *root,
 		item_off = btrfs_item_ptr_offset(leaf, i);
 		item_len = btrfs_item_size_nr(leaf, i);
 
-		if (item_len > BTRFS_SEARCH_ARGS_BUFSIZE)
+		btrfs_item_key_to_cpu(leaf, key, i);
+		if (!key_in_sk(key, sk))
+			continue;
+
+		if (sizeof(sh) + item_len > BTRFS_SEARCH_ARGS_BUFSIZE)
 			item_len = 0;
 
 		if (sizeof(sh) + item_len + *sk_offset >
@@ -1548,10 +1552,6 @@ static noinline int copy_to_sk(struct btrfs_root *root,
 			goto overflow;
 		}
 
-		btrfs_item_key_to_cpu(leaf, key, i);
-		if (!key_in_sk(key, sk))
-			continue;
-
 		sh.objectid = key->objectid;
 		sh.offset = key->offset;
 		sh.type = key->type;
