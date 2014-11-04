Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbaKDBtW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 20:49:22 -0500
Received: from mail-pd0-f194.google.com ([209.85.192.194]:64764 "EHLO
	mail-pd0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbaKDBtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 20:49:20 -0500
From: "billbonaparte" <programme110@gmail.com>
To: <fw@strlen.de>
Cc: <linux-kernel@vger.kernel.org>, "Pablo Neira Ayuso" <pablo@netfilter.org>,
        "Patrick McHardy" <kaber@trash.net>, <kadlec@blackhole.kfki.hu>,
        <davem@davemloft.net>, "Changli Gao" <xiaosuo@gmail.com>,
        "Jesper Dangaard Brouer" <brouer@redhat.com>,
        "Andrey Vagin" <avagin@openvz.org>
Subject: Re: netfilter: nf_conntrack: there maybe a bug in __nf_conntrack_confirm, when it race against get_next_corpse
Date: Tue, 4 Nov 2014 09:48:32 +0800
Message-ID: <012601cff7d1$7ce2d620$76a88260$@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0127_01CFF814.8B094A70"
X-Mailer: Microsoft Outlook 14.0
Thread-Index: Ac/30PYSucSRULmNTf2aYVpAYaLsJg==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multipart message in MIME format.

------=_NextPart_000_0127_01CFF814.8B094A70
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

(sorry to send this e-mail again, last mail is rejected by server due to
non-acceptable content)

Florian Westphal [mailto:fw@strlen.de] wrote:
>Correct.  This is broken since the central spin lock removal, since 
>nf_conntrack_lock no longer protects both get_next_corpse and 
>conntrack_confirm.
> 
>Please send a patch, moving dying check after removal of conntrack from 
>the percpu list,
Since unconfirmed conntrack is stored in unconfirmed-list which is per-cpu
list and protected by per-cpu spin-lock, we can remove it from
uncomfirmed-list and insert it into ct-hash-table separately. that is to
say, we can remove it from uncomfirmed-list without holding corresponding
hash-lock, then check if it is dying.
if it is dying, we add it to the dying-list, then quit
__nf_conntrack_confirm. we do this to follow the rules that the conntrack
must alternatively at unconfirmed-list or dying-list when it is abort to be
destroyed.

>> 	2. operation on ct->status should be atomic, because it race aginst 
>> get_next_corpse.
>
>Alternatively we could also get rid of the unconfirmed list handling in
get_next_corpse, 
>it looks to me as if its simply not worth the trouble to also caring 
>about
unconfirmed lists.

yes, I think so. 
if there is a race at operating ct->status, there will be in alternative
case:
1) IPS_DYING bit which set in get_next_corpse override other bits (e.g.
IPS_SRC_NAT_DONE_BIT), or
2) other bits (e.g. IPS_SRC_NAT_DONE_BIT) which set in nf_nat_setup_info
override IPS_DYING bit.
but, any case seems to be okay.

------=_NextPart_000_0127_01CFF814.8B094A70
Content-Type: application/octet-stream;
	name="fix_conntrack_confirm_race.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="fix_conntrack_confirm_race.patch"

>From c454ca5a96f5b6f815fe29cc2c91c92d719d7b95 Mon Sep 17 00:00:00 2001=0A=
From: bill bonaparte <programme110@gmail.com>=0A=
Date: Mon, 3 Nov 2014 17:13:51 +0800=0A=
Subject: [PATCH] netfilter: nf_conntrack: fix a race in=0A=
 __nf_conntrack_confirm against nf_ct_get_next_corpse=0A=
=0A=
After we remove central spinlock nf_conntrack_lock, we get the race =
against nf_ct_get_next_corpse again,=0A=
to get rid of this race, we should remove the conntrack from the =
unconfirmed-list (which is per-cpu list) firstly,=0A=
then check if it is dying.=0A=
---=0A=
 net/netfilter/nf_conntrack_core.c |   28 ++++++++++++++++------------=0A=
 1 files changed, 16 insertions(+), 12 deletions(-)=0A=
=0A=
diff --git a/net/netfilter/nf_conntrack_core.c =
b/net/netfilter/nf_conntrack_core.c=0A=
index 5016a69..5d54a18 100644=0A=
--- a/net/netfilter/nf_conntrack_core.c=0A=
+++ b/net/netfilter/nf_conntrack_core.c=0A=
@@ -589,6 +589,22 @@ __nf_conntrack_confirm(struct sk_buff *skb)=0A=
 =0A=
 	zone =3D nf_ct_zone(ct);=0A=
 	local_bh_disable();=0A=
+	=0A=
+	/* We have to check the DYING flag after unlink the conntrack=0A=
+	   to prevent a race against nf_ct_get_next_corpse() possibly =0A=
+	   called from user context, else we insert an already 'dead' hash, =0A=
+	   blocking further use of that particular connection -JM */=0A=
+	nf_ct_del_from_dying_or_unconfirmed_list(ct);=0A=
+	=0A=
+	if (unlikely(nf_ct_is_dying(ct))) {=0A=
+	    /* let's follow the rules that the conntrack must=0A=
+	       alternatively at the unconfirmed-list or dying-list=0A=
+	       when it is abort to be destoryed =0A=
+	     */=0A=
+		nf_ct_add_to_dying_list(ct);=0A=
+		local_bh_enable();=0A=
+		return NF_ACCEPT;=0A=
+	}=0A=
 =0A=
 	do {=0A=
 		sequence =3D read_seqcount_begin(&net->ct.generation);=0A=
@@ -611,16 +627,6 @@ __nf_conntrack_confirm(struct sk_buff *skb)=0A=
 	 */=0A=
 	NF_CT_ASSERT(!nf_ct_is_confirmed(ct));=0A=
 	pr_debug("Confirming conntrack %p\n", ct);=0A=
-	/* We have to check the DYING flag inside the lock to prevent=0A=
-	   a race against nf_ct_get_next_corpse() possibly called from=0A=
-	   user context, else we insert an already 'dead' hash, blocking=0A=
-	   further use of that particular connection -JM */=0A=
-=0A=
-	if (unlikely(nf_ct_is_dying(ct))) {=0A=
-		nf_conntrack_double_unlock(hash, reply_hash);=0A=
-		local_bh_enable();=0A=
-		return NF_ACCEPT;=0A=
-	}=0A=
 =0A=
 	/* See if there's one in the list already, including reverse:=0A=
 	   NAT could have grabbed it without realizing, since we're=0A=
@@ -636,8 +642,6 @@ __nf_conntrack_confirm(struct sk_buff *skb)=0A=
 		    zone =3D=3D nf_ct_zone(nf_ct_tuplehash_to_ctrack(h)))=0A=
 			goto out;=0A=
 =0A=
-	nf_ct_del_from_dying_or_unconfirmed_list(ct);=0A=
-=0A=
 	/* Timer relative to confirmation time, not original=0A=
 	   setting time, otherwise we'd get timer wrap in=0A=
 	   weird delay cases. */=0A=
-- =0A=
1.7.5.4=0A=
=0A=

------=_NextPart_000_0127_01CFF814.8B094A70--

