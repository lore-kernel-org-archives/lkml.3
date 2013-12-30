Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122Ab3L3NqL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 08:46:11 -0500
Received: from m59-178.qiye.163.com ([123.58.178.59]:38347 "EHLO
	m59-178.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756026Ab3L3NqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 08:46:03 -0500
From: Li Wang <liwang@ubuntukylin.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>, Zefan Li <lizefan@huawei.com>,
        Matthew Wilcox <matthew@wil.cx>, Li Wang <liwang@ubuntukylin.com>,
        Yunchuan Wen <yunchuanwen@ubuntukylin.com>
Subject: [PATCH 3/3] Fadvise: Add the ability for directory level page cache cleaning
Date: Mon, 30 Dec 2013 21:45:18 +0800
Message-Id: <c31e91f1cea4afc0d86671fbe84f70d8d5d11329.1388409687.git.liwang@ubuntukylin.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1388409686.git.liwang@ubuntukylin.com>
References: <cover.1388409686.git.liwang@ubuntukylin.com>
In-Reply-To: <cover.1388409686.git.liwang@ubuntukylin.com>
References: <cover.1388409686.git.liwang@ubuntukylin.com>
X-HM-Spam-Status: e1koWUFPN1dZCBgUCR5ZQUpOVUNJQkJCQkJJSExLTUtOTldZCQ4XHghZQV
	koKz0kKDQ9Lz06MjckMjUkMz46Pz4pQUtVS0A2IyQiPigkMjUkMz46Pz4pQUtVS0ArLykkNTQkMj
	UkMz46Pz4pQUlVS0A4NC41LykiJDg1QUtVS0ApPjwyNDUkOigyOkFLVUtAKyk0LTI1OD4kMy41Oj
	VBS1VLQD8iNTo2MjgkMiskNTQkMjUkMz46Pz4pQUtVS0A2LjcvMiQpOCsvJD8yPT0#KT41LyQyNS
	QzPjo*PilBSVVLQDIrJC80PzoiJDg1LyRLJEpLS0FLVUtAMiskTiQ2MjUuLz4kODUvJEskSktBS1
	VLQDIrJEokNjI1Li8#JDg1LyRLJEpLQUtVS0AyKyRKJDM0LikkODUvJEskSktLQUtVS0AyKyRISy
	Q2MjUuLz4kODUvJEskTktBS1VLQDU0LyQ9OjY0LigkPzQ2OjI1JCgrPSQ9OjI3QUpLVUtAKC45JD
	5BSlVOTkA9NSQoLjkkPjUsNCk*KCQzNzEkSktLSUtKQUtVSUNZBg++
X-HM-Sender-Digest: e1kSHx4VD1lBWUc6MQg6Cjo4LDo4EDorKjhIOj4qOkMwCjFVSlVKSEND
	T0pKSk5NTEpJVTMWGhIXVRcSDBoVHDsOGQ4VDw4QAhcSFVUYFBZFWVdZDB4ZWUEdGhcIHldZCAFZ
	QUlPS0k3V1kSC1lBWUpKQlVIQlVKSU9VSkxLWQY+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Li Wang <liwang@ubuntukylin.com>
Signed-off-by: Yunchuan Wen <yunchuanwen@ubuntukylin.com>
---
 mm/fadvise.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/fadvise.c b/mm/fadvise.c
index 3bcfd81..644d32d 100644
--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -113,6 +113,10 @@ SYSCALL_DEFINE4(fadvise64_64, int, fd, loff_t, offset, loff_t, len, int, advice)
 	case POSIX_FADV_NOREUSE:
 		break;
 	case POSIX_FADV_DONTNEED:
+		if (S_ISDIR(file_inode(f.file)->i_mode)) {
+			shrink_pagecache_parent(f.file->f_dentry);
+			goto out;
+		}
 		if (!bdi_write_congested(mapping->backing_dev_info))
 			__filemap_fdatawrite_range(mapping, offset, endbyte,
 						   WB_SYNC_NONE);
-- 
1.7.9.5

