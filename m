Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331AbaD3ABK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 20:01:10 -0400
Received: from old-vorash.stgraber.org ([176.9.111.221]:41259 "EHLO
	smtpout1.stgraber.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395AbaD3ABG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 20:01:06 -0400
Date: Tue, 29 Apr 2014 20:01:01 -0400
From: =?iso-8859-1?Q?St=E9phane?= Graber <stgraber@ubuntu.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Marian Marinov <mm@1h.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>, "Ted Ts'o" <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lxc-devel <lxc-devel@lists.sourceforge.net>
Subject: Re: ioctl CAP_LINUX_IMMUTABLE is checked in the wrong namespace
Message-ID: <20140430000101.GC2997@dakara>
References: <20140429185251.GA27969@ubuntumail>
 <53601E5B.5050004@1h.com>
 <20140429220234.GC28410@ubuntumail>
 <536026B3.1020905@1h.com>
 <20140429222913.GD28410@ubuntumail>
 <53602B84.1020304@mit.edu>
 <536033A9.5070504@1h.com>
 <CALCETrVJY6SWjdbqSSCeOo9oid22TnL83v9oDVg06XLZfPkLCw@mail.gmail.com>
 <20140429234739.GB2997@dakara>
 <CALCETrXK6N8CLjPtnHVXB-BM_bxNU6e1xYGd=_UKcjKMrR3j0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="kfjH4zxOES6UT95V"
Content-Disposition: inline
In-Reply-To: <CALCETrXK6N8CLjPtnHVXB-BM_bxNU6e1xYGd=_UKcjKMrR3j0g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kfjH4zxOES6UT95V
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 29, 2014 at 04:51:54PM -0700, Andy Lutomirski wrote:
> On Tue, Apr 29, 2014 at 4:47 PM, St=E9phane Graber <stgraber@ubuntu.com> =
wrote:
> > On Tue, Apr 29, 2014 at 04:22:55PM -0700, Andy Lutomirski wrote:
> >> On Tue, Apr 29, 2014 at 4:20 PM, Marian Marinov <mm@1h.com> wrote:
> >> > On 04/30/2014 01:45 AM, Andy Lutomirski wrote:
> >> >>
> >> >> On 04/29/2014 03:29 PM, Serge Hallyn wrote:
> >> >>>
> >> >>> Quoting Marian Marinov (mm-108MBtLGafw@public.gmane.org):
> >> >>>>
> >> >>>> On 04/30/2014 01:02 AM, Serge Hallyn wrote:
> >> >>>>>
> >> >>>>> Quoting Marian Marinov (mm-108MBtLGafw@public.gmane.org):
> >> >>>>>>
> >> >>>>>> On 04/29/2014 09:52 PM, Serge Hallyn wrote:
> >> >>>>>>>
> >> >>>>>>> Quoting Theodore Ts'o (tytso-3s7WtUTddSA@public.gmane.org):
> >> >>>>>>>>
> >> >>>>>>>> On Tue, Apr 29, 2014 at 04:49:14PM +0300, Marian Marinov wrot=
e:
> >> >>>>>>>>>
> >> >>>>>>>>>
> >> >>>>>>>>> I'm proposing a fix to this, by replacing the
> >> >>>>>>>>> capable(CAP_LINUX_IMMUTABLE)
> >> >>>>>>>>> check with ns_capable(current_cred()->user_ns,
> >> >>>>>>>>> CAP_LINUX_IMMUTABLE).
> >> >>>>>>>>
> >> >>>>>>>>
> >> >>>>>>>> Um, wouldn't it be better to simply fix the capable() functio=
n?
> >> >>>>>>>>
> >> >>>>>>>> /**
> >> >>>>>>>>   * capable - Determine if the current task has a superior
> >> >>>>>>>> capability in effect
> >> >>>>>>>>   * @cap: The capability to be tested for
> >> >>>>>>>>   *
> >> >>>>>>>>   * Return true if the current task has the given superior
> >> >>>>>>>> capability currently
> >> >>>>>>>>   * available for use, false if not.
> >> >>>>>>>>   *
> >> >>>>>>>>   * This sets PF_SUPERPRIV on the task if the capability is
> >> >>>>>>>> available on the
> >> >>>>>>>>   * assumption that it's about to be used.
> >> >>>>>>>>   */
> >> >>>>>>>> bool capable(int cap)
> >> >>>>>>>> {
> >> >>>>>>>>         return ns_capable(&init_user_ns, cap);
> >> >>>>>>>> }
> >> >>>>>>>> EXPORT_SYMBOL(capable);
> >> >>>>>>>>
> >> >>>>>>>> The documentation states that it is for "the current task", a=
nd I
> >> >>>>>>>> can't imagine any use case, where user namespaces are in effe=
ct,
> >> >>>>>>>> where
> >> >>>>>>>> using init_user_ns would ever make sense.
> >> >>>>>>>
> >> >>>>>>>
> >> >>>>>>> the init_user_ns represents the user_ns owning the object, not=
 the
> >> >>>>>>> subject.
> >> >>>>>>>
> >> >>>>>>> The patch by Marian is wrong.  Anyone can do 'clone(CLONE_NEWU=
SER)',
> >> >>>>>>> setuid(0), execve, and end up satisfying
> >> >>>>>>> 'ns_capable(current_cred()->userns,
> >> >>>>>>> CAP_SYS_IMMUTABLE)' by definition.
> >> >>>>>>>
> >> >>>>>>> So NACK to that particular patch.  I'm not sure, but IIUC it s=
hould
> >> >>>>>>> be
> >> >>>>>>> safe to check against the userns owning the inode?
> >> >>>>>>>
> >> >>>>>>
> >> >>>>>> So what you are proposing is to replace
> >> >>>>>> 'ns_capable(current_cred()->userns, CAP_SYS_IMMUTABLE)' with
> >> >>>>>> 'inode_capable(inode, CAP_SYS_IMMUTABLE)' ?
> >> >>>>>>
> >> >>>>>> I agree that this is more sane.
> >> >>>>>
> >> >>>>>
> >> >>>>> Right, and I think the two operations you're looking at seem sane
> >> >>>>> to allow.
> >> >>>>
> >> >>>>
> >> >>>> If you are ok with this patch, I will fix all file systems and se=
nd
> >> >>>> patches.
> >> >>>
> >> >>>
> >> >>> Sounds good, thanks.
> >> >>>
> >> >>>> Signed-off-by: Marian Marinov <mm-NV7Lj0SOnH0@public.gmane.org>
> >> >>>
> >> >>>
> >> >>> Acked-by: Serge E. Hallyn
> >> >>> <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
> >> >>
> >> >>
> >> >> Wait, what?
> >> >>
> >> >> Inodes aren't owned by user namespaces; they're owned by users.  An=
d any
> >> >> user can arrange to have a user namespace in which they pass an
> >> >> inode_capable check on any inode that they own.
> >> >>
> >> >> Presumably there's a reason that CAP_SYS_IMMUTABLE is needed.  If t=
his
> >> >> gets merged, then it would be better to just drop CAP_SYS_IMMUTABLE
> >> >> entirely.
> >> >
> >> >
> >> > The problem I'm trying to solve is this:
> >> >
> >> > container with its own user namespace and CAP_SYS_IMMUTABLE should b=
e able
> >> > to use chattr on all files witch this container has access to.
> >> >
> >> > Unfortunately with the capable(CAP_SYS_IMMUTABLE) check this is not =
working.
> >> >
> >> > With the proposed two fixes CAP_SYS_IMMUTABLE started working in the
> >> > container.
> >> >
> >> > The first solution got its user namespace from the currently running=
 process
