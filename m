Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbaL2JQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 04:16:33 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:12461 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbaL2JQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 04:16:30 -0500
Message-ID: <54A11B95.2050103@atmel.com>
Date: Mon, 29 Dec 2014 17:15:01 +0800
From: "Wu, Songjun" <songjun.wu@atmel.com>
Organization: ATMEL
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Bo Shen <voice.shen@atmel.com>
CC: <linux-kernel@vger.kernel.org>, <nicolas.ferre@atmel.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: =?UTF-8?B?55yL55yL6L+Z5qC35Zue5aSN5Y+v5Lul5ZCX77yfIFJlOiBbUEFUQ0g=?=
 =?UTF-8?B?XSBVU0I6IGdhZGdldDogdWRjOiBhdG1lbDogZml4IHBvc3NpYmxlIG9vcHMgd2g=?=
 =?UTF-8?B?ZW4gdW5sb2FkaW5nIG1vZHVsZQ==?=
References: <1419240374-12179-1-git-send-email-songjun.wu@atmel.com> <20141223162419.GB9147@saruman> <549A138D.50204@atmel.com> <20141226152707.GG17430@saruman>
In-Reply-To: <20141226152707.GG17430@saruman>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/26/2014 23:27, Felipe Balbi wrote:
> Hi,
>
> On Wed, Dec 24, 2014 at 09:14:53AM +0800, Wu, Songjun wrote:
>>
>> 在 12/24/2014 00:24, Felipe Balbi 写道:
>>> On Mon, Dec 22, 2014 at 05:26:14PM +0800, Songjun Wu wrote:
>>>> When unloading the module, the urb request will be dequeued
>>>> and the completion routine will be excuted.
>>>> If no urb packet, the urb request will not be added to the endpoint queue
>>>> and the completion routine pointer in urb request is NULL.
>>>> Accessing to the NULL function pointer will cause the oops issue.
>>>> Add the code to check the urb request is in the endpoint queue or not.
>>>> If the urb request is not in the endpoint queue, a negative error code
>>>> will be returned.
>>>
>>> have you triggered the NULL pointer oops ? Care to add it to the commit
>>> log.
>>
>> Executing the 'insmod g_hid.ko', then executing the 'rmmod g_hid.ko', the
>> NULL pointer oops will be triggered.
>
> what about all my other queries below and what about adding the oops
> dump to commit log ?
>
>>> Also, which commit is this fixing ? Does this need to be backported ?
>>> When was the bug introduced ?
>

Fixes: commit a81ca786d049f3ac4b6062bfb426b468a5e02a3b

This bug was introduced since the file atmel_usba_udc.c was initialized.

The oops dump log is shown in the following.
# insmod g_hid.ko
g_hid gadget: HID Gadget, version: 2010/03/16
g_hid gadget: g_hid ready
# rmmod g_hid.ko
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = dedf0000
[00000000] *pgd=3ede5831, *pte=00000000, *ppte=00000000
Internal error: Oops: 80000007 [#1] ARM
Modules linked in: g_hid(-) usb_f_hid libcomposite
CPU: 0 PID: 923 Comm: rmmod Not tainted 3.18.0+ #2
Hardware name: Atmel SAMA5 (Device Tree)
task: df6b1100 ti: dedf6000 task.ti: dedf6000
PC is at 0x0
LR is at usb_gadget_giveback_request+0xc/0x10
pc : [<00000000>]    lr : [<c02ace88>]    psr: 60000093
sp : dedf7eb0  ip : df572634  fp : 00000000
r10: 00000000  r9 : df52e210  r8 : 60000013
r7 : df6a9858  r6 : df52e210  r5 : df6a9858  r4 : df572600
r3 : 00000000  r2 : ffffff98  r1 : df572600  r0 : df6a9868
Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 10c53c7d  Table: 3edf0059  DAC: 00000015
Process rmmod (pid: 923, stack limit = 0xdedf6230)
Stack: (0xdedf7eb0 to 0xdedf8000)
7ea0:                                     00000000 c02adbbc df572580 
deced608
7ec0: df572600 df6a9868 df572634 c02aed3c df577c00 c01b8608 00000000 
df6be27c
7ee0: 00200200 00100100 bf0162f4 c000e544 dedf6000 00000000 00000000 
bf010c00
7f00: bf0162cc bf00159c 00000000 df572980 df52e218 00000001 df5729b8 
bf0031d0
7f20: bf003234 df52e400 df52e400 a0000013 00000081 c02acee0 00000000 
c02ad570
7f40: bf0160b0 bf016290 00000000 bf0160c0 bf0167a0 c0056748 00000022 
69685f67
7f60: b6ff0064 00000001 b6ff3000 00000000 dedf6000 00000000 bebaaa4c 
c008370c
7f80: 00100871 c0081078 00000022 df5f31e8 b6ff4518 00000000 0001c588 
69685f67
7fa0: b6ff0064 c000e3c0 0001c588 69685f67 bebaab78 00000880 bebaab78 
00000880
7fc0: 0001c588 69685f67 b6ff0064 00000081 bebaae14 00000000 0000009f 
00000000
7fe0: bebaab70 bebaab60 0001c464 b6f69ba0 60000010 bebaab78 3fffd821 
3fffdc21
[<c02ace88>] (usb_gadget_giveback_request) from [<c02adbbc>] 
(request_complete+0x64/0x88)
[<c02adbbc>] (request_complete) from [<c02aed3c>] 
(usba_ep_dequeue+0x70/0x128)
[<c02aed3c>] (usba_ep_dequeue) from [<bf010c00>] (hidg_unbind+0x50/0x7c 
[usb_f_hid])
[<bf010c00>] (hidg_unbind [usb_f_hid]) from [<bf00159c>] 
(remove_config.isra.6+0x98/0x9c [libcomposite])
[<bf00159c>] (remove_config.isra.6 [libcomposite]) from [<bf0031d0>] 
(__composite_unbind+0x34/0x98 [libcomposite])
[<bf0031d0>] (__composite_unbind [libcomposite]) from [<c02acee0>] 
(usb_gadget_remove_driver+0x50/0x78)
[<c02acee0>] (usb_gadget_remove_driver) from [<c02ad570>] 
(usb_gadget_unregister_driver+0x64/0x94)
[<c02ad570>] (usb_gadget_unregister_driver) from [<bf0160c0>] 
(hidg_cleanup+0x10/0x34 [g_hid])
[<bf0160c0>] (hidg_cleanup [g_hid]) from [<c0056748>] 
(SyS_delete_module+0x118/0x19c)
[<c0056748>] (SyS_delete_module) from [<c000e3c0>] 
(ret_fast_syscall+0x0/0x30)
Code: bad PC value
---[ end trace dd1fcf365005ba79 ]---
Segmentation fault
#
