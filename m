Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933AbaJXJ2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 05:28:43 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:47964 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaJXJ2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 05:28:42 -0400
Date: Fri, 24 Oct 2014 10:28:32 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "stefano.stabellini@eu.citrix.com" <stefano.stabellini@eu.citrix.com>,
        "ezequiel.garcia@free-electrons.com" 
	<ezequiel.garcia@free-electrons.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: supplementing IO accessors with 64 bit capability
Message-ID: <20141024092832.GD20534@e104818-lin.cambridge.arm.com>
References: <1413993983-17310-1-git-send-email-mathieu.poirier@linaro.org>
 <20141022164454.GI15370@e104818-lin.cambridge.arm.com>
 <CANLsYkx08dw=YYBoRJ47QC+iL578HxPoMFcRDw6aKsvyqaqtkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANLsYkx08dw=YYBoRJ47QC+iL578HxPoMFcRDw6aKsvyqaqtkw@mail.gmail.com>
Thread-Topic: [PATCH] ARM: supplementing IO accessors with 64 bit capability
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 08:10:27PM +0100, Mathieu Poirier wrote:
> On 22 October 2014 18:44, Catalin Marinas <catalin.marinas@arm.com> wrote:
> > On Wed, Oct 22, 2014 at 05:06:23PM +0100, mathieu.poirier@linaro.org wrote:
> >> +static inline void __raw_writeq(u64 val, volatile void __iomem *addr)
> >> +{
> >> +     asm volatile("strd %1, %0"
> >> +                  : "+Qo" (*(volatile u64 __force *)addr)
> >> +                  : "r" (val));
> >> +}
> >> +
> >> +static inline u64 __raw_readq(const volatile void __iomem *addr)
> >> +{
> >> +     u64 val;
> >> +     asm volatile("ldrd %1, %0"
> >> +                  : "+Qo" (*(volatile u64 __force *)addr),
> >> +                    "=r" (val));
> >> +     return val;
> >> +}
> >> +#endif
> >
> > I'm curious why you need these. Do you have a device that needs a 64-bit
> > single access or you are trying to read two consecutive registers?
> 
> The fundamental data size of Coresight STM32 for ARMv7 is
> implementation defined and can be 32 or 64bit.  As such stimulus ports
> can support transaction sizes of up to 64 bit.

The STM programmer's model spec recommends something else (though I find
the "3.6 Data sizes" chapter a bit confusing):

  To ensure that code is portable between processor micro-architectures
  and system implementations, ARM recommends that only the native data
  size of the machine is used, and smaller sizes. For the 32-bit ARMv7
  architecture, only 8, 16, and 32-bit transfers are recommended. For an
  ARMv8 processor that supports the AArch64 Execution state, it is
  recommended that the fundamental data size of 64-bits is implemented.

Which means that you should not use readq/writeq on a 32-bit system.

-- 
Catalin
