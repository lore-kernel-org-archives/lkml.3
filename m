Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab3KTONJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 09:13:09 -0500
Received: from mail-ph.de-nserver.de ([85.158.179.214]:50367 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab3KTONG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 09:13:06 -0500
X-Fcrdns: No
Message-ID: <528CC36A.7080003@profihost.ag>
Date: Wed, 20 Nov 2013 15:12:58 +0100
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Chinmay V S <cvs268@gmail.com>, Christoph Hellwig <hch@infradead.org>
CC: linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, matthew@wil.cx
Subject: Re: Why is O_DSYNC on linux so slow / what's wrong with my SSD?
References: <528CA73B.9070604@profihost.ag> <20131120125446.GA6284@infradead.org> <CAK-9PRAManphkxT3ub0DfW8hx=xbq+ZeqUB0E0CEnFTfF7AQuw@mail.gmail.com>
In-Reply-To: <CAK-9PRAManphkxT3ub0DfW8hx=xbq+ZeqUB0E0CEnFTfF7AQuw@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by hostmaster@profihost.com through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi ChinmayVS,

Am 20.11.2013 14:34, schrieb Chinmay V S:
> Hi Stefan,
> 
> Christoph is bang on right. To further elaborate upon this, here is
> what is happening in the above case :
> By using DIRECT, SYNC/DSYNC flags on a block device (i.e. bypassing
> the file-systems layer), essentially you are enforcing a CMD_FLUSH on
> each I/O command sent to the disk. This is by design of the
> block-device driver in the Linux kernel. This severely degrades the
> performance.
> 
> A detailed walk-through of the various I/O scenarios is available at
> thecodeartist.blogspot.com/2012/08/hdd-filesystems-osync.html
> 
> Note that SYNC/DSYNC on a filesystem(eg. ext2/3/4) does NOT issue a
> CMD_FLUSH. The "SYNC" via filesystem, simply guarantees that the data
> is sent to the disk and not really flushed to the disk. It will
> continue to reside in the internal cache on the disk, waiting to be
> written to the disk platter in a optimum manner (bunch of writes
> re-ordered to be sequential on-disk and clubbed together in one go).
> This can affect performance to a large extent on modern HDDs with NCQ
> support (CMD_FLUSH simply cancels all performance benefits of NCQ).
> 
> In case of SSDs, the huge IOPS number for the disk (40,000 in case of
> Crucial M4) is again typically observed with write-cache enabled.
> For Crucial M4 SSDs,
> http://www.crucial.com/pdf/tech_specs-letter_crucial_m4_ssd_v3-11-11_online.pdf
> Footnote1 - "Typical I/O performance numbers as measured using Iometer
> with a queue depth of 32 and write cache enabled. Iometer measurements
> are performed on a 8GB span. 4k transfers used for Read/Write latency
> values."

thanks for your great and detailed reply. I'm just wondering why an
intel 520 ssd degrades the speed just by 2% in case of O_SYNC. intel 530
the newer model and replacement for the 520 degrades speed by 75% like
the crucial m4.

The Intel DC S3500 instead delivers also nearly 98% of it's performance
even under O_SYNC.

> To simply disable this behaviour and make the SYNC/DSYNC behaviour and
> performance on raw block-device I/O resemble the standard filesystem
> I/O you may want to apply the following patch to your kernel -
> https://gist.github.com/TheCodeArtist/93dddcd6a21dc81414ba
> 
> The above patch simply disables the CMD_FLUSH command support even on
> disks that claim to support it.

Is this the right one? By assing ahci_dummy_read_id we disable the
CMD_FLUSH?

What is the risk of that one?

Thanks!

Stefan
