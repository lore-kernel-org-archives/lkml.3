Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbbAHChg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 21:37:36 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:27260 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbbAHChf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 21:37:35 -0500
Message-ID: <54ADED68.7060507@oracle.com>
Date: Wed, 07 Jan 2015 21:37:28 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] firmware class: remove from pending list on load failure
References: <1420472494-25836-1-git-send-email-sasha.levin@oracle.com>	<CACVXFVPUF1x8YDwHtYzoC6LiPy22Lr2bZC-N73+NakFMBrEUFw@mail.gmail.com>	<54AD6148.6030703@oracle.com> <CACVXFVMcggxG41c5h4-3dY_twZfD3artiD8G=x608ADnNfnn4Q@mail.gmail.com>
In-Reply-To: <CACVXFVMcggxG41c5h4-3dY_twZfD3artiD8G=x608ADnNfnn4Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2015 09:15 PM, Ming Lei wrote:
> On Thu, Jan 8, 2015 at 12:39 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
>> On 01/06/2015 11:52 PM, Ming Lei wrote:
>>> On Mon, Jan 5, 2015 at 11:41 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>>>>> If we failed loading the firmware we have to make sure it leaves the pending
>>>>> list if abort wasn't executed for it.
>>>>>
>>>>> Otherwise we'd free an object still on the pending list and corrupt it.
>>>>>
>>>>> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
>>>>> ---
>>>>>  drivers/base/firmware_class.c | 11 ++++++++++-
>>>>>  1 file changed, 10 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
>>>>> index 58470c3..8ccf6cf4 100644
>>>>> --- a/drivers/base/firmware_class.c
>>>>> +++ b/drivers/base/firmware_class.c
>>>>> @@ -929,9 +929,18 @@ static int _request_firmware_load(struct firmware_priv *fw_priv,
>>>>>         cancel_delayed_work_sync(&fw_priv->timeout_work);
>>>>>         if (is_fw_load_aborted(buf))
>>>>>                 retval = -EAGAIN;
>>>>> -       else if (!buf->data)
>>>>> +       else if (!buf->data) {
>>>>>                 retval = -ENOMEM;
>>>>>
>>>>> +               /*
>>>>> +                * We failed loading, but abort was never done so we
>>>>> +                * need to remove it from the pending list ourselves.
>>>>> +                */
>>>>> +               mutex_lock(&fw_lock);
>>>>> +               list_del_init(&buf->pending_list);
>>>>> +               mutex_unlock(&fw_lock);
>>> The buf is always removed before the complete_all(), isn't it? Or did
>>> you observe the issue?
>>
>> Not in the case where userspacehelper fails. Yes, this is not a theoretical
>> thing and can be easily reproduced.
> 
> OK, I am just curious how it is triggered.
> 
> One situation I thought of is that the request context is interrupted
> by signal after wait_for_completion() becomes interruptable, and the
> fix should abort the request if retval is -ERESTARTSYS.
> 
> Or could you share how to reproduce if it isn't above case?

It's pretty simple, just abort it once with Ctrl-C:

# echo test > /sys/devices/virtual/misc/test_firmware/trigger_request
[   30.058867] test_firmware: loading 'test
[   30.058867] '
[   30.076177] misc test_firmware: Direct firmware load for test
[   30.076177]  failed with error -2
[   30.078542] misc test_firmware: Falling back to user helper
^C
[   31.413539] test_firmware: load of 'test
[   31.413539] ' failed: -12
[   31.414858] test_firmware: loaded: 0

# echo boom > /sys/devices/virtual/misc/test_firmware/trigger_request
[   36.170485] test_firmware: loading 'boom
[   36.170485] '
[   36.184837] misc test_firmware: Direct firmware load for boom
[   36.184837]  failed with error -2
[   36.186851] misc test_firmware: Falling back to user helper
[   36.188806] ------------[ cut here ]------------
[   36.189599] WARNING: CPU: 0 PID: 8318 at lib/list_debug.c:26 __list_add+0x128/0x1d0()
[   36.191737] list_add corruption. next->prev should be prev (ffffffffba4228e0), but was ffff8800509df980. (next=ffff8800509df980).
[   36.193634] Modules linked in:
[   36.194274] CPU: 0 PID: 8318 Comm: sh Not tainted 3.19.0-rc3-next-20150107-sasha-00056-g2ee6177-dirty #1687
[   36.195870]  0000000000000000 0000000000000000 ffff880050e2b000 ffff88005039bbf8
[   36.197159]  ffffffffb7c4b527 0000000000000000 ffff88005039bc58 ffff88005039bc48
[   36.198446]  ffffffffae2c96ca ffffffffba422900 ffffffffafcef968 ffff88005039bc28
[   36.199752] Call Trace:
[   36.200476]  [<ffffffffb7c4b527>] dump_stack+0x4f/0x7b
[   36.201313]  [<ffffffffae2c96ca>] warn_slowpath_common+0xca/0x130
[   36.202425]  [<ffffffffafcef968>] ? __list_add+0x128/0x1d0
[   36.203293]  [<ffffffffae2c9776>] warn_slowpath_fmt+0x46/0x50
[   36.204204]  [<ffffffffafcef968>] __list_add+0x128/0x1d0
[   36.205045]  [<ffffffffb1052c94>] _request_firmware+0xf54/0x15e0
[   36.206053]  [<ffffffffafcdf4d7>] ? trigger_request_store+0x67/0x110
[   36.207053]  [<ffffffffb1053355>] request_firmware+0x35/0x50
[   36.207946]  [<ffffffffafcdf500>] trigger_request_store+0x90/0x110
[   36.208945]  [<ffffffffb1018300>] ? dev_driver_string+0x150/0x150
[   36.209924]  [<ffffffffb101833c>] dev_attr_store+0x3c/0x70
[   36.210862]  [<ffffffffae838769>] ? sysfs_file_ops+0x119/0x170
[   36.211811]  [<ffffffffae8388da>] sysfs_kf_write+0x11a/0x180
[   36.212707]  [<ffffffffae8387c0>] ? sysfs_file_ops+0x170/0x170
[   36.213644]  [<ffffffffae837261>] kernfs_fop_write+0x271/0x3b0
[   36.214557]  [<ffffffffae6e4466>] vfs_write+0x186/0x5d0
[   36.215406]  [<ffffffffae6e6c62>] SyS_write+0xb2/0x1a0
[   36.216245]  [<ffffffffb7cb896d>] system_call_fastpath+0x16/0x1b
[   36.217442] ---[ end trace 0f95e6ddae030fca ]---
[   36.218262] ------------[ cut here ]------------
[   36.218994] WARNING: CPU: 0 PID: 8318 at lib/list_debug.c:34 __list_add+0x17b/0x1d0()
[   36.220648] list_add double add: new=ffff8800509df980, prev=ffffffffba4228e0, next=ffff8800509df980.
[   36.222127] Modules linked in:
[   36.222636] CPU: 0 PID: 8318 Comm: sh Tainted: G        W       3.19.0-rc3-next-20150107-sasha-00056-g2ee6177-dirty #1687
[   36.224354]  0000000000000000 0000000000000000 ffff880050e2b000 ffff88005039bbf8
[   36.225587]  ffffffffb7c4b527 0000000000000000 ffff88005039bc58 ffff88005039bc48
[   36.226896]  ffffffffae2c96ca ffffffffba422900 ffffffffafcef9bb ffff88005039bc28
[   36.228126] Call Trace:
[   36.228538]  [<ffffffffb7c4b527>] dump_stack+0x4f/0x7b
[   36.229374]  [<ffffffffae2c96ca>] warn_slowpath_common+0xca/0x130
[   36.230562]  [<ffffffffafcef9bb>] ? __list_add+0x17b/0x1d0
[   36.231472]  [<ffffffffae2c9776>] warn_slowpath_fmt+0x46/0x50
[   36.232387]  [<ffffffffafcef9bb>] __list_add+0x17b/0x1d0
[   36.233258]  [<ffffffffb1052c94>] _request_firmware+0xf54/0x15e0
[   36.234282]  [<ffffffffafcdf4d7>] ? trigger_request_store+0x67/0x110
[   36.235311]  [<ffffffffb1053355>] request_firmware+0x35/0x50
[   36.236231]  [<ffffffffafcdf500>] trigger_request_store+0x90/0x110
[   36.237229]  [<ffffffffb1018300>] ? dev_driver_string+0x150/0x150
[   36.238258]  [<ffffffffb101833c>] dev_attr_store+0x3c/0x70
[   36.239127]  [<ffffffffae838769>] ? sysfs_file_ops+0x119/0x170
[   36.240202]  [<ffffffffae8388da>] sysfs_kf_write+0x11a/0x180
[   36.241106]  [<ffffffffae8387c0>] ? sysfs_file_ops+0x170/0x170
[   36.242131]  [<ffffffffae837261>] kernfs_fop_write+0x271/0x3b0
[   36.243081]  [<ffffffffae6e4466>] vfs_write+0x186/0x5d0
[   36.243924]  [<ffffffffae6e6c62>] SyS_write+0xb2/0x1a0
[   36.244758]  [<ffffffffb7cb896d>] system_call_fastpath+0x16/0x1b
[   36.245730] ---[ end trace 0f95e6ddae030fcb ]---


Thanks,
Sasha
