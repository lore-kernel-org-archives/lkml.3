Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbaEOJGB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 05:06:01 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:34725 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750786AbaEOJGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 05:06:00 -0400
Date: Thu, 15 May 2014 10:05:35 +0100
From: Will Deacon <will.deacon@arm.com>
To: Kyle McMartin <kyle@redhat.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: [PATCH] arm64: don't set READ_IMPLIES_EXEC for EM_AARCH64
Message-ID: <20140515090535.GB27594@arm.com>
References: <20140514185720.GI26038@redacted.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140514185720.GI26038@redacted.bos.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 07:57:21PM +0100, Kyle McMartin wrote:
> current->personality & READ_IMPLIES_EXEC is currently being set for
> AArch64 binaries, resulting in an executable stack, when no explicit
> PT_GNU_STACK header is present.
> 
> [kmcmarti@sedition ~]$ uname -p
> aarch64
> [kmcmarti@sedition ~]$ cat /proc/$$/personality 
> 00400000
> 
> The reason for this is, without an explicit PT_GNU_STACK entry in the
> binary, stk is still set to EXSTACK_DEFAULT (which should be
> non-executable on AArch64.) As a result, elf_read_implies_exec is true,
> and we set READ_IMPLIES_EXEC in binfmt_elf.c:load_elf_binary.
> 
> Fix this to return 0 in the native case, and parrot the logic from
> arch/arm/kernel/elf.c otherwise. With this patch, binaries correctly
> don't have READ_IMPLIES_EXEC set, and we can let PT_GNU_STACK change
> things if it's explicitly requested.

Unfortunately, my understanding is that GCC currently requires this for
nested functions, so this is an effective ABI breakage. On the plus side,
the GCC guys are planning to fix that, so we should see PT_GNU_STACK getting
used more frequently in the future.

Will
