Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbaJASI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 14:08:58 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:59611 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbaJASI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 14:08:57 -0400
MIME-Version: 1.0
In-Reply-To: <542C4177.6060409@zytor.com>
References: <20140911161931.GA12001@www.outflux.net>
	<542C4177.6060409@zytor.com>
Date: Wed, 1 Oct 2014 11:08:56 -0700
X-Google-Sender-Auth: lz7HXfqVQQ_qlCaikjQtB88xM4U
Message-ID: <CAGXu5jLK-k4JZO4eZSasRuSSQxeru94U9whMPcgD6iin40VVTA@mail.gmail.com>
Subject: Re: [PATCH] x86, kaslr: avoid setup_data when picking location
From: Kees Cook <keescook@chromium.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Baoquan He <bhe@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Pavel Machek <pavel@ucw.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 1, 2014 at 11:01 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 09/11/2014 09:19 AM, Kees Cook wrote:
>> --- a/arch/x86/boot/compressed/aslr.c
>> +++ b/arch/x86/boot/compressed/aslr.c
>> @@ -183,12 +183,27 @@ static void mem_avoid_init(unsigned long input, unsigned long input_size,
>>  static bool mem_avoid_overlap(struct mem_vector *img)
>>  {
>>       int i;
>> +     struct setup_data *ptr;
>>
>>       for (i = 0; i < MEM_AVOID_MAX; i++) {
>>               if (mem_overlaps(img, &mem_avoid[i]))
>>                       return true;
>>       }
>>
>> +     /* Avoid all entries in the setup_data linked list. */
>> +     ptr = (struct setup_data *)(unsigned long)real_mode->hdr.setup_data;
>> +     while (ptr) {
>> +             struct mem_vector avoid;
>> +
>> +             avoid.start = (u64)ptr;
>> +             avoid.size = sizeof(*ptr) + ptr->len;
>> +
>> +             if (mem_overlaps(img, &avoid))
>> +                     return true;
>> +
>> +             ptr = (struct setup_data *)(unsigned long)ptr->next;
>> +     }
>> +
>>       return false;
>>  }
>>
>>
>
> The use of (u64) in the assignment to avoid.start gives a nuisance
> warning on 32 bits.

Ah, good catch! This should be (unsigned long), I think. Shall I send
a follow-up patch, or do you want to fix this directly?

-Kees

-- 
Kees Cook
Chrome OS Security
