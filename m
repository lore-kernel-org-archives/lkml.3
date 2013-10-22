Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab3JVNXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 09:23:12 -0400
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:38491 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab3JVNXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 09:23:10 -0400
Date: Tue, 22 Oct 2013 15:23:03 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Dirk Gouders <dirk@gouders.net>
Cc: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
        Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, sw@simonwunderlich.de
Subject: Re: [BUG bisected] WARNING: CPU: 0 PID: 1550 at
 net/wireless/chan.c:373 cfg80211_chandef_usable+0x30/0x15f()
Message-ID: <20131022132303.GA14762@pandem0nium>
References: <gifvruyge3.fsf@karga.hank.lab>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
In-Reply-To: <gifvruyge3.fsf@karga.hank.lab>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-purgate: clean
X-purgate-type: clean
X-purgate-ID: 154106::1382448185-00007495-496CD30A/0-0/0-0
X-Scan-AV: cora.hrz.tu-chemnitz.de;2013-10-22 15:23:05;4cec88815c2f28cb41b15f2ce03e9fd5
X-Scan-SA: cora.hrz.tu-chemnitz.de;2013-10-22 15:23:05;9a5a83e1433d51edd1ca147cc7570418
X-Spam-Score: -1.0 (-)
X-Spam-Report: --- Textanalyse SpamAssassin 3.3.1 (-1.0 Punkte)
 Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
 * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
 --- Ende Textanalyse
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Dirk,

thanks a lot for your report. I have looked at your trace and the patch
again, but so far I'm not sure where the problem comes from. Could you
please help by providing:

 * your wpa_supplicant config (censor your passwords!) - I guess you have
   some ad-hoc networks configured?
 * your wpa_supplicant command line parameters when running
 * environment infos - are there IBSS networks next to your notebook?

=46rom what I've seen so far:

 * the following warning in cfg80211_chandef_usable() fails:=20

     if (WARN_ON(!cfg80211_chandef_valid(chandef)))

 * cfg80211_chandef_usable() is most probably called by
   cfg80211_reg_can_beacon(), which is called from __ieee80211_sta_join_ibs=
s()
 * the worker appearently creates the IBSS network using ifibss->chandef,
   which appearently turns out to be invalid.
 * ifibss->chandef gets initialized from in ieee80211_ibss_join() from the =
upper
   level parameters and is not changed later.
 * at least nl80211 calls reg_can_bacon() as well and checks the chandef be=
fore
   proceeding. wext looks ok too.

Therefore I'm not sure how the chandef gets broken ...

Thanks,
	Simon

On Mon, Oct 21, 2013 at 02:09:40PM +0200, Dirk Gouders wrote:
> Hello Simon, all,
>=20
> Recently, I noticed many traces (find a sample attached) in situations
> when wpa_supplicant is running but no appropriate access-point available.
>=20
> I started a bisect and ended at commit 3aede78aad2a7e
> (mac80211: change IBSS channel state to chandef).
>=20
> Please let me know if you need more information to inspect this problem.
>=20
> Best regards,
>=20
> Dirk
>=20
> ------------------------------------------------------------------------
> Oct 21 13:56:06 lena kernel: ------------[ cut here ]------------
> Oct 21 13:56:06 lena kernel: WARNING: CPU: 0 PID: 1550 at net/wireless/ch=
an.c:373 cfg80211_chandef_usable+0x30/0x15f()
> Oct 21 13:56:06 lena kernel: Modules linked in: brcmsmac cordic brcmutil =
bcma
> Oct 21 13:56:06 lena kernel: CPU: 0 PID: 1550 Comm: kworker/u4:5 Tainted:=
 G        W    3.12.0-rc6+ #20
> Oct 21 13:56:06 lena kernel: Hardware name: LENOVO 08946MG/MoutCook, BIOS=
 33CN14WW        05/10/2010
> Oct 21 13:56:06 lena kernel: Workqueue: phy0 ieee80211_iface_work
> Oct 21 13:56:06 lena kernel: 0000000000000000 0000000000000009 ffffffff81=
61e3c7 0000000000000000
> Oct 21 13:56:06 lena kernel: ffffffff81068b00 ffff88006f8be7c0 ffffffff81=
5e79e4 0000000000000000
> Oct 21 13:56:06 lena kernel: 000000000000000f ffff8800703e5dc2 ffff880070=
3e5d50 ffff88006f8bc200
> Oct 21 13:56:06 lena kernel: Call Trace:
> Oct 21 13:56:06 lena kernel: [<ffffffff8161e3c7>] ? dump_stack+0x50/0x80
> Oct 21 13:56:06 lena kernel: [<ffffffff81068b00>] ? warn_slowpath_common+=
0x73/0x8b
> Oct 21 13:56:06 lena kernel: [<ffffffff815e79e4>] ? cfg80211_chandef_usab=
le+0x30/0x15f
> Oct 21 13:56:06 lena kernel: [<ffffffff815e79e4>] ? cfg80211_chandef_usab=
le+0x30/0x15f
> Oct 21 13:56:06 lena kernel: [<ffffffff815f7c2e>] ? __ieee80211_sta_join_=
ibss+0x162/0x6e2
> Oct 21 13:56:06 lena kernel: [<ffffffff8161b8cd>] ? printk+0x4f/0x54
> Oct 21 13:56:06 lena kernel: [<ffffffff815f8439>] ? ieee80211_sta_create_=
ibss+0xc8/0xce
> Oct 21 13:56:06 lena kernel: [<ffffffff815f91ed>] ? ieee80211_ibss_work+0=
x255/0x3c5
> Oct 21 13:56:06 lena kernel: [<ffffffff8107addb>] ? process_one_work+0x1c=
7/0x2e6
> Oct 21 13:56:06 lena kernel: [<ffffffff81078c58>] ? pwq_activate_delayed_=
work+0x1e/0x28
> Oct 21 13:56:06 lena kernel: [<ffffffff8107b346>] ? worker_thread+0x1cb/0=
x2c4
> Oct 21 13:56:06 lena kernel: [<ffffffff8107b17b>] ? rescuer_thread+0x25c/=
0x25c
> Oct 21 13:56:06 lena kernel: [<ffffffff8107ff37>] ? kthread+0xad/0xb5
> Oct 21 13:56:06 lena kernel: [<ffffffff81080000>] ? kthread_create_on_nod=
e+0xc1/0x115
> Oct 21 13:56:06 lena kernel: [<ffffffff8107fe8a>] ? kthread_freezable_sho=
uld_stop+0x3b/0x3b
> Oct 21 13:56:06 lena kernel: [<ffffffff816247bc>] ? ret_from_fork+0x7c/0x=
b0
> Oct 21 13:56:06 lena kernel: [<ffffffff8107fe8a>] ? kthread_freezable_sho=
uld_stop+0x3b/0x3b
> Oct 21 13:56:06 lena kernel: ---[ end trace ade89af8f1b5d90f ]---
> ------------------------------------------------------------------------

--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlJmfDcACgkQrzg/fFk7axbz1wCfaV4X4NCQtVAWaC32CABwK1V3
gT8AmwQmY+mRz8RwDkjrl2hqpv0allHE
=GbY/
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
