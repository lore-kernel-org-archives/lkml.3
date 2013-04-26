Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867Ab3DZHM2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 03:12:28 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:60469 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757078Ab3DZHM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 03:12:26 -0400
Message-ID: <517A28D7.3010707@intel.com>
Date: Fri, 26 Apr 2013 08:12:23 +0100
From: Matt Fleming <matt.fleming@intel.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@suse.de>,
        Ingo Molnar <mingo@elte.hu>, Josh Boyer <jwboyer@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Bolle <pebolle@tiscali.nl>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] x86 fixes for 3.9
References: <201304252144.r3PLihDe025383@terminus.zytor.com> <CA+55aFxxWXrQU4oZUbHOBBkvtF=pSxMvyF6sYU9xpSDarWV-=Q@mail.gmail.com> <1366928604.9976.3.camel@x230> <CANN689EH-VyDefawtKdY=cVQNdZP1xN7cV4bDgXvYeniSCkvqA@mail.gmail.com> <5179B435.1000404@zytor.com> <CANN689EaFu32GKNj-U41ykGpNJekBL2=w92P1pSkETuKAffJDQ@mail.gmail.com>
In-Reply-To: <CANN689EaFu32GKNj-U41ykGpNJekBL2=w92P1pSkETuKAffJDQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/04/13 00:11, Michel Lespinasse wrote:
> On Thu, Apr 25, 2013 at 3:54 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 04/25/2013 03:53 PM, Michel Lespinasse wrote:
>>> On Thu, Apr 25, 2013 at 3:23 PM, Matthew Garrett
>>> <matthew.garrett@nebula.com> wrote:
>>>> On Thu, 2013-04-25 at 15:20 -0700, Linus Torvalds wrote:
>>>>> On Thu, Apr 25, 2013 at 2:44 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>>>>>>
>>>>>> -       if (!sys_table->runtime->query_variable_info)
>>>>>> +       if (sys_table->runtime->hdr.revision < EFI_2_00_SYSTEM_TABLE_REVISION)
>>>>>>                 return EFI_UNSUPPORTED;
>>>>>
>>>>> Is a EFI 2.00 system table *guaranteed* to have that
>>>>> "query_variable_info" function? The above adds the version check, but
>>>>> removes the check for a NULL pointer.
>>>>
>>>> As far as the spec's concerned, yes. As far as reality's concerned - if
>>>> anything doesn't provide it, we're already crashing when
>>>> efi_virt_query_variable_info() gets called. Nobody's complained so far.
>>>
>>> Well, I don't know if this is related, but commit e971318bbed6 broke
>>> the google EFI SMI driver with
>>> BUG: unable to handle kernel NULL pointer dereference at (null)
>>> IP: [<ffffffff814a7245>] variable_is_present+0x55/0x170
>>> Call Trace:
>>> [<ffffffff814a9936>] register_efivars+0x106/0x370
>>> [<ffffffff818ff430>] ? firmware_map_add_early+0xb1/0xb1
>>> [<ffffffff818ff6dd>] gsmi_init+0x2ad/0x3da
>>> [<ffffffff8100020f>] do_one_initcall+0x3f/0x170
>>> ...
>>
>> I don't know either.  Could you test this patch and see if it does anything?
> 
> Nope, still seeing the crash with this patch applied.

Could you try the following patch against Linus' tree? The bug you've
found and the changes in the pull request are unrelated.

---

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 182ce94..2a4f619 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -1635,6 +1635,9 @@ static bool variable_is_present(efi_char16_t *variable_name, efi_guid_t *vendor)
 	unsigned long strsize1, strsize2;
 	bool found = false;
 
+	if (list_empty(&efivars->list))
+		return false;
+
 	strsize1 = ucs2_strsize(variable_name, 1024);
 	list_for_each_entry_safe(entry, n, &efivars->list, list) {
 		strsize2 = ucs2_strsize(entry->var.VariableName, 1024);
