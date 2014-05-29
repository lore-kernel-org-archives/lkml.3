Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716AbaE2DgA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 23:36:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:16702 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264AbaE2Df7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 23:35:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,932,1392192000"; 
   d="scan'208";a="548165091"
Message-ID: <5386AAF4.4090804@intel.com>
Date: Thu, 29 May 2014 11:35:16 +0800
From: Jet Chen <jet.chen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>,
        Dongsu Park <dongsu.park@profitbricks.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: [PATCH] bio: decrease bi_iter.bi_size by len in the fail path
References: <20140527112459.GF2205@dhcp-27-189.brq.redhat.com>	<1401289778-9840-1-git-send-email-dongsu.park@profitbricks.com>	<CACVXFVO6uW3KoVPoeb+O0txuY2Ji6BO1Sob1e-g7NmZBv9MPBQ@mail.gmail.com> <CACVXFVNNc3dRshmMYNgS+pn54RC2dyQkJFOy1=HJdXfUfuhAMQ@mail.gmail.com>
In-Reply-To: <CACVXFVNNc3dRshmMYNgS+pn54RC2dyQkJFOy1=HJdXfUfuhAMQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2014 12:59 AM, Ming Lei wrote:
> On Wed, May 28, 2014 at 11:42 PM, Ming Lei <tom.leiming@gmail.com> wrote:
>> Hi Dongsu,
>>
>> On Wed, May 28, 2014 at 11:09 PM, Dongsu Park
>> <dongsu.park@profitbricks.com> wrote:
>>> From: Dongsu Park <dongsu.park@profitbricks.com>
>>>
>>> Commit 3979ef4dcf3d1de55a560a3a4016c30a835df44d ("bio-modify-
>>> __bio_add_page-to-accept-pages-that-dont-start-a-new-segment-v3")
>>> introduced a regression as reported by Jet Chen.
>>> That results in a kernel BUG at drivers/block/virtio_blk.c:166.
>>>
>>> To fix that, bi_iter.bi_size must be decreased by len, before
>>> recounting the number of physical segments.
>>>
>>> Tested on with kernel 3.15.0-rc7-next-20140527 on qemu guest,
>>> by running xfstests/ext4/271.
>>>
>>> Cc: Jens Axboe <axboe@kernel.dk>
>>> Cc: Jet Chen <jet.chen@intel.com>
>>> Cc: Maurizio Lombardi <mlombard@redhat.com>
>>> Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
>>> ---
>>>  block/bio.c | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/block/bio.c b/block/bio.c
>>> index 0443694ccbb4..67d7cba1e5fd 100644
>>> --- a/block/bio.c
>>> +++ b/block/bio.c
>>> @@ -810,6 +810,7 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
>>>         bvec->bv_len = 0;
>>>         bvec->bv_offset = 0;
>>>         bio->bi_vcnt--;
>>> +       bio->bi_iter.bi_size -= len;
>>
>> Would you mind explaining why bi_iter.bi_size need to be
>> decreased by 'len'? In the failure path, it wasn't added by
>> 'len', was it?
> 
> Actually, the correct thing may be like what did in the
> attached patch, as Maurizio discussed with me[1].
> 
> Very interestingly, I have reproduced the problem one time
> with ext4/271 ext4/301 ext4/305, but won't with the attached
> patch after running it for 3 rounds.
> 
> [tom@localhost xfstests]$ sudo ./check ext4/271 ext4/301 ext4/305
> FSTYP         -- ext4
> PLATFORM      -- Linux/x86_64 localhost 3.15.0-rc7-next-20140527+
> MKFS_OPTIONS  -- /dev/vdc
> MOUNT_OPTIONS -- -o acl,user_xattr /dev/vdc /mnt/scratch
> 
> ext4/271 1s ... 1s
> ext4/301 31s ... 32s
> ext4/305 181s ... 180s
> Ran: ext4/271 ext4/301 ext4/305
> Passed all 3 tests
> 
> Jet, could you test the attached patch?

sorry, could you specify which patch need me to test ?
actually I got confused. I only find
	
	[PATCH V3] bio: modify __bio_add_page() to accept pages that don't start a new segment

in this mail thread. is it need to be tested ?

on next/master branch,

commit 3979ef4dcf3d1de55a560a3a4016c30a835df44d
Author: Maurizio Lombardi <mlombard@redhat.com>
Date:   Sat May 17 23:17:30 2014 +1000

    bio-modify-__bio_add_page-to-accept-pages-that-dont-start-a-new-segment-v3

    Changes in V3:

    In case of error, V2 restored the previous number of segments but left
    the BIO_SEG_FLAG set.
    To avoid problems, after the page is removed from the bio vec,
    V3 performs a recount of the segments in the error code path.

    Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
    Cc: Al Viro <viro@zeniv.linux.org.uk>
    Cc: Christoph Hellwig <hch@lst.de>
    Cc: Kent Overstreet <kmo@daterainc.com>
    Cc: Jens Axboe <axboe@kernel.dk>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

commit fceb38f36f4fecabf9ca33aa44a3f943f133cb78
Author: Maurizio Lombardi <mlombard@redhat.com>
Date:   Sat May 17 23:17:30 2014 +1000

    bio: modify __bio_add_page() to accept pages that don't start a new segment

    The original behaviour is to refuse to add a new page if the maximum
    number of segments has been reached, regardless of the fact the page we

3979ef4dcf3d1de55a560a3a4016c30a835df44d is the first bad commit.

> 
> [1], https://lkml.org/lkml/2014/5/27/327
> 
> 
> Thanks,
> 
