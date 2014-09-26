Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbaIZLVK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 07:21:10 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:44088 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753594AbaIZLVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 07:21:08 -0400
Date: Fri, 26 Sep 2014 12:21:10 +0100
From: Will Deacon <will.deacon@arm.com>
To: Kees Cook <keescook@chromium.org>
Cc: Rabin Vincent <rabin@rab.in>, Laura Abbott <lauraa@codeaurora.org>,
        Rob Herring <robh@kernel.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        "msalter@redhat.com" <msalter@redhat.com>,
        Liu hua <sdu.liu@huawei.com>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Doug Anderson <dianders@google.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 0/8] arm: support CONFIG_RODATA
Message-ID: <20140926112109.GH22293@arm.com>
References: <1411067949-10913-1-git-send-email-keescook@chromium.org>
 <CAGXu5j+v075p9j6tME5N1fN9WsX1YiBO-vYtP8MLM=eo5UsqHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+v075p9j6tME5N1fN9WsX1YiBO-vYtP8MLM=eo5UsqHg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 06:58:05AM +0100, Kees Cook wrote:
> On Thu, Sep 18, 2014 at 12:19 PM, Kees Cook <keescook@chromium.org> wrote:
> > This is a series of patches to support CONFIG_RODATA on ARM, so that
> > the kernel text is RO, and non-text sections default to NX. To support
> > on-the-fly kernel text patching (via ftrace, kprobes, etc), fixmap
> > support has been finalized based on several versions of various patches
> > that are floating around on the mailing list. This series attempts to
> > include the least intrusive version, so that others can build on it for
> > future fixmap work.
> >
> > The series has been heavily tested, and appears to be working correctly:
> >
> > With CONFIG_ARM_PTDUMP, expected page table permissions are seen in
> > /sys/kernel/debug/kernel_page_tables.
> >
> > Using CONFIG_LKDTM, the kernel now correctly detects bad accesses for
> > for the following lkdtm tests via /sys/kernel/debug/provoke-crash/DIRECT:
> >         EXEC_DATA
> >         WRITE_RO
> >         WRITE_KERN
> >
> > ftrace works:
> >         CONFIG_FTRACE_STARTUP_TEST passes
> >         Enabling tracing works:
> >                 echo function > /sys/kernel/debug/tracing/current_tracer
> > kprobes works:
> >         CONFIG_ARM_KPROBES_TEST passes
> >
> > kexec works:
> >         kexec will load and start a new kernel
> >
> > Built with and without CONFIG_HIGHMEM, CONFIG_HIGHMEM_DEBUG, and
> > CONFIG_NR_CPUS=32.
> >
> > Thanks to everyone who has been testing this series and working on its
> > various pieces!
> >
> > Hopefully this should address Will's last concerns. :)
> >
> > Thanks!
> >
> > -Kees
> >
> > v6:
> > - always run patch_text under stop_machine (will.deacon)
> > - document set_fixmap's TLB flushing situation (will.deacon)
> 
> Hi Will,
> 
> Does this version look good to you? Should I turn it into a pull request?

The TLB flushing bits look sensible now, but the locking in __set_fixmap is
still pretty horrible (x86 just uses a mutex, not sure why we need to be
different). Still, it's Russell's call.

Will
