Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412AbaI2KX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 06:23:58 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:61727 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbaI2KX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 06:23:57 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7f776d000003e54-5e-5429333ac652
Content-transfer-encoding: 8BIT
Message-id: <1411986225.6035.4.camel@AMDC1943>
Subject: Re: [RFC PATCH] extcon: Fix sleeping in atomic context after
 connecting USB cable
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: myungjoo.ham@samsung.com
Cc: =?UTF-8?Q?=EC=B5=9C=EC=B0=AC=EC=9A=B0?= <cw00.choi@samsung.com>,
        Felipe Balbi <balbi@ti.com>,
        =?UTF-8?Q?=EC=9A=B0=EC=83=81=EC=A0=95?= <sangjung.woo@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?Q?=ED=95=9C=EC=A7=84=EA=B5=AC?= <jg1.han@samsung.com>,
        =?UTF-8?Q?=EB=B0=95=EA=B2=BD=EB=AF=BC?= <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Mon, 29 Sep 2014 12:23:45 +0200
In-reply-to: <368375031.68241411964736944.JavaMail.weblogic@epmlwas08a>
References: <368375031.68241411964736944.JavaMail.weblogic@epmlwas08a>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t/xK7pWxpohBrNXG1tsnLGe1eLg/XqL
	61+es1o0L17PZnF54SVWi7NNb9gtLu+aw2ax9shddovbjSvYLBbsKXHg8tg/dw27R9+WVYwe
	x29sZ/L4vEkugCWKyyYlNSezLLVI3y6BK6P7RXTBZpmKrbv2MzYw/hHvYuTkkBAwkVg7bxET
	hC0mceHeerYuRi4OIYGljBLXXnWygyR4BQQlfky+x9LFyMHBLCAvceRSNkiYWUBdYtK8RcwQ
	9Z8ZJd68WcAIUa8nsWvFYbChwgIxEkcbe8DibALGEpuXL2EDsUUEZCSubtzOAtLMLNDNIrHm
	502wIhYBVYlN7zezgticAu4SD5acBDtCSMBN4sKWqawgR0gIKEs09rtNYBSYheS8WQjnzUJy
	3gJG5lWMoqmlyQXFSem5RnrFibnFpXnpesn5uZsYIQH/dQfj0mNWhxgFOBiVeHg5VmiECLEm
	lhVX5h5ilOBgVhLh/aCmGSLEm5JYWZValB9fVJqTWnyIkYmDU6qBsc9wepjKsnulsZVhHf3H
	Hs9Yba2U/4u36bFZoao07/M/u6XWFp6LU5boCmzsVrjhI3Nhr5uI5EmDBrvr+c83uxQdenGC
	v92uOFuP127avJvbme8vMFyyNG7T2fVT2hV3FO2wYUv6v3+v9kxvN8MN3w0e/j+5bIWpTJb2
	xeqETeVT+6+dt2lZpsRSnJFoqMVcVJwIAPiYTTBWAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pon, 2014-09-29 at 04:25 +0000, 함명주 wrote:
> >   
> >  Kernel built with extcon and charger-manager.
> > 
> > After connecting the USB cable sleeping function was called from atomic
> > context:
> > [   63.328648] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:586
> []
> > [   63.388743] Workqueue: events max14577_muic_irq_work
> > [   63.393707] [<c00167a4>] (unwind_backtrace) from [<c0012c08>] (show_stack+0x10/0x14)
> > [   63.401422] [<c0012c08>] (show_stack) from [<c06232ec>] (dump_stack+0x70/0xbc)
> > [   63.408625] [<c06232ec>] (dump_stack) from [<c0629d0c>] (mutex_lock_nested+0x24/0x410)
> > [   63.416525] [<c0629d0c>] (mutex_lock_nested) from [<c0354474>] (regmap_read+0x30/0x60)
> > [   63.424424] [<c0354474>] (regmap_read) from [<c0406b84>] (max14577_charger_get_property+0x1e4/0x250)
> > [   63.433535] [<c0406b84>] (max14577_charger_get_property) from [<c0403834>] (is_ext_pwr_online+0x30/0x6c)
> > [   63.442994] [<c0403834>] (is_ext_pwr_online) from [<c0404a54>] (charger_extcon_notifier+0x40/0x70)
> > [   63.451934] [<c0404a54>] (charger_extcon_notifier) from [<c044cbe4>] (_call_per_cable+0x40/0x4c)
> > [   63.460704] [<c044cbe4>] (_call_per_cable) from [<c0051560>] (notifier_call_chain+0x64/0x128)
> > [   63.469209] [<c0051560>] (notifier_call_chain) from [<c0051640>] (raw_notifier_call_chain+0x18/0x20)
> > [   63.478321] [<c0051640>] (raw_notifier_call_chain) from [<c044d0fc>] (extcon_update_state+0xa8/0x204)
> > [   63.487522] [<c044d0fc>] (extcon_update_state) from [<c044e5f8>] (max14577_muic_chg_handler+0xdc/0x180)
> > [   63.496897] [<c044e5f8>] (max14577_muic_chg_handler) from [<c044e924>] (max14577_muic_irq_work+0x7c/0xd8)
> > [   63.506445] [<c044e924>] (max14577_muic_irq_work) from [<c004480c>] (process_one_work+0x198/0x66c)
> > [   63.515385] [<c004480c>] (process_one_work) from [<c0044d4c>] (worker_thread+0x38/0x564)
> > [   63.523455] [<c0044d4c>] (worker_thread) from [<c004c4ec>] (kthread+0xcc/0xe8)
> > [   63.530661] [<c004c4ec>] (kthread) from [<c000f1f8>] (ret_from_fork+0x14/0x3c)
> > [   63.543926] charger_manager: Set current limit of CHARGER : 450000uA ~ 450000uA
> > [   63.548870] extcon-port jack: jack event CHGDET=usb
> > [   63.550592] extcon-port jack: jack event CHGDET=charger
> > [   64.188607] charger-manager charger-manager@0: Failed to get battery temperature
> > [   64.200684] charger-manager charger-manager@0: CHARGING
> > 
> > The first sleeping function is is_ext_pwr_online()
> > (drivers/power/charger-manager.c). The atomic context initiating the
> > flow is set up in extcon_update_state() (drivers/extcon/extcon-class.c).
> > 
> > The extcon_update_state() uses spin locks which are not necessary
> > because the function is not called from interrupt service routines.
> > Instead, the extcon_update_state() is called from:
> > 1. Threaded interrupt handlers.
> > 2. Work queues.
> > 
> > Replace the spin lock with mutex and update the documentation of this
> > function.
> 
> No. You've done it in the opposite way.
> 
> update_state is often called in a interrupt handler that cannot sleep.
> 
> For the context you've mentioned, we'd need workqueue invoked by
> _call_per_cable or notifier callback.

I'm still not convinced that calling raw_notifier_chain under spin lock
in extcon_update_state() is safe. I think it is not safe because current
design implies silently that all notifiers registered with
extcon_register_notifier() must not sleep.

_call_per_cable() is just one of ways to trigger this issue.

Best regards,
Krzysztof



