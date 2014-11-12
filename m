Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbaKLMjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 07:39:17 -0500
Received: from mail.skyhub.de ([78.46.96.112]:32992 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271AbaKLMjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 07:39:16 -0500
Date: Wed, 12 Nov 2014 13:39:09 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <h.peter.anvin@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        x86@kernel.org
Subject: Re: [PATCH 3/6] x86: Add support for the clwb instruction
Message-ID: <20141112123909.GD16807@pd.tnic>
References: <1415731396-19364-1-git-send-email-ross.zwisler@linux.intel.com>
 <1415731396-19364-4-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1415731396-19364-4-git-send-email-ross.zwisler@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 11:43:13AM -0700, Ross Zwisler wrote:
> +static inline void clwb(volatile void *__p)
> +{
> +	alternative_io_2(".byte " __stringify(NOP_DS_PREFIX) "; clflush %P0",
> +			 ".byte 0x66; clflush %P0",
> +			 X86_FEATURE_CLFLUSHOPT,
> +			 ".byte 0x66; xsaveopt %P0",

Btw, I'm afraid you're going to have to spell out those new instruction
mnemonics as they aren't supported by older compilers:

  CC      drivers/gpu/drm/drm_cache.o
{standard input}: Assembler messages:
{standard input}:63: Error: no such instruction: `xsaveopt (%rax)'
{standard input}:249: Error: no such instruction: `xsaveopt (%rdi)'
{standard input}:283: Error: no such instruction: `xsaveopt -1(%rdx)'
make[1]: *** [drivers/gpu/drm/drm_cache.o] Error 1
make: *** [drivers/gpu/drm/drm_cache.o] Error 2
[boris@etch:14:35:40:k:14)->  gcc --version
gcc (GCC) 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)

This is on a very old guest I have which has this gcc in it and the
kernel supports everything gcc >= 3.2.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
