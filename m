Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbaI2Rae (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 13:30:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33519 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926AbaI2Rac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 13:30:32 -0400
Message-ID: <1412011687.15492.39.camel@firewall.xsintricity.com>
Subject: Re: Document POSIX MQ /proc/sys/fs/mqueue files
From: Doug Ledford <dledford@redhat.com>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Madars Vitolins <m@silodev.com>
Date: Mon, 29 Sep 2014 13:28:07 -0400
In-Reply-To: <542921EA.4050709@gmail.com>
References: <542921EA.4050709@gmail.com>
Organization: Red Hat, Inc.
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-7a98rrVHTOl3JqdfeWre"
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-7a98rrVHTOl3JqdfeWre
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-09-29 at 11:10 +0200, Michael Kerrisk (man-pages) wrote:
> Hello Doug, David,
>=20
> I think you two were the last ones to make significant=20
> changes to the semantics of the files in /proc/sys/fs/mqueue,
> so I wonder if you (or anyone else who is willing) might
> take a look at the man page text below that I've written
> (for the mq_overview(7) page) to describe past and current
> reality, and let me know of improvements of corrections.
>=20
> By the way, Doug, your commit ce2d52cc1364 appears to have
> changed/broken the semantics of the files in the /dev/mqueue=20
> filesystem. Formerly, the QSIZE field in these files showed
> the number of bytes of real user data in all of the queued
> messages. After that commit, QSIZE now includes kernel=20
> overhead bytes, which does not seem very useful for user=20
> space. Was that change intentional? I see no mention of the
> change in the commit message, so it sounds like it was not=20
> intended.

That change didn't come in that commit.  That commit modified it, but
didn't introduce it.

Now, was it intentional? Yes.  Is it valuable, useful?  That depends on
your perspective.

One of the problems I ran into with that code relates to the rlimit
checks that happen at queue creation time.  We used to check to see if

 msg_num * (msg_size + sizeof struct msg_msg *)

would fit within the user's currently available rlimit for
RLIMIT_MSGQUEUE.  This was not an accurate check though.  It accounted
for the msg number, and the payload size, and the array of pointers we
used to point to the msg_msg structs that held each message, but ignored
the msg_msg structs themselves.  Given that we accept the creation of
message queues with a msg_size of 1, this could be used to create a
minor DoS because of the fact that there was such a large size
difference between the sizeof struct msg_msg and the size of our
messages.  In this scenario, a msg_size of 1 would result in us
accounting 9/5 bytes per message on 64bit/32bit OSes respecitively, but
actually using 49bytes/19bytes respectively.  That's a 4:1 ratio at the
worst case for the different between actual memory used and memory usage
accounted against the RLIMIT_MSGQUEUE limit. So before I ever got around
to doing the rbtree update, I fixed this to at least be more accurate
and it became

 msg_num * (msg_size + sizeof struct msg_msg * + sizeof struct msg_msg)

Even this wasn't totally accurate though, as large messages could result
in the allocation of additional msg_msgseg segments.  However, I ignored
that inaccuracy because once the message size is large enough to need
additional SG segments, we are no longer in danger of any sort of minor
DoS because our own overhead will become nothing more than noise to the
calculation.

When I then changed things to use rbtrees, I again updated the way we
calculate memory consumed by a queue.  The rbtrees are used one per
priority with a list head attached to our rbtree node so that once we
locate our given priority, we have O(1) insertion and removal of
messages.  It just so happens that, sometime long ago, someone set our
maximum number of priorities we support in Linux at 32768.  This kills
us on our memory calculations because the size of the msg_tree_node
struct is another 40 bytes on 64bit.  That means if someone creates a
message queue with 32768 max_msgs, and a msg_size of 1, they can cause
us to allocate 32768 struct msg_msg, 32768 struct posix_msg_tree_node,
and 32768 * 1 payload.  In order to protect against that sort of
exploitation, the new memory usage calculation had to become:

 msg_num * (msg_size + sizeof struct msg_msg) +
   sizeof struct posix_msg_tree_node * min(msg_num, max_priorities)

So, that's how we now calculate the size of a queue when checking it
against RLIMIT_MSGQUEUE to see if the user has the ability to create a
new queue.  This is now reasonably accurate, and it closes up what would
have been a minimum of an order of magnitude error between the worst
case scenario's actual memory usage and accounted memory usage.

With this change in place, people that used to be able to allocate lots
of large queues of very small messages suddenly needed to adjust their
RLIMIT_MSGQUEUE to be able to continue.  I contend this is the right
thing, but it is a surprise to some people.  At the time, I had thought
that the sizeof struct msg_msg was already accounted for in the QSIZE
output.  So I had added the rbtree size in too so that users could see
their currently used memory more accurately.  Going back and looking
now, that was a mistake on my part as the size of struct msg_msg is not
included in that number, so it wasn't correct to add the rbtree size
their either (or at a minimum if I was going to add one, I should have
added both, but this in-between land makes no sense).  However, I think
it's probably worth adding a new field to the end of that data output
that does reflect both struct msg_msg and struct posix_msg_tree_node
allocations so that users can see the overhead of their current queue
usage, especially in light of the changes to how the rlimit is enforced.
And I would say that putting the data element back to an exact match to
the number of user data bytes currently in queue makes sense.

I've been trying to think of a way to tackle the priorities problem
anyway.  That we have a default, and unchangeable, setting of 32768
priorities precludes having lots of small messages in queue without
having to plan for huge amounts of overhead.  I think it's worth
investigating some method of allowing the supported number of priorities
for queues (either system wide or per namespace or per queue) to be
reduced in the name of efficiency.  I can bump that work up my priority
list and take care of fixing up the DATA field at the same time.

The man page below looks fine to me.  It covers the various
incarnations.  If I add some tweaks to the priorities value though, it
will need updating again ;-)

