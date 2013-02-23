Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853Ab3BWTXb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 14:23:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756959Ab3BWTX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 14:23:29 -0500
Date: Sat, 23 Feb 2013 20:21:58 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org, Ben Chan <benchan@chromium.org>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 5/5] coredump: ignore non-fatal signals when core
	dumping to a pipe
Message-ID: <20130223192158.GA9405@redhat.com>
References: <1361008406-2307-1-git-send-email-msb@chromium.org> <1361008406-2307-5-git-send-email-msb@chromium.org> <20130216171010.GE4910@redhat.com> <20130216194643.GA31569@redhat.com> <CACBanvpOVxdiM3FWMiZMM5sAkxXbguT1VhFMkyQv-ntVPE8Y=Q@mail.gmail.com> <20130219142721.GA5709@redhat.com> <CACBanvq+Sdtv-tNXTmJyb3EvXGshC=D4NjR8aVOCjRXcTKp+Mw@mail.gmail.com> <20130219194517.GA9986@redhat.com> <CACBanvo6NqbG7mzD76rM-5kEZ3bOXKfGSbRghvuejSD5S_jnBQ@mail.gmail.com> <CACBanvqF8GjPM0yfEy=7yHCQk5vct6G_T9MD4KJsDiCfwkCQnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACBanvqF8GjPM0yfEy=7yHCQk5vct6G_T9MD4KJsDiCfwkCQnQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mandeep, sorry for delay.

On 02/20, Mandeep Singh Baines wrote:
>
> On Tue, Feb 19, 2013 at 12:20 PM, Mandeep Singh Baines <msb@chromium.org> wrote:
> > Ah. Good point. How about this then:
> >
> > /* can't use wait_event_freezable since we suppress the fake signal on
> > SIGNAL_GROUP_COREDUMP */
> > freezer_do_not_count();
> > wait_event_interruptible(pipe->wait, pipe->readers == 1);
> > freezer_count();

Yes, I thought about freezer_do_not_count() + wait_event_interruptible()
too, but

> No that won't work either. You can't block the fake signal.

Yes.

And wait_event_freezable() can't work because it is buggy, it doesn't
clear TIF_SIGPENDING so it becomes a busy-wait loop after freezing.
34b087e48 broke the logic. Perhaps my fault, I do not remember when
I sent the patch which was applied as 24b7ead3 (but the code was wrong
anyway). And its usage is wrong too, unless I missed something. But
lets discuss this later.

As for coredump, we can fix wait_event_freezable() or reintroduce
recalc_sigpending() in __refrigerator() as you suggested.

But this doesn't solve other problems, we need more try_to_freeze's
before wait_for_dump_helper() is called.

> On suspend, you might truncate a core-dump but at least you can
> reliably suspend.

Btw, yes. Perhaps coredump should simply fail if it races with
freezer, in this case the necessary changes are simple.

But so far I'll try to make the fixes which will allow to freeze
the dumping task correctly, I hope I'll send the patches tomorrow.

It is still not clear to me whether we should change freeze_task(),
but most probably yes, this would be simpler.

Oleg.

