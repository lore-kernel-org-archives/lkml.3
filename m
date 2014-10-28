Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751766AbaJ1MfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 08:35:20 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:36899 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaJ1MfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 08:35:17 -0400
Date: Tue, 28 Oct 2014 14:35:11 +0200
From: Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: perex@perex.cz, bhelgaas@google.com, benoit.taine@lip6.fr, arnd@arndb.de,
        opw-kernel@googlegroups.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sound: pci: pcxhr: convert timeval to ktime_t
Message-ID: <20141028123511.GA3719@localhost.localdomain>
References: <20141028112955.GA2365@localhost.localdomain>
 <s5hsii88kw0.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <s5hsii88kw0.wl-tiwai@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 12:59:59PM +0100, Takashi Iwai wrote:
> At Tue, 28 Oct 2014 13:29:56 +0200,
> Aya Mahfouz wrote:
> > 
> > This patch is concerned with migrating the time variables in the pcxhr
> > module found in the sound driver. The changes are concerend with the
> > y2038 problem where timeval will overflow in the year 2038. ktime_t
> > was used instead of timeval to get the wall time. The difference
> > is displayed now in nanoseconds instead of microseconds.
> > 
> > Signed-off-by: Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
> > Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> 
> It gets compile errors like below.  Please submit a patch at least
> after build testing.
>

I do actually compile all my patches before submitting them. Since
the change is minor I use make M=sound/pci. My second patch is based
on your compile errors. Kindly let me know how do you compile the
patch to avoid breaking your system in the future.
 
> thanks,
> 
> Takashi
> 

Kind Regards,
Aya Saif El-yazal Mahfouz

> ===
> 
> sound/pci/pcxhr/pcxhr_core.c: In function ‘pcxhr_set_pipe_state’:
> sound/pci/pcxhr/pcxhr_core.c:913:10: error: ‘start’ redeclared as different kind of symbol
>   ktime_t start, stop, diff;
>           ^
> sound/pci/pcxhr/pcxhr_core.c:907:27: note: previous definition of ‘start’ was here
>      int capture_mask, int start)
>                            ^
> In file included from include/linux/printk.h:260:0,
>                  from include/linux/kernel.h:13,
>                  from include/linux/delay.h:10,
>                  from sound/pci/pcxhr/pcxhr_core.c:23:
> sound/pci/pcxhr/pcxhr_core.c:923:13: error: used union type value where scalar is required
>        start ? "START" : "STOP", audio_mask, state);
>              ^
> include/linux/dynamic_debug.h:87:9: note: in definition of macro ‘dynamic_dev_dbg’
>        ##__VA_ARGS__);  \
>          ^
> sound/pci/pcxhr/pcxhr_core.c:921:2: note: in expansion of macro ‘dev_dbg’
>   dev_dbg(&mgr->pci->dev,
>   ^
> sound/pci/pcxhr/pcxhr_core.c:924:6: error: used union type value where scalar is required
>   if (start) {
>       ^
> sound/pci/pcxhr/pcxhr_core.c:950:38: error: used union type value where scalar is required
>    if ((state & audio_mask) == (start ? audio_mask : 0))
>                                       ^
> sound/pci/pcxhr/pcxhr_core.c:958:6: error: wrong type argument to unary exclamation mark
>   if (!start) {
>       ^
> scripts/Makefile.build:257: recipe for target 'sound/pci/pcxhr/pcxhr_core.o' failed
> 
> 
> > ---
> >  sound/pci/pcxhr/pcxhr.c      | 10 ++++++----
> >  sound/pci/pcxhr/pcxhr_core.c | 10 ++++++----
> >  2 files changed, 12 insertions(+), 8 deletions(-)
> > 
> > diff --git a/sound/pci/pcxhr/pcxhr.c b/sound/pci/pcxhr/pcxhr.c
> > index b854fc5..3f4607c 100644
> > --- a/sound/pci/pcxhr/pcxhr.c
> > +++ b/sound/pci/pcxhr/pcxhr.c
> > @@ -711,8 +711,9 @@ static void pcxhr_start_linked_stream(struct pcxhr_mgr *mgr)
> >  	int playback_mask = 0;
> >  
> >  #ifdef CONFIG_SND_DEBUG_VERBOSE
> > -	struct timeval my_tv1, my_tv2;
> > -	do_gettimeofday(&my_tv1);
> > +	ktime_t start, stop, diff;
> > +
> > +	start = ktime_get();
> >  #endif
> >  	mutex_lock(&mgr->setup_mutex);
> >  
> > @@ -823,9 +824,10 @@ static void pcxhr_start_linked_stream(struct pcxhr_mgr *mgr)
> >  	mutex_unlock(&mgr->setup_mutex);
> >  
> >  #ifdef CONFIG_SND_DEBUG_VERBOSE
> > -	do_gettimeofday(&my_tv2);
> > +	stop = ktime_get();
> > +	diff = ktime_sub(stop, start);
> >  	dev_dbg(&mgr->pci->dev, "***TRIGGER START*** TIME = %ld (err = %x)\n",
> > -		    (long)(my_tv2.tv_usec - my_tv1.tv_usec), err);
> > +			(long)(ktime_to_ns(diff)), err);
> >  #endif
> >  }
> >  
> > diff --git a/sound/pci/pcxhr/pcxhr_core.c b/sound/pci/pcxhr/pcxhr_core.c
> > index a584acb..be3c003 100644
> > --- a/sound/pci/pcxhr/pcxhr_core.c
> > +++ b/sound/pci/pcxhr/pcxhr_core.c
> > @@ -910,8 +910,9 @@ int pcxhr_set_pipe_state(struct pcxhr_mgr *mgr, int playback_mask,
> >  	int audio_mask;
> >  
> >  #ifdef CONFIG_SND_DEBUG_VERBOSE
> > -	struct timeval my_tv1, my_tv2;
> > -	do_gettimeofday(&my_tv1);
> > +	ktime_t start, stop, diff;
> > +
> > +	start = ktime_get();
> >  #endif
> >  	audio_mask = (playback_mask |
> >  		      (capture_mask << PCXHR_PIPE_STATE_CAPTURE_OFFSET));
> > @@ -960,9 +961,10 @@ int pcxhr_set_pipe_state(struct pcxhr_mgr *mgr, int playback_mask,
> >  			return err;
> >  	}
> >  #ifdef CONFIG_SND_DEBUG_VERBOSE
> > -	do_gettimeofday(&my_tv2);
> > +	stop = ktime_get();
> > +	diff = ktime_sub(stop, start);
> >  	dev_dbg(&mgr->pci->dev, "***SET PIPE STATE*** TIME = %ld (err = %x)\n",
> > -		    (long)(my_tv2.tv_usec - my_tv1.tv_usec), err);
> > +			(long)(ktime_to_ns(diff)), err);
> >  #endif
> >  	return 0;
> >  }
> > -- 
> > 1.9.3
> > 