Although this section wasn't included below, I would update how the
memory is calculated to match what I wrote above.  However, I would also
put in a notation that the calculation can change when the kernel's
internal implementation changes and resource usage therefore changes.

> Cheers,
>=20
> Michael
>=20
> From mq_overview(7) draft:
>=20
>    /proc interfaces
>        The following interfaces can be used to limit the amount of  ker=
=1B$B!>=1B(B
>        nel  memory  consumed  by  POSIX  message  queues  and to set the
>        default attributes for new message queues:
>=20
>        /proc/sys/fs/mqueue/msg_default (since Linux 3.5)
>               This file  defines  the  value  used  for  a  new  queue's
>               mq_maxmsg setting when the queue is created with a call to
>               mq_open(3) where attr is specified as NULL.   The  default
>               value for this file is 10.  The minimum and maximum are as
>               for /proc/sys/fs/mqueue/msg_max.  If  msg_default  exceeds
>               msg_max,  a  new queue's default mq_maxmsg value is capped
>               to the msg_max limit.  Up until Linux 2.6.28, the  default
>               mq_maxmsg  was  10;  from  Linux  2.6.28 to Linux 3.4, the
>               default was the value defined for the msg_max limit.
>=20
>        /proc/sys/fs/mqueue/msg_max
>               This file can be used to view and change the ceiling value
>               for the maximum number of messages in a queue.  This value
>               acts as a ceiling on the attr->mq_maxmsg argument given to
>               mq_open(3).   The  default  value  for msg_max is 10.  The
>               minimum value is 1 (10 in  kernels  before  2.6.28).   The
>               upper  limit is HARD_MSGMAX.  The msg_max limit is ignored
>               for  privileged  processes  (CAP_SYS_RESOURCE),  but   the
>               HARD_MSGMAX ceiling is nevertheless imposed.
>=20
>               The  definition  of  HARD_MSGMAX has changed across kernel
>               versions:
>=20
>               *  Up to Linux 2.6.32: 131072 / sizeof(void *)
>=20
>               *  Linux 2.6.33 to 3.4: (32768 * sizeof(void *) / 4)
>=20
>               *  Since Linux 3.5: 65,536
>=20
>        /proc/sys/fs/mqueue/msgsize_default (since Linux 3.5)
>               This file defines the value used for a new queue's mq_msg=
=1B$B!>=1B(B
>               size  setting  when  the  queue  is created with a call to
>               mq_open(3) where attr is specified as NULL.   The  default
>               value  for this file is 8192.  The minimum and maximum are
>               as   for   /proc/sys/fs/mqueue/msgsize_max.     If    msg=
=1B$B!>=1B(B
>               size_default  exceeds  msgsize_max,  a new queue's default
>               mq_msgsize value is capped to the msgsize_max  limit.   Up
>               until  Linux 2.6.28, the default mq_msgsize was 8192; from
>               Linux 2.6.28 to Linux  3.4,  the  default  was  the  value
>               defined for the msgsize_max limit.
>=20
>        /proc/sys/fs/mqueue/msgsize_max
>               This  file  can  be used to view and change the ceiling on
>               the maximum message size.  This value acts as a ceiling on
>               the  attr->mq_msgsize  argument  given to mq_open(3).  The
>               default value for msgsize_max is 8192 bytes.  The  minimum
>               value  is  128 (8192 in kernels before 2.6.28).  The upper
>               limit for msgsize_max has varied across kernel versions:
>=20
>               *  Before Linux 2.6.28, the upper limit is INT_MAX.
>=20
>               *  From Linux 2.6.28 to 3.4, the limit is 1,048,576.
>=20
>               *  Since Linux 3.5, the limit is 16,777,216 (HARD_MSGSIZE=
=1B$B!>=1B(B
>                  MAX).
>=20
>               The  msgsize_max  limit  is ignored for privileged process
>               (CAP_SYS_RESOURCE), but, since Linux  3.5,  the  HARD_MSG=
=1B$B!>=1B(B
>               SIZEMAX ceiling is enforced for privileged processes.
>=20
>        /proc/sys/fs/mqueue/queues_max
>               This  file  can be used to view and change the system-wide
>               limit on the number of message queues that can be created.
>               The default value for queues_max is 256.  The semantics of
>               this limit have changed across kernel versions as follows:
>=20
>               *  Before Linux 3.5, this limit could be  changed  to  any
>                  value  in  the  range 0 to INT_MAX, but privileged pro=
=1B$B!>=1B(B
>                  cesses (CAP_SYS_RESOURCE) can exceed the limit.
>=20
>               *  Since Linux 3.5, there is a ceiling for this  limit  of
>                  1024     (HARD_QUEUESMAX).      Privileged    processes
>                  (CAP_SYS_RESOURCE) can exceed the queues_max limit, but
>                  the  HARD_QUEUESMAX  limit  is enforced even for privi=
=1B$B!>=1B(B
>                  leged processes.
>=20
>               *  Starting with Linux 3.14, the HARD_QUEUESMAX ceiling is
>                  removed: no ceiling is imposed on the queues_max limit,
>                  and privileged processes (CAP_SYS_RESOURCE) can  exceed
>                  the limit.
>=20


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--=-7a98rrVHTOl3JqdfeWre
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJUKZa0AAoJELgmozMOVy/d9gQP/1NsA3Sp4g7tZ1cia/YCry0Z
ptD+FlOdw0Ks8xjwMkQHlCIz/nQk2zRCYATrwDxmU9l0z1yHj7WTvWfqWYiN87Nu
spVXvMwPCu4vWbElhu16zK2y7NL9ZNO6FWCycmA42s5wUSKNLglLTNu0TNzEm5t7
bGTjZhy2g6L8hm+Hstv4uyk/5QcF8iOsHSxgYT4zFyqk66GWpb9IN16i3usi5Tzc
WDb300PuOZqRcykw4ogh1xZKxdMSYLag+sjlNBu4y2r4wuIOqq2BMP4KDuPnZWcy
pIap/0bxgOjN0I+m2P+v89J5f/s02D1yJbGRPbuDkhYS7z7s3sreXiQc/HScaQNf
TnMSfeFrScRjrQsZAfTZnkGyXFK1LhIFg+TF8FfsNx8Cz5UjZR76poZdyxk9IeDB
kC5cRvt3vFodHteh6JlIWQyFYmAKlOjvRqD/VCeOjmgn89tt8RAzOPQi+4iM+E5m
JeAA1NlU1zzucT42Tp+Dfoka+Og4yTYmstqHV0b8Xv0yHlu6tdkuyQfj2FqTefrQ
CKW5Ll7dc6HJmJnjDVjOsCdbHHXJMuwe953/MTfFPqdW/GwBGGgfGpzG63g1oL3n
gnmudacrQbeZ3ZWECq5HnTTH6bGL8LTeFaPnyl5KW1jVGxaJ39hVmWvHJO9xAClK
8nGaIJrUXGmX4U5R/tkB
=F4bI
-----END PGP SIGNATURE-----

--=-7a98rrVHTOl3JqdfeWre--

