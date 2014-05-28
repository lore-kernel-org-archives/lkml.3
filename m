Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbaE1Q7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 12:59:22 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:62774 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbaE1Q7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 12:59:20 -0400
MIME-Version: 1.0
In-Reply-To: <CACVXFVO6uW3KoVPoeb+O0txuY2Ji6BO1Sob1e-g7NmZBv9MPBQ@mail.gmail.com>
References: <20140527112459.GF2205@dhcp-27-189.brq.redhat.com>
	<1401289778-9840-1-git-send-email-dongsu.park@profitbricks.com>
	<CACVXFVO6uW3KoVPoeb+O0txuY2Ji6BO1Sob1e-g7NmZBv9MPBQ@mail.gmail.com>
Date: Thu, 29 May 2014 00:59:19 +0800
Message-ID: <CACVXFVNNc3dRshmMYNgS+pn54RC2dyQkJFOy1=HJdXfUfuhAMQ@mail.gmail.com>
Subject: Re: [PATCH] bio: decrease bi_iter.bi_size by len in the fail path
From: Ming Lei <tom.leiming@gmail.com>
To: Dongsu Park <dongsu.park@profitbricks.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Jet Chen <jet.chen@intel.com>,
        Maurizio Lombardi <mlombard@redhat.com>
Content-Type: multipart/mixed; boundary=bcaec547c08dbd00df04fa78bb37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec547c08dbd00df04fa78bb37
Content-Type: text/plain; charset=UTF-8

On Wed, May 28, 2014 at 11:42 PM, Ming Lei <tom.leiming@gmail.com> wrote:
> Hi Dongsu,
>
> On Wed, May 28, 2014 at 11:09 PM, Dongsu Park
> <dongsu.park@profitbricks.com> wrote:
>> From: Dongsu Park <dongsu.park@profitbricks.com>
>>
>> Commit 3979ef4dcf3d1de55a560a3a4016c30a835df44d ("bio-modify-
>> __bio_add_page-to-accept-pages-that-dont-start-a-new-segment-v3")
>> introduced a regression as reported by Jet Chen.
>> That results in a kernel BUG at drivers/block/virtio_blk.c:166.
>>
>> To fix that, bi_iter.bi_size must be decreased by len, before
>> recounting the number of physical segments.
>>
>> Tested on with kernel 3.15.0-rc7-next-20140527 on qemu guest,
>> by running xfstests/ext4/271.
>>
>> Cc: Jens Axboe <axboe@kernel.dk>
>> Cc: Jet Chen <jet.chen@intel.com>
>> Cc: Maurizio Lombardi <mlombard@redhat.com>
>> Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
>> ---
>>  block/bio.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/block/bio.c b/block/bio.c
>> index 0443694ccbb4..67d7cba1e5fd 100644
>> --- a/block/bio.c
>> +++ b/block/bio.c
>> @@ -810,6 +810,7 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
>>         bvec->bv_len = 0;
>>         bvec->bv_offset = 0;
>>         bio->bi_vcnt--;
>> +       bio->bi_iter.bi_size -= len;
>
> Would you mind explaining why bi_iter.bi_size need to be
> decreased by 'len'? In the failure path, it wasn't added by
> 'len', was it?

Actually, the correct thing may be like what did in the
attached patch, as Maurizio discussed with me[1].

Very interestingly, I have reproduced the problem one time
with ext4/271 ext4/301 ext4/305, but won't with the attached
patch after running it for 3 rounds.

[tom@localhost xfstests]$ sudo ./check ext4/271 ext4/301 ext4/305
FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 localhost 3.15.0-rc7-next-20140527+
MKFS_OPTIONS  -- /dev/vdc
MOUNT_OPTIONS -- -o acl,user_xattr /dev/vdc /mnt/scratch

ext4/271 1s ... 1s
ext4/301 31s ... 32s
ext4/305 181s ... 180s
Ran: ext4/271 ext4/301 ext4/305
Passed all 3 tests

Jet, could you test the attached patch?

[1], https://lkml.org/lkml/2014/5/27/327


Thanks,
-- 
Ming Lei

--bcaec547c08dbd00df04fa78bb37
Content-Type: application/octet-stream; name=lll
Content-Disposition: attachment; filename=lll
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hvqvib210

ZGlmZiAtLWdpdCBhL2Jsb2NrL2Jpby5jIGIvYmxvY2svYmlvLmMKaW5kZXggMDQ0MzY5NC4uNjg3
Mjg0OSAxMDA2NDQKLS0tIGEvYmxvY2svYmlvLmMKKysrIGIvYmxvY2svYmlvLmMKQEAgLTc2MSw2
ICs3NjEsNyBAQCBzdGF0aWMgaW50IF9fYmlvX2FkZF9wYWdlKHN0cnVjdCByZXF1ZXN0X3F1ZXVl
ICpxLCBzdHJ1Y3QgYmlvICpiaW8sIHN0cnVjdCBwYWdlCiAJYnZlYy0+YnZfb2Zmc2V0ID0gb2Zm
c2V0OwogCWJpby0+YmlfdmNudCsrOwogCWJpby0+YmlfcGh5c19zZWdtZW50cysrOworCWJpby0+
YmlfaXRlci5iaV9zaXplICs9IGxlbjsKIAogCS8qCiAJICogUGVyZm9ybSBhIHJlY291bnQgaWYg
dGhlIG51bWJlciBvZiBzZWdtZW50cyBpcyBncmVhdGVyCkBAIC04MDIsNyArODAzLDYgQEAgc3Rh
dGljIGludCBfX2Jpb19hZGRfcGFnZShzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSwgc3RydWN0IGJp
byAqYmlvLCBzdHJ1Y3QgcGFnZQogCQliaW8tPmJpX2ZsYWdzICY9IH4oMSA8PCBCSU9fU0VHX1ZB
TElEKTsKIAogIGRvbmU6Ci0JYmlvLT5iaV9pdGVyLmJpX3NpemUgKz0gbGVuOwogCXJldHVybiBs
ZW47CiAKICBmYWlsZWQ6CkBAIC04MTAsNiArODEwLDcgQEAgc3RhdGljIGludCBfX2Jpb19hZGRf
cGFnZShzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSwgc3RydWN0IGJpbyAqYmlvLCBzdHJ1Y3QgcGFn
ZQogCWJ2ZWMtPmJ2X2xlbiA9IDA7CiAJYnZlYy0+YnZfb2Zmc2V0ID0gMDsKIAliaW8tPmJpX3Zj
bnQtLTsKKwliaW8tPmJpX2l0ZXIuYmlfc2l6ZSAtPSBsZW47CiAJYmxrX3JlY291bnRfc2VnbWVu
dHMocSwgYmlvKTsKIAlyZXR1cm4gMDsKIH0K
--bcaec547c08dbd00df04fa78bb37--
