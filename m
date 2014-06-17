Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933709AbaFQU3o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 16:29:44 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:51900 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932927AbaFQU3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 16:29:43 -0400
Date: Tue, 17 Jun 2014 13:29:32 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Rob Herring <robh@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Subject: Re: Problems with commit 9ec36cafe4 (of/irq: do irq resolution in
 platform_get_irq) and mfd client devices
Message-ID: <20140617202932.GA31414@roeck-us.net>
References: <20140617181034.GA25854@roeck-us.net>
 <CAL_Jsq+TFKJN_-PowcAyYztXzcomeAiT70xg7FxKgEQoG=7tAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_Jsq+TFKJN_-PowcAyYztXzcomeAiT70xg7FxKgEQoG=7tAw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 03:08:24PM -0500, Rob Herring wrote:
> On Tue, Jun 17, 2014 at 1:10 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> > Hi,
> >
> > I have an mfd master and client drivers on a system which has devicetree
> > enabled. The mfd master driver passes interrupts to the clients using
> > mfd cells and 'struct resource'. The client driver is a platform driver
> > which retrieves the irq using platform_get_irq().
> >
> > After commit 9ec36cafe (of/irq: do irq resolution in platform_get_irq),
> > this code no longer works. This is because platform_get_irq() does no
> > longer call platform_get_resource() if OF is enabled and if dev->of_node
> > is not NULL (it is not NULL because there is other [static] information
> > which is passed to the client with devicetree data).
> >
> > Any idea how to solve this problem ? How do I now pass a virtual interrupt
> > from an mfd master to its clients if devicetree is enabled ?
> 
> The node ptr points to the MFD node or a child node? If there are
> child nodes in DT, then why not define interrupts there too? If there
> are not child nodes, then perhaps the child drivers should not have DT
> knowledge.
> 
There is a whole bunch of secondary data in the child's dt node.
One of the child/client drivers is an i2c controller with attached
i2c muxes and several i2c devices, another is a gpio controller
with a large number of gpio pins which itself acts as interrupt
controller.

> Does it fail to get an interrupt or gets the parent interrupt instead?
> 
It fails to get an interrupt and returns -EINVAL.

> We could probably make an error fall-back to looking at resources. Or
> try to get irq from resources first, then call of_irq_get.
> 
I submitted a patch implementing the first approach a few minutes ago.
That fixes the problem for me. Not sure if that is the right solution
though, as it doesn't handle -EPROBE_DEFER. Let me know when you see
the patch if there is a better way to handle it (maybe abort with
-EPROBE_DEFER if of_irq_get returns it would do).

Guenter
