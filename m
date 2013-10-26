Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637Ab3JZKbO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 06:31:14 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:34601 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab3JZKbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 06:31:13 -0400
Date: Sat, 26 Oct 2013 12:31:09 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, arjan@linux.intel.com,
        linux@roeck-us.net, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/2] x86: unify copy_from_user() size checking
Message-ID: <20131026103109.GC14949@gmail.com>
References: <5265056D02000078000FC4F3@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5265056D02000078000FC4F3@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <JBeulich@suse.com> wrote:

> Commits 4a3127693001c61a21d1ce680db6340623f52e93 ("x86: Turn the
> copy_from_user check into an (optional) compile time warning") and
> 63312b6a6faae3f2e5577f2b001e3b504f10a2aa ("x86: Add a Kconfig option to
> turn the copy_from_user warnings into errors") touched only the 32-bit
> variant of copy_from_user(), whereas the original commit
> 9f0cf4adb6aa0bfccf675c938124e68f7f06349d ("x86: Use
> __builtin_object_size() to validate the buffer size for
> copy_from_user()") also added the same code to the 64-bit one.
> 
> Further the earlier conversion from an inline WARN() to the call to
> copy_from_user_overflow() went a little too far: When the number of
> bytes to be copied is not a constant (e.g. [looking at 3.11] in
> drivers/net/tun.c:__tun_chr_ioctl() or
> drivers/pci/pcie/aer/aer_inject.c:aer_inject_write()), the compiler
> will always have to keep the funtion call, and hence there will always
> be a warning. By using __builtin_constant_p() we can avoid this.
> 
> And then this slightly extends the effect of
> CONFIG_DEBUG_STRICT_USER_COPY_CHECKS in that apart from converting
> warnings to errors in the constant size case, it retains the (possibly
> wrong) warnings in the non-constant size case, such that if someone is
> prepared to get a few false positives, (s)he'll be able to recover the
> current behavior (except that these diagnostics now will never be
> converted to errors).
> 
> Since the 32-bit variant (intentionally) didn't call might_fault(), the
> unification results in this being called twice now. Adding a suitable
> #ifdef would be the alternative if that's a problem.

Addressing that sanely would be nice.

> I'd like to point out though that with __compiletime_object_size()
> being restricted to gcc before 4.6, the whole construct is going to
> become more and more pointless going forward. I would question
> however that commit 2fb0815c9ee6b9ac50e15dd8360ec76d9fa46a2 ("gcc4:
> disable __compiletime_object_size for GCC 4.6+") was really necessary,
> and instead this should have been dealt with as is done here from the
> beginning.

Can we now revert 2fb0815c9ee6?

Thanks,

	Ingo
