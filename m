Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbaKDN4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 08:56:30 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:46740 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbaKDN4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 08:56:25 -0500
MIME-Version: 1.0
In-Reply-To: <20141016161507.GJ14343@console-pimps.org>
References: <CAGBcZGfHX57jwCfw7CnvLgOJ58kd0KVJULOvhAsfi=3YBp5WsQ@mail.gmail.com>
	<20141013095310.GZ14343@console-pimps.org>
	<CAGBcZGe=HszCxQyx8bBDUEQcF4g+gcMyLfGiM4dVz4=TfxvLpg@mail.gmail.com>
	<CAGBcZGfSdYa2yXW68RbywzCiC7mTxjAdGjUnwnhjWAwXZ0uqiQ@mail.gmail.com>
	<20141016161507.GJ14343@console-pimps.org>
Date: Tue, 4 Nov 2014 15:56:22 +0200
Message-ID: <CAGBcZGf5+OkF1QQOJocVHuSKFgC1+rjiNuSBK3Oo3nBfr5RXdw@mail.gmail.com>
Subject: Re: [PATCH 2/2] efi: Capsule update support
From: Sam Protsenko <semen.protsenko@linaro.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Matt Fleming <matt.fleming@intel.com>,
        Leif Lindholm <leif.lindholm@linaro.org>, hock.leong.kweh@intel.com,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt,

I've tested your patch with zero image size (no image passed, only headers)
and it crashes because there is no check for image size there.
This case (zero image size) seems to be legit according to specification
and also can be useful in real life. So I developed a little fix for your patch:

<<<<<<<<<<<<<<<<<<<<<<< cut here >>>>>>>>>>>>>>>>>>>>>
diff --git a/drivers/firmware/efi/capsule.c b/drivers/firmware/efi/capsule.c
index ca29bad..597b363 100644
--- a/drivers/firmware/efi/capsule.c
+++ b/drivers/firmware/efi/capsule.c
@@ -169,13 +169,17 @@ static int
efi_update_capsule(efi_capsule_header_t *capsule,
                   struct page **pages, size_t size, int reset)
 {
     efi_capsule_block_desc_t *block = NULL;
-    struct page **block_pgs;
+    struct page **block_pgs = NULL;
     efi_status_t status;
-    unsigned int nr_data_pgs, nr_block_pgs;
+    unsigned int nr_data_pgs = 0, nr_block_pgs = 0;
+    unsigned long sg_list = 0;
     int i, j, err = -ENOMEM;

     lockdep_assert_held(&capsule_mutex);

+    if (size == 0)
+        goto update_caps;
+
     nr_data_pgs = DIV_ROUND_UP(size, PAGE_SIZE);
     nr_block_pgs = num_block_pages(nr_data_pgs);

@@ -215,7 +219,10 @@ static int
efi_update_capsule(efi_capsule_header_t *capsule,
         kunmap(block_pgs[i]);
     }

-    status = efi.update_capsule(&capsule, 1, page_to_phys(block_pgs[0]));
+    sg_list = page_to_phys(block_pgs[0]);
+
+update_caps:
+    status = efi.update_capsule(&capsule, 1, sg_list);
     if (status != EFI_SUCCESS) {
         pr_err("update_capsule fail: 0x%lx\n", status);
         err = efi_status_to_err(status);
-- 
2.1.1
<<<<<<<<<<<<<<<<<<<<<<< cut here >>>>>>>>>>>>>>>>>>>>>

I'm planning to use your API for our UpdateCapsule test module so
it would be really helpful if you can include this fix to your patch.


On 16 October 2014 19:15, Matt Fleming <matt@console-pimps.org> wrote:
> On Tue, 14 Oct, at 06:30:22PM, Sam Protsenko wrote:
>> Matt,
>>
>> I tried to play with your code and now I have some extra notes about this patch:
>>
>> 1. As it was proposed earlier, I support thought that it would be nice to
>>    rename function names in next way:
>>
>>      efi_update_capsule -> __efi_update_capsule
>>      efi_capsule_update -> efi_update_capsule
>>
>>    because it's quite confusing to have both efi_update_capsule() and
>>    efi_capsule_update(). Besides, EFI function called UpdateCapsule, so it's
>>    good idea to stick to this name in kernel API (I mean exporting
>>    efi_update_capsule() instead of efi_capsule_update()).
>
> I'm not so convinced by that argument. Remember, we're building a kernel
> API here, so we've got functions like,
>
>   efi_capsule_supported()
>   efi_capsule_pending()
>
> I've stuck with efi_capsule_update() and __efi_capsule_update() for now,
> to continue the efi_capsule* theme (avoiding both efi_capsule_update()
> and efi_update_capsule() was a good point though).
>
>> 2. UEFI's UpdateCapsule() runtime service supports passing more than one
>>    capsule to it (we can pass CapsuleCount argument to it for this purpose).
>>    But your particular kernel implementation allows us only to provide one
>>    capsule at a time. Is that was done for a reason? Can it be consider as
>>    shortcoming?
>
> Yeah, the reason is simply that it makes the capsule management more
> complicated if you have more than one capsule, and when testing the
> patches (and experimenting with the features in the capsule-* branches
> in my git tree) I didn't come across a scenario where sending multiple
> capsules at one time was required.
>
> Doesn't mean we couldn't extend the kernel API in the future, though.
> We'd just need an in-kernel user first.
>
>> 3. I noticed that you dropped efi_capsule_build() in this patch (w.r.t.
>>    https://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/
>>    implementation). BTW, it should be declared in header there.
>>    Anyway, how do we suppose to build capsule to pass to efi_capsule_update()?
>>    I mean, it can take a quite large code to build a capsule (allocating pages
>>    etc). Wouldn't it be easier to user to use your API if it has something
>>    ready to use? Anyway, if it should be done like this, it would be nice
>>    to have a decent example code (use-case) how to use this API (maybe in
>>    Documentation/, idk), because it looks quite non-intuitive (for me at least).
>
> The two patches that I sent are only preparatory patches for EFI capsule
> support, and Kweh (Cc'd) is working on patches that implement a userland
> interface.
>
> Wilson, do you think you could post your patches by the beginning of
> next week? They just need to give an idea of how we can use this API.
>
>> 4. Tedious stuff: I checked your patch with "checkpatch.pl" and it shows
>>     some warnings, please fix them if possible.
>
> Will do.
>
>> I will try to test and verify this patch further, will notify you if
>> notice any issues.
>
> Great, thanks.
>
> --
> Matt Fleming, Intel Open Source Technology Center
