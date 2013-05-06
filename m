Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758490Ab3EFUxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 16:53:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59340 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758031Ab3EFUq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 16:46:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Robert P. J. Day" <rpjday@crashcourse.ca>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [ 080/115] localmodconfig: Process source kconfig files as they are found
Date: Mon,  6 May 2013 13:45:16 -0700
Message-Id: <20130506203103.770919811@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506203055.537199268@linuxfoundation.org>
References: <20130506203055.537199268@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit ced9cb1af1e3486cc14dca755a1b3fbadf06e90b upstream.

A bug was reported that caused localmodconfig to not keep all the
dependencies of ATH9K. This was caused by the kconfig file:

In drivers/net/wireless/ath/Kconfig:

---
if ATH_CARDS

config ATH_DEBUG
        bool "Atheros wireless debugging"
        ---help---
          Say Y, if you want to debug atheros wireless drivers.
          Right now only ath9k makes use of this.

source "drivers/net/wireless/ath/ath5k/Kconfig"
source "drivers/net/wireless/ath/ath9k/Kconfig"
source "drivers/net/wireless/ath/carl9170/Kconfig"
source "drivers/net/wireless/ath/ath6kl/Kconfig"
source "drivers/net/wireless/ath/ar5523/Kconfig"
source "drivers/net/wireless/ath/wil6210/Kconfig"

endif
---

The current way kconfig works, it processes new source files after the
first file is completed. It creates an array of new source config files
and when the one file is finished, it continues with the next file.

Unfortunately, this means that it loses the fact that the source file is
within an "if" statement, and this means that each of these source file's
configs will not have the proper dependencies set.

As ATH9K requires ATH_CARDS set, the localmodconfig did not see that
dependency, and did not enable ATH_CARDS. When the oldconfig was run, it
forced ATH9K to be disabled.

Link: http://lkml.kernel.org/r/alpine.DEB.2.02.1304291022320.9234@oneiric

Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
Tested-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 scripts/kconfig/streamline_config.pl |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -156,7 +156,6 @@ sub read_kconfig {
 
     my $state = "NONE";
     my $config;
-    my @kconfigs;
 
     my $cont = 0;
     my $line;
@@ -190,7 +189,13 @@ sub read_kconfig {
 
 	# collect any Kconfig sources
 	if (/^source\s*"(.*)"/) {
-	    $kconfigs[$#kconfigs+1] = $1;
+	    my $kconfig = $1;
+	    # prevent reading twice.
+	    if (!defined($read_kconfigs{$kconfig})) {
+		$read_kconfigs{$kconfig} = 1;
+		read_kconfig($kconfig);
+	    }
+	    next;
 	}
 
 	# configs found
@@ -250,14 +255,6 @@ sub read_kconfig {
 	}
     }
     close($kinfile);
-
-    # read in any configs that were found.
-    foreach my $kconfig (@kconfigs) {
-	if (!defined($read_kconfigs{$kconfig})) {
-	    $read_kconfigs{$kconfig} = 1;
-	    read_kconfig($kconfig);
-	}
-    }
 }
 
 if ($kconfig) {


