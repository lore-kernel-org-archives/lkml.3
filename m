Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbaE2ILb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 04:11:31 -0400
Received: from mga14.intel.com ([192.55.52.115]:57468 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755249AbaE2IL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 04:11:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="asc'?scan'208";a="349566963"
Date: Thu, 29 May 2014 03:43:45 -0400
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Borislav Petkov <bp@alien8.de>, tony.luck@intel.com, m.chehab@samsung.com,
        linux-acpi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7 v6] trace, RAS: Add eMCA trace event interface
Message-ID: <20140529074345.GA23484@gchen.bj.intel.com>
Mail-Followup-To: Steven Rostedt <rostedt@goodmis.org>,
	Borislav Petkov <bp@alien8.de>, tony.luck@intel.com,
	m.chehab@samsung.com, linux-acpi@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
References: <1400142646-10127-1-git-send-email-gong.chen@linux.intel.com>
 <1401247938-22125-1-git-send-email-gong.chen@linux.intel.com>
 <1401247938-22125-2-git-send-email-gong.chen@linux.intel.com>
 <20140528112832.5f83c66b@gandalf.local.home>
 <20140528163452.GF17196@pd.tnic>
 <20140528125625.6f6dcf7f@gandalf.local.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
In-Reply-To: <20140528125625.6f6dcf7f@gandalf.local.home>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2014 at 12:56:25PM -0400, Steven Rostedt wrote:
> My concern is passing in a large string and wasting a lot of the ring
> buffer space. The max you can hold per event is just under a page size
> (4k). And all these strings add up. If it happens to be 512bytes, then
> you end up with one event per page.
I just don't understand why you say wasting memory. I just pass
a char * not a string array. And most of time these strings are partial ful=
l,
about 1/5 ~ 1/4 spaces are used.

>=20
> Instead of making that a huge string, what about a dynamic array of
> special structures?
>=20
>=20
> struct __attribute__((__packed__)) cper_sec_mem_rec {
> 	short type;
> 	int data;
> };
>=20
>=20
> static struct cper_sec_mem_rec mem_location[CPER_REC_LEN];
>=20
> then have the:
>=20
>  	if (mem->validation_bits & CPER_MEM_VALID_NODE) {
> 		msg[n].type =3D CPER_MEM_VALID_NODE_TYPE;
> 		msg[n++].data =3D mem->node;
> 	}
> 	if (mem->validation_bits & CPER_MEM_VALID_CARD) {
> 		msg[n].type =3D CPER_MEM_VALID_CARD_TYPE;
> 		msg[n++].data =3D mem->card;
> 	}
> 	if (mem->validation_bits & CPER_MEM_VALID_MODULE) {
> [ and so on ]
>=20

This function is not only for perf but for dmesg. So key is how
to handle two strings: dimm_location and mem_location.

I read some __print_symbolic implementations like btrfs trace,

#define show_ref_type(type)                                     \
        __print_symbolic(type,                                  \
        { BTRFS_TREE_BLOCK_REF_KEY,     "TREE_BLOCK_REF" },     \
        { BTRFS_EXTENT_DATA_REF_KEY,    "EXTENT_DATA_REF" },    \
        { BTRFS_EXTENT_REF_V0_KEY,      "EXTENT_REF_V0" },      \
        { BTRFS_SHARED_BLOCK_REF_KEY,   "SHARED_BLOCK_REF" },   \
        { BTRFS_SHARED_DATA_REF_KEY,    "SHARED_DATA_REF" })

So for this case, maybe we need a macro like:

#define show_dimm_location(type)                                \
        __print_symbolic(type,                                  \
        { CPER_MEM_VALID_NODE,          "node" },               \
        { CPER_MEM_VALID_CARD,          "card" },               \
        { CPER_MEM_VALID_MODULE,        "module" },             \
        ...

IMO, it is just another implementation method, maybe more graceful,
but I don't know how it can save space. Again, original functions
work both for trace and dmesg. If we add such interface, it looks
a little bit repeated.

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJThuUxAAoJEI01n1+kOSLH40oQAKFZParhigH7MAHDsgsXaqXH
zGqzV5X8eaGeBFYAEaiICJa5L9jhTlnZg2kas1ODEoJUqLb+BSmQ9A/4JfDx9dk6
ZfLBRCDvffMe8EN8FVU8TQTz81KIm7NDiHnhbys6Bxgn4ZuhgtdA95RCC3o+lKsi
XU619oI5THKOm9ib0k+9kF5XZmkpp+YOqjNix43MtiRHsPqHYCcqWnGkiY78OzFW
GufpYL2YZnGMV/igbVIfYqnTG7atf71BBRUjhzUpphymJarF0PGC6cFgc5s879Cs
mf5ljdPJLwW+mu4hFJuiJDrMVNftoch5N18h6jKSs9wAmTU/UeYqVH5bkVVxABWp
xDSLRdNDbqc8Z5xRIyLDRRiR6P7WXDX0rSUQ5WiX50A5r9aOXT75XrbiwyOou5Jg
WrTGOhUgFqNHEdeIZynAWMaoblYwCge474ce6GbiyoL648FuCKoOUXqtQACPmLIF
huJzpPrtplpRb1UdFs4HsjCQGJJnmdjxdIrIxd/xxRzo7XCHDuYZWMSrz+laaoZ/
vVeZncH6b1eo3w5Ny60pUBlAYa1TC9Rq4GKysN5B7yz/jmbzunGCrbOfJOm0kqUm
/lNKeTFuD63lFcYrO5b7zwb2EOKHoimIXISXF7XWYTqeDlYVyG3GLbqkwvnIMhpf
95IeM7TAXyPF1S5Xk2sm
=1cQQ
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
