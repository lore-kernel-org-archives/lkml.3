Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401Ab3FHDsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 23:48:17 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:46456 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059Ab3FHDsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 23:48:16 -0400
Message-ID: <51B2A955.4010906@gentoo.org>
Date: Fri, 07 Jun 2013 23:47:33 -0400
From: Richard Yao <ryao@gentoo.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130522 Thunderbird/17.0.6
MIME-Version: 1.0
To: Kernel development list <linux-kernel@vger.kernel.org>
CC: "gentoo-dev@lists.gentoo.org" <gentoo-dev@lists.gentoo.org>,
        kernel@gentoo.org, gentooligan@gmail.com
Subject: dm-crypt reordering BIOs across barriers?
X-Enigmail-Version: 1.6a1pre
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2OMTIHKRKPGTCPVMFGOBI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2OMTIHKRKPGTCPVMFGOBI
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

When you use dm-crypt, block IO requests to a dm-* device will invoke
dm_request_fn() -> map_request() -> crypt_map(). If a BIO is a write
barrier, crypt_map() will return DM_MAPIO_REMAPPED to map_request(),
which will immediately queue it to the device.

If a few dozen IOs are queued in rapid succession with multiple write
barriers, all write barriers will be executed before any actual write
BIOs occur because the write IOs will be processed asynchronously in a
work queue. Since the barriers will be long gone by the time the write
IOs are queued, they can be queued in any order.

Am I misunderstanding this or is dm-crypt ignoring proper write barrier
semantics?


------enig2OMTIHKRKPGTCPVMFGOBI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJRsqlcAAoJECDuEZm+6ExkKUAQAIpVsYXbVPpZY/JyPdUDPWcs
YltVHB/2twi7c2j6bZbJIKrdgnZHQD47wqiUJQWVjMk/7kPIrn6ikeyPJFw4Mj+g
DuMX9Ujs+mZLzk/Jw4359kVC+33BWVwb82dregp8MQZUFCtWENlinpXNX/j7TlSK
iySgDbkOEByZ4ycmLXhtFCss/iNYcUy8J/WsTBeRdDAhirebhqvkSjrDlRuE2NT8
2YoZxW+p1/qtmhzjNuiMCR74ai3nPO6fB8UEPZF5KWTTTLklXTSNTUNQLbfq8k9d
uc3+h0VyfN6JgBdXKdxftorhvrzfsXULJHFZWLneXWOYzXClUkSZFfPpM6uxnvVL
pDRLabpXLZIIygMKWvVZQjOQHpB7mnzAcCU/UEU6gvGqKpseEL4ar6ZJOsDK+T53
5AcMSc9cYjLo77IPtlaKicG4BxIHCwJAVU8B9xCYi5hIqbq8q3XgTUivbEutvomv
+IgZ9Ie8/sR5i3Tt+pOrljsVZ9gPIWMeAjd26Yqee26WWI68Em+MVPhB2lmfVsOx
CvUmn3HuKfMPzFUCGzoAKoU9KIN8FVLp10yo9wYtRfyTjJwKq8yC0qwpK9bfayu0
AhpsMhIAgMe2C/5mhH9QOPNfRprWHz89Pv4CCUKY3LRlOYtn4IcN9prFVa2D1se5
VG/CNgR9I97V4zCPO135
=7vK6
-----END PGP SIGNATURE-----

------enig2OMTIHKRKPGTCPVMFGOBI--
