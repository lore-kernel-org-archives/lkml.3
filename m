Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947278Ab3BHW5d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 17:57:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947164Ab3BHW5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 17:57:31 -0500
Date: Fri, 8 Feb 2013 16:56:37 -0600
From: Clark Williams <williams@redhat.com>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Josh Boyer <jwboyer@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: Odd ENOMEM being returned in 3.8-rcX
Message-ID: <20130208165637.795a0859@riff.lan>
In-Reply-To: <874nhmpgz6.fsf@xmission.com>
References: <20130207215742.GB31684@hansolo.jdub.homelinux.org>
	<20130207141502.04625ea0.akpm@linux-foundation.org>
	<20130208003501.GC31684@hansolo.jdub.homelinux.org>
	<20130208181949.GD31684@hansolo.jdub.homelinux.org>
	<87k3qiwomi.fsf@xmission.com>
	<20130208202314.GF31684@hansolo.jdub.homelinux.org>
	<87r4kqttz8.fsf@xmission.com>
	<20130208212726.GH31684@hansolo.jdub.homelinux.org>
	<20130208161031.28212e80@riff.lan>
	<874nhmpgz6.fsf@xmission.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/dczg1QdxHHlz0NpBCuCm+ik"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/dczg1QdxHHlz0NpBCuCm+ik
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 08 Feb 2013 14:40:13 -0800
ebiederm@xmission.com (Eric W. Biederman) wrote:

> Clark Williams <williams@redhat.com> writes:
>=20
> > The more I look at that the more I think I should nuke CLONE_NEWPID in
> > mock. It came in with a commit that added NEWIPC, which I think is valid
> > for mock managing a chroot, but we're not looking to do full-up
> > containers at this point and it looks like containers is the only place
> > you'd want to start a new set of pids.=20
>=20
> Just taking the code out seems reasonable.  Howerver there is a
> practical use for a pid namespace in a setup like mock.  A pid namespace
> makes it so your sub processes can not reparent and get away from you,
> which could be handy in case someone starts a system daemon in a post
> install script.
>=20

Ok, I *think* I'm up to speed now (I'm old and slow so gimme a break).=20

Unsharing pidns only works after your commit in 3.8; that's why my
unshare was always failing. Does it make sense for me to make an
additional unshare() call with just NEWPID as an argument? That is,
call unshare with the NEWNS, NEWIPC, and NEWUTS flags, then when that
succeeds, try NEWPID. If the NEWPID call succeeds, do:

    pid =3D os.fork()
    if pid:
        os.waitpid(pid, 0)

So that the child continues on?

Clark

--Sig_/dczg1QdxHHlz0NpBCuCm+ik
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlEVgq4ACgkQHyuj/+TTEp38rwCfRHFSpWYAjoad+VzE7dnEHEUk
DJgAn10qNabkxbkS77p37okiHcBMU2Tt
=2oSB
-----END PGP SIGNATURE-----

--Sig_/dczg1QdxHHlz0NpBCuCm+ik--
