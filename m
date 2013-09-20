Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab3ITLVg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 07:21:36 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:48988 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480Ab3ITLVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 07:21:34 -0400
MIME-Version: 1.0
In-Reply-To: <CAJd=RBD_6FMHS3Dg_Zqugs4YCHHDeCgrxypANpPP5K2xTLE0bA@mail.gmail.com>
References: <CAJd=RBBbJMWox5yJaNzW_jUdDfKfWe-Y7d1riYdN6huQStxzcA@mail.gmail.com>
 <CAOMqctQyS2SFraqJpzE0sRFcihFpMHRhT+3QuZhxft=SUXYVDw@mail.gmail.com>
 <CAOMqctQ+XchmXk_Xno6ViAoZF-tHFPpDWoy7LVW1nooa+ywbmg@mail.gmail.com>
 <CAOMqctT2u7E0kwpm052B9pkNo4D=sYHO+Vk=P_TziUb5KvTMKA@mail.gmail.com>
 <20130917211317.GB6537@quack.suse.cz> <CAOMqctT5Wi_Y9ODAnoG-RQiO1oJ+yKR=LnF21swuupyLShL=+w@mail.gmail.com>
 <CAJd=RBD_6FMHS3Dg_Zqugs4YCHHDeCgrxypANpPP5K2xTLE0bA@mail.gmail.com>
From: Michal Suchanek <hramrach@gmail.com>
Date: Fri, 20 Sep 2013 13:20:53 +0200
Message-ID: <CAOMqctSyovsfff++g=cUfRLmyBM9nHrQ7RB4R7z96-aXr9QcEw@mail.gmail.com>
Subject: Re: doing lots of disk writes causes oom killer to kill processes
To: Hillf Danton <dhillf@gmail.com>, Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 19 September 2013 10:07, Hillf Danton <dhillf@gmail.com> wrote:
> Hello Michal
>
> Take it easy please, the kernel is made by human hands.
>
> Can you please try the diff(and sorry if mail agent reformats it)?
>
> Best Regards
> Hillf
>
>
> --- a/mm/vmscan.c Wed Sep 18 08:44:08 2013
> +++ b/mm/vmscan.c Wed Sep 18 09:31:34 2013
> @@ -1543,8 +1543,11 @@ shrink_inactive_list(unsigned long nr_to
>   * implies that pages are cycling through the LRU faster than
>   * they are written so also forcibly stall.
>   */
> - if (nr_unqueued_dirty == nr_taken || nr_immediate)
> + if (nr_unqueued_dirty == nr_taken || nr_immediate) {
> + if (current_is_kswapd())
> + wakeup_flusher_threads(0, WB_REASON_TRY_TO_FREE_PAGES);
>   congestion_wait(BLK_RW_ASYNC, HZ/10);
> + }
>   }
>
>   /*
> --

I applied the patch and raised the dirty block ratios to 30/10 and the
default 60/40 while imaging a VM and did not observe any problems so I
guess this solves it.

Thanks

Michal
