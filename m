Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab3AKIzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 03:55:46 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:53015 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab3AKIzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 03:55:45 -0500
From: Fredrik Gustafsson <iveqy@iveqy.com>
To: apw@canonical.com
Cc: linux-kernel@vger.kernel.org, iveqy@iveqy.com
Subject: [PATCH] Prevent use of unitialized variable
Date: Fri, 11 Jan 2013 09:55:20 +0100
Message-Id: <1357894520-3406-1-git-send-email-iveqy@iveqy.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Run checkpatch.pl -f kernel/fork.c in commit
ecf02a607bd801e742d7bb35c6e40f7ca15edf03
and checkpatch.pl will try to use an uninitialized variable.
This patch fixes that.

Signed-off-by: Fredrik Gustafsson <iveqy@iveqy.com>
---
 scripts/checkpatch.pl |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 4d2c7df..4e34368 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3363,14 +3363,17 @@ sub process {
 
 			my $ms_addr = $2;
 			my $ms_val = $7;
-			my $ms_size = $12;
-
-			if ($ms_size =~ /^(0x|)0$/i) {
-				ERROR("MEMSET",
-				      "memset to 0's uses 0 as the 2nd argument, not the 3rd\n" . "$here\n$stat\n");
-			} elsif ($ms_size =~ /^(0x|)1$/i) {
-				WARN("MEMSET",
-				     "single byte memset is suspicious. Swapped 2nd/3rd argument?\n" . "$here\n$stat\n");
+
+			if (defined $12) {
+				my $ms_size = $12;
+
+				if ($ms_size =~ /^(0x|)0$/i) {
+					ERROR("MEMSET",
+						  "memset to 0's uses 0 as the 2nd argument, not the 3rd\n" . "$here\n$stat\n");
+				} elsif ($ms_size =~ /^(0x|)1$/i) {
+					WARN("MEMSET",
+						 "single byte memset is suspicious. Swapped 2nd/3rd argument?\n" . "$here\n$stat\n");
+				}
 			}
 		}
 
-- 
1.7.2.5

