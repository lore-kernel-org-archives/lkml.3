Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159Ab3GYRwe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 13:52:34 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:51774 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757041Ab3GYRwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:52:24 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20130725172616.GA11514@cantiga.alporthouse.com>
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
Date: Thu, 25 Jul 2013 19:52:22 +0200
Message-ID: <CA+icZUUpnQ_=bTtK-0-qG90GjV38oeVe2E1v-KdLZQFQWH21GQ@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary=e89a8f2353233149c204e259b00c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8f2353233149c204e259b00c
Content-Type: text/plain; charset=UTF-8

On Thu, Jul 25, 2013 at 7:26 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Thu, Jul 25, 2013 at 07:15:03PM +0200, Sedat Dilek wrote:
>> On Thu, Jul 25, 2013 at 7:01 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>> > Basically boils down to either an object allocation failure or mmaping
>> > failure. I think dmesg with drm.debug=7 is the next step.
>>
>> Attached! Thanks for taking care.
>
> Hmm, looks like i915_gem_map_gtt fails, but no reason given, so can you
> please apply this for more debug:
>
> diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
> index 0563661..34e09bf 100644
> --- a/drivers/gpu/drm/i915/i915_gem.c
> +++ b/drivers/gpu/drm/i915/i915_gem.c
> @@ -1630,24 +1630,29 @@ i915_gem_mmap_gtt(struct drm_file *file,
>
>         obj = to_intel_bo(drm_gem_object_lookup(dev, file, handle));
>         if (&obj->base == NULL) {
> +               DRM_DRIVER_DEBUG("Unknown object handle %d\n", handle);
>                 ret = -ENOENT;
>                 goto unlock;
>         }
>
>         if (obj->base.size > dev_priv->gtt.mappable_end) {
> +               DRM_DRIVER_DEBUG("Object (%d) larger than mappable aperture (%d) > %d\n",
> +                               (int)obj->base.size, (int)dev_priv->gtt.mappable_end);
>                 ret = -E2BIG;
>                 goto out;
>         }
>
>         if (obj->madv != I915_MADV_WILLNEED) {
> -               DRM_ERROR("Attempting to mmap a purgeable buffer\n");
> +               DRM_DRIVER_DEBUG("Attempting to mmap a purgeable buffer\n");
>                 ret = -EINVAL;
>                 goto out;
>         }
>
>         ret = i915_gem_object_create_mmap_offset(obj);
> -       if (ret)
> +       if (ret) {
> +               DRM_DRIVER_DEBUG("Failed to allocate mmap offset (ret=%d)\n", ret);
>                 goto out;
> +       }
>
>         *offset = (u64)obj->base.map_list.hash.key << PAGE_SHIFT;
>
> --

This does not apply... After refreshing and some cleanups... does not build:

$ LANG=C LC_ALL=C make M=drivers/gpu/drm/i915
  LD      drivers/gpu/drm/i915/built-in.o
  CC [M]  drivers/gpu/drm/i915/i915_drv.o
  CC [M]  drivers/gpu/drm/i915/i915_dma.o
  CC [M]  drivers/gpu/drm/i915/i915_irq.o
  CC [M]  drivers/gpu/drm/i915/i915_debugfs.o
  CC [M]  drivers/gpu/drm/i915/i915_gpu_error.o
  CC [M]  drivers/gpu/drm/i915/i915_suspend.o
  CC [M]  drivers/gpu/drm/i915/i915_gem.o
drivers/gpu/drm/i915/i915_gem.c: In function 'i915_gem_mmap_gtt':
drivers/gpu/drm/i915/i915_gem.c:1538:3: error: implicit declaration of
function 'DRM_DRIVER_DEBUG' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[1]: *** [drivers/gpu/drm/i915/i915_gem.o] Error 1
make: *** [_module_drivers/gpu/drm/i915] Error 2

- Sedat -

> Chris Wilson, Intel Open Source Technology Centre
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--e89a8f2353233149c204e259b00c
Content-Type: application/octet-stream; name="1-v2.patch"
Content-Disposition: attachment; filename="1-v2.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hjk9czpj0

RnJvbTogQ2hyaXMgV2lsc29uIDxjaHJpc0BjaHJpcy13aWxzb24uY28udWs+CgpTdWJqZWN0OiBp
OTE1OiBEZWJ1ZyB0ZXN0IHBhdGNoIHRvIHNlZSB3aHkgaTkxNV9nZW1fbWFwX2d0dCBmYWlscwoK
WyBkaWxla3M6IHYyOiBBZGFwdCB0byBmaXQgZHJtLWludGVsLW5pZ2h0bHkgcHVsbGVkIGludG8g
bmV4dC0yMDEzMDcyNS4gXQoKU2lnbmVkLW9mZi1ieTogQ2hyaXMgV2lsc29uIDxjaHJpc0BjaHJp
cy13aWxzb24uY28udWs+CgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL2k5MTUvaTkxNV9n
ZW0uYyBiL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2k5MTVfZ2VtLmMKaW5kZXggMzQwZDU0Ny4uZWZi
MzY0ZSAxMDA2NDQKLS0tIGEvZHJpdmVycy9ncHUvZHJtL2k5MTUvaTkxNV9nZW0uYworKysgYi9k
cml2ZXJzL2dwdS9kcm0vaTkxNS9pOTE1X2dlbS5jCkBAIC0xNTM1LDI0ICsxNTM1LDI5IEBAIGk5
MTVfZ2VtX21tYXBfZ3R0KHN0cnVjdCBkcm1fZmlsZSAqZmlsZSwKIAogCW9iaiA9IHRvX2ludGVs
X2JvKGRybV9nZW1fb2JqZWN0X2xvb2t1cChkZXYsIGZpbGUsIGhhbmRsZSkpOwogCWlmICgmb2Jq
LT5iYXNlID09IE5VTEwpIHsKKwkJRFJNX0RSSVZFUl9ERUJVRygiVW5rbm93biBvYmplY3QgaGFu
ZGxlICVkXG4iLCBoYW5kbGUpOwogCQlyZXQgPSAtRU5PRU5UOwogCQlnb3RvIHVubG9jazsKIAl9
CiAKIAlpZiAob2JqLT5iYXNlLnNpemUgPiBkZXZfcHJpdi0+Z3R0Lm1hcHBhYmxlX2VuZCkgewor
CQlEUk1fRFJJVkVSX0RFQlVHKCJPYmplY3QgKCVkKSBsYXJnZXIgdGhhbiBtYXBwYWJsZSBhcGVy
dHVyZSAoJWQpID4gJWRcbiIsCisJCQkJKGludClvYmotPmJhc2Uuc2l6ZSwgKGludClkZXZfcHJp
di0+Z3R0Lm1hcHBhYmxlX2VuZCk7CiAJCXJldCA9IC1FMkJJRzsKIAkJZ290byBvdXQ7CiAJfQog
CiAJaWYgKG9iai0+bWFkdiAhPSBJOTE1X01BRFZfV0lMTE5FRUQpIHsKLQkJRFJNX0VSUk9SKCJB
dHRlbXB0aW5nIHRvIG1tYXAgYSBwdXJnZWFibGUgYnVmZmVyXG4iKTsKKwkJRFJNX0RSSVZFUl9E
RUJVRygiQXR0ZW1wdGluZyB0byBtbWFwIGEgcHVyZ2VhYmxlIGJ1ZmZlclxuIik7CiAJCXJldCA9
IC1FSU5WQUw7CiAJCWdvdG8gb3V0OwogCX0KIAogCXJldCA9IGk5MTVfZ2VtX29iamVjdF9jcmVh
dGVfbW1hcF9vZmZzZXQob2JqKTsKLQlpZiAocmV0KQorCWlmIChyZXQpIHsKKwkJRFJNX0RSSVZF
Ul9ERUJVRygiRmFpbGVkIHRvIGFsbG9jYXRlIG1tYXAgb2Zmc2V0IChyZXQ9JWQpXG4iLCByZXQp
OwogCQlnb3RvIG91dDsKKwl9CiAKIAkqb2Zmc2V0ID0gZHJtX3ZtYV9ub2RlX29mZnNldF9hZGRy
KCZvYmotPmJhc2Uudm1hX25vZGUpOwogCg==
--e89a8f2353233149c204e259b00c--
