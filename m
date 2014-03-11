Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbaCKA7K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 20:59:10 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:61137 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbaCKA7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 20:59:07 -0400
MIME-Version: 1.0
In-Reply-To: <20140311003856.GA4203@redhat.com>
References: <775280bd6cab6345a1d340e7038d2011763bf81b.1394492341.git.luto@amacapital.net>
 <531E5531.20409@linux.intel.com> <CALCETrX1RBVYAKyN_GdvF8w3S=A5wZ_XaMqR_MjdLim7RMR8NQ@mail.gmail.com>
 <20140311003856.GA4203@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 10 Mar 2014 17:58:46 -0700
Message-ID: <CALCETrU44fMDr+FQcXKZp7VHrnNnvy7W=c17hWKmQ6s=T3G8rA@mail.gmail.com>
Subject: Re: [PATCH] x86: Remove compat vdso support
To: Dave Jones <davej@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        X86 ML <x86@kernel.org>, Stefani Seibold <stefani@seibold.net>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 5:38 PM, Dave Jones <davej@redhat.com> wrote:
> On Mon, Mar 10, 2014 at 05:19:27PM -0700, Andy Lutomirski wrote:
>  > On Mon, Mar 10, 2014 at 5:13 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>  > > On 03/10/2014 05:12 PM, Andy Lutomirski wrote:
>  > >> The compat vDSO is a complicated hack that's needed to maintain
>  > >> compatibility with a small range of never-released glibc versions.
>  > >>
>  > >> This removes it and replaces it with a much simpler hack: a config
>  > >> option to disable the 32-bit vDSO by default.
>  > >>
>  > >> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>  > >
>  > > Can we verify this works correctly on the affected distributions?
>  >
>  > It works correctly on Fedora 20 32-bit and 64-bit.
>
> I went and dug through the SRPMs at https://archives.fedoraproject.org
> Fedora hasn't ever shipped with COMPAT_VDSO enabled.
> Before FC6 (kernel 2.6.18), the option never existed.
>

What I mean is: a kernel with this patch can boot Fedora 20.

It looks like OpenSUSE 9 is the affected distribution.  I bootstrapped
a minimal OpenSUSE 9 32-bit chroot (filesystem, glibc, ncurses,
readline, bash).  If there's a non-compat vDSO, it says:

Inconsistency detected by ld.so: rtld.c: 1250: dl_main: Assertion
`(void *) ph->p_vaddr == _rtld_local._dl_sysinfo_dso' failed!

With 'echo 0 >/proc/sys/abi/vsyscall32', it works.  With vdso32=2, it
works.  With CONFIG_ENABLE_VDSO32_BY_DEFAULT=n, it works.  I also
checked an unpatched kernel with compat vdso on.  That also works.

So, the upshot of my patch is that the default becomes sane for
everyone except users of OpenSUSE 9 and similar.  OpenSUSE 9 users
will need to fiddle with their settings or config.

And it looks like I need to spruce up virtme a bit to make this kind
of testing easier :)

I'll respin the patch to note that OpenSUSE 9 is affected.

NB: I've only tested a 64-bit kernel.  Testing a 32-bit kernel will
involve considerably more effort.

>         Dave
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
