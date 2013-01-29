Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab3A2Eea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 23:34:30 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:61887 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323Ab3A2Ee0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 23:34:26 -0500
MIME-Version: 1.0
In-Reply-To: <20130129014000.GA7003@thunk.org>
References: <CAEsagEgeaHC_2ULhr_yAtOuNUxk+PZC=aPXU4PQyY9NnUC=TyQ@mail.gmail.com>
	<alpine.DEB.2.02.1301272158450.13067@nftneq.ynat.uz>
	<CAEsagEjAoVNUUSotBXd0am5zZb5VMLWT2Dz9k5fj+C9-LKABnQ@mail.gmail.com>
	<20130128141209.GA22711@thunk.org>
	<alpine.DEB.2.02.1301281526410.21503@nftneq.ynat.uz>
	<20130129002011.GA4757@blackbox.djwong.org>
	<20130129014000.GA7003@thunk.org>
Date: Mon, 28 Jan 2013 20:34:24 -0800
Message-ID: <CAEsagEhZkkr+G0gFr6rnsyjFmCckNMkOnTVcUMvaj8EHD-qGQw@mail.gmail.com>
Subject: Re: Tux3 Report: Initial fsck has landed
From: Daniel Phillips <daniel.raymond.phillips@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        David Lang <david@lang.hm>,
        Daniel Phillips <daniel.raymond.phillips@gmail.com>,
        linux-kernel@vger.kernel.org, tux3@tux3.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 5:40 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Mon, Jan 28, 2013 at 04:20:11PM -0800, Darrick J. Wong wrote:
>> On Mon, Jan 28, 2013 at 03:27:38PM -0800, David Lang wrote:
>> > The situation I'm thinking of is when dealing with VMs, you make a
>> > filesystem image once and clone it multiple times. Won't that end up
>> > with the same UUID in the superblock?
>>
>> Yes, but one ought to be able to change the UUID a la tune2fs -U.  Even
>> still... so long as the VM images have a different UUID than the fs that they
>> live on, it ought to be fine.
>
> ... and this is something most system administrators should be
> familiar with.  For example, it's one of those things that Norton
> Ghost when makes file system image copes (the equivalent of "tune2fs
> -U random /dev/XXX")

Hmm, maybe I missed something but it does not seem like a good idea
to use the volume UID itself to generate unique-per-volume metadata
hashes, if users expect to be able to change it. All the metadata hashes
would need to be changed.

Anyway, our primary line of attack on this problem is not unique hashes,
but actually knowing which blocks are in files and which are not. Before
(a hypothetical) Tux3 fsck repair would be so bold as to reattach some lost
metadata to the place it thinks it belongs, all of the following would need
to be satisfied:

   * The lost metadata subtree is completely detached from the filesystem
     tree. In other words, it cannot possibly be the contents of some valid
     file already belonging to the filesystem. I believe this addresses the
     concern of David Lang at the head of this thread.

   * The filesystem tree is incomplete. Somwhere in it Tux3 fsck has
     discovered a hole that needs to be filled.

   * The lost metadata subree is complete and consistent, except for not
     being attached to the filesystem tree.

   * The lost metadata subtree that was found matches a hole where
     metadata is missing, according to its "uptags", which specify at
     least the low order bits of the inode the metadata belongs to and
     the offset at which it belongs.

   * Tux3 fsck asked the user if this lost metadata (describing it in some
     reasonable way) should be attached to some particular filesystem
     object that appears to be incomplete. Alternatively, the lost subtree
     may be attached to the traditional "lost+found" directory, though we
     are able to be somewhat more specific about where the subtree
     might originally have belonged, and can name the lost+found object
     accordingly.

Additionally, Tux3 fsck might consider the following:

  * If the allocation bitmaps appear to be undamaged, but some or all
    of a lost filesystem tree is marked as free space, then the subtree is
    most likely free space and no attempt should be made to attach it to
    anything.

Thanks for your comments. I look forward to further review as things progress.

One thing to consider: this all gets much more interesting when versioning
arrives. For shared tree snapshotting filesystem designs, this must get very
interesting indeed, to the point where even contemplating the corner makes
me shudder. But even with versioning, Tux3 still upholds the single-reference
rule, therefore our fsck problem will continue to look a lot more like Ext4 than
like Btrfs or ZFS. Which suggests some great opportunities for unabashed
imitation.

Regards,

Daniel
