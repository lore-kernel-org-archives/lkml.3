Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbaD1IJa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 04:09:30 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:62443 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbaD1IJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 04:09:24 -0400
From: Thomas Schwinge <thomas@codesourcery.com>
To: Jerome Glisse <j.glisse@gmail.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        "Johannes Weiner" <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@surriel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Zlatko Calusic <zcalusic@bitsync.net>,
        Minchan Kim <minchan@kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian =?utf-8?Q?K=C3=B6nig?= <christian.koenig@amd.com>,
        <dri-devel@lists.freedesktop.org>
Subject: Re: radeon: screen garbled after page allocator change, was: Re: [patch v2 3/3] mm: page_alloc: fair zone allocator policy
In-Reply-To: <20140427195527.GC9315@gmail.com>
References: <1375457846-21521-1-git-send-email-hannes@cmpxchg.org> <1375457846-21521-4-git-send-email-hannes@cmpxchg.org> <87r45fajun.fsf@schwinge.name> <20140424133722.GD4107@cmpxchg.org> <20140427033110.GA15091@gmail.com> <20140427195527.GC9315@gmail.com>
User-Agent: Notmuch/0.9-101-g81dad07 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Mon, 28 Apr 2014 10:09:17 +0200
Message-ID: <87ppk1q3iq.fsf@schwinge.name>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg=pgp-sha1;
	protocol="application/pgp-signature"
X-OriginalArrivalTime: 28 Apr 2014 08:09:23.0524 (UTC) FILETIME=[2A4DB040:01CF62B9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi!

On Sun, 27 Apr 2014 15:55:29 -0400, Jerome Glisse <j.glisse@gmail.com> wrot=
e:
> If my ugly patch works does this quirk also work ?

Unfortunately they both don't; see my other email,
<http://news.gmane.org/find-root.php?message_id=3D%3C87sioxq3rx.fsf%40schwi=
nge.name%3E>.


Also, the quirk patch resulted in a NULL pointer dereference in
pci_find_ht_capability+0x4/0x30, which I hacked around as follows:

diff --git drivers/pci/quirks.c drivers/pci/quirks.c
index f025867..33aaad2 100644
=2D-- drivers/pci/quirks.c
+++ drivers/pci/quirks.c
@@ -2452,6 +2452,8 @@ u64 pci_ht_quirk_dma_32bit_only(struct pci_dev *dev, =
u64 mask)
 		struct pci_dev *bridge =3D bus->self;
 		int pos;
=20
+		if (!bridge)
+			goto skip;
 		pos =3D pci_find_ht_capability(bridge, HT_CAPTYPE_SLAVE);
 		if (pos) {
 			int ctrl_off;
@@ -2472,6 +2474,7 @@ u64 pci_ht_quirk_dma_32bit_only(struct pci_dev *dev, =
u64 mask)
 				return 0xffffffff;
 			}
 		}
+	skip:
 		bus =3D bus->parent;
 	} while (bus);
 	return mask;

If needed, I can try to capture more data, but someone who has knowledge
of PCI bus architecture and Linux kernel code (so, not me), might
probably already see what's wrong.


Gr=C3=BC=C3=9Fe,
 Thomas

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAEBAgAGBQJTXgytAAoJENuKOtuXzphJQmIH/jS8Ld0BhAf522qyfvmjTdvH
3KGi0+4NX9ca+Lq6azfZMVUbeHHx+oR9BK4/pjsqEt6sMi3C2svpNwfi5sj/Vt3r
PWeGCptMhnuGvxashuQlh/lcu9oWfIh5HxCUGrjFM8ZtQYj0qkoN/+og38E0fQ72
46AzBNHp/f9h8WWZcCLChXLI9nK41yLwS0DQXSzGVm/M1BADaeBrpRDwtlv6xlYj
LflZcVDPoM7lUU3HjPBeWa91C4QcnJUna2G0FAPJGOtmbG2iUETVWRilonZFOWCq
GT0zVFSCCSI27bUsOeoLj8G93qE1fC62dolqw7i6MUWXfYYJ1fhE1NTDNp+mGx0=
=Wd6Z
-----END PGP SIGNATURE-----
--=-=-=--
