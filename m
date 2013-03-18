Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab3CREb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:31:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33636 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751950Ab3CREbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:31:02 -0400
Message-Id: <20130318042148.316225295@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:22:26 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        Larry Baker <baker@usgs.gov>
Subject: [ 42/82] decnet: Fix disappearing sysctl entries
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

When decnet is built as a module a simple:
echo 0.0 >/proc/sys/net/decnet/node_address

results in most of the sysctl entries under /proc/sys/net/decnet and
/proc/sys/net/decnet/conf disappearing.

For more details see http://www.spinics.net/lists/netdev/msg226123.html.

This change applies the same workaround used in
net/core/sysctl_net_core.c and net/ipv6/sysctl_net_ipv6.c of creating
a skeleton of decnet sysctl entries before doing anything else.

The problem first appeared in kernel 2.6.27.  The later rewrite of
sysctl in kernel 3.4 restored the previous behavior and eliminated the
need for this workaround.

This patch was heavily inspired by a similar but more complex patch by
Larry Baker.

Reported-by: Larry Baker <baker@usgs.gov>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/decnet/af_decnet.c         |    4 ++++
 net/decnet/sysctl_net_decnet.c |   28 ++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 0 deletions(-)

--- a/net/decnet/af_decnet.c
+++ b/net/decnet/af_decnet.c
@@ -2354,6 +2354,8 @@ static const struct proto_ops dn_proto_o
 	.sendpage =	sock_no_sendpage,
 };
 
+void dn_register_sysctl_skeleton(void);
+void dn_unregister_sysctl_skeleton(void);
 void dn_register_sysctl(void);
 void dn_unregister_sysctl(void);
 
@@ -2374,6 +2376,7 @@ static int __init decnet_init(void)
 	if (rc != 0)
 		goto out;
 
+	dn_register_sysctl_skeleton();
 	dn_neigh_init();
 	dn_dev_init();
 	dn_route_init();
@@ -2413,6 +2416,7 @@ static void __exit decnet_exit(void)
 	dn_fib_cleanup();
 
 	proc_net_remove(&init_net, "decnet");
+	dn_unregister_sysctl_skeleton();
 
 	proto_unregister(&dn_proto);
 
--- a/net/decnet/sysctl_net_decnet.c
+++ b/net/decnet/sysctl_net_decnet.c
@@ -55,6 +55,7 @@ static int max_decnet_no_fc_max_cwnd[] =
 static char node_name[7] = "???";
 
 static struct ctl_table_header *dn_table_header = NULL;
+static struct ctl_table_header *dn_skeleton_table_header = NULL;
 
 /*
  * ctype.h :-)
@@ -357,6 +358,27 @@ static struct ctl_path dn_path[] = {
 	{ }
 };
 
+static struct ctl_table empty[1];
+
+static struct ctl_table dn_skeleton[] = {
+	{
+		.procname = "conf",
+		.mode = 0555,
+		.child = empty,
+	},
+	{ }
+};
+
+void dn_register_sysctl_skeleton(void)
+{
+	dn_skeleton_table_header = register_sysctl_paths(dn_path, dn_skeleton);
+}
+
+void dn_unregister_sysctl_skeleton(void)
+{
+	unregister_sysctl_table(dn_skeleton_table_header);
+}
+
 void dn_register_sysctl(void)
 {
 	dn_table_header = register_sysctl_paths(dn_path, dn_table);
@@ -368,6 +390,12 @@ void dn_unregister_sysctl(void)
 }
 
 #else  /* CONFIG_SYSCTL */
+void dn_register_sysctl_skeleton(void)
+{
+}
+void dn_unregister_sysctl_skeleton(void)
+{
+}
 void dn_unregister_sysctl(void)
 {
 }


