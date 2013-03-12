Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964954Ab3CLWqv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:46:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60754 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964895Ab3CLWor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:44:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Larry Baker <baker@usgs.gov>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Miller <davem@redhat.com>
Subject: [ 20/21] decnet: Fix disappearing sysctl entries
Date: Tue, 12 Mar 2013 15:44:22 -0700
Message-Id: <20130312223247.449652622@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223245.109098379@linuxfoundation.org>
References: <20130312223245.109098379@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


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
Acked-by: David Miller <davem@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/decnet/af_decnet.c         |    4 ++++
 net/decnet/sysctl_net_decnet.c |   28 ++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

--- a/net/decnet/af_decnet.c
+++ b/net/decnet/af_decnet.c
@@ -2355,6 +2355,8 @@ static const struct proto_ops dn_proto_o
 	.sendpage =	sock_no_sendpage,
 };
 
+void dn_register_sysctl_skeleton(void);
+void dn_unregister_sysctl_skeleton(void);
 void dn_register_sysctl(void);
 void dn_unregister_sysctl(void);
 
@@ -2375,6 +2377,7 @@ static int __init decnet_init(void)
 	if (rc != 0)
 		goto out;
 
+	dn_register_sysctl_skeleton();
 	dn_neigh_init();
 	dn_dev_init();
 	dn_route_init();
@@ -2414,6 +2417,7 @@ static void __exit decnet_exit(void)
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
@@ -356,6 +357,27 @@ static struct ctl_path dn_path[] = {
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
@@ -367,6 +389,12 @@ void dn_unregister_sysctl(void)
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


