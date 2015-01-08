Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbbAHEgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 23:36:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59195 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbbAHEgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 23:36:36 -0500
MIME-Version: 1.0
In-Reply-To: <CACVXFVO73hw-FWK+-xvuqRrmE3hvWQavLP2ixKwRj9tmFX0tcQ@mail.gmail.com>
References: <1420472494-25836-1-git-send-email-sasha.levin@oracle.com>
	<CACVXFVPUF1x8YDwHtYzoC6LiPy22Lr2bZC-N73+NakFMBrEUFw@mail.gmail.com>
	<54AD6148.6030703@oracle.com>
	<CACVXFVMcggxG41c5h4-3dY_twZfD3artiD8G=x608ADnNfnn4Q@mail.gmail.com>
	<54ADED68.7060507@oracle.com>
	<CACVXFVO73hw-FWK+-xvuqRrmE3hvWQavLP2ixKwRj9tmFX0tcQ@mail.gmail.com>
Date: Thu, 8 Jan 2015 12:36:33 +0800
Message-ID: <CACVXFVMZGQD0dZ8pKt_rufX3DOzU6JLWcTu+eZ2oLK--fx2ekg@mail.gmail.com>
Subject: Re: [PATCH] firmware class: remove from pending list on load failure
From: Ming Lei <ming.lei@canonical.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 8, 2015 at 11:06 AM, Ming Lei <ming.lei@canonical.com> wrote:
> On Thu, Jan 8, 2015 at 10:37 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
>> On 01/07/2015 09:15 PM, Ming Lei wrote:
>>> On Thu, Jan 8, 2015 at 12:39 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
>>>> On 01/06/2015 11:52 PM, Ming Lei wrote:
>>>>> On Mon, Jan 5, 2015 at 11:41 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>>>>>>> If we failed loading the firmware we have to make sure it leaves the pending
>>>>>>> list if abort wasn't executed for it.
>>>>>>>
>>>>>>> Otherwise we'd free an object still on the pending list and corrupt it.
>>>>>>>
>>>>>>> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
>>>>>>> ---
>>>>>>>  drivers/base/firmware_class.c | 11 ++++++++++-
>>>>>>>  1 file changed, 10 insertions(+), 1 deletion(-)
>>>>>>>
>>>>>>> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
>>>>>>> index 58470c3..8ccf6cf4 100644
>>>>>>> --- a/drivers/base/firmware_class.c
>>>>>>> +++ b/drivers/base/firmware_class.c
>>>>>>> @@ -929,9 +929,18 @@ static int _request_firmware_load(struct firmware_priv *fw_priv,
>>>>>>>         cancel_delayed_work_sync(&fw_priv->timeout_work);
>>>>>>>         if (is_fw_load_aborted(buf))
>>>>>>>                 retval = -EAGAIN;
>>>>>>> -       else if (!buf->data)
>>>>>>> +       else if (!buf->data) {
>>>>>>>                 retval = -ENOMEM;
>>>>>>>
>>>>>>> +               /*
>>>>>>> +                * We failed loading, but abort was never done so we
>>>>>>> +                * need to remove it from the pending list ourselves.
>>>>>>> +                */
>>>>>>> +               mutex_lock(&fw_lock);
>>>>>>> +               list_del_init(&buf->pending_list);
>>>>>>> +               mutex_unlock(&fw_lock);
>>>>> The buf is always removed before the complete_all(), isn't it? Or did
>>>>> you observe the issue?
>>>>
>>>> Not in the case where userspacehelper fails. Yes, this is not a theoretical
>>>> thing and can be easily reproduced.
>>>
>>> OK, I am just curious how it is triggered.
>>>
>>> One situation I thought of is that the request context is interrupted
>>> by signal after wait_for_completion() becomes interruptable, and the
>>> fix should abort the request if retval is -ERESTARTSYS.
>>>
>>> Or could you share how to reproduce if it isn't above case?
>>
>> It's pretty simple, just abort it once with Ctrl-C:
>
> Looks it is just the case I said, :-)
>
> Then I suggest you to remove the buf from list in case of
> 'retval == -ERESTARTSYS', and the return value should be
> changed to -EINTR.

Thought of the case further, the request still need to be
aborted in the situation since it doesn't make sense for
requests on same fw in other contexts to wait any more.


Thanks
Ming Lei
