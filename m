Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbaDVTSj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 15:18:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54106 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751998AbaDVTSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 15:18:35 -0400
Message-ID: <1398194284.7767.101.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH 3.13] core, nfqueue, openvswitch: Orphan frags in
 skb_zerocopy and handle errors
From: Ben Hutchings <ben@decadent.org.uk>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
Cc: Luis Henriques <luis.henriques@canonical.com>,
        David Miller <davem@davemloft.net>, jesse@nicira.com,
        pshelar@nicira.com, tgraf@redhat.com, dev@openvswitch.org,
        pablo@netfilter.org, kadlec@blackhole.kfki.hu, edumazet@google.com,
        dborkman@redhat.com, therbert@google.com, jasowang@redhat.com,
        fw@strlen.de, joe@perches.com, horms@verge.net.au, jiri@resnulli.us,
        mst@redhat.com, Paul.Durrant@citrix.com, JBeulich@suse.com,
        herbert@gondor.apana.org.au, mszeredi@suse.cz,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Tue, 22 Apr 2014 20:18:04 +0100
In-Reply-To: <5356AEBF.5010505@citrix.com>
References: <1395873465-22282-1-git-send-email-zoltan.kiss@citrix.com>
		 <20140327.152956.1528740039185894234.davem@davemloft.net>
		 <20140421112601.GC3200@hercules>
	 <1398181118.3624.203.camel@deadeye.wl.decadent.org.uk>
	 <5356AEBF.5010505@citrix.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Vv0pKuM1AUvurcOJjlxB"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Vv0pKuM1AUvurcOJjlxB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Zoltan Kiss <zoltan.kiss@citrix.com>

commit 36d5fe6a000790f56039afe26834265db0a3ad4c upstream.

skb_zerocopy can copy elements of the frags array between skbs, but it does=
n't
orphan them. Also, it doesn't handle errors, so this patch takes care of th=
at
as well, and modify the callers accordingly. skb_tx_error() is also added t=
o
the callers so they will signal the failed delivery towards the creator of =
the
skb.

Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.13: skb_zerocopy() is new in 3.14, but was moved from=
 a
 static function in nfnetlink_queue.  We need to patch that and its caller,=
 but
 not openvswitch.]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
On Tue, 2014-04-22 at 19:02 +0100, Zoltan Kiss wrote:
> On 22/04/14 16:38, Ben Hutchings wrote:
> > On Mon, 2014-04-21 at 12:26 +0100, Luis Henriques wrote:
> >> Hi David,
> >>
> >> On Thu, Mar 27, 2014 at 03:29:56PM -0400, David Miller wrote:
> >>> From: Zoltan Kiss <zoltan.kiss@citrix.com>
> >>> Date: Wed, 26 Mar 2014 22:37:45 +0000
> >>>
> >>>> skb_zerocopy can copy elements of the frags array between skbs, but =
it doesn't
> >>>> orphan them. Also, it doesn't handle errors, so this patch takes car=
e of that
> >>>> as well, and modify the callers accordingly. skb_tx_error() is also =
added to
> >>>> the callers so they will signal the failed delivery towards the crea=
tor of the
> >>>> skb.
> >>>>
> >>>> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
> >>>
> >>> Fingers crossed :-)  Applied, thanks Zoltan.
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe netdev" in
> >>> the body of a message to majordomo@vger.kernel.org
> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> >> Could you please queue this for stable as well?  It has CVE-2014-2568
> >> assigned to it and I believe it is applicable to some of the trees.
> >
> > It was applied to 3.13, but needs backporting to earlier versions.  I
> > posted my attempt in
> > <1397429860.10849.86.camel@deadeye.wl.decadent.org.uk> but it needs
> > testing/reviewing.
>=20
> This one is a different issue, although it is very similar.

Sorry for mixing these up.  I believe this bug has been present since
zerocopy was added to nfqueue in Linux 3.10 (commit ae08ce002108).  This
is the version I used for Debian's 3.13 branch, which might be usable
for older stable branches too.

Ben.

---
--- a/net/netfilter/nfnetlink_queue_core.c
+++ b/net/netfilter/nfnetlink_queue_core.c
@@ -235,22 +235,23 @@ nfqnl_flush(struct nfqnl_instance *queue
 	spin_unlock_bh(&queue->lock);
 }
