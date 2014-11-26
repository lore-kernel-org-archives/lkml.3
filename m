Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372AbaKZK6H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 05:58:07 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:59942 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbaKZK6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 05:58:05 -0500
Date: Wed, 26 Nov 2014 16:19:13 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ALSA: korg1212: cleanup of printk
Message-ID: <20141126104912.GA1085@sudip-PC>
References: <1416730251-5194-1-git-send-email-sudipm.mukherjee@gmail.com>
 <s5hh9xottl9.wl-tiwai@suse.de>
 <1416849910.8797.1.camel@perches.com>
 <20141125062132.GA3380@sudip-PC>
 <1416941965.8358.6.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416941965.8358.6.camel@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 10:59:25AM -0800, Joe Perches wrote:
> On Tue, 2014-11-25 at 11:51 +0530, Sudip Mukherjee wrote:
> > problems with this way:
> > 1) macro name is little misleading - macro says printk, but we are using dev_dbg
> > 2) if some one later wants to add something to this file, and doesnot want to use the variable name korg1212 in his function.
> > 
> > any suggestions ?
> 
> Some code is so old and unlikely to be ever used
> again, it may be better to move it to an "ancient
> and crufty" folder and forget about it.
> 
> This may be one of those.
> 
> If the debugging was written in a more current style,
> it might look like this: (with various format/argument
> mismatches fixed, formatting changes, etc)

ok. and can't we delete some of the messages like "DSP download is complete." and then printing the statename. there are lots of messages like that which is just printing the function name and the statename ..

and, even if i modify it a little and send it, most of the work has been done by you. so how do i send the patch in your name or add your name in the patch ? I have not done anything so my name should not be there.

thanks
sudip

