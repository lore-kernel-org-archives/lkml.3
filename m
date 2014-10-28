Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbaJ1RNN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:13:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:50972 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbaJ1RNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:13:12 -0400
Date: Tue, 28 Oct 2014 18:13:09 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
cc: Heena Sirwani <heenasirwani@gmail.com>, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org
Subject: Re: [PATCH v2] timekeeping: Added a function to return tv_sec portion
 of ktime_get_real_ts64()
In-Reply-To: <3267270.TT2UKZmIpE@wuerfel>
Message-ID: <alpine.DEB.2.11.1410281805410.5308@nanos>
References: <20141027050804.GA8550@heena-HP-Compaq-8200-Elite-MT-PC> <alpine.DEB.2.11.1410281641350.5308@nanos> <3267270.TT2UKZmIpE@wuerfel>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2014, Arnd Bergmann wrote:
> On Tuesday 28 October 2014 16:43:42 Thomas Gleixner wrote:
> > >  
> > > +time64_t ktime_get_real_seconds(void)
> > > +{
> > > +     time64_t seconds;
> > > +     struct timekeeper *tk = &tk_core.timekeeper;
> > > +     unsigned int seq;
> > > +
> > > +     if (IS_ENABLED(CONFIG_64BIT))
> > > +             return tk->xtime_sec;
> > > +
> > > +     do {
> > > +             seq = read_seqcount_begin(&tk_core.seq);
> > > +             seconds = tk->xtime_sec;
> > > +
> > > +     } while (read_seqcount_retry(&tk_core.seq, seq));
> > > +
> > > +     return seconds;
> > > +}
> > > +EXPORT_SYMBOL_GPL(ktime_get_real_seconds);
> > 
> > Nice and clean implementation! Though I wonder whether we should just
> > name it get_seconds64().
> > 
> 
> I don't have a strong opinion here, I suggested ktime_get_real_seconds()
> for consistency with ktime_get_real_ts64(), but get_seconds64() would
> make as much sense.
> 
> As I mentioned in my other reply, we have also concluded that returning
> 'unsigned long' from get_seconds() at the moment is actually not a
> problem for y2038 because it will do the right until 2106 by returning
> the unsigned lower 32-bit of the correct 64-bit number, so we might
> not actually need this one.

Well, the issue is that some of the use cases feed it into a time_t...

I think we should convert all in kernel users to get_seconds64 and get
rid of get_seconds. The few cases which work until 2016 can do with
the truncated value.
 
> I also don't have a strong opinion on this matter, adding it would
> make it easier for developers to pick get_seconds64/ktime_get_real_ts64()
> and understand that it's correct without having to know the finer
> details of the time_t/ulong distinction.

Right. I really want to convert all kernel time interfaces to the 64
postfix and remove the old interfaces. No point in changing the names
back. That also has the advantage that for functions which are similar
in user space we have a clear distinction.

Thanks,

	tglx
