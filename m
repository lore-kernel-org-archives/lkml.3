Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab3BIJKO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 04:10:14 -0500
Received: from mail-ia0-f180.google.com ([209.85.210.180]:54645 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab3BIJJ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 04:09:58 -0500
MIME-Version: 1.0
X-Originating-IP: [121.44.22.157]
In-Reply-To: <C4B5704C6FEB5244B2A1BCC8CF83B86B0A624D6719@MYMBX.MY.STEC-INC.AD>
References: <20130202004459.GA4760@blackbox.djwong.org>
	<CANN689ExTyhZBiQ-pg3jw+sA4X459qcy3kpt82n3obJ=9AVceQ@mail.gmail.com>
	<C4B5704C6FEB5244B2A1BCC8CF83B86B0A624D66FE@MYMBX.MY.STEC-INC.AD>
	<20130207000045.GE27179@google.com>
	<C4B5704C6FEB5244B2A1BCC8CF83B86B0A624D6719@MYMBX.MY.STEC-INC.AD>
Date: Sat, 9 Feb 2013 20:09:55 +1100
Message-ID: <CAOzFzEhPWNmYEr8wzjV4YLjGo_JrSwVJkL9144qaiNfc1gLoyw@mail.gmail.com>
Subject: Re: [RFC] [DONOTAPPLY] [PATCH] enhanceio: STEC EnhanceIO SSD caching
 software for Linux kernel
From: Joseph Glanville <joseph.glanville@orionvm.com.au>
To: Amit Kale <akale@stec-inc.com>
Cc: Kent Overstreet <koverstreet@google.com>,
        Michel Lespinasse <walken@google.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-bcache <linux-bcache@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Jason Warr <jason@warr.net>,
        "thornber@redhat.com" <thornber@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 February 2013 12:54, Amit Kale <akale@stec-inc.com> wrote:
>> -----Original Message-----
>> From: Kent Overstreet [mailto:koverstreet@google.com]
>> Sent: Wednesday, February 06, 2013 4:01 PM
>> To: Amit Kale
>> Cc: Michel Lespinasse; Darrick J. Wong; linux-bcache; device-mapper
>> development; Kent Overstreet; Mike Snitzer; LKML; Jason Warr;
>> thornber@redhat.com
>> Subject: Re: [RFC] [DONOTAPPLY] [PATCH] enhanceio: STEC EnhanceIO SSD
>> caching software for Linux kernel
>>
>> On Thu, Feb 07, 2013 at 06:57:40AM +0800, Amit Kale wrote:
>> > > -----Original Message-----
>> > > From: Michel Lespinasse [mailto:walken@google.com]
>> > > Sent: Friday, February 01, 2013 4:58 PM
>> > > To: Darrick J. Wong
>> > > Cc: Amit Kale; linux-bcache; device-mapper development; Kent
>> > > Overstreet; Mike Snitzer; LKML; Jason Warr; thornber@redhat.com
>> > > Subject: Re: [RFC] [DONOTAPPLY] [PATCH] enhanceio: STEC EnhanceIO
>> > > SSD caching software for Linux kernel
>> > >
>> > > On Fri, Feb 1, 2013 at 4:44 PM, Darrick J. Wong
>> > > <darrick.wong@oracle.com> wrote:
>> > > > This is a patch to migrate STEC's enhanceio driver out of their
>> > > github
>> > > > repository and into the staging tree.  From their README:
>> > > >
>> > > > "EnhanceIO driver is based on EnhanceIO SSD caching software
>> > > > product developed by STEC Inc. EnhanceIO was derived from
>> > > > Facebook's open source Flashcache project. EnhanceIO uses SSDs as
>> > > > cache devices for traditional rotating hard disk drives (referred
>> > > > to as source volumes
>> > > throughout this document).
>> > > > EnhanceIO can work with any block device, be it an entire
>> physical
>> > > > disk, an individual disk partition,  a RAIDed DAS device, a SAN
>> > > > volume, a device mapper volume or a software RAID (md) device."
>> > >
>> > > What's your take on the benefits of this vs bcache ?
>> >
>> > EnhanceIO was designed for and has been validated in enterprise
>> > environments. The important benefits are - 1. There is no downtime
>> for cache creation, deletion, editing properties,
>> writeback/readonly/writethrough mode change.
>>
>> True of bcache.
>>
>> > 2. Wb mode comes with an option to control whether dirty data should
>> be clean-up across reboots, which prevents SSD/HDD going out of sync.
>>
>> No idea why you'd want this. You have to be able to handle a rebooting
>> with a dirty cache, if you hope to handle unclean shutdown - bcache
>> does this. And if you're running in writeback mode there's probably
>> going to be many gigabytes of dirty data in your cache, at least
>> sometimes, and you aren't going to want to wait for that to flush
>> before you reboot.
>>
>> If you want to flush dirty data with bcache, you can switch back to
>> writethrough mode whenever you want.
>
> We have two modes of operation with writeback
>
> 1. Warm restart mode (default) - Reboots are quick. Dirty data is kept as it is across reboots. So is clean data. Abrupt reboots are handled correctly by throwing away clean data and retaining dirty data. The throwing away clean data is a fallout of an optimization done to skip metadata updates for clean data.
>
> 2. Cold restart mode - A reboot or a shutdown involves clean-up of dirty data. This is for paranoid sysads who are afraid that iSCSI HDD setup may cause them to be reattached. Switching to writethrough mode will achieve the same thing, however with a persistent cache configuration in place, the cache will be write-through after a reboot.

How does Enhance-IO prevent mounting of the backing device if the
cache device doesn't show up due to failure etc?
I was reviewing the setup/tear-down code but I couldn't find where EIO
writes any superblock etc to the backing device to prevent udev etc
from mounting the filesystem.

>
> I am happy to see bcache being compliant with the rest of the items I had noted.
>
> -Amit
>
>>
>> > 3. Our in-house testing was done for large setups with 500GB+SSDs and
>> proportionately large HDDs, on 24CPU machines with plenty of RAM. It's
>> survived heavy IO loads without any locking or corruption problems.
>>
>> True of bcache.
>>
>> > 4. Error handling is exactly what enterprises look for -
>> writethrough/readonly modes work seamlessly regardless of SSD failures.
>> In all the three caching modes, the guarantees of completion in
>> presence of IO errors or shutdowns, in terms of granularity and
>> persistence of data written, is identical to underlying HDDs.
>>
>> True of bcache.
>>
>> > 5. It works for all known block devices - Software RAIDs, full block
>> devices with or without partitions, individual partitions, various
>> intelligent block devices.
>>
>> True of bcache.
>>
>> > -Amit
>> >
>> > PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED
>> >
>> > This electronic transmission, and any documents attached hereto, may
>> contain confidential, proprietary and/or legally privileged
>> information. The information is intended only for use by the recipient
>> named above. If you received this electronic message in error, please
>> notify the sender and delete the electronic message. Any disclosure,
>> copying, distribution, or use of the contents of information received
>> in error is strictly prohibited, and violators will be pursued legally.
>>
>> Which of the above information was proprietary, and should I not be
>> resending this to lkml or - who?
>>
>> ...
>
> PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED
>
> This electronic transmission, and any documents attached hereto, may contain confidential, proprietary and/or legally privileged information. The information is intended only for use by the recipient named above. If you received this electronic message in error, please notify the sender and delete the electronic message. Any disclosure, copying, distribution, or use of the contents of information received in error is strictly prohibited, and violators will be pursued legally.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
CTO | Orion Virtualisation Solutions | www.orionvm.com.au
Phone: 1300 56 99 52 | Mobile: 0428 754 846
