Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab3BBGwH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 01:52:07 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:55867 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab3BBGwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 01:52:05 -0500
Message-ID: <510CB787.80003@huawei.com>
Date: Sat, 2 Feb 2013 14:51:51 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Davide Libenzi <davidel@xmailserver.org>,
        Aaron Durbin <adurbin@google.com>, Greg Thelen <gthelen@google.com>
Subject: [PATCH 4/4] cgroup: adapt to the new way of detecting cgroup removal
References: <510CB733.2080904@huawei.com>
In-Reply-To: <510CB733.2080904@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If read() returns with errno == EIDRM, we know the cgroup has been
removed.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 tools/cgroup/cgroup_event_listener.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/tools/cgroup/cgroup_event_listener.c b/tools/cgroup/cgroup_event_listener.c
index 4eb5507..19e3d4a 100644
--- a/tools/cgroup/cgroup_event_listener.c
+++ b/tools/cgroup/cgroup_event_listener.c
@@ -62,18 +62,16 @@ int main(int argc, char **argv)
 		if (ret == -1) {
 			if (errno == EINTR)
 				continue;
-			err(1, "Cannot read from eventfd");
+			if (errno != EIDRM)
+				err(1, "Cannot read from eventfd");
 		}
-		assert(ret == sizeof(result));
 
-		ret = access(event_control_path, W_OK);
-		if ((ret == -1) && (errno == ENOENT)) {
-			puts("The cgroup seems to have removed.");
+		if (ret == -1 && errno == EIDRM) {
+			puts("The cgroup has been removed.");
 			break;
 		}
 
-		if (ret == -1)
-			err(1, "cgroup.event_control is not accessible any more");
+		assert(ret == sizeof(result));
 
 		printf("%s %s: crossed\n", argv[1], argv[2]);
 	}
-- 
1.8.0.2

