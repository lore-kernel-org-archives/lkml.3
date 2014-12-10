Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbaLJAZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 19:25:29 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:45094 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaLJAZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 19:25:27 -0500
Date: Tue, 9 Dec 2014 18:25:23 -0600
From: rkuo <rkuo@codeaurora.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kevin Cernekee <cernekee@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH] hexagon: Fix build failures in linux-next
Message-ID: <20141210002523.GA17946@codeaurora.org>
References: <1418163705-1816-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418163705-1816-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 02:21:45PM -0800, Guenter Roeck wrote:
> hexagon:defconfig fails to build in linux-next since commit 332fd7c4fef5
> ("genirq: Generic chip: Change irq_reg_{readl,writel} arguments").
> 
> The primary build failure is
> 
> arch/hexagon/include/asm/cacheflush.h: In function 'copy_to_user_page':
> arch/hexagon/include/asm/cacheflush.h:89:22: error: 'VM_EXEC' undeclared
> 
> This is the result of including of <linux/io.h> from <linux/irq.h>,
> which is now necessary due to the use of readl and writel from irq.h.
> This causes recursive inclusions in hexagon code; cacheflush.h is included
> from mm.h prior to the definition of VM_EXEC.
> 
> Fix the problem by moving copy_to_user_page from the hexagon include file to
> arch/hexagon/mm/cache.c, similar to other architectures. After this change,
> several redefinitions of readl and writel are reported. Those are caused
> by recursive inclusions of io.h and asm/cacheflush.h. Fix those problems by
> reducing the number of files included from those files. Also, it was necessary
> to stop including asm-generic/cacheflush.h from asm/cacheflush.h. Instead,
> functionality originally provided by asm-generic/cacheflush.h is now coded
> in asm/cacheflush.h directly.
> 
> Cc: Kevin Cernekee <cernekee@gmail.com>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> Compile tested only. Applies to linux-next as well as mainline.
> 
>  arch/hexagon/include/asm/cacheflush.h | 36 ++++++++++++++++++-----------------
>  arch/hexagon/include/asm/io.h         |  5 -----
>  arch/hexagon/kernel/setup.c           |  1 +
>  arch/hexagon/mm/cache.c               | 10 ++++++++++
>  arch/hexagon/mm/ioremap.c             |  1 +
>  5 files changed, 31 insertions(+), 22 deletions(-)
> 

Thanks for the cleanup; tested working on hardware.

I'm fine taking this into my tree, or it can go via another tree if more
expedient.


Acked-by: Richard Kuo <rkuo@codeaurora.org>



-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, 
a Linux Foundation Collaborative Project
