Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbaBOO1G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 09:27:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153AbaBOO1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 09:27:04 -0500
Date: Sat, 15 Feb 2014 15:27:00 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Dave Jones <davej@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140215142700.GA15540@redhat.com>
References: <20140212042215.GN18016@ZenIV.linux.org.uk> <20140212054043.GB13997@dastard> <CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com> <20140212113928.GO18016@ZenIV.linux.org.uk> <CA+55aFywwx0Q8xK2GJiRJ+FV7PQEKoBRxDUxW4052FVyd5XOpg@mail.gmail.com> <20140212211421.GP18016@ZenIV.linux.org.uk> <CA+55aFyobyUNFo=3rpdbxTqgV7OQetCKbCfwEEbgxUcT-1+30w@mail.gmail.com> <20140213174020.GA14455@redhat.com> <CA+55aFxwozCQ05axLB02R3huX8sj=20EoFfw0cSDDL8fBE_Y6Q@mail.gmail.com> <20140215052531.GX18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140215052531.GX18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15, Al Viro wrote:
>
> OK, _very_ preliminary patch follows.  It's uglier than it has to

And I'm afraid it needs more uglifications...

> +void dismiss_siginfo(ksiginfo_t *info)
> +{
> +	if (info->q)
> +		__sigqueue_free(info->q);
> +	info->q = NULL;
> +}

1. info->q can be already freed if SIGQUEUE_PREALLOC.

   Once get_signal_to_deliver() or any other caller drops ->siglock
   another thread can do sys_timer_delete()->sigqueue_free().

2. We need to move do_schedule_next_timer() from dequeue_signal()
   here.

   Otherwise ->q can be reused/overwritten by the next send_sigqueue()
   right affter ->siglock is dropped.

Oleg.

