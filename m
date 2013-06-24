Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab3FXGUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 02:20:00 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:36601 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab3FXGT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 02:19:57 -0400
MIME-Version: 1.0
In-Reply-To: <51C77840.2060800@pobox.com>
References: <20130623101940.GA4448@amd.pavel.ucw.cz>
	<20130623112133.GA4837@amd.pavel.ucw.cz>
	<CAJBHPoj5hgp97=JH8UKX+Ty8TF9_ySQUYU6AnqcRjuLy5A-PcQ@mail.gmail.com>
	<20130623190003.GA6714@amd.pavel.ucw.cz>
	<51C76858.4060906@pobox.com>
	<20130623215100.GA7414@amd.pavel.ucw.cz>
	<51C77840.2060800@pobox.com>
Date: Mon, 24 Jun 2013 08:19:55 +0200
Message-ID: <CAJBHPojcNeCu1MPd8uM19KPdtaypALDRLaWUt+oRUOeJ9erYPA@mail.gmail.com>
Subject: Re: SATA hdd refuses to reallocate a sector?
From: Marcus Overhagen <marcus.overhagen@gmail.com>
To: Mark Lord <mlord@pobox.com>
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org, tj@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > root@amd:~# dd if=/dev/sda4 of=/dev/zero bs=1 skip=8958947328
> > > dd: reading `/dev/sda4': Input/output error
> > > 0+0 records in
> > > 0+0 records out
> > > 0 bytes (0 B) copied, 5.05805 s, 0.0 kB/s
> >
> > I once noticed a similar problem. The trouble is that the kernel
> > always seems to be doing a larger read access that failes for this
> > sector, and the write is never executed.
>
> And returns success writing? That's pretty antisocial :-(.

On a second look i see that you have if and of reversed in the dd command.
However, what I was referring to was that writing a single sector with dd
will fail with a io error because the kernel first seems to do a larger read.

> ...but it does not do the trick :-(. It behaves strangely as if it was
> still cached somewhere. Do I need to turn off the write back cache?

I used hdparm --write-sector successfully to fix a single sector where
dd would fail, but I really don't know what going on with your disk. I
guess your harddisk is having some more issues than this single
sector. If you haven't done it yet, make a complete backup!

Your original post contained:

> end_request: I/O error, dev sda, sector 961237184
> Buffer I/O error on device sda4, logical block 17498759
> Buffer I/O error on device sda4, logical block 17498760
> Buffer I/O error on device sda4, logical block 17498761
> Buffer I/O error on device sda4, logical block 17498762
> Buffer I/O error on device sda4, logical block 17498763
> Buffer I/O error on device sda4, logical block 17498764
> Buffer I/O error on device sda4, logical block 17498765
> Buffer I/O error on device sda4, logical block 17498766
> Buffer I/O error on device sda4, logical block 17498767
> Buffer I/O error on device sda4, logical block 17498768

So assuming(!) that sector 961237184of sda  is logical block 17498759
from sda4, you may need to write all sectors 961237184 to 961237193.

However, regarding the smart data, the drive still thinks that it's
pretty healthy, only 3 reallocated sectors, and no pending.

> 5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Always       -       3
> 197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       0
> 198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       0

Perhaps writing the whole disk with dd and a larger blocksize would
ill work? something like

dd if=/dev/zero of=/dev/sda bs=1M

You shouldn't have any partiton monted when doing so. All data ist
lost after that is finished. then you can look into the smart data to
see how many sectors were reallocated, and decide if you want to trash
the disk.

regards
Marcus

On Mon, Jun 24, 2013 at 12:35 AM, Mark Lord <mlord@pobox.com> wrote:
> On 13-06-23 05:51 PM, Pavel Machek wrote:
>> On Sun 2013-06-23 17:27:52, Mark Lord wrote:
>>
>>> For all existing drives out there, that's a 512 byte unit.
>>
>> I guessed so. (It would be good to actually document it, as well as
>> documenting exactly why it is dangerous. Is it okay to send patches?)
>
> Absolutely.  Please, even!
>
>> Well, I definitely have more than one bad sector, but I did try to
>> read exactly the same sector and it failed. See below.
> ..
> read failed.
> write works.
> read failed.
> write works.
> read works.
> dd failed.
> read works.
> read works.
> read failed.
>
> Odd.  The drive must be furiously reshuffling sectors or something,
> or more likely pushing a piece of dirt around scuffing up more bits.
>
> hdparm generally talks directly to a drive, not through the block
> or filesystem layers.  So the block, filesystem, and page-cache stuff
> don't know anything about --read-sector and --write-sector.
>
> Cheers
> --
> Mark Lord
> Real-Time Remedies Inc.
> mlord@pobox.com