=20
-static void
+static int
 nfqnl_zcopy(struct sk_buff *to, const struct sk_buff *from, int len, int h=
len)
 {
 	int i, j =3D 0;
 	int plen =3D 0; /* length of skb->head fragment */
+	int ret;
 	struct page *page;
 	unsigned int offset;
=20
 	/* dont bother with small payloads */
-	if (len <=3D skb_tailroom(to)) {
-		skb_copy_bits(from, 0, skb_put(to, len), len);
-		return;
-	}
+	if (len <=3D skb_tailroom(to))
+		return skb_copy_bits(from, 0, skb_put(to, len), len);
=20
 	if (hlen) {
-		skb_copy_bits(from, 0, skb_put(to, hlen), hlen);
+		ret =3D skb_copy_bits(from, 0, skb_put(to, hlen), hlen);
+		if (unlikely(ret))
+			return ret;
 		len -=3D hlen;
 	} else {
 		plen =3D min_t(int, skb_headlen(from), len);
@@ -268,6 +269,11 @@ nfqnl_zcopy(struct sk_buff *to, const st
 	to->len +=3D len + plen;
 	to->data_len +=3D len + plen;
=20
+	if (unlikely(skb_orphan_frags(from, GFP_ATOMIC))) {
+		skb_tx_error(from);
+		return -ENOMEM;
+	}
+
 	for (i =3D 0; i < skb_shinfo(from)->nr_frags; i++) {
 		if (!len)
 			break;
@@ -278,6 +284,8 @@ nfqnl_zcopy(struct sk_buff *to, const st
 		j++;
 	}
 	skb_shinfo(to)->nr_frags =3D j;
+
+	return 0;
 }
=20
 static int
@@ -374,13 +382,16 @@ nfqnl_build_packet_message(struct net *n
=20
 	skb =3D nfnetlink_alloc_skb(net, size, queue->peer_portid,
 				  GFP_ATOMIC);
-	if (!skb)
+	if (!skb) {
+		skb_tx_error(entskb);
 		return NULL;
+	}
=20
 	nlh =3D nlmsg_put(skb, 0, 0,
 			NFNL_SUBSYS_QUEUE << 8 | NFQNL_MSG_PACKET,
 			sizeof(struct nfgenmsg), 0);
 	if (!nlh) {
+		skb_tx_error(entskb);
 		kfree_skb(skb);
 		return NULL;
 	}
@@ -504,13 +515,15 @@ nfqnl_build_packet_message(struct net *n
 		nla->nla_type =3D NFQA_PAYLOAD;
 		nla->nla_len =3D nla_attr_size(data_len);
=20
-		nfqnl_zcopy(skb, entskb, data_len, hlen);
+		if (nfqnl_zcopy(skb, entskb, data_len, hlen))
+			goto nla_put_failure;
 	}
=20
 	nlh->nlmsg_len =3D skb->len;
 	return skb;
=20
 nla_put_failure:
+	skb_tx_error(entskb);
 	kfree_skb(skb);
 	net_err_ratelimited("nf_queue: error creating packet message\n");
 	return NULL;

--=20
Ben Hutchings
Beware of programmers who carry screwdrivers. - Leonard Brandwein

--=-Vv0pKuM1AUvurcOJjlxB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIUAwUAU1bAbOe/yOyVhhEJAQomXw/41oNtg+4/VhTYXH8KRy6ZJTszBaTKJOJA
nliM1dunH40tnT6dPtfsqMPiqHX4LAsprABSpUNXt7JvryPYTqzeM121YirhUtfi
7OMdY/N3x11c2zi+8av16Ia6ccVqFUhOoRIlKPYlJI9CPwIB4m+TtLWRiesKUU+m
oh+llBUYRnXhCaZI5Fi4ZkBBfFLnmoaF7hp7Uz4VvjKJFMvAZ8fEAtb4dzSt1upH
IfpIaANPVVAyYy/yAOine8xfxFDaWbMcrTWlJazIzJvqfQGfL0IBql0PFpGW4tki
C0Od6hExVtO7cCIiHw3KXQgjUiR4VbykVqi1xAU9a9K6WeimbCMZJumdauSZEw+1
/CZgr/GWj7kbWCDiZJG3fFK0SQEvC5YcwfWN/ZlmTA13mAseN5R8V2cF7Neki1ZD
KoFiypUHFIpWpGf/BKuaYsafCyd+MoaPvYhzK+G5kIdXFvvlSTQmq57L6y4HyZXp
6YyR4/K+IXaEWK8yJuIf9lzobKzPsEogNVq5qqazv0P1kXWLnKGVJMuq55KEVLqE
S2EouZjinfleE571va9hyEo05n3yUPulyaZ8JqteLl1xQWMhlVPQ3+P655lz5fEu
kdOmZbwe2fxqNsb2i+4f3ABHWWprt7KIgUgNli7SiOsMyOspGmekHOdrWUzl41yC
HjRBM7IEyw==
=B9oh
-----END PGP SIGNATURE-----

--=-Vv0pKuM1AUvurcOJjlxB--
