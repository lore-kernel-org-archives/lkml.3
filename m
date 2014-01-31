Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932971AbaAaVdO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 16:33:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932271AbaAaVdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 16:33:13 -0500
Message-ID: <1391203964.6959.141.camel@bling.home>
Subject: Re: Regression due to 0c44c2d0f459 x86: Use asm goto to implement
 better modify_and_test() functions
From: Alex Williamson <alex.williamson@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 31 Jan 2014 14:32:44 -0700
In-Reply-To: <529F5C02.2060706@zytor.com>
References: <529E8719.4070202@zytor.com> <20131204085953.GC31778@gmail.com>
	 <529F5C02.2060706@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-04 at 08:44 -0800, H. Peter Anvin wrote:
> On 12/04/2013 12:59 AM, Ingo Molnar wrote:
> > 
> > * H. Peter Anvin <hpa@zytor.com> wrote:
> > 
> >> Hi guys,
> >>
> >> 0c44c2d0f459 x86: Use asm goto to implement better modify_and_test()
> >> functions
> >>
> >> causes a regression, because it incorrectly changed the constraints of
> >> bitops.
> >>
> >> Specifically, the GEN_BINARY_RMWcc() hardcodes a constraint as "er", but
> >> it needs to be "Ir" for the bitops themselves.  "I" is correct (as
> >> opposed to "J" even on 64 bits, because we only generate the 64-bit
> >> version when we have a register operand.
> >>
> >> Unfortunately there isn't a way we can get gcc+gas to generate a version
> >> with an offset pointer.
> > 
> > Does the regression manifest itself in any actual breakage - if yes, 
> > how does it look like? (People experiencing similar symptoms will be 
> > helped by seeing a fix matching their problems.)
> > 
> 
> It was discovered because it caused a build failure in a
> not-yet-submitted driver patch.  This happens when someone uses
> test_and_set_bit() or another similar operation on a fixed bit index
> above 255; the assembler throws an error at that point and the build fails.
> 
> *HOWEVER*, for bit indicies in the range 32-255, the current code will
> instead silently miscompile, as the CPU will truncate the argument to 5
> bits.  I don't know if there are any such instances in the current
> kernel, but it is entirely possible there is, with unknown but
> potentially disastrous results.

I'm seeing reports from folks using vfio for PCI device assignment
through QEMU that hugepages aren't being released on VM shutdown and
reverting 0c44c2d0f459 resolves the problem.  I haven't confirmed this
myself nor do I pretend to understand the changes this commit makes.
Thanks,

Alex

