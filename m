Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab3AUQaO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 11:30:14 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51245 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab3AUQaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 11:30:13 -0500
Date: Mon, 21 Jan 2013 16:29:41 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Matt Sealey <matt@genesi-usa.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        devel <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: Re: Compilation problem with drivers/staging/zsmalloc when !SMP on
	ARM
Message-ID: <20130121162941.GT23505@n2100.arm.linux.org.uk>
References: <CAKGA1b=ACTQHo9=B7EAG5nrFCO9u-J+sy7dXtYk3Rk6OUcW3cQ@mail.gmail.com> <20130118210859.GH23505@n2100.arm.linux.org.uk> <CAKGA1bmJ6c4LC=NAD4MU_rBZ2hZjf6qH=C+dqMCf0eP+2vSFdA@mail.gmail.com> <20130119044602.GC5391@phenom.dumpdata.com> <CAKGA1b=whdh9=ke0efUXnJdT-op=7G1uVh82=3OxT5GoHhWvdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKGA1b=whdh9=ke0efUXnJdT-op=7G1uVh82=3OxT5GoHhWvdA@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 10:20:38AM -0600, Matt Sealey wrote:
> See previous mail to Minchan; local_tlb_flush_kernel_range calls
> cpu_tlb.flush_kernel_range on SMP, but a direct function call
> ("glue(_TLB, flush_kernel_range)" which resolves to
> v7wbi_flush_kernel_range etc. etc.) without CONFIG_SMP.

Actually, that's wrong - it's got nothing to do with SMP vs non-SMP.

It's more to do with which CPUs are being supported.  If they all use one
single cache maintanence implementation, then direct calls are used as an
optimization.  If they require more than one cache maintanence
implementation, they are indirect calls.  SMP really doesn't come into
that decision.

So:

> >> diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c
> >> b/drivers/staging/zsmalloc/zsmalloc-main.c
> >> index 09a9d35..ecf75fb 100644
> >         > --- a/drivers/staging/zsmalloc/zsmalloc-main.c
> >> +++ b/drivers/staging/zsmalloc/zsmalloc-main.c
> >> @@ -228,7 +228,7 @@ struct zs_pool {
> >>   * mapping rather than copying
> >>   * for object mapping.
> >>  */
> >> -#if defined(CONFIG_ARM)
> >> +#if defined(CONFIG_ARM) && defined(CONFIG_SMP)

Would be wrong.
