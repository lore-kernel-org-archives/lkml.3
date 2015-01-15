Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbbAOP45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 10:56:57 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:39087 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbbAOP4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 10:56:55 -0500
MIME-Version: 1.0
In-Reply-To: <CAH3drwacXXPMNDTEaBHFOzOY9PdYgSp9XhimVvHrP3xJg6eEuA@mail.gmail.com>
References: <1421175345-6635-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<CADnq5_PnbTcdUezO5q4RzWUW=YWcEBty_J=b9e0FQFgMO6yKMw@mail.gmail.com>
	<CAH3drwacXXPMNDTEaBHFOzOY9PdYgSp9XhimVvHrP3xJg6eEuA@mail.gmail.com>
Date: Thu, 15 Jan 2015 10:56:54 -0500
Message-ID: <CADnq5_P1rTEPyiGPb9oX7A471KyVMCi6x-Eq=3aENUpYV7t9sA@mail.gmail.com>
Subject: Re: [PATCH] drm/radeon/rv515: Remove unused function
From: Alex Deucher <alexdeucher@gmail.com>
To: Jerome Glisse <j.glisse@gmail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001a11c119b4bc3083050cb2e78d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c119b4bc3083050cb2e78d
Content-Type: text/plain; charset=UTF-8

On Thu, Jan 15, 2015 at 10:43 AM, Jerome Glisse <j.glisse@gmail.com> wrote:
> This one looks highly suspicious, i need to check, but i would think
> that this function should be use !

Yeah, I think the attached patch is probably correct.  Although r5xx
has been using the r300 ring start function for a while apparently.

Alex

