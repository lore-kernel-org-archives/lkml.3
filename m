Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab3CBTHp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 14:07:45 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48913 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752225Ab3CBTHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 14:07:43 -0500
Message-ID: <1362251253.3768.127.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH] tty: Prevent deadlock in n_gsm driver
From: Ben Hutchings <ben@decadent.org.uk>
To: Dirkjan Bussink <dirkjan.bussink@nedap.com>
Cc: LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Date: Sat, 02 Mar 2013 19:07:33 +0000
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-2x1jdhKL0Q6YEWJEJnmB"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-2x1jdhKL0Q6YEWJEJnmB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm looking at commit 4d9b109060f690f5c835130ff54165ae157b3087 ('tty:
Prevent deadlock in n_gsm driver') which was cc'd to stable.  This drops
the tty lock in gsm_dlci_release().

I could apply it to 3.2.y with some adjustment, but I checked the
locking context of this function and I think there's another bug to fix.
Tracing back the callers in 3.2.y I found:

gsm_dlci_release
<- gsm_cleanup_mux
   <- gsmld_detach_gsm
      <- gsmld_close
         <- tty_ldisc_close
            <- tty_set_ldisc [with tty_lock]
            <- tty_ldisc_reinit
               <- tty_ldisc_hangup [with tty_lock]
   <- gsmld_config
      <- gsmld_ioctl
         <- tty_ioctl [without tty lock]

and I think the call chains are much the same in mainline.  So
gsmld_config() presumably needs to acquire the tty lock.

Ben.

--=20
Ben Hutchings
Computers are not intelligent.	They only think they are.

--=-2x1jdhKL0Q6YEWJEJnmB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUTJN9ee/yOyVhhEJAQqTSQ/+JyZpYmO5/QI02FKUONBFeDWYJZ/VAB+B
xpTGjqmXr0dvsw0KFJEcq+Zhw9BuSKex8cIRSKgqerGzPjXnZZhXXLER9Zg3WtFv
hLdtg3xlHNcbigNJ8B26nk4WvqTfCX32bGrzoh4gHjnHkcsB22JWC1YBI2MzOvPc
jCqNPsWzaOSV8mYY6Cy2XIr6MoQ41RCmh2MZS6PA8YH0Ccqwg10gdpi9m7IeqfiA
YXcO9yiMk7EulFfJRr1b0OS7gykeoR6eKfL7AGLci0Far6Y8p/s4ZQmAI4ESBt6w
g0muvXnrrWkrU86VasthBDG8qD9NFibhRtQfxcAmjYxc13B5CfaUxqmWNqK7UEuF
gJ6MvclkU6EGsvbVFbsvnJsiQoe4DezGu7s+yLM9C+wABWJsLjwb0JOjxll0SUM6
ObrQ5RfazMJlqBIDbTNNiiZmJRB5TlL0hP4gm9fTcFWMdFYCwmTF8bD4hVhYkRGv
u1MYBa7zFFBAUPjk/CpKqRbycLAuy4MnBcPsESdWZdhx2SFL6D+X38HUozoaLtCy
6u72Z06Yf/k16wc4bK5XYNzj7pj5mKrD4PvuJqj7t3ozIGAH7vDnVzPEk65nPPeo
mccppuHGA2Og4CjSR1ubQC/9AqqHldwKuDWE18/Bmsm6ICbMIQneczRznCyPjbhv
6RiNmxRsO0s=
=M4aj
-----END PGP SIGNATURE-----

--=-2x1jdhKL0Q6YEWJEJnmB--
