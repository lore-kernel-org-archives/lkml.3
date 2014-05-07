Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933977AbaEGPwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:52:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46566 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933879AbaEGPvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:51:46 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: Re: [3.8.y.z extended stable] Linux 3.8.13.23
Date: Wed,  7 May 2014 08:51:42 -0700
Message-Id: <1399477902-6798-2-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399477902-6798-1-git-send-email-kamal@canonical.com>
References: <1399477902-6798-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index f56d086..b3c5f9d 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 3
 PATCHLEVEL = 8
 SUBLEVEL = 13
-EXTRAVERSION = .22
+EXTRAVERSION = .23
 NAME = Remoralised Urchins Update
 
 # *DOCUMENTATION*
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 2ddd64a..408111f 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3053,7 +3053,10 @@ static int raw_cmd_copyout(int cmd, void __user *param,
 	int ret;
 
 	while (ptr) {
-		ret = copy_to_user(param, ptr, sizeof(*ptr));
+		struct floppy_raw_cmd cmd = *ptr;
+		cmd.next = NULL;
+		cmd.kernel_data = NULL;
+		ret = copy_to_user(param, &cmd, sizeof(cmd));
 		if (ret)
 			return -EFAULT;
 		param += sizeof(struct floppy_raw_cmd);
@@ -3107,10 +3110,11 @@ loop:
 		return -ENOMEM;
 	*rcmd = ptr;
 	ret = copy_from_user(ptr, param, sizeof(*ptr));
-	if (ret)
-		return -EFAULT;
 	ptr->next = NULL;
 	ptr->buffer_length = 0;
+	ptr->kernel_data = NULL;
+	if (ret)
+		return -EFAULT;
 	param += sizeof(struct floppy_raw_cmd);
 	if (ptr->cmd_count > 33)
 			/* the command may now also take up the space
@@ -3126,7 +3130,6 @@ loop:
 	for (i = 0; i < 16; i++)
 		ptr->reply[i] = 0;
 	ptr->resultcode = 0;
-	ptr->kernel_data = NULL;
 
 	if (ptr->flags & (FD_RAW_READ | FD_RAW_WRITE)) {
 		if (ptr->length <= 0)
diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 9365978..2058e94 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -2067,8 +2067,12 @@ static ssize_t n_tty_write(struct tty_struct *tty, struct file *file,
 			if (tty->ops->flush_chars)
 				tty->ops->flush_chars(tty);
 		} else {
+			struct n_tty_data *ldata = tty->disc_data;
+
 			while (nr > 0) {
+				mutex_lock(&ldata->output_lock);
 				c = tty->ops->write(tty, b, nr);
+				mutex_unlock(&ldata->output_lock);
 				if (c < 0) {
 					retval = c;
 					goto break_out;
diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index a8ae287..9a2cec6 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -428,7 +428,7 @@ static bool dccp_new(struct nf_conn *ct, const struct sk_buff *skb,
 	const char *msg;
 	u_int8_t state;
 
-	dh = skb_header_pointer(skb, dataoff, sizeof(_dh), &dh);
+	dh = skb_header_pointer(skb, dataoff, sizeof(_dh), &_dh);
 	BUG_ON(dh == NULL);
 
 	state = dccp_state_table[CT_DCCP_ROLE_CLIENT][dh->dccph_type][CT_DCCP_NONE];
@@ -485,7 +485,7 @@ static int dccp_packet(struct nf_conn *ct, const struct sk_buff *skb,
 	u_int8_t type, old_state, new_state;
 	enum ct_dccp_roles role;
 
-	dh = skb_header_pointer(skb, dataoff, sizeof(_dh), &dh);
+	dh = skb_header_pointer(skb, dataoff, sizeof(_dh), &_dh);
 	BUG_ON(dh == NULL);
 	type = dh->dccph_type;
 
@@ -576,7 +576,7 @@ static int dccp_error(struct net *net, struct nf_conn *tmpl,
 	unsigned int cscov;
 	const char *msg;
 
-	dh = skb_header_pointer(skb, dataoff, sizeof(_dh), &dh);
+	dh = skb_header_pointer(skb, dataoff, sizeof(_dh), &_dh);
 	if (dh == NULL) {
 		msg = "nf_ct_dccp: short packet ";
 		goto out_invalid;
