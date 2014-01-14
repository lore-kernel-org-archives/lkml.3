Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbaANSdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 13:33:20 -0500
Received: from smtprelay0014.hostedemail.com ([216.40.44.14]:43167 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751946AbaANSdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 13:33:18 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:800:960:967:973:988:989:1260:1345:1431:1437:1535:1544:1711:1730:1747:1777:1792:1981:2194:2199:2393:2525:2560:2563:2682:2685:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3354:3866:3867:3870:3871:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4605:5007:6117:6119:6261:7903:9025:9388:10004:10026:10049:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12555:12683:13095:13437:13972:21063,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: shoe84_398aa2c669343
X-Filterd-Recvd-Size: 5189
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>
Subject: [PATCH 1/2] audit: Use more current logging style
Date: Tue, 14 Jan 2014 10:33:12 -0800
Message-Id: <f4acac9406b7ec15f859215808e72305e6a3a46a.1389724329.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pr_fmt to prefix "audit: " to output
Convert printk(KERN_<LEVEL> to pr_<level>
Coalesce formats
Use pr_cont
Move a brace after switch

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/audit.c | 38 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 2dc7573..f397ab2 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -41,6 +41,8 @@
  * Example user-space utilities: http://people.redhat.com/sgrubb/audit/
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/init.h>
 #include <asm/types.h>
 #include <linux/atomic.h>
@@ -194,13 +196,12 @@ static void audit_set_portid(struct audit_buffer *ab, __u32 portid)
 
 void audit_panic(const char *message)
 {
-	switch (audit_failure)
-	{
+	switch (audit_failure) {
 	case AUDIT_FAIL_SILENT:
 		break;
 	case AUDIT_FAIL_PRINTK:
 		if (printk_ratelimit())
-			printk(KERN_ERR "audit: %s\n", message);
+			pr_err("%s\n", message);
 		break;
 	case AUDIT_FAIL_PANIC:
 		/* test audit_pid since printk is always losey, why bother? */
@@ -271,9 +272,7 @@ void audit_log_lost(const char *message)
 
 	if (print) {
 		if (printk_ratelimit())
-			printk(KERN_WARNING
-				"audit: audit_lost=%d audit_rate_limit=%d "
-				"audit_backlog_limit=%d\n",
+			pr_warn("audit_lost=%d audit_rate_limit=%d audit_backlog_limit=%d\n",
 				atomic_read(&audit_lost),
 				audit_rate_limit,
 				audit_backlog_limit);
@@ -394,7 +393,7 @@ static void audit_printk_skb(struct sk_buff *skb)
 
 	if (nlh->nlmsg_type != AUDIT_EOE) {
 		if (printk_ratelimit())
-			printk(KERN_NOTICE "type=%d %s\n", nlh->nlmsg_type, data);
+			pr_notice("type=%d %s\n", nlh->nlmsg_type, data);
 		else
 			audit_log_lost("printk limit exceeded\n");
 	}
@@ -411,7 +410,7 @@ static void kauditd_send_skb(struct sk_buff *skb)
 	if (err < 0) {
 		BUG_ON(err != -ECONNREFUSED); /* Shouldn't happen */
 		if (audit_pid) {
-			printk(KERN_ERR "audit: *NO* daemon at audit_pid=%d\n", audit_pid);
+			pr_err("*NO* daemon at audit_pid=%d\n", audit_pid);
 			audit_log_lost("auditd disappeared\n");
 			audit_pid = 0;
 			audit_sock = NULL;
@@ -1056,7 +1055,7 @@ static int __net_init audit_net_init(struct net *net)
 
 	struct audit_net *aunet = net_generic(net, audit_net_id);
 
-	pr_info("audit: initializing netlink socket in namespace\n");
+	pr_info("initializing netlink socket in namespace\n");
 
 	aunet->nlsk = netlink_kernel_create(net, NETLINK_AUDIT, &cfg);
 	if (aunet->nlsk == NULL)
@@ -1097,8 +1096,8 @@ static int __init audit_init(void)
 	if (audit_initialized == AUDIT_DISABLED)
 		return 0;
 
-	pr_info("audit: initializing netlink subsys (%s)\n",
-	       audit_default ? "enabled" : "disabled");
+	pr_info("initializing netlink subsys (%s)\n",
+		audit_default ? "enabled" : "disabled");
 	register_pernet_subsys(&audit_net_ops);
 
 	skb_queue_head_init(&audit_skb_queue);
@@ -1123,7 +1122,7 @@ static int __init audit_enable(char *str)
 	if (!audit_default)
 		audit_initialized = AUDIT_DISABLED;
 
-	pr_info("audit: %s\n", audit_default ?
+	pr_info("%s\n", audit_default ?
 		"enabled (after initialization)" : "disabled (until reboot)");
 
 	return 1;
@@ -1135,15 +1134,16 @@ __setup("audit=", audit_enable);
 static int __init audit_backlog_limit_set(char *str)
 {
 	long int audit_backlog_limit_arg;
+
 	pr_info("audit_backlog_limit: ");
 	if (kstrtol(str, 0, &audit_backlog_limit_arg)) {
-		printk("using default of %d, unable to parse %s\n",
-		       audit_backlog_limit, str);
+		pr_cont("using default of %d, unable to parse %s\n",
+			audit_backlog_limit, str);
 		return 1;
 	}
 	if (audit_backlog_limit_arg >= 0)
 		audit_backlog_limit = (int)audit_backlog_limit_arg;
-	printk("%d\n", audit_backlog_limit);
+	pr_cont("%d\n", audit_backlog_limit);
 
 	return 1;
 }
@@ -1325,11 +1325,9 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
 			}
 		}
 		if (audit_rate_check() && printk_ratelimit())
-			printk(KERN_WARNING
-			       "audit: audit_backlog=%d > "
-			       "audit_backlog_limit=%d\n",
-			       skb_queue_len(&audit_skb_queue),
-			       audit_backlog_limit);
+			pr_warn("audit_backlog=%d > audit_backlog_limit=%d\n",
+				skb_queue_len(&audit_skb_queue),
+				audit_backlog_limit);
 		audit_log_lost("backlog limit exceeded");
 		audit_backlog_wait_time = audit_backlog_wait_overflow;
 		wake_up(&audit_backlog_wait);
-- 
1.8.1.2.459.gbcd45b4.dirty

