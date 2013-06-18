Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933745Ab3FRWG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 18:06:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52039 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932596Ab3FRWG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 18:06:58 -0400
Date: Tue, 18 Jun 2013 15:06:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Jones <davej@redhat.com>,
        David Howells <dhowells@redhat.com>, Imre Deak <imre.deak@intel.com>,
        Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Lukas Czerner <lczerner@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] wait: introduce wait_event_common(wq, condition,
 state, timeout)
Message-Id: <20130618150656.3266771d49f68f86fdb5e3f3@linux-foundation.org>
In-Reply-To: <20130606200316.GB23628@redhat.com>
References: <20130606200257.GA23628@redhat.com>
	<20130606200316.GB23628@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Jun 2013 22:03:16 +0200 Oleg Nesterov <oleg@redhat.com> wrote:

> 1. wait_event_timeout(wq, true, 0) returns zero, I think this is
>    wrong and should be fixed.
> 
>    __wait_event_timeout() was already changed by 4c663cfc but we
>    need the same logic in wait_event_timeout() if the fast-path
>    check succeeds.
> 
> 2. wait_event_timeout/__wait_event_timeout interface do not match
>    wait_event(), you can't use __wait_event_timeout() instead of
>    wait_event_timeout() if you do not need the fast-path check.
> 
> 3. wait_event_* macros duplicate the same code.
> 
> This patch adds a single helper wait_event_common() which hopefully
> does everything right. Compiler optimizes out the "dead" code when
> we do not need signal_pending/schedule_timeout.
> 
> With this patch "size vmlinux" reports that .text/data shrinks but
> I think this depends on gcc/config.

hm,

> -#define __wait_event_interruptible(wq, condition, ret)
> +#define __wait_event_interruptible(wq, condition)

net/irda/af_irda.c:2568:13: error: macro "__wait_event_interruptible" passed 3 arguments, but takes just 2

waddup with that?

__wait_event_interruptible() has several callsites.  I think I'll go
zap and await v2 ;)

