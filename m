Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab3LZObA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 09:31:00 -0500
Received: from m199-177.yeah.net ([123.58.177.199]:56470 "EHLO
	m199-177.yeah.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab3LZOav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 09:30:51 -0500
From: Li Wang <liwang@ubuntukylin.com>
To: ceph-devel@vger.kernel.org
Cc: Sage Weil <sage@inktank.com>, Milosz Tanski <milosz@adfin.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yunchuan Wen <yunchuanwen@ubuntukylin.com>
Subject: [PATCH 0/3] Ceph fscache: Fix kernel panic due to a race
Date: Thu, 26 Dec 2013 06:29:25 -0800
Message-Id: <cover.1388066937.git.liwang@ubuntukylin.com>
X-Mailer: git-send-email 1.7.9.5
X-HM-Spam-Status: e1koWUFPN1dZCBgUCR5ZQUhPVUtPQ0JCTkJMSk1MQk1CV1kJDhceCFlBWS
	grPSQrOigoJDI1JDM#Oj8#KUFOVUlOTUA2IyQiPigkMjUkMz46Pz4pQUtVSE9JQCsvKSQiPigkMj
	UkMz46Pz4pQUtVT0xMQDg0LjUvKSIkODVBS1VJTUNAKT48MjQ1JDooMjpBSFVPT01AKyk0LTI1OD
	4kMy41OjVBQlVCSk5APyI1OjYyOCQyKyQ1NCQyNSQzPjo*PilBS1VMQ0JAPzAyNiQ1NDU#QUtVS0
	ApPjo3JDIrJDI1JCk5NyQyNSQzPjo*PilBTFVLS0NANi43LzIkKTgrLyQ*Mj09Pik#NS8kMjUkMz
	46Pz4pQU9VS0tJQDIrJC80PzoiJDg1LyRLJEpLS0FLVUxKTUAyKyRKJDM0LikkODUvJEskSktLQU
	tVS0AyKyRKJDYyNS4vPiQ4NS8kSyRKS0FLVUtAMiskTiQ2MjUuLz4kODUvJEskSktBS1VLQDIrJE
	hLJDYyNS4vPiQ4NS8kSyROS0FLVUtAKC45JD5BSlVOTkA9NSQoLjkkPjUsNCk*KCQzNzEkSktLSU
	tKQUtVSUNZBg++
X-HM-Sender-Digest: e1kSHx4VD1lBWUc6MQg6Cjo4LDo4EDorKjhIOj4qOkMwCjFVSlVKSEND
	S01DSU9PSUhPVTMWGhIXVRcSDBoVHDsOGQ4VDw4QAhcSFVUYFBZFWVdZDB4ZWUEdGhcIHldZCAFZ
	QUlLSUw3V1kSC1lBWU1KVUpDTFVOT1VCWQY+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yunchuan Wen <yunchuanwen@ubuntukylin.com>

The following scripts could easily panic the kernel,

#!/bin/bash
mount -t ceph -o fsc MONADDR:/ cephfs
rm -rf cephfs/foo
dd if=/dev/zero of=cephfs/foo bs=8 count=512
echo 3 > /proc/sys/vm/drop_caches
dd if=cephfs/foo of=/dev/null bs=8 count=1024

This is due to when writing a page into fscache, the code will
assert that the write position does not exceed the 
object->store_limit_l, which is supposed to be equal to inode->i_size.
However, for current implementation, after file writing, the 
object->store_limit_l is not synchronized with new 
inode->i_size immediately, which introduces a race that if writing
a new page into fscache, will reach the ASSERT that write position
has exceeded the object->store_limit_l, and cause kernel panic. 
This patch fixes it.

Yunchuan Wen (3):
  Ceph fscache: Add an interface to synchronize object store limit
  Ceph fscache: Update object store limit after writing
  Ceph fscache: Wait for completion of object initialization

 fs/ceph/cache.c |    1 +
 fs/ceph/cache.h |   10 ++++++++++
 fs/ceph/file.c  |    3 +++
 3 files changed, 14 insertions(+)

-- 
1.7.9.5

