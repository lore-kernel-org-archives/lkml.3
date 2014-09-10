Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751066AbaIJGIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 02:08:48 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:33344 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbaIJGIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 02:08:46 -0400
MIME-Version: 1.0
In-Reply-To: <1561567.ev2pEO8C5v@vostro.rjw.lan>
References: <1407754252-22779-1-git-send-email-jlee@suse.com>
	<1561567.ev2pEO8C5v@vostro.rjw.lan>
Date: Tue, 9 Sep 2014 23:08:45 -0700
X-Google-Sender-Auth: R45mQu-jXi9yfIar5-zCMr-qf8E
Message-ID: <CAE9FiQUROUAxFk8_gtMp0Fu6aBLbL8GtKhJg0Y-01s4n3BDjtw@mail.gmail.com>
Subject: Re: [PATCH] Hibernate: Do not assume the first e820 area to be RAM
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Takashi Iwai <tiwai@suse.de>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Lee, Chun-Yi" <jlee@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 8, 2014 at 3:52 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Monday, August 11, 2014 06:50:52 PM Lee, Chun-Yi wrote:
>> In arch/x86/kernel/setup.c::trim_bios_range(), the codes introduced
>> by 1b5576e6 (base on d8a9e6a5), it updates the first 4Kb of memory
>> to be E820_RESERVED region. That's because it's a BIOS owned area
>> but generally not listed in the E820 table:
>>
>> [    0.000000] e820: BIOS-provided physical RAM map:
>> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000096fff] usable
>> [    0.000000] BIOS-e820: [mem 0x0000000000097000-0x0000000000097fff] reserved
>> ...
>> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
>> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
>>
>> But the region of first 4Kb didn't register to nosave memory:
>>
>> [    0.000000] PM: Registered nosave memory: [mem 0x00097000-0x00097fff]
>> [    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
>>
>> The codes in e820_mark_nosave_regions() assumes the first e820 area to be
>> RAM, so it causes the first 4Kb E820_RESERVED region ignored when register
>> to nosave. This patch removed assumption of the first e820 area.
>>
>> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
>> Cc: Len Brown <len.brown@intel.com>
>> Cc: Pavel Machek <pavel@ucw.cz>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
>
> Thomas, Ingo, Peter, any objections here?
>
> If not, do you want to handle it or do you want me to do that?

Did it address any regression?

>
>> ---
>>  arch/x86/kernel/e820.c | 7 +++----
>>  1 file changed, 3 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
>> index 988c00a..d595240 100644
>> --- a/arch/x86/kernel/e820.c
>> +++ b/arch/x86/kernel/e820.c
>> @@ -682,18 +682,17 @@ void __init parse_e820_ext(u64 phys_addr, u32 data_len)
>>   * hibernation (32 bit) or software suspend and suspend to RAM (64 bit).
>>   *
>>   * This function requires the e820 map to be sorted and without any
>> - * overlapping entries and assumes the first e820 area to be RAM.
>> + * overlapping entries.
>>   */
>>  void __init e820_mark_nosave_regions(unsigned long limit_pfn)
>>  {
>>       int i;
>>       unsigned long pfn;
>>
>> -     pfn = PFN_DOWN(e820.map[0].addr + e820.map[0].size);
>> -     for (i = 1; i < e820.nr_map; i++) {
>> +     for (i = 0; i < e820.nr_map; i++) {
>>               struct e820entry *ei = &e820.map[i];
>>
>> -             if (pfn < PFN_UP(ei->addr))
>> +             if (i > 0 && pfn < PFN_UP(ei->addr))
>>                       register_nosave_region(pfn, PFN_UP(ei->addr));

could avoid the i > 0 checking.

>>
>>               pfn = PFN_DOWN(ei->addr + ei->size);
>>
>

following would be better ?

@@ -682,15 +682,14 @@ void __init parse_e820_ext(u64 phys_addr, u32 data_len)
  * hibernation (32 bit) or software suspend and suspend to RAM (64 bit).
  *
  * This function requires the e820 map to be sorted and without any
- * overlapping entries and assumes the first e820 area to be RAM.
+ * overlapping entries.
  */
 void __init e820_mark_nosave_regions(unsigned long limit_pfn)
 {
     int i;
-    unsigned long pfn;
+    unsigned long pfn = 0;

-    pfn = PFN_DOWN(e820.map[0].addr + e820.map[0].size);
-    for (i = 1; i < e820.nr_map; i++) {
+    for (i = 0; i < e820.nr_map; i++) {
         struct e820entry *ei = &e820.map[i];

         if (pfn < PFN_UP(ei->addr))
