Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab3I3Pxy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 11:53:54 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:49052 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209Ab3I3Pxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 11:53:51 -0400
Message-ID: <52499E8B.6000702@gmail.com>
Date: Mon, 30 Sep 2013 08:53:47 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        Markos Chandras <Markos.Chandras@imgtec.com>,
        linux-mips@linux-mips.org,
        Andrew Pinski <Andrew.Pinski@caviumnetworks.com>,
        John Crispin <blogic@openwrt.org>
Subject: Re: Issue with BUG() in asm-gemeric/bug.h if CONFIG_BUG=n
References: <20130930145630.GA14672@linux-mips.org>
In-Reply-To: <20130930145630.GA14672@linux-mips.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2013 07:56 AM, Ralf Baechle wrote:
> Lately I received several patches for build issues that only strike if
> CONFIG_BUG is disabled.  Here's a test case extracted from one of them:
>
> /*
>   * Definition of BUG taken from asm-generic/bug.h for the CONFIG_BUG=n case
>   */
> #define BUG() 	do {} while(0)
>
> int foo(int arg)
> {
> 	int res;
>
> 	if (arg == 1)
> 		res = 23;
> 	else if (arg == 2)
> 		res = 42;
> 	else
> 		BUG();
>
> 	return res;
> }
>
> [ralf@h7 ~]$ gcc -O2 -Wall -c bug.c
> bug.c: In function ‘foo’:
> bug.c:17:2: warning: ‘res’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>    return res;
>    ^
>
> It's fairly obvious to see what's happening here - GCC doesn't know that
> the else case can not be reached, thus razorsharply concludes that res
> may be used uninitialized.
>
> There several locations where MIPS - possibly other architectures as well -
> is affected by this.
>
> I think the definition of BUG should be changed to something like
>
> #define BUG()	unreachable()
> 16304
> unreachable() will depending on the compiler being used, expand either
> into a call to __builtin_unreachable() or where that function is
> unavailable, into do {} while (1).

The *only* reason we have CONFIG_BUG=n is to reduce code size.

Sticking in that empty loop, negates the entire point.

IMHO: We should do one of:
  o Make CONFIG_BUG=y mandatory
  o Ignore the warnings.
  o Fix the warning sites so they quit Warning.

So I don't think the patch is really an improvement over the status quo.

David Daney

>
> __builtin_unreachable() was introduce for GCC 4.5.0.
>
> This means there'd be minor bloat for antique compilers - but probably
> even better code generation for compilers supporting __builtin_unreachable().
>
>    Ralf
>
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
>
>   include/asm-generic/bug.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
> index 7d10f96..6f78771 100644
> --- a/include/asm-generic/bug.h
> +++ b/include/asm-generic/bug.h
> @@ -108,7 +108,7 @@ extern void warn_slowpath_null(const char *file, const int line);
>
>   #else /* !CONFIG_BUG */
>   #ifndef HAVE_ARCH_BUG
> -#define BUG() do {} while(0)
> +#define BUG() unreachable()
>   #endif
>
>   #ifndef HAVE_ARCH_BUG_ON
>
> ----- End forwarded message -----
>
>    Ralf
>

