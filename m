Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366AbaJCWWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:22:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46906 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757977AbaJCWOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:14:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Brassow Jonathan <jbrassow@redhat.com>, NeilBrown <neilb@suse.de>
Subject: [PATCH 3.14 221/238] md/raid1: intialise start_next_window for READ case to avoid hang
Date: Fri,  3 Oct 2014 14:32:16 -0700
Message-Id: <20141003212920.734914088@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit f0cc9a057151892b885be21a1d19b0185568281d upstream.

r1_bio->start_next_window is not initialised in the READ
case, so allow_barrier may incorrectly decrement
   conf->current_window_requests
which can cause raise_barrier() to block forever.

Fixes: 79ef3a8aa1cb1523cc231c9a90a278333c21f761
Reported-by: Brassow Jonathan <jbrassow@redhat.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid1.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1185,6 +1185,7 @@ read_again:
 				   atomic_read(&bitmap->behind_writes) == 0);
 		}
 		r1_bio->read_disk = rdisk;
+		r1_bio->start_next_window = 0;
 
 		read_bio = bio_clone_mddev(bio, GFP_NOIO, mddev);
 		bio_trim(read_bio, r1_bio->sector - bio->bi_iter.bi_sector,


