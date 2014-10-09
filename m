Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436AbaJIR6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 13:58:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46716 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918AbaJIR6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 13:58:10 -0400
Message-ID: <5436CCAF.5040100@suse.com>
Date: Thu, 09 Oct 2014 13:58:07 -0400
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: copy bi_vcnt in __bio_clone_fast
References: <5435C093.5070405@suse.com>	<x4938axz6vd.fsf@segfault.boston.devel.redhat.com>	<54369B13.4030004@suse.com>	<CACVXFVO+LBseOCmQuHaVz5LnK0hgvp1iPPhkGWFZc_iOxjBnfg@mail.gmail.com> <CACVXFVOuS7gj=Dn1R1+hdK3GsaFx5SiR5gRNLK-4a9TA_dMJyw@mail.gmail.com>
In-Reply-To: <CACVXFVOuS7gj=Dn1R1+hdK3GsaFx5SiR5gRNLK-4a9TA_dMJyw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 10/9/14, 12:13 PM, Ming Lei wrote:
> On Thu, Oct 9, 2014 at 11:25 PM, Ming Lei <ming.lei@canonical.com>
> wrote:
>> On Thu, Oct 9, 2014 at 10:26 PM, Jeff Mahoney <jeffm@suse.com>
>> wrote:
>>> -----BEGIN PGP SIGNED MESSAGE----- Hash: SHA1
>>> 
>>> On 10/9/14, 9:53 AM, Jeff Moyer wrote:
>>>> Jeff Mahoney <jeffm@suse.com> writes:
>>>> 
>>>>> Commit 05f1dd53152173 (block: add queue flag for disabling
>>>>> SG merging) uses bi_vcnt to assign bio->bi_phys_segments if
>>>>> sg merging is disabled. When using device mapper on top of
>>>>> a blk-mq device (virtio_blk in my test), we'd end up
>>>>> overflowing the scatterlist in __blk_bios_map_sg.
>>>>> 
>>>>> __bio_clone_fast copies bi_iter and bi_io_vec but not
>>>>> bi_vcnt, so blk_recount_segments would report
>>>>> bi_phys_segments as 0. Since rq->nr_phys_segments is 0 as
>>>>> well, the checks to ensure that we don't exceed the queue's
>>>>> segment limit end up allowing more bios (and segments) to
>>>>> attach the a request until we finally map it. That also
>>>>> means we pass the BUG_ON at the beginning of 
>>>>> virtio_queue_rq, ultimately causing memory corruption and
>>>>> a crash.
>>>>> 
>>>>> If we copy bi_vcnt in __bio_clone_fast, the bios and
>>>>> requests properly report the number of segments and
>>>>> everything works as expected.
>>>>> 
>>>>> Originally reported at 
>>>>> http://bugzilla.opensuse.org/show_bug.cgi?id=888259
>>>> 
>>>> Hi, Jeff,
>>>> 
>>>> Did you manage to reproduce this problem with commit 0738854 
>>>> (blk-merge: fix blk_recount_segments) applied?  Or perhaps
>>>> with commit 200612e (dm table: propagate
>>>> QUEUE_FLAG_NO_SG_MERGE)?
>>> 
>>> Yep. I was able to reproduce it with 3.17. I did try 0738854
>>> when I was still using 3.16 since it looked like a good
>>> candidate. Neither of those patches affect the problem here.
>>> bio->bi_phys_segments never gets a value set in the fast clone
>>> case and that translates to req->nr_phys_segments never getting
>>> properly accumulated. That might not be a problem except that
>>> the NO_SG_MERGE behavior bypasses the iteration that would come
>>> up with the correct value. In either case,
>> 
>> This patch may get incorrect rq->nr_phys_segments because bio
>> cloning is often used in case of I/O splitting, so could you test
>> if the attached patch fixes your problem?

Ah. Right.

> Please ignore last patch and test the attached patch since we still
> should use no sg merge to recalculate req's segments for cloned
> bio.

Yep, this fix works as expected.

Thanks,

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJUNsyuAAoJEB57S2MheeWyCSoQALkgpSfaWXEV89Sg0oaVbI/b
KWaHv1lLKICdkIpU+ujwsZtbxOzgwhG13CeWmLZArVvVp2eljciOdpI4vpuXVtOK
12QFj7ShLtgCt7dw/2zE8NP7tY2nAWznHhd8RXrphwM2XJ2APUVGbiUld2e+IqlI
jgdFrSOOVK+ZTUlDTkxjGPD6Q5zCJ7JDZ7cN7IWQB6yu115UoCJ73j9YhpfcDkRA
TZKk5/1NsCq11Gn+a5zCx9WMfauwNEeuwDFXPol8BMAK6BjucrZJjPDG2ykihuuI
EWUUOdnCmXgQgpW9ARrOr7ldfJO7OYL2u9WIgoBwMl1r23ZmSvIvMKIbUFuSwPSz
8yuJpzoH4SaaEO7e2ud2+aMK88Ih1Rr2uN009WPMYn5WXeCWlCBxaLmrFN4nlu3Y
Z/CoFFlhjsNr9Z7QzCv+u2SyEllA0l3/u+t3SNts4jhRReDGrEQIjs0ASvbKqNYZ
+c3hgrZDwv/xL1f7hBSblwIE0DgBn1rPJBfSRkSfrLzSi103lZrBQxpjN3wtjcFK
037/BfkUuzqSTG9MAdZoVkdw/iNh0Q3qfC7PjcT/EDKn4g30+DE04Sh6gDyojyvu
Z0HtRYUPjnlH0OBzvK8AyXmzLoEjkiyL4rSie1F2cy+qK/uRCUjyon8oCK9nfrga
6KWf1kYhmEAO17mN1y6y
=iDIX
-----END PGP SIGNATURE-----
