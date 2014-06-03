Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbaFCOss (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 10:48:48 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42515 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753046AbaFCOsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 10:48:47 -0400
Date: Tue, 3 Jun 2014 10:48:45 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Wei.Yang@windriver.com, Michal Nazarewicz <mina86@mina86.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>
cc: Felipe Balbi <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] USB:gadget: Fix a warning while loading g_mass_storage
In-Reply-To: <1401788235-22621-1-git-send-email-Wei.Yang@windriver.com>
Message-ID: <Pine.LNX.4.44L0.1406031033010.1054-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2014 Wei.Yang@windriver.com wrote:

> From: Yang Wei <Wei.Yang@windriver.com>
> 
> While loading g_mass_storage module, the following warning is triggered.
> In fact, it is more easy to reproduce it with RT kernel.
> 
> WARNING: at drivers/usb/gadget/composite.c:
> usb_composite_setup_continue: Unexpected call
> Modules linked in: fat vfat minix nls_cp437 nls_iso8859_1 g_mass_storage
> [<800179cc>] (unwind_backtrace+0x0/0x104) from [<80619608>] (dump_stack+0x20/0x24)
> [<80619608>] (dump_stack+0x20/0x24) from [<80025100>] (warn_slowpath_common+0x64/0x74)
> [<80025100>] (warn_slowpath_common+0x64/0x74) from [<800251cc>] (warn_slowpath_fmt+0x40/0x48)
> [<800251cc>] (warn_slowpath_fmt+0x40/0x48) from [<7f047774>] (usb_composite_setup_continue+0xb4/0xbc [g_mass_storage])
> [<7f047774>] (usb_composite_setup_continue+0xb4/0xbc [g_mass_storage]) from [<7f047ad4>] (handle_exception+0x358/0x3e4 [g_mass_storage])
> [<7f047ad4>] (handle_exception+0x358/0x3e4 [g_mass_storage]) from [<7f048080>] (fsg_main_thread+0x520/0x157c [g_mass_storage])
> [<7f048080>] (fsg_main_thread+0x520/0x157c [g_mass_storage]) from [<8004bc90>] (kthread+0x98/0x9c)
> [<8004bc90>] (kthread+0x98/0x9c) from [<8000faec>] (kernel_thread_exit+0x0/0x8) 
> 
> The root cause just likes the following scenario.
> 
> irq thread
> 
> composite_disconnect()
> |
> |->fsg_disable() fsg->common->new_fsg = NULL
>                  and then wake fsg_main_thread
>                  with seting common->state to
>                  FSG_STATE_CONFIG_CHANGE.
>                                                     fsg_main_thread
>                                                     |
>                                                     |->do_set_interface()
> irq thread
> 
> set_config()
> |
> |->fsg_set_alt() fsg->common->new_fsg = new_fsg
>                  and then also wake up fsg_main_thread
>                  with setting common->state to
>                  FSG_STATE_CONFIG_CHANGE.
>                                                     |-> if(common->new_fsg)
> 		                                                 usb_composite_setup_continue()
> 
> In this case, fsg_main_thread would invoke usb_composite_setup_continue
> twice, so the second call would trigger the above call trace, as we also
> save common->new_fsg while changing the common->state.

Michal and Andrzej:

I haven't paid much attention to these matters, because you handled the 
conversion from g_file_storage to f_mass_storage using the composite 
framework.  But this patch seemed odd, so I took a closer look.

In f_mass_storage.c, struct fsg_common is shared among all the function
instances.  This structure includes things like cmnd and nluns, which
will in general be different for different functions.

That's okay if each function is in a separate config, but what happens
when there are multiple functions in the same config, using different
interfaces?  What if the host sends concurrent commands to two of these
functions?

Am I missing something?

Alan Stern

