Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab3LRRvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 12:51:41 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:63755 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754542Ab3LRRvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 12:51:38 -0500
Message-Id: <20131218175137.162937350@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 18 Dec 2013 12:35:20 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Takashi Iwai <tiwai@suse.de>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC][PATCH 1/2] localmodconfig: Add config depends by default settings
References: <20131218173519.265509723@goodmis.org>
Content-Disposition: inline; filename=0001-localmodconfig-Add-config-depends-by-default-setting.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Currently localmodconfig will miss dependencies from the default option.
For example:

config FOO
	default y if BAR || ZOO

If FOO is needed for a module and is set to '=m', and so are BAR or ZOO,
localmodconfig will not see that BOO or ZOO are also needed for the foo
module, and will incorrectly disable them.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/kconfig/streamline_config.pl | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streamline_config.pl
index 4606cdf..3133172 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -219,6 +219,13 @@ sub read_kconfig {
 	    $depends{$config} = $1;
 	} elsif ($state eq "DEP" && /^\s*depends\s+on\s+(.*)$/) {
 	    $depends{$config} .= " " . $1;
+	} elsif ($state eq "DEP" && /^\s*def(_(bool|tristate)|ault)\s+(\S.*)$/) {
+	    my $dep = $3;
+	    if ($dep !~ /^\s*(y|m|n)\s*$/) {
+		$dep =~ s/.*\sif\s+//;
+		$depends{$config} .= " " . $dep;
+		dprint "Added default depends $dep to $config\n";
+	    }
 
 	# Get the configs that select this config
 	} elsif ($state ne "NONE" && /^\s*select\s+(\S+)/) {
-- 
1.8.4.3


