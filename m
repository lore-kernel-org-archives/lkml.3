Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab3KTNey (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 08:34:54 -0500
Received: from mail-ve0-f176.google.com ([209.85.128.176]:62280 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039Ab3KTNeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 08:34:46 -0500
MIME-Version: 1.0
In-Reply-To: <20131120125446.GA6284@infradead.org>
References: <528CA73B.9070604@profihost.ag> <20131120125446.GA6284@infradead.org>
From: Chinmay V S <cvs268@gmail.com>
Date: Wed, 20 Nov 2013 19:04:15 +0530
Message-ID: <CAK-9PRAManphkxT3ub0DfW8hx=xbq+ZeqUB0E0CEnFTfF7AQuw@mail.gmail.com>
Subject: Re: Why is O_DSYNC on linux so slow / what's wrong with my SSD?
To: Christoph Hellwig <hch@infradead.org>
Cc: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, matthew@wil.cx
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan,

Christoph is bang on right. To further elaborate upon this, here is
what is happening in the above case :
By using DIRECT, SYNC/DSYNC flags on a block device (i.e. bypassing
the file-systems layer), essentially you are enforcing a CMD_FLUSH on
each I/O command sent to the disk. This is by design of the
block-device driver in the Linux kernel. This severely degrades the
performance.

A detailed walk-through of the various I/O scenarios is available at
thecodeartist.blogspot.com/2012/08/hdd-filesystems-osync.html

Note that SYNC/DSYNC on a filesystem(eg. ext2/3/4) does NOT issue a
CMD_FLUSH. The "SYNC" via filesystem, simply guarantees that the data
is sent to the disk and not really flushed to the disk. It will
continue to reside in the internal cache on the disk, waiting to be
written to the disk platter in a optimum manner (bunch of writes
re-ordered to be sequential on-disk and clubbed together in one go).
This can affect performance to a large extent on modern HDDs with NCQ
support (CMD_FLUSH simply cancels all performance benefits of NCQ).

In case of SSDs, the huge IOPS number for the disk (40,000 in case of
Crucial M4) is again typically observed with write-cache enabled.
For Crucial M4 SSDs,
http://www.crucial.com/pdf/tech_specs-letter_crucial_m4_ssd_v3-11-11_online.pdf
Footnote1 - "Typical I/O performance numbers as measured using Iometer
with a queue depth of 32 and write cache enabled. Iometer measurements
are performed on a 8GB span. 4k transfers used for Read/Write latency
values."

To simply disable this behaviour and make the SYNC/DSYNC behaviour and
performance on raw block-device I/O resemble the standard filesystem
I/O you may want to apply the following patch to your kernel -
https://gist.github.com/TheCodeArtist/93dddcd6a21dc81414ba

The above patch simply disables the CMD_FLUSH command support even on
disks that claim to support it.

regards
ChinmayVS

On Wed, Nov 20, 2013 at 6:24 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Nov 20, 2013 at 01:12:43PM +0100, Stefan Priebe - Profihost AG wrote:
>> Can anyone explain to me why O_DSYNC for my app on linux is so slow?
>
> Because FreeBSD ignores O_DSYNC on block devices, it never sends a FLUSH
> to the device.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
