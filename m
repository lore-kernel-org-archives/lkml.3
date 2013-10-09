Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab3JILO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 07:14:28 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:36619 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab3JILO1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 07:14:27 -0400
Message-ID: <52553A8D.4090906@gmail.com>
Date: Wed, 09 Oct 2013 07:14:21 -0400
From: Dan Rosenberg <dan.j.rosenberg@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Ryan Mallon <rmallon@gmail.com>, Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>, eldad@fogrefinery.com,
        Jiri Kosina <jkosina@suse.cz>, jgunthorpe@obsidianresearch.com,
        Kees Cook <keescook@chromium.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        George Spelvin <linux@horizon.com>,
        "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] vsprintf: Check real user/group id for %pK
References: <5254A034.5020700@gmail.com>	 <1381279758.23937.42.camel@joe-AO722> <1381282200.23937.45.camel@joe-AO722>	 <5254B787.6080700@gmail.com> <1381284056.23937.49.camel@joe-AO722> <5254BDD0.7040001@gmail.com>
In-Reply-To: <5254BDD0.7040001@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2013 10:22 PM, Ryan Mallon wrote:
> Ah, I misread it. It does however check when kptr_restrict != 0, not
> just when kptr_restrict is 1. I've left the in_irq test as-is, but used
> a switch as suggested. I don't really care either way, I think the
> original check is quite readable. Anyway, updated patch below:
>
> ~Ryan

This seems mostly fine to me, except the "proccess" -> "process" nit Joe
already identified.

I think I also prefer Joe's style of having an explicit "case 2" in the
switch statement in addition to the default case for clarity.

Also, isn't the default value of kptr_restrict 0 now, unless I'm missing
something? If I recall it was 1 when originally written, and then
changed to 0 at some point. Could the documentation be updated to
reflect that?

-Dan

> ---
>
> diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
> index 9d4c1d1..eac53d5 100644
> --- a/Documentation/sysctl/kernel.txt
> +++ b/Documentation/sysctl/kernel.txt
> @@ -290,13 +290,15 @@ Default value is "/sbin/hotplug".
>  kptr_restrict:
>  
>  This toggle indicates whether restrictions are placed on
> -exposing kernel addresses via /proc and other interfaces.  When
> -kptr_restrict is set to (0), there are no restrictions.  When
> -kptr_restrict is set to (1), the default, kernel pointers
> +exposing kernel addresses via /proc and other interfaces.
> +
> +When kptr_restrict is set to (0), there are no restrictions.
> +When kptr_restrict is set to (1), the default, kernel pointers
>  printed using the %pK format specifier will be replaced with 0's
> -unless the user has CAP_SYSLOG.  When kptr_restrict is set to
> -(2), kernel pointers printed using %pK will be replaced with 0's
> -regardless of privileges.
> +unless the user has CAP_SYSLOG and effective user and group ids
> +are equal to the real ids.
> +When kptr_restrict is set to (2), kernel pointers printed using
> +%pK will be replaced with 0's regardless of privileges.
>  
>  ==============================================================
>  
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index 26559bd..6dd8c5d 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -27,6 +27,7 @@
>  #include <linux/uaccess.h>
>  #include <linux/ioport.h>
>  #include <linux/dcache.h>
> +#include <linux/cred.h>
>  #include <net/addrconf.h>
>  
>  #include <asm/page.h>		/* for PAGE_SIZE */
> @@ -1312,11 +1313,36 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
>  				spec.field_width = default_width;
>  			return string(buf, end, "pK-error", spec);
>  		}
> -		if (!((kptr_restrict == 0) ||
> -		      (kptr_restrict == 1 &&
> -		       has_capability_noaudit(current, CAP_SYSLOG))))
> +
> +		switch (kptr_restrict) {
> +		case 0:
> +			/* Always print %pK values */
> +			break;
> +		case 1: {
> +			/*
> +			 * Only print the real pointer value if the current
> +			 * proccess has CAP_SYSLOG and is running with the
> +			 * same credentials it started with. This is because
> +			 * access to files is checked at open() time, but %pK
> +			 * checks permission at read() time. We don't want to
> +			 * leak pointer values if a binary opens a file using
> +			 * %pK and then elevates privileges before reading it.
> +			 */
> +			const struct cred *cred = current_cred();
> +
> +			if (!has_capability_noaudit(current, CAP_SYSLOG) ||
> +			    !uid_eq(cred->euid, cred->uid) ||
> +			    !gid_eq(cred->egid, cred->gid))
> +				ptr = NULL;
> +			break;
> +		}
> +		default:
> +			/* Always print 0's for %pK */
>  			ptr = NULL;
> +			break;
> +		}
>  		break;
> +
>  	case 'N':
>  		switch (fmt[1]) {
>  		case 'F':
>
>
>
>
>


