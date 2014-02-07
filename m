Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750768AbaBGGAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 01:00:46 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:38920 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaBGGAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 01:00:45 -0500
Date: Thu, 6 Feb 2014 23:58:32 -0600
From: David Fries <david@fries.net>
To: zbr@ioremap.net
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] w1: refcnt fix, skip non-error send, docs
Message-ID: <20140207055832.GN5342@spacedout.fries.net>
References: <1391390104-31154-1-git-send-email-David@Fries.net>
 <9071391471978@web15j.yandex.ru>
 <20140204055131.GI5342@spacedout.fries.net>
 <253061391557725@web20g.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <253061391557725@web20g.yandex.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Thu, 06 Feb 2014 23:58:33 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 05, 2014 at 03:48:45AM +0400, zbr@ioremap.net wrote:
> Hi
> 
> 04.02.2014, 09:51, "David Fries" <david@fries.net>:
> > Help me understand what the protocol is supposed to be.  Assuming
> > there aren't any errors, is there supposed to be a
> > w1_netlink_send_error generated reply per netlink packet (cn_msg), per
> > w1_netlink_msg, or per w1_netlink_cmd?
> 
> reply should be sent per cmd to specify each command status
> If there is no cmd in request or we didn't get to it (like failed to reset device), we should send error.
> 
> Depending on how w1-msg + (optional) w1-cmd are packed, client can detect what exact error happend
> 
> > What about the cn_msg seq and ack values?  I assume the kernel
> > response should carry the same seq number as the request, but what
> > should the ack be set to?
> 
> reply ack is seq + 1
> seq is the same to highlight request it belongs to

Here's a patch to implement that.  Is this what you have in mind?

>From 4ed65d81b0121a8c191a9833d041484e9097198b Mon Sep 17 00:00:00 2001
From: David Fries <David@Fries.net>
Date: Thu, 6 Feb 2014 23:45:05 -0600
Subject: [PATCH] w1: correct cn_msg ack, no change or seq + 1

Netlink messages sent from the kernel consists of kernel generated
notifications for adds or removes, the error message (also indicates
the message has been processed), and the messages that have data to
return.  The cn_msg ack is left alone for the first two, and when
returning data it is the sequence number + 1.  Modifying the code to
the protocol standard.

Signed-off-by: David Fries <David@Fries.net>
---
 Documentation/connector/connector.txt |    2 +-
 drivers/w1/w1_netlink.c               |    6 +-----
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/Documentation/connector/connector.txt b/Documentation/connector/connector.txt
index 9bdfc1a..0bc3522 100644
--- a/Documentation/connector/connector.txt
+++ b/Documentation/connector/connector.txt
@@ -115,7 +115,7 @@ acknowledge number MUST be the same + 1.
 If we receive a message and its sequence number is not equal to one we
 are expecting, then it is a new message.  If we receive a message and
 its sequence number is the same as one we are expecting, but its
-acknowledge is not equal to the acknowledge number in the original
+acknowledge is not equal to the sequence number in the original
 message + 1, then it is a new message.
 
 Obviously, the protocol header contains the above id.
diff --git a/drivers/w1/w1_netlink.c b/drivers/w1/w1_netlink.c
index 3c81689..d98b550 100644
--- a/drivers/w1/w1_netlink.c
+++ b/drivers/w1/w1_netlink.c
@@ -59,7 +59,6 @@ static void w1_send_slave(struct w1_master *dev, u64 rn)
 	avail = dev->priv_size - cmd->len;
 
 	if (avail < 8) {
-		msg->ack++;
 		cn_netlink_send(msg, dev->portid, 0, GFP_KERNEL);
 
 		msg->len = sizeof(struct w1_netlink_msg) +
@@ -130,7 +129,6 @@ static int w1_get_slaves(struct w1_master *dev,
 			W1_ALARM_SEARCH : W1_SEARCH, w1_found_send_slave);
 	}
 
-	msg->ack = 0;
 	cn_netlink_send(msg, dev->portid, 0, GFP_KERNEL);
 
 	dev->priv = NULL;
@@ -308,7 +306,7 @@ static int w1_process_command_root(struct cn_msg *msg,
 	cn->id.val = CN_W1_VAL;
 
 	cn->seq = msg->seq;
-	cn->ack = 1;
+	cn->ack = msg->seq + 1;
 	cn->len = sizeof(struct w1_netlink_msg);
 	w = (struct w1_netlink_msg *)(cn + 1);
 
@@ -321,7 +319,6 @@ static int w1_process_command_root(struct cn_msg *msg,
 	list_for_each_entry(m, &w1_masters, w1_master_entry) {
 		if (cn->len + sizeof(*id) > PAGE_SIZE - sizeof(struct cn_msg)) {
 			cn_netlink_send(cn, portid, 0, GFP_KERNEL);
-			cn->ack++;
 			cn->len = sizeof(struct w1_netlink_msg);
 			w->len = 0;
 			id = (u32 *)(w + 1);
@@ -332,7 +329,6 @@ static int w1_process_command_root(struct cn_msg *msg,
 		cn->len += sizeof(*id);
 		id++;
 	}
-	cn->ack = 0;
 	cn_netlink_send(cn, portid, 0, GFP_KERNEL);
 	mutex_unlock(&w1_mlock);
 
-- 
1.7.10.4

