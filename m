Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbaA0KJH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 05:09:07 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:58289 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622AbaA0KJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 05:09:04 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-2f-52e6303f044e
From: Weijie Yang <weijie.yang@samsung.com>
To: hughd@google.com
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Minchan Kim'" <minchan@kernel.org>, shli@kernel.org,
        "'Bob Liu'" <bob.liu@oracle.com>, weijie.yang.kh@gmail.com,
        "'Seth Jennings'" <sjennings@variantweb.net>,
        "'Heesub Shin'" <heesub.shin@samsung.com>, mquzik@redhat.com,
        "'Linux-MM'" <linux-mm@kvack.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH 3/8] mm/swap: prevent concurrent swapon on the same S_ISBLK
 blockdev
Date: Mon, 27 Jan 2014 18:03:04 +0800
Message-id: <000c01cf1b47$ce280170$6a780450$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8bRudppeILuSNKSMywpTnYTmP1Dw==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t9jAV17g2dBBgv3iFnMWb+GzaLr1FQW
	i4OzlzBZPP3Ux2JxedccNot7a/6zWiz7+p7dYsrDSYwWFw7dZ7L4dPQRm8WCjY8YLZ6c+M/i
	wOOxc9Zddo8Fm0o9Nq3qZPPY9GkSu8eJGb9ZPD4+vcXi8X7fVTaPvi2rGD2ufyvy+LxJLoAr
	issmJTUnsyy1SN8ugStjxYEN7AVt3BWXD99ka2D8ztHFyMkhIWAiMfvBKiYIW0ziwr31bF2M
	XBxCAosYJd4u+MUC4fxhlFg89SMrSBWbgLbE3f6NYLaIgIjEmjsLGUGKmAV+MUn09x8A6uDg
	EBYIk1j6JwykhkVAVeLooensIDavgJ1E29OXrBC2oMSPyffAypkF1CWmTMkFCTMLyEtsXvOW
	GSQsARR+9FcXYpOexI2zJ9kgSsQlNh65xTKBUWAWkkGzEAbNQjJoFpKOBYwsqxhFUwuSC4qT
	0nMN9YoTc4tL89L1kvNzNzGCI+uZ1A7GlQ0WhxgFOBiVeHgzrj8NEmJNLCuuzD3EKMHBrCTC
	W6HzLEiINyWxsiq1KD++qDQntfgQozQHi5I474FW60AhgfTEktTs1NSC1CKYLBMHp1QD45xz
	oXdX973d5GdUG7ON0+iuweYH1xyd58vY75ijeZ931tZZJ3P013VVrrbNuH+5dlFc+yWuqC39
	j8JyW791qydeZ97OmRbKYCchGSyhUCvD80FEREySe5eQoYXIpPeGnIseXSsoYNCYWcX/qPPc
	96ePFjYZmlo5RDplCYTsuVvXUPPn/fR+JZbijERDLeai4kQAiEgWxKgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When swapon the same S_ISBLK blockdev concurrent, the allocated two
swap_info could hold the same block_device, because claim_swapfile()
allow the same holder(here, it is sys_swapon function).

To prevent this situation, This patch adds swap_lock protect to ensure
we can find this situation and return -EBUSY for one swapon call.

As for S_ISREG swapfile, claim_swapfile() already prevent this scenario
by holding inode->i_mutex.

This patch is just for a rare scenario, aim to correct of code.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
---
 mm/swapfile.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 4d24158..413c213 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2459,9 +2459,10 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		goto bad_swap;
 	}
 
+	/* prevent concurrent swapon on the same S_ISBLK blockdev */
+	spin_lock(&swap_lock);
 	p->swap_file = swap_file;
 	mapping = swap_file->f_mapping;
-
 	for (i = 0; i < nr_swapfiles; i++) {
 		struct swap_info_struct *q = swap_info[i];
 
@@ -2472,6 +2473,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 			goto bad_swap;
 		}
 	}
+	spin_unlock(&swap_lock);
 
 	inode = mapping->host;
 	/* If S_ISREG(inode->i_mode) will do mutex_lock(&inode->i_mutex); */
-- 
1.7.10.4


