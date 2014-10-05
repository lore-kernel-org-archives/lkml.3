Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbaJEVYx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 17:24:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:52081 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbaJEVYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 17:24:52 -0400
Date: Sun, 5 Oct 2014 23:24:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Oleg Nesterov <oleg@redhat.com>
cc: Mathias Krause <minipli@googlemail.com>, linux-kernel@vger.kernel.org,
        Brad Spengler <spender@grsecurity.net>,
        PaX Team <pageexec@freemail.hu>
Subject: Re: [PATCH] posix-timers: fix stack info leak in timer_create()
In-Reply-To: <20141005210614.GA28899@redhat.com>
Message-ID: <alpine.DEB.2.11.1410052314380.4383@nanos>
References: <1412456799-32339-1-git-send-email-minipli@googlemail.com> <20141005210614.GA28899@redhat.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Oct 2014, Oleg Nesterov wrote:
> In any case this all looks confusing to me. sys_timer_create() does
> 
> 	new_timer->sigq->info.si_value = event.sigev_value;
> 	new_timer->sigq->info.si_tid   = new_timer->it_id;
> 
> later, this writes to the differents members (_rt and _timer) in the
> same union. But the comment in struct siginfo says that we should use
> _timer. And copy_siginfo_to_user() reports si_tid and si_ptr, this
> again reads _timer and _rt. This should actually work, _sigval should
> have the same offset in both struct's, still it looks confusing imho.

It does.

> Perhaps we should change
> 
> 	#define si_value	_sifields._rt._sigval
> 	#define si_int		_sifields._rt._sigval.sival_int
> 	#define si_ptr		_sifields._rt._sigval.sival_ptr
> 
> to use _timer instead. Nevermind, this is off-topic.

Well that would cause mqueue, perf and procfs to read/set the timer
fields. Odd as well.

Thanks,

	tglx
