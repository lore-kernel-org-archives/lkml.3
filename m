Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab3EZKZJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 06:25:09 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:39171 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751985Ab3EZKZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 06:25:06 -0400
Message-ID: <51A1E2FF.9020400@hurleysoftware.com>
Date: Sun, 26 May 2013 06:25:03 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 06/10] ipc: Don't allocate a copy larger than max
References: <51A0A8B9.4070807@colorfullife.com>
In-Reply-To: <51A0A8B9.4070807@colorfullife.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2013 08:04 AM, Manfred Spraul wrote:
> Hi Peter,
>
> You wrote:
>> When MSG_COPY is set, a duplicate message must be allocated for
>> the copy before locking the queue. However, the copy could
>> not be larger than was sent which is limited to msg_ctlmax.
>>
>> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
>> ---
>>   ipc/msg.c | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/ipc/msg.c b/ipc/msg.c
>> index 950572f..31cd1bf 100644
>> --- a/ipc/msg.c
>> +++ b/ipc/msg.c
>> @@ -820,15 +820,17 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
>>       struct msg_msg *copy = NULL;
>>       unsigned long copy_number = 0;
>> +    ns = current->nsproxy->ipc_ns;
>> +
>>       if (msqid < 0 || (long) bufsz < 0)
>>           return -EINVAL;
>>       if (msgflg & MSG_COPY) {
>> -        copy = prepare_copy(buf, bufsz, msgflg, &msgtyp, &copy_number);
>> +        copy = prepare_copy(buf, min_t(size_t, bufsz, ns->msg_ctlmax),
>> +                    msgflg, &msgtyp, &copy_number);
>
> What about:
> - increase msg_ctlmax
> - send message
> - reduce msg_ctlmax
>
> The side effects of the patch are odd:
> - without MSG_COPY, a message can be read regardsless of the size.
>    The user could check for E2BIG and increase the buffer size until
>    msgrcv succeeds.

The patch does not change the behavior of non-MSG_COPY msg receive.

> - with MSG_COPY, something else would happen.
>    As far as I can see, it would oops: msg_ctlmax bytes are allocated,
>    then the E2BIG test is against bufsz, and copy_msg() doesn't check
>    the size of the target buffer.

I assume you are using 3.9

Current mainline returns EINVAL.

Regards,
Peter Hurley
