Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab3CLFMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 01:12:23 -0400
Received: from mail-ia0-f181.google.com ([209.85.210.181]:38549 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150Ab3CLFMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 01:12:20 -0400
Date: Mon, 11 Mar 2013 22:12:15 -0700
From: Tejun Heo <tj@kernel.org>
To: Lei Wen <adrian.wenl@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        leiwen@marvell.com, wwang27@marvell.com
Subject: Re: workqueue panic in 3.4 kernel
Message-ID: <20130312051215.GU14556@mtj.dyndns.org>
References: <CALZhoSR0+SzPLHzJafmny=o8PJ2d7MaH9N6_6s0QZ_oCQm43Xg@mail.gmail.com>
 <20130305163228.GA12795@htj.dyndns.org>
 <CALZhoSRyjRYVcKpq9cECHWgKkci6V+O_zn2CkiwqnFo57tZDfQ@mail.gmail.com>
 <20130306191408.GN1227@htj.dyndns.org>
 <CALZhoSTPBNjhUP4R=vX0Ot7eAA8POTAy8K5Cd3KRe_y8PzjfFA@mail.gmail.com>
 <CALZhoSRJ+HV93tDJo-57M-SdXi8Z6qW_bRV9FzSfGWuz8j-t8Q@mail.gmail.com>
 <20130307154907.GB29601@htj.dyndns.org>
 <alpine.LFD.2.02.1303071705310.22263@ionos>
 <CALZhoSQBH3RxSoaVDCYoCyRVRndht-Rk0rh_w5Dbp6+5T_auSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALZhoSQBH3RxSoaVDCYoCyRVRndht-Rk0rh_w5Dbp6+5T_auSw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Mar 12, 2013 at 01:08:15PM +0800, Lei Wen wrote:
> diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
> index 8afab27..425d5a2 100644
> --- a/include/linux/workqueue.h
> +++ b/include/linux/workqueue.h
> @@ -189,12 +189,16 @@ static inline unsigned int work_static(struct
> work_struct *work) { return 0; }
>   * NOTE! No point in using "atomic_long_set()": using a direct
>   * assignment of the work data initializer allows the compiler
>   * to generate better code.
> + *
> + * We take the assumption that work should not be inited if it already
> + * hold the pending bit, or bug would be reported.
>   */
>  #ifdef CONFIG_LOCKDEP
>  #define __INIT_WORK(_work, _func, _onstack)                            \
>         do {                                                            \
>                 static struct lock_class_key __key;                     \
>                                                                         \
> +               BUG_ON(work_pending(_work));                            \

You're initializing random piece of memory which may contain any
garbage and triggering BUG if some bit is set on it. No, you can't do
that. debugobj is the right tool for debugging object lifetime issues
and is already supported.

Thanks.

-- 
tejun
