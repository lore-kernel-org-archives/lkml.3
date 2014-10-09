Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbaJIO0h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 10:26:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43011 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322AbaJIO0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 10:26:30 -0400
Message-ID: <54369B13.4030004@suse.com>
Date: Thu, 09 Oct 2014 10:26:27 -0400
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH] block: copy bi_vcnt in __bio_clone_fast
References: <5435C093.5070405@suse.com> <x4938axz6vd.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x4938axz6vd.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 10/9/14, 9:53 AM, Jeff Moyer wrote:
> Jeff Mahoney <jeffm@suse.com> writes:
> 
>> Commit 05f1dd53152173 (block: add queue flag for disabling SG
>> merging) uses bi_vcnt to assign bio->bi_phys_segments if sg
>> merging is disabled. When using device mapper on top of a blk-mq
>> device (virtio_blk in my test), we'd end up overflowing the
>> scatterlist in __blk_bios_map_sg.
>> 
>> __bio_clone_fast copies bi_iter and bi_io_vec but not bi_vcnt,
>> so blk_recount_segments would report bi_phys_segments as 0.
>> Since rq->nr_phys_segments is 0 as well, the checks to ensure
>> that we don't exceed the queue's segment limit end up allowing
>> more bios (and segments) to attach the a request until we finally
>> map it. That also means we pass the BUG_ON at the beginning of
>> virtio_queue_rq, ultimately causing memory corruption and a
>> crash.
>> 
>> If we copy bi_vcnt in __bio_clone_fast, the bios and requests
>> properly report the number of segments and everything works as
>> expected.
>> 
>> Originally reported at
>> http://bugzilla.opensuse.org/show_bug.cgi?id=888259
> 
> Hi, Jeff,
> 
> Did you manage to reproduce this problem with commit 0738854
> (blk-merge: fix blk_recount_segments) applied?  Or perhaps with
> commit 200612e (dm table: propagate QUEUE_FLAG_NO_SG_MERGE)?

Yep. I was able to reproduce it with 3.17. I did try 0738854 when I
was still using 3.16 since it looked like a good candidate. Neither of
those patches affect the problem here. bio->bi_phys_segments never
gets a value set in the fast clone case and that translates to
req->nr_phys_segments never getting properly accumulated. That might
not be a problem except that the NO_SG_MERGE behavior bypasses the
iteration that would come up with the correct value. In either case,
it's still correct to copy bi_vcnt from the source bio since it's
describing the same bvec. Doing the iteration with no merging would
just end up with the same value. bio_clone_bioset builds up bi_vcnt as
it iterates over the number of segments, so that works fine. It's only
__bio_clone_fast that's broken.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJUNpsSAAoJEB57S2MheeWy5k4QAL2N5KQC3cAv+jYHal5qASaZ
5vr2A2VCofnz9ADV/CHhMNzcArcL1MBn/hJvXC8l/RZkEKY2GYaf4Uqu8LoYjPeJ
7rUrJGQ74H2IS63n7+qgBI5AlL+ndSsOruxiCSExIJPVu4t7MeKGnDKLApq9s7zl
JAh+ec+iJ5mT3Nth714zSyDVBFvBOWhZVm5uf/9QeLrFv9aBG4896u6P50SzA5zn
QU7r9sSwws7o30+2f2A9k57vEPm9DiqKQBgQoI0reZmrrs6YzP3PivLp6v2DLlED
WToOy3b5ZLw2GKeAgYFStQpSLvpwBqFdqjydzJ+ynZ+a07YATDuwj1iailSzY/g2
pCZaXazQ4jBJF5Qsy3C1IpN7OAQS1CBzQTEeLrYi0KQ3aM+VQDp9SV6s1vakFEVD
VsYGJxlUG8MvuPFfvUlqGvYtoudy5R0rdTCdIbWAAQlQosser+1u6mhyqHnSPqyW
Pja/hXmTsffASwqQYXd8HqEVZRDtaqX30dfuLYYWWGq9WBcLPpPFrYilwCwgFZ9C
8HGaMHAtEC3vAN8KBj5rVNgMILrxZlMXVqf+BTs+M9dq6Ed7Q+VYytK9WTM7G3Hy
WY/fhWgFoAOyaTHc1EmxbWjxb5wM2anK3zeiJAomAsZ/f/xhwnq/aLgu3x846Af5
V1v8uHhjR+HfHRn0wmaN
=bziR
-----END PGP SIGNATURE-----
