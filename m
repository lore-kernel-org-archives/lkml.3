Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab3A1Fzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 00:55:47 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:43284 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab3A1Fzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 00:55:42 -0500
MIME-Version: 1.0
Date: Sun, 27 Jan 2013 21:55:40 -0800
Message-ID: <CAEsagEgeaHC_2ULhr_yAtOuNUxk+PZC=aPXU4PQyY9NnUC=TyQ@mail.gmail.com>
Subject: Tux3 Report: Initial fsck has landed
From: Daniel Phillips <daniel.raymond.phillips@gmail.com>
To: linux-kernel@vger.kernel.org, tux3@tux3.org
Cc: linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initial Tux3 fsck has landed

Things are moving right along in Tux3 land. Encouraged by our great initial
benchmarks for in-cache workloads, we are now busy working through our to-do
list to develop Tux3 the rest of the way into a functional filesystem that a
sufficiently brave person could actually mount.

At the top of the to-do list is "fsck". Because really, fsck has to rank as
one of the top features of any filesystem you would actually want to use.
Ext4 rules the world largely on the strength of e2fsck. Not just fsck, but
certainly that is a large part of it. Accordingly, we have set our sights on
creating an e2fsck-quality fsck in due course.

Today, I am happy to be able to say that a first draft of a functional Tux3
fsck has already landed:

    https://github.com/OGAWAHirofumi/tux3/blob/master/user/tux3_fsck.c

Note how short it is. That is because Tux3 fsck uses a "walker" framework
shared by a number of other features. It will soon also use our suite of
metadata format checking methods that were developed years ago (and still
continue to be improved).

The Tux3 walker framework (another great hack by Hirofumi, likewise the
initial fsck) is interesting in that it evolved from tux3graph, Hirofumi's
graphical filesystem structure dumper. And before that, it came from our btree
traversing framework, which came from ddsnap, which came from HTree, which
came from Tux2. Whew. Nearly a 15 year history for that code when you trace
it all out.

Anyway, the walker is really sweet. You give it a few specialized methods and
poof, you have an fsck. So far, we just check physical referential integrity:
each block is either free or is referenced by exactly one pointer in the
filesystem tree, possibly as part of a data extent. This check is done with
the help of a "shadow bitmap". As we walk the tree, we mark off all referenced
blocks in the shadow bitmap, complaining if already marked. At the end of
that, the shadow file should be identical to the allocation bitmap inode. And
more often than not, it is.

Cases where we actually get differences are now mostly during hacking, though
of course we do need to be checking a lot more volumes under different loads
to have a lot of confidence about that. As a development tool, even this very
simple fsck is a wonderful thing.

Tux3 fsck is certainly not going to stay simple. Here is roughly where we are
going with it next:

    http://phunq.net/pipermail/tux3/2013-January/001976.html
    "Fsck Revisited"

To recap, next on the list is checking referential integrity of the directory
namespace, a somewhat more involved problem than physical structure, but not
really hard. After that, the main difference between this and a real fsck
will be repair. Which is a big topic, but it is already underway. First simple
repairs, then tricky repairs.

Compared to Ext2/3/4, Tux3 has a big disadvantage in terms of fsck: it does
not confine inode table blocks to fixed regions of the volume. Tux3 may store
any metadata block anywhere, and tends to stir things around to new locations
during normal operation. To overcome this disadvantage, we have the concept of
uptags:

    http://phunq.net/pipermail/tux3/2013-January/001973.html
    "What are uptags?"

With uptags we should be able to fall back to a full scan of a damaged volume
and get a pretty good idea of which blocks are actually lost metadata blocks,
and to which filesystem objects they might belong.

Free form metadata has another disadvantage: we can't just slurp it up from
disk in huge, efficient reads. Instead we tend to mix inode table blocks,
directory entry blocks, data blocks and index blocks all together in one big
soup so that related blocks live close together. This is supposed to be great
for read performance on spinning media, and should also help control write
multiplication on solid state devices, but it is most probably going to suck
for fsck performance on spinning disk, due to seeking.

So what are we going to do about that? Well, first we want to verify that
there is actually an issue, as proved by slow fsck. We already suspect that
there is, but some of the layout optimization work we have underway might go
some distance to fixing it. After optimizing layout, we will probably still
have some work to do to get at least close to e2fsck performance. Maybe we can
come up with some smart cache preload strategy or something like that.

The real problem is, Moore's Law just does not work for spinning disks. Nobody
really wants their disk spinning faster than 72000 rpm, or they don't want to
pay for it. But density goes up as the square of feature size. So media
transfer rate goes up linearly while disk size goes up quadratically. Today,
it takes a couple of hours to read each terabyte of disk. Fsck is normally
faster than that, because it only reads a portion of the disk, but over time,
it breaks in the same way. The bottom line is, full fsck just isn't a viable
thing to do on your system as a standard, periodic procedure. There is really
not a lot of choice but to move on to incremental and online fsck.

It is quite possible that Tux3 will get to incremental and online fsck before
Ext4 does. (There you go, Ted, that is a challenge.) There is no question that
this is something that every viable, modern filesystem must do, and no,
scrubbing does not cut the mustard. We need to be able to detect errors on the
filesystem, perhaps due to blocks going bad, or heaven forbid, bugs, then
report them to the user and *fix* them on command without taking the volume
offline. If that seems hard, it is. But it simply has to be done.

So that is the Tux3 Report for today. As usual, the welcome mat is out for
developers at oftc.net #tux3. Or hop on over and join our mailing list:

    http://phunq.net/cgi-bin/mailman/listinfo/tux3

We are open to donations of various kinds, particularly of your own awesome
developer power. We have an increasing need for testers. Expect to see a
nice simple recipe for KVM testing soon. Developing kernel code in userspace
is a normal thing in the Tux3 world. It's great. If you haven't tried it yet,
you should.

Thank you for reading, and see you on #tux3.

Regards,

Daniel
