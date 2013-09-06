Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750867Ab3IFIIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 04:08:31 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:35709 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab3IFIIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 04:08:23 -0400
MIME-Version: 1.0
In-Reply-To: <1376966841-31774-8-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130820024700.GA31075@linux.vnet.ibm.com>
	<1376966841-31774-1-git-send-email-paulmck@linux.vnet.ibm.com>
	<1376966841-31774-8-git-send-email-paulmck@linux.vnet.ibm.com>
Date: Fri, 6 Sep 2013 10:08:22 +0200
X-Google-Sender-Auth: oqhhN00C_a096kOIlv8gufCANW4
Message-ID: <CAMuHMdWtZAD3G_miFOT9DPZpfTO3nJ9J4aG_zvHV_6eVf2jdQg@mail.gmail.com>
Subject: Re: [PATCH tip/core/rcu 8/9] nohz_full: Add full-system-idle state machine
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        josh@joshtriplett.org, niv@us.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Howells <dhowells@redhat.com>, edumazet@google.com,
        darren@dvhart.com,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        sbw@mit.edu, Linux-Arch <linux-arch@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 4:47 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> --- a/kernel/time/Kconfig
> +++ b/kernel/time/Kconfig
> @@ -157,6 +157,33 @@ config NO_HZ_FULL_SYSIDLE
>
>          Say N if you are unsure.
>
> +config NO_HZ_FULL_SYSIDLE_SMALL
> +       int "Number of CPUs above which large-system approach is used"
> +       depends on NO_HZ_FULL_SYSIDLE
> +       range 1 NR_CPUS

This causes "kernel/time/Kconfig:162:warning: range is invalid" on m68k and
all other architectures that do not support SMP.

How to reproduce:
    make ARCH=m68k defconfig

Furthermore, it seems only hexagon, metag, mips, and x86 set NR_CPUS to 1
if !SMP. On other architectures, NR_CPUS is not defined and presumed to be 0.

Hence in non-interactive configs (e.g. "make defconfig"),
NO_HZ_FULL_SYSIDLE_SMALL will end up as 0.
In interactive configs (e.g. "make oldconfig") Kconfig suggest "0" as
the default,
but refuses to accept it as it doesn't fall within the range 1..0.

How to reproduce:
    Remove the "depends on NO_HZ_FULL_SYSIDLE"
    make ARCH=powerpc mpc83xx_defconfig
    grep NO_HZ_FULL_SYSIDLE_SMALL .config
    -> CONFIG_NO_HZ_FULL_SYSIDLE_SMALL=0
    sed 's/CONFIG_NO_HZ_FULL_SYSIDLE_SMALL=0//g' -i .config
    make ARCH=powerpc oldconfig
    -> no value is accepted

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
