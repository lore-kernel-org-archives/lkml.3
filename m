Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbaE1Roo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 13:44:44 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:48988 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbaE1Rom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 13:44:42 -0400
MIME-Version: 1.0
In-Reply-To: <20140528172150.GA3261@dhcp-27-189.brq.redhat.com>
References: <20140527112459.GF2205@dhcp-27-189.brq.redhat.com>
	<1401289778-9840-1-git-send-email-dongsu.park@profitbricks.com>
	<CACVXFVO6uW3KoVPoeb+O0txuY2Ji6BO1Sob1e-g7NmZBv9MPBQ@mail.gmail.com>
	<CACVXFVNNc3dRshmMYNgS+pn54RC2dyQkJFOy1=HJdXfUfuhAMQ@mail.gmail.com>
	<20140528172150.GA3261@dhcp-27-189.brq.redhat.com>
Date: Thu, 29 May 2014 01:44:41 +0800
Message-ID: <CACVXFVPQR6xdzJxakPhA_rMiNyquooEGt_XS50-nZmyY0P+0CA@mail.gmail.com>
Subject: Re: [PATCH] bio: decrease bi_iter.bi_size by len in the fail path
From: Ming Lei <tom.leiming@gmail.com>
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Jet Chen <jet.chen@intel.com>,
        Dongsu Park <dongsu.park@profitbricks.com>
Content-Type: multipart/mixed; boundary=089e012945fa01d74804fa795ee0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e012945fa01d74804fa795ee0
Content-Type: text/plain; charset=UTF-8

On Thu, May 29, 2014 at 1:21 AM, Maurizio Lombardi <mlombard@redhat.com> wrote:
> Hi Ming,
>
> On Thu, May 29, 2014 at 12:59:19AM +0800, Ming Lei wrote:
>>
>> Actually, the correct thing may be like what did in the
>> attached patch, as Maurizio discussed with me[1].
>>
>> Very interestingly, I have reproduced the problem one time
>> with ext4/271 ext4/301 ext4/305, but won't with the attached
>> patch after running it for 3 rounds.
>>
>> [tom@localhost xfstests]$ sudo ./check ext4/271 ext4/301 ext4/305
>> FSTYP         -- ext4
>> PLATFORM      -- Linux/x86_64 localhost 3.15.0-rc7-next-20140527+
>> MKFS_OPTIONS  -- /dev/vdc
>> MOUNT_OPTIONS -- -o acl,user_xattr /dev/vdc /mnt/scratch
>>
>> ext4/271 1s ... 1s
>> ext4/301 31s ... 32s
>> ext4/305 181s ... 180s
>> Ran: ext4/271 ext4/301 ext4/305
>> Passed all 3 tests
>>
>> Jet, could you test the attached patch?
>>
>> [1], https://lkml.org/lkml/2014/5/27/327
>
> There is a little mistake in your patch, you removed bio->bi_iter.bi_size += len;
> after the "done" label,
> but be careful that at line 747 there is a "goto done"... bi_size should be incremented
> before jumping there.

Good catch, thanks Maurizio.

Jet, please test the attached patch in this mail and ignore previous
one.

The story behind the patch should be like below:

- one page is added in __bio_add_page() 'successfully',
and bio->bi_phys_segments is equal to queue_max_segments(q),
but it should have been rejected since the last vector isn't covered

- next time, __bio_add_page() is called to add one page, but this
time blk_recount_segments() can figure out the actual physical
segments and find it is more than max segments, so failure is
triggered, but the bio->bi_phys_segments is updated with
max segments plus one

- the oops is triggered and reported by Jet, :-)


Thanks,
-- 
Ming Lei

--089e012945fa01d74804fa795ee0
Content-Type: text/x-patch; charset=US-ASCII; name="fix_compute_segments.patch"
Content-Disposition: attachment; filename="fix_compute_segments.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hvqx7u2v0

ZGlmZiAtLWdpdCBhL2Jsb2NrL2Jpby5jIGIvYmxvY2svYmlvLmMKaW5kZXggMDQ0MzY5NC4uZjli
YWU1NiAxMDA2NDQKLS0tIGEvYmxvY2svYmlvLmMKKysrIGIvYmxvY2svYmlvLmMKQEAgLTc0NCw2
ICs3NDQsNyBAQCBzdGF0aWMgaW50IF9fYmlvX2FkZF9wYWdlKHN0cnVjdCByZXF1ZXN0X3F1ZXVl
ICpxLCBzdHJ1Y3QgYmlvICpiaW8sIHN0cnVjdCBwYWdlCiAJCQkJfQogCQkJfQogCisJCQliaW8t
PmJpX2l0ZXIuYmlfc2l6ZSArPSBsZW47CiAJCQlnb3RvIGRvbmU7CiAJCX0KIAl9CkBAIC03NjEs
NiArNzYyLDcgQEAgc3RhdGljIGludCBfX2Jpb19hZGRfcGFnZShzdHJ1Y3QgcmVxdWVzdF9xdWV1
ZSAqcSwgc3RydWN0IGJpbyAqYmlvLCBzdHJ1Y3QgcGFnZQogCWJ2ZWMtPmJ2X29mZnNldCA9IG9m
ZnNldDsKIAliaW8tPmJpX3ZjbnQrKzsKIAliaW8tPmJpX3BoeXNfc2VnbWVudHMrKzsKKwliaW8t
PmJpX2l0ZXIuYmlfc2l6ZSArPSBsZW47CiAKIAkvKgogCSAqIFBlcmZvcm0gYSByZWNvdW50IGlm
IHRoZSBudW1iZXIgb2Ygc2VnbWVudHMgaXMgZ3JlYXRlcgpAQCAtODAyLDcgKzgwNCw2IEBAIHN0
YXRpYyBpbnQgX19iaW9fYWRkX3BhZ2Uoc3RydWN0IHJlcXVlc3RfcXVldWUgKnEsIHN0cnVjdCBi
aW8gKmJpbywgc3RydWN0IHBhZ2UKIAkJYmlvLT5iaV9mbGFncyAmPSB+KDEgPDwgQklPX1NFR19W
QUxJRCk7CiAKICBkb25lOgotCWJpby0+YmlfaXRlci5iaV9zaXplICs9IGxlbjsKIAlyZXR1cm4g
bGVuOwogCiAgZmFpbGVkOgpAQCAtODEwLDYgKzgxMSw3IEBAIHN0YXRpYyBpbnQgX19iaW9fYWRk
X3BhZ2Uoc3RydWN0IHJlcXVlc3RfcXVldWUgKnEsIHN0cnVjdCBiaW8gKmJpbywgc3RydWN0IHBh
Z2UKIAlidmVjLT5idl9sZW4gPSAwOwogCWJ2ZWMtPmJ2X29mZnNldCA9IDA7CiAJYmlvLT5iaV92
Y250LS07CisJYmlvLT5iaV9pdGVyLmJpX3NpemUgLT0gbGVuOwogCWJsa19yZWNvdW50X3NlZ21l
bnRzKHEsIGJpbyk7CiAJcmV0dXJuIDA7CiB9Cg==
--089e012945fa01d74804fa795ee0--
