Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab3DPFB4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 01:01:56 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:50185 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab3DPFBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 01:01:55 -0400
Message-ID: <516CDAF5.3020909@linux.vnet.ibm.com>
Date: Tue, 16 Apr 2013 13:00:37 +0800
From: Runzhen Wang <runzhen@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: acme@redhat.com
CC: mingo@kernel.org, linux-kernel@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: [PATCH] perf tool: fix the perf --version bug
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041604-3568-0000-0000-000003700A19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From 4d629cfb265beece1aae2e3fdf603e36a321f785 Mon Sep 17 00:00:00 2001
From: Runzhen Wang <runzhen@linux.vnet.ibm.com>
Date: Mon, 15 Apr 2013 23:17:15 -0400
Subject: [PATCH] perf tool: fix the perf --version bug

The perf --version can't print the right version
information when reset it to an earlier commit.

For example, at present the version is:
# ./perf --version
perf version 3.9.rc6.gf8378f

then, I reset it to an earlier version, say v3.8-rc7
# git reset --hard v3.8-rc7
# make

However, the ./perf --version prints a wrong result:
# ./perf --version
perf version 3.9.rc6.g836dc9

Using 'git describe' instead of 'git tag' can fix this problem.

Signed-off-by: Runzhen Wang <runzhen@linux.vnet.ibm.com>
---
  tools/perf/util/PERF-VERSION-GEN |    3 +--
  1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/perf/util/PERF-VERSION-GEN 
b/tools/perf/util/PERF-VERSION-GEN
index 055fef3..ec3dd86 100755
--- a/tools/perf/util/PERF-VERSION-GEN
+++ b/tools/perf/util/PERF-VERSION-GEN
@@ -14,9 +14,8 @@ LF='
  # otherwise try to get the version from the kernel Makefile
  #
  if test -d ../../.git -o -f ../../.git &&
-    VN=$(git tag 2>/dev/null | tail -1 | grep -E "v[0-9].[0-9]*")
+    VN=$(git describe --match 'v[0-9].[0-9]*' --abbrev=4 HEAD 2>/dev/null)
  then
-    VN=$(echo $VN"-g"$(git log -1 --abbrev=4 --pretty=format:"%h" HEAD))
      VN=$(echo "$VN" | sed -e 's/-/./g');
  else
      VN=$(MAKEFLAGS= make -sC ../.. kernelversion)
-- 
1.7.10.1

