Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbaAWN0L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 08:26:11 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:63234 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaAWN0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 08:26:07 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-32-52e1186cb7b1
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: Jason Baron <jbaron@akamai.com>
Cc: linux-kernel@vger.kernel.org, Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [PATCH 2/3] dynamic_debug: fix ddebug_parse_query()
Date: Thu, 23 Jan 2014 17:20:31 +0400
Message-id: <1390483232-7160-2-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <1390483232-7160-1-git-send-email-a.ryabinin@samsung.com>
References: <1390483232-7160-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGJMWRmVeSWpSXmKPExsVy+t/xy7o5Eg+DDHom6Fhs+/WIzWLG4uOs
	Fpd3zWFzYPaYfGQBs0ffllWMHp83yQUwR3HZpKTmZJalFunbJXBldM95xVhwhKOit8+ugfEn
	WxcjB4eEgInE1jfsXYycQKaYxIV764HCXBxCAksZJTad64ZyepgkfuxsZQSpYhPQk/g3azsb
	iC0ioCxx5eMNVhCbWcBLYuPVpUwgtrCAjcSrNUfA6lkEVCUe/XwMVsMr4CrxaHoD1DYFiWVf
	1jKD2JwCbhJdzW/AbCGgmguLJrBNYORdwMiwilE0tTS5oDgpPddIrzgxt7g0L10vOT93EyMk
	LL7uYFx6zOoQowAHoxIPb+KX+0FCrIllxZW5hxglOJiVRHhz2R8GCfGmJFZWpRblxxeV5qQW
	H2Jk4uCUamCs2mgawxlqw3LpXezyu4Kiso3THzH89X598uPUYNcPhR84ha+EPOj2v+bw45ew
	8LWdrikqST+3Sqwv37kqd5PbcvaH6seiN12d7c+65/ZxybvHTjmFs5u8zHp4bM6Se/+SFgYp
	+hnwzpPl0O225w3lqBF4+CXyu+PVbwXHTvMZ8jFlrnVxd3mlxFKckWioxVxUnAgA8oswaOkB	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes following scenario:

$ echo 'file dynamic_debug.c line 1-123 +p' > /sys/kernel/debug/dynamic_debug/control
-bash: echo: write error: Invalid argument
$ dmesg | grep dynamic_debug
dynamic_debug:ddebug_parse_query: last-line:123 < 1st-line:1
dynamic_debug:ddebug_parse_query: query parse failed

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 lib/dynamic_debug.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index f959c39..e488d9a 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -352,8 +352,10 @@ static int ddebug_parse_query(char *words[], int nwords,
 				return -EINVAL;
 			if (last) {
 				/* range <first>-<last> */
-				if (parse_lineno(last, &query->last_lineno)
-				    < query->first_lineno) {
+				if (parse_lineno(last, &query->last_lineno) < 0)
+					return -EINVAL;
+
+				if (query->last_lineno < query->first_lineno) {
 					pr_err("last-line:%d < 1st-line:%d\n",
 						query->last_lineno,
 						query->first_lineno);
-- 
1.8.3.2