> 
> I don't have this card (does anyone?), so it's compiled
> but untested.
> ---
>  sound/pci/korg1212/korg1212.c | 363 +++++++++++++++++++++---------------------
>  1 file changed, 184 insertions(+), 179 deletions(-)
> 
> diff --git a/sound/pci/korg1212/korg1212.c b/sound/pci/korg1212/korg1212.c
> index 59d21c9..9dd7f96 100644
> --- a/sound/pci/korg1212/korg1212.c
> +++ b/sound/pci/korg1212/korg1212.c
> @@ -38,20 +38,9 @@
>  
>  #include <asm/io.h>
>  
> -// ----------------------------------------------------------------------------
> -// Debug Stuff
> -// ----------------------------------------------------------------------------
> -#define K1212_DEBUG_LEVEL		0
> -#if K1212_DEBUG_LEVEL > 0
> -#define K1212_DEBUG_PRINTK(fmt,args...)	printk(KERN_DEBUG fmt,##args)
> -#else
> -#define K1212_DEBUG_PRINTK(fmt,...)
> -#endif
> -#if K1212_DEBUG_LEVEL > 1
> -#define K1212_DEBUG_PRINTK_VERBOSE(fmt,args...)	printk(KERN_DEBUG fmt,##args)
> -#else
> -#define K1212_DEBUG_PRINTK_VERBOSE(fmt,...)
> -#endif
> +/* #define K1212_DEBUG_MEMORY_RANGES */
> +#define k1212_dbg(k1212, fmt, ...)                      \
> +	dev_dbg((k1212)->card->dev, fmt, ##__VA_ARGS__)
>  
>  // ----------------------------------------------------------------------------
>  // Record/Play Buffer Allocation Method. If K1212_LARGEALLOC is defined all 
> @@ -530,12 +519,12 @@ static int snd_korg1212_Send1212Command(struct snd_korg1212 *korg1212,
>  	int rc = K1212_CMDRET_Success;
>  
>          if (!korg1212->outDoorbellPtr) {
> -		K1212_DEBUG_PRINTK_VERBOSE("K1212_DEBUG: CardUninitialized\n");
> +		k1212_dbg(korg1212, "CardUninitialized\n");
>                  return K1212_CMDRET_CardUninitialized;
>  	}
>  
> -	K1212_DEBUG_PRINTK("K1212_DEBUG: Card <- 0x%08x 0x%08x [%s]\n",
> -			   doorbellVal, mailBox0Val, stateName[korg1212->cardState]);
> +	k1212_dbg(korg1212, "Card <- 0x%08x 0x%08x [%s]\n",
> +		  doorbellVal, mailBox0Val, stateName[korg1212->cardState]);
>          for (retryCount = 0; retryCount < MAX_COMMAND_RETRIES; retryCount++) {
>  		writel(mailBox3Val, korg1212->mailbox3Ptr);
>                  writel(mailBox2Val, korg1212->mailbox2Ptr);
> @@ -562,7 +551,7 @@ static int snd_korg1212_Send1212Command(struct snd_korg1212 *korg1212,
>                  mailBox3Lo = readl(korg1212->mailbox3Ptr);
>                  if (mailBox3Lo & COMMAND_ACK_MASK) {
>                  	if ((mailBox3Lo & DOORBELL_VAL_MASK) == (doorbellVal & DOORBELL_VAL_MASK)) {
> -				K1212_DEBUG_PRINTK_VERBOSE("K1212_DEBUG: Card <- Success\n");
> +				k1212_dbg(korg1212, "Card <- Success\n");
>                                  rc = K1212_CMDRET_Success;
>  				break;
>                          }
> @@ -571,7 +560,7 @@ static int snd_korg1212_Send1212Command(struct snd_korg1212 *korg1212,
>          korg1212->cmdRetryCount += retryCount;
>  
>  	if (retryCount >= MAX_COMMAND_RETRIES) {
> -		K1212_DEBUG_PRINTK_VERBOSE("K1212_DEBUG: Card <- NoAckFromCard\n");
> +		k1212_dbg(korg1212, "Card <- NoAckFromCard\n");
>          	rc = K1212_CMDRET_NoAckFromCard;
>  	}
>  
> @@ -612,8 +601,8 @@ static void snd_korg1212_timer_func(unsigned long data)
>  		korg1212->stop_pending_cnt = 0;
>  		korg1212->dsp_stop_is_processed = 1;
>  		wake_up(&korg1212->wait);
> -		K1212_DEBUG_PRINTK_VERBOSE("K1212_DEBUG: Stop ack'ed [%s]\n",
> -					   stateName[korg1212->cardState]);
> +		k1212_dbg(korg1212, "Stop ack'ed [%s]\n",
> +			  stateName[korg1212->cardState]);
>  	} else {
>  		if (--korg1212->stop_pending_cnt > 0) {
>  			/* reprogram timer */
> @@ -624,8 +613,8 @@ static void snd_korg1212_timer_func(unsigned long data)
>  			korg1212->sharedBufferPtr->cardCommand = 0;
>  			korg1212->dsp_stop_is_processed = 1;
>  			wake_up(&korg1212->wait);
> -			K1212_DEBUG_PRINTK("K1212_DEBUG: Stop timeout [%s]\n",
> -					   stateName[korg1212->cardState]);
> +			k1212_dbg(korg1212, "Stop timeout [%s]\n",
> +				  stateName[korg1212->cardState]);
>  		}
>  	}
>  	spin_unlock_irqrestore(&korg1212->lock, flags);
> @@ -660,8 +649,8 @@ static inline void snd_korg1212_setCardState(struct snd_korg1212 * korg1212, enu
>  
>  static int snd_korg1212_OpenCard(struct snd_korg1212 * korg1212)
>  {
> -	K1212_DEBUG_PRINTK("K1212_DEBUG: OpenCard [%s] %d\n",
> -			   stateName[korg1212->cardState], korg1212->opencnt);
> +	k1212_dbg(korg1212, "OpenCard [%s] %d\n",
> +		  stateName[korg1212->cardState], korg1212->opencnt);
>  	mutex_lock(&korg1212->open_mutex);
>          if (korg1212->opencnt++ == 0) {
>  		snd_korg1212_TurnOffIdleMonitor(korg1212);
> @@ -674,8 +663,8 @@ static int snd_korg1212_OpenCard(struct snd_korg1212 * korg1212)
>  
>  static int snd_korg1212_CloseCard(struct snd_korg1212 * korg1212)
>  {
> -	K1212_DEBUG_PRINTK("K1212_DEBUG: CloseCard [%s] %d\n",
> -			   stateName[korg1212->cardState], korg1212->opencnt);
> +	k1212_dbg(korg1212, "CloseCard [%s] %d\n",
> +		  stateName[korg1212->cardState], korg1212->opencnt);
>  
>  	mutex_lock(&korg1212->open_mutex);
>  	if (--(korg1212->opencnt)) {
> @@ -687,8 +676,8 @@ static int snd_korg1212_CloseCard(struct snd_korg1212 * korg1212)
>                  int rc = snd_korg1212_Send1212Command(korg1212, K1212_DB_SelectPlayMode,
>                                  K1212_MODE_StopPlay, 0, 0, 0);
>  		if (rc)
> -			K1212_DEBUG_PRINTK("K1212_DEBUG: CloseCard - RC = %d [%s]\n",
> -					   rc, stateName[korg1212->cardState]);
> +			k1212_dbg(korg1212, "CloseCard - RC = %d [%s]\n",
> +				  rc, stateName[korg1212->cardState]);
>  		if (rc != K1212_CMDRET_Success) {
>  			mutex_unlock(&korg1212->open_mutex);
>                          return 0;
> @@ -711,8 +700,8 @@ static int snd_korg1212_SetupForPlay(struct snd_korg1212 * korg1212)
>  {
>  	int rc;
>  
> -	K1212_DEBUG_PRINTK("K1212_DEBUG: SetupForPlay [%s] %d\n",
> -			   stateName[korg1212->cardState], korg1212->setcnt);
> +	k1212_dbg(korg1212, "SetupForPlay [%s] %d\n",
> +		  stateName[korg1212->cardState], korg1212->setcnt);
>  
>          if (korg1212->setcnt++)
>  		return 0;
> @@ -721,8 +710,8 @@ static int snd_korg1212_SetupForPlay(struct snd_korg1212 * korg1212)
>          rc = snd_korg1212_Send1212Command(korg1212, K1212_DB_SelectPlayMode,
>                                          K1212_MODE_SetupPlay, 0, 0, 0);
>  	if (rc)
> -		K1212_DEBUG_PRINTK("K1212_DEBUG: SetupForPlay - RC = %d [%s]\n",
> -				   rc, stateName[korg1212->cardState]);
> +		k1212_dbg(korg1212, "SetupForPlay - RC = %d [%s]\n",
> +			  rc, stateName[korg1212->cardState]);
>          if (rc != K1212_CMDRET_Success) {
>                  return 1;
>          }
> @@ -734,8 +723,8 @@ static int snd_korg1212_TriggerPlay(struct snd_korg1212 * korg1212)
>  {
>  	int rc;
>  
> -	K1212_DEBUG_PRINTK("K1212_DEBUG: TriggerPlay [%s] %d\n",
> -			   stateName[korg1212->cardState], korg1212->playcnt);
> +	k1212_dbg(korg1212, "TriggerPlay [%s] %d\n",
> +		  stateName[korg1212->cardState], korg1212->playcnt);
>  
>          if (korg1212->playcnt++)
>  		return 0;
> @@ -743,8 +732,8 @@ static int snd_korg1212_TriggerPlay(struct snd_korg1212 * korg1212)
>          snd_korg1212_setCardState(korg1212, K1212_STATE_PLAYING);
>          rc = snd_korg1212_Send1212Command(korg1212, K1212_DB_TriggerPlay, 0, 0, 0, 0);
>  	if (rc)
> -		K1212_DEBUG_PRINTK("K1212_DEBUG: TriggerPlay - RC = %d [%s]\n",
> -				   rc, stateName[korg1212->cardState]);
> +		k1212_dbg(korg1212, "TriggerPlay - RC = %d [%s]\n",
> +			  rc, stateName[korg1212->cardState]);
>          if (rc != K1212_CMDRET_Success) {
>                  return 1;
>          }
> @@ -754,8 +743,8 @@ static int snd_korg1212_TriggerPlay(struct snd_korg1212 * korg1212)
>  /* spinlock already held */
>  static int snd_korg1212_StopPlay(struct snd_korg1212 * korg1212)
>  {
> -	K1212_DEBUG_PRINTK("K1212_DEBUG: StopPlay [%s] %d\n",
> -			   stateName[korg1212->cardState], korg1212->playcnt);
> +	k1212_dbg(korg1212, "StopPlay [%s] %d\n",
> +		  stateName[korg1212->cardState], korg1212->playcnt);
>  
>          if (--(korg1212->playcnt)) 
>  		return 0;
> @@ -784,8 +773,8 @@ static void snd_korg1212_EnableCardInterrupts(struct snd_korg1212 * korg1212)
>  static int snd_korg1212_SetMonitorMode(struct snd_korg1212 *korg1212,
>  				       enum MonitorModeSelector mode)
>  {
> -	K1212_DEBUG_PRINTK("K1212_DEBUG: SetMonitorMode [%s]\n",
> -			   stateName[korg1212->cardState]);
> +	k1212_dbg(korg1212, "SetMonitorMode [%s]\n",
> +		  stateName[korg1212->cardState]);
>  
>          switch (mode) {
>  	case K1212_MONMODE_Off:
> @@ -866,8 +855,8 @@ static int snd_korg1212_SetRate(struct snd_korg1212 *korg1212, int rate)
>  					  ClockSourceSelector[korg1212->clkSrcRate],
>  					  0, 0, 0);
>  	if (rc)
> -		K1212_DEBUG_PRINTK("K1212_DEBUG: Set Clock Source Selector - RC = %d [%s]\n",
> -				   rc, stateName[korg1212->cardState]);
> +		k1212_dbg(korg1212, "Set Clock Source Selector - RC = %d [%s]\n",
> +			  rc, stateName[korg1212->cardState]);
>  
>          return 0;
>  }
> @@ -902,8 +891,8 @@ static int snd_korg1212_WriteADCSensitivity(struct snd_korg1212 *korg1212)
>          u16       count;
>  	unsigned long flags;
>  
> -	K1212_DEBUG_PRINTK("K1212_DEBUG: WriteADCSensivity [%s]\n",
> -			   stateName[korg1212->cardState]);
> +	k1212_dbg(korg1212, "WriteADCSensivity [%s]\n",
> +		  stateName[korg1212->cardState]);
>  
>          // ----------------------------------------------------------------------------
>          // initialize things.  The local init bit is always set when writing to the
> @@ -1026,8 +1015,8 @@ static int snd_korg1212_WriteADCSensitivity(struct snd_korg1212 *korg1212)
>                  int rc = snd_korg1212_Send1212Command(korg1212, K1212_DB_SelectPlayMode,
>                                  K1212_MODE_MonitorOn, 0, 0, 0);
>  	        if (rc)
> -			K1212_DEBUG_PRINTK("K1212_DEBUG: WriteADCSensivity - RC = %d [%s]\n",
> -					   rc, stateName[korg1212->cardState]);
> +			k1212_dbg(korg1212, "WriteADCSensivity - RC = %d [%s]\n",
> +				  rc, stateName[korg1212->cardState]);
>          }
>  
>  	spin_unlock_irqrestore(&korg1212->lock, flags);
> @@ -1039,8 +1028,8 @@ static void snd_korg1212_OnDSPDownloadComplete(struct snd_korg1212 *korg1212)
>  {
>          int channel, rc;
>  
> -        K1212_DEBUG_PRINTK("K1212_DEBUG: DSP download is complete. [%s]\n",
> -			   stateName[korg1212->cardState]);
> +	k1212_dbg(korg1212, "DSP download is complete. [%s]\n",
> +		  stateName[korg1212->cardState]);
>  
>          // ----------------------------------------------------
>          // tell the card to boot
> @@ -1048,8 +1037,8 @@ static void snd_korg1212_OnDSPDownloadComplete(struct snd_korg1212 *korg1212)
>          rc = snd_korg1212_Send1212Command(korg1212, K1212_DB_BootFromDSPPage4, 0, 0, 0, 0);
>  
>  	if (rc)
> -		K1212_DEBUG_PRINTK("K1212_DEBUG: Boot from Page 4 - RC = %d [%s]\n",
> -				   rc, stateName[korg1212->cardState]);
> +		k1212_dbg(korg1212, "Boot from Page 4 - RC = %d [%s]\n",
> +			  rc, stateName[korg1212->cardState]);
>  	msleep(DSP_BOOT_DELAY_IN_MS);
>  
>          // --------------------------------------------------------------------------------
> @@ -1065,8 +1054,8 @@ static void snd_korg1212_OnDSPDownloadComplete(struct snd_korg1212 *korg1212)
>          );
>  
>  	if (rc)
> -		K1212_DEBUG_PRINTK("K1212_DEBUG: Configure Buffer Memory - RC = %d [%s]\n",
> -				   rc, stateName[korg1212->cardState]);
> +		k1212_dbg(korg1212, "Configure Buffer Memory - RC = %d [%s]\n",
> +			  rc, stateName[korg1212->cardState]);
>  
>          udelay(INTERCOMMAND_DELAY);
>  
> @@ -1079,8 +1068,8 @@ static void snd_korg1212_OnDSPDownloadComplete(struct snd_korg1212 *korg1212)
>          );
>  
>  	if (rc)
> -		K1212_DEBUG_PRINTK("K1212_DEBUG: Configure Misc Memory - RC = %d [%s]\n",
> -				   rc, stateName[korg1212->cardState]);
> +		k1212_dbg(korg1212, "Configure Misc Memory - RC = %d [%s]\n",
> +			  rc, stateName[korg1212->cardState]);
>  
>          // --------------------------------------------------------------------------------
>          // Initialize the routing and volume tables, then update the card's state.
> @@ -1100,15 +1089,15 @@ static void snd_korg1212_OnDSPDownloadComplete(struct snd_korg1212 *korg1212)
>  					  ClockSourceSelector[korg1212->clkSrcRate],
>  					  0, 0, 0);
>  	if (rc)
> -		K1212_DEBUG_PRINTK("K1212_DEBUG: Set Clock Source Selector - RC = %d [%s]\n",
> -				   rc, stateName[korg1212->cardState]);
> +		k1212_dbg(korg1212, "Set Clock Source Selector - RC = %d [%s]\n",
> +			  rc, stateName[korg1212->cardState]);
>  
>  	rc = snd_korg1212_TurnOnIdleMonitor(korg1212);
>  	snd_korg1212_setCardState(korg1212, K1212_STATE_READY);
>  
>  	if (rc)
> -		K1212_DEBUG_PRINTK("K1212_DEBUG: Set Monitor On - RC = %d [%s]\n",
> -				   rc, stateName[korg1212->cardState]);
> +		k1212_dbg(korg1212, "Set Monitor On - RC = %d [%s]\n",
> +			  rc, stateName[korg1212->cardState]);
>  
>  	snd_korg1212_setCardState(korg1212, K1212_STATE_DSP_COMPLETE);
>  }
> @@ -1133,9 +1122,9 @@ static irqreturn_t snd_korg1212_interrupt(int irq, void *dev_id)
>  
>          switch (doorbellValue) {
>                  case K1212_DB_DSPDownloadDone:
> -                        K1212_DEBUG_PRINTK("K1212_DEBUG: IRQ DNLD count - %ld, %x, [%s].\n",
> -					   korg1212->irqcount, doorbellValue,
> -					   stateName[korg1212->cardState]);
> +			k1212_dbg(korg1212, "IRQ DNLD count - %ld, %x, [%s]\n",
> +				  korg1212->irqcount, doorbellValue,
> +				  stateName[korg1212->cardState]);
>                          if (korg1212->cardState == K1212_STATE_DSP_IN_PROCESS) {
>  				korg1212->dsp_is_loaded = 1;
>  				wake_up(&korg1212->wait);
> @@ -1146,9 +1135,9 @@ static irqreturn_t snd_korg1212_interrupt(int irq, void *dev_id)
>                  // an error occurred - stop the card
>                  // ------------------------------------------------------------------------
>                  case K1212_DB_DMAERROR:
> -			K1212_DEBUG_PRINTK_VERBOSE("K1212_DEBUG: IRQ DMAE count - %ld, %x, [%s].\n",
> -						   korg1212->irqcount, doorbellValue,
> -						   stateName[korg1212->cardState]);
> +			k1212_dbg(korg1212, "IRQ DMAE count - %ld, %x, [%s].\n",
> +				  korg1212->irqcount, doorbellValue,
> +				  stateName[korg1212->cardState]);
>  			snd_printk(KERN_ERR "korg1212: DMA Error\n");
>  			korg1212->errorcnt++;
>  			korg1212->totalerrorcnt++;
> @@ -1161,16 +1150,17 @@ static irqreturn_t snd_korg1212_interrupt(int irq, void *dev_id)
>                  // the semaphore in case someone is waiting for this.
>                  // ------------------------------------------------------------------------
>                  case K1212_DB_CARDSTOPPED:
> -                        K1212_DEBUG_PRINTK_VERBOSE("K1212_DEBUG: IRQ CSTP count - %ld, %x, [%s].\n",
> -						   korg1212->irqcount, doorbellValue,
> -						   stateName[korg1212->cardState]);
> +			k1212_dbg(korg1212, "IRQ CSTP count - %ld, %x, [%s]\n",
> +				  korg1212->irqcount, doorbellValue,
> +				  stateName[korg1212->cardState]);
>  			korg1212->sharedBufferPtr->cardCommand = 0;
>                          break;
>  
>                  default:
> -			K1212_DEBUG_PRINTK_VERBOSE("K1212_DEBUG: IRQ DFLT count - %ld, %x, cpos=%d [%s].\n",
> -			       korg1212->irqcount, doorbellValue, 
> -			       korg1212->currentBuffer, stateName[korg1212->cardState]);
> +			k1212_dbg(korg1212, "IRQ DFLT count - %ld, %x, cpos=%d [%s]\n",
> +				  korg1212->irqcount, doorbellValue,
> +				  korg1212->currentBuffer,
> +				  stateName[korg1212->cardState]);
>                          if ((korg1212->cardState > K1212_STATE_SETUP) || korg1212->idleMonitorOn) {
>                                  korg1212->currentBuffer++;
>  
> @@ -1206,8 +1196,8 @@ static int snd_korg1212_downloadDSPCode(struct snd_korg1212 *korg1212)
>  {
>  	int rc;
>  
> -        K1212_DEBUG_PRINTK("K1212_DEBUG: DSP download is starting... [%s]\n",
> -			   stateName[korg1212->cardState]);
> +	k1212_dbg(korg1212, "DSP download is starting... [%s]\n",
> +		  stateName[korg1212->cardState]);
>  
>          // ---------------------------------------------------------------
>          // verify the state of the card before proceeding.
> @@ -1221,8 +1211,8 @@ static int snd_korg1212_downloadDSPCode(struct snd_korg1212 *korg1212)
>                                       UpperWordSwap(korg1212->dma_dsp.addr),
>                                       0, 0, 0);
>  	if (rc)
> -		K1212_DEBUG_PRINTK("K1212_DEBUG: Start DSP Download RC = %d [%s]\n",
> -				   rc, stateName[korg1212->cardState]);
> +		k1212_dbg(korg1212, "Start DSP Download RC = %d [%s]\n",
> +			  rc, stateName[korg1212->cardState]);
>  
>  	korg1212->dsp_is_loaded = 0;
>  	wait_event_timeout(korg1212->wait, korg1212->dsp_is_loaded, HZ * CARD_BOOT_TIMEOUT);
> @@ -1281,16 +1271,16 @@ static int snd_korg1212_silence(struct snd_korg1212 *korg1212, int pos, int coun
>  	struct KorgAudioFrame * dst =  korg1212->playDataBufsPtr[0].bufferData + pos;
>  	int i;
>  
> -	K1212_DEBUG_PRINTK_VERBOSE("K1212_DEBUG: snd_korg1212_silence pos=%d offset=%d size=%d count=%d\n",
> -				   pos, offset, size, count);
> +	k1212_dbg(korg1212, "snd_korg1212_silence pos=%d offset=%d size=%d count=%d\n",
> +		  pos, offset, size, count);
>  	if (snd_BUG_ON(pos + count > K1212_MAX_SAMPLES))
>  		return -EINVAL;
>  
>  	for (i=0; i < count; i++) {
> -#if K1212_DEBUG_LEVEL > 0
> +#ifdef K1212_DEBUG_MEMORY_RANGES
>  		if ( (void *) dst < (void *) korg1212->playDataBufsPtr ||
>  		     (void *) dst > (void *) korg1212->playDataBufsPtr[8].bufferData ) {
> -			printk(KERN_DEBUG "K1212_DEBUG: snd_korg1212_silence KERNEL EFAULT dst=%p iter=%d\n",
> +			printk(KERN_DEBUG "snd_korg1212_silence KERNEL EFAULT dst=%p iter=%d\n",
>  			       dst, i);
>  			return -EFAULT;
>  		}
> @@ -1307,22 +1297,24 @@ static int snd_korg1212_copy_to(struct snd_korg1212 *korg1212, void __user *dst,
>  	struct KorgAudioFrame * src =  korg1212->recordDataBufsPtr[0].bufferData + pos;
>  	int i, rc;
>  
> -	K1212_DEBUG_PRINTK_VERBOSE("K1212_DEBUG: snd_korg1212_copy_to pos=%d offset=%d size=%d\n",
> -				   pos, offset, size);
> +	k1212_dbg(korg1212, "snd_korg1212_copy_to pos=%d offset=%d size=%d\n",
> +		  pos, offset, size);
>  	if (snd_BUG_ON(pos + count > K1212_MAX_SAMPLES))
>  		return -EINVAL;
>  
>  	for (i=0; i < count; i++) {
> -#if K1212_DEBUG_LEVEL > 0
> +#ifdef K1212_DEBUG_MEMORY_RANGES
>  		if ( (void *) src < (void *) korg1212->recordDataBufsPtr ||
>  		     (void *) src > (void *) korg1212->recordDataBufsPtr[8].bufferData ) {
> -			printk(KERN_DEBUG "K1212_DEBUG: snd_korg1212_copy_to KERNEL EFAULT, src=%p dst=%p iter=%d\n", src, dst, i);
> +			printk(KERN_DEBUG "snd_korg1212_copy_to KERNEL EFAULT, src=%p dst=%p iter=%d\n",
> +			       src, dst, i);
>  			return -EFAULT;
>  		}
>  #endif
>  		rc = copy_to_user(dst + offset, src, size);
>  		if (rc) {
> -			K1212_DEBUG_PRINTK("K1212_DEBUG: snd_korg1212_copy_to USER EFAULT src=%p dst=%p iter=%d\n", src, dst, i);
> +			k1212_dbg(korg1212, "snd_korg1212_copy_to USER EFAULT src=%p dst=%p iter=%d\n",
> +				  src, dst, i);
>  			return -EFAULT;
>  		}
>  		src++;
> @@ -1337,23 +1329,25 @@ static int snd_korg1212_copy_from(struct snd_korg1212 *korg1212, void __user *sr
>  	struct KorgAudioFrame * dst =  korg1212->playDataBufsPtr[0].bufferData + pos;
>  	int i, rc;
>  
> -	K1212_DEBUG_PRINTK_VERBOSE("K1212_DEBUG: snd_korg1212_copy_from pos=%d offset=%d size=%d count=%d\n",
> -				   pos, offset, size, count);
> +	k1212_dbg(korg1212, "snd_korg1212_copy_from pos=%d offset=%d size=%d count=%d\n",
> +		  pos, offset, size, count);
>  
>  	if (snd_BUG_ON(pos + count > K1212_MAX_SAMPLES))
>  		return -EINVAL;
>  
>  	for (i=0; i < count; i++) {
> -#if K1212_DEBUG_LEVEL > 0
> +#ifdef K1212_DEBUG_MEMORY_RANGES
>  		if ( (void *) dst < (void *) korg1212->playDataBufsPtr ||
>  		     (void *) dst > (void *) korg1212->playDataBufsPtr[8].bufferData ) {
> -			printk(KERN_DEBUG "K1212_DEBUG: snd_korg1212_copy_from KERNEL EFAULT, src=%p dst=%p iter=%d\n", src, dst, i);
> +			printk(KERN_DEBUG "snd_korg1212_copy_from KERNEL EFAULT, src=%p dst=%p iter=%d\n",
> +			       src, dst, i);
>  			return -EFAULT;
>  		}
>  #endif
>  		rc = copy_from_user((void*) dst + offset, src, size);
>  		if (rc) {
> -			K1212_DEBUG_PRINTK("K1212_DEBUG: snd_korg1212_copy_from USER EFAULT src=%p dst=%p iter=%d\n", src, dst, i);
> +			k1212_dbg(korg1212, "snd_korg1212_copy_from USER EFAULT src=%p dst=%p iter=%d\n",
> +				  src, dst, i);
>  			return -EFAULT;
>  		}
>  		dst++;
> @@ -1367,8 +1361,8 @@ static void snd_korg1212_free_pcm(struct snd_pcm *pcm)
>  {
>          struct snd_korg1212 *korg1212 = pcm->private_data;
>  
> -	K1212_DEBUG_PRINTK("K1212_DEBUG: snd_korg1212_free_pcm [%s]\n",
> -			   stateName[korg1212->cardState]);
> +	k1212_dbg(korg1212, "snd_korg1212_free_pcm [%s]\n",
> +		  stateName[korg1212->cardState]);
>  
>          korg1212->pcm = NULL;
>  }
> @@ -1379,8 +1373,8 @@ static int snd_korg1212_playback_open(struct snd_pcm_substream *substream)
>          struct snd_korg1212 *korg1212 = snd_pcm_substream_chip(substream);
>          struct snd_pcm_runtime *runtime = substream->runtime;
>  
> -	K1212_DEBUG_PRINTK("K1212_DEBUG: snd_korg1212_playback_open [%s]\n",
> -			   stateName[korg1212->cardState]);
> +	k1212_dbg(korg1212, "snd_korg1212_playback_open [%s]\n",
> +		  stateName[korg1212->cardState]);
>  
>  	snd_korg1212_OpenCard(korg1212);
>  
> @@ -1408,8 +1402,8 @@ static int snd_korg1212_capture_open(struct snd_pcm_substream *substream)
>          struct snd_korg1212 *korg1212 = snd_pcm_substream_chip(substream);
>          struct snd_pcm_runtime *runtime = substream->runtime;
>  
> -	K1212_DEBUG_PRINTK("K1212_DEBUG: snd_korg1212_capture_open [%s]\n",
> -			   stateName[korg1212->cardState]);
> +	k1212_dbg(korg1212, "snd_korg1212_capture_open [%s]\n",
> +		  stateName[korg1212->cardState]);
>  
>  	snd_korg1212_OpenCard(korg1212);
>  
> @@ -1435,8 +1429,8 @@ static int snd_korg1212_playback_close(struct snd_pcm_substream *substream)
>          unsigned long flags;
>          struct snd_korg1212 *korg1212 = snd_pcm_substream_chip(substream);
>  
> -	K1212_DEBUG_PRINTK("K1212_DEBUG: snd_korg1212_playback_close [%s]\n",
> -			   stateName[korg1212->cardState]);
> +	k1212_dbg(korg1212, "snd_korg1212_playback_close [%s]\n",
> +		  stateName[korg1212->cardState]);
>  
>  	snd_korg1212_silence(korg1212, 0, K1212_MAX_SAMPLES, 0, korg1212->channels * 2);
>  
> @@ -1457,8 +1451,8 @@ static int snd_korg1212_capture_close(struct snd_pcm_substream *substream)
>          unsigned long flags;
>          struct snd_korg1212 *korg1212 = snd_pcm_substream_chip(substream);
>  
> -	K1212_DEBUG_PRINTK("K1212_DEBUG: snd_korg1212_capture_close [%s]\n",
> -			   stateName[korg1212->cardState]);
> +	k1212_dbg(korg1212, "snd_korg1212_capture_close [%s]\n",
> +		  stateName[korg1212->cardState]);
>  
>          spin_lock_irqsave(&korg1212->lock, flags);
>  
> @@ -1475,14 +1469,14 @@ static int snd_korg1212_capture_close(struct snd_pcm_substream *substream)
>  static int snd_korg1212_ioctl(struct snd_pcm_substream *substream,
>  			     unsigned int cmd, void *arg)
>  {
> -	K1212_DEBUG_PRINTK("K1212_DEBUG: snd_korg1212_ioctl: cmd=%d\n", cmd);
> -
>  	if (cmd == SNDRV_PCM_IOCTL1_CHANNEL_INFO ) {
> +		struct snd_korg1212 *korg1212 = snd_pcm_substream_chip(substream);
>  		struct snd_pcm_channel_info *info = arg;
>          	info->offset = 0;
>          	info->first = info->channel * 16;
>          	info->step = 256;
> -		K1212_DEBUG_PRINTK("K1212_DEBUG: channel_info %d:, offset=%ld, first=%d, step=%d\n", info->channel, info->offset, info->first, info->step);
> +		k1212_dbg(korg1212, "channel_info %d:, offset=%ld, first=%d, step=%d\n",
> +			  info->channel, info->offset, info->first, info->step);
>  		return 0;
>  	}
>  
> @@ -1498,8 +1492,8 @@ static int snd_korg1212_hw_params(struct snd_pcm_substream *substream,
>  	pid_t this_pid;
>  	pid_t other_pid;
>  
> -	K1212_DEBUG_PRINTK("K1212_DEBUG: snd_korg1212_hw_params [%s]\n",
> -			   stateName[korg1212->cardState]);
> +	k1212_dbg(korg1212, "snd_korg1212_hw_params [%s]\n",
> +		  stateName[korg1212->cardState]);
>  
>          spin_lock_irqsave(&korg1212->lock, flags);
>  
> @@ -1546,15 +1540,15 @@ static int snd_korg1212_prepare(struct snd_pcm_substream *substream)
>          struct snd_korg1212 *korg1212 = snd_pcm_substream_chip(substream);
>  	int rc;
>  
> -	K1212_DEBUG_PRINTK("K1212_DEBUG: snd_korg1212_prepare [%s]\n",
> -			   stateName[korg1212->cardState]);
> +	k1212_dbg(korg1212, "snd_korg1212_prepare [%s]\n",
> +		  stateName[korg1212->cardState]);
>  
>  	spin_lock_irq(&korg1212->lock);
>  
>  	/* FIXME: we should wait for ack! */
>  	if (korg1212->stop_pending_cnt > 0) {
> -		K1212_DEBUG_PRINTK("K1212_DEBUG: snd_korg1212_prepare - Stop is pending... [%s]\n",
> -				   stateName[korg1212->cardState]);
> +		k1212_dbg(korg1212, "snd_korg1212_prepare - Stop is pending... [%s]\n",
> +			  stateName[korg1212->cardState]);
>          	spin_unlock_irq(&korg1212->lock);
>  		return -EAGAIN;
>  		/*
> @@ -1579,16 +1573,16 @@ static int snd_korg1212_trigger(struct snd_pcm_substream *substream,
>          struct snd_korg1212 *korg1212 = snd_pcm_substream_chip(substream);
>  	int rc;
>  
> -	K1212_DEBUG_PRINTK("K1212_DEBUG: snd_korg1212_trigger [%s] cmd=%d\n",
> -			   stateName[korg1212->cardState], cmd);
> +	k1212_dbg(korg1212, "snd_korg1212_trigger [%s] cmd=%d\n",
> +		  stateName[korg1212->cardState], cmd);
>  
>  	spin_lock(&korg1212->lock);
>          switch (cmd) {
>                  case SNDRV_PCM_TRIGGER_START:
>  /*
>  			if (korg1212->running) {
> -				K1212_DEBUG_PRINTK_VERBOSE("K1212_DEBUG: snd_korg1212_trigger: Already running?\n");
> -				break;
> +			k1212_dbg(korg1212, "snd_korg1212_trigger: Already running?\n");
> +			break;
>  			}
>  */
>                          korg1212->running++;
> @@ -1598,8 +1592,8 @@ static int snd_korg1212_trigger(struct snd_pcm_substream *substream,
>                  case SNDRV_PCM_TRIGGER_STOP:
>  /*
>  			if (!korg1212->running) {
> -				K1212_DEBUG_PRINTK_VERBOSE("K1212_DEBUG: snd_korg1212_trigger: Already stopped?\n");
> -				break;
> +			k1212_dbg(korg1212, "snd_korg1212_trigger: Already stopped?\n");
> +			break;
>  			}
>  */
>                          korg1212->running--;
> @@ -1621,8 +1615,8 @@ static snd_pcm_uframes_t snd_korg1212_playback_pointer(struct snd_pcm_substream
>  
>  	pos = korg1212->currentBuffer * kPlayBufferFrames;
>  
> -	K1212_DEBUG_PRINTK_VERBOSE("K1212_DEBUG: snd_korg1212_playback_pointer [%s] %ld\n", 
> -				   stateName[korg1212->cardState], pos);
> +	k1212_dbg(korg1212, "snd_korg1212_playback_pointer [%s] %ld\n",
> +		  stateName[korg1212->cardState], pos);
>  
>          return pos;
>  }
> @@ -1634,8 +1628,8 @@ static snd_pcm_uframes_t snd_korg1212_capture_pointer(struct snd_pcm_substream *
>  
>  	pos = korg1212->currentBuffer * kPlayBufferFrames;
>  
> -	K1212_DEBUG_PRINTK_VERBOSE("K1212_DEBUG: snd_korg1212_capture_pointer [%s] %ld\n",
> -				   stateName[korg1212->cardState], pos);
> +	k1212_dbg(korg1212, "snd_korg1212_capture_pointer [%s] %ld\n",
> +		  stateName[korg1212->cardState], pos);
>  
>          return pos;
>  }
> @@ -1648,8 +1642,8 @@ static int snd_korg1212_playback_copy(struct snd_pcm_substream *substream,
>  {
>          struct snd_korg1212 *korg1212 = snd_pcm_substream_chip(substream);
>  
> -	K1212_DEBUG_PRINTK_VERBOSE("K1212_DEBUG: snd_korg1212_playback_copy [%s] %ld %ld\n",
> -				   stateName[korg1212->cardState], pos, count);
> +	k1212_dbg(korg1212, "snd_korg1212_playback_copy [%s] %ld %ld\n",
> +		  stateName[korg1212->cardState], pos, count);
>   
>  	return snd_korg1212_copy_from(korg1212, src, pos, count, 0, korg1212->channels * 2);
>  
> @@ -1662,8 +1656,8 @@ static int snd_korg1212_playback_silence(struct snd_pcm_substream *substream,
>  {
>          struct snd_korg1212 *korg1212 = snd_pcm_substream_chip(substream);
>  
> -	K1212_DEBUG_PRINTK_VERBOSE("K1212_DEBUG: snd_korg1212_playback_silence [%s]\n",
> -				   stateName[korg1212->cardState]);
> +	k1212_dbg(korg1212, "snd_korg1212_playback_silence [%s]\n",
> +		  stateName[korg1212->cardState]);
>  
>  	return snd_korg1212_silence(korg1212, pos, count, 0, korg1212->channels * 2);
>  }
> @@ -1676,8 +1670,8 @@ static int snd_korg1212_capture_copy(struct snd_pcm_substream *substream,
>  {
>          struct snd_korg1212 *korg1212 = snd_pcm_substream_chip(substream);
>  
> -	K1212_DEBUG_PRINTK_VERBOSE("K1212_DEBUG: snd_korg1212_capture_copy [%s] %ld %ld\n",
> -				   stateName[korg1212->cardState], pos, count);
> +	k1212_dbg(korg1212, "snd_korg1212_capture_copy [%s] %ld %ld\n",
> +		  stateName[korg1212->cardState], pos, count);
>  
>  	return snd_korg1212_copy_to(korg1212, dst, pos, count, 0, korg1212->channels * 2);
>  }
> @@ -2138,7 +2132,7 @@ snd_korg1212_free(struct snd_korg1212 *korg1212)
>  static int snd_korg1212_dev_free(struct snd_device *device)
>  {
>          struct snd_korg1212 *korg1212 = device->device_data;
> -        K1212_DEBUG_PRINTK("K1212_DEBUG: Freeing device\n");
> +	k1212_dbg(korg1212, "Freeing device\n");
>  	return snd_korg1212_free(korg1212);
>  }
>  
> @@ -2210,15 +2204,15 @@ static int snd_korg1212_create(struct snd_card *card, struct pci_dev *pci,
>  	ioport_size = pci_resource_len(korg1212->pci, 1);
>  	iomem2_size = pci_resource_len(korg1212->pci, 2);
>  
> -        K1212_DEBUG_PRINTK("K1212_DEBUG: resources:\n"
> -                   "    iomem = 0x%lx (%d)\n"
> -		   "    ioport  = 0x%lx (%d)\n"
> -                   "    iomem = 0x%lx (%d)\n"
> -		   "    [%s]\n",
> -		   korg1212->iomem, iomem_size,
> -		   korg1212->ioport, ioport_size,
> -		   korg1212->iomem2, iomem2_size,
> -		   stateName[korg1212->cardState]);
> +	k1212_dbg(korg1212, "resources:\n"
> +		  "    iomem = 0x%lx (%d)\n"
> +		  "    ioport  = 0x%lx (%d)\n"
> +		  "    iomem = 0x%lx (%d)\n"
> +		  "    [%s]\n",
> +		  korg1212->iomem, iomem_size,
> +		  korg1212->ioport, ioport_size,
> +		  korg1212->iomem2, iomem2_size,
> +		  stateName[korg1212->cardState]);
>  
>          if ((korg1212->iobase = ioremap(korg1212->iomem, iomem_size)) == NULL) {
>  		snd_printk(KERN_ERR "korg1212: unable to remap memory region 0x%lx-0x%lx\n", korg1212->iomem,
> @@ -2252,29 +2246,29 @@ static int snd_korg1212_create(struct snd_card *card, struct pci_dev *pci,
>          korg1212->sensRegPtr = (u16 __iomem *) (korg1212->iobase + SENS_CONTROL_OFFSET);
>          korg1212->idRegPtr = (u32 __iomem *) (korg1212->iobase + DEV_VEND_ID_OFFSET);
>  
> -        K1212_DEBUG_PRINTK("K1212_DEBUG: card registers:\n"
> -                   "    Status register = 0x%p\n"
> -                   "    OutDoorbell     = 0x%p\n"
> -                   "    InDoorbell      = 0x%p\n"
> -                   "    Mailbox0        = 0x%p\n"
> -                   "    Mailbox1        = 0x%p\n"
> -                   "    Mailbox2        = 0x%p\n"
> -                   "    Mailbox3        = 0x%p\n"
> -                   "    ControlReg      = 0x%p\n"
> -                   "    SensReg         = 0x%p\n"
> -                   "    IDReg           = 0x%p\n"
> -		   "    [%s]\n",
> -                   korg1212->statusRegPtr,
> -		   korg1212->outDoorbellPtr,
> -		   korg1212->inDoorbellPtr,
> -                   korg1212->mailbox0Ptr,
> -                   korg1212->mailbox1Ptr,
> -                   korg1212->mailbox2Ptr,
> -                   korg1212->mailbox3Ptr,
> -                   korg1212->controlRegPtr,
> -                   korg1212->sensRegPtr,
> -                   korg1212->idRegPtr,
> -		   stateName[korg1212->cardState]);
> +	k1212_dbg(korg1212, "card registers:\n"
> +		  "    Status register = 0x%p\n"
> +		  "    OutDoorbell     = 0x%p\n"
> +		  "    InDoorbell      = 0x%p\n"
> +		  "    Mailbox0        = 0x%p\n"
> +		  "    Mailbox1        = 0x%p\n"
> +		  "    Mailbox2        = 0x%p\n"
> +		  "    Mailbox3        = 0x%p\n"
> +		  "    ControlReg      = 0x%p\n"
> +		  "    SensReg         = 0x%p\n"
> +		  "    IDReg           = 0x%p\n"
> +		  "    [%s]\n",
> +		  korg1212->statusRegPtr,
> +		  korg1212->outDoorbellPtr,
> +		  korg1212->inDoorbellPtr,
> +		  korg1212->mailbox0Ptr,
> +		  korg1212->mailbox1Ptr,
> +		  korg1212->mailbox2Ptr,
> +		  korg1212->mailbox3Ptr,
> +		  korg1212->controlRegPtr,
> +		  korg1212->sensRegPtr,
> +		  korg1212->idRegPtr,
> +		  stateName[korg1212->cardState]);
>  
>  	if (snd_dma_alloc_pages(SNDRV_DMA_TYPE_DEV, snd_dma_pci_data(pci),
>  				sizeof(struct KorgSharedBuffer), &korg1212->dma_shared) < 0) {
> @@ -2285,7 +2279,9 @@ static int snd_korg1212_create(struct snd_card *card, struct pci_dev *pci,
>          korg1212->sharedBufferPtr = (struct KorgSharedBuffer *)korg1212->dma_shared.area;
>          korg1212->sharedBufferPhy = korg1212->dma_shared.addr;
>  
> -        K1212_DEBUG_PRINTK("K1212_DEBUG: Shared Buffer Area = 0x%p (0x%08lx), %d bytes\n", korg1212->sharedBufferPtr, korg1212->sharedBufferPhy, sizeof(struct KorgSharedBuffer));
> +	k1212_dbg(korg1212, "Shared Buffer Area = 0x%p (0x%08lx), %zu bytes\n",
> +		  korg1212->sharedBufferPtr, korg1212->sharedBufferPhy,
> +		  sizeof(struct KorgSharedBuffer));
>  
>  #ifndef K1212_LARGEALLOC
>  
> @@ -2300,8 +2296,9 @@ static int snd_korg1212_create(struct snd_card *card, struct pci_dev *pci,
>  	korg1212->playDataBufsPtr = (struct KorgAudioBuffer *)korg1212->dma_play.area;
>  	korg1212->PlayDataPhy = korg1212->dma_play.addr;
>  
> -        K1212_DEBUG_PRINTK("K1212_DEBUG: Play Data Area = 0x%p (0x%08x), %d bytes\n",
> -		korg1212->playDataBufsPtr, korg1212->PlayDataPhy, korg1212->DataBufsSize);
> +	k1212_dbg(korg1212, "Play Data Area = 0x%p (0x%08x), %d bytes\n",
> +		  korg1212->playDataBufsPtr, korg1212->PlayDataPhy,
> +		  korg1212->DataBufsSize);
>  
>  	if (snd_dma_alloc_pages(SNDRV_DMA_TYPE_DEV, snd_dma_pci_data(pci),
>  				korg1212->DataBufsSize, &korg1212->dma_rec) < 0) {
> @@ -2312,8 +2309,9 @@ static int snd_korg1212_create(struct snd_card *card, struct pci_dev *pci,
>          korg1212->recordDataBufsPtr = (struct KorgAudioBuffer *)korg1212->dma_rec.area;
>          korg1212->RecDataPhy = korg1212->dma_rec.addr;
>  
> -        K1212_DEBUG_PRINTK("K1212_DEBUG: Record Data Area = 0x%p (0x%08x), %d bytes\n",
> -		korg1212->recordDataBufsPtr, korg1212->RecDataPhy, korg1212->DataBufsSize);
> +	k1212_dbg(korg1212, "Record Data Area = 0x%p (0x%08x), %d bytes\n",
> +		  korg1212->recordDataBufsPtr, korg1212->RecDataPhy,
> +		  korg1212->DataBufsSize);
>  
>  #else // K1212_LARGEALLOC
>  
> @@ -2347,9 +2345,9 @@ static int snd_korg1212_create(struct snd_card *card, struct pci_dev *pci,
>                  return -ENOMEM;
>          }
>  
> -        K1212_DEBUG_PRINTK("K1212_DEBUG: DSP Code area = 0x%p (0x%08x) %d bytes [%s]\n",
> -		   korg1212->dma_dsp.area, korg1212->dma_dsp.addr, dsp_code->size,
> -		   stateName[korg1212->cardState]);
> +	k1212_dbg(korg1212, "DSP Code area = 0x%p (%pad) %zu bytes [%s]\n",
> +		  korg1212->dma_dsp.area, &korg1212->dma_dsp.addr,
> +		  dsp_code->size, stateName[korg1212->cardState]);
>  
>  	memcpy(korg1212->dma_dsp.area, dsp_code->data, dsp_code->size);
>  
> @@ -2358,7 +2356,8 @@ static int snd_korg1212_create(struct snd_card *card, struct pci_dev *pci,
>  	rc = snd_korg1212_Send1212Command(korg1212, K1212_DB_RebootCard, 0, 0, 0, 0);
>  
>  	if (rc)
> -		K1212_DEBUG_PRINTK("K1212_DEBUG: Reboot Card - RC = %d [%s]\n", rc, stateName[korg1212->cardState]);
> +		k1212_dbg(korg1212, "Reboot Card - RC = %d [%s]\n",
> +			  rc, stateName[korg1212->cardState]);
>  
>          if ((err = snd_device_new(card, SNDRV_DEV_LOWLEVEL, korg1212, &ops)) < 0) {
>                  snd_korg1212_free(korg1212);
> @@ -2372,18 +2371,24 @@ static int snd_korg1212_create(struct snd_card *card, struct pci_dev *pci,
>          if (snd_korg1212_downloadDSPCode(korg1212))
>          	return -EBUSY;
>  
> -        K1212_DEBUG_PRINTK("korg1212: dspMemPhy = %08x U[%08x], "
> -               "PlayDataPhy = %08x L[%08x]\n"
> -	       "korg1212: RecDataPhy = %08x L[%08x], "
> -               "VolumeTablePhy = %08x L[%08x]\n"
> -               "korg1212: RoutingTablePhy = %08x L[%08x], "
> -               "AdatTimeCodePhy = %08x L[%08x]\n",
> -	       (int)korg1212->dma_dsp.addr,    UpperWordSwap(korg1212->dma_dsp.addr),
> -               korg1212->PlayDataPhy,     LowerWordSwap(korg1212->PlayDataPhy),
> -               korg1212->RecDataPhy,      LowerWordSwap(korg1212->RecDataPhy),
> -               korg1212->VolumeTablePhy,  LowerWordSwap(korg1212->VolumeTablePhy),
> -               korg1212->RoutingTablePhy, LowerWordSwap(korg1212->RoutingTablePhy),
> -               korg1212->AdatTimeCodePhy, LowerWordSwap(korg1212->AdatTimeCodePhy));
> +	k1212_dbg(korg1212, "dspMemPhy = %08x U[%08x]\n",
> +		  (int)korg1212->dma_dsp.addr,
> +		  UpperWordSwap(korg1212->dma_dsp.addr));
> +	k1212_dbg(korg1212, "PlayDataPhy = %08x L[%08x]\n",
> +		  korg1212->PlayDataPhy,
> +		  LowerWordSwap(korg1212->PlayDataPhy));
> +	k1212_dbg(korg1212, "RecDataPhy = %08x L[%08x]\n",
> +		  korg1212->RecDataPhy,
> +		  LowerWordSwap(korg1212->RecDataPhy));
> +	k1212_dbg(korg1212, "VolumeTablePhy = %08x L[%08x]\n",
> +		  korg1212->VolumeTablePhy,
> +		  LowerWordSwap(korg1212->VolumeTablePhy));
> +	k1212_dbg(korg1212, "RoutingTablePhy = %08x L[%08x]\n",
> +		  korg1212->RoutingTablePhy,
> +		  LowerWordSwap(korg1212->RoutingTablePhy));
> +	k1212_dbg(korg1212, "AdatTimeCodePhy = %08x L[%08x]\n",
> +		  korg1212->AdatTimeCodePhy,
> +		  LowerWordSwap(korg1212->AdatTimeCodePhy));
>  
>          if ((err = snd_pcm_new(korg1212->card, "korg1212", 0, 1, 1, &korg1212->pcm)) < 0)
>                  return err;
> @@ -2446,7 +2451,7 @@ snd_korg1212_probe(struct pci_dev *pci,
>  	sprintf(card->longname, "%s at 0x%lx, irq %d", card->shortname,
>  		korg1212->iomem, korg1212->irq);
>  
> -        K1212_DEBUG_PRINTK("K1212_DEBUG: %s\n", card->longname);
> +	k1212_dbg(korg1212, "%s\n", card->longname);
>  
>  	if ((err = snd_card_register(card)) < 0) {
>  		snd_card_free(card);
> 
> 
