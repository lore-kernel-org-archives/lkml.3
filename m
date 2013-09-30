Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab3I3ABZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 20:01:25 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:53021 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752210Ab3I3ABX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 20:01:23 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Ronald <ronald645@gmail.com>
Cc: linux-kernel@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: Fwd: [v3.12-rc1] [regression] PM / hibernate: Create memory bitmaps after freezing user space
Date: Mon, 30 Sep 2013 02:12:48 +0200
Message-ID: <18917329.YEy4ieURCA@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAF1_xX0zQriGMKvH8aLs4GhmCnLGSd7C2ESTvsOQvB7q22Mk8Q@mail.gmail.com>
References: <CAF1_xX2=BYkEn3ycM4smREqk-ioGbvu8Ea4or22U-jBdKmDKGA@mail.gmail.com> <6939844.AIXnPB8Wdj@vostro.rjw.lan> <CAF1_xX0zQriGMKvH8aLs4GhmCnLGSd7C2ESTvsOQvB7q22Mk8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, September 29, 2013 09:22:45 AM Ronald wrote:
> Attached patch fixes the issue. Both methods function as they did
> before. Thanks for the superfast fix!

You're welcome, it's not the final one, however.

Can you please test the one below and report back?

Rafael


---
 kernel/power/snapshot.c |    5 ++++-
 kernel/power/user.c     |    8 ++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

Index: linux-pm/kernel/power/snapshot.c
===================================================================
--- linux-pm.orig/kernel/power/snapshot.c
+++ linux-pm/kernel/power/snapshot.c
@@ -743,7 +743,10 @@ int create_basic_memory_bitmaps(void)
 	struct memory_bitmap *bm1, *bm2;
 	int error = 0;
 
-	BUG_ON(forbidden_pages_map || free_pages_map);
+	if (forbidden_pages_map && free_pages_map)
+		return 0;
+	else
+		BUG_ON(forbidden_pages_map || free_pages_map);
 
 	bm1 = kzalloc(sizeof(struct memory_bitmap), GFP_KERNEL);
 	if (!bm1)
Index: linux-pm/kernel/power/user.c
===================================================================
--- linux-pm.orig/kernel/power/user.c
+++ linux-pm/kernel/power/user.c
@@ -39,6 +39,7 @@ static struct snapshot_data {
 	char frozen;
 	char ready;
 	char platform_support;
+	bool free_bitmaps;
 } snapshot_state;
 
 atomic_t snapshot_device_available = ATOMIC_INIT(1);
@@ -82,6 +83,10 @@ static int snapshot_open(struct inode *i
 		data->swap = -1;
 		data->mode = O_WRONLY;
 		error = pm_notifier_call_chain(PM_RESTORE_PREPARE);
+		if (!error) {
+			error = create_basic_memory_bitmaps();
+			data->free_bitmaps = !error;
+		}
 		if (error)
 			pm_notifier_call_chain(PM_POST_RESTORE);
 	}
@@ -111,6 +116,8 @@ static int snapshot_release(struct inode
 		pm_restore_gfp_mask();
 		free_basic_memory_bitmaps();
 		thaw_processes();
+	} else if (data->free_bitmaps) {
+		free_basic_memory_bitmaps();
 	}
 	pm_notifier_call_chain(data->mode == O_RDONLY ?
 			PM_POST_HIBERNATION : PM_POST_RESTORE);
@@ -231,6 +238,7 @@ static long snapshot_ioctl(struct file *
 			break;
 		pm_restore_gfp_mask();
 		free_basic_memory_bitmaps();
+		data->free_bitmaps = false;
 		thaw_processes();
 		data->frozen = 0;
 		break;

