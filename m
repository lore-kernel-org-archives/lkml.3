Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbaFEEVB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:21:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44009 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbaFEEUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:20:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Jakub=20Hus=C3=A1k?= <jakub@gooseman.cz>,
        NeilBrown <neilb@suse.de>, Ben Hutchings <ben@decadent.org.uk>,
        Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 3.4 097/214] md/raid10: fix "enough" function for detecting if array is failed.
Date: Wed,  4 Jun 2014 21:17:40 -0700
Message-Id: <20140605041652.726311171@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 80b4812407c6b1f66a4f2430e69747a13f010839 upstream.

The 'enough' function is written to work with 'near' arrays only
in that is implicitly assumes that the offset from one 'group' of
devices to the next is the same as the number of copies.
In reality it is the number of 'near' copies.

So change it to make this number explicit.

This bug makes it possible to run arrays without enough drives
present, which is dangerous.
It is appropriate for an -stable kernel, but will almost certainly
need to be modified for some of them.

Reported-by: Jakub Husák <jakub@gooseman.cz>
Signed-off-by: NeilBrown <neilb@suse.de>
[bwh: Backported to 3.2: s/geo->/conf->/]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid10.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1419,14 +1419,16 @@ static int enough(struct r10conf *conf,
 	do {
 		int n = conf->copies;
 		int cnt = 0;
+		int this = first;
 		while (n--) {
-			if (conf->mirrors[first].rdev &&
-			    first != ignore)
+			if (conf->mirrors[this].rdev &&
+			    this != ignore)
 				cnt++;
-			first = (first+1) % conf->raid_disks;
+			this = (this+1) % conf->raid_disks;
 		}
 		if (cnt == 0)
 			return 0;
+		first = (first + conf->near_copies) % conf->raid_disks;
 	} while (first != 0);
 	return 1;
 }


