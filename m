Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab3JKFbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 01:31:44 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:57897 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab3JKFbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 01:31:43 -0400
Message-ID: <52578D37.2000004@gmail.com>
Date: Fri, 11 Oct 2013 16:31:35 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>
CC: Dan Rosenberg <dan.j.rosenberg@gmail.com>, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] vsprintf/sysctl: Bugfix, neaten and document %pK
 usages
References: <0aef7497929fd764a88ca7b3c22f082a5c2fe909.1381468961.git.joe@perches.com>
In-Reply-To: <0aef7497929fd764a88ca7b3c22f082a5c2fe909.1381468961.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/13 16:25, Joe Perches wrote:
> Printing kernel pointers via %pK has a minor defect when
> kptr_restrict is set to 2:  the pointer may be emitted
> as "pK-error" instead of all 0's when in an interrupt.

NAK. This is not a defect, as I explained earlier. It is really a defect
that it _doesn't_ print 'pK-error' in all cases. 'pK-error' is for
finding kernel bugs.

If a user sets kptr_restrict to 0 (or 2 with this patch), then pointer
values printed from interrupt handlers will appear as normal (all 0's in
kptr_restrict=2 case), so the user will not notice that the kernel code
is actually buggy. If they ever set kptr_restrict to 1 then they will
start seeing the 'pK-error' value. Since the default kptr_restrict
setting is now 0, it is less likely that users/developers will see the
'pK-error' message for buggy code.

~Ryan

> 
> Fix this defect, neaten the code, and correct the sysctl
> documentation.
> 
> Add missing documentation for 2 other uses: %pNF and %pV.
> 
> Trivially reduces vsprintf.o object size:
> 
> $ size lib/vsprintf.o*
>    text	   data	    bss	    dec	    hex	filename
>   14536	      6	      0	  14542	   38ce	lib/vsprintf.o.new
>   14568	      6	      0	  14574	   38ee	lib/vsprintf.o.old
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  Documentation/sysctl/kernel.txt | 17 +++++++++--------
>  lib/vsprintf.c                  | 38 ++++++++++++++++++++++++--------------
>  2 files changed, 33 insertions(+), 22 deletions(-)
> 
> diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
> index 9d4c1d1..c17d5ca 100644
> --- a/Documentation/sysctl/kernel.txt
> +++ b/Documentation/sysctl/kernel.txt
> @@ -289,14 +289,15 @@ Default value is "/sbin/hotplug".
>  
>  kptr_restrict:
>  
> -This toggle indicates whether restrictions are placed on
> -exposing kernel addresses via /proc and other interfaces.  When
> -kptr_restrict is set to (0), there are no restrictions.  When
> -kptr_restrict is set to (1), the default, kernel pointers
> -printed using the %pK format specifier will be replaced with 0's
> -unless the user has CAP_SYSLOG.  When kptr_restrict is set to
> -(2), kernel pointers printed using %pK will be replaced with 0's
> -regardless of privileges.
> +This toggle indicates whether restrictions are placed on exposing kernel
> +addresses via /proc and other interfaces.
> +
> +When kptr_restrict is set to (0), the default, there are no restrictions.
> +When kptr_restrict is set to (1), kernel pointers printed using the %pK
> +format specifier will be replaced with 0's unless the user has CAP_SYSLOG
> +and effective user and group ids are equal to the real ids.
> +When kptr_restrict is set to (2), kernel pointers printed using %pK will
> +be replaced with 0's regardless of privileges.
>  
>  ==============================================================
>  
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index 26559bd..ce55f52 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -1301,21 +1301,28 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
>  			va_end(va);
>  			return buf;
>  		}
> -	case 'K':
> -		/*
> -		 * %pK cannot be used in IRQ context because its test
> -		 * for CAP_SYSLOG would be meaningless.
> -		 */
> -		if (kptr_restrict && (in_irq() || in_serving_softirq() ||
> -				      in_nmi())) {
> -			if (spec.field_width == -1)
> -				spec.field_width = default_width;
> -			return string(buf, end, "pK-error", spec);
> -		}
> -		if (!((kptr_restrict == 0) ||
> -		      (kptr_restrict == 1 &&
> -		       has_capability_noaudit(current, CAP_SYSLOG))))
> +	case 'K':		/* see: Documentation/sysctl/kernel.txt */
> +		switch (kptr_restrict) {
> +		case 0:			/* None (default) */
> +			break;
> +		case 1:			/* Restricted */
> +			if (in_irq() || in_serving_softirq() || in_nmi()) {
> +				/*
> +				 * This cannot be used in IRQ context because
> +				 * the test for CAP_SYSLOG would be meaningless
> +				 */
> +				if (spec.field_width == -1)
> +					spec.field_width = default_width;
> +				return string(buf, end, "pK-error", spec);
> +			}
> +			if (!has_capability_noaudit(current, CAP_SYSLOG))
> +				ptr = NULL;
> +			break;
> +		case 2:			/* Never - Always emit 0 */
> +		default:
>  			ptr = NULL;
> +			break;
> +		}
>  		break;
>  	case 'N':
>  		switch (fmt[1]) {
> @@ -1574,6 +1581,9 @@ qualifier:
>   * %piS depending on sa_family of 'struct sockaddr *' print IPv4/IPv6 address
>   * %pU[bBlL] print a UUID/GUID in big or little endian using lower or upper
>   *   case.
> + * %pV recurse and output a struct va_format (const char *fmt, va_list *)
> + * %pK output a kernel address or 0 depending on sysctl kptr_restrict
> + * %NF output a netdev_features_t
>   * %*ph[CDN] a variable-length hex string with a separator (supports up to 64
>   *           bytes of the input)
>   * %n is ignored
> 

