Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615AbaDXFia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 01:38:30 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39580 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaDXFi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 01:38:29 -0400
Message-ID: <53589C8E.5000505@gmail.com>
Date: Thu, 24 Apr 2014 07:09:34 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Heinrich Schuchardt <xypron.glpk@gmx.de>, Eric Paris <eparis@redhat.com>
CC: mtk.manpages@gmail.com, linux-kernel@vger.kernel.org,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/1] fanotify: for FAN_MARK_FLUSH check flags
References: <1398290151-6502-1-git-send-email-xypron.glpk@gmx.de>
In-Reply-To: <1398290151-6502-1-git-send-email-xypron.glpk@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2014 11:55 PM, Heinrich Schuchardt wrote:
> If fanotify_mark is called with illegal value of arguments flags and marks
> it usually returns EINVAL.
> 
> When fanotify_mark is called with FAN_MARK_FLUSH the argument flags is not
> checked for irrelevant flags like FAN_MARK_IGNORED_MASK.
> 
> The patch removes this inconsistency.
> 
> If an irrelevant flag is set error EINVAL is returned.
>
> Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>


So, a small heads up that this change may of course break existing code. 
(Heinrich, see https://lwn.net/Articles/588444/ ). However, 
there is some precedent for such changes (examples in 
https://lwn.net/Articles/588444/), and

* The number of applications out there using fanotify is probably very low
* The number that are using FAN_MARK_FLUSH and misusing the flags will be even lower

So the risk of breakage is likely vanishingly small. So, a qualified

Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>

Cheers,

Michael

> ---
>  fs/notify/fanotify/fanotify_user.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
> index 287a22c..8bba549 100644
> --- a/fs/notify/fanotify/fanotify_user.c
> +++ b/fs/notify/fanotify/fanotify_user.c
> @@ -819,7 +819,10 @@ SYSCALL_DEFINE5(fanotify_mark, int, fanotify_fd, unsigned int, flags,
>  	case FAN_MARK_REMOVE:
>  		if (!mask)
>  			return -EINVAL;
> +		break;
>  	case FAN_MARK_FLUSH:
> +		if (flags & ~(FAN_MARK_MOUNT | FAN_MARK_FLUSH))
> +			return -EINVAL;
>  		break;
>  	default:
>  		return -EINVAL;
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
