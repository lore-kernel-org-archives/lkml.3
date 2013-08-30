Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721Ab3H3XM1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 19:12:27 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:33900 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab3H3XMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 19:12:25 -0400
MIME-Version: 1.0
In-Reply-To: <20130830133902.AEA7A3E102A@localhost>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org>
	<1376090777-20090-13-git-send-email-roy.franz@linaro.org>
	<20130830133902.AEA7A3E102A@localhost>
Date: Fri, 30 Aug 2013 16:12:24 -0700
Message-ID: <CAFECyb-J4gTiAQkKVT8qt94Tk6-_jVdX=sNM7VkXkyvPdEeZFA@mail.gmail.com>
Subject: Re: [PATCH 12/16] Fix types in EFI calls to match EFI function definitions.
From: Roy Franz <roy.franz@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>, matt.fleming@intel.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Dave Martin <dave.martin@arm.com>, Mark Salter <msalter@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 6:39 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Fri,  9 Aug 2013 16:26:13 -0700, Roy Franz <roy.franz@linaro.org> wrote:
>> EFI calls can made directly on ARM, so the function pointers
>> are directly invoked.  This allows types to be checked at
>> compile time, so here we ensure that the parameters match
>> the function signature.
>>
>> Signed-off-by: Roy Franz <roy.franz@linaro.org>
>> ---
>>  drivers/firmware/efi/efi-stub-helper.c |   15 +++++++++------
>>  1 file changed, 9 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
>> index b707a9f..4bb542f 100644
>> --- a/drivers/firmware/efi/efi-stub-helper.c
>> +++ b/drivers/firmware/efi/efi-stub-helper.c
>> @@ -321,7 +321,7 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
>>       status = efi_call_phys3(sys_table_arg->boottime->allocate_pool,
>>                               EFI_LOADER_DATA,
>>                               nr_files * sizeof(*files),
>> -                             &files);
>> +                             (void **)&files);
>>       if (status != EFI_SUCCESS) {
>>               efi_printk(sys_table_arg, "Failed to alloc mem for file handle list\n");
>>               goto fail;
>> @@ -372,7 +372,8 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
>>                       boottime = sys_table_arg->boottime;
>>
>>                       status = efi_call_phys3(boottime->handle_protocol,
>> -                                     image->device_handle, &fs_proto, &io);
>> +                                     image->device_handle, &fs_proto,
>> +                                             (void **)&io);
>>                       if (status != EFI_SUCCESS) {
>>                               efi_printk(sys_table_arg, "Failed to handle fs_proto\n");
>>                               goto free_files;
>> @@ -406,7 +407,8 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
>>
>>  grow:
>>               status = efi_call_phys3(sys_table_arg->boottime->allocate_pool,
>> -                                     EFI_LOADER_DATA, info_sz, &info);
>> +                                     EFI_LOADER_DATA, info_sz,
>> +                                     (void **)&info);
>>               if (status != EFI_SUCCESS) {
>>                       efi_printk(sys_table_arg, "Failed to alloc mem for file info\n");
>>                       goto close_handles;
>> @@ -456,18 +458,19 @@ grow:
>>
>>               addr = file_addr;
>>               for (j = 0; j < nr_files; j++) {
>> -                     u64 size;
>> +                     unsigned long size;
>>
>>                       size = files[j].size;
>>                       while (size) {
>> -                             u64 chunksize;
>> +                             unsigned long chunksize;
>>                               if (size > EFI_READ_CHUNK_SIZE)
>>                                       chunksize = EFI_READ_CHUNK_SIZE;
>>                               else
>>                                       chunksize = size;
>>                               status = efi_call_phys3(fh->read,
>>                                                       files[j].handle,
>> -                                                     &chunksize, addr);
>> +                                                     &chunksize,
>> +                                                     (void *)addr);
>
> I think you need some description in the commit text about why the type
> of chunksize is changing. It's not clear why you're making this change.
> It is a bug fix?

The type was changed to match the EFI_FILE_PROTOCOL specification -
chunk size is
defined as a native width unsigned integer.  So yes, this is a bug in
that this is wrong for
ia32, since that really should be a u32 in that case.
Since the x86 wrappers break type checking by the compiler these types
were never checked at compile time
before.  chunksize is the the only change that isn't a cast to a type
of void pointer.

I can break this change out as a separate patch if desired.

Matt - would you like me to split the chunksize type change into a
separate patch from the arm EFI stub series?

Roy



>
> g.
