Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab3HGFMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 01:12:37 -0400
Received: from intranet.asianux.com ([58.214.24.6]:40346 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab3HGFMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 01:12:36 -0400
X-Spam-Score: -100.8
Message-ID: <5201D705.2090805@asianux.com>
Date: Wed, 07 Aug 2013 13:11:33 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>, xi.wang@gmail.com,
        nicolas.dichtel@6wind.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/sysctl_binary.c: improve the usage of return value
 'result'
References: <5200A5E6.9020803@asianux.com> <20130806144339.182beb0a2abddc0782015487@linux-foundation.org>
In-Reply-To: <20130806144339.182beb0a2abddc0782015487@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thank you for your reply in details, especially you are very busy.

My original opinion about optimization is incorrect.

Thanks.

On 08/07/2013 05:43 AM, Andrew Morton wrote:
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
> 
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
> 
> 


-- 
Chen Gang
