Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab3LJV67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 16:58:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615Ab3LJV65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 16:58:57 -0500
Message-ID: <52A78E9E.8080706@redhat.com>
Date: Tue, 10 Dec 2013 13:58:54 -0800
From: Anand Avati <avati@redhat.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>, Josh Boyer <jwboyer@fedoraproject.org>
CC: James Morris <jmorris@namei.org>, Eric Sandeen <sandeen@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: SELinux change in 3.13 causes sync hang
References: <CA+5PVA56s68i_Ad+FiT_8_OHZt3BeZdpqdzc6RVbgOx68=MaOQ@mail.gmail.com>	 <1386707123.23829.23.camel@flatline.rdu.redhat.com> <1386707744.23829.25.camel@flatline.rdu.redhat.com>
In-Reply-To: <1386707744.23829.25.camel@flatline.rdu.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/13, 12:35 PM, Eric Paris wrote:
> On Tue, 2013-12-10 at 15:25 -0500, Eric Paris wrote:
>
>> I'll try to write a patch to fix that logic...
>
> Anand,
>
> How about something like (untested but it compiles):


Sorry, it took me a while to compare the committed patch and my original 
submission. The original patch did not have the subtype matching issue 
(but had a different issue) and it looks like this bug has come in the 
reworked/committed patch. I think the fix you have pasted below works.

Reviewed-by: Anand Avati <avati@redhat.com>

Thanks,
Avati

>
> diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
> index ee470a0..2b437fc8 100644
> --- a/security/selinux/ss/services.c
> +++ b/security/selinux/ss/services.c
> @@ -2349,9 +2359,17 @@ int security_fs_use(struct super_block *sb)
>   		if (strncmp(fstype, c->u.name, baselen))
>   			continue;
>
> -		/* if there is no subtype, this is the one! */
> -		if (!subtype)
> -			break;
> +		/* current mount has no subtype */
> +		if (!subtype) {
> +			/*
> +			 * if there is no subtype in policy this is our match
> +			 * if there is a subtype in policy keep looking,
> +			 */
> +			if (baselen == strlen(c->u.name))
> +				break;
> +			else
> +				continue;
> +		}
>
>   		/* skip past the base in this entry */
>   		sub = c->u.name + baselen;
>
>

