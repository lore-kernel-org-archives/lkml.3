Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab3I2BFS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 21:05:18 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:59743 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751560Ab3I2BFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 21:05:15 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Ronald <ronald645@gmail.com>
Cc: linux-kernel@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: Fwd: [v3.12-rc1] [regression] PM / hibernate: Create memory bitmaps after freezing user space
Date: Sun, 29 Sep 2013 03:16:40 +0200
Message-ID: <6939844.AIXnPB8Wdj@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAF1_xX0suiHSgqWRBrA66qc1A_32Xq08hOikM2VSwQOEgRH-RA@mail.gmail.com>
References: <CAF1_xX2=BYkEn3ycM4smREqk-ioGbvu8Ea4or22U-jBdKmDKGA@mail.gmail.com> <CAF1_xX0suiHSgqWRBrA66qc1A_32Xq08hOikM2VSwQOEgRH-RA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, September 28, 2013 08:18:18 PM Ronald wrote:
> [ resend, forgot to disable HTML (sorry!) ]
> 
> Dear kernel developers,
> 
> Commit 8fd37a4c9 (PM / hibernate: Create memory bitmaps after freezing
> user space) causes resume to fail.
> 
> Only, when using the s2disk utility (through pm-hibernate).
> 
> Not when I do:
> 
> echo -n "disk" > /sys/power/state
> 
> Reverting the commit did not work.
> 
> I am using a encrypted LUKS partition with a temporary key that is
> functioning as the swap device used for the suspend image.
> 
> Awaiting further orders....

I'm traveling now, so I can't really test things, but I think I know what the
problem is.

Can you please check if the appended patch makes any difference for you?

Rafael


---
 kernel/power/snapshot.c |    5 ++++-
 kernel/power/user.c     |    5 +++++
 2 files changed, 9 insertions(+), 1 deletion(-)

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
@@ -82,6 +82,9 @@ static int snapshot_open(struct inode *i
 		data->swap = -1;
 		data->mode = O_WRONLY;
 		error = pm_notifier_call_chain(PM_RESTORE_PREPARE);
+		if (!error)
+			error = create_basic_memory_bitmaps();
+
 		if (error)
 			pm_notifier_call_chain(PM_POST_RESTORE);
 	}

