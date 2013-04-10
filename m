Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934877Ab3DJNbD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 09:31:03 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:48792 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab3DJNbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:31:01 -0400
Message-ID: <51656992.60203@gmail.com>
Date: Wed, 10 Apr 2013 08:30:58 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Colin Cross <ccross@android.com>
CC: lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>
Subject: Re: [RFC PATCH 1/3] pstore-ram: use write-combine mappings
References: <1365563297-12480-1-git-send-email-robherring2@gmail.com> <CAMbhsRSvQPbzJ7Nt=OSSYE_A1e+eaUjO7XY+qRppJ5_gfWmW4A@mail.gmail.com>
In-Reply-To: <CAMbhsRSvQPbzJ7Nt=OSSYE_A1e+eaUjO7XY+qRppJ5_gfWmW4A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 10:53 PM, Colin Cross wrote:
> On Tue, Apr 9, 2013 at 8:08 PM, Rob Herring <robherring2@gmail.com> wrote:
>> From: Rob Herring <rob.herring@calxeda.com>
>>
>> Atomic operations are undefined behavior on ARM for device or strongly
>> ordered memory types. So use write-combine variants for mappings. This
>> corresponds to normal, non-cacheable memory on ARM. For many other
>> architectures, this change should not change the mapping type.
> 
> This is going to make ramconsole less reliable.  A debugging printk
> followed by a __raw_writel that causes an immediate hard crash is
> likely to lose the last updates, including the most useful message, in
> the write buffers.

It would have to be a write that hangs the bus. In my experience with
AXI, the bus doesn't actually hang until you hit max outstanding
transactions.

I think exclusive stores will limit the buffering, but that is probably
not architecturally guaranteed.

I could put a wb() in at the end of persistent_ram_write.

> Also, isn't this patch unnecessary after patch 3 in this set?

It is still needed in the main memory case to be architecturally correct
to avoid multiple mappings of different memory types and exclusive
accesses to device memory. At least on an A9, it doesn't really seem to
matter. I could remove this for the ioremap case.

Rob

>> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
>> Cc: Anton Vorontsov <cbouatmailru@gmail.com>
>> Cc: Colin Cross <ccross@android.com>
>> Cc: Kees Cook <keescook@chromium.org>
>> Cc: Tony Luck <tony.luck@intel.com>
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>  fs/pstore/ram_core.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
>> index 0306303..e126d9f 100644
>> --- a/fs/pstore/ram_core.c
>> +++ b/fs/pstore/ram_core.c
>> @@ -337,7 +337,7 @@ static void *persistent_ram_vmap(phys_addr_t start, size_t size)
>>         page_start = start - offset_in_page(start);
>>         page_count = DIV_ROUND_UP(size + offset_in_page(start), PAGE_SIZE);
>>
>> -       prot = pgprot_noncached(PAGE_KERNEL);
>> +       prot = pgprot_writecombine(PAGE_KERNEL);
> Is this necessary?  Won't pgprot_noncached already be normal memory?
> 
>>         pages = kmalloc(sizeof(struct page *) * page_count, GFP_KERNEL);
>>         if (!pages) {
>> @@ -364,7 +364,7 @@ static void *persistent_ram_iomap(phys_addr_t start, size_t size)
>>                 return NULL;
>>         }
>>
>> -       return ioremap(start, size);
>> +       return ioremap_wc(start, size);
> 
> ioremap_wc corresponds to MT_DEVICE_WC, which is still device memory,
> so I don't see how this helps solve the problem in the commit message.
> 
>>  }
>>
>>  static int persistent_ram_buffer_map(phys_addr_t start, phys_addr_t size,
>> --
>> 1.7.10.4
>>