>
> On Wed, Jan 14, 2015 at 4:44 PM, Alex Deucher <alexdeucher@gmail.com> wrote:
>> On Tue, Jan 13, 2015 at 1:55 PM, Rickard Strandqvist
>> <rickard_strandqvist@spectrumdigital.se> wrote:
>>> Remove the function rv515_ring_start() that is not used anywhere.
>>>
>>> This was partially found by using a static code analysis program called cppcheck.
>>>
>>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>>
>> Applied.  thanks!
>>
>> Alex
>>
>>> ---
>>>  drivers/gpu/drm/radeon/radeon_asic.h |    1 -
>>>  drivers/gpu/drm/radeon/rv515.c       |   68 ----------------------------------
>>>  2 files changed, 69 deletions(-)
>>>
>>> diff --git a/drivers/gpu/drm/radeon/radeon_asic.h b/drivers/gpu/drm/radeon/radeon_asic.h
>>> index d8ace5b..52667b3 100644
>>> --- a/drivers/gpu/drm/radeon/radeon_asic.h
>>> +++ b/drivers/gpu/drm/radeon/radeon_asic.h
>>> @@ -280,7 +280,6 @@ int rv515_init(struct radeon_device *rdev);
>>>  void rv515_fini(struct radeon_device *rdev);
>>>  uint32_t rv515_mc_rreg(struct radeon_device *rdev, uint32_t reg);
>>>  void rv515_mc_wreg(struct radeon_device *rdev, uint32_t reg, uint32_t v);
>>> -void rv515_ring_start(struct radeon_device *rdev, struct radeon_ring *ring);
>>>  void rv515_bandwidth_update(struct radeon_device *rdev);
>>>  int rv515_resume(struct radeon_device *rdev);
>>>  int rv515_suspend(struct radeon_device *rdev);
>>> diff --git a/drivers/gpu/drm/radeon/rv515.c b/drivers/gpu/drm/radeon/rv515.c
>>> index 8a477bf..cb966e6 100644
>>> --- a/drivers/gpu/drm/radeon/rv515.c
>>> +++ b/drivers/gpu/drm/radeon/rv515.c
>>> @@ -59,74 +59,6 @@ void rv515_debugfs(struct radeon_device *rdev)
>>>         }
>>>  }
>>>
>>> -void rv515_ring_start(struct radeon_device *rdev, struct radeon_ring *ring)
>>> -{
>>> -       int r;
>>> -
>>> -       r = radeon_ring_lock(rdev, ring, 64);
>>> -       if (r) {
>>> -               return;
>>> -       }
>>> -       radeon_ring_write(ring, PACKET0(ISYNC_CNTL, 0));
>>> -       radeon_ring_write(ring,
>>> -                         ISYNC_ANY2D_IDLE3D |
>>> -                         ISYNC_ANY3D_IDLE2D |
>>> -                         ISYNC_WAIT_IDLEGUI |
>>> -                         ISYNC_CPSCRATCH_IDLEGUI);
>>> -       radeon_ring_write(ring, PACKET0(WAIT_UNTIL, 0));
>>> -       radeon_ring_write(ring, WAIT_2D_IDLECLEAN | WAIT_3D_IDLECLEAN);
>>> -       radeon_ring_write(ring, PACKET0(R300_DST_PIPE_CONFIG, 0));
>>> -       radeon_ring_write(ring, R300_PIPE_AUTO_CONFIG);
>>> -       radeon_ring_write(ring, PACKET0(GB_SELECT, 0));
>>> -       radeon_ring_write(ring, 0);
>>> -       radeon_ring_write(ring, PACKET0(GB_ENABLE, 0));
>>> -       radeon_ring_write(ring, 0);
>>> -       radeon_ring_write(ring, PACKET0(R500_SU_REG_DEST, 0));
>>> -       radeon_ring_write(ring, (1 << rdev->num_gb_pipes) - 1);
>>> -       radeon_ring_write(ring, PACKET0(VAP_INDEX_OFFSET, 0));
>>> -       radeon_ring_write(ring, 0);
>>> -       radeon_ring_write(ring, PACKET0(RB3D_DSTCACHE_CTLSTAT, 0));
>>> -       radeon_ring_write(ring, RB3D_DC_FLUSH | RB3D_DC_FREE);
>>> -       radeon_ring_write(ring, PACKET0(ZB_ZCACHE_CTLSTAT, 0));
>>> -       radeon_ring_write(ring, ZC_FLUSH | ZC_FREE);
>>> -       radeon_ring_write(ring, PACKET0(WAIT_UNTIL, 0));
>>> -       radeon_ring_write(ring, WAIT_2D_IDLECLEAN | WAIT_3D_IDLECLEAN);
>>> -       radeon_ring_write(ring, PACKET0(GB_AA_CONFIG, 0));
>>> -       radeon_ring_write(ring, 0);
>>> -       radeon_ring_write(ring, PACKET0(RB3D_DSTCACHE_CTLSTAT, 0));
>>> -       radeon_ring_write(ring, RB3D_DC_FLUSH | RB3D_DC_FREE);
>>> -       radeon_ring_write(ring, PACKET0(ZB_ZCACHE_CTLSTAT, 0));
>>> -       radeon_ring_write(ring, ZC_FLUSH | ZC_FREE);
>>> -       radeon_ring_write(ring, PACKET0(GB_MSPOS0, 0));
>>> -       radeon_ring_write(ring,
>>> -                         ((6 << MS_X0_SHIFT) |
>>> -                          (6 << MS_Y0_SHIFT) |
>>> -                          (6 << MS_X1_SHIFT) |
>>> -                          (6 << MS_Y1_SHIFT) |
>>> -                          (6 << MS_X2_SHIFT) |
>>> -                          (6 << MS_Y2_SHIFT) |
>>> -                          (6 << MSBD0_Y_SHIFT) |
>>> -                          (6 << MSBD0_X_SHIFT)));
>>> -       radeon_ring_write(ring, PACKET0(GB_MSPOS1, 0));
>>> -       radeon_ring_write(ring,
>>> -                         ((6 << MS_X3_SHIFT) |
>>> -                          (6 << MS_Y3_SHIFT) |
>>> -                          (6 << MS_X4_SHIFT) |
>>> -                          (6 << MS_Y4_SHIFT) |
>>> -                          (6 << MS_X5_SHIFT) |
>>> -                          (6 << MS_Y5_SHIFT) |
>>> -                          (6 << MSBD1_SHIFT)));
>>> -       radeon_ring_write(ring, PACKET0(GA_ENHANCE, 0));
>>> -       radeon_ring_write(ring, GA_DEADLOCK_CNTL | GA_FASTSYNC_CNTL);
>>> -       radeon_ring_write(ring, PACKET0(GA_POLY_MODE, 0));
>>> -       radeon_ring_write(ring, FRONT_PTYPE_TRIANGE | BACK_PTYPE_TRIANGE);
>>> -       radeon_ring_write(ring, PACKET0(GA_ROUND_MODE, 0));
>>> -       radeon_ring_write(ring, GEOMETRY_ROUND_NEAREST | COLOR_ROUND_NEAREST);
>>> -       radeon_ring_write(ring, PACKET0(0x20C8, 0));
>>> -       radeon_ring_write(ring, 0);
>>> -       radeon_ring_unlock_commit(rdev, ring, false);
>>> -}
>>> -
>>>  int rv515_mc_wait_for_idle(struct radeon_device *rdev)
>>>  {
>>>         unsigned i;
>>> --
>>> 1.7.10.4
>>>
>>> _______________________________________________
>>> dri-devel mailing list
>>> dri-devel@lists.freedesktop.org
>>> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> http://lists.freedesktop.org/mailman/listinfo/dri-devel

--001a11c119b4bc3083050cb2e78d
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-drm-radeon-use-rv515_ring_start-on-r5xx.patch"
Content-Disposition: attachment; 
	filename="0001-drm-radeon-use-rv515_ring_start-on-r5xx.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i4ybjheg0

RnJvbSAzOWNkMjZiNWQ2MDJmNTdhMTE0ZGVmMjliOGMwOTMxYjQwNjlkYTg5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4IERldWNoZXIgPGFsZXhhbmRlci5kZXVjaGVyQGFtZC5j
b20+CkRhdGU6IFRodSwgMTUgSmFuIDIwMTUgMTA6NTI6MzMgLTA1MDAKU3ViamVjdDogW1BBVENI
XSBkcm0vcmFkZW9uOiB1c2UgcnY1MTVfcmluZ19zdGFydCBvbiByNXh4CgpBdCBzb21lIHBvaW50
IHRoZXNlIHNlZW1zIHRvIGhhdmUgYmVlbiBsb3N0IGluIGZhdm9yCm9mIHRoZSByMzAwX3Jpbmdf
c3RhcnQgZnVuY3Rpb24uCgpTaWduZWQtb2ZmLWJ5OiBBbGV4IERldWNoZXIgPGFsZXhhbmRlci5k
ZXVjaGVyQGFtZC5jb20+Ci0tLQogZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25fYXNpYy5j
IHwgMTggKysrKysrKysrKysrKysrKy0tCiAxIGZpbGUgY2hhbmdlZCwgMTYgaW5zZXJ0aW9ucygr
KSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3Jh
ZGVvbl9hc2ljLmMgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9hc2ljLmMKaW5kZXgg
NmU0NzY2Mi4uZjgxMWVlMSAxMDA2NDQKLS0tIGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRl
b25fYXNpYy5jCisrKyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX2FzaWMuYwpAQCAt
MzMzLDYgKzMzMywyMCBAQCBzdGF0aWMgc3RydWN0IHJhZGVvbl9hc2ljX3JpbmcgcjMwMF9nZnhf
cmluZyA9IHsKIAkuc2V0X3dwdHIgPSAmcjEwMF9nZnhfc2V0X3dwdHIsCiB9OwogCitzdGF0aWMg
c3RydWN0IHJhZGVvbl9hc2ljX3JpbmcgcnY1MTVfZ2Z4X3JpbmcgPSB7CisJLmliX2V4ZWN1dGUg
PSAmcjEwMF9yaW5nX2liX2V4ZWN1dGUsCisJLmVtaXRfZmVuY2UgPSAmcjMwMF9mZW5jZV9yaW5n
X2VtaXQsCisJLmVtaXRfc2VtYXBob3JlID0gJnIxMDBfc2VtYXBob3JlX3JpbmdfZW1pdCwKKwku
Y3NfcGFyc2UgPSAmcjMwMF9jc19wYXJzZSwKKwkucmluZ19zdGFydCA9ICZydjUxNV9yaW5nX3N0
YXJ0LAorCS5yaW5nX3Rlc3QgPSAmcjEwMF9yaW5nX3Rlc3QsCisJLmliX3Rlc3QgPSAmcjEwMF9p
Yl90ZXN0LAorCS5pc19sb2NrdXAgPSAmcjEwMF9ncHVfaXNfbG9ja3VwLAorCS5nZXRfcnB0ciA9
ICZyMTAwX2dmeF9nZXRfcnB0ciwKKwkuZ2V0X3dwdHIgPSAmcjEwMF9nZnhfZ2V0X3dwdHIsCisJ
LnNldF93cHRyID0gJnIxMDBfZ2Z4X3NldF93cHRyLAorfTsKKwogc3RhdGljIHN0cnVjdCByYWRl
b25fYXNpYyByMzAwX2FzaWMgPSB7CiAJLmluaXQgPSAmcjMwMF9pbml0LAogCS5maW5pID0gJnIz
MDBfZmluaSwKQEAgLTc0NCw3ICs3NTgsNyBAQCBzdGF0aWMgc3RydWN0IHJhZGVvbl9hc2ljIHJ2
NTE1X2FzaWMgPSB7CiAJCS5zZXRfcGFnZSA9ICZydjM3MF9wY2llX2dhcnRfc2V0X3BhZ2UsCiAJ
fSwKIAkucmluZyA9IHsKLQkJW1JBREVPTl9SSU5HX1RZUEVfR0ZYX0lOREVYXSA9ICZyMzAwX2dm
eF9yaW5nCisJCVtSQURFT05fUklOR19UWVBFX0dGWF9JTkRFWF0gPSAmcnY1MTVfZ2Z4X3JpbmcK
IAl9LAogCS5pcnEgPSB7CiAJCS5zZXQgPSAmcnM2MDBfaXJxX3NldCwKQEAgLTgxMCw3ICs4MjQs
NyBAQCBzdGF0aWMgc3RydWN0IHJhZGVvbl9hc2ljIHI1MjBfYXNpYyA9IHsKIAkJLnNldF9wYWdl
ID0gJnJ2MzcwX3BjaWVfZ2FydF9zZXRfcGFnZSwKIAl9LAogCS5yaW5nID0gewotCQlbUkFERU9O
X1JJTkdfVFlQRV9HRlhfSU5ERVhdID0gJnIzMDBfZ2Z4X3JpbmcKKwkJW1JBREVPTl9SSU5HX1RZ
UEVfR0ZYX0lOREVYXSA9ICZydjUxNV9nZnhfcmluZwogCX0sCiAJLmlycSA9IHsKIAkJLnNldCA9
ICZyczYwMF9pcnFfc2V0LAotLSAKMS44LjMuMQoK
--001a11c119b4bc3083050cb2e78d--
