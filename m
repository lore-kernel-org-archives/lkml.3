Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbbANHZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:25:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57661 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbbANHZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:25:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3.18 025/150] ktest: Fix make_min_config to handle new assign_configs call
Date: Tue, 13 Jan 2015 23:21:36 -0800
Message-Id: <20150114072057.016849917@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

commit 9972fc0b859e7aaeb6d2d33bdb591959d9a436c0 upstream.

Commit 6071c22e1755 "ktest: Rewrite the config-bisect to actually work"
fixed the config-bisect to work nicely but in doing so it broke
make_min_config by changing the way assign_configs works.

The assign_configs function now adds the config to the hash even if
it is disabled, but changes the hash value to be that of the
line "# CONFIG_FOO is not set". Unfortunately, the make_min_config
test only checks to see if the config is removed. It now needs to
check if the config is in the hash and not set to be disabled.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/ktest/ktest.pl |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -3571,7 +3571,9 @@ sub test_this_config {
     undef %configs;
     assign_configs \%configs, $output_config;
 
-    return $config if (!defined($configs{$config}));
+    if (!defined($configs{$config}) || $configs{$config} =~ /^#/) {
+	return $config;
+    }
 
     doprint "disabling config $config did not change .config\n";
 


