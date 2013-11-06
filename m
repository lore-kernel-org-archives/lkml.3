Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab3KFU4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 15:56:39 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:55968 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610Ab3KFU4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 15:56:37 -0500
MIME-Version: 1.0
In-Reply-To: <52799891.7070300@linux.intel.com>
References: <1383699252-8898-1-git-send-email-ohaugan@codeaurora.org>
	<52799891.7070300@linux.intel.com>
Date: Wed, 6 Nov 2013 12:56:36 -0800
Message-ID: <CAPkvG_ftpPJMdYdOmKdYT2e6sd+tntX_vrvpLbAW85dXYJiQdw@mail.gmail.com>
Subject: Re: [PATCH] staging: zsmalloc: Ensure handle is never 0 on success
From: Nitin Gupta <ngupta@vflare.org>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: Olav Haugan <ohaugan@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>, linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 5, 2013 at 5:17 PM, David Cohen
<david.a.cohen@linux.intel.com> wrote:
> Hi Olav,
>
>
> On 11/05/2013 04:54 PM, Olav Haugan wrote:
>>
>> zsmalloc encodes a handle using the page pfn and an object
>> index. On some hardware platforms the pfn could be 0 and this
>> causes the encoded handle to be 0 which is interpreted as an
>> allocation failure.
>>
>> To prevent this false error we ensure that the encoded handle
>> will not be 0 when allocation succeeds.
>>
>> Change-Id: Ifff930dcf254915b497aec5cb36f152a5e5365d6
>> Signed-off-by: Olav Haugan <ohaugan@codeaurora.org>
>> ---
>>   drivers/staging/zsmalloc/zsmalloc-main.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c
>> b/drivers/staging/zsmalloc/zsmalloc-main.c
>> index 523b937..0e32c0f 100644
>> --- a/drivers/staging/zsmalloc/zsmalloc-main.c
>> +++ b/drivers/staging/zsmalloc/zsmalloc-main.c
>> @@ -441,7 +441,7 @@ static void *obj_location_to_handle(struct page *page,
>> unsigned long obj_idx)
>>         }
>>
>>         handle = page_to_pfn(page) << OBJ_INDEX_BITS;
>> -       handle |= (obj_idx & OBJ_INDEX_MASK);
>> +       handle |= ((obj_idx + 1) & OBJ_INDEX_MASK);
>
>
> As suggestion you could use a macro instead of hardcoded 1.
>
> I am not familiar with this code, but if it's a valid test to verify if
> the resulting address is page aligned, you might want to set this
> offset macro to a page aligned value as well.
>
>

Using a hardcoded 1 looks fine in this case. But the patch description
should also be added as a comment for this function. Otherwise, the patch
looks good to me.

>>
>>         return (void *)handle;
>>   }
>> @@ -451,7 +451,7 @@ static void obj_handle_to_location(unsigned long
>> handle, struct page **page,
>>                                 unsigned long *obj_idx)
>>   {
>>         *page = pfn_to_page(handle >> OBJ_INDEX_BITS);
>> -       *obj_idx = handle & OBJ_INDEX_MASK;
>> +       *obj_idx = (handle & OBJ_INDEX_MASK) - 1;
>
>
> Ditto.
>

Thanks,
Nitin