> >> > and the second gets its user namespace from the currently opened ino=
de.
> >> >
> >> > So what would be the best solution in this case?
> >>
> >> I'd suggest adding a mount option like fs_owner_uid that names a uid
> >> that owns, in the sense of having unlimited access to, a filesystem.
> >> Then anyone with caps on a namespace owned by that uid could do
> >> whatever.
> >>
> >> Eric?
> >>
> >> --Andy
> >
> > The most obvious problem I can think of with "do whatever" is that this
> > will likely include mknod of char and block devices which you can then
> > chown/chmod as you wish and use to access any devices on the system from
> > an unprivileged container.
> > This can however be mitigated by using the devices cgroup controller.
>=20
> Or 'nodev'.  setuid/setgid may have the same problem, too.
>=20
> Implementing something like this would also make CAP_DAC_READ_SEARCH
> and CAP_DAC_OVERRIDE work.
>=20
> Arguably it should be impossible to mount such a thing in the first
> place without global privilege.
>=20
> >
> > You also probably wouldn't want any unprivileged user from the host to
> > find a way to access that mounted filesytem but so long as you do the
> > mount in a separate mountns and don't share uids between the host and
> > the container, that should be fine too.
>=20
> This part should be a nonissue -- an unprivileged user who has the
> right uid owns the namespace anyway, so this is the least of your
> worries.
>=20
> --Andy

It should be a nonissue so long as we make sure that a file owned by a
uid outside the scope of the container may not be changed even though
fs_owner_uid is set. Otherwise, it's just a matter of chmod +S on say
a shell and anyone who can see the fs from the host will be getting a
root shell (assuming said file is owned by the host's uid 0).

So that's restricting slightly what "do whatever" would do in this case.

--=20
St=E9phane Graber
Ubuntu developer
http://www.ubuntu.com

--kfjH4zxOES6UT95V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTYD09AAoJEMY4l01keS1n5CgP/0SOTZSKt2vLaNv5rV57PBta
ubyaG99MdUdSZLZPTLCJKijvfJCZbHtSOxWFH+IlOhhzEX01a9ZDlIAL3zUfuQgn
QQJuckRaIKKg3ZNMpBBng/4iO+1+e9mySegdvBK8xDoc0Q0xt01KJL+anGPxI52d
NVumABpQ1UFCzTIXMEZrTLAOzPO+3I2leEwc3u05cmQkBojBAA04c5OoduKPf2cO
IomyvY1n5M6OKiA+nNcbggVQ39UI5rYe48EreAzaJmHvAKOOw/cvdapqBX/ko+af
xYMwVbTcS0cB/O3AI6u9+BOAU64lOkeBN9g2Utd6gg8mBeM/8fhAXrUgTiON+Uvw
jHFtBJmFgYJ3A6d6pl8LhrEpoDVy/CJ+R80L7Tg1FVWiG40TmrdkQsH38I41A0FX
1/g9SK0di0df87je35AcblIsKTIul4nbYIhPrr0q8wnUEaIsyrN4IMmcTtZXvHWG
sizAoIPMLb1m3rCwy2wqI83GcUGb5k1MMRaj+XqeiJUlzR4GdwfxstCepngedHsH
bEnRLcu4PvV0jJuQs/sLYpOcOT8fmyeZ111T0U58uIk6ddBYeHqtQkZXzady4PJ9
qBus9lVgdG/avuc5FuBj8FVR2S/f9VQISDG3LmjVuDNTvdNv1ZfPrigA6ImTE2uK
nETUDmN5NpWc6F8qDJK7
=5k0l
-----END PGP SIGNATURE-----

--kfjH4zxOES6UT95V--
