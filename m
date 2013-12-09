Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761019Ab3LILeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 06:34:16 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:59918 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759819Ab3LILeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 06:34:13 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Eugene Krasnikov <k.eugene.e@gmail.com>
Cc: Peter Stuge <peter@stuge.se>, "John W. Linville" <linville@tuxdriver.com>,
        ath9k-devel <ath9k-devel@venema.h4ckr.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: wirelesse: wcn36xx: check allocation and trim critical section
In-Reply-To: <CAFSJ42a5ngsShaQPwwjfLxaj3ojvghwTAvCBggG=tPr9oLwhEg@mail.gmail.com>
References: <1385744870-10164-1-git-send-email-mpn@google.com> <20131201004715.11125.qmail@stuge.se> <xa1tiov78kmp.fsf@mina86.com> <CAFSJ42YckTDO=UV=fWG9mmVXSBYep1x6xiHahzGDcrB4dy0oOQ@mail.gmail.com> <878uvw1t49.fsf@mina86.com> <CAFSJ42a5ngsShaQPwwjfLxaj3ojvghwTAvCBggG=tPr9oLwhEg@mail.gmail.com>
User-Agent: Notmuch/0.16+80~g81ee785 (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Mon, 09 Dec 2013 12:34:04 +0100
Message-ID: <8738m2uukz.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Commit [3469adb3: fix potential NULL pointer dereference] introduced
a check of msg_ind allocation, but omitted allocation of msg_ind->msg.
Moreover, it introduced two if statements, which looked a bit clunky.

This commit moves allocation code outside of the critical section so
there's no need to dance around mutex_unlock, and adds the missing
allocation check.

=2D--
 drivers/net/wireless/ath/wcn36xx/smd.c | 32 +++++++++++++++++++-----------=
--
 1 file changed, 19 insertions(+), 13 deletions(-)

On Mon, Dec 09 2013, Eugene Krasnikov wrote:
> hal_ind_mutex suppose to protect msg_ind but with this patch
> allocation will be done outside the critical section.

msg_ind is a local variable which is not shared outside of the function
until it's added to a list.  I don't see how it matters if it's
allocation and initialisation is done under mutex.

In fact, there's another kmalloc call that should be checked and can be
done outside of the critical section, so disregard my previous patch,
here's a new one.

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/=
ath/wcn36xx/smd.c
index 823631c..713e3ce 100644
=2D-- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -2056,22 +2056,28 @@ static void wcn36xx_smd_rsp_process(struct wcn36xx =
*wcn, void *buf, size_t len)
 	case WCN36XX_HAL_OTA_TX_COMPL_IND:
 	case WCN36XX_HAL_MISSED_BEACON_IND:
 	case WCN36XX_HAL_DELETE_STA_CONTEXT_IND:
=2D		mutex_lock(&wcn->hal_ind_mutex);
 		msg_ind =3D kmalloc(sizeof(*msg_ind), GFP_KERNEL);
=2D		if (msg_ind) {
=2D			msg_ind->msg_len =3D len;
=2D			msg_ind->msg =3D kmalloc(len, GFP_KERNEL);
=2D			memcpy(msg_ind->msg, buf, len);
=2D			list_add_tail(&msg_ind->list, &wcn->hal_ind_queue);
=2D			queue_work(wcn->hal_ind_wq, &wcn->hal_ind_work);
=2D			wcn36xx_dbg(WCN36XX_DBG_HAL, "indication arrived\n");
+		if (!msg_ind)
+			goto nomem;
+		msg_ind->msg_len =3D len;
+		msg_ind->msg =3D kmalloc(len, GFP_KERNEL);
+		if (!msg_ind->msg) {
+			kfree(msg_ind);
+nomem:
+			/*
+			 * FIXME: Do something smarter then just
+			 * printing an error.
+			 */
+			wcn36xx_err("Run out of memory while handling SMD_EVENT (%d)\n",
+				    msg_header->msg_type);
+			break;
 		}
+		memcpy(msg_ind->msg, buf, len);
+		mutex_lock(&wcn->hal_ind_mutex);
+		list_add_tail(&msg_ind->list, &wcn->hal_ind_queue);
+		queue_work(wcn->hal_ind_wq, &wcn->hal_ind_work);
 		mutex_unlock(&wcn->hal_ind_mutex);
=2D		if (msg_ind)
=2D			break;
=2D		/* FIXME: Do something smarter then just printing an error. */
=2D		wcn36xx_err("Run out of memory while handling SMD_EVENT (%d)\n",
=2D			    msg_header->msg_type);
+		wcn36xx_dbg(WCN36XX_DBG_HAL, "indication arrived\n");
 		break;
 	default:
 		wcn36xx_err("SMD_EVENT (%d) not supported\n",
=2D-=20
1.8.4


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSpaqsAAoJECBgQBJQdR/0d08P/1aCipZ9r5UUpCGi1lhUOggh
KG8jpc2X7djh9L8I3Eqvu1U0oOPJKEPn0OZoa0pPwJ1uItYVTB5KMt7N3OEAKT69
Fv9I0aZH1AxSqYGZtvo4hCf3IsALxyC41IIax6kbLng25skAonlf9p8DewPEizWj
wpSnmnzMYEGF4PW1eL1S5XGZsli5DN2K9Wkg+pPShxeLPMPzM/I1gR5bWfA5AQ5G
P/yMaucMdJMBD+G3Gs96I+/iNz3FAPkuvdYSQIvUnWMEVlVjFxmNUUv1vhBVu2an
SdIPrdXUWHtFbSX9WBWuuC49Y2Zypko74xMJBHABJ4UA/NJwsj2+upUP2TANuaFT
rPwDh/93Yb6YhXUeqG6PkKZccTaugI9ivyY4kzcqvXoZpd8Ay9OvMb1kYX0fThSL
Vff4cAjyZ3MPdZjQ7uz5+GkJVRafJrGZmUHIaDFdNSE0ZylNWI7NDz5gkU+dVEz7
EATxMujzM/jAf7Enkw4jeKcW3DK022vqGV84wTyBHecLE3TtrzdVtp3dLnPBE/tx
kFgJg7eD8y9T8H30Me/nOE5s5GlBHwPredUMZ3toVakRGFgy+PFd79sGZXXcVIvq
Xv1AKPvS2WI4wCbLD0YuyLvcNBp7lFStCC772zhMjSwjjE9LMwiTjqTA628KtwC6
9cbYgNXeabBg+LEoD+7O
=KNq7
-----END PGP SIGNATURE-----
--=-=-=--
