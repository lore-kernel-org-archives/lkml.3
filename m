Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbaKXOcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 09:32:17 -0500
Received: from arrakis.dune.hu ([78.24.191.176]:39239 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753414AbaKXOcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 09:32:14 -0500
MIME-Version: 1.0
In-Reply-To: <1416796846-28149-7-git-send-email-cernekee@gmail.com>
References: <1416796846-28149-1-git-send-email-cernekee@gmail.com> <1416796846-28149-7-git-send-email-cernekee@gmail.com>
From: Jonas Gorski <jogo@openwrt.org>
Date: Mon, 24 Nov 2014 15:31:27 +0100
Message-ID: <CAOiHx=ntm7AO5BU2Ge0JDC5nDgXSZwQDm05s5VTM8mLqYmCZRw@mail.gmail.com>
Subject: Re: [PATCH V3 06/11] irqchip: bcm7120-l2: Change DT binding to allow
 non-contiguous IRQEN/IRQSTAT
To: Kevin Cernekee <cernekee@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jon Fraser <jfraser@broadcom.com>, Dmitry Torokhov <dtor@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        computersforpeace@gmail.com,
        MIPS Mailing List <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 3:40 AM, Kevin Cernekee <cernekee@gmail.com> wrote:
> To date, all supported controllers have had the IRQEN register at offset
> 0x00 and the IRQSTAT register at 0x04.  So in DT we would typically see
> something like:
>
>     reg = <0xf0406800 0x8>;
>
> We still want to support this format, but we also need to support cases
> where IRQEN and IRQSTAT aren't adjacent.  So, we will amend the driver to
> accept an alternate format that looks like this:
>
>     reg = <0xf0406800 0x4 0xf0406804 0x4>;
>
> i.e. if the first resource_size() == 4, assume that the first resource
> points to IRQEN and that the next resource points to IRQSTAT.  If the
> first resource_size() == 8, retain the current behavior.
>
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>

Hmm ... the more I think about this, the less I like it.

Using the amount and size of the reg-properties to infer a certain
layout seems rather hackish and dirty to me. Maybe we should just use
different compatible match ids for that? E.g. brcm,bm7120-l2-intc for
the 32-bit en/stat pairs, and e.g. brcm,bcm6368-l2-intc for the 64-bit
wide one. Or maybe make the bcm63xx one a separate driver and let it
share code with the bcm7120-l2-intc driver.

This would avoid having to specify a lot of regs (let's assume we also
add support for affinity), and cause a lot of io(re)map calls - the
bcm63268 one would currently look like:

        reg = <0x1000002c 0x4 0x1000003c 0x4>, /* irq 0..31 -> mips irq 2 */
               <0x10000028 0x4 0x10000038 0x4>,  /* irq 32..63 -> mips irq 2 */
               <0x10000024 0x4 0x10000034 0x4>, /* irq 64 .. 95 -> mips irq 2 */
               <0x10000020 0x4 0x10000030 0x4>, /* irq 96 .. 127 ->
mips irq 2 */
               <0x1000004c 0x4 0x1000005c 0x4>, /* irq 0.. 31 -> mips irq 3 */
               <0x10000048 0x4 0x10000058 0x4>, /* irq 32 .. 63 -> mips irq 3 */
               <0x10000044 0x4 0x10000054 0x4>, /* irq 64 ... 95 ->
mips irq 3 */
              <0x10000040 0x4 0x10000050 0x4>; /* irq 96 ... 127 ->
mips irq 3 */

where as with a different match id, we could rather allow something like

        reg = <0x10000020 0x20>, /* irq 0..127 -> mips irq 2 */
               <0x10000040 0x20>;   /* irq 0..127 -> mips irq 3 */


This would make the dts(i) files quite a bit more readable IMHO, and
make it more likely that newer dts(i) files work with older kernels,
e.g. where the mips irq3 routed registers were added - in the current
style, the kernel would interpret these as additional irq banks. Not
that I think this is expected/required to work, but it wouldn't hurt
having at least a bit of backward compatibility for bisecting on a
device that provides a newer dtb through the bootloader.


Jonas
