Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbaDNVIb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:08:31 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:42930 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbaDNVI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:08:27 -0400
Date: Mon, 14 Apr 2014 23:08:07 +0200
From: Rabin Vincent <rabin@rab.in>
To: Kees Cook <keescook@chromium.org>
Cc: "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Laura Abbott <lauraa@codeaurora.org>,
        Alexander Holler <holler@ahsoftware.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/2] ARM: mm: make text and rodata read-only
Message-ID: <20140414210807.GA25564@debian>
References: <1396577719-14786-1-git-send-email-keescook@chromium.org>
 <1396577719-14786-3-git-send-email-keescook@chromium.org>
 <20140404195818.GA21028@debian>
 <CAGXu5jKPX2igsb2rQzdCZQZ8X3h4YZihCV9D+cDW3F+qii8H2A@mail.gmail.com>
 <1396960898.3567.55.camel@linaro1.home>
 <CAGXu5jJq24k4uQbBJmihJ4RScJ40o41oKFtm13hBO_YZOvHpkA@mail.gmail.com>
 <1396973561.14809.26.camel@linaro1.home>
 <CAGXu5jJewy0Xy-qUEF2K6bAcEC8ZdKy0Ad2nLPjGRsq20fSQXQ@mail.gmail.com>
 <20140408194815.GA6188@debian>
 <CAGXu5jLkc2oFouYq3ZT1sUvgjjJY32_uEcuLLE4wHX-N0cFiFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jLkc2oFouYq3ZT1sUvgjjJY32_uEcuLLE4wHX-N0cFiFw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 01:19:01PM -0700, Kees Cook wrote:
> > To prevent any stale entries being used indefinitely, perhaps the all
> > CPU TLB flush can be inserted into
> > ftrace_arch_code_modify_post_process(), which is called after the
> > stop_machine() and which is where x86 for example makes the entries
> > read-only again.
> 
> Do you mean something like this?

Yes, something like that should probably be sufficient.

> 
> diff --git a/arch/arm/kernel/ftrace.c b/arch/arm/kernel/ftrace.c
> index ea446ae09c89..b8c75e45a950 100644
> --- a/arch/arm/kernel/ftrace.c
> +++ b/arch/arm/kernel/ftrace.c
> @@ -90,6 +90,8 @@ int ftrace_arch_code_modify_prepare(void)
>  int ftrace_arch_code_modify_post_process(void)
>  {
>         set_all_modules_text_ro();
> +       /* Make sure any TLB misses during machine stop are cleared. */
> +       flush_tlb_all();
>         return 0;
>  }
