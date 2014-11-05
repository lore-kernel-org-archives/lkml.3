Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbaKELIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 06:08:47 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:56498 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754412AbaKELIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 06:08:45 -0500
Date: Wed, 5 Nov 2014 11:08:19 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Hu Keping <hukeping@huawei.com>
Cc: swarren@nvidia.com, ebiederm@xmission.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sdu.liu@huawei.com, wangnan0@huawei.com, peifeiyue@huawei.com
Subject: Re: [RESEND PATCH] ARM: kexec: Fix validating CPU hotplug support
Message-ID: <20141105110819.GK4042@n2100.arm.linux.org.uk>
References: <1415094025-66180-1-git-send-email-hukeping@huawei.com>
 <20141104105525.GE4042@n2100.arm.linux.org.uk>
 <545A0282.4070001@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545A0282.4070001@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 06:57:06PM +0800, Hu Keping wrote:
> Actually, i do think there is something wrong in the panic-rountine:
> when panic comes, we clear the cpu_online_bits of other CPUs and
> keep them calling cpu_relax(). That's why I post that patch ,because
> we do not really shut down the CPUs.
> 
> But as your mentioned , there is another problem:
> what's in the pc register of each cpu is unknown after the MMU has been
> shut down.

Correct.

> On X86, there is a halt() before the cpu_relax(), so do you think we
> need a call wfi() before cpu_relax() to keep the other CPUs on
> status-WFI on ARM?

X86 benefits from the fact that it is a known architecture, and there are
ways to ensure that the other CPUs are held in reset or whatever, so the
system is recoverable from such a situation.

That is far from true on ARM: on ARM, everyone does their own thing, which
leads to situations where we can't reset other CPUs (eg, because the
hardware isn't implemented, or the secure firmware doesn't support being
called by non-boot CPUs, etc.)

So, while adding a wfi() call in machine_crash_nonpanic_core() will stop
the CPU executing instructions, the kernel being kexec'd will not see
the CPUs it expects.  Also, I worry whether a wfi() is sufficient - what
if an interrupt does get delivered to that CPU (eg, as part of the kexec'd
kernel trying to bring the CPU online) or a device raises its interrupt
and the interrupt has been routed to that CPU.

I think this is the reason why we went for the simple option here: we
know that all the conditions are not correct for being able to safely
kexec() in SMP mode, especially in a panic scenario.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
