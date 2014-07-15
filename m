Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933414AbaGOTxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 15:53:55 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:54879 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933172AbaGOTxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 15:53:52 -0400
MIME-Version: 1.0
In-Reply-To: <1405452884-25688-1-git-send-email-toshi.kani@hp.com>
References: <1405452884-25688-1-git-send-email-toshi.kani@hp.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 15 Jul 2014 12:53:30 -0700
Message-ID: <CALCETrVfqBpJaTJCnDH8pZf4-6x6oojv+8Vvm3XudJfhbstdOQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/11] Support Write-Through mapping on x86
To: Toshi Kani <toshi.kani@hp.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, plagnioj@jcrosoft.com,
        tomi.valkeinen@ti.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefan Bader <stefan.bader@canonical.com>,
        Dave Airlie <airlied@gmail.com>, Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 12:34 PM, Toshi Kani <toshi.kani@hp.com> wrote:
> This RFC patchset is aimed to seek comments/suggestions for the design
> and changes to support of Write-Through (WT) mapping.  The study below
> shows that using WT mapping may be useful for non-volatile memory.
>
>   http://www.hpl.hp.com/techreports/2012/HPL-2012-236.pdf
>
> There were idea & patches to support WT in the past, which stimulated
> very valuable discussions on this topic.
>
>   https://lkml.org/lkml/2013/4/24/424
>   https://lkml.org/lkml/2013/10/27/70
>   https://lkml.org/lkml/2013/11/3/72
>
> This RFC patchset tries to address the issues raised by taking the
> following design approach:
>
>  - Keep the MTRR interface
>  - Keep the WB, WC, and UC- slots in the PAT MSR
>  - Keep the PAT bit unused
>  - Reassign the UC slot to WT in the PAT MSR
>
> There are 4 usable slots in the PAT MSR, which are currently assigned to:
>
>   PA0/4: WB, PA1/5: WC, PA2/6: UC-, PA3/7: UC
>
> The PAT bit is unused since it shares the same bit as the PSE bit and
> there was a bug in older processors.  Among the 4 slots, the uncached
> memory type consumes 2 slots, UC- and UC.  They are functionally
> equivalent, but UC- allows MTRRs to overwrite it with WC.  All interfaces
> that set the uncached memory type use UC- in order to work with MTRRs.
> The PA3/7 slot is effectively unused today.  Therefore, this patchset
> reassigns the PA3/7 slot to WT.  If MTRRs get deprecated in future,
> UC- can be reassigned to UC, and there is still no need to consume
> 2 slots for the uncached memory type.

Note that MTRRs are already partially deprecated: all drivers *should*
be using arch_phys_wc_add, not mtrr_add, and arch_phys_wc_add is a
no-op on systems with working PAT.

Unfortunately, I never finished excising mtrr_add.  Finishing the job
wouldn't be very hard.

--Andy
