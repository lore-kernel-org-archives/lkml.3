Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159AbaGOIoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 04:44:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755594AbaGOIox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 04:44:53 -0400
Message-ID: <53C4E9F1.7070302@redhat.com>
Date: Tue, 15 Jul 2014 10:44:33 +0200
From: Maurizio Lombardi <mlombard@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, Mike Qiu <qiudayu@linux.vnet.ibm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ming.lei@canonical.com" <ming.lei@canonical.com>,
        "dongsu.park@profitbricks.com" <dongsu.park@profitbricks.com>,
        "jet.chen@intel.com" <jet.chen@intel.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "hch@lst.de" <hch@lst.de>, "kmo@daterainc.com" <kmo@daterainc.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "axboe@fb.com" <axboe@fb.com>
Subject: Re: Bug_ON with patch: bio: modify __bio_add_page() to accept pages
 that don't start a new segment
References: <53C4E2F0.8000307@linux.vnet.ibm.com> <E83EB052-8DC9-4B0E-830D-AF7A2557BEF6@kernel.dk>
In-Reply-To: <E83EB052-8DC9-4B0E-830D-AF7A2557BEF6@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/15/2014 10:41 AM, Jens Axboe wrote:
> On 15/07/2014, at 10.14, Mike Qiu <qiudayu@linux.vnet.ibm.com> wrote:
>>
>> My Power7 box boot fail with commit:
>>
>> 254c4407cb84a6dec90336054615b0f0e996bb7c
>> bio: modify __bio_add_page() to accept pages that don't start a new segment
>>
>> Just revert it will works for me.
> 
> I have reverted it yesterday in my tree. 
> 


The problem was here:

        if (q->merge_bvec_fn) {
                struct bvec_merge_data bvm = {
                        .bi_bdev = bio->bi_bdev,
                        .bi_sector = bio->bi_iter.bi_sector,
                        .bi_size = bio->bi_iter.bi_size, <-------
                        .bi_rw = bio->bi_rw,
                };

                /*
                 * merge_bvec_fn() returns number of bytes it can accept
                 * at this offset
                 */
                if (q->merge_bvec_fn(q, &bvm, bvec) < bvec->bv_len)
                        goto failed;
        }

        /* If we may be able to merge these biovecs, force a recount */
        if (bio->bi_vcnt > 1 && (BIOVEC_PHYS_MERGEABLE(bvec-1, bvec)))
                bio->bi_flags &= ~(1 << BIO_SEG_VALID);


it should have been ".bi_size = bio->bi_iter.bi_size - len"

Regards,
Maurizio Lombardi
