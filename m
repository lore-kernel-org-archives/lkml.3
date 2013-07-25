Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663Ab3GYRzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 13:55:41 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:53249 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756456Ab3GYRz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:55:29 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUUpnQ_=bTtK-0-qG90GjV38oeVe2E1v-KdLZQFQWH21GQ@mail.gmail.com>
References: <CA+icZUWxvBR6NX8JnqM1+4yVNfQ8ew5_7UCQ6yVpz8B4UibW7A@mail.gmail.com>
	<20130725142705.GM5939@phenom.ffwll.local>
	<CA+icZUU3+egkAVtSVEiOaqWK+7EFi572jGv2jUt=QDuGjbfZOw@mail.gmail.com>
	<CAKMK7uG-KCF5oU2XJ5UWPJn=V3i0jBLs5a=gU9UPuJxY0v=bNw@mail.gmail.com>
	<CA+icZUV-UM_9OSfGfYyb0-qZrFSuqeX-7BiPQ0NbyF7bADW-qA@mail.gmail.com>
	<CA+icZUWJDp6XQZs8hojVJOVyjC8NeV7QoQeFopNoUgwCaYHnSQ@mail.gmail.com>
	<20130725163150.GD6493@cantiga.alporthouse.com>
	<CA+icZUWmpZK0jO_G1ec446WftzXDvSdnHLcQrkmBSHA7fSAqcw@mail.gmail.com>
	<20130725170144.GE6493@cantiga.alporthouse.com>
	<CA+icZUUOmoFY3JDZOYmiP3dV9KAR_8WYfEDQhaynKmhXCLpF9w@mail.gmail.com>
	<20130725172616.GA11514@cantiga.alporthouse.com>
	<CA+icZUUpnQ_=bTtK-0-qG90GjV38oeVe2E1v-KdLZQFQWH21GQ@mail.gmail.com>
