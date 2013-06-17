Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299Ab3FQIHq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 04:07:46 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56232 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122Ab3FQIHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 04:07:44 -0400
Date: Mon, 17 Jun 2013 18:07:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>, Glauber Costa <glommer@openvz.org>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>
Subject: linux-next: manual merge of the akpm tree with the kvm tree
Message-Id: <20130617180735.c10c058469ce0633c65225a4@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Jun_2013_18_07_35_+1000_kSj6GGA/6hQbFOWY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Jun_2013_18_07_35_+1000_kSj6GGA/6hQbFOWY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
arch/x86/kvm/mmu.c between commit 365c886860c4 ("KVM: MMU: reclaim the
zapped-obsolete page first") from the kvm tree and commit "shrinker:
convert remaining shrinkers to count/scan API" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/kvm/mmu.c
index 6941fa7,422493d..0000000
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@@ -4312,12 -4213,8 +4312,13 @@@ restart
  	spin_unlock(&kvm->mmu_lock);
  }
 =20
 +static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
 +{
 +	return unlikely(!list_empty_careful(&kvm->arch.zapped_obsolete_pages));
 +}
 +
- static int mmu_shrink(struct shrinker *shrink, struct shrink_control *sc)
+ static long
+ mmu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
  {
  	struct kvm *kvm;
  	int nr_to_scan =3D sc->nr_to_scan;
@@@ -4352,16 -4246,9 +4351,16 @@@
  		idx =3D srcu_read_lock(&kvm->srcu);
  		spin_lock(&kvm->mmu_lock);
 =20
 +		if (kvm_has_zapped_obsolete_pages(kvm)) {
 +			kvm_mmu_commit_zap_page(kvm,
 +			      &kvm->arch.zapped_obsolete_pages);
 +			goto unlock;
 +		}
 +
- 		prepare_zap_oldest_mmu_page(kvm, &invalid_list);
+ 		freed +=3D prepare_zap_oldest_mmu_page(kvm, &invalid_list);
  		kvm_mmu_commit_zap_page(kvm, &invalid_list);
 =20
 +unlock:
  		spin_unlock(&kvm->mmu_lock);
  		srcu_read_unlock(&kvm->srcu, idx);
 =20

--Signature=_Mon__17_Jun_2013_18_07_35_+1000_kSj6GGA/6hQbFOWY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRvsPLAAoJEECxmPOUX5FEJ98P/1k6sW/8muJ/+ObkuH1XbRHH
RISYKs3AOY37bwz4jr+q9ccBBoPQN8M5jf+EicBqXpWxEqNooaHjaZ2TTX7D6UnK
+A26wHNq0PuznXozUtwDQ6ntt1JDJN0umY78I762BXhE+5fHQJE8kk6hiYgu6V8a
O0/+eMPYQe9W7HCKePH3gD86bCsHk7yFRl646IKvmQJSGbrgg5jU+OXvL30th5+D
nO3yW6ZOv/iiJ6Q6KAeSK6PY+QAUF1K15JVUQ5zny1szgah9Rnfmc7ndgn1tYD09
8vWF3wOZdVrC7L0VPlgpd5Rzx5Ybeb1PmnJEZXTCXFMJ8nYXWLHVxmzdI8wKO7nl
3LWZHUDIkDdPkIXFzwV8mvt2y4lV/KXDMSNIa4EGc892HWv3XAZ79naWkmg3mecw
aGf0qI+8YXTw0fGQHcOt5gE1rKON+wYq6h5y+ozBmk4cSaMp2F8TEja0PlbRpVkA
7rGFjUK+Q+tt68zIzixoiQtuAgevoXqpTOE7AjTlG8cY7euL4IQBNBbU5SKC+hIj
pdsMMyEsPFMQSX7FZaPVTAj1QiBtuVu5cp3eDyvWs9E+y5SRXPDlDaYqr47sg0/F
qB4pNDd4/XlNDNgv5jVUuGnlov/Trsoi95cQbDWq7EIdiMnFkkg8dqmUX37u7IT2
IzMFzXWBKyyUDk6mJ2fE
=snIw
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Jun_2013_18_07_35_+1000_kSj6GGA/6hQbFOWY--
