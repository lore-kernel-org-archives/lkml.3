Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114Ab3DWW46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 18:56:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35042 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753987Ab3DWW45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 18:56:57 -0400
Message-ID: <517711A7.8090002@zytor.com>
Date: Tue, 23 Apr 2013 15:56:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: arjan@infradead.org, james.hogan@imgtec.com, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com
Subject: Re: [PATCH] x86_32: Fix module version table mismatch.
References: <CAHp75VdDwh0wgCWrVDcPps1C2qfdDZra15y9BQvzfWHzSMqbWA@mail.gmail.com> <CAHp75Vfh6Bpk4j3crVEAo3UtJEqpyucbQw+AzJvO85uRJ6gVgg@mail.gmail.com> <201304222326.IJB21395.FOtVJFHFQMOOSL@I-love.SAKURA.ne.jp> <201304232140.FGF73904.QJOFOVtHFFMSOL@I-love.SAKURA.ne.jp>
In-Reply-To: <201304232140.FGF73904.QJOFOVtHFFMSOL@I-love.SAKURA.ne.jp>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2013 05:40 AM, Tetsuo Handa wrote:
> Commit a4b6a77b "module: fix symbol versioning with symbol prefixes" broke
> loading of net/ipv6/ipv6.ko built with CONFIG_MODVERSIONS=y for x86_32.
> 
>   # modprobe ipv6
>   FATAL: Error inserting ipv6 (/lib/modules/3.9.0-rc8-next-20130422/kernel/net/ipv6/ipv6.ko): Invalid argument
>   # dmesg
>   ipv6: no symbol version for memcmp
>   ipv6: Unknown symbol memcmp (err -22)
> 
> The reason for breakage is that check_version() in kernel/module.c tries to
> find symname == "memcmp" but versions[i].name == "__builtin_memcmp".
> 
> The reason for versions[i].name == "__builtin_memcmp" is that
> memcmp() for x86_32 is defined as
> 
>   #define memcmp __builtin_memcmp
> 
> in arch/x86/include/asm/string_32.h while memcmp() for x86_64 is defined as
> 
>   int memcmp(const void *cs, const void *ct, size_t count);
> 
> in arch/x86/include/asm/string_64.h.
> 
> Since __builtin_memcmp is a gcc's built-in function which might emit a call to
> memcmp, __builtin_memcmp should not be used for versions[i].name field.
> 
> In order to make sure that versions[i].name == "memcmp", make the definition of
> memcmp() for x86_32 identical with that of x86_64.
> 

I'm still confused by all of this.  VMLINUX_SYMBOL_STR() ought to be a
noop on x86, so how on Earth could a4b6a77b break anything?

Secondly, although memcmp is a macro, it is #undef'd before the
definition in lib/string.c, which is the one that is exported.

I'm wondering if the real culprit isn't b92021b0, but I'm looking into
it now.

	-hpa

