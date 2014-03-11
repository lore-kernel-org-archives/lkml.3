Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbaCKCiM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 22:38:12 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:39870 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbaCKCiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 22:38:11 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwaWgb-hCfOf8Y_LA+ZAHpTFYU937XN=7T6SxDAdpPzcg@mail.gmail.com>
References: <f23ea19270122375e8d2efe0646bbe6101c451b4.1394499629.git.luto@amacapital.net>
 <CA+55aFwaWgb-hCfOf8Y_LA+ZAHpTFYU937XN=7T6SxDAdpPzcg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 10 Mar 2014 19:37:50 -0700
Message-ID: <CALCETrUe0TjzjEo-N2GZkD9DiVbtjretGjTVqiv7U+ZJerWLXQ@mail.gmail.com>
Subject: Re: [PATCH v2] x86: Remove compat vdso support
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Stefani Seibold <stefani@seibold.net>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 6:39 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Mar 10, 2014 at 6:03 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>
>> This is a bit of an abuse of the no-breaking-userspace policy.
>
> No it's not, because it won't be applied.
>
> You need to fix it.
>
> I'm not sure what goes wrong, since it *looks* like you handle the
> "vdso_enabled" thing correctly, so I find it surprising that you say
> that
>
>     echo 0 >/proc/sys/abi/vsyscall32
>
> makes it work, since it should be zero already, and that echo should
> be a no-op. But maybe I'm missing something.
>
> Maybe you can just fake the boot parameter and fix the OpenSuSE
> breakage that way (presumably that "init" sees it if it's some
> user-space setup thing), but I'd like to know why that "echo 0" works,
> but just initializing it to zero does not?

It does.  My patch breaks OpenSuSE 9 when
CONFIG_ENABLE_VDSO32_BY_DEFAULT=y unless it's overridden by sysctl or
boot option.

The behavior with my patch is:

If ENABLE_VDSO32_BY_DEFAULT (which is the default), then OpenSuSE 9
breaks.  Everything else works.  Booting with vdso=0, vdso=2,
vdso32=0, or vdso32=2, or setting abi.vsyscall32=0 will switch to the
no-vDSO behavior.

If !ENABLE_VDSO32_BY_DEFAULT, then OpenSuSE 9 breaks and other 32-bit
code runs without a vDSO, which slows it down a bit.

I did that because I seem to remember that it's not so bad to break
small amounts of userspace as long as there's a backwards
compatibility path (there are plenty of kernel options that turn on
"legacy" things needed for small numbers of users).

If this is not okay, then I can redo the patch, leaving it with
CONFIG_COMPAT_VDSO as the option name, so that anyone with a working
config will keep working if they run 'make oldconfig' (as opposed to
being prompted).  If I do that, I'd still prefer to make the
non-compatible version be the default, since it's the right choice for
the vast majority of users.  Currently CONFIG_COMPAT_VDSO is default
y, which seems like an odd choice to me.

--Andy
