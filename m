Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932563Ab3CTNYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 09:24:19 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:47241 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab3CTNYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 09:24:17 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1303191142330.15684-100000@netrider.rowland.org>
References: <CADB-GoLzX-G5j92oEsLeUq6PRpKwb15U6LL_jw4zh6Nhh+ZHLg@mail.gmail.com>
	<Pine.LNX.4.44L0.1303191142330.15684-100000@netrider.rowland.org>
Date: Wed, 20 Mar 2013 21:24:14 +0800
Message-ID: <CADB-GoLncGoXmJsxXPUZocz1fJe9uUBX+mtgBVkuUR1SqbOBEQ@mail.gmail.com>
Subject: Re: [PATCH] usb host: Faraday FUSBH200 HCD driver.
From: Yuan-Hsin Chen <yuanlmm@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Felipe Balbi <balbi@ti.com>, gregkh@linuxfoundation.org,
        sarah.a.sharp@linux.intel.com, Julia.Lawall@lip6.fr,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yuan-Hsin Chen <yhchen@faraday-tech.com>, john453@faraday-tech.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Mar 19, 2013 at 11:48 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Tue, 19 Mar 2013, Yuan-Hsin Chen wrote:
>
>> > What about the port_status registers?  They're not between command and
>> > async_next.  If they aren't consistent with EHCI, it makes things a lot
>> > more complicated.
>>
>> fusbh200 has only one port_status register with different offset,
>> 0x30, and the position of some bits are different from EHCI.

How about adding kernel configuration to adjust offset for FUSBH200 in
ehci_def.h? So port_status would be in offset 0x20 from ehci_regs.

For example,

        /* ASYNCLISTADDR: offset 0x18 */
        u32             async_next;     /* address of next async queue head */

#ifndef CONFIG_USB_EHCI_HCD_FUSBH200
        u32             reserved1[2];

        /* TXFILLTUNING: offset 0x24 */
        u32             txfill_tuning;  /* TX FIFO Tuning register */
#define TXFIFO_DEFAULT  (8<<16)         /* FIFO burst threshold 8 */

        u32             reserved2[6];

        /* CONFIGFLAG: offset 0x40 */
        u32             configured_flag;
#define FLAG_CF         (1<<0)          /* true: we'll support "high speed" */

#else
        u32             reserved1;
#endif
        /* PORTSC: offset 0x44 */
        u32             port_status[0]; /* up to N_PORTS */


Furthermore, there are PORT_POWER, PORT_OWNER, PORT_LED_XXX,
PORT_TEST, PORT_WKCONN_E, PORT_WKDISC_E, PORT_WKOC_E absent in
port_status of FUSBH200. Also PORT_OC and PORT_OCC are in another
register. Is it ok to use quirk flag also?

>
> That's pretty nasty.  Integrating that with the standard EHCI driver
> would be considerably more difficult.
>
> Why was the FUSBH200 designed in this strange way?  Why doesn't it use
> the standard EHCI register layout?  Were the engineers at Faraday
> deliberately trying to make life harder for driver writers?
>
>> Also, usbmode_ex, hostpc, and txfill_tuning other than configured_flag
>> are non-existent in fusbh200. They are used in both ehci-hcd.c and
>> ehci-hub.c for several times.
>
> They are used only if the hardware supports them, that is, only if the
> ehci->has_hostpc flag is set.
>
> Alan Stern
>

Thank you for your help.

Yuan-Hsin
