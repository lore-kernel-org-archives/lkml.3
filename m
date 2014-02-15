Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbaBOPW7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 10:22:59 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:52930 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361AbaBOPW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 10:22:58 -0500
Date: Sat, 15 Feb 2014 15:22:51 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Dave Jones <davej@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140215152251.GY18016@ZenIV.linux.org.uk>
References: <20140212054043.GB13997@dastard>
 <CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com>
 <20140212113928.GO18016@ZenIV.linux.org.uk>
 <CA+55aFywwx0Q8xK2GJiRJ+FV7PQEKoBRxDUxW4052FVyd5XOpg@mail.gmail.com>
 <20140212211421.GP18016@ZenIV.linux.org.uk>
 <CA+55aFyobyUNFo=3rpdbxTqgV7OQetCKbCfwEEbgxUcT-1+30w@mail.gmail.com>
 <20140213174020.GA14455@redhat.com>
 <CA+55aFxwozCQ05axLB02R3huX8sj=20EoFfw0cSDDL8fBE_Y6Q@mail.gmail.com>
 <20140215052531.GX18016@ZenIV.linux.org.uk>
 <20140215142700.GA15540@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140215142700.GA15540@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 15, 2014 at 03:27:00PM +0100, Oleg Nesterov wrote:

> 1. info->q can be already freed if SIGQUEUE_PREALLOC.
> 
>    Once get_signal_to_deliver() or any other caller drops ->siglock
>    another thread can do sys_timer_delete()->sigqueue_free().

How the devil would it find the sucker?  It's off the list already.

> 2. We need to move do_schedule_next_timer() from dequeue_signal()
>    here.
> 
>    Otherwise ->q can be reused/overwritten by the next send_sigqueue()
>    right affter ->siglock is dropped.

Ditto.  We rip them out of queue on collect_signal(); the only thing we do
not do is actual __sigqueue_free().
