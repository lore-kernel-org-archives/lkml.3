Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427AbaIPVHO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 17:07:14 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:42165 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752095AbaIPVHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 17:07:13 -0400
Date: Tue, 16 Sep 2014 17:07:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jan Kara <jack@suse.cz>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] printk: git rid of [sched_delayed] message for
 printk_deferred
Message-ID: <20140916170709.73ef2993@gandalf.local.home>
In-Reply-To: <20140916203510.GF1205@quack.suse.cz>
References: <20140914050905.GA296@x4>
	<20140914055450.GB296@x4>
	<CAMuHMdUmqvN3GZzfjjHc5W2Dxgx2b0gzVHFUR8P8yUs5iFt_tA@mail.gmail.com>
	<20140915163740.GA12408@x4>
	<20140916105547.GA1205@quack.suse.cz>
	<20140916144252.GB32118@x4>
	<20140916111331.14303381@gandalf.local.home>
	<20140916203510.GF1205@quack.suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Sep 2014 22:35:10 +0200
Jan Kara <jack@suse.cz> wrote:

> On Tue 16-09-14 11:13:31, Steven Rostedt wrote:
> > On Tue, 16 Sep 2014 16:42:52 +0200
> > Markus Trippelsdorf <markus@trippelsdorf.de> wrote:
> > 
> > > commit 458df9fd hardcodes printk_deferred() to KERN_WARNING and inserts
> > > the string "[sched_delayed] " before the actual message.
> > > However it doesn't take into account the KERN_* prefix of the message,
> > > that now ends up in the middle of the output:
> > > 
> > >  [sched_delayed] ^a4CE: hpet increased min_delta_ns to 20115 nsec
> > > 
> > > Fix this by just getting rid of the "[sched_delayed] " scnprintf().
> > 
> > I prefer the "[sched_delayed]" output. It lets us know that the output
> > did not come out immediately, which is important sometimes during
> > debugging. Otherwise it can confuse people, as printk is suppose to be
> > a blocking write.
>   This is a common misconception about printk. It isn't a blocking write
> for ten years or more. If there happens to be someone else printing to
> console, the difference between printk() and printk_deferred() is
> marginal - it used to be bigger when scheduler had its own buffer but these
> days message is inserted in the kernel ring buffer immediately. That's why
> I don't think the prefix is useful anymore.

For the most part it's a blocking write. Yeah, if another CPU is
writing, it wont be a blocking write, but it usually is, I know I
depend on it (when I'm debugging, I usually don't have contention
between CPUs). The important part is that they are done in order. A
delayed print, wont be in order with other printks. That is still a
crucial difference.


> 
> > Can we instead fix the bug instead of nuking the output? That is, move
> > the KERN_* prefix before the "[sched_delayed]" message? I don't think
> > it would be that hard. If you want, I'll write that patch (probably
> > take me 20 minutes at most), but I'm just coming back from medical
> > leave so I prefer not to.
>   Glad to see you back! I'm not opposed to moving the prefix but it doesn't
> seem worth the effort...

I don't know. Since all the printk_deferred() are KERN_WARNING anyway,
we can at least clean them up, and remove the extra loglevel.

-- Steve
