Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaKJS72 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 13:59:28 -0500
Received: from smtprelay0018.hostedemail.com ([216.40.44.18]:35057 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751590AbaKJS7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 13:59:24 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1543:1711:1730:1747:1777:1792:1801:2393:2559:2562:2689:3138:3139:3140:3141:3142:3354:3865:3866:3867:3870:3871:3872:4321:4605:5007:6261:6742:8603:10004:10848:11026:11473:11658:11914:12043:12048:12296:12438:12517:12519:12555:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: gold01_8ba042da34b2e
X-Filterd-Recvd-Size: 4722
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>, Corey Minyard <minyard@acm.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: Petr Mladek <pmladek@suse.cz>, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
Subject: [PATCH -next 2/2] seq_putc: Convert to return void and convert uses too.
Date: Mon, 10 Nov 2014 10:58:57 -0800
Message-Id: <56c4c0d5ec721134cff4913e5e3f8923169c35ef.1415645477.git.joe@perches.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <cover.1415645476.git.joe@perches.com>
References: <cover.1415645476.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the return value of seq_putc is error-prone, so
make it return void instead.

Reverse the logic in seq_putc to make it like seq_puts.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/char/ipmi/ipmi_msghandler.c                   |  4 +++-
 fs/seq_file.c                                         | 11 ++++++-----
 include/linux/seq_file.h                              |  2 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c |  4 +++-
 net/netfilter/nf_conntrack_expect.c                   |  4 +++-
 5 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index f816211..c12fb30 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -1953,7 +1953,9 @@ static int smi_ipmb_proc_show(struct seq_file *m, void *v)
 	seq_printf(m, "%x", intf->channels[0].address);
 	for (i = 1; i < IPMI_MAX_CHANNELS; i++)
 		seq_printf(m, " %x", intf->channels[i].address);
-	return seq_putc(m, '\n');
+	seq_putc(m, '\n');
+
+	return 0;
 }
 
 static int smi_ipmb_proc_open(struct inode *inode, struct file *file)
diff --git a/fs/seq_file.c b/fs/seq_file.c
index e6be05a..5ca5af9 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -673,13 +673,14 @@ int seq_open_private(struct file *filp, const struct seq_operations *ops,
 }
 EXPORT_SYMBOL(seq_open_private);
 
-int seq_putc(struct seq_file *m, char c)
+void seq_putc(struct seq_file *m, char c)
 {
-	if (m->count < m->size) {
-		m->buf[m->count++] = c;
-		return 0;
+	if (m->count >= m->size) {
+		seq_set_overflow(m);
+		return;
 	}
-	return -1;
+
+	m->buf[m->count++] = c;
 }
 EXPORT_SYMBOL(seq_putc);
 
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index 9b02cb6..c1e47ff 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -115,7 +115,7 @@ ssize_t seq_read(struct file *, char __user *, size_t, loff_t *);
 loff_t seq_lseek(struct file *, loff_t, int);
 int seq_release(struct inode *, struct file *);
 int seq_escape(struct seq_file *, const char *, const char *);
-int seq_putc(struct seq_file *m, char c);
+void seq_putc(struct seq_file *m, char c);
 void seq_puts(struct seq_file *m, const char *s);
 int seq_write(struct seq_file *seq, const void *data, size_t len);
 
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
index a460a87..f0dfe92 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
@@ -300,7 +300,9 @@ static int exp_seq_show(struct seq_file *s, void *v)
 		    __nf_ct_l3proto_find(exp->tuple.src.l3num),
 		    __nf_ct_l4proto_find(exp->tuple.src.l3num,
 					 exp->tuple.dst.protonum));
-	return seq_putc(s, '\n');
+	seq_putc(s, '\n');
+
+	return 0;
 }
 
 static const struct seq_operations exp_seq_ops = {
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 91a1837..7a17070 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -561,7 +561,9 @@ static int exp_seq_show(struct seq_file *s, void *v)
 				   helper->expect_policy[expect->class].name);
 	}
 
-	return seq_putc(s, '\n');
+	seq_putc(s, '\n');
+
+	return 0;
 }
 
 static const struct seq_operations exp_seq_ops = {
-- 
2.1.2

