Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab3K0O2d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:28:33 -0500
Received: from m199-177.yeah.net ([123.58.177.199]:39562 "EHLO
	m199-177.yeah.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3K0O23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 09:28:29 -0500
From: Li Wang <liwang@ubuntukylin.com>
To: ceph-devel@vger.kernel.org
Cc: Sage Weil <sage@inktank.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Li Wang <liwang@ubuntukylin.com>,
        Yunchuan Wen <yunchuanwen@ubuntukylin.com>
Subject: [PATCH 1/2] ceph: Clean up if error occurred in finish_read()
Date: Wed, 27 Nov 2013 22:28:13 +0800
Message-Id: <1947b705cc4c308f96591b19bbe0065d13a1058e.1385561919.git.liwang@ubuntukylin.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1385561919.git.liwang@ubuntukylin.com>
References: <cover.1385561919.git.liwang@ubuntukylin.com>
In-Reply-To: <cover.1385561919.git.liwang@ubuntukylin.com>
References: <cover.1385561919.git.liwang@ubuntukylin.com>
X-HM-Spam-Status: e1koWUFPN1dZCBgUCR5ZQU9MVUhKSUJCTkJKS01PT05IV1kJDhceCFlBWS
	grPSQoND0vPToyNyQyNSQzPjo*PilBTVVKSEJANiMkIj4oJDI1JDM#Oj8#KUFLVUhPSUArLykkNT
	QkMjUkMz46Pz4pQUlVQ05DQDg0LjUvKSIkODVBS1VJTUNAKT48MjQ1JDooMjpBSFVPT01AKyk0LT
	I1OD4kMy41OjVBQlVCSk5APyI1OjYyOCQyKyQ1NCQyNSQzPjo*PilBS1VMQ0JAPzAyNiQ1NDU#QU
	tVS0ApPjo3JDIrJDI1JCk5NyQyNSQzPjo*PilBTFVLS0NANi43LzIkKTgrLyQ*Mj09Pik#NS8kMj
	UkMz46Pz4pQU9VS0tJQDIrJEokNjI1Li8#JDg1LyRLJEpLQUtVS0AyKyRISyQ2MjUuLz4kODUvJE
	skTktBS1VLQDIrJE4kNjI1Li8#JDg1LyRLJEpLQUtVS0AyKyQvND86IiQ4NS8kSyRKS0tBS1VMSk
	1AMiskSiQzNC4pJDg1LyRLJEpLS0FLVUtANTQvJD06NjQuKCQ*NDY6MjUkKCs9JD06MjdBSktVS0
	AoLjkkPkFKVU5OQD01JCguOSQ#NSw0KT8oJDM3MSRKS0tJS0pBS1VJQ1kG
X-HM-Sender-Digest: e1kSHx4VD1lBWUc6MQg6Cjo4LDo4EDorKjhIOj4qOkMwCjFVSlVKSENO
	Tk1JTktMT0pJVTMWGhIXVRcSDBoVHDsOGQ4VDw4QAhcSFVUYFBZFWVdZDB4ZWUEdGhcIHldZCAFZ
	QUlISEk3V1kSC1lBWUlJSVVJT0tVSkxMVUhPWQY+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up if error occurred rather than going through normal process

Signed-off-by: Li Wang <liwang@ubuntukylin.com>
Signed-off-by: Yunchuan Wen <yunchuanwen@ubuntukylin.com>
---
 fs/ceph/addr.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 1e561c0..97845b4 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -252,6 +252,8 @@ static void finish_read(struct ceph_osd_request *req, struct ceph_msg *msg)
 	for (i = 0; i < num_pages; i++) {
 		struct page *page = osd_data->pages[i];
 
+		if (rc < 0)
+			goto unlock;
 		if (bytes < (int)PAGE_CACHE_SIZE) {
 			/* zero (remainder of) page */
 			int s = bytes < 0 ? 0 : bytes;
@@ -262,6 +264,7 @@ static void finish_read(struct ceph_osd_request *req, struct ceph_msg *msg)
 		flush_dcache_page(page);
 		SetPageUptodate(page);
 		ceph_readpage_to_fscache(inode, page);
+unlock:
 		unlock_page(page);
 		page_cache_release(page);
 		bytes -= PAGE_CACHE_SIZE;
-- 
1.7.9.5

