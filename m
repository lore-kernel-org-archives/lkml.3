Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806Ab3FJFYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 01:24:20 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:62864 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab3FJFYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 01:24:16 -0400
MIME-Version: 1.0
In-Reply-To: <1369950320-22784-1-git-send-email-stepanm@codeaurora.org>
References: <1369950320-22784-1-git-send-email-stepanm@codeaurora.org>
Date: Mon, 10 Jun 2013 14:24:14 +0900
Message-ID: <CANqRtoQERw46u7qyUPavd7XCj5P8TMVFFNy-xjEBMDEoR7U1Qw@mail.gmail.com>
Subject: Re: [PATCH] arm: Prevent memory aliasing on non-LPAE kernels
From: Magnus Damm <magnus.damm@gmail.com>
To: Stepan Moskovchenko <stepanm@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Stepan,

On Fri, May 31, 2013 at 6:45 AM, Stepan Moskovchenko
<stepanm@codeaurora.org> wrote:
> Some LPAE-capable systems may use a Device Tree containing
> memory nodes that describe memory extending beyond the 4GB
> physical address boundary. Ignore or truncate these memory
> nodes on kernels that have not been built with LPAE
> support, to prevent the extended physical addresses from
> being truncated and aliasing with physical addresses below
> the 4GB boundary.
>
> Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
> ---
>  arch/arm/kernel/devtree.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)

Thanks for your efforts on fixing this issue. Before I was aware of
this patch I wrote a different implementation to solve most likely the
same issue, please see the following patches for more information.
Thanks to Arnd for pointing me in the right direction.

[PATCH 00/03] ARM: 64-bit memory fixes, APE6EVM second memory bank
[PATCH 01/03] ARM: Let arm_add_memory() always use 64-bit arguments
[PATCH 02/03] ARM: Handle 64-bit memory in case of 32-bit phys_addr_t
[PATCH 03/03] ARM: shmobile: Add second memory bank to DTS for APE6EVM

Regarding this patch, I have now tested it on my APE6EVM board
together with this patch:

[PATCH 03/03] ARM: shmobile: Add second memory bank to DTS for APE6EVM

Without your patch the situation is as follows:

HIGHMEM=n, LPAE=n - OK (busted, second bank ignored with message [1])
HIGHMEM=y, LPAE=n - NG (busted, board hangs on boot)
HIGHMEM=n, LPAE=y - OK
HIGHMEM=y, LPAE=y - OK

[1] Ignoring RAM at 00000000-3fffffff (vmalloc region overlap).

With your patch applied I get the following:

HIGHMEM=n, LPAE=n - OK (with message [2])
HIGHMEM=y, LPAE=n - OK (with message [2])
HIGHMEM=n, LPAE=y - OK
HIGHMEM=y, LPAE=y - OK

[2] Ignoring memory at 0x200000000 due to lack of LPAE support


So your patch unbreaks the second memory on my board perfectly well, thank you!

Regarding implementation details, I wonder if we only need to cover
the DT memory banks by performing the check inside
early_init_dt_add_memory_arch()?

To me the root cause of this issue seems to be how phys_addr_t is
configured when LPAE=n. It is understandable that the kernel cannot
handle 64-bit addresses when phys_addr_t is 32-bit, but I believe we
need some sane way to omit those memory banks. Your patch handles the
non-LPAE case before phys_addr_t is involved which seems to work well.
Your approach is much better compared to as-is today with potentially
wrapping phys_addr_t parameters to arm_add_memory().

The only question in my mind is about the location for this kind of
test, shall it be done in early_init_dt_add_memory_arch() or
arm_add_memory()?

If we care about adding some bounds checking for the kernel command
line mem=xxx option then arm_add_memory() seems to be the best
location from my point of view.

Any ideas?

Please add me to CC if you respin your patch. I will give it a go on my board.

Thanks,

/ magnus
