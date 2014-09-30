Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbaI3UAb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 16:00:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996AbaI3UA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 16:00:29 -0400
Message-ID: <1412107074.4930.9.camel@firewall.xsintricity.com>
Subject: Re: Document POSIX MQ /proc/sys/fs/mqueue files
From: Doug Ledford <dledford@redhat.com>
To: mtk.manpages@gmail.com
Cc: Davidlohr Bueso <dave@stgolabs.net>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Madars Vitolins <m@silodev.com>
Date: Tue, 30 Sep 2014 15:57:54 -0400
In-Reply-To: <CAKgNAkj9+Z1yO-zrQ_qWFut7BqOkzNtNCruSSRyTKMpXZOcBaw@mail.gmail.com>
References: <542921EA.4050709@gmail.com>
	 <1412011687.15492.39.camel@firewall.xsintricity.com>
	 <CAKgNAkj9+Z1yO-zrQ_qWFut7BqOkzNtNCruSSRyTKMpXZOcBaw@mail.gmail.com>
Organization: Red Hat, Inc.
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-UlZFfiXyFbPSQ70XdBla"
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-UlZFfiXyFbPSQ70XdBla
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable

On Tue, 2014-09-30 at 12:12 +0200, Michael Kerrisk (man-pages) wrote:
> Hi Doug,
>=20
> On Mon, Sep 29, 2014 at 7:28 PM, Doug Ledford <dledford@redhat.com> wrote=
:
> > On Mon, 2014-09-29 at 11:10 +0200, Michael Kerrisk (man-pages) wrote:
> >> Hello Doug, David,
> >>
> >> I think you two were the last ones to make significant
> >> changes to the semantics of the files in /proc/sys/fs/mqueue,
> >> so I wonder if you (or anyone else who is willing) might
> >> take a look at the man page text below that I've written
> >> (for the mq_overview(7) page) to describe past and current
> >> reality, and let me know of improvements of corrections.
> >>
> >> By the way, Doug, your commit ce2d52cc1364 appears to have
> >> changed/broken the semantics of the files in the /dev/mqueue
> >> filesystem. Formerly, the QSIZE field in these files showed
> >> the number of bytes of real user data in all of the queued
> >> messages. After that commit, QSIZE now includes kernel
> >> overhead bytes, which does not seem very useful for user
> >> space. Was that change intentional? I see no mention of the
> >> change in the commit message, so it sounds like it was not
> >> intended.
> >
> > That change didn't come in that commit.  That commit modified it, but
> > didn't introduce it.
>=20
> (Which commit was it then? d6629859b36 ?)

Yes, that's the one.

> > Now, was it intentional? Yes.  Is it valuable, useful?  That depends on
> > your perspective.
>=20
> Thanks for the detailed explanation below. However, I don't understand
> why the (useful) work that you describe below necessitated a change in
> the QSIZE value that was exposed to user space.

Given how long ago this was, I can't say for sure, old age and memory
being what it is ;-)  Most likely, when I rewrote the msg_insert
routine, I saw we were updating info->qsize and said to myself "Crap,
I've added a new structure, we have to account for it too" and made the
change.

>  Surely the necessary
> changes could have been done internally while still leaving QSIZE to
> expose the same value it ever did?

Yes, it could have.

>  As things stand now (and unless I
> am missing something), QSIZE exposes an implementation-specific
> internal value that has little meaning or value to user space.

