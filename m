Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbaIIVKL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 17:10:11 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:58804 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbaIIVKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 17:10:08 -0400
MIME-Version: 1.0
In-Reply-To: <bb719b1c-83c4-4496-9940-772144d89a30@email.android.com>
References: <1409926097-2101-1-git-send-email-bhe@redhat.com>
	<1409926097-2101-4-git-send-email-bhe@redhat.com>
	<20140905173256.GV5598@outflux.net>
	<20140909194500.GB20681@redhat.com>
	<bb719b1c-83c4-4496-9940-772144d89a30@email.android.com>
Date: Tue, 9 Sep 2014 14:10:08 -0700
X-Google-Sender-Auth: dNBPRNKtSjinzn0AdeH2eATERkE
Message-ID: <CAGXu5j+v+LPzc634XJ2vaKk+qGLiF6Vxz7FNRgPC-tjSqUFGDA@mail.gmail.com>
Subject: Re: [PATCH 3/4] kaslr setup_data handling
From: Kees Cook <keescook@chromium.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Baoquan He <bhe@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Deutschmann <whissi@whissi.de>,
        Dave Young <dyoung@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        WANG Chao <chaowang@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2014 at 12:49 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> setup_data is used by a variety of bootloaders.  The first user was large memory machines with more than 128 memory areas.
>
> On September 9, 2014 12:45:00 PM PDT, Vivek Goyal <vgoyal@redhat.com> wrote:
>>On Fri, Sep 05, 2014 at 10:32:56AM -0700, Kees Cook wrote:
>>> On Fri, Sep 05, 2014 at 10:08:16PM +0800, Baoquan He wrote:
>>> > From: Dave Young <dyoung@redhat.com>
>>> >
>>> > X86 will pass setup_data region while necessary, these regions
>>could be
>>> > overwitten by kernel due to kaslr.
>>> >
>>> > Thus iterate and add setup regions to mem_avoid[] in this patch.
>>> > Up to now there isn't a official data to state the maximal entries
>>> > setup data could use. So just set max mem avoid entries 32,
>>hopefully
>>> > it will be enough. This can be increased later when people report
>>> > they are using more setup data entries.
>>>
>>> Ew, yes, this is bad. I hadn't seen setup_data while designing the
>>> mem_avoid stuff. I don't like the fixed 32 entry size here, so let me
>>> consider some options. I think the mem_avoid logic can just walk the
>>> setup_data list itself, since that's what it's for. :)
>>>
>>> Does only kexec use this? I assume other boot loaders must be using
>>this
>>> too. Is there an easy test case for validating this is fixed?
>>
>>[CC hpa]
>>
>>I think this is generic mechanism and any bootloader can make use of
>>it.
>>May be testing it using kexec on an EFI machine might work as kexec
>>prepares setup_data entry to pass some information to second kernel.

Has anyone been able to test my solution? I could try to cook
something up with QEMU, but that might take a while. Note that I've
fixed a few build warnings in my originally proposed patch. The latest
is here:
https://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/commit/?h=kaslr&id=be892817cf8424c22739c56df472f160fc710021

-Kees

>>> Subject: x86, kaslr: avoid setup_data when choosing kernel location
>>>
>>> The KASLR location-choosing logic needs to avoid the setup_data list
>>> areas as well.
>>>
>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>> Cc: stable@vger.kernel.org
>>>
>>> diff --git a/arch/x86/boot/compressed/aslr.c
>>b/arch/x86/boot/compressed/aslr.c
>>> index fc6091abedb7..7c75c22d9bc3 100644
>>> --- a/arch/x86/boot/compressed/aslr.c
>>> +++ b/arch/x86/boot/compressed/aslr.c
>>> @@ -112,6 +112,7 @@ struct mem_vector {
>>>
>>>  #define MEM_AVOID_MAX 5
>>>  static struct mem_vector mem_avoid[MEM_AVOID_MAX];
>>> +static struct setup_data *setup_data_avoid;
>>>
>>>  static bool mem_contains(struct mem_vector *region, struct
>>mem_vector *item)
>>>  {
>>> @@ -177,17 +178,30 @@ static void mem_avoid_init(unsigned long input,
>>unsigned long input_size,
>>>      /* Avoid stack memory. */
>>>      mem_avoid[4].start = (unsigned long)free_mem_end_ptr;
>>>      mem_avoid[4].size = BOOT_STACK_SIZE;
>>> +
>>> +    /* Locate the setup_data list, if it exists. */
>>> +    setup_data_avoid = (struct setup_data *)real_mode->hdr.setup_data;
>>>  }
>>>
>>>  /* Does this memory vector overlap a known avoided area? */
>>>  static bool mem_avoid_overlap(struct mem_vector *img)
>>>  {
>>>      int i;
>>> +    struct setup_data *ptr;
>>>
>>>      for (i = 0; i < MEM_AVOID_MAX; i++) {
>>>              if (mem_overlaps(img, &mem_avoid[i]))
>>>                      return true;
>>>      }
>>> +    for (ptr = setup_data_avoid; ptr; ptr = ptr->next) {
>>> +            struct mem_vector avoid;
>>> +
>>> +            avoid.start = (u64)ptr;
>>> +            avoid.size = sizeof(*ptr) + ptr->len;
>>> +
>>> +            if (mem_overlaps(img, &avoid))
>>> +                    return true;
>>> +    }
>>>
>>>      return false;
>>>  }
>>>
>>> --
>>> Kees Cook
>>> Chrome OS Security
>
> --
> Sent from my mobile phone.  Please pardon brevity and lack of formatting.



-- 
Kees Cook
Chrome OS Security
