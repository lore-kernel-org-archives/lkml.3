Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933311AbaKMQir (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 11:38:47 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:44274 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbaKMQiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 11:38:46 -0500
MIME-Version: 1.0
In-Reply-To: <20141113112017.GA14416@pd.tnic>
References: <1415731396-19364-1-git-send-email-ross.zwisler@linux.intel.com>
 <1415731396-19364-7-git-send-email-ross.zwisler@linux.intel.com>
 <5464220D.6090204@amacapital.net> <20141113112017.GA14416@pd.tnic>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 13 Nov 2014 08:38:23 -0800
Message-ID: <CALCETrV2E-LBHLTV6zJ=nfw8ijjV8VZoYAinXdg9ZaOryfqquw@mail.gmail.com>
Subject: Re: [PATCH 6/6] x86: Use clwb in drm_clflush_virt_range
To: Borislav Petkov <bp@alien8.de>
Cc: DRI <dri-devel@lists.freedesktop.org>,
        Ross Zwisler <ross.zwisler@linux.intel.com>, X86 ML <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, David Airlie <airlied@linux.ie>,
        H Peter Anvin <h.peter.anvin@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 13, 2014 3:20 AM, "Borislav Petkov" <bp@alien8.de> wrote:
>
> On Wed, Nov 12, 2014 at 07:14:21PM -0800, Andy Lutomirski wrote:
> > On 11/11/2014 10:43 AM, Ross Zwisler wrote:
> > > If clwb is available on the system, use it in drm_clflush_virt_range.
> > > If clwb is not available, fall back to clflushopt if you can.
> > > If clflushopt is not supported, fall all the way back to clflush.
> >
> > I don't know exactly what drm_clflush_virt_range (and the other
> > functions you're modifying similarly) are for, but it seems plausible to
> > me that they're used before reads to make sure that non-coherent memory
> > sees updated data.  If that's true, then this will break it.
>
> Why would it break it? The updated cachelines will be in memory and
> subsequent reads will be serviced from the cache instead from going to
> memory as it is not invalidated as it would be by CLFLUSH.
>
> /me is puzzled.

Suppose you map some device memory WB, and then the device
non-coherently updates.  If you want the CPU to see it, you need
clflush or clflushopt.  Some architectures might do this for
dma_sync_single_for_cpu with DMA_FROM_DEVICE.

I'm not sure that such a thing exists on x86.

--Andy
