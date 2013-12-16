Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab3LPPL7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 10:11:59 -0500
Received: from m59-178.qiye.163.com ([123.58.178.59]:54768 "EHLO
	m59-178.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454Ab3LPPK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 10:10:56 -0500
From: Li Wang <liwang@ubuntukylin.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Sage Weil <sage@inktank.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Li Wang <liwang@ubuntukylin.com>,
        Yunchuan Wen <yunchuanwen@ubuntukylin.com>
Subject: =?UTF-8?q?=5BPATCH=200/5=5D=20VFS=3A=20Directory=20level=20cache=20cleaning?=
Date: Mon, 16 Dec 2013 07:00:04 -0800
Message-Id: <cover.1387205337.git.liwang@ubuntukylin.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1koWUFPN1dZCBgUCR5ZQUpMVU5MQkJCQkJJSExLTUtOTldZCQ4XHghZQV
	koKz0kKzooKCQyNSQzPjo*PilBS1VLQDYjJCI#KCQyNSQzPjo*PilBS1VLQCsvKSQiPigkMjUkMz
	46Pz4pQUtVS0A4NC41LykiJDg1QUtVS0ApPjwyNDUkOigyOkFLVUtAKyk0LTI1OD4kMy41OjVBS1
	VLQD8iNTo2MjgkMiskNTQkMjUkMz46Pz4pQUtVS0ApPjo3JDIrJDI1JCk5NyQyNSQzPjo*PilBSk
	lVS0A2LjcvMiQpOCsvJD8yPT0#KT41LyQyNSQzPjo*PilBSVVLQDIrJC80PzoiJDg1LyRLJEpLS0
	FLVUtAMiskTiQ2MjUuLz4kODUvJEskSktBS1VLQDIrJEokNjI1Li8#JDg1LyRLJEpLQUtVS0AyKy
	RKJDM0LikkODUvJEskSktLQUtVS0AyKyRISyQ2MjUuLz4kODUvJEskTktBS1VLQD01JDM0LyQzNz
	EkS0xLTktPQUtVS0AoLjkkPkFKVU5OQD01JCguOSQ#NSw0KT8oJDM3MSRKS0tJS0pBS1VJQ0A9NS
	Q9KT4#JDM3MSRLTEtOS09BSlVMTlkG
X-HM-Sender-Digest: e1kSHx4VD1lBWUc6MQg6Cjo4LDo4EDorKjhIOj4qOkMwCjFVSlVKSENM
	SUtNS05PSUtNVTMWGhIXVRcSDBoVHDsOGQ4VDw4QAhcSFVUYFBZFWVdZDB4ZWUEdGhcIHldZCAFZ
	QU9NQ003V1kSC1lBWU1KVUpDTFVOT1VCWQY+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, Linux only support file system wide VFS
cache (dentry cache and page cache) cleaning through
'/proc/sys/vm/drop_caches'. Sometimes this is less
flexible. The applications may know exactly whether
the metadata and data will be referenced or not in future,
a desirable mechanism is to enable applications to
reclaim the memory of unused cache entries at a finer
granularity - directory level. This enables applications
to keep hot metadata and data (to be referenced in the
future) in the cache, and kick unused out to avoid
cache thrashing. Another advantage is it is more flexible
for debugging.

This patch extend the 'drop_caches' interface to
support directory level cache cleaning and has a complete
backward compatibility. '{1,2,3}' keeps the same semantics
as before. Besides, "{1,2,3}:DIRECTORY_PATH_NAME" is allowed
to recursively clean the caches under DIRECTORY_PATH_NAME.
For example, 'echo 1:/home/foo/jpg > /proc/sys/vm/drop_caches'
will clean the page caches of the files inside 'home/foo/jpg'.

It is easy to demonstrate the advantage of directory level
cache cleaning. We use a virtual machine configured with
an Intel(R) Xeon(R) 8-core CPU E5506 @ 2.13GHz, and with 1GB
memory.  Three directories named '1', '2' and '3' are created,
with each containing 180000 – 280000 files. The test program
opens all files in a directory and then tries the next directory.
The order for accessing the directories is '1', '2', '3',
'1'.

The time on accessing '1' on the second time is measured
with/without cache cleaning, under different file counts.
With cache cleaning, we clean all cache entries of files
in '2' before accessing the files in '3'. The results
are as follows (in seconds),

Note: by default, VFS will move those unreferenced inodes
into a global LRU list rather than freeing them, for this
experiment, we modified iput() to force to free inode as well,
this behavior and related codes are left for further discussion,
thus not reflected in this patch)

Number of files:   180000 200000 220000 240000 260000
Without cleaning:  2.165  6.977  10.032 11.571 13.443
With cleaning:     1.949  1.906  2.336  2.918  3.651

When the number of files is 180000 in each directory,
the metadata cache is large enough to buffer all entries
of three directories, so re-accessing '1' will hit in
the cache, regardless of whether '2' cleaned up or not.
As the number of files increases, the cache can now only
buffer two+ directories. Accessing '3' will result in some
entries of '1' to be evicted (due to LRU). When re-accessing '1',
some entries need be reloaded from disk, which is time-consuming.
In this case, cleaning '2' before accessing '3' enjoys a good
speedup, a maximum 4.29X performance improvements is achieved.
The advantage of directory level page cache cleaning should be 
easier to be demonstrated.

Signed-off-by: Li Wang <liwang@ubuntukylin.com>
Signed-off-by: Yunchuan Wen <yunchuanwen@ubuntukylin.com>

Li Wang (5):
  VFS: Convert drop_caches to accept string
  VFS: Convert sysctl_drop_caches to string
  VFS: Add the declaration of shrink_pagecache_parent
  VFS: Add shrink_pagecache_parent
  VFS: Extend drop_caches sysctl handler to allow directory level cache
    cleaning

 fs/dcache.c            |   35 +++++++++++++++++++++++++++++++++++
 fs/drop_caches.c       |   45 +++++++++++++++++++++++++++++++++++++--------
 include/linux/dcache.h |    1 +
 include/linux/mm.h     |    3 ++-
 kernel/sysctl.c        |    6 ++----
 5 files changed, 77 insertions(+), 13 deletions(-)

-- 
1.7.9.5

