Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649AbaJ1Tyg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 15:54:36 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:51361 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbaJ1Tyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 15:54:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Heena Sirwani <heenasirwani@gmail.com>, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org
Subject: Re: [PATCH v2] timekeeping: Added a function to return tv_sec portion of ktime_get_real_ts64()
Date: Tue, 28 Oct 2014 20:54:30 +0100
Message-ID: <9160485.26T1OFaUNG@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.11.1410281805410.5308@nanos>
References: <20141027050804.GA8550@heena-HP-Compaq-8200-Elite-MT-PC> <3267270.TT2UKZmIpE@wuerfel> <alpine.DEB.2.11.1410281805410.5308@nanos>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:e5JztzurZj532uGlbwMbJz/DBRKKBBQtFq/RyfDHgv4
 MPPBciBHvadgBKAAZE2HcTsbJ6LzYwpVaiYYcO7JYDsLvVERzB
 8C2Qaq31Vk8zlzONZbmlplfkM8bws/DV1CCHSeohYYmlPnSfDv
 qMMjILqcdZTcFUcs7jMgLo+sJcCREsywKB6i6etC035O48lViQ
 HSj7xgQjEODGMRsy8zrzF9+STVuBD2JG8S9KwGaD3gbmAcjteg
 qy86zRfNEolHjxJYwR1S/3CVZHAkVfQrrhF5q4CBfHm2Sm23pE
 EuMsKnMRu+bcYPeoV6OfQJXBHhT5IGigawelusOoL2C0c0bprh
 eEDcoz9YFiSPGBmrJyCA=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 October 2014 18:13:09 Thomas Gleixner wrote:
> On Tue, 28 Oct 2014, Arnd Bergmann wrote:
> > On Tuesday 28 October 2014 16:43:42 Thomas Gleixner wrote:
> > > >  
> > > > +time64_t ktime_get_real_seconds(void)
> > > > +{
> > > > +     time64_t seconds;
> > > > +     struct timekeeper *tk = &tk_core.timekeeper;
> > > > +     unsigned int seq;
> > > > +
> > > > +     if (IS_ENABLED(CONFIG_64BIT))
> > > > +             return tk->xtime_sec;
> > > > +
> > > > +     do {
> > > > +             seq = read_seqcount_begin(&tk_core.seq);
> > > > +             seconds = tk->xtime_sec;
> > > > +
> > > > +     } while (read_seqcount_retry(&tk_core.seq, seq));
> > > > +
> > > > +     return seconds;
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(ktime_get_real_seconds);
> > > 
> > > Nice and clean implementation! Though I wonder whether we should just
> > > name it get_seconds64().
> > > 
> > 
> > I don't have a strong opinion here, I suggested ktime_get_real_seconds()
> > for consistency with ktime_get_real_ts64(), but get_seconds64() would
> > make as much sense.
> > 
> > As I mentioned in my other reply, we have also concluded that returning
> > 'unsigned long' from get_seconds() at the moment is actually not a
> > problem for y2038 because it will do the right until 2106 by returning
> > the unsigned lower 32-bit of the correct 64-bit number, so we might
> > not actually need this one.
> 
> Well, the issue is that some of the use cases feed it into a time_t...
> 
> I think we should convert all in kernel users to get_seconds64 and get
> rid of get_seconds. The few cases which work until 2016 can do with
> the truncated value.
>
> > I also don't have a strong opinion on this matter, adding it would
> > make it easier for developers to pick get_seconds64/ktime_get_real_ts64()
> > and understand that it's correct without having to know the finer
> > details of the time_t/ulong distinction.
> 
> Right. I really want to convert all kernel time interfaces to the 64
> postfix and remove the old interfaces. No point in changing the names
> back. That also has the advantage that for functions which are similar
> in user space we have a clear distinction.

Ok, fair enough. Let's make both ktime_get_real_seconds() and
ktime_get_seconds() return a time64_t then and use those in new code.

I'd like to apply this patch to my y2038 branch and apply the
other patches that need it on top, unless you want to still submit
it for 3.18.

Regarding the names, should we then have

time64_t ktime_get_real_seconds(void);
time64_t ktime_get_seconds(void);

or

time64_t get_seconds64(void);
time64_t ktime_get_seconds64(void);

If you don't have a preference either way, I guess we can just stay
with the patch that Heena did, otherwise it would be a trivial
change.

	Arnd
