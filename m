Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316AbaKFBcw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 20:32:52 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56479 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750970AbaKFBcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 20:32:50 -0500
Message-ID: <1415237557.3398.41.camel@decadent.org.uk>
Subject: [PATCH] rtsx_usb_ms: Use msleep_interruptible() in polling loop
From: Ben Hutchings <ben@decadent.org.uk>
To: Roger Tseng <rogerable@realtek.com>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Date: Thu, 06 Nov 2014 01:32:37 +0000
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Qz5YfK2anvlGSsg8QY9o"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Qz5YfK2anvlGSsg8QY9o
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

rtsx_usb_ms creates a task that mostly sleeps, but tasks in
uninterruptible sleep still contribute to the load average (for
bug-compatibility with Unix).  A load average of ~1 on a system that
should be idle is somewhat alarming.

Change the sleep to be interruptible, but still ignore signals.

A better fix might be to replace this loop with a delayed work item.

References: https://bugs.debian.org/765717
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
Re-sent without the typo in linux-kernel address.

Ben.

 drivers/memstick/host/rtsx_usb_ms.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/memstick/host/rtsx_usb_ms.c b/drivers/memstick/host/rt=
sx_usb_ms.c
index a7282b7..7356780 100644
--- a/drivers/memstick/host/rtsx_usb_ms.c
+++ b/drivers/memstick/host/rtsx_usb_ms.c
@@ -706,7 +706,8 @@ poll_again:
 		if (host->eject)
 			break;
=20
-		msleep(1000);
+		if (msleep_interruptible(1000))
+			flush_signals(current);
 	}
=20
 	complete(&host->detect_ms_exit);


--=20
Ben Hutchings
Beware of programmers who carry screwdrivers. - Leonard Brandwein

--=-Qz5YfK2anvlGSsg8QY9o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVFrPu+e/yOyVhhEJAQrduw//dLRp5mbnzx1r3t+Fq2CnsW3dyUXBfq+5
87wVGKEVm83SV7DClh2X1ysb8BHTKNcXZxujNqH6bX7ZhIWTp9/ErKsKWMzLx9Ty
n6u84lyouJs0BVlLgNCJz2PkBWeX/RWZynMiowBOHwcmXRig8iT5Vyh6ORCvX5bD
Z+V5bvom5MoFBlYvuExQRdubwyb+BP/ROcwS3DYHhoWSCvAsA3xcMpUbTtHb8wx9
ZK7HNhmQMvyE01fPCrVlQSf15E1/jPB6gaYEAo0SHjjYCgNZseX10oVQYGHndfr2
Tiy3MxEu9GKAVeSZHc9Yuf2oxTCUEKSaiTTdRIAaLFBk7+fLNpHBTHApt34/nQNI
lR5eiqnZ8rjqLRRLMKxPQHdWs5o2hYG9v/y/Fpb8lvBHGkTWKXuxKVC7BezsWODa
VsKhbVJ+ofp2/3SEex91JYbOHfne/nKIZw7RSdiI8MzeXm51HDv15Cl9n4tK4DG5
4XwUuqxIqECRevivYG98+J5WR8WYGLM2gOf2ryYS94DXM9AQPMXuVC6LcVK6gsHY
AgPOsbIeRXpZCYD9clcCxLmK2FNuJI0gkqyQ7uSO+cHel6SD4PMHhHlORAEY+B/4
wywUg+fw7L5tP2QskZjAzphy2vI7MmqXYearIUIP2QTEbmJCW2V6pFAIFwTOb3Jy
FX7Q75qmiE0=
=ElTO
-----END PGP SIGNATURE-----

--=-Qz5YfK2anvlGSsg8QY9o--
