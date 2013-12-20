Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab3LTIaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 03:30:22 -0500
Received: from alt-proxy17.mail.unifiedlayer.com ([66.147.241.60]:59409 "HELO
	alt-proxy17.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751383Ab3LTIaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 03:30:20 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Dec 2013 03:30:20 EST
Message-ID: <1387527808.4022.6.camel@slavad-ubuntu>
Subject: Re: [PATCH] fs/nilfs2: Integer overflow in nilfs_ioctl_wrap_copy()
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Reply-To: slava@dubeyko.com
To: Wenliang Fan <fanwlexca@gmail.com>
Cc: konishi.ryusuke@lab.ntt.co.jp, linux-nilfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 20 Dec 2013 12:23:28 +0400
In-Reply-To: <1387525568-30025-1-git-send-email-fanwlexca@gmail.com>
References: <1387525568-30025-1-git-send-email-fanwlexca@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 109.188.126.151 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-12-20 at 15:46 +0800, Wenliang Fan wrote:
> The local variable 'pos' comes from userspace. If a large number was
> passed, there would be an integer overflow in the following line:
> 	pos += n;
> 

What about check before enter into the cycle? If you are talking about
possible huge number then you can receive huge number from userspace
before entering in the cycle.

Thanks,
Vyacheslav Dubeyko.

> Signed-off-by: Wenliang Fan <fanwlexca@gmail.com>
> ---
>  fs/nilfs2/ioctl.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index b44bdb2..b2bac9a 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -90,8 +90,13 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
>  		total += nr;
>  		if ((size_t)nr < n)
>  			break;
> -		if (pos == ppos)
> +		if (pos == ppos) {
> +			if (pos > ULONG_MAX - n) {
> +				ret = -EINVAL;
> +				break;
> +			}
>  			pos += n;
> +		}
>  	}
>  	argv->v_nmembs = total;
>  


