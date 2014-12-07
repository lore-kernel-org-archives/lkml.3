Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbaLGUKz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 15:10:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39772 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624AbaLGUKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 15:10:51 -0500
Date: Sun, 7 Dec 2014 12:10:49 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 3.17.6
Message-ID: <20141207201049.GB12806@kroah.com>
References: <20141207201043.GA12806@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141207201043.GA12806@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 42585f6a819a..bb43e9e6a79c 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION = 3
 PATCHLEVEL = 17
-SUBLEVEL = 5
+SUBLEVEL = 6
 EXTRAVERSION =
 NAME = Shuffling Zombie Juror
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index ec94ba94079f..de88c4ab5146 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -611,16 +611,12 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	 */
 	NF_CT_ASSERT(!nf_ct_is_confirmed(ct));
 	pr_debug("Confirming conntrack %p\n", ct);
-
-	/* We have to check the DYING flag after unlink to prevent
-	 * a race against nf_ct_get_next_corpse() possibly called from
-	 * user context, else we insert an already 'dead' hash, blocking
-	 * further use of that particular connection -JM.
-	 */
-	nf_ct_del_from_dying_or_unconfirmed_list(ct);
+	/* We have to check the DYING flag inside the lock to prevent
+	   a race against nf_ct_get_next_corpse() possibly called from
+	   user context, else we insert an already 'dead' hash, blocking
+	   further use of that particular connection -JM */
 
 	if (unlikely(nf_ct_is_dying(ct))) {
-		nf_ct_add_to_dying_list(ct);
 		nf_conntrack_double_unlock(hash, reply_hash);
 		local_bh_enable();
 		return NF_ACCEPT;
@@ -640,6 +636,8 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 		    zone == nf_ct_zone(nf_ct_tuplehash_to_ctrack(h)))
 			goto out;
 
+	nf_ct_del_from_dying_or_unconfirmed_list(ct);
+
 	/* Timer relative to confirmation time, not original
 	   setting time, otherwise we'd get timer wrap in
 	   weird delay cases. */
