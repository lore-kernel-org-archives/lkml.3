Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293AbaJIQNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 12:13:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57137 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaJIQNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 12:13:47 -0400
MIME-Version: 1.0
In-Reply-To: <CACVXFVO+LBseOCmQuHaVz5LnK0hgvp1iPPhkGWFZc_iOxjBnfg@mail.gmail.com>
References: <5435C093.5070405@suse.com>
	<x4938axz6vd.fsf@segfault.boston.devel.redhat.com>
	<54369B13.4030004@suse.com>
	<CACVXFVO+LBseOCmQuHaVz5LnK0hgvp1iPPhkGWFZc_iOxjBnfg@mail.gmail.com>
Date: Fri, 10 Oct 2014 00:13:44 +0800
Message-ID: <CACVXFVOuS7gj=Dn1R1+hdK3GsaFx5SiR5gRNLK-4a9TA_dMJyw@mail.gmail.com>
Subject: Re: [PATCH] block: copy bi_vcnt in __bio_clone_fast
From: Ming Lei <ming.lei@canonical.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=047d7b47282e6e2db80504ffb768
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b47282e6e2db80504ffb768
Content-Type: text/plain; charset=UTF-8

On Thu, Oct 9, 2014 at 11:25 PM, Ming Lei <ming.lei@canonical.com> wrote:
> On Thu, Oct 9, 2014 at 10:26 PM, Jeff Mahoney <jeffm@suse.com> wrote:
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>
>> On 10/9/14, 9:53 AM, Jeff Moyer wrote:
>>> Jeff Mahoney <jeffm@suse.com> writes:
>>>
>>>> Commit 05f1dd53152173 (block: add queue flag for disabling SG
>>>> merging) uses bi_vcnt to assign bio->bi_phys_segments if sg
>>>> merging is disabled. When using device mapper on top of a blk-mq
>>>> device (virtio_blk in my test), we'd end up overflowing the
>>>> scatterlist in __blk_bios_map_sg.
>>>>
>>>> __bio_clone_fast copies bi_iter and bi_io_vec but not bi_vcnt,
>>>> so blk_recount_segments would report bi_phys_segments as 0.
>>>> Since rq->nr_phys_segments is 0 as well, the checks to ensure
>>>> that we don't exceed the queue's segment limit end up allowing
>>>> more bios (and segments) to attach the a request until we finally
>>>> map it. That also means we pass the BUG_ON at the beginning of
>>>> virtio_queue_rq, ultimately causing memory corruption and a
>>>> crash.
>>>>
>>>> If we copy bi_vcnt in __bio_clone_fast, the bios and requests
>>>> properly report the number of segments and everything works as
>>>> expected.
>>>>
>>>> Originally reported at
>>>> http://bugzilla.opensuse.org/show_bug.cgi?id=888259
>>>
>>> Hi, Jeff,
>>>
>>> Did you manage to reproduce this problem with commit 0738854
>>> (blk-merge: fix blk_recount_segments) applied?  Or perhaps with
>>> commit 200612e (dm table: propagate QUEUE_FLAG_NO_SG_MERGE)?
>>
>> Yep. I was able to reproduce it with 3.17. I did try 0738854 when I
>> was still using 3.16 since it looked like a good candidate. Neither of
>> those patches affect the problem here. bio->bi_phys_segments never
>> gets a value set in the fast clone case and that translates to
>> req->nr_phys_segments never getting properly accumulated. That might
>> not be a problem except that the NO_SG_MERGE behavior bypasses the
>> iteration that would come up with the correct value. In either case,
>
> This patch may get incorrect rq->nr_phys_segments because
> bio cloning is often used in case of I/O splitting, so could you
> test if the attached patch fixes your problem?

Please ignore last patch and test the attached patch since we
still should use no sg merge to recalculate req's segments for
cloned bio.

Thanks,

--047d7b47282e6e2db80504ffb768
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-blk-merge-don-t-compute-bi_phys_segments-from-bi_vcn.patch"
Content-Disposition: attachment; 
	filename="0001-blk-merge-don-t-compute-bi_phys_segments-from-bi_vcn.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i12b1avt1

