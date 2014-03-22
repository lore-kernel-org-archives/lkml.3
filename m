Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584AbaCVQmm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 12:42:42 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48348 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751199AbaCVQmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 12:42:39 -0400
Message-ID: <1395506558.2143.18.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH v2] LLVMLinux: Remove warning about returning an
 uninitialized variable
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Behan Webster <behanw@converseincode.com>
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, pageexec@freemail.hu,
        Mark Charlebois <charlebm@gmail.com>
Date: Sat, 22 Mar 2014 09:42:38 -0700
In-Reply-To: <532DBC50.9040505@converseincode.com>
References: <201403221101.16961.arnd@arndb.de>
		 <1395503299-15203-1-git-send-email-behanw@converseincode.com>
	 <1395505786.2143.14.camel@dabdike.int.hansenpartnership.com>
	 <532DBC50.9040505@converseincode.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-03-22 at 09:37 -0700, Behan Webster wrote:
> On 03/22/14 09:29, James Bottomley wrote:
> > On Sat, 2014-03-22 at 08:48 -0700, behanw@converseincode.com wrote:
> >> From: Behan Webster <behanw@converseincode.com>
> >>
> >> Fix uninitialized return code in default case in cmpxchg-local.h
> >>
> >> This patch fixes the code to prevent an uninitialized return value that is detected
> >> when compiling with clang. The bug produces numerous warnings when compiling the
> >> Linux kernel with clang.
> >>
> >> Signed-off-by: Behan Webster <behanw@converseincode.com>
> >> Signed-off-by: Mark Charlebois <charlebm@gmail.com>
> >> ---
> >>   include/asm-generic/cmpxchg-local.h | 1 +
> >>   1 file changed, 1 insertion(+)
> >>
> >> diff --git a/include/asm-generic/cmpxchg-local.h b/include/asm-generic/cmpxchg-local.h
> >> index d8d4c89..9112111 100644
> >> --- a/include/asm-generic/cmpxchg-local.h
> >> +++ b/include/asm-generic/cmpxchg-local.h
> >> @@ -41,6 +41,7 @@ static inline unsigned long __cmpxchg_local_generic(volatile void *ptr,
> >>   		break;
> >>   	default:
> >>   		wrong_size_cmpxchg(ptr);
> >> +		__builtin_unreachable();
> > No, that's got to be unreachable() so that it works in all compilers,
> > (__builtin_unreachable is a gcc-4 ism).
> It is also supported by clang.

OK, but it's not supported by gcc-3.  So gcc-3 would crap out seeing the
statement, which is why we have to wrapper it.

> > Got to say this still looks wrong.  If wrong_size_cmpxchg() cannot
> > return, the function should be annotated as such with __noreturn (like
> > panic()) so the unreachable() should be superfluous.
> Okay. I can try that instead.

Great; This seems to work for me (but then my compiler doesn't see the
unreachable problem).

James

---
diff --git a/include/asm-generic/cmpxchg-local.h b/include/asm-generic/cmpxchg-local.h
index d8d4c89..70bef78 100644
--- a/include/asm-generic/cmpxchg-local.h
+++ b/include/asm-generic/cmpxchg-local.h
@@ -4,7 +4,8 @@
 #include <linux/types.h>
 #include <linux/irqflags.h>
 
-extern unsigned long wrong_size_cmpxchg(volatile void *ptr);
+extern unsigned long wrong_size_cmpxchg(volatile void *ptr)
+	__noreturn;
 
 /*
  * Generic version of __cmpxchg_local (disables interrupts). Takes an unsigned


