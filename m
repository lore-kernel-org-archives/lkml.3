Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933253AbaLDU1x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 15:27:53 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:59689 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933234AbaLDU1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 15:27:51 -0500
MIME-Version: 1.0
In-Reply-To: <20141204161321.GA14127@thin>
References: <1417665832-6933-1-git-send-email-bobby.prani@gmail.com> <20141204161321.GA14127@thin>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Thu, 4 Dec 2014 15:27:20 -0500
Message-ID: <CAJhHMCBOSQOH+Y=zxO1mo-rvpS1g+CaozYyDONPa0HLtqYLREg@mail.gmail.com>
Subject: Re: [RFC PATCH v2] tinification: Introduce CONFIG_SRCU to make SRCU optional
To: Josh Triplett <josh@joshtriplett.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(resending, forgot CC's)

On Thu, Dec 4, 2014 at 11:13 AM, Josh Triplett <josh@joshtriplett.org> wrote:
>>
>> The current tinyconfig on x86 enables SRCU by default since x86 enables
>> PERF_EVENTS which in-turn require SRCU support. If we disable
>> PERF_EVENTS, we can disable compiling SRCU for tiny configs on x86 systems.
>
> To the best of my knowledge, "select" still doesn't recursively enable
> things that the selected symbol selects, so I think you need to "select
> SRCU" from X86, right next to the "select PERF_EVENTS".

Doesn't this prevent not selecting SRCU on x86 systems?

I think a warning will be generated during make if a dependent config
is not enabled.

>
> Also, can you try your patch on top of the current patch series to
> compile without perf (tiny/disable-perf), and see if you can
> successfully compile without SRCU on x86?

This branch had a small config error which was compiling perf related
code unconditionally.

warning: (HW_BREAKPOINTS) selects HAVE_HW_BREAKPOINT which has unmet
direct dependencies (PERF_EVENTS)

With the following patch applied on top of it I was able to compile my patch.

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 10c51ff..0ecc069 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -588,6 +588,7 @@ config HW_BREAKPOINTS
        default y
        select HAVE_HW_BREAKPOINT
        select HAVE_MIXED_BREAKPOINTS_REGS
+       depends on PERF_EVENTS
        ---help---
          Enable support for x86 hardware breakpoints for debuggers
          and perf.  This will implicitly enable perf-events.


>
>> I tested this using randconfig and building about 15 kernels. This is definitely
>> not complete and could use more testing. Sticking it in next might help in that
>> regards.
>>
>> Comments and suggestions are welcome. Please let me know if I should split up
>> this patch.
>
> I don't think this needs splitting; it's a very small and obvious patch
> combined with a few selects.
>
> The code looks good to me.  Assuming it compiles on x86, with tinyconfig
> and with allyesconfig minus SRCU (and whatever requires it), this seems

For allyesconfig minus SRCU(using tiny/disable-perf) I needed the
following patch to get it to build

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 10c51ff..0ecc069 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -588,6 +588,7 @@ config HW_BREAKPOINTS
        default y
        select HAVE_HW_BREAKPOINT
        select HAVE_MIXED_BREAKPOINTS_REGS
+       depends on PERF_EVENTS
        ---help---
          Enable support for x86 hardware breakpoints for debuggers
          and perf.  This will implicitly enable perf-events.
diff --git a/fs/Kconfig.binfmt b/fs/Kconfig.binfmt
index 370b24c..2669ddf 100644
--- a/fs/Kconfig.binfmt
+++ b/fs/Kconfig.binfmt
@@ -182,6 +182,7 @@ config BINFMT_MISC
 config COREDUMP
        bool "Enable core dump support" if EXPERT
        default y
+       depends on PERF_EVENTS
        help
          This option enables support for performing core dumps. You almost
          certainly want to say Y here. Not necessary on systems that never
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 8639819..b008c597 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -125,6 +125,7 @@ config TRACING_SUPPORT
        # irqflags tracing for your architecture.
        depends on TRACE_IRQFLAGS_SUPPORT || PPC32
        depends on STACKTRACE_SUPPORT
+       depends on PERF_EVENTS
        default y

 if TRACING_SUPPORT

--

If the above two patches are good, then may be you should add them to
the tiny/disable-perf branch?

I will submit SRCU patch on top of rcu/dev so that Paul can pick it up
in his tree.

Thanks!
--
Pranith