Date: Thu, 25 Jul 2013 19:55:27 +0200
Message-ID: <CA+icZUXz+6MgbW952fU_da1-RfX8CSZp76gJnOwGDNsd-rdebA@mail.gmail.com>
Subject: Re: [Intel-gfx] linux-next: Tree for Jul 25 [ call-trace: drm |
 drm-intel related? ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        linux-next <linux-next@vger.kernel.org>
Content-Type: multipart/mixed; boundary=e89a8f23532330bd9804e259bb4c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8f23532330bd9804e259bb4c
Content-Type: text/plain; charset=UTF-8

On Thu, Jul 25, 2013 at 7:52 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Thu, Jul 25, 2013 at 7:26 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>> On Thu, Jul 25, 2013 at 07:15:03PM +0200, Sedat Dilek wrote:
>>> On Thu, Jul 25, 2013 at 7:01 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>>> > Basically boils down to either an object allocation failure or mmaping
>>> > failure. I think dmesg with drm.debug=7 is the next step.
>>>
>>> Attached! Thanks for taking care.
>>
>> Hmm, looks like i915_gem_map_gtt fails, but no reason given, so can you
>> please apply this for more debug:
>>
>> diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
>> index 0563661..34e09bf 100644
>> --- a/drivers/gpu/drm/i915/i915_gem.c
>> +++ b/drivers/gpu/drm/i915/i915_gem.c
>> @@ -1630,24 +1630,29 @@ i915_gem_mmap_gtt(struct drm_file *file,
>>
>>         obj = to_intel_bo(drm_gem_object_lookup(dev, file, handle));
>>         if (&obj->base == NULL) {
>> +               DRM_DRIVER_DEBUG("Unknown object handle %d\n", handle);
>>                 ret = -ENOENT;
>>                 goto unlock;
>>         }
>>
>>         if (obj->base.size > dev_priv->gtt.mappable_end) {
>> +               DRM_DRIVER_DEBUG("Object (%d) larger than mappable aperture (%d) > %d\n",
>> +                               (int)obj->base.size, (int)dev_priv->gtt.mappable_end);
>>                 ret = -E2BIG;
>>                 goto out;
>>         }
>>
>>         if (obj->madv != I915_MADV_WILLNEED) {
>> -               DRM_ERROR("Attempting to mmap a purgeable buffer\n");
>> +               DRM_DRIVER_DEBUG("Attempting to mmap a purgeable buffer\n");
>>                 ret = -EINVAL;
>>                 goto out;
>>         }
>>
>>         ret = i915_gem_object_create_mmap_offset(obj);
>> -       if (ret)
>> +       if (ret) {
>> +               DRM_DRIVER_DEBUG("Failed to allocate mmap offset (ret=%d)\n", ret);
>>                 goto out;
>> +       }
>>
>>         *offset = (u64)obj->base.map_list.hash.key << PAGE_SHIFT;
>>
>> --
>
> This does not apply... After refreshing and some cleanups... does not build:
>
> $ LANG=C LC_ALL=C make M=drivers/gpu/drm/i915
>   LD      drivers/gpu/drm/i915/built-in.o
>   CC [M]  drivers/gpu/drm/i915/i915_drv.o
>   CC [M]  drivers/gpu/drm/i915/i915_dma.o
>   CC [M]  drivers/gpu/drm/i915/i915_irq.o
>   CC [M]  drivers/gpu/drm/i915/i915_debugfs.o
>   CC [M]  drivers/gpu/drm/i915/i915_gpu_error.o
>   CC [M]  drivers/gpu/drm/i915/i915_suspend.o
>   CC [M]  drivers/gpu/drm/i915/i915_gem.o
> drivers/gpu/drm/i915/i915_gem.c: In function 'i915_gem_mmap_gtt':
> drivers/gpu/drm/i915/i915_gem.c:1538:3: error: implicit declaration of
> function 'DRM_DRIVER_DEBUG' [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> make[1]: *** [drivers/gpu/drm/i915/i915_gem.o] Error 1
> make: *** [_module_drivers/gpu/drm/i915] Error 2
>

F*ck. Wrong patch refreshed.

- S.

> - Sedat -
>
>> Chris Wilson, Intel Open Source Technology Centre
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-next" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--e89a8f23532330bd9804e259bb4c
Content-Type: application/octet-stream; 
	name="0001-i915-Debug-test-patch-to-see-why-i915_gem_map_gtt-fa.patch"
Content-Disposition: attachment; 
	filename="0001-i915-Debug-test-patch-to-see-why-i915_gem_map_gtt-fa.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hjk9hsaj1

RnJvbSA3ZGM0YjUwMTczMjg4OGNjOTE2YWQ0ZWZmYTNhMWI2YmRkMmY0MzU4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBDaHJpcyBXaWxzb24gPGNocmlzQGNocmlzLXdpbHNvbi5jby51
az4KRGF0ZTogVGh1LCAyNSBKdWwgMjAxMyAxOTo0MDo1OCArMDIwMApTdWJqZWN0OiBbUEFUQ0hd
IGk5MTU6IERlYnVnIHRlc3QgcGF0Y2ggdG8gc2VlIHdoeSBpOTE1X2dlbV9tYXBfZ3R0IGZhaWxz
CgpbIGRpbGVrczogdjI6CiAgKiBBZGFwdCB0byBmaXQgZHJtLWludGVsLW5pZ2h0bHkgcHVsbGVk
IGludG8gbmV4dC0yMDEzMDcyNQogICogcy9EUk1fRFJJVkVSX0RFQlVHL0RSTV9ERUJVR19EUklW
RVIgXQoKU2lnbmVkLW9mZi1ieTogQ2hyaXMgV2lsc29uIDxjaHJpc0BjaHJpcy13aWxzb24uY28u
dWs+Ci0tLQogZHJpdmVycy9ncHUvZHJtL2k5MTUvaTkxNV9nZW0uYyB8IDkgKysrKysrKy0tCiAx
IGZpbGUgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdp
dCBhL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2k5MTVfZ2VtLmMgYi9kcml2ZXJzL2dwdS9kcm0vaTkx
NS9pOTE1X2dlbS5jCmluZGV4IDM0MGQ1NDcuLmVmYjM2NGUgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMv
Z3B1L2RybS9pOTE1L2k5MTVfZ2VtLmMKKysrIGIvZHJpdmVycy9ncHUvZHJtL2k5MTUvaTkxNV9n
ZW0uYwpAQCAtMTUzNSwyNCArMTUzNSwyOSBAQCBpOTE1X2dlbV9tbWFwX2d0dChzdHJ1Y3QgZHJt
X2ZpbGUgKmZpbGUsCiAKIAlvYmogPSB0b19pbnRlbF9ibyhkcm1fZ2VtX29iamVjdF9sb29rdXAo
ZGV2LCBmaWxlLCBoYW5kbGUpKTsKIAlpZiAoJm9iai0+YmFzZSA9PSBOVUxMKSB7CisJCURSTV9E
RUJVR19EUklWRVIoIlVua25vd24gb2JqZWN0IGhhbmRsZSAlZFxuIiwgaGFuZGxlKTsKIAkJcmV0
ID0gLUVOT0VOVDsKIAkJZ290byB1bmxvY2s7CiAJfQogCiAJaWYgKG9iai0+YmFzZS5zaXplID4g
ZGV2X3ByaXYtPmd0dC5tYXBwYWJsZV9lbmQpIHsKKwkJRFJNX0RFQlVHX0RSSVZFUigiT2JqZWN0
ICglZCkgbGFyZ2VyIHRoYW4gbWFwcGFibGUgYXBlcnR1cmUgKCVkKSA+ICVkXG4iLAorCQkJCShp
bnQpb2JqLT5iYXNlLnNpemUsIChpbnQpZGV2X3ByaXYtPmd0dC5tYXBwYWJsZV9lbmQpOwogCQly
ZXQgPSAtRTJCSUc7CiAJCWdvdG8gb3V0OwogCX0KIAogCWlmIChvYmotPm1hZHYgIT0gSTkxNV9N
QURWX1dJTExORUVEKSB7Ci0JCURSTV9FUlJPUigiQXR0ZW1wdGluZyB0byBtbWFwIGEgcHVyZ2Vh
YmxlIGJ1ZmZlclxuIik7CisJCURSTV9ERUJVR19EUklWRVIoIkF0dGVtcHRpbmcgdG8gbW1hcCBh
IHB1cmdlYWJsZSBidWZmZXJcbiIpOwogCQlyZXQgPSAtRUlOVkFMOwogCQlnb3RvIG91dDsKIAl9
CiAKIAlyZXQgPSBpOTE1X2dlbV9vYmplY3RfY3JlYXRlX21tYXBfb2Zmc2V0KG9iaik7Ci0JaWYg
KHJldCkKKwlpZiAocmV0KSB7CisJCURSTV9ERUJVR19EUklWRVIoIkZhaWxlZCB0byBhbGxvY2F0
ZSBtbWFwIG9mZnNldCAocmV0PSVkKVxuIiwgcmV0KTsKIAkJZ290byBvdXQ7CisJfQogCiAJKm9m
ZnNldCA9IGRybV92bWFfbm9kZV9vZmZzZXRfYWRkcigmb2JqLT5iYXNlLnZtYV9ub2RlKTsKIAot
LSAKMS44LjMuNAoK
--e89a8f23532330bd9804e259bb4c--
