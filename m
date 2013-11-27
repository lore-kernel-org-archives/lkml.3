Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441Ab3K0O2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:28:39 -0500
Received: from m199-177.yeah.net ([123.58.177.199]:39564 "EHLO
	m199-177.yeah.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab3K0O23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 09:28:29 -0500
From: Li Wang <liwang@ubuntukylin.com>
To: ceph-devel@vger.kernel.org
Cc: Sage Weil <sage@inktank.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Li Wang <liwang@ubuntukylin.com>,
        Yunchuan Wen <yunchuanwen@ubuntukylin.com>
Subject: [PATCH 2/2] ceph: Add necessary clean up if invalid reply received in handle_reply()
Date: Wed, 27 Nov 2013 22:28:14 +0800
Message-Id: <4ea6e7ee4e9d67176a61839ff95193c7a96740e9.1385561919.git.liwang@ubuntukylin.com>
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
	Tk1JTktMTUtCVTMWGhIXVRcSDBoVHDsOGQ4VDw4QAhcSFVUYFBZFWVdZDB4ZWUEdGhcIHldZCAFZ
	QUlKSEw3V1kSC1lBWUlJSVVJT0tVSkxMVUhPWQY+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wake up possible waiters, invoke the call back if any, unregister the request

Signed-off-by: Li Wang <liwang@ubuntukylin.com>
Signed-off-by: Yunchuan Wen <yunchuanwen@ubuntukylin.com>
---
 net/ceph/osd_client.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 2b4b32a..a17eaae 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1581,6 +1581,13 @@ done:
 	return;
 
 bad_put:
+	req->r_result = -EIO;
+	__unregister_request(osdc, req);
+	if (req->r_callback)
+		req->r_callback(req, msg);
+	else
+		complete_all(&req->r_completion);
+	complete_request(req);
 	ceph_osdc_put_request(req);
 bad_mutex:
 	mutex_unlock(&osdc->request_mutex);
-- 
1.7.9.5

