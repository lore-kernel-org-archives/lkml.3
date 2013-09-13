Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859Ab3IMAvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 20:51:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:3867 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755407Ab3IMAvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 20:51:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,894,1371106800"; 
   d="scan'208";a="395020719"
Date: Fri, 13 Sep 2013 08:51:33 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Tejun Heo <tj@kernel.org>
Subject: increased vmap_area_lock contentions on "n_tty: Move buffers into
 n_tty_data"
Message-ID: <20130913005133.GA32479@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Peter,

FYI, we noticed much increased vmap_area_lock contentions since this
commit:

commit 20bafb3d23d108bc0a896eb8b7c1501f4f649b77
Author: Peter Hurley <peter@hurleysoftware.com>
Date:   Sat Jun 15 10:21:19 2013 -0400

    n_tty: Move buffers into n_tty_data
    
    Reduce pointer reloading and improve locality-of-reference;
    allocate read_buf and echo_buf within struct n_tty_data.
    
    Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

:040000 040000 96d92e4e242c4b2ff11b25c005bccd093865b350 2822d87b2425c3e7adc7b722a20d739c9d4a3046 M	drivers
bisect run success

# bad: [9cdfea961eeaf9b6b939fb9dc822a204a1d94d08] Merge remote-tracking branch 'ipvs-next/master' into devel-hourly-2013090112
# good: [d4e4ab86bcba5a72779c43dc1459f71fea3d89c8] Linux 3.11-rc5
git bisect start '9cdfea961eeaf9b6b939fb9dc822a204a1d94d08' 'd4e4ab86bcba5a72779c43dc1459f71fea3d89c8' '--'
# good: [903bc7e8c2a4f9ef8e40aed615ed48023f9460e3] Merge remote-tracking branch 'spi/for-next'
git bisect good 903bc7e8c2a4f9ef8e40aed615ed48023f9460e3
# bad: [d926318427c1fa8df182d3dcd7f802d7d0609225] Merge remote-tracking branch 'bcon/master'
git bisect bad d926318427c1fa8df182d3dcd7f802d7d0609225
# bad: [adcb2bcd0dd2bb88f21180c8ffb9ec2549f4d883] Merge remote-tracking branch 'usb/usb-next'
git bisect bad adcb2bcd0dd2bb88f21180c8ffb9ec2549f4d883
# good: [a83605266423437d8afe73cbd538df33cf8fb32b] Merge remote-tracking branch 'driver-core/driver-core-next'
git bisect good a83605266423437d8afe73cbd538df33cf8fb32b
# good: [224563b6ce034b82f8511969d9496113da34fb2c] Merge tag 'for-usb-next-2013-08-15' of git://git.kernel.org/pub/scm/linux/kernel/git/sarah/xhci into usb-next
git bisect good 224563b6ce034b82f8511969d9496113da34fb2c
# bad: [5284eba7b37dfeffe75bfdf81a13e9efebe0480a] serial/arc-uart: Handle Rx Error Interrupts w/o any data
git bisect bad 5284eba7b37dfeffe75bfdf81a13e9efebe0480a
# bad: [7d88d637a3c75257b7611f9feee0c17fa187ecc9] n_tty: Factor standard per-char i/o into separate fn
git bisect bad 7d88d637a3c75257b7611f9feee0c17fa187ecc9
# good: [11b9faa44df76189b8346ff602a2c01c610c37eb] tty: Merge tty_buffer_find() into tty_buffer_alloc()
git bisect good 11b9faa44df76189b8346ff602a2c01c610c37eb
# good: [019ebdf9f26fd2e43b9e1af576835183e95dc82e] n_tty: Eliminate echo_commit memory barrier
git bisect good 019ebdf9f26fd2e43b9e1af576835183e95dc82e
# bad: [1bb9d562856279a217a4e581a803dee9bb48a708] n_tty: Rename process_char_map to char_map
git bisect bad 1bb9d562856279a217a4e581a803dee9bb48a708
# good: [9dfd16ddea9bdbc8343340e543732db0a467ae32] n_tty: Avoid false-sharing echo buffer indices
git bisect good 9dfd16ddea9bdbc8343340e543732db0a467ae32
# good: [8cb06c983822103da1cfe57b9901e60a00e61f67] n_tty: Remove alias ptrs in __receive_buf()
git bisect good 8cb06c983822103da1cfe57b9901e60a00e61f67
# bad: [20bafb3d23d108bc0a896eb8b7c1501f4f649b77] n_tty: Move buffers into n_tty_data
git bisect bad 20bafb3d23d108bc0a896eb8b7c1501f4f649b77
# first bad commit: [20bafb3d23d108bc0a896eb8b7c1501f4f649b77] n_tty: Move buffers into n_tty_data


