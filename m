Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758427AbaCSAKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 20:10:00 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:47100 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758387AbaCSAJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 20:09:59 -0400
MIME-Version: 1.0
In-Reply-To: <53284382.7080509@redhat.com>
References: <4376102.svyTz8ADVT@daeseok-laptop.cloud.net>
	<20140317214145.GA29105@kroah.com>
	<CAHb8M2BwuCJEGueP+-cOatynS5QcSrJMeei_D=0-GdKGxi5N-Q@mail.gmail.com>
	<53284382.7080509@redhat.com>
Date: Wed, 19 Mar 2014 09:09:59 +0900
Message-ID: <CAHb8M2A1J242RZoc49zu47HW5c0iVsJAXiu7KeBL8uFk2TJkGA@mail.gmail.com>
Subject: Re: [PATCH] staging: unisys: use kzalloc instead of kmalloc/memset 0
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Ken Cox <jkc@redhat.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ken
Thanks for review.

But I have a question,  I wan to know why tracing buffer
status(Malloc_FailuresAlloc, Malloc_BytesInUse...) for
info_proc_read_helper() are needed.
If it doesn't need, whole tracing stuff for memory can be removed.

After getting a reply from you and greg, I will make a patch.
Regards,
Daeseok Youn.

2014-03-18 22:00 GMT+09:00 Ken Cox <jkc@redhat.com>:
>
> On 03/17/2014 07:26 PM, DaeSeok Youn wrote:
>>
>> I think vmalloc/kmalloc in uislib_malloc() can be removed and just use
>> vmalloc/kmalloc directly.
>> (UISMALLOC() macro is also removed.)
>> And uislib_malloc() is renamed to "uislib_trace_buffer_status()" which
>> is just tracing buffer status(Malloc_FailuresAlloc, Malloc_BytesInUse
>> ...) for info_proc_read_helper().
>>
>> If this change is accepted, it also need to change uislib_free().
>>
>> Is it fine to change like this?
>
> This change is fine with me.  It makes the logic easier to follow.
>
>>
>> Thanks.
>> Daeseok Youn.
>>
>> 2014-03-18 6:41 GMT+09:00 Greg KH <gregkh@linuxfoundation.org>:
>>>
>>> On Wed, Mar 12, 2014 at 07:37:50PM +0900, Daeseok Youn wrote:
>>>>
>>>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>>>> ---
>>>>   drivers/staging/unisys/uislib/uislib.c   |    5 +----
>>>>   drivers/staging/unisys/uislib/uisutils.c |    2 +-
>>>>   2 files changed, 2 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/drivers/staging/unisys/uislib/uislib.c
>>>> b/drivers/staging/unisys/uislib/uislib.c
>>>> index d77df9a..9748fcb 100644
>>>> --- a/drivers/staging/unisys/uislib/uislib.c
>>>> +++ b/drivers/staging/unisys/uislib/uislib.c
>>>> @@ -339,8 +339,6 @@ create_bus(CONTROLVM_MESSAGE *msg, char *buf)
>>>>                return CONTROLVM_RESP_ERROR_KMALLOC_FAILED;
>>>>        }
>>>>
>>>> -     memset(bus, 0, size);
>>>> -
>>>>        /* Currently by default, the bus Number is the GuestHandle.
>>>>         * Configure Bus message can override this.
>>>>         */
>>>> @@ -530,7 +528,6 @@ create_device(CONTROLVM_MESSAGE *msg, char *buf)
>>>>                return CONTROLVM_RESP_ERROR_KMALLOC_FAILED;
>>>>        }
>>>>
>>>> -     memset(dev, 0, sizeof(struct device_info));
>>>>        dev->channelTypeGuid = msg->cmd.createDevice.dataTypeGuid;
>>>>        dev->intr = msg->cmd.createDevice.intr;
>>>>        dev->channelAddr = msg->cmd.createDevice.channelAddr;
>>>> @@ -1437,7 +1434,7 @@ uislib_malloc(size_t siz, gfp_t gfp, U8
>>>> contiguous, char *fn, int ln)
>>>>                * get memory for you (like, invoke oom killer), which
>>>>                * will probably cripple the system.
>>>>                */
>>>> -             p = kmalloc(siz, gfp | __GFP_NORETRY);
>>>> +             p = kzalloc(siz, gfp | __GFP_NORETRY);
>>>>        }
>>>>        if (p == NULL) {
>>>>                LOGERR("uislib_malloc failed to alloc %d bytes @%s:%d",
>>>> diff --git a/drivers/staging/unisys/uislib/uisutils.c
>>>> b/drivers/staging/unisys/uislib/uisutils.c
>>>> index 208b7ea..2f05be1 100644
>>>> --- a/drivers/staging/unisys/uislib/uisutils.c
>>>> +++ b/drivers/staging/unisys/uislib/uisutils.c
>>>> @@ -294,7 +294,7 @@ ReqHandlerAdd(GUID switchTypeGuid,
>>>>        rc = UISMALLOC(sizeof(*rc), GFP_ATOMIC);
>>>>        if (!rc)
>>>>                return NULL;
>>>> -     memset(rc, 0, sizeof(*rc));
>>>> +
>>>>        rc->switchTypeGuid = switchTypeGuid;
>>>>        rc->controlfunc = controlfunc;
>>>>        rc->min_channel_bytes = min_channel_bytes;
>>>
>>> Can you just remove the UISMALLOC() macro completly, so that it's easier
>>> to verify that changes like this are actually correct?
>>>
>>> thanks,
>>>
>>> greg k-h
>
>
