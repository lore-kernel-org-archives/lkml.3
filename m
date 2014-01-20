Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbaATPeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 10:34:10 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:32085 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751669AbaATPeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 10:34:05 -0500
Date: Mon, 20 Jan 2014 10:34:03 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kbuild@vger.kernel.org
Subject: [GIT PULL] localmodconfig: Add config depends by default settings
Message-ID: <20140120103403.33012eb2@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

While debugging the problem with localmodconfig and the ALSA codec
modules all being set, I discovered a small bug in the dependency
logic.

If a config has a dependency based on its setting value, localmodcondig
misses it.

For example:

config FOO
    default y if BAR || ZOO

If FOO is needed for a module and is set to '=m', and so are BAR or ZOO,
localmodconfig will not see that BAR or ZOO are also needed for the foo
module, and will incorrectly disable them.

Please pull the latest localmodconfig-v3.14 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-kconfig.git
localmodconfig-v3.14

Tag SHA1: 3e4892e9201af46ba6df30b7bb8925da06f28cbc
Head SHA1: 95edca5c523c4b404dd60baa0a1bea0e4c38fd72


Steven Rostedt (Red Hat) (1):
      localmodconfig: Add config depends by default settings

----
 scripts/kconfig/streamline_config.pl | 7 +++++++
 1 file changed, 7 insertions(+)
---------------------------
commit 95edca5c523c4b404dd60baa0a1bea0e4c38fd72
Author: Steven Rostedt (Red Hat) <rostedt@goodmis.org>
Date:   Wed Dec 18 12:35:20 2013 -0500

    localmodconfig: Add config depends by default settings
    
    Currently localmodconfig will miss dependencies from the default option.
    For example:
    
    config FOO
    	default y if BAR || ZOO
    
    If FOO is needed for a module and is set to '=m', and so are BAR or ZOO,
    localmodconfig will not see that BOO or ZOO are also needed for the foo
    module, and will incorrectly disable them.
    
    Link: http://lkml.kernel.org/r/20131218175137.162937350@goodmis.org
    
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

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
