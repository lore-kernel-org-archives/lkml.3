Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbaA0KBb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 05:01:31 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:15896 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbaA0KBT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 05:01:19 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-d7-52e62e6de111
From: Weijie Yang <weijie.yang@samsung.com>
To: hughd@google.com
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Minchan Kim'" <minchan@kernel.org>, shli@kernel.org,
        "'Bob Liu'" <bob.liu@oracle.com>, weijie.yang.kh@gmail.com,
        "'Seth Jennings'" <sjennings@variantweb.net>,
        "'Linux-MM'" <linux-mm@kvack.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, "'Heesub Shin'" <heesub.shin@samsung.com>,
        mguzik@redhat.com
Subject: [PATCH 0/8] mm/swap: fix some rare issues in swap subsystem
Date: Mon, 27 Jan 2014 18:00:03 +0800
Message-id: <000501cf1b46$b899edb0$29cdc910$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8bRoxBybqmwJqdTV+ILWx69yq+1g==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsVy+t9jAd1cvWdBBoc26VjMWb+GzaLr1FQW
	i4OzlzBZPP3Ux2JxedccNot7a/6zWnQ8O81osezre3aLC4fuM1l8OvqIzWLBxkeMFk9O/Gdx
	4PHYOesuu8eCTaUem1Z1snls+jSJ3ePEjN8sHh+f3mLxeL/vKptH35ZVjB7XvxV5fN4kF8AV
	xWWTkpqTWZZapG+XwJXx89gx9oIPvBV3lyQ3MDZxdzFycEgImEg8aQ3uYuQEMsUkLtxbz9bF
	yMUhJLCIUWLv2hYmCOcPo0TftZVMIFVsAtoSd/s3soLYIgIiEmvuLGQEKWIW+MEkce7gVRaQ
	qcICLhJ3L4eC1LAIqEocmNwFVs8rYCex4+w/dghbUOLH5Htg5cwC6hJTpuSChJmBxj95d4EV
	4jZ1iUd/dSE26Um83HubBaJEXGLjkVssExgFZiEZNAth0Cwkg2Yh6VjAyLKKUTS1ILmgOCk9
	10ivODG3uDQvXS85P3cTIziqnknvYFzVYHGIUYCDUYmHN+P60yAh1sSy4srcQ4wSHMxKIrwV
	Os+ChHhTEiurUovy44tKc1KLDzFKc7AoifMebLUOFBJITyxJzU5NLUgtgskycXBKNTAW/ymJ
	eh/fuu5d1NOvAZ/kDTYGavZ0im2blvPi98GknZMflW2sLjAI+FKz/NKu3/ezDov/LOr32vS8
	3uZE+1tDla32n5LSXMVc/stvKfee2yxhLOsVF/LPylj1i8PWHVIP8rq0BZQNtLQyV3+RS510
	uYCtfKvi93+vfv3h/HLs/wTj7P8vU/cosRRnJBpqMRcVJwIAorCvSKYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series focus on some tiny and rare issues in swap subsystem.
These issues happen rarely, so it is just for the correctness of the code.

It firstly add some comments to try to make swap flag/lock usage in
swapfile.c more clear and readable,
and fix some rare issues in swap subsystem that cause race condition among
swapon, swapoff and frontswap_register_ops.
and fix some not race issues.

Please see individual patch for details, any complaint and suggestion
are welcome.

Regards

patch 1/8: add some comments for swap flag/lock usage

patch 2/8: fix race on swap_info reuse between swapoff and swapon
	This patch has been in akpm -mm tree, however I improve it according
	to Heesub Shin and Mateusz Guzik's suggestion. So, that old patch need
	to be dropped.

patch 3/8: prevent concurrent swapon on the same S_ISBLK blockdev

patch 4/8: fix race among frontswap_register_ops, swapoff and swapon

patch 5/8: drop useless and bug frontswap_shrink codes

patch 6/8: remove swap_lock to simplify si_swapinfo()

patch 7/8: check swapfile blocksize greater than PAGE_SIZE

patch 8/8: add missing handle on a dup-store failure

 include/linux/blkdev.h    |    4 +++-
 include/linux/frontswap.h |    2 --
 include/linux/swapfile.h  |    4 +---
 mm/frontswap.c            |  127 +++++++------------------------------------------------------------------------------------------------------------------------
 mm/page_io.c              |    2 ++
 mm/rmap.c                 |    2 +-
 mm/swapfile.c             |  138 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------
 7 files changed, 112 insertions(+), 167 deletions(-)

