Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab3KTSo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 13:44:27 -0500
Received: from mail-vb0-f44.google.com ([209.85.212.44]:38603 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833Ab3KTSoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 13:44:23 -0500
MIME-Version: 1.0
In-Reply-To: <20131120175807.GC5380@fieldses.org>
References: <528CA73B.9070604@profihost.ag> <20131120125446.GA6284@infradead.org>
 <CAK-9PRAManphkxT3ub0DfW8hx=xbq+ZeqUB0E0CEnFTfF7AQuw@mail.gmail.com>
 <528CC36A.7080003@profihost.ag> <CAK-9PRDyGhXPef-Vbt83Os-oowFZ2HzSZVY9PH3rSdnTwNmf2w@mail.gmail.com>
 <20131120153703.GA23160@thunk.org> <20131120155507.GA5380@fieldses.org>
 <CAK-9PRCQ6qWvzpdvK8BswpS+TfgM7NeoRaVdChFHhyDjwtUGTw@mail.gmail.com> <20131120175807.GC5380@fieldses.org>
From: Chinmay V S <cvs268@gmail.com>
Date: Thu, 21 Nov 2013 00:13:52 +0530
Message-ID: <CAK-9PRDNxHAX70cN88kRt03FkYbDB_x1cFQQYmVzqiCX=aZD6w@mail.gmail.com>
Subject: Re: Why is O_DSYNC on linux so slow / what's wrong with my SSD?
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <matthew@wil.cx>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 11:28 PM, J. Bruce Fields <bfields@fieldses.org> wrote:
> On Wed, Nov 20, 2013 at 10:41:54PM +0530, Chinmay V S wrote:
>> On Wed, Nov 20, 2013 at 9:25 PM, J. Bruce Fields <bfields@fieldses.org> wrote:
>> > Some SSD's are also claim the ability to flush the cache on power loss:
>> >
>> >         http://www.intel.com/content/www/us/en/solid-state-drives/ssd-320-series-power-loss-data-protection-brief.html
>> >
>> > Which should in theory let them respond immediately to flush requests,
>> > right?  Except they only seem to advertise it as a safety (rather than a
>> > performance) feature, so I probably misunderstand something.
>> >
>> > And the 520 doesn't claim this feature (look for "enhanced power loss
>> > protection" at http://ark.intel.com/products/66248), so that wouldn't
>> > explain these results anyway.
>>
>> FYI, nowhere does Intel imply that the CMD_FLUSH is instantaneous. The
>> product brief for Intel 320 SSDs (above link), explains that it is
>> implemented by a power-fail detection circuit that detects drop in
>> power-supply, following which the on-disk controller issues an internal
>> CMD_FLUSH equivalent command to ensure data is moved to the
>> non-volatile area from the disk-cache. Large secondary capacitors
>> ensure backup supply for this brief duration.
>>
>> Thus applications can always perform asynchronous I/O upon the disk,
>> taking comfort in the fact that the physical disk ensures that all
>> data in the volatile disk-cache is automatically transferred to the
>> non-volatile area even in the event of an external power-failure. Thus
>> the host never has to worry about issuing a CMD_FLUSH (which is still
>> a terribly expensive performance bottleneck, even on the Intel 320
>> SSDs).
>
> So why is it up to the application to do this and not the drive?
> Naively I'd've thought it would be simpler if the protocol allowed the
> drive to respond instantly if it knows it can do so safely, and then you
> could always issue flush requests, and save some poor admin from having
> to read spec sheets to figure out if they can safely mount "nobarrier".
Strictly speaking CMD_FLUSH implies that the app/driver wants to
ensure data IS in-fact on the non-volatile area. Also the time-penalty
associated with it on majority of disks is a known fact and hence
CMD_FLUSHes are not issued unless absolutely necessary. During IO upon
a raw block device, as this is the ONLY data barrier available, it is
mapped to the SYNC command.

The Intel 320 SSD is an exception where the disk does NOT need a
CMD_FLUSH as it can guarantee that the cache is always flushed to the
non-volatile area automatically in case of a power loss. However, a
CMD_FLUSH is an explicit command to write to non-volatile area and is
implemented accordingly. Practically though it is could have been made
a no-op on the Intel 320 series(and other similar battery-backed
disks, but not for all disks). Unfortunately this is not how the
on-disk controller firmware is implemented and hence it is up to the
app/kernel-driver to avoid issuing CMD_FLUSHes which are clearly
unnecessary as discussed above.

> Is it that you want to eliminate CMD_FLUSH entirely because the protocol
> still has some significant overhead even if the drive responds to it
> quickly?

1. Most drives do NOT respond to CMD_FLUSH immediately i.e. they wait
until the data is actually moved to the non-volatile media (which is
the right behaviour) i.e. performance drops.

2. Some drives may implement CMD_FLUSH to return immediately i.e. no
guarantee the data is actually on disk.

3. Anyway, CMD_FLUSH does NOT guarantee atomicity. (Consider power
failure in the middle of an ongoing CMD_FLUSH on non battery-backed
disks).

4. Throughput using CMD_FLUSH is so less that an app generating large
amount of I/O will have to buffer most of it in the app layer itself
i.e. it is lost in case of a power-outage.

Considering the above 4 facts, ASYNC IO is almost always better on raw
block devices. This pushes the data to the disk as fast as possible
and an occasional CMD_FLUSH will ensure it is flushed to the
non-volatile area periodically.

In case the application cannot be modified to perform ASYNC IO, there
exists a way to disable the behaviour of issuing a CMD_FLUSH for each
sync() within the block device driver for SATA/SCSI disks. This is
what is described by
https://gist.github.com/TheCodeArtist/93dddcd6a21dc81414ba

Just to be clear, i am NOT recommending that this change be mainlined;
rather it is a reference to improve performance in the rare cases(like
in the OP Stefan's case) where both the app performing DIRECT SYNC
block IO and the disk firmware implementing CMD_FLUSH can NOT be
modified. In which case the standard block driver behaviour of issuing
a CMD_FLUSH with each write is too restrictive and thus modified using
the patch.
