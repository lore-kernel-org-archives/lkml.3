Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbaCLNNr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 09:13:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45407 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395AbaCLNNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 09:13:46 -0400
Date: Wed, 12 Mar 2014 14:13:44 +0100
From: Jan Kara <jack@suse.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>, Jiri Bohac <jbohac@suse.cz>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: is printk() safe within a timekeeper_seq write section?
Message-ID: <20140312131344.GA28695@quack.suse.cz>
References: <20140306174531.GA30634@midget.suse.cz>
 <531F6429.8050008@linaro.org>
 <alpine.DEB.2.02.1403112040100.18573@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1403112040100.18573@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 11-03-14 22:32:26, Thomas Gleixner wrote:
> On Tue, 11 Mar 2014, John Stultz wrote:
> > I was also surprised the seqlock lockdep enablement changes wouldn't
> > catch this, but Jiri pointed out printk calls lockdep_off in
> > vprintk_emit() - which makes sense as you don't want lockdep splats
> > calling printk and recursing - but is frustrating to have that hole in
> > the checking.
> > 
> > There's a few spots where we do printks with the timekeeping seqlock
> > held, and they're annoyingly nested far enough to make deferring the
> > printk awkward. So I'm half thinking we could have some sort of buffer
> > something like time_printk() could fill and then flush it after the lock
> > is dropped. Then we just need something to warn if any new printks' are
> > added to timekeeping seqlock sequences.
> > 
> > The whole thing makes my head spin a bit, since even if we remove the
> > explicit printks, I'm not sure where else printk might be triggered
> > (like via lockdep warnings, for instance), where it might be unsafe.
> > 
> > Peter/Thomas: Any thoughts on the deferred printk buffer? Does printk
> > already have something like this? Any other ideas here?
> 
> I was thinking about something like that for RT as on RT printk is a
> complete nightmare. It's simple to implement that, but as we know from
> the RT experience it can lead to painful loss of debug output.
> 
> Assume you printk inside such a region, which just fills the dmesg
> buffer and schedules the delayed output. Now in that same region you
> run into a deadlock which causes the whole machine to freeze. Then you
> won't see the debug output, which might actually give you the hint why
> the system deadlocked ....
  Certainly just adding messages to printk buffer is more prone to loosing
the messages on error. OTOH if we schedule something like irq work to do
the printing (as currently happens with scheduler messages), loosing
messages should be relatively rare, shouldn't it?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
