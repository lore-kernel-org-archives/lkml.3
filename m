Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbaCKEKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 00:10:35 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:38029 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbaCKEKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 00:10:34 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFydgX7yejyPq0ckuXabEFhjXO960F=L0-+yYNT=U=Madg@mail.gmail.com>
References: <f23ea19270122375e8d2efe0646bbe6101c451b4.1394499629.git.luto@amacapital.net>
 <CA+55aFwaWgb-hCfOf8Y_LA+ZAHpTFYU937XN=7T6SxDAdpPzcg@mail.gmail.com>
 <CALCETrUe0TjzjEo-N2GZkD9DiVbtjretGjTVqiv7U+ZJerWLXQ@mail.gmail.com> <CA+55aFydgX7yejyPq0ckuXabEFhjXO960F=L0-+yYNT=U=Madg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 10 Mar 2014 21:10:13 -0700
Message-ID: <CALCETrXd_7K2rc-JPDFtxQWE+ZURzY6qfOLR9DDtjp-nBG1Sgg@mail.gmail.com>
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

On Mon, Mar 10, 2014 at 8:09 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Mar 10, 2014 at 7:37 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>
>> It does.  My patch breaks OpenSuSE 9 when
>> CONFIG_ENABLE_VDSO32_BY_DEFAULT=y unless it's overridden by sysctl or
>> boot option.
>
> Oh, I missed that "when =y" part.
>
> But why do we then want to have that "=y" as an option at all?
>
> If the situation is that everybody is fine with that being disabled by
> default, let's just make it the default. And I'd even be ok with
> removing it as an option *entirely*.
>
> That would seem to be *much* preferable that having an option that
> nobody really wants anyway, and where the default value would break
> some users. THAT just seems completely insane.

I suspect that a lot of 32-bit Linux users want syscall and/or
sysenter, and Stefani certainly wants the fast timing that the vDSO
can provide.  Also, presumably __kernel_sigreturn serves some purpose
:)

The basic issue is that most old glibc versions (and all versions that
were ever tagged in a release) work correctly regardless of whether
there is a vDSO, and newer glibc versions (since 2004) will take
advantage of a vDSO if one exists, but OpenSuSE 9 shipped with a
creatively broken version that blows up if presented with a vDSO
that's not prelinked to its actual address.

Currently there are three options: sane vDSO, no vDSO, and OpenSuSE
9-compatible vDSO.  The latter is a mess to maintain and breaks ASLR
(even for users of modern glibc), and having a vDSO is apparently
important enough that people are willing to pay to enhance it.  The
default is OpenSuSE 9-compatible vDSO, which is IMO an odd choice.

ISTM the right solution is to make OpenSuSE 9 users turn off the vDSO
(which is a performance hit for them, but not a correctness issue) and
let everyone else have a simpler kernel that has no ASLR issues.

I'm a bit heartened by the fact that the failure mode on OpenSuSE 9 is
a rather distinctive and easily Googlable message.  Most of the hits
offer abi.vsyscall32=0 or vdso=0 as suggestions, both of which
continue to work with my patch.


--Andy
