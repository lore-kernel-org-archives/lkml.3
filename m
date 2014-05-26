Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbaEZUeG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 16:34:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65364 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbaEZUeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 16:34:00 -0400
Message-Id: <20140526203358.050994577@networkplumber.org>
User-Agent: quilt/0.63-1
Date: Mon, 26 May 2014 13:33:13 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH 4/4] get_maintainer: use anonymous function instead of eval
References: <20140526203309.782169359@networkplumber.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=get_maintainer_lambda.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change get_maintainer to use anonymous function instead of eval().
Using a anonymous function is safer than doing eval on a string.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>


--- a/scripts/get_maintainer.pl	2014-05-26 13:23:00.480939284 -0700
+++ b/scripts/get_maintainer.pl	2014-05-26 13:23:45.925291872 -0700
@@ -93,8 +93,9 @@ my $rfc822_char = '[\\000-\\377]';
 my %VCS_cmds_git = (
     name	=> 'git',
     execute_cmd => \&git_execute_cmd,
-    available   => '(which("git") ne "") && (-e ".git")',
-
+    available   => sub {
+	return (which("git") ne "") && (-e ".git");
+    },
     find_signers_cmd =>
       "git log --no-color --follow --since=\$email_git_since "
       . '--numstat --no-merges '
@@ -129,7 +130,9 @@ my %VCS_cmds_git = (
 my %VCS_cmds_hg = (
     name	=> 'hg',
     execute_cmd => \&hg_execute_cmd,
-    available   => '(which("hg") ne "" ) && ( -d ".hg" )',
+    available   => sub {
+	return (which("hg") ne "" ) && ( -d ".hg" );
+    },
     find_signers_cmd => "hg log --date=\$email_hg_since "
       . "--template='HgCommit: {node}\\n"
       . "HgAuthor: {author}\\n"
@@ -1401,7 +1404,7 @@ sub vcs_blame {
 my $printed_novcs = 0;
 sub vcs_exists {
     foreach my $vc (@VCS_avail) {
-	return $vc if eval $vc->{available};
+	return $vc if $vc->{available}();
     }
 
     if (!$printed_novcs) {

