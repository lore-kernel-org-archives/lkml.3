Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbaEITeF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 15:34:05 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:33757 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499AbaEITdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 15:33:04 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/7] cgroup: update and fix parsing of "cgroup.subtree_control"
Date: Fri,  9 May 2014 15:32:52 -0400
Message-Id: <1399663975-315-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399663975-315-1-git-send-email-tj@kernel.org>
References: <1399663975-315-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was confused that strsep() was equivalent to strtok_r() in skipping
over consecutive delimiters.  strsep() just splits at the first
occurrence of one of the delimiters which makes the parsing very
inflexible, which makes allowing multiple whitespace chars as
delimters kinda moot.  Let's just be consistently strict and require
list of tokens separated by spaces.  This is what
Documentation/cgroups/unified-hierarchy.txt describes too.

Also, parsing may access beyond the end of the string if the string
ends with spaces or is zero-length.  Make sure it skips zero-length
tokens.  Note that this also ensures that the parser doesn't puke on
multiple consecutive spaces.

v2: Add zero-length token skipping.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 35daf89..b81e7c0 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2542,11 +2542,13 @@ static int cgroup_subtree_control_write(struct cgroup_subsys_state *dummy_css,
 	int ssid, ret;
 
 	/*
-	 * Parse input - white space separated list of subsystem names
-	 * prefixed with either + or -.
+	 * Parse input - space separated list of subsystem names prefixed
+	 * with either + or -.
 	 */
 	p = buffer;
-	while ((tok = strsep(&p, " \t\n"))) {
+	while ((tok = strsep(&p, " "))) {
+		if (tok[0] =='\0')
+			continue;
 		for_each_subsys(ss, ssid) {
 			if (ss->disabled || strcmp(tok + 1, ss->name))
 				continue;
-- 
1.9.0

