Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691Ab3K0Qvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 11:51:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:1373 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757627Ab3K0QvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 11:51:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,783,1378882800"; 
   d="scan'208";a="443137829"
From: Ashutosh Dixit <ashutosh.dixit@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc: Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Siva Krishna Kumar Reddy Yerramreddy 
	<siva.krishna.kumar.reddy.yerramreddy@intel.com>,
        Caz Yokoyama <Caz.Yokoyama@intel.com>
Subject: [PATCH char-misc-linus v3 3/6] misc: mic: Bug fix for sysfs poll usage.
Date: Wed, 27 Nov 2013 08:58:40 -0800
Message-Id: <110d7ea2d60d47682da4208a07646a97b0f00585.1385569514.git.ashutosh.dixit@intel.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <cover.1385527468.git.ashutosh.dixit@intel.com>
References: <cover.1385527468.git.ashutosh.dixit@intel.com>
In-Reply-To: <cover.1385569514.git.ashutosh.dixit@intel.com>
References: <cover.1385569514.git.ashutosh.dixit@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MIC user space daemon poll's on sysfs changes. The documentation for
sysfs_poll(...) in fs/sysfs/file.c states that "Once poll/select
indicates that the value has changed, you need to close and re-open the
file, or seek to 0 and read again". This step was missed out earlier and
resulted in the daemon spinning continuously rather than getting blocked
in 'poll'. This bug was exposed by commit aea585ef8fa65163 introduced as
part of sysfs changes in 3.13-rc1. A seek to 0 has been introduced to
fix it.

Reviewed-by: Sudeep Dutt <sudeep.dutt@intel.com>
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
---
 Documentation/mic/mpssd/mpssd.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/mic/mpssd/mpssd.c b/Documentation/mic/mpssd/mpssd.c
index 0c980ad..5c7fdda 100644
--- a/Documentation/mic/mpssd/mpssd.c
+++ b/Documentation/mic/mpssd/mpssd.c
@@ -1412,6 +1412,12 @@ mic_config(void *arg)
 	}
 
 	do {
+		ret = lseek(fd, 0, SEEK_SET);
+		if (ret < 0) {
+			mpsslog("%s: Failed to seek to file start '%s': %s\n",
+				mic->name, pathname, strerror(errno));
+			goto close_error1;
+		}
 		ret = read(fd, value, sizeof(value));
 		if (ret < 0) {
 			mpsslog("%s: Failed to read sysfs entry '%s': %s\n",
-- 
1.8.2.3

