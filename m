Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079AbaCDSoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 13:44:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753642AbaCDSoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 13:44:14 -0500
Date: Tue, 4 Mar 2014 19:41:09 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        viro@zeniv.linux.org.uk, vgupta@synopsys.com, catalin.marinas@arm.com,
        will.deacon@arm.com, hskinnemoen@gmail.com, egtvedt@samfundet.no,
        vapier@gentoo.org, msalter@redhat.com, a-jacquiot@ti.com,
        starvik@axis.com, jesper.nilsson@axis.com, dhowells@redhat.com,
        rkuo@codeaurora.org, tony.luck@intel.com, fenghua.yu@intel.com,
        takata@linux-m32r.org, geert@linux-m68k.org, james.hogan@imgtec.com,
        monstr@monstr.eu, yasutake.koichi@jp.panasonic.com,
        ralf@linux-mips.org, jonas@southpole.se, jejb@parisc-linux.org,
        deller@gmx.de, benh@kernel.crashing.org, paulus@samba.org,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        liqin.linux@gmail.com, lennox.wu@gmail.com, cmetcalf@tilera.com,
        gxt@mprc.pku.edu.cn, linux-xtensa@linux-xtensa.org,
        akpm@linux-foundation.org, tj@kernel.org, hch@infradead.org
Subject: Re: [PATCH 28/44] Add translate_signal() helper
Message-ID: <20140304184109.GB19393@redhat.com>
References: <1393804758-7916-1-git-send-email-richard@nod.at> <1393804758-7916-6-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393804758-7916-6-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03, Richard Weinberger wrote:
>
> +static inline int translate_signal(int sig)
> +{
> +	struct thread_info *info = current_thread_info();
> +
> +	if (info->exec_domain

Afaics it can't be NULL.

> && info->exec_domain->signal_invmap && sig < 32)
> +		return info->exec_domain->signal_invmap[sig];
> +

And why default_exec_domain has .signal_invmap = ident_map ?
translate_signal-like code should check ->signal_invmap != NULL
anyway.

Off topic, but can't we kill exec_domain->signal_map ? it seems that
it is unused.

Hmm. And who actually uses exec_domain->handler() ?? asm-offsets.c,
but I do not see any usage of TI_EXEC_DOMAIN.

In short: I agree with this change but I am totally confused. To the
point, I am not sure I even understand ->signal_invmap. I mean, it
seems that only arthur_exec_domain has a non-ident map. Why, say,
x86 does signr_convert() ? and only if CONFIG_X86_32? Is there any
external module which does register_exec_domain(strange_invmap) ?

Oleg.

