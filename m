Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260Ab3DZHn1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 03:43:27 -0400
Received: from mail-ia0-f180.google.com ([209.85.210.180]:45796 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759192Ab3DZHnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 03:43:25 -0400
MIME-Version: 1.0
In-Reply-To: <517A28D7.3010707@intel.com>
References: <201304252144.r3PLihDe025383@terminus.zytor.com>
	<CA+55aFxxWXrQU4oZUbHOBBkvtF=pSxMvyF6sYU9xpSDarWV-=Q@mail.gmail.com>
	<1366928604.9976.3.camel@x230>
	<CANN689EH-VyDefawtKdY=cVQNdZP1xN7cV4bDgXvYeniSCkvqA@mail.gmail.com>
	<5179B435.1000404@zytor.com>
	<CANN689EaFu32GKNj-U41ykGpNJekBL2=w92P1pSkETuKAffJDQ@mail.gmail.com>
	<517A28D7.3010707@intel.com>
Date: Fri, 26 Apr 2013 00:43:25 -0700
Message-ID: <CANN689F7c8UbxGEHyAOH+uwZxFf7VoQDmCM3Nv862s2b=21bQg@mail.gmail.com>
Subject: Re: [GIT PULL] x86 fixes for 3.9
From: Michel Lespinasse <walken@google.com>
To: Matt Fleming <matt.fleming@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@suse.de>,
        Ingo Molnar <mingo@elte.hu>, Josh Boyer <jwboyer@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Bolle <pebolle@tiscali.nl>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 12:12 AM, Matt Fleming <matt.fleming@intel.com> wrote:
> On 26/04/13 00:11, Michel Lespinasse wrote:
>> On Thu, Apr 25, 2013 at 3:54 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> On 04/25/2013 03:53 PM, Michel Lespinasse wrote:
>>>> Well, I don't know if this is related, but commit e971318bbed6 broke
>>>> the google EFI SMI driver with
>>>> BUG: unable to handle kernel NULL pointer dereference at (null)
>>>> IP: [<ffffffff814a7245>] variable_is_present+0x55/0x170
>>>> Call Trace:
>>>> [<ffffffff814a9936>] register_efivars+0x106/0x370
>>>> [<ffffffff818ff430>] ? firmware_map_add_early+0xb1/0xb1
>>>> [<ffffffff818ff6dd>] gsmi_init+0x2ad/0x3da
>>>> [<ffffffff8100020f>] do_one_initcall+0x3f/0x170
>>>> ...
>>>
>>> I don't know either.  Could you test this patch and see if it does anything?
>>
>> Nope, still seeing the crash with this patch applied.
>
> Could you try the following patch against Linus' tree? The bug you've
> found and the changes in the pull request are unrelated.
>
> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
> index 182ce94..2a4f619 100644
> --- a/drivers/firmware/efivars.c
> +++ b/drivers/firmware/efivars.c
> @@ -1635,6 +1635,9 @@ static bool variable_is_present(efi_char16_t *variable_name, efi_guid_t *vendor)
>         unsigned long strsize1, strsize2;
>         bool found = false;
>
> +       if (list_empty(&efivars->list))
> +               return false;
> +
>         strsize1 = ucs2_strsize(variable_name, 1024);
>         list_for_each_entry_safe(entry, n, &efivars->list, list) {
>                 strsize2 = ucs2_strsize(entry->var.VariableName, 1024);

Still seeing the crash.

I went and compared the crash dump with the vmlinux disassembly; the
issue is a NULL pointer dereference in list_for_each_entry_safe().
list_empty() checks that the head node points to itself, but here the
head node has NULL. I think this may be due to gsmi_init() being
called before efivars_init(). Not sure what's the proper fix though.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
