Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbaAaCnY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 21:43:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753511AbaAaCnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 21:43:22 -0500
Date: Thu, 30 Jan 2014 21:43:07 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Jens Axboe <axboe@kernel.dk>, "Alasdair G. Kergon" <agk@redhat.com>,
        Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com,
        "David S. Miller" <davem@davemloft.net>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] block devices: validate block device capacity
In-Reply-To: <1391132609.2181.131.camel@dabdike.int.hansenpartnership.com>
Message-ID: <alpine.LRH.2.02.1401302116180.9767@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401301531040.29912@file01.intranet.prod.int.rdu2.redhat.com>   <1391122163.2181.103.camel@dabdike.int.hansenpartnership.com>   <alpine.LRH.2.02.1401301805590.19506@file01.intranet.prod.int.rdu2.redhat.com> 
 <1391125027.2181.114.camel@dabdike.int.hansenpartnership.com>  <alpine.LRH.2.02.1401301905520.25766@file01.intranet.prod.int.rdu2.redhat.com> <1391132609.2181.131.camel@dabdike.int.hansenpartnership.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 30 Jan 2014, James Bottomley wrote:

> > A device may be accessed direcly (by opening /dev/sdX) and it creates a 
> > mapping too - thus, the size of a mapping limits the size of a block 
> > device.
> 
> Right, that's what I suspected below.  We can't damage large block
> support on filesystems just because of this corner case.

Devices larger than 16TiB never worked on 32-bit kernel, so this patch 
isn't damaging anything.

Note that if you attach a 16TiB block device, don't open it and mount it, 
it still won't work, because the buffer cache uses the page cache (see the 
function __find_get_block_slow and the variable "pgoff_t index" - that 
variable would overflow if the filesystem accessed a buffer beyond 16TiB).

> > The main problem is that pgoff_t has 4 bytes - chaning it to 8 bytes may 
> > fix it - but there may be some hidden places where pgoff is converted to 
> > unsigned long - who knows, if they exist or not?
> 
> I don't think we want to do that ... it will make struct page fatter and
> have knock on impacts in the radix tree code.  To fix this, we need to
> make the corner case (i.e. opening large block devices without a
> filesystem) bear the pain.  It sort of looks like we want to do a linear
> array of mappings of 64TB for the device so the page cache calculations
> don't overflow.

The code that reads and writes data to block devices and files is shared - 
the functions in mm/filemap.c work for both files and block devices.

So, if you want 64-bit page offsets, you need to increase pgoff_t size, 
and that will increase the limit for both files and block devices.

You shouldn't have separate functions for managing pages on files and 
separate functions for managing pages on block devices - that would 
increase code size and cause maintenance problems.

> > Though, we need to know if the people who designed memory management agree 
> > with changing pgoff_t to 64 bits.
> 
> I don't think we can change the size of pgoff_t ... because it won't
> just be that, it will be other problems like the radix tree.

If we can't change it, then we must stay with the current 16TiB limit. 
There's no other way.

> However, you also have to bear in mind that truncating large block
> device support to 64TB on 32 bits is a technical ABI break.  Hopefully
> it is only technical because I don't know of any current consumer block
> device that is 64TB yet, but anyone who'd created a filesystem >64TB
> would find it no-longer mounted on 32 bits.
> James

It is not ABI break, because block devices larger than 16TiB never worked 
on 32-bit architectures. So it's better to refuse them outright, than to 
cause subtle lockups or data corruption.

Mikulas
