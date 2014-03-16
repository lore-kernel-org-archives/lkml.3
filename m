Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbaCPJrW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 05:47:22 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:54037 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751080AbaCPJrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 05:47:20 -0400
Date: Sun, 16 Mar 2014 09:46:50 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sebastian Capella <sebastian.capella@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Len Brown <len.brown@intel.com>,
        Jonathan Austin <jonathan.austin@arm.com>,
        Victor Kamensky <victor.kamensky@linaro.org>,
        Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>,
        Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Laura Abbott <lauraa@codeaurora.org>, Sricharan R <r.sricharan@ti.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Russ Dill <Russ.Dill@ti.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Jiang Liu <liuj97@gmail.com>
Subject: Re: [PATCH v7 2/2] ARM hibernation / suspend-to-disk
Message-ID: <20140316094650.GV21483@n2100.arm.linux.org.uk>
References: <1394016605-24120-1-git-send-email-sebastian.capella@linaro.org> <1394016605-24120-3-git-send-email-sebastian.capella@linaro.org> <20140307044251.GD9985@codeaurora.org> <CADHgK6s4K+K+OZuUZVbHKNzbFiHzm82Ss0WpSfkUdQgP+E3j=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADHgK6s4K+K+OZuUZVbHKNzbFiHzm82Ss0WpSfkUdQgP+E3j=w@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 11:32:17AM -0700, Sebastian Capella wrote:
> I've moved to this second implementation.  I don't think I understand
> the ramifications enough to add the virt_to_pfn call for arm.

Let's look at the implementations...

#define __pa(x)                 __virt_to_phys((unsigned long)(x))
static inline phys_addr_t __virt_to_phys(unsigned long x)
{
        return (phys_addr_t)x - PAGE_OFFSET + PHYS_OFFSET;
}

So, __pa() returns a phys_addr_t (which may be either 32-bit or 64-bit).

#define virt_to_pfn(kaddr)  (__pa(kaddr) >> PAGE_SHIFT)

And that will do an appropriate shift to convert the phys_addr_t to a PFN,
which will be fine to assign to an unsigned long variable.

#define __phys_to_pfn(paddr)    ((unsigned long)((paddr) >> PAGE_SHIFT))

This does the same thing, but has an explicit cast.

So, the only difference between the two suggestions is that additional
cast, which has no effect here.

> I've changed one thing.  __nosave_end is pointing at the first byte
> not included in the nosave region.  I subtracted one from it so that
> we make sure we're referring to the last pfn, and left the pfn
> comparison as you'd suggested.

Yes, that should be safer.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
