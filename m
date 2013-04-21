Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521Ab3DUClB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 22:41:01 -0400
Received: from mail-da0-f50.google.com ([209.85.210.50]:55363 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab3DUClA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 22:41:00 -0400
MIME-Version: 1.0
In-Reply-To: <1363145021-14339-1-git-send-email-s-anna@ti.com>
References: <1363145021-14339-1-git-send-email-s-anna@ti.com>
Date: Sun, 21 Apr 2013 08:10:59 +0530
Message-ID: <CABb+yY0RYkVeo2Sb4WsDJY0jf17488FEz0d2CB994eQaSOEsVg@mail.gmail.com>
Subject: Re: [PATCHv3 00/14] drivers: mailbox: framework creation
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Suman Anna <s-anna@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suman,

  [Resending with mailing-list CCed this time. For some reason LKML
doesn't appear in reply-to despite this message being fwd'ed from
there]

On Wed, Mar 13, 2013 at 8:53 AM, Suman Anna <s-anna@ti.com> wrote:
> Hi,
> Please find the updated mailbox patch series for pulling into linux-next.
> The series is rebased on top of 3.9-rc2, and includes one new patch to
> rename an existing mailbox.h added as part of the highbank cpufreq
> support for 3.9 merge window [1].
>
I am to implement IPC protocol and client drivers on a platform that
has a master processor having control over critical h/w resources,
like clock and power management, to be used by the MPCore running
linux. And there are 2 such IPC controllers - one for communication
within the MPCore and another for between MPCore and the 'Master'.

I have a few concerns about this api as follows...

a) No documentation. Usually the header would have proper
documentation of data structures and info for users of both side of
the api.

b) The api is not scalable. The assumption of just one IPC controller
in the platform is hardcoded.

c) There seems to be no consistent design - mailbox_ops has 12
callback hooks. Some, save_ctx, restore_ctx, enable_irq, disable_irq
are exported for no apparent reason (legacy of a legacy - OMAP), while
other hooks are kept private to the api.
I believe OMAP had valid reasons to make IPC clients save/restore
context of the IPC controller, but I don't think that is the case in
general. I2C client drivers don't save/restore context of I2C
controller's, why should IPC's?  Similarly enable/disable_irq of the
controller seem too intrusive for a client driver.

mailbox_ops.mailbox_type_t makes no sense to me. At least not without
documentation, though I doubt any amount of documentation could help
it - mailbox.c doesn't even read the member. Btw, isn't every mailbox
a MBOX_SHARED_MEM_TYPE? A part of data passed via FIFO/REG could point
to location in shared memory that might have full command/payload for
the message. Or did I get the meaning of MBOX_SHARED_MEM_TYPE wrong in
the absence of documentation?

The api seems to worry too much about the low-level details of the IPC
controller (save/restore context, enable/disable_irq and ack_irq),
while it fails to provide a tight well-defined interface to client
drivers.

There are also some code issues, which might come as replies to
respective patches.

Regards,
-Jassi