This part is not necessarily true.  I'm pretty sure at the time I
thought the struct msg_msg was also included in qsize (even though it
isn't).  And although we've not had any reports of bugs on this, I have
a Red Hat bug against the accounting change (namely that it caught one
user off guard that they needed to increase their RLIMIT_MSGQUEUE to
create the same number/size of queues they used to be able to create)
and so it does have some value in that it's the only way a user has of
knowing just how much the overhead of their queue is biting them in the
ass in terms of that RLIMIT_MSGQUEUE test.  But, since it doesn't
include the size of each struct msg_msg, it's incomplete even for that
purpose.  Like I said in my previous email, I'm not so sure it wouldn't
be wise to include some extra data in this file (but that again would be
an ABI break).  Maybe a second line that includes something like this:

CUR_OVERHEAD: # RLIM_OVERHEAD: # RLIM_PAYLOAD: #

where CUR_OVERHEAD is how much we currently have allocated in internal
kernel structures for the current DATA on the line above, and the other
two are the amount of size we charged against the RLIMIT_MSGQUEUE
available to the user based upon their queue parameters and the
potential worst case scenario of queue usage.

>  And,
> it's unfortunate that the commit message made no mention of the fact
> that there was an ABI change here.

I don't think I realized it was an ABI change at the time.

> [...]
>=20
> > The man page below looks fine to me.
>=20
> Thanks for checking it!
>=20
> Cheers,
>=20
> Michael
>=20
>=20
> > It covers the various
> > incarnations.  If I add some tweaks to the priorities value though, it
> > will need updating again ;-)
> >
> > Although this section wasn't included below, I would update how the
> > memory is calculated to match what I wrote above.  However, I would als=
o
> > put in a notation that the calculation can change when the kernel's
> > internal implementation changes and resource usage therefore changes.
> >
> >> Cheers,
> >>
> >> Michael
> >>
> >> From mq_overview(7) draft:
> >>
> >>    /proc interfaces
> >>        The following interfaces can be used to limit the amount of  ke=
r=1B$B!>=1B(B
> >>        nel  memory  consumed  by  POSIX  message  queues  and to set t=
he
> >>        default attributes for new message queues:
> >>
> >>        /proc/sys/fs/mqueue/msg_default (since Linux 3.5)
> >>               This file  defines  the  value  used  for  a  new  queue=
's
> >>               mq_maxmsg setting when the queue is created with a call =
to
> >>               mq_open(3) where attr is specified as NULL.   The  defau=
lt
> >>               value for this file is 10.  The minimum and maximum are =
as
> >>               for /proc/sys/fs/mqueue/msg_max.  If  msg_default  excee=
ds
> >>               msg_max,  a  new queue's default mq_maxmsg value is capp=
ed
> >>               to the msg_max limit.  Up until Linux 2.6.28, the  defau=
lt
> >>               mq_maxmsg  was  10;  from  Linux  2.6.28 to Linux 3.4, t=
he
> >>               default was the value defined for the msg_max limit.
> >>
> >>        /proc/sys/fs/mqueue/msg_max
> >>               This file can be used to view and change the ceiling val=
ue
> >>               for the maximum number of messages in a queue.  This val=
ue
> >>               acts as a ceiling on the attr->mq_maxmsg argument given =
to
> >>               mq_open(3).   The  default  value  for msg_max is 10.  T=
he
> >>               minimum value is 1 (10 in  kernels  before  2.6.28).   T=
he
> >>               upper  limit is HARD_MSGMAX.  The msg_max limit is ignor=
ed
> >>               for  privileged  processes  (CAP_SYS_RESOURCE),  but   t=
he
> >>               HARD_MSGMAX ceiling is nevertheless imposed.
> >>
> >>               The  definition  of  HARD_MSGMAX has changed across kern=
el
> >>               versions:
> >>
> >>               *  Up to Linux 2.6.32: 131072 / sizeof(void *)
> >>
> >>               *  Linux 2.6.33 to 3.4: (32768 * sizeof(void *) / 4)
> >>
> >>               *  Since Linux 3.5: 65,536
> >>
> >>        /proc/sys/fs/mqueue/msgsize_default (since Linux 3.5)
> >>               This file defines the value used for a new queue's mq_ms=
g=1B$B!>=1B(B
> >>               size  setting  when  the  queue  is created with a call =
to
> >>               mq_open(3) where attr is specified as NULL.   The  defau=
lt
> >>               value  for this file is 8192.  The minimum and maximum a=
re
> >>               as   for   /proc/sys/fs/mqueue/msgsize_max.     If    ms=
g=1B$B!>=1B(B
> >>               size_default  exceeds  msgsize_max,  a new queue's defau=
lt
> >>               mq_msgsize value is capped to the msgsize_max  limit.   =
Up
> >>               until  Linux 2.6.28, the default mq_msgsize was 8192; fr=
om
> >>               Linux 2.6.28 to Linux  3.4,  the  default  was  the  val=
ue
> >>               defined for the msgsize_max limit.
> >>
> >>        /proc/sys/fs/mqueue/msgsize_max
> >>               This  file  can  be used to view and change the ceiling =
on
> >>               the maximum message size.  This value acts as a ceiling =
on
> >>               the  attr->mq_msgsize  argument  given to mq_open(3).  T=
he
> >>               default value for msgsize_max is 8192 bytes.  The  minim=
um
> >>               value  is  128 (8192 in kernels before 2.6.28).  The upp=
er
> >>               limit for msgsize_max has varied across kernel versions:
> >>
> >>               *  Before Linux 2.6.28, the upper limit is INT_MAX.
> >>
> >>               *  From Linux 2.6.28 to 3.4, the limit is 1,048,576.
> >>
> >>               *  Since Linux 3.5, the limit is 16,777,216 (HARD_MSGSIZ=
E=1B$B!>=1B(B
> >>                  MAX).
> >>
> >>               The  msgsize_max  limit  is ignored for privileged proce=
ss
> >>               (CAP_SYS_RESOURCE), but, since Linux  3.5,  the  HARD_MS=
G=1B$B!>=1B(B
> >>               SIZEMAX ceiling is enforced for privileged processes.
> >>
> >>        /proc/sys/fs/mqueue/queues_max
> >>               This  file  can be used to view and change the system-wi=
de
> >>               limit on the number of message queues that can be create=
d.
> >>               The default value for queues_max is 256.  The semantics =
of
> >>               this limit have changed across kernel versions as follow=
s:
> >>
> >>               *  Before Linux 3.5, this limit could be  changed  to  a=
ny
> >>                  value  in  the  range 0 to INT_MAX, but privileged pr=
o=1B$B!>=1B(B
> >>                  cesses (CAP_SYS_RESOURCE) can exceed the limit.
> >>
> >>               *  Since Linux 3.5, there is a ceiling for this  limit  =
of
> >>                  1024     (HARD_QUEUESMAX).      Privileged    process=
es
> >>                  (CAP_SYS_RESOURCE) can exceed the queues_max limit, b=
ut
> >>                  the  HARD_QUEUESMAX  limit  is enforced even for priv=
i=1B$B!>=1B(B
> >>                  leged processes.
> >>
> >>               *  Starting with Linux 3.14, the HARD_QUEUESMAX ceiling =
is
> >>                  removed: no ceiling is imposed on the queues_max limi=
t,
> >>                  and privileged processes (CAP_SYS_RESOURCE) can  exce=
ed
> >>                  the limit.
> >>
> >
> >
> > --
> > Doug Ledford <dledford@redhat.com>
> >               GPG KeyID: 0E572FDD
> >
> >
>=20
>=20
>=20


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--=-UlZFfiXyFbPSQ70XdBla
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJUKwtMAAoJELgmozMOVy/d6/8P/jacLi5HD01P0beoUCSA6Nhx
5rC+/5LPk9LCpNoPPM9BojW2StDDqrFuNH/zhNYia0/zSoY5QIroHg0069JS3Ris
NN+Sd6leg7A+brD32/9lisjgKEoOiVkFbFD92oSj/6Fbz5SXp+N9SVUIGbAKZxLg
qW43dSblwQeBFzqeI5Bf+8pYtIexKKUMooHHBHKBudSTvLy/KXf0KHbV/bGO4wA5
sBrnYS5cFmKfX++kIOEX3InrAxcNPVYz+qNg/P/DEE5C6h4t4wzZIlw/M+CeAQay
bB/VlBojApulvecMz1OTV+bz2uDzivXfTKCepwQQjqoXWz+FRJBSUz6MuP/xvHeZ
LgJihLFpMcYYFehfOmU6EWkg9Rl9DVdlyjDRujN9lm/cHwp/EcSLFYeqEi2iVAvz
qMQ1NRamab9dHmsOz1pGgJmG45X9/8cNrkWWGdRXmou4gaRA28u6meZX+CAo8iN5
9rSkwFIYHMs5JsEUivVNiY86Iy15ZIyJQ6oapKTqL+Duk/e2/e0BTHlOMeLjWg/b
MThz3knkmM79z/jhHKtVc8hokqva0DWtWhBBxBppK5pJulBXskkVhjcdR1QuWUpS
1DFdIqO6i6gXWSJ+2mub6bPjhrD6YFwU32bIPUXP9yJXhQZFKFPw5yoCfStRw4yE
bdQZp1KBGbHBeEkkIQIH
=/gEI
-----END PGP SIGNATURE-----

--=-UlZFfiXyFbPSQ70XdBla--

