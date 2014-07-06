Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751143AbaGFJPm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 05:15:42 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:37768 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaGFJPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 05:15:40 -0400
Date: Sun, 6 Jul 2014 11:15:30 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Helge Deller <deller@gmx.de>
Cc: Eric Paris <eparis@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>, linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] fix fanotify_mark() breakage on big endian 32bit kernel
Message-ID: <20140706091530.GA3589@osiris>
References: <20140704151235.GA22454@ls3530.dhcp.wdf.sap.corp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140704151235.GA22454@ls3530.dhcp.wdf.sap.corp>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070609-2966-0000-0000-0000006EFBFD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2014 at 05:12:35PM +0200, Helge Deller wrote:
> This patch affects big endian architectures only.
> 
> On those with 32bit userspace and 64bit kernel (CONFIG_COMPAT=y) the
> 64bit mask parameter is correctly constructed out of two 32bit values in
> the compat_fanotify_mark() function and then passed as 64bit parameter
> to the fanotify_mark() syscall.
> 
> But for the CONFIG_COMPAT=n case (32bit kernel & userspace),
> compat_fanotify_mark() isn't used and the fanotify_mark syscall implementation
> is used directly. In that case the upper and lower 32 bits of the 64bit mask
> parameter is still swapped on big endian machines and thus leads to
> fanotify_mark failing with -EINVAL.

Why do you think upper and lower 32 bits are swapped on big endian machines?
At least an s390 the C ABI defines that 64 bit values are split into an
even odd register pair, where the most significant bits are in the even numbered
register.

So for sys_fanotify_mark everything is fine on s390, and probably most other
architectures as well. Having a 64 bit syscall parameter indeed does work,
if all the architecture specific details have been correctly considered.

> Here is a strace of the same 32bit executable (fanotify01 testcase from LTP):
> 
> On a 64bit kernel it suceeds:
> syscall_322(0, 0, 0x3, 0x3, 0x266c8, 0x1) = 0x3
> syscall_323(0x3, 0x1, 0, 0x3b, 0xffffff9c, 0x266c8) = 0
> 
> On a 32bit kernel it fails:
> syscall_322(0, 0, 0x3, 0x3, 0x266c8, 0x1) = 0x3
> syscall_323(0x3, 0x1, 0, 0x3b, 0xffffff9c, 0x266c8) = -1 (errno 22)

So "0" and "0x3b" together should be the 64 bit "0x3b" mask, this looks just
fine.

> diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
> index 3fdc8a3..374261c 100644
> --- a/fs/notify/fanotify/fanotify_user.c
> +++ b/fs/notify/fanotify/fanotify_user.c
> @@ -787,6 +787,10 @@ SYSCALL_DEFINE5(fanotify_mark, int, fanotify_fd, unsigned int, flags,
>  	struct path path;
>  	int ret;
> 
> +#if defined(__BIG_ENDIAN) && !defined(CONFIG_64BIT)
> +	mask = (mask << 32) | (mask >> 32);
> +#endif
> +
>  	pr_debug("%s: fanotify_fd=%d flags=%x dfd=%d pathname=%p mask=%llx\n",
>  		 __func__, fanotify_fd, flags, dfd, pathname, mask);

Did you activate this pr_debug()? I'm really wondering what the output looks
like on your machine.

