Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825Ab3DSJzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 05:55:09 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34633 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756774Ab3DSJzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 05:55:07 -0400
Date: Fri, 19 Apr 2013 10:54:45 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Colin Cross <ccross@android.com>
Cc: Rob Herring <robherring2@gmail.com>, Tony Luck <tony.luck@intel.com>,
        Kees Cook <keescook@chromium.org>, lkml <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 1/3] pstore-ram: use write-combine mappings
Message-ID: <20130419095445.GG14496@n2100.arm.linux.org.uk>
References: <1365563297-12480-1-git-send-email-robherring2@gmail.com> <CAMbhsRSvQPbzJ7Nt=OSSYE_A1e+eaUjO7XY+qRppJ5_gfWmW4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMbhsRSvQPbzJ7Nt=OSSYE_A1e+eaUjO7XY+qRppJ5_gfWmW4A@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 08:53:18PM -0700, Colin Cross wrote:
> On Tue, Apr 9, 2013 at 8:08 PM, Rob Herring <robherring2@gmail.com> wrote:
> > -       return ioremap(start, size);
> > +       return ioremap_wc(start, size);
> 
> ioremap_wc corresponds to MT_DEVICE_WC, which is still device memory,
> so I don't see how this helps solve the problem in the commit message.

In reality it isn't, because there's no such thing as "write combining
device memory" in the ARM memory model.

There are three major memory types: strongly ordered, device and normal
memory.  Only normal memory can be cached in any way, which includes
using write combining.

#define ioremap_wc(cookie,size) __arm_ioremap((cookie), (size), MT_DEVICE_WC)

        [MT_DEVICE_WC] = {      /* ioremap_wc */
                .prot_pte       = PROT_PTE_DEVICE | L_PTE_MT_DEV_WC,

         *                      n       TR      IR      OR
         *   BUFFERABLE         001     10      00      00
         *   DEV_WC             001     10
(see arch/arm/mm/proc-v7-2level.S for the rest of the table and its
description.)

So, DEV_WC is an alias for BUFFERABLE, which is normal memory,
uncacheable in both inner and outer caches.  This means that at the
moment, ioremap_wc() memory has the same properties as system memory
- with all the out of ordering effects you get there.

I don't put any guarantee on this though - we may end up having to
change it if we find a SoC needing this to really be device memory...
