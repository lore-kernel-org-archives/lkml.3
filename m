Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205Ab3ANQIL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 11:08:11 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:57745 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756574Ab3ANQIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 11:08:10 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1301132143310.1772@xoschi>
References: <alpine.LNX.2.00.1301061336180.1397@xoschi>
	<CADnq5_O1GDuigxwR8eXu7f1Fsb8iqrggVwYBaiOJKOR-ighYag@mail.gmail.com>
	<alpine.LNX.2.00.1301072206530.1617@xoschi>
	<CADnq5_NEQ2cCEPEGwBhX1KP0bDn7b+Q2M=Logw1fVC67ct-gEA@mail.gmail.com>
	<alpine.LNX.2.00.1301132143310.1772@xoschi>
Date: Mon, 14 Jan 2013 11:08:07 -0500
Message-ID: <CADnq5_N+pHZ5ugCDp7EfdW7yZ-ABS3M-vk_xtUFmnqDzz9sBvg@mail.gmail.com>
Subject: Re: Regression: drm/radeon: brightness control hard system lockup
From: Alex Deucher <alexdeucher@gmail.com>
To: Eldad Zack <eldad@fogrefinery.com>
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: multipart/mixed; boundary=bcaec5016241d8fcc004d341d9b6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec5016241d8fcc004d341d9b6
Content-Type: text/plain; charset=ISO-8859-1

On Sun, Jan 13, 2013 at 4:00 PM, Eldad Zack <eldad@fogrefinery.com> wrote:
>
> On Mon, 7 Jan 2013, Alex Deucher wrote:
>> On Mon, Jan 7, 2013 at 4:33 PM, Eldad Zack <eldad@fogrefinery.com> wrote:
>> >
>> > On Mon, 7 Jan 2013, Alex Deucher wrote:
>> >> On Sun, Jan 6, 2013 at 7:59 AM, Eldad Zack <eldad@fogrefinery.com> wrote:
>> >> >
>> >> > Hi Alex,
>> >> >
>> >> > Commit 0ecebb9e0d14e9948e0b1529883a776758117d6f "drm/radeon: switch to a
>> >> > finer grained reset for evergreen" introduced a hard system lockup to my
>> >> > setup. I found it after bisecting, and confirmed it by reverting it on
>> >> > the latest mainline ( 5f243b9 ).
>> >> >
>> >> > This:
>> >> >
>> >> >    echo 7 > /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/backlight/acpi_video0/brightness
>> >> >
>> >> > Causes a hard lock-up hard, i.e. immediate freeze, without any logs.
>> >> >
>> >> > See lspci output and kernel .config below.
>> >> > If there's any more info I can provide, please let me know.
>> >>
>> >> Do you normally see GPU resets when changing the backlight?  Please
>> >> attach your dmesg output when changing the backlight with the patch
>> >> reverted.
>> >
>> > I see nothing. Just to make sure, I cleared the buffer, cycled through
>> > 0-7 a couple of hunderd times (until the flicker annoyed), but I see no
>> > messages at all.
>> > Is there any debug config I should turn on?
>>
>> Can you try adding a printk() in evergreen_asic_reset() and see if it
>> is somehow getting called when you change the brightness?  When you
>> use the apci backlight control, the radeon driver is not involved at
>> all.  They only way the driver would get involved is if the acpi
>> backlight control somehow caused the GPU to hang and then the driver
>> detected the hang and attempted to reset the GPU.  I don't see any
>> evidence of a GPU reset in your kernel log however.  Note that the
>> driver also registers native backlight contol.  Does that work any
>> better than acpi?
>
> The native backlight controls work very well. Thanks for that, I didn't
> even noticed that. It has finer control over brightness too.
>
> I worked out a fix for the problem, but I think it's not a proper one.
> What I noticed is that evergreen_gpu_soft_reset() is only ever called
> once on my system, at boot.
> Then I realized from the dmesg that neither
> evergreen_gpu_soft_reset_dma() nor evergreen_gpu_soft_reset_gfx() actually
> do anything. Both return on the first if statements there.
>
> So as far as I can tell, the difference your patch introduced is calling
> evergreen_mc_stop() and evergreen_mc_resume(), which somehow puts my
> system in some state that ACPI brightness control leads to a lock up.
>
> BTW, I don't see a GPU reset happening at all - I also tried suspend/resume
> and starting an OpenGL application. Do you know how I can trigger it?
>
> To fix this, I moved the GUI_ACTIVE test before evergreen_mc_stop(), but
> I think it just masks the issue.
> Patch below (against latest HEAD) just in case.
>

Thanks for tracking this down.  The attached patch should fix the
issue properly.

Alex