Compare of all good/bad commits in this bisect:

                        lock_stat.vmap_area_lock.contentions

   22000 ++-----------------------------------------------------------------+
   20000 ++O    O O O    O O O O OO O O   OO O O O OO   O O O O  O O O O    |
         O   OO       OO                O             O        O            |
   18000 ++                                                                 |
   16000 ++                                                                 |
         |                                                                  |
   14000 ++                                                                 |
   12000 ++                                                                 |
   10000 ++                                                                 |
         |                                                                  |
    8000 ++                                                                 |
    6000 ++                                                                 |
         |                                                                  |
    4000 *+*.**.*.*.*.**.*.*.*.*.**.*.*.*.**.*.*.*.**.*.*.*.*.**.*.*.*.**.*.*
    2000 ++-----------------------------------------------------------------+


                lock_stat.vmap_area_lock.contentions.get_vmalloc_info

   45000 ++-----------------------------------------------------------------+
         | O                   O    O            O      O   O      O        |
   40000 O+  OO O O O OO O O O   OO   O O OO O O   OO O   O   OO O   O O    |
   35000 ++                                                                 |
         |                                                                  |
   30000 ++                                                                 |
         |                                                                  |
   25000 ++                                                                 |
         |                                                                  |
   20000 ++                                                                 |
   15000 ++                                                                 |
         |                                                                  |
   10000 ++                                                                 |
         |                        *.*.     *. .*.          .*.  .*.*.       |
    5000 *+*-**-*-*-*-**-*-*-*-*-*----*-*-*--*---*-**-*-*-*---**-----*-**-*-*


--LQksG6bCIzRHxTLp
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-n_tty-Move-buffers-into-n_tty_data.patch"

>From 20bafb3d23d108bc0a896eb8b7c1501f4f649b77 Mon Sep 17 00:00:00 2001
From: Peter Hurley <peter@hurleysoftware.com>
Date: Sat, 15 Jun 2013 10:21:19 -0400
Subject: [PATCH] n_tty: Move buffers into n_tty_data

Reduce pointer reloading and improve locality-of-reference;
allocate read_buf and echo_buf within struct n_tty_data.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_tty.c | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index d6eba99..51cbdd2 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -105,9 +105,9 @@ struct n_tty_data {
 	unsigned char lnext:1, erasing:1, raw:1, real_raw:1, icanon:1;
 
 	/* shared by producer and consumer */
-	char *read_buf;
+	char read_buf[N_TTY_BUF_SIZE];
 	DECLARE_BITMAP(read_flags, N_TTY_BUF_SIZE);
-	unsigned char *echo_buf;
+	unsigned char echo_buf[N_TTY_BUF_SIZE];
 
 	int minimum_to_wake;
 
@@ -1695,9 +1695,7 @@ static void n_tty_close(struct tty_struct *tty)
 	if (tty->link)
 		n_tty_packet_mode_flush(tty);
 
-	kfree(ldata->read_buf);
-	kfree(ldata->echo_buf);
-	kfree(ldata);
+	vfree(ldata);
 	tty->disc_data = NULL;
 }
 
@@ -1715,7 +1713,8 @@ static int n_tty_open(struct tty_struct *tty)
 {
 	struct n_tty_data *ldata;
 
-	ldata = kzalloc(sizeof(*ldata), GFP_KERNEL);
+	/* Currently a malloc failure here can panic */
+	ldata = vmalloc(sizeof(*ldata));
 	if (!ldata)
 		goto err;
 
@@ -1723,16 +1722,14 @@ static int n_tty_open(struct tty_struct *tty)
 	mutex_init(&ldata->atomic_read_lock);
 	mutex_init(&ldata->output_lock);
 
-	/* These are ugly. Currently a malloc failure here can panic */
-	ldata->read_buf = kzalloc(N_TTY_BUF_SIZE, GFP_KERNEL);
-	ldata->echo_buf = kzalloc(N_TTY_BUF_SIZE, GFP_KERNEL);
-	if (!ldata->read_buf || !ldata->echo_buf)
-		goto err_free_bufs;
-
 	tty->disc_data = ldata;
 	reset_buffer_flags(tty->disc_data);
 	ldata->column = 0;
+	ldata->canon_column = 0;
 	ldata->minimum_to_wake = 1;
+	ldata->num_overrun = 0;
+	ldata->no_room = 0;
+	ldata->lnext = 0;
 	tty->closing = 0;
 	/* indicate buffer work may resume */
 	clear_bit(TTY_LDISC_HALTED, &tty->flags);
@@ -1740,10 +1737,6 @@ static int n_tty_open(struct tty_struct *tty)
 	tty_unthrottle(tty);
 
 	return 0;
-err_free_bufs:
-	kfree(ldata->read_buf);
-	kfree(ldata->echo_buf);
-	kfree(ldata);
 err:
 	return -ENOMEM;
 }
-- 
1.8.3.2


--LQksG6bCIzRHxTLp--
