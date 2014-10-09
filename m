Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbaJIPZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 11:25:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56859 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbaJIPZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 11:25:26 -0400
MIME-Version: 1.0
In-Reply-To: <54369B13.4030004@suse.com>
References: <5435C093.5070405@suse.com>
	<x4938axz6vd.fsf@segfault.boston.devel.redhat.com>
	<54369B13.4030004@suse.com>
Date: Thu, 9 Oct 2014 23:25:22 +0800
Message-ID: <CACVXFVO+LBseOCmQuHaVz5LnK0hgvp1iPPhkGWFZc_iOxjBnfg@mail.gmail.com>
Subject: Re: [PATCH] block: copy bi_vcnt in __bio_clone_fast
From: Ming Lei <ming.lei@canonical.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001a11408c6a818a7b0504ff0aae
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11408c6a818a7b0504ff0aae
Content-Type: text/plain; charset=UTF-8

On Thu, Oct 9, 2014 at 10:26 PM, Jeff Mahoney <jeffm@suse.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 10/9/14, 9:53 AM, Jeff Moyer wrote:
>> Jeff Mahoney <jeffm@suse.com> writes:
>>
>>> Commit 05f1dd53152173 (block: add queue flag for disabling SG
>>> merging) uses bi_vcnt to assign bio->bi_phys_segments if sg
>>> merging is disabled. When using device mapper on top of a blk-mq
>>> device (virtio_blk in my test), we'd end up overflowing the
>>> scatterlist in __blk_bios_map_sg.
>>>
>>> __bio_clone_fast copies bi_iter and bi_io_vec but not bi_vcnt,
>>> so blk_recount_segments would report bi_phys_segments as 0.
>>> Since rq->nr_phys_segments is 0 as well, the checks to ensure
>>> that we don't exceed the queue's segment limit end up allowing
>>> more bios (and segments) to attach the a request until we finally
>>> map it. That also means we pass the BUG_ON at the beginning of
>>> virtio_queue_rq, ultimately causing memory corruption and a
>>> crash.
>>>
>>> If we copy bi_vcnt in __bio_clone_fast, the bios and requests
>>> properly report the number of segments and everything works as
>>> expected.
>>>
>>> Originally reported at
>>> http://bugzilla.opensuse.org/show_bug.cgi?id=888259
>>
>> Hi, Jeff,
>>
>> Did you manage to reproduce this problem with commit 0738854
>> (blk-merge: fix blk_recount_segments) applied?  Or perhaps with
>> commit 200612e (dm table: propagate QUEUE_FLAG_NO_SG_MERGE)?
>
> Yep. I was able to reproduce it with 3.17. I did try 0738854 when I
> was still using 3.16 since it looked like a good candidate. Neither of
> those patches affect the problem here. bio->bi_phys_segments never
> gets a value set in the fast clone case and that translates to
> req->nr_phys_segments never getting properly accumulated. That might
> not be a problem except that the NO_SG_MERGE behavior bypasses the
> iteration that would come up with the correct value. In either case,

This patch may get incorrect rq->nr_phys_segments because
bio cloning is often used in case of I/O splitting, so could you
test if the attached patch fixes your problem?

Thanks,
--
Ming Lei

--001a11408c6a818a7b0504ff0aae
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-blk-merge-don-t-compute-bi_phys_segments-from-bi_vcn.patch"
Content-Disposition: attachment; 
	filename="0001-blk-merge-don-t-compute-bi_phys_segments-from-bi_vcn.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i1297v110

RnJvbSBkMzk0NmRiOTNjOGViMWRhNGEwYzMyMjQ5ZDYwM2Y0MTVmZWJmMDllIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNaW5nIExlaSA8bWluZy5sZWlAY2Fub25pY2FsLmNvbT4KRGF0
ZTogVGh1LCA5IE9jdCAyMDE0IDIzOjE3OjM1ICswODAwClN1YmplY3Q6IFtQQVRDSF0gYmxrLW1l
cmdlOiBkb24ndCBjb21wdXRlIGJpX3BoeXNfc2VnbWVudHMgZnJvbSBiaV92Y250IGZvcgogY2xv
bmVkIGJpbwoKSXQgaXNuJ3QgY29ycmVjdCB0byBmaWd1cmUgb3V0IHJlcS0+YmlfcGh5c19zZWdt
ZW50cyBmcm9tIGJpby0+YmlfdmNudAppZiB0aGUgYmlvIGlzIGNsb25lZC4KClNpZ25lZC1vZmYt
Ynk6IE1pbmcgTGVpIDxtaW5nLmxlaUBjYW5vbmljYWwuY29tPgotLS0KIGJsb2NrL2Jsay1tZXJn
ZS5jIHwgICAgMSArCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykKCmRpZmYgLS1naXQg
YS9ibG9jay9ibGstbWVyZ2UuYyBiL2Jsb2NrL2Jsay1tZXJnZS5jCmluZGV4IGY3MWJhZDMuLmQ1
Y2FkMWEgMTAwNjQ0Ci0tLSBhL2Jsb2NrL2Jsay1tZXJnZS5jCisrKyBiL2Jsb2NrL2Jsay1tZXJn
ZS5jCkBAIC05OCw2ICs5OCw3IEBAIHZvaWQgYmxrX3JlY2FsY19ycV9zZWdtZW50cyhzdHJ1Y3Qg
cmVxdWVzdCAqcnEpCiB2b2lkIGJsa19yZWNvdW50X3NlZ21lbnRzKHN0cnVjdCByZXF1ZXN0X3F1
ZXVlICpxLCBzdHJ1Y3QgYmlvICpiaW8pCiB7CiAJaWYgKHRlc3RfYml0KFFVRVVFX0ZMQUdfTk9f
U0dfTUVSR0UsICZxLT5xdWV1ZV9mbGFncykgJiYKKwkJCSFiaW9fZmxhZ2dlZChiaW8sIEJJT19D
TE9ORUQpICYmCiAJCQliaW8tPmJpX3ZjbnQgPCBxdWV1ZV9tYXhfc2VnbWVudHMocSkpCiAJCWJp
by0+YmlfcGh5c19zZWdtZW50cyA9IGJpby0+YmlfdmNudDsKIAllbHNlIHsKLS0gCjEuNy45LjUK
Cg==
--001a11408c6a818a7b0504ff0aae--
