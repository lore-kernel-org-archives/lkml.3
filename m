Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab3KTPXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 10:23:12 -0500
Received: from mail-ve0-f179.google.com ([209.85.128.179]:48808 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab3KTPXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 10:23:09 -0500
MIME-Version: 1.0
In-Reply-To: <528CC36A.7080003@profihost.ag>
References: <528CA73B.9070604@profihost.ag> <20131120125446.GA6284@infradead.org>
 <CAK-9PRAManphkxT3ub0DfW8hx=xbq+ZeqUB0E0CEnFTfF7AQuw@mail.gmail.com> <528CC36A.7080003@profihost.ag>
From: Chinmay V S <cvs268@gmail.com>
Date: Wed, 20 Nov 2013 20:52:36 +0530
Message-ID: <CAK-9PRDyGhXPef-Vbt83Os-oowFZ2HzSZVY9PH3rSdnTwNmf2w@mail.gmail.com>
Subject: Re: Why is O_DSYNC on linux so slow / what's wrong with my SSD?
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        matthew@wil.cx
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan,

> thanks for your great and detailed reply. I'm just wondering why an
> intel 520 ssd degrades the speed just by 2% in case of O_SYNC. intel 530
> the newer model and replacement for the 520 degrades speed by 75% like
> the crucial m4.
>
> The Intel DC S3500 instead delivers also nearly 98% of it's performance
> even under O_SYNC.

If you have confirmed the performance numbers, then it indicates that
the Intel 530 controller is more advanced and makes better use of the
internal disk-cache to achieve better performance (as compared to the
Intel 520). Thus forcing CMD_FLUSH on each IOP (negating the benefits
of the disk write-cache and not allowing any advanced disk controller
optimisations) has a more pronouced effect of degrading the
performance on Intel 530 SSDs. (Someone with some actual info on Intel
SSDs kindly confirm this.)

>> To simply disable this behaviour and make the SYNC/DSYNC behaviour and
>> performance on raw block-device I/O resemble the standard filesystem
>> I/O you may want to apply the following patch to your kernel -
>> https://gist.github.com/TheCodeArtist/93dddcd6a21dc81414ba
>>
>> The above patch simply disables the CMD_FLUSH command support even on
>> disks that claim to support it.
>
> Is this the right one? By assing ahci_dummy_read_id we disable the
> CMD_FLUSH?
>
> What is the risk of that one?

Yes, https://gist.github.com/TheCodeArtist/93dddcd6a21dc81414ba is the
right one. The dummy read_id() provides a hook into the initial
disk-properties discovery process when the disk is plugged-in. By
explicitly negating the bits that indicate cache and
flush-cache(CMD_FLUSH) support, we can ensure that the block driver
does NOT issue CMD_FLUSH commands to the disk. Note that this does NOT
disable the write-cache on the disk itself i.e. performance improves
due to the on-disk write-cache in the absence of any CMD_FLUSH
commands from the host-PC.

Theoretically, it increases the chances of data loss i.e. if power is
removed while the write is in progress from the app. Personally though
i have found that the impact of this is minimal because SYNC on a raw
block device with CMD_FLUSH does NOT guarantee atomicity in case of a
power-loss. Hence, in the event of a power loss, applications cannot
rely on SYNC(with CMD_FLUSH) for data integrity. Rather they have to
maintain other data-structures with redundant disk metadata (which is
precisely what modern file-systems do). Thus, removing CMD_FLUSH
doesn't really result in a downside as such.

The main thing to consider when applying the above simple patch is
that it is system-wide. The above patch prevents the host-PC from
issuing CMD_FLUSH for ALL drives enumerated via SATA/SCSI on the
system.

If this patch works for you, then to restrict the change in behaviour
to a specific disk, you will need to:
1. Identify the disk by its model number within the dummy read_id().
2. Zero the bits ONLY for your particular disk.
3. Return without modifying anything for all other disks.

Try out the above patch and let me know if you have any further issues.

regards
ChinmayVS
