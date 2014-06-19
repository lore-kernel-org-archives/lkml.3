Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933944AbaFSRAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 13:00:25 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:53909 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932232AbaFSRAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 13:00:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bug: Fix CONFIG_BUG=n BUG_ON()
Date: Thu, 19 Jun 2014 19:00:14 +0200
Message-ID: <5061693.b4BPIj9quA@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53A2E573.6080407@acm.org>
References: <53A2E573.6080407@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:9seRW8KMWQ96XwQpDahM12Kav+3OeNA0F5PsMW9cZwV
 DLCOS+4B+hy5KcjcB6/Z0BmktATtI/wtrHJFP6pKrKlY2+AUcD
 bdUEQZV/YtpsvTKncEgDDAYt3UDFl/o4k5qx6aw7QuF0wxXN/3
 LRPtFH/pK/uKhQUIm3gdvDBai9tRkyjXRBecZCs7YRm4clv0Sj
 kIo421C2EkYGjKuKA50tWnBDJswwyF8PxgotjAIIci8ZFCg+2u
 C1NXU5nYgawQmC9xOAyf3nZ5SL965GoF9HFtDVMvZJCteR+fsb
 E7Qn7SUWYEAiME2q0IR4i11QkPX6iSqe8uhhf5dNWs1ETu/WnX
 RV0p1MzGipsZgially4s=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 June 2014 15:28:19 Bart Van Assche wrote:
> Patch "bug: Make BUG() always stop the machine" changed the
> behavior of BUG() with CONFIG_BUG=n from a no-op into an infinite
> loop. Modify the definition of BUG_ON() accordingly such that the
> behavior of BUG_ON(1) is identical to that of BUG().
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  include/asm-generic/bug.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
> index 630dd23..f3241cd 100644
> --- a/include/asm-generic/bug.h
> +++ b/include/asm-generic/bug.h
> @@ -142,7 +142,7 @@ extern void warn_slowpath_null(const char *file, const int line);
>  #endif
>  
>  #ifndef HAVE_ARCH_BUG_ON
> -#define BUG_ON(condition) do { if (condition) ; } while (0)
> +#define BUG_ON(condition) do { } while (unlikely(condition))
>  #endif
>  
>  #ifndef HAVE_ARCH_WARN_ON
> 

How about making it 

	do { if (condition) BUG(); } while (0)

That way it can be optimized for architectures that have their own
BUG but not BUG_ON.

	Arnd
