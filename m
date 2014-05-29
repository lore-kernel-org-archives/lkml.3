Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731AbaE2GIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 02:08:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:61319 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbaE2GIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 02:08:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,932,1392192000"; 
   d="scan'208";a="519487777"
Message-ID: <5386CE5A.6070708@intel.com>
Date: Thu, 29 May 2014 14:06:18 +0800
From: Jet Chen <jet.chen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>, Maurizio Lombardi <mlombard@redhat.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Dongsu Park <dongsu.park@profitbricks.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] bio: decrease bi_iter.bi_size by len in the fail path
References: <20140527112459.GF2205@dhcp-27-189.brq.redhat.com>	<1401289778-9840-1-git-send-email-dongsu.park@profitbricks.com>	<CACVXFVO6uW3KoVPoeb+O0txuY2Ji6BO1Sob1e-g7NmZBv9MPBQ@mail.gmail.com>	<CACVXFVNNc3dRshmMYNgS+pn54RC2dyQkJFOy1=HJdXfUfuhAMQ@mail.gmail.com>	<20140528172150.GA3261@dhcp-27-189.brq.redhat.com> <CACVXFVPQR6xdzJxakPhA_rMiNyquooEGt_XS50-nZmyY0P+0CA@mail.gmail.com>
In-Reply-To: <CACVXFVPQR6xdzJxakPhA_rMiNyquooEGt_XS50-nZmyY0P+0CA@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------010606000708080507030805"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010606000708080507030805
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 05/29/2014 01:44 AM, Ming Lei wrote:
> On Thu, May 29, 2014 at 1:21 AM, Maurizio Lombardi <mlombard@redhat.com> wrote:
>> Hi Ming,
>>
>> On Thu, May 29, 2014 at 12:59:19AM +0800, Ming Lei wrote:
>>>
>>> Actually, the correct thing may be like what did in the
>>> attached patch, as Maurizio discussed with me[1].
>>>
>>> Very interestingly, I have reproduced the problem one time
>>> with ext4/271 ext4/301 ext4/305, but won't with the attached
>>> patch after running it for 3 rounds.
>>>
>>> [tom@localhost xfstests]$ sudo ./check ext4/271 ext4/301 ext4/305
>>> FSTYP         -- ext4
>>> PLATFORM      -- Linux/x86_64 localhost 3.15.0-rc7-next-20140527+
>>> MKFS_OPTIONS  -- /dev/vdc
>>> MOUNT_OPTIONS -- -o acl,user_xattr /dev/vdc /mnt/scratch
>>>
>>> ext4/271 1s ... 1s
>>> ext4/301 31s ... 32s
>>> ext4/305 181s ... 180s
>>> Ran: ext4/271 ext4/301 ext4/305
>>> Passed all 3 tests
>>>
>>> Jet, could you test the attached patch?
>>>
>>> [1], https://lkml.org/lkml/2014/5/27/327
>>
>> There is a little mistake in your patch, you removed bio->bi_iter.bi_size += len;
>> after the "done" label,
>> but be careful that at line 747 there is a "goto done"... bi_size should be incremented
>> before jumping there.
>
> Good catch, thanks Maurizio.
>
> Jet, please test the attached patch in this mail and ignore previous
> one.
>
> The story behind the patch should be like below:
>
> - one page is added in __bio_add_page() 'successfully',
> and bio->bi_phys_segments is equal to queue_max_segments(q),
> but it should have been rejected since the last vector isn't covered
>
> - next time, __bio_add_page() is called to add one page, but this
> time blk_recount_segments() can figure out the actual physical
> segments and find it is more than max segments, so failure is
> triggered, but the bio->bi_phys_segments is updated with
> max segments plus one
>
> - the oops is triggered and reported by Jet, :-)
>
>
> Thanks,
>
This patch works, thanks.

Tested-by: Jet Chen <jet.chen@intel.com>


--------------010606000708080507030805
Content-Type: text/x-patch;
 name="fix_compute_segments.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="fix_compute_segments.patch"

diff --git a/block/bio.c b/block/bio.c
index 0443694..f9bae56 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -744,6 +744,7 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 				}
 			}
 
+			bio->bi_iter.bi_size += len;
 			goto done;
 		}
 	}
@@ -761,6 +762,7 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 	bvec->bv_offset = offset;
 	bio->bi_vcnt++;
 	bio->bi_phys_segments++;
+	bio->bi_iter.bi_size += len;
 
 	/*
 	 * Perform a recount if the number of segments is greater
@@ -802,7 +804,6 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 		bio->bi_flags &= ~(1 << BIO_SEG_VALID);
 
  done:
-	bio->bi_iter.bi_size += len;
 	return len;
 
  failed:
@@ -810,6 +811,7 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 	bvec->bv_len = 0;
 	bvec->bv_offset = 0;
 	bio->bi_vcnt--;
+	bio->bi_iter.bi_size -= len;
 	blk_recount_segments(q, bio);
 	return 0;
 }

--------------010606000708080507030805--
