Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758770Ab3EOABW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 20:01:22 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:15489 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758432Ab3EOABT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 20:01:19 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-52-5192d048239a
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 1/2] f2fs: fix inconsistency of block count during recovery
Date: Wed, 15 May 2013 08:59:51 +0900
Message-id: <1368575992-7142-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t8zQ12PC5MCDZpmyVhc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlfHo0yTGgkl8Fed/
	NrI2MDbwdDFyckgImEgcf/KfEcIWk7hwbz1bFyMXh5DAMkaJ7vWL2WCKLn7YywSRWMQosWJZ
	I1RVG5NE05bVQA4HB5uAtsTm/QYgDSICzBILpp5nBKlhFpjAKPF/0XsWkISwgLfEru+/wKay
	CKhKHL3ylAnE5hVwk/j37Qc7xDZdidX/n7ODNEsI3GaTWN+zmh2iQUDi2+RDLCDLJARkJTYd
	YIaol5Q4uOIGywRGwQWMDKsYRVMLkguKk9KLDPWKE3OLS/PS9ZLzczcxQoKwdwfj7QPWhxiT
	gcZNZJYSTc4HBnFeSbyhsZmRhamJqbGRuaUZacJK4rxqLdaBQgLpiSWp2ampBalF8UWlOanF
	hxiZODilGhjn+RSHRvFwXiprzi9NEVzMZLR67fyZdWrx017MnuS4xjzmzZTn9c8aGf97HxHy
	y7DkD8o4cu/TpK1fZ7oXbq8wWW7Yuf9z3UeOez9fu98zkC1dcCV2U7LtzcwsHhX2wEUXbt/7
	bb320/QTz1NUNzxed1klTfLK9I1Ml8VyhfMnvS+8fm6jCtMhJZbijERDLeai4kQAHiP5yFgC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t9jAV2PC5MCDXY2Slhc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5jx6NMkxoJJfBXnfzayNjA28HQxcnJICJhIXPywlwnCFpO4cG89WxcjF4eQ
	wCJGiRXLGqGcNiaJpi2rgRwODjYBbYnN+w1AGkQEmCUWTD3PCFLDLDCBUeL/ovcsIAlhAW+J
	Xd9/sYHYLAKqEkevPAXbwCvgJvHv2w92iG26Eqv/P2efwMi9gJFhFaNoakFyQXFSeq6RXnFi
	bnFpXrpecn7uJkZwiD+T3sG4qsHiEKMAB6MSD29h4KRAIdbEsuLK3EOMEhzMSiK8z6OAQrwp
	iZVVqUX58UWlOanFhxiTgbZPZJYSTc4Hxl9eSbyhsYmZkaWRmYWRibk5acJK4rwHW60DhQTS
	E0tSs1NTC1KLYLYwcXBKNTAGSs02fbPTIUVaguv63ym3l2brHHmQ5ldy5GC0dNGebx+6ffVa
	TzLrxGZx2aTa5wZc11CTqS0z19EtZ1XK8maVz64x1ZjJe3LZRaWmycv4wzbHi+hYHOH6UfOz
	6i/Hkas6zY9Edurmv8uOfP9jqRRvoZGDw9Fnnv1xpTKTF/5XWH+n7cIFESWW4oxEQy3mouJE
	AETb6TO1AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently f2fs recovers the dentry of fsynced files.
When power-off-recovery is conducted, this newly recovered inode should increase
node block count as well as inode block count.

This patch resolves this inconsistency that results in:

1. create a file
2. write data
3. fsync
4. reboot without sync
5. mount and recover the file
6. node block count is 1 and inode block count is 2
 : fall into the inconsistent state
7. unlink the file
 : trigger the following BUG_ON

------------[ cut here ]------------
kernel BUG at /home/zeus/f2fs_test/src/fs/f2fs/f2fs.h:716!
Call Trace:
 [<ffffffffa0344100>] ? get_node_page+0x50/0x1a0 [f2fs]
 [<ffffffffa0344bfc>] remove_inode_page+0x8c/0x100 [f2fs]
 [<ffffffffa03380f0>] ? f2fs_evict_inode+0x180/0x2d0 [f2fs]
 [<ffffffffa033812e>] f2fs_evict_inode+0x1be/0x2d0 [f2fs]
 [<ffffffff811c7a67>] evict+0xa7/0x1a0
 [<ffffffff811c82b5>] iput+0x105/0x190
 [<ffffffff811c2b30>] d_kill+0xe0/0x120
 [<ffffffff811c2c57>] dput+0xe7/0x1e0
 [<ffffffff811acc3d>] __fput+0x19d/0x2d0
 [<ffffffff811acd7e>] ____fput+0xe/0x10
 [<ffffffff81070645>] task_work_run+0xb5/0xe0
 [<ffffffff81002941>] do_notify_resume+0x71/0xb0
 [<ffffffff8175f14a>] int_signal+0x12/0x17

Reported-by: Chris Fries <C.Fries@motorola.com>
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/node.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 3df43b4..9641534 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1492,6 +1492,8 @@ int recover_inode_page(struct f2fs_sb_info *sbi, struct page *page)
 	new_ni = old_ni;
 	new_ni.ino = ino;
 
+	if (!inc_valid_node_count(sbi, NULL, 1))
+		WARN_ON(1);
 	set_node_addr(sbi, &new_ni, NEW_ADDR);
 	inc_valid_inode_count(sbi);
 
-- 
1.8.1.3.566.gaa39828

