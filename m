Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387Ab3LTQq5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 11:46:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53027 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab3LTQq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 11:46:56 -0500
Date: Fri, 20 Dec 2013 08:47:05 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Frank Haverkamp <haver@linux.vnet.ibm.com>
Cc: fengguang.wu@intel.com, jim.epost@gmail.com, sfr@canb.auug.org.au,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        kbuild-all@01.org
Subject: Re: [PATCH 1/2] GenWQE: Fix endian issues detected by sparse
Message-ID: <20131220164705.GA24804@kroah.com>
References: <CA+r1Zhimt7Xusnc4kkkVqfoRhfZRnreMmZqaN7WP7rSpZ3XTvw@mail.gmail.com>
 <1387553171-31469-1-git-send-email-haver@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387553171-31469-1-git-send-email-haver@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 04:26:10PM +0100, Frank Haverkamp wrote:
> Fengguang Wu used CF=-D__CHECK_ENDIAN__ to check the GenWQE driver for
> endian issues. Sparse found a couple of those. Most of them were caused
> by not correctly handling __be64/32 and __u64/32. Those I was able to
> fix with appropriate castings.
> 
> One more serious issue was the ATS entry in struct genwqe_ddcb_cmd.
> The kernel expected it in big-endian, but the type was defined __u64.
> I decided that it is better to keep the interface consistent using
> host endian byte-odering instead of having a mixture. With this change
> the kernel likes to see host endian byte order for the ATS entry. That
> would have been an interface change, if someone would have used the
> driver already. Since this is not the case, I hope it is ok to fix it
> now.
> 
> For the genqwe_readq/writeq/readl/writel functions I enforced the casts.
> 
> It still complains, as far as I can see, about some copy_to/from_user()
> usages:
> 
>   CHECK   char-misc/drivers/misc/genwqe/card_dev.c
> char-misc/arch/x86/include/asm/uaccess.h:625:18: warning: incorrect type in argument 1 (different modifiers)
> char-misc/arch/x86/include/asm/uaccess.h:625:18:    expected void *<noident>
> char-misc/arch/x86/include/asm/uaccess.h:625:18:    got void const *from
> char-misc/arch/x86/include/asm/uaccess.h:625:18: warning: incorrect type in argument 1 (different modifiers)
> char-misc/arch/x86/include/asm/uaccess.h:625:18:    expected void *<noident>
> char-misc/arch/x86/include/asm/uaccess.h:625:18:    got void const *from
> char-misc/arch/x86/include/asm/uaccess.h:625:18: warning: incorrect type in argument 1 (different modifiers)
> char-misc/arch/x86/include/asm/uaccess.h:625:18:    expected void *<noident>
> char-misc/arch/x86/include/asm/uaccess.h:625:18:    got void const *from
> char-misc/arch/x86/include/asm/uaccess.h:625:18: warning: incorrect type in argument 1 (different modifiers)
> char-misc/arch/x86/include/asm/uaccess.h:625:18:    expected void *<noident>
> char-misc/arch/x86/include/asm/uaccess.h:625:18:    got void const *from
>   CC [M]  drivers/misc/genwqe/card_dev.o
>   CHECK   char-misc/drivers/misc/genwqe/card_ddcb.c
> char-misc/arch/x86/include/asm/uaccess.h:625:18: warning: incorrect type in argument 1 (different modifiers)
> char-misc/arch/x86/include/asm/uaccess.h:625:18:    expected void *<noident>
> char-misc/arch/x86/include/asm/uaccess.h:625:18:    got void const *from
> char-misc/arch/x86/include/asm/uaccess.h:625:18: warning: incorrect type in argument 1 (different modifiers)
> char-misc/arch/x86/include/asm/uaccess.h:625:18:    expected void *<noident>
> char-misc/arch/x86/include/asm/uaccess.h:625:18:    got void const *from
>   CC [M]  drivers/misc/genwqe/card_ddcb.o
>   LD [M]  drivers/misc/genwqe/genwqe_card.o
> 
> I appreciate some help from you to figure out what is causig those, and
> making a proposal how to fix them.
> 
> I included the missing header file to fix the
> implicit-function-declaration warning when using dynamic_hex_dump.
> 
> Signed-off-by: Frank Haverkamp <haver@linux.vnet.ibm.com>

In the future (I missed this as well), please use a "Reported-by:" tag
to document who reported the problem to you.

thanks,

greg k-h
