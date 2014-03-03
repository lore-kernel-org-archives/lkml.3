Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbaCCDxo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 22:53:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38340 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753452AbaCCDxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 22:53:42 -0500
Date: Mon, 3 Mar 2014 14:53:33 +1100
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux RAID <linux-raid@vger.kernel.org>,
        "majianpeng" <majianpeng@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] md / procfs: avoid Oops if md-mod removed while
 /proc/mdstat is being polled.
Message-ID: <20140303145333.05ce4315@notabene.brown>
In-Reply-To: <20140227153242.42cb9b9ef83dacc895017d44@linux-foundation.org>
References: <20140227172445.13644477@notabene.brown>
	<20140227125807.d034c50c7fe2e1a9f3c38ec1@linux-foundation.org>
	<20140228083443.64c92382@notabene.brown>
	<20140227135125.92a56ff656b3ca8d0b5d9029@linux-foundation.org>
	<20140228100757.7dbd3dae@notabene.brown>
	<20140227153242.42cb9b9ef83dacc895017d44@linux-foundation.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/DF7.Cd93fkarzoWZ3flQizO"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/DF7.Cd93fkarzoWZ3flQizO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 27 Feb 2014 15:32:42 -0800 Andrew Morton <akpm@linux-foundation.org>
wrote:

> On Fri, 28 Feb 2014 10:07:57 +1100 NeilBrown <neilb@suse.de> wrote:
>=20
> > On Thu, 27 Feb 2014 13:51:25 -0800 Andrew Morton <akpm@linux-foundation=
.org>
> > wrote:
> >=20
> > > On Fri, 28 Feb 2014 08:34:43 +1100 NeilBrown <neilb@suse.de> wrote:
> > >=20
> > > > On Thu, 27 Feb 2014 12:58:07 -0800 Andrew Morton <akpm@linux-founda=
tion.org>
> > > > wrote:
> > > >=20
> > > > > On Thu, 27 Feb 2014 17:24:45 +1100 NeilBrown <neilb@suse.de> wrot=
e:
> > > > >=20
> > > > > > If poll or select is waiting on /proc/mdstat when md-mod is unl=
oaded
> > > > > > an oops will ensure when the poll/select completes.
> > > > > >=20
> > > > > > This is because the wait_queue_head which is registered with po=
ll_wait()
> > > > > > is local to the module and no longer exists when the poll compl=
etes and
> > > > > > detaches that wait_queue_head (in poll_free_wait -> remove_wait=
_queue).
> > > > > >=20
> > > > > > To fix this we need the wait_queue_head to have (at least) the =
same life
> > > > > > time as the proc_dir_entry.  So this patch places it in that st=
ructure.
> > > > > >=20
> > > > > > We:
> > > > > >   - add pde_poll_wait to struct proc_dir_entry
> > > > > >   - call poll_wait() passing this when poll() is called on the =
proc file
> > > > > >   - export a function proc_wake_up which will call wake_up() on=
 pde_poll_wait
> > > > > >=20
> > > > > > and make use of all that in md.c
> > > > >=20
> > > > > This sounds wrong.  If a userspace process is waiting on
> > > > > md_event_waiters then the md module is "busy" and the rmmod attem=
pt
> > > > > should fail?
> > > >=20
> > > > Al Viro says "no" quite firmly.
> > > >=20
> > > > I think the core argument is that
> > > >=20
> > > >   rmmod md-mod < /proc/mdstat
> > > >=20
> > > > would deadlock.
> > >=20
> > > Well, only if the rmmod hangs around waiting for the module to go idl=
e.
> > > I'm thinking rmmod should fail.  EBUSY.
>=20
> This?  What happens if we just fail the rmmod when the module is busy
> (which it is).

I was hoping that Al would step in with an answer, but I got impatient had
had a look around myself.

I found

commit 99b76233803beab302123d243eea9e41149804f3
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Wed Mar 25 22:48:06 2009 +0300

    proc 2/2: remove struct proc_dir_entry::owner
   =20


which references

https://bugzilla.kernel.org/show_bug.cgi?id=3D12454

which seems to suggest that we used to try to do as you suggest but it was
racy and would be a lot of work to "fix". The chosen solution was to only
'get' the module during read/write, not just while the /proc file is open.

NeilBrown

--Sig_/DF7.Cd93fkarzoWZ3flQizO
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUxP8vTnsnt1WYoG5AQIhNBAAuXj8ipTGw4UuB0uvnqz93wPfxX5Y2cMt
ll9Iozyod/SjCfBfuupZpYg3gl4LQHuBXeJpqO30DBOsSsYgqsoBzqHgzk1y50/T
+gsMTrb252qDDrvh7FrpMmGXULVKwqynYKTzaCRX5BrFWq8sKx2pboeEelvnPOfA
B0dBOzOQ1lo4DJqAtTvPTborlxOWag/Hz36a02MWNkh6LrY+ZZSlx/h3youODdeh
QuzTNv+MCeMNYs6/oAXLYuRktPJdc4Gx9Ofw8pR2nIh0JUS/X7YF0F4lJMskBRY1
XPbbmryL7Kby8qRQ0+LNuLFlz4m5K/mhfdFJHJfnJA5JZGu6h+veKuN5xyxOUI9y
O+8F8qsXNU5XQPWc7tdWerZ5CdxK8nL92852Sq/8LWNDYI2UEPivrrU5Ew58djRS
ftpCmG+Fcoz8ESQfpaqGHW/wFaHRFbtkQYF/a9NxwlSo0WSd8h9KL9J0xL9BZhps
ODTuP+a5Irs8htMERQudAnWKvyiO3qY04TrI+cgXn92sHA9XM4OpmXhAH2LQ2DZW
FcH+dhyavLzutkdG/im5N7ips4lgPwXV2smREWIyt93DDBTm/Wd5wLNPp528/f71
GnKmYl1P2neBNSYC+tEdByw3bDGfLcIAuiXwRImryctOXRHlDWKJ/JzxlhaCEN5e
tLcFoQGLqFI=
=BdgV
-----END PGP SIGNATURE-----

--Sig_/DF7.Cd93fkarzoWZ3flQizO--