RnJvbSBmZDhiZTM1YzFiMWUzNTc4MTEzN2IyMDIwZGQyOTU1MmMzZjhlYjk4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNaW5nIExlaSA8bWluZy5sZWlAY2Fub25pY2FsLmNvbT4KRGF0
ZTogVGh1LCA5IE9jdCAyMDE0IDIzOjE3OjM1ICswODAwClN1YmplY3Q6IFtQQVRDSF0gYmxrLW1l
cmdlOiBkb24ndCBjb21wdXRlIGJpX3BoeXNfc2VnbWVudHMgZnJvbSBiaV92Y250IGZvcgogY2xv
bmVkIGJpbwoKSXQgaXNuJ3QgY29ycmVjdCB0byBmaWd1cmUgb3V0IHJlcS0+YmlfcGh5c19zZWdt
ZW50cyBmcm9tIGJpby0+YmlfdmNudAppZiB0aGUgYmlvIGlzIGNsb25lZC4KClNpZ25lZC1vZmYt
Ynk6IE1pbmcgTGVpIDxtaW5nLmxlaUBjYW5vbmljYWwuY29tPgotLS0KIGJsb2NrL2Jsay1tZXJn
ZS5jIHwgICAgOCArKysrKystLQogMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMiBk
ZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9ibG9jay9ibGstbWVyZ2UuYyBiL2Jsb2NrL2Jsay1t
ZXJnZS5jCmluZGV4IGY3MWJhZDMuLmJhOTkzNTEgMTAwNjQ0Ci0tLSBhL2Jsb2NrL2Jsay1tZXJn
ZS5jCisrKyBiL2Jsb2NrL2Jsay1tZXJnZS5jCkBAIC05NywxNCArOTcsMTggQEAgdm9pZCBibGtf
cmVjYWxjX3JxX3NlZ21lbnRzKHN0cnVjdCByZXF1ZXN0ICpycSkKIAogdm9pZCBibGtfcmVjb3Vu
dF9zZWdtZW50cyhzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSwgc3RydWN0IGJpbyAqYmlvKQogewot
CWlmICh0ZXN0X2JpdChRVUVVRV9GTEFHX05PX1NHX01FUkdFLCAmcS0+cXVldWVfZmxhZ3MpICYm
CisJYm9vbCBub19zZ19tZXJnZSA9ICEhdGVzdF9iaXQoUVVFVUVfRkxBR19OT19TR19NRVJHRSwK
KwkJCSZxLT5xdWV1ZV9mbGFncyk7CisKKwlpZiAobm9fc2dfbWVyZ2UgJiYgIWJpb19mbGFnZ2Vk
KGJpbywgQklPX0NMT05FRCkgJiYKIAkJCWJpby0+YmlfdmNudCA8IHF1ZXVlX21heF9zZWdtZW50
cyhxKSkKIAkJYmlvLT5iaV9waHlzX3NlZ21lbnRzID0gYmlvLT5iaV92Y250OwogCWVsc2Ugewog
CQlzdHJ1Y3QgYmlvICpueHQgPSBiaW8tPmJpX25leHQ7CiAKIAkJYmlvLT5iaV9uZXh0ID0gTlVM
TDsKLQkJYmlvLT5iaV9waHlzX3NlZ21lbnRzID0gX19ibGtfcmVjYWxjX3JxX3NlZ21lbnRzKHEs
IGJpbywgZmFsc2UpOworCQliaW8tPmJpX3BoeXNfc2VnbWVudHMgPSBfX2Jsa19yZWNhbGNfcnFf
c2VnbWVudHMocSwgYmlvLAorCQkJCW5vX3NnX21lcmdlKTsKIAkJYmlvLT5iaV9uZXh0ID0gbnh0
OwogCX0KIAotLSAKMS43LjkuNQoK
--047d7b47282e6e2db80504ffb768--