> Cheers,
> Eldad
>
> From 5817128d2761f60051b069d2bb31209c909b6a04 Mon Sep 17 00:00:00 2001
> From: Eldad Zack <eldad@fogrefinery.com>
> Date: Sun, 13 Jan 2013 21:14:08 +0100
> Subject: [PATCH] drm/radeon: fix evergreen brightness control regression
>
> Commit 0ecebb9e0d14e9948e0b1529883a776758117d6f introduced a
> regression, where using ACPI brightness control leads to a
> hard system lock-up.
> To resolve the issue, this patch moves the GUI_ACTIVE test
> earlier, as it was before the commit.
>
> Signed-off-by: Eldad Zack <eldad@fogrefinery.com>
> ---
>  drivers/gpu/drm/radeon/evergreen.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
> index 061fa0a..1392f99 100644
> --- a/drivers/gpu/drm/radeon/evergreen.c
> +++ b/drivers/gpu/drm/radeon/evergreen.c
> @@ -2310,9 +2310,6 @@ static void evergreen_gpu_soft_reset_gfx(struct radeon_device *rdev)
>  {
>         u32 grbm_reset = 0;
>
> -       if (!(RREG32(GRBM_STATUS) & GUI_ACTIVE))
> -               return;
> -
>         dev_info(rdev->dev, "  GRBM_STATUS               = 0x%08X\n",
>                 RREG32(GRBM_STATUS));
>         dev_info(rdev->dev, "  GRBM_STATUS_SE0           = 0x%08X\n",
> @@ -2404,6 +2401,9 @@ static int evergreen_gpu_soft_reset(struct radeon_device *rdev, u32 reset_mask)
>         if (reset_mask == 0)
>                 return 0;
>
> +       if (!(RREG32(GRBM_STATUS) & GUI_ACTIVE))
> +               return 0;
> +
>         dev_info(rdev->dev, "GPU softreset: 0x%08X\n", reset_mask);
>
>         evergreen_mc_stop(rdev, &save);
> --
> 1.7.12.4
>

--bcaec5016241d8fcc004d341d9b6
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-drm-radeon-clear-reset-flags-if-engines-are-idle.patch"
Content-Disposition: attachment; 
	filename="0001-drm-radeon-clear-reset-flags-if-engines-are-idle.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hbxt35jn0

RnJvbSBjYjUyMDZhYTFjNmM1MmIxYjQ1OWVhZjkzNzk3YzU5M2NmZjBjOGRiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4IERldWNoZXIgPGFsZXhhbmRlci5kZXVjaGVyQGFtZC5j
b20+CkRhdGU6IE1vbiwgMTQgSmFuIDIwMTMgMTE6MDQ6MzkgLTA1MDAKU3ViamVjdDogW1BBVENI
XSBkcm0vcmFkZW9uOiBjbGVhciByZXNldCBmbGFncyBpZiBlbmdpbmVzIGFyZSBpZGxlCgpGaXhl
cyBhIHJlZ3Jlc3Npb24gaW4gdGhlIGdwdSByZXNldCBjb2RlIGFmdGVyIHRoZQpyZXdvcmsgZm9y
IERNQSBzdXBwb3J0LgoKUmVwb3J0ZWQtYnk6IEVsZGFkIFphY2sgPGVsZGFkQGZvZ3JlZmluZXJ5
LmNvbT4KU2lnbmVkLW9mZi1ieTogQWxleCBEZXVjaGVyIDxhbGV4YW5kZXIuZGV1Y2hlckBhbWQu
Y29tPgotLS0KIGRyaXZlcnMvZ3B1L2RybS9yYWRlb24vZXZlcmdyZWVuLmMgfCAgICA2ICsrKysr
KwogZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9uaS5jICAgICAgICB8ICAgIDYgKysrKysrCiBkcml2
ZXJzL2dwdS9kcm0vcmFkZW9uL3I2MDAuYyAgICAgIHwgICAgNiArKysrKysKIGRyaXZlcnMvZ3B1
L2RybS9yYWRlb24vc2kuYyAgICAgICAgfCAgICA2ICsrKysrKwogNCBmaWxlcyBjaGFuZ2VkLCAy
NCBpbnNlcnRpb25zKCspLCAwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1
L2RybS9yYWRlb24vZXZlcmdyZWVuLmMgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL2V2ZXJncmVl
bi5jCmluZGV4IDA2MWZhMGEuLjRkMGU2MGEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvZ3B1L2RybS9y
YWRlb24vZXZlcmdyZWVuLmMKKysrIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9ldmVyZ3JlZW4u
YwpAQCAtMjQwMSw2ICsyNDAxLDEyIEBAIHN0YXRpYyBpbnQgZXZlcmdyZWVuX2dwdV9zb2Z0X3Jl
c2V0KHN0cnVjdCByYWRlb25fZGV2aWNlICpyZGV2LCB1MzIgcmVzZXRfbWFzaykKIHsKIAlzdHJ1
Y3QgZXZlcmdyZWVuX21jX3NhdmUgc2F2ZTsKIAorCWlmICghKFJSRUczMihHUkJNX1NUQVRVUykg
JiBHVUlfQUNUSVZFKSkKKwkJcmVzZXRfbWFzayAmPSB+KFJBREVPTl9SRVNFVF9HRlggfCBSQURF
T05fUkVTRVRfQ09NUFVURSk7CisKKwlpZiAoUlJFRzMyKERNQV9TVEFUVVNfUkVHKSAmIERNQV9J
RExFKQorCQlyZXNldF9tYXNrICY9IH5SQURFT05fUkVTRVRfRE1BOworCiAJaWYgKHJlc2V0X21h
c2sgPT0gMCkKIAkJcmV0dXJuIDA7CiAKZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9yYWRl
b24vbmkuYyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vbmkuYwppbmRleCA4OTZmMWNiLi41OWFj
YWJiIDEwMDY0NAotLS0gYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL25pLmMKKysrIGIvZHJpdmVy
cy9ncHUvZHJtL3JhZGVvbi9uaS5jCkBAIC0xNDA5LDYgKzE0MDksMTIgQEAgc3RhdGljIGludCBj
YXltYW5fZ3B1X3NvZnRfcmVzZXQoc3RydWN0IHJhZGVvbl9kZXZpY2UgKnJkZXYsIHUzMiByZXNl
dF9tYXNrKQogewogCXN0cnVjdCBldmVyZ3JlZW5fbWNfc2F2ZSBzYXZlOwogCisJaWYgKCEoUlJF
RzMyKEdSQk1fU1RBVFVTKSAmIEdVSV9BQ1RJVkUpKQorCQlyZXNldF9tYXNrICY9IH4oUkFERU9O
X1JFU0VUX0dGWCB8IFJBREVPTl9SRVNFVF9DT01QVVRFKTsKKworCWlmIChSUkVHMzIoRE1BX1NU
QVRVU19SRUcpICYgRE1BX0lETEUpCisJCXJlc2V0X21hc2sgJj0gflJBREVPTl9SRVNFVF9ETUE7
CisKIAlpZiAocmVzZXRfbWFzayA9PSAwKQogCQlyZXR1cm4gMDsKIApkaWZmIC0tZ2l0IGEvZHJp
dmVycy9ncHUvZHJtL3JhZGVvbi9yNjAwLmMgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3I2MDAu
YwppbmRleCA1MzdlMjU5Li4zY2I5ZDYwIDEwMDY0NAotLS0gYS9kcml2ZXJzL2dwdS9kcm0vcmFk
ZW9uL3I2MDAuYworKysgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3I2MDAuYwpAQCAtMTM3OCw2
ICsxMzc4LDEyIEBAIHN0YXRpYyBpbnQgcjYwMF9ncHVfc29mdF9yZXNldChzdHJ1Y3QgcmFkZW9u
X2RldmljZSAqcmRldiwgdTMyIHJlc2V0X21hc2spCiB7CiAJc3RydWN0IHJ2NTE1X21jX3NhdmUg
c2F2ZTsKIAorCWlmICghKFJSRUczMihHUkJNX1NUQVRVUykgJiBHVUlfQUNUSVZFKSkKKwkJcmVz
ZXRfbWFzayAmPSB+KFJBREVPTl9SRVNFVF9HRlggfCBSQURFT05fUkVTRVRfQ09NUFVURSk7CisK
KwlpZiAoUlJFRzMyKERNQV9TVEFUVVNfUkVHKSAmIERNQV9JRExFKQorCQlyZXNldF9tYXNrICY9
IH5SQURFT05fUkVTRVRfRE1BOworCiAJaWYgKHJlc2V0X21hc2sgPT0gMCkKIAkJcmV0dXJuIDA7
CiAKZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vc2kuYyBiL2RyaXZlcnMvZ3B1
L2RybS9yYWRlb24vc2kuYwppbmRleCAzMjQwYTNkLi5hZThiNDgyIDEwMDY0NAotLS0gYS9kcml2
ZXJzL2dwdS9kcm0vcmFkZW9uL3NpLmMKKysrIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9zaS5j
CkBAIC0yMjE1LDYgKzIyMTUsMTIgQEAgc3RhdGljIGludCBzaV9ncHVfc29mdF9yZXNldChzdHJ1
Y3QgcmFkZW9uX2RldmljZSAqcmRldiwgdTMyIHJlc2V0X21hc2spCiB7CiAJc3RydWN0IGV2ZXJn
cmVlbl9tY19zYXZlIHNhdmU7CiAKKwlpZiAoIShSUkVHMzIoR1JCTV9TVEFUVVMpICYgR1VJX0FD
VElWRSkpCisJCXJlc2V0X21hc2sgJj0gfihSQURFT05fUkVTRVRfR0ZYIHwgUkFERU9OX1JFU0VU
X0NPTVBVVEUpOworCisJaWYgKFJSRUczMihETUFfU1RBVFVTX1JFRykgJiBETUFfSURMRSkKKwkJ
cmVzZXRfbWFzayAmPSB+UkFERU9OX1JFU0VUX0RNQTsKKwogCWlmIChyZXNldF9tYXNrID09IDAp
CiAJCXJldHVybiAwOwogCi0tIAoxLjcuNy41Cgo=
--bcaec5016241d8fcc004d341d9b6--
