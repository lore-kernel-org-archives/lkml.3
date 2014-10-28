Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbaJ1PuO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 11:50:14 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:51315 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaJ1PuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 11:50:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Heena Sirwani <heenasirwani@gmail.com>, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org
Subject: Re: [PATCH v2] timekeeping: Added a function to return tv_sec portion of ktime_get_real_ts64()
Date: Tue, 28 Oct 2014 16:50:01 +0100
Message-ID: <3267270.TT2UKZmIpE@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.11.1410281641350.5308@nanos>
References: <20141027050804.GA8550@heena-HP-Compaq-8200-Elite-MT-PC> <alpine.DEB.2.11.1410281641350.5308@nanos>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Y1/ee/ADz1S4h7vZ4DYWAvhA7+7DzafAmYBosbqc6Lu
 inD/pFdvhQplFR4XM6v/iWuRGp4RWUNDJtl7BSVJHhGCs5KL7r
 TN2Sif9J6uw00M6QVfHPSxlO0S6IC7NG4mty0EAdn6zlMz8Eho
 GC914hEAJS054D8UFlb26FO1E38Rg7xESErBUQluE09VDLbRrB
 d9C7XMqyKaMYna9WCH+Ezoi2Imhr6ZLcqZRPRKN9FsKc+puWbC
 AK8zZXe/EOx04RTFadakusBCh3aGEntuJvRlHzMdarhib/5a3y
 Uf795ye/vdMxlLadw9JMB7lsiHq/wY88cDFboRct93HghuCEHG
 h53W0T0/uIS/N8KGB4Ss=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 October 2014 16:43:42 Thomas Gleixner wrote:
> >  
> > +time64_t ktime_get_real_seconds(void)
> > +{
> > +     time64_t seconds;
> > +     struct timekeeper *tk = &tk_core.timekeeper;
> > +     unsigned int seq;
> > +
> > +     if (IS_ENABLED(CONFIG_64BIT))
> > +             return tk->xtime_sec;
> > +
> > +     do {
> > +             seq = read_seqcount_begin(&tk_core.seq);
> > +             seconds = tk->xtime_sec;
> > +
> > +     } while (read_seqcount_retry(&tk_core.seq, seq));
> > +
> > +     return seconds;
> > +}
> > +EXPORT_SYMBOL_GPL(ktime_get_real_seconds);
> 
> Nice and clean implementation! Though I wonder whether we should just
> name it get_seconds64().
> 

I don't have a strong opinion here, I suggested ktime_get_real_seconds()
for consistency with ktime_get_real_ts64(), but get_seconds64() would
make as much sense.

As I mentioned in my other reply, we have also concluded that returning
'unsigned long' from get_seconds() at the moment is actually not a
problem for y2038 because it will do the right until 2106 by returning
the unsigned lower 32-bit of the correct 64-bit number, so we might
not actually need this one.

I also don't have a strong opinion on this matter, adding it would
make it easier for developers to pick get_seconds64/ktime_get_real_ts64()
and understand that it's correct without having to know the finer
details of the time_t/ulong distinction.

	Arnd
