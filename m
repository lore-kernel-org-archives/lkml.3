Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303Ab3JQWUc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 18:20:32 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58451 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754544Ab3JQWUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 18:20:30 -0400
Date: Fri, 18 Oct 2013 00:20:12 +0200
From: Borislav Petkov <bp@alien8.de>
To: Joonas Saarinen <jza@saunalahti.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: AMD Bobcat cpufreq
Message-ID: <20131017222012.GC5044@pd.tnic>
References: <17862115.9387961382043268695.JavaMail.jza@saunalahti.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <17862115.9387961382043268695.JavaMail.jza@saunalahti.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 11:54:28PM +0300, Joonas Saarinen wrote:
> All right. I'm finally back to re-investigate the issue. The
> requested data can be found at:
> 
> http://users.metropolia.fi/~joonasms/bobcat/
> 
> The CPU underclocks as expected but the turbo multiplier is never
> activated.

Right, first of all, when you reply to people on lkml, please make sure
to use "reply-to-all" in your mail client so that the people who you
reply to can get your message directly instead of possibly missing it in
the lkml flood.

Now, I'd guess this 1.3 GHz power state you're talking about is the
boosted state. Here's how you dump that: build and install the cpupower
tool in the kernel repository's tools/power/cpupower/ directory.

Then, do as root:

$ modprobe msr

because you need this module.

Once you've done that successfully, you need to run as root:

$ cd tools/power/cpupower/
$ LD_LIBRARY_PATH=. ./cpupower frequency-info

 [ Btw, the cpupower tool might already be available in your distro... ]

Anyways, once you run it successfully, you'll get a similar dump as
below which will show you all your power states. Pb0 should be 1333 in
your case and if it says "boost state support: ... Active" then all is
fine and your machine is switching into it but in a burstly manner - it
cannot be running in it all the time because it would explode the TDP
limits of the box.

HTH.

analyzing CPU 0:
  driver: acpi-cpufreq
  CPUs which run at the same hardware frequency: 0
  CPUs which need to have their frequency coordinated by software: 0
  maximum transition latency: 4.0 us.
  hardware limits: 1.40 GHz - 4.00 GHz
  available frequency steps: 4.00 GHz, 3.40 GHz, 2.80 GHz, 2.10 GHz, 1.40 GHz
  available cpufreq governors: powersave, userspace, conservative, ondemand, performance
  current policy: frequency should be within 1.40 GHz and 4.00 GHz.
                  The governor "ondemand" may decide which speed to use
                  within this range.
  current CPU frequency is 2.80 GHz (asserted by call to hardware).
  cpufreq stats: 4.00 GHz:4.85%, 3.40 GHz:0.51%, 2.80 GHz:1.01%, 2.10 GHz:2.01%, 1.40 GHz:91.62%  (1281567)
  boost state support:
    Supported: yes
    Active: yes
    Boost States: 2
    Total States: 7
    Pstate-Pb0: 4200MHz (boost state)
    Pstate-Pb1: 4100MHz (boost state)
    Pstate-P0:  4000MHz
    Pstate-P1:  3400MHz
    Pstate-P2:  2800MHz
    Pstate-P3:  2100MHz
    Pstate-P4:  1400MHz

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
