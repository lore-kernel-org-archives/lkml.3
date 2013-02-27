Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620Ab3B0DaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 22:30:11 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:46436 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab3B0DaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 22:30:09 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFzRRxTjuQcLhkhfxDWpHEg3EoSY8CMP+v78i+_Z-EkQ1g@mail.gmail.com>
References: <alpine.DEB.2.00.1302260003460.24684@skynet.skynet.ie>
	<CA+55aFzRRxTjuQcLhkhfxDWpHEg3EoSY8CMP+v78i+_Z-EkQ1g@mail.gmail.com>
Date: Wed, 27 Feb 2013 13:30:07 +1000
Message-ID: <CAPM=9ty2_8TM8Y_5x-iE8aio1NCvmJMB7bmip3rcsrtK-0iR+Q@mail.gmail.com>
Subject: Re: [git pull] drm merge for 3.9-rc1
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Imre Deak <imre.deak@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: multipart/mixed; boundary=e0cb4efe342e0bf55704d6ac648a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e0cb4efe342e0bf55704d6ac648a
Content-Type: text/plain; charset=ISO-8859-1

On Wed, Feb 27, 2013 at 11:39 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Feb 25, 2013 at 4:05 PM, Dave Airlie <airlied@linux.ie> wrote:
>>
>> Highlights:
>>
>> i915: all over the map, haswell power well enhancements, valleyview macro horrors cleaned up, killing lots of legacy GTT
>> code,
>
> Lowlight:
>
> There's something wrong with i915 DP detection or whatever. I get
> stuff like this:
>
> [    5.710827] [drm:intel_dp_aux_wait_done] *ERROR* dp aux hw did not
> signal timeout (has irq: 1)!
> [    5.720810] [drm:intel_dp_aux_wait_done] *ERROR* dp aux hw did not
> signal timeout (has irq: 1)!
> [    5.730794] [drm:intel_dp_aux_wait_done] *ERROR* dp aux hw did not
> signal timeout (has irq: 1)!
> [    5.740782] [drm:intel_dp_aux_wait_done] *ERROR* dp aux hw did not
> signal timeout (has irq: 1)!
> [    5.750775] [drm:intel_dp_aux_wait_done] *ERROR* dp aux hw did not
> signal timeout (has irq: 1)!
> [    5.750778] [drm:intel_dp_aux_ch] *ERROR* dp_aux_ch not done status
> 0xa145003f
> .....
> [    8.149931] [drm:intel_dp_aux_ch] *ERROR* dp_aux_ch not done status
> 0xa145003f
>
> and after that the screen ends up black.
>
> It's happened twice now, but is not 100% repeatable. It looks like the
> message itself is new,  but the black screen is also new and does seem
> to happen when I get the message, so...
>
> The second time I touched the power button, and the machine came back.
> Apparently the suspend/resume cycle made it all magically work: the
> suspend caused the same errors, but then the resume made it all good
> again.
>
> Some kind of missed initialization at bootup? It's not reliable enough
> to bisect, but I obviously suspect commit 9ee32fea5fe8 ("drm/i915:
> irq-drive the dp aux communication") since that is where the message
> was added..
>
> Btw, looking at that commit, what do you think the semantics of the
> timeout in something like
>
>     done = wait_event_timeout(dev_priv->gmbus_wait_queue, C, 10);
>
> would be? What's that magic "10"? It's some totally random number.
>
> Guys, it should be something meaningful. If you meant a tenth of a
> second, use HZ/10 or something. Because just the plain "10" is crazy.
> I happen to have CONFIG_HZ_1000=y, and you're apparently waiting for a
> hundreth of a second. Was that what you intended? Because if it was,
> it is still crap, since CONFIG_HZ might be 100, and then you're
> waiting for ten times longer.

Yeah the looks bogus, Daniel and Imre fail, though I think Daniel is
on holiday this week,
so maybe if you can make it revert, that might be the best option,

If you want to just bump it so Ironlake isn't affected, (patch attached).

Is this external DP monitor or eDP laptop panel btw?

Dave.

--e0cb4efe342e0bf55704d6ac648a
Content-Type: application/octet-stream; 
	name="0001-drm-i915-only-use-irq-for-dp-on-post-ilk.patch"
Content-Disposition: attachment; 
	filename="0001-drm-i915-only-use-irq-for-dp-on-post-ilk.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hdnxeucf0

RnJvbSA1ZDY4YWYxM2Y2NjM4MzNjN2QzMzk0Y2E0ZWNkNTk3ZjRkOGFiYTFjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEYXZlIEFpcmxpZSA8YWlybGllZEBnbWFpbC5jb20+CkRhdGU6
IFdlZCwgMjcgRmViIDIwMTMgMTM6Mjg6MjEgKzEwMDAKU3ViamVjdDogW1BBVENIXSBkcm0vaTkx
NTogb25seSB1c2UgaXJxIGZvciBkcCBvbiBwb3N0LWlsawoKTGludXMgcmVwb3J0cyBoaXMgSUxL
IGlzIGJyb2tlbi4KClNpZ25lZC1vZmYtYnk6IERhdmUgQWlybGllIDxhaXJsaWVkQHJlZGhhdC5j
b20+Ci0tLQogZHJpdmVycy9ncHUvZHJtL2k5MTUvaW50ZWxfZHAuYyB8IDIgKy0KIDEgZmlsZSBj
aGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2RyaXZl
cnMvZ3B1L2RybS9pOTE1L2ludGVsX2RwLmMgYi9kcml2ZXJzL2dwdS9kcm0vaTkxNS9pbnRlbF9k
cC5jCmluZGV4IDMxYzAyMDUuLjAxMjU1M2YgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvZ3B1L2RybS9p
OTE1L2ludGVsX2RwLmMKKysrIGIvZHJpdmVycy9ncHUvZHJtL2k5MTUvaW50ZWxfZHAuYwpAQCAt
Mzc5LDcgKzM3OSw3IEBAIGludGVsX2RwX2F1eF9jaChzdHJ1Y3QgaW50ZWxfZHAgKmludGVsX2Rw
LAogCXVpbnQzMl90IHN0YXR1czsKIAl1aW50MzJfdCBhdXhfY2xvY2tfZGl2aWRlcjsKIAlpbnQg
dHJ5LCBwcmVjaGFyZ2U7Ci0JYm9vbCBoYXNfYXV4X2lycSA9IElOVEVMX0lORk8oZGV2KS0+Z2Vu
ID49IDUgJiYgIUlTX1ZBTExFWVZJRVcoZGV2KTsKKwlib29sIGhhc19hdXhfaXJxID0gSU5URUxf
SU5GTyhkZXYpLT5nZW4gPj0gNiAmJiAhSVNfVkFMTEVZVklFVyhkZXYpOwogCiAJLyogZHAgYXV4
IGlzIGV4dHJlbWVseSBzZW5zaXRpdmUgdG8gaXJxIGxhdGVuY3ksIGhlbmNlIHJlcXVlc3QgdGhl
CiAJICogbG93ZXN0IHBvc3NpYmxlIHdha2V1cCBsYXRlbmN5IGFuZCBzbyBwcmV2ZW50IHRoZSBj
cHUgZnJvbSBnb2luZyBpbnRvCi0tIAoxLjguMQoK
--e0cb4efe342e0bf55704d6ac648a--
