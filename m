Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714Ab3HFWOD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 18:14:03 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:42166 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756632Ab3HFWOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 18:14:01 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chen Gang <gang.chen@asianux.com>, Al Viro <viro@zeniv.linux.org.uk>,
        xi.wang@gmail.com, nicolas.dichtel@6wind.com,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <5200A5E6.9020803@asianux.com>
	<20130806144339.182beb0a2abddc0782015487@linux-foundation.org>
Date: Tue, 06 Aug 2013 15:13:42 -0700
In-Reply-To: <20130806144339.182beb0a2abddc0782015487@linux-foundation.org>
	(Andrew Morton's message of "Tue, 6 Aug 2013 14:43:39 -0700")
Message-ID: <87zjsu5uy1.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+fGSuRz8GUAfSNZIsTqKLhpnUfYToAfAM=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0287]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] kernel/sysctl_binary.c: improve the usage of return value 'result'
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Tue, 06 Aug 2013 15:29:42 +0800 Chen Gang <gang.chen@asianux.com> wrote:
>
>> Improve the usage of return value 'result', so not only can make code
>> clearer to readers, but also can improve the performance.
>
> It used to be pervasive kernel style do to
>
> 	ret = -ENOMEM;
> 	foo = alloc(...);
> 	if (!foo)
> 		goto out;
>
> whereas nowadays people usually do the more straightforward
>
> 	foo = alloc(...);
> 	if (!foo) {
> 		ret = -ENOMEM;
> 		goto out;
> 	}
>
> The thinking was that the old style generated better code, but for the
> life of me I can't remember why :(

Because doing the assignment outside of the if() goto .  Allows the
compiler to emit the if() goto as a single branch.

While a smart compiler may perform the code motion across the branch,
it is much easier for the compiler to branch to somewhere else perform
the assignment and then branch out.

Eric


> Your patch switches from old-style to new-style.  And it appears to
> have increased the text size.  I did this, to switch three sites back
> to old-style:
>
> --- a/kernel/sysctl_binary.c~kernel-sysctl_binaryc-improve-the-usage-of-return-value-result-fix
> +++ a/kernel/sysctl_binary.c
> @@ -941,17 +941,15 @@ static ssize_t bin_string(struct file *f
>  		copied = result;
>  		lastp = oldval + copied - 1;
>  
> -		if (get_user(ch, lastp)) {
> -			result = -EFAULT;
> +		result = -EFAULT;
> +		if (get_user(ch, lastp))
>  			goto out;
> -		}
>  
>  		/* Trim off the trailing newline */
>  		if (ch == '\n') {
> -			if (put_user('\0', lastp)) {
> -				result = -EFAULT;
> +			result = -EFAULT;
> +			if (put_user('\0', lastp))
>  				goto out;
> -			}
>  			copied -= 1;
>  		}
>  	}
> @@ -976,11 +974,10 @@ static ssize_t bin_intvec(struct file *f
>  	char *buffer;
>  	ssize_t result;
>  
> +	result = -ENOMEM;
>  	buffer = kmalloc(BUFSZ, GFP_KERNEL);
> -	if (!buffer) {
> -		result = -ENOMEM;
> +	if (!buffer)
>  		goto out;
> -	}
>  
>  	if (oldval && oldlen) {
>  		unsigned __user *vec = oldval;
> _
>
> and kernel/sysctl_binary.o's .text got six bytes smaller.
>
> Now, smaller text doesn't mean faster code.  But it probably means
> larger cache footprint, which can mean slower code.
>
> IOW, it isn't obvious that this was an improvement.
