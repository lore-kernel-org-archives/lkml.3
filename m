Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbaFDMG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 08:06:27 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:19596 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbaFDMGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 08:06:25 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-86-538f0bbe2685
Message-id: <538F0BBD.2000605@samsung.com>
Date: Wed, 04 Jun 2014 14:06:21 +0200
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>, Wei.Yang@windriver.com,
        Michal Nazarewicz <mina86@mina86.com>
Cc: Felipe Balbi <balbi@ti.com>, gregkh@linuxfoundation.org,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] USB:gadget: Fix a warning while loading g_mass_storage
References: <Pine.LNX.4.44L0.1406031033010.1054-100000@iolanthe.rowland.org>
In-reply-to: <Pine.LNX.4.44L0.1406031033010.1054-100000@iolanthe.rowland.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t/xa7r7uPuDDfoOi1gcvF9v0bx4PZvF
	5V1z2CwWLWtltlhwvIXVYsLvC2wW998kOLB77J+7ht1j3Z9XTB6z7/5g9Dh+YzuTx+dNch7r
	t2xlCmCL4rJJSc3JLEst0rdL4MrY9sK9YL5qRf/kM8wNjE2yXYycHBICJhI9fz4xQthiEhfu
	rWfrYuTiEBJYyijR0/WTEcL5zCix8G8/G0gVr4CWxJnpl9hBbBYBVYndSw6wgthsAsYSew92
	gE0SFQiT6Dj1ghmiXlDix+R7LCC2iEC2xPl5P9lBhjILzGWUODD5JNhQYQE/iXVH74IVCQn4
	SPya9xaomYODU8BX4s1/DZAws4C1xMpJ2xghbHmJzWveMk9gFJiFZMUsJGWzkJQtYGRexSia
	WppcUJyUnmuoV5yYW1yal66XnJ+7iRES6l92MC4+ZnWIUYCDUYmH94NuX7AQa2JZcWXuIUYJ
	DmYlEd5JDP3BQrwpiZVVqUX58UWlOanFhxiZODilGhjVeELUlk/bdeTpzM/TfXsibNclzzeJ
	WB3icyntdaF1bYH92/ePrx7jqLvlHu5wK/+vXbDue8ddVZvad9w8M4vbsjvfM8DM/MRR9mjj
	kJMWGzeGcW4Pt8tLvGo+e+H3L+f082dVisfOc/Z8XDfbWO+ZaP7e6YILlzeUcmX0rLOoZ1UI
	W1GmdUKJpTgj0VCLuag4EQC68WvfUwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

W dniu 03.06.2014 16:48, Alan Stern pisze:
> On Tue, 3 Jun 2014 Wei.Yang@windriver.com wrote:
>
>> From: Yang Wei <Wei.Yang@windriver.com>
>>
>> While loading g_mass_storage module, the following warning is triggered.
>> In fact, it is more easy to reproduce it with RT kernel.
>>
>> WARNING: at drivers/usb/gadget/composite.c:
>> usb_composite_setup_continue: Unexpected call
>> Modules linked in: fat vfat minix nls_cp437 nls_iso8859_1 g_mass_storage
>> [<800179cc>] (unwind_backtrace+0x0/0x104) from [<80619608>] (dump_stack+0x20/0x24)
>> [<80619608>] (dump_stack+0x20/0x24) from [<80025100>] (warn_slowpath_common+0x64/0x74)
>> [<80025100>] (warn_slowpath_common+0x64/0x74) from [<800251cc>] (warn_slowpath_fmt+0x40/0x48)
>> [<800251cc>] (warn_slowpath_fmt+0x40/0x48) from [<7f047774>] (usb_composite_setup_continue+0xb4/0xbc [g_mass_storage])
>> [<7f047774>] (usb_composite_setup_continue+0xb4/0xbc [g_mass_storage]) from [<7f047ad4>] (handle_exception+0x358/0x3e4 [g_mass_storage])
>> [<7f047ad4>] (handle_exception+0x358/0x3e4 [g_mass_storage]) from [<7f048080>] (fsg_main_thread+0x520/0x157c [g_mass_storage])
>> [<7f048080>] (fsg_main_thread+0x520/0x157c [g_mass_storage]) from [<8004bc90>] (kthread+0x98/0x9c)
>> [<8004bc90>] (kthread+0x98/0x9c) from [<8000faec>] (kernel_thread_exit+0x0/0x8)
>>
>> The root cause just likes the following scenario.
>>
>> irq thread
>>
>> composite_disconnect()
>> |
>> |->fsg_disable() fsg->common->new_fsg = NULL
>>                   and then wake fsg_main_thread
>>                   with seting common->state to
>>                   FSG_STATE_CONFIG_CHANGE.
>>                                                      fsg_main_thread
>>                                                      |
>>                                                      |->do_set_interface()
>> irq thread
>>
>> set_config()
>> |
>> |->fsg_set_alt() fsg->common->new_fsg = new_fsg
>>                   and then also wake up fsg_main_thread
>>                   with setting common->state to
>>                   FSG_STATE_CONFIG_CHANGE.
>>                                                      |-> if(common->new_fsg)
>> 		                                                 usb_composite_setup_continue()
>>
>> In this case, fsg_main_thread would invoke usb_composite_setup_continue
>> twice, so the second call would trigger the above call trace, as we also
>> save common->new_fsg while changing the common->state.
>
> Michal and Andrzej:
>
> I haven't paid much attention to these matters, because you handled the
> conversion from g_file_storage to f_mass_storage using the composite
> framework.  But this patch seemed odd, so I took a closer look.

Actually when I started dealing with usb gadgets the f_mass_storage
had already been there. My involvement started with some cleanup,
then moving to the new function registration interface
(usb_get/put_function_instance(), usb_get/put_function())
and adding configfs support. That said, it is not impossible for me
to have spoilt something :O

>
> In f_mass_storage.c, struct fsg_common is shared among all the function
> instances.  This structure includes things like cmnd and nluns, which
> will in general be different for different functions.
>
> That's okay if each function is in a separate config, but what happens
> when there are multiple functions in the same config, using different
> interfaces?  What if the host sends concurrent commands to two of these
> functions?
>


When Sebastian introduced the function registration interface I didn't
specially like the naming: struct usb_function_instance is something
different than an instance of struct usb_function.

The purpose of fsg_alloc_inst() is to create a usb_function_instance
whose container_of is struct fsg_opts. In fact it is struct fsg_opts
which is actually allocated; one of its members is struct fsg_common
which is also allocated - individually for each struct usb_function_instance.

Among traditional gadgets there is no gadget which uses mass storage function
more than once. On the other hand, when gadgets are created with configfs
it is forbidden to link a given function more than once into a given
config, that is a struct usb_function_instance can be referenced by more
than one config, but can be referenced only once in a given config;
each symbolic link corresponds to an instance of struct usb_function
(don't confuse with struct usb_function_instance).
So yes, an fsg_common can be shared among instances of struct usb_function,
but neither with traditional gadgets as they are now nor with configfs
is it possible to have the same fsg_common referenced more than once
in a given config.

AP

