Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311AbaLIO6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 09:58:20 -0500
Received: from ec2-54-201-57-178.us-west-2.compute.amazonaws.com ([54.201.57.178]:54064
	"EHLO ip-172-31-12-36.us-west-2.compute.internal"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752430AbaLIO6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 09:58:18 -0500
X-Greylist: delayed 570 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Dec 2014 09:58:18 EST
Date: Tue, 9 Dec 2014 14:46:03 +0000
From: dwalker@fifo99.com
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: arm: mach-msm: smd.c:  Remove some unused functions
Message-ID: <20141209144602.GB5376@fifo99.com>
References: <1417914740-8390-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417914740-8390-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Seems ok to me. These files, and functions, are also in drivers/staging/dream/
are you removing them there also ?


On Sun, Dec 07, 2014 at 02:12:20AM +0100, Rickard Strandqvist wrote:
> Removes some functions that are not used anywhere:
> smsm_set_sleep_duration() smsm_get_state() smd_wait_until_writable()
> smd_wait_until_readable() smd_write_atomic() smd_sleep_exit()
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  arch/arm/mach-msm/include/mach/msm_smd.h |    9 ---
>  arch/arm/mach-msm/smd.c                  |  105 ------------------------------
>  arch/arm/mach-msm/smd_private.h          |    2 -
>  3 files changed, 116 deletions(-)
> 
> diff --git a/arch/arm/mach-msm/include/mach/msm_smd.h b/arch/arm/mach-msm/include/mach/msm_smd.h
> index 029463e..48ddef98 100644
> --- a/arch/arm/mach-msm/include/mach/msm_smd.h
> +++ b/arch/arm/mach-msm/include/mach/msm_smd.h
> @@ -40,7 +40,6 @@ int smd_read(smd_channel_t *ch, void *data, int len);
>  ** it will return the requested length written or an error.
>  */
>  int smd_write(smd_channel_t *ch, const void *data, int len);
> -int smd_write_atomic(smd_channel_t *ch, const void *data, int len);
>  
>  int smd_write_avail(smd_channel_t *ch);
>  int smd_read_avail(smd_channel_t *ch);
> @@ -57,14 +56,6 @@ int smd_cur_packet_size(smd_channel_t *ch);
>  void smd_kick(smd_channel_t *ch);
>  
>  
> -#if 0
> -/* these are interruptable waits which will block you until the specified
> -** number of bytes are readable or writable.
> -*/
> -int smd_wait_until_readable(smd_channel_t *ch, int bytes);
> -int smd_wait_until_writable(smd_channel_t *ch, int bytes);
> -#endif
> -
>  typedef enum {
>  	SMD_PORT_DS = 0,
>  	SMD_PORT_DIAG,
> diff --git a/arch/arm/mach-msm/smd.c b/arch/arm/mach-msm/smd.c
> index b1588a1..4bc1e71 100644
> --- a/arch/arm/mach-msm/smd.c
> +++ b/arch/arm/mach-msm/smd.c
> @@ -401,36 +401,6 @@ static inline int smd_need_int(struct smd_channel *ch)
>  	return 0;
>  }
>  
> -void smd_sleep_exit(void)
> -{
> -	unsigned long flags;
> -	struct smd_channel *ch;
> -	int need_int = 0;
> -
> -	spin_lock_irqsave(&smd_lock, flags);
> -	list_for_each_entry(ch, &smd_ch_list_modem, ch_list) {
> -		if (smd_need_int(ch)) {
> -			need_int = 1;
> -			break;
> -		}
> -	}
> -	list_for_each_entry(ch, &smd_ch_list_dsp, ch_list) {
> -		if (smd_need_int(ch)) {
> -			need_int = 1;
> -			break;
> -		}
> -	}
> -	spin_unlock_irqrestore(&smd_lock, flags);
> -	do_smd_probe();
> -
> -	if (need_int) {
> -		if (msm_smd_debug_mask & MSM_SMD_DEBUG)
> -			pr_info("smd_sleep_exit need interrupt\n");
> -		tasklet_schedule(&smd_fake_irq_tasklet);
> -	}
> -}
> -
> -
>  void smd_kick(smd_channel_t *ch)
>  {
>  	unsigned long flags;
> @@ -747,16 +717,6 @@ int smd_write(smd_channel_t *ch, const void *data, int len)
>  	return ch->write(ch, data, len);
>  }
>  
> -int smd_write_atomic(smd_channel_t *ch, const void *data, int len)
> -{
> -	unsigned long flags;
> -	int res;
> -	spin_lock_irqsave(&smd_lock, flags);
> -	res = ch->write(ch, data, len);
> -	spin_unlock_irqrestore(&smd_lock, flags);
> -	return res;
> -}
> -
>  int smd_read_avail(smd_channel_t *ch)
>  {
>  	return ch->read_avail(ch);
> @@ -767,16 +727,6 @@ int smd_write_avail(smd_channel_t *ch)
>  	return ch->write_avail(ch);
>  }
>  
> -int smd_wait_until_readable(smd_channel_t *ch, int bytes)
> -{
> -	return -1;
> -}
> -
> -int smd_wait_until_writable(smd_channel_t *ch, int bytes)
> -{
> -	return -1;
> -}
> -
>  int smd_cur_packet_size(smd_channel_t *ch)
>  {
>  	return ch->current_packet;
> @@ -875,61 +825,6 @@ int smsm_change_state(enum smsm_state_item item,
>  	return 0;
>  }
>  
> -uint32_t smsm_get_state(enum smsm_state_item item)
> -{
> -	unsigned long flags;
> -	uint32_t rv;
> -
> -	spin_lock_irqsave(&smem_lock, flags);
> -
> -	rv = readl(smd_info.state + item * 4);
> -
> -	if (item == SMSM_STATE_MODEM && (rv & SMSM_RESET))
> -		handle_modem_crash();
> -
> -	spin_unlock_irqrestore(&smem_lock, flags);
> -
> -	return rv;
> -}
> -
> -#ifdef CONFIG_ARCH_MSM_SCORPION
> -
> -int smsm_set_sleep_duration(uint32_t delay)
> -{
> -	struct msm_dem_slave_data *ptr;
> -
> -	ptr = smem_find(SMEM_APPS_DEM_SLAVE_DATA, sizeof(*ptr));
> -	if (ptr == NULL) {
> -		pr_err("smsm_set_sleep_duration <SM NO APPS_DEM_SLAVE_DATA>\n");
> -		return -EIO;
> -	}
> -	if (msm_smd_debug_mask & MSM_SMSM_DEBUG)
> -		pr_info("smsm_set_sleep_duration %d -> %d\n",
> -		       ptr->sleep_time, delay);
> -	ptr->sleep_time = delay;
> -	return 0;
> -}
> -
> -#else
> -
> -int smsm_set_sleep_duration(uint32_t delay)
> -{
> -	uint32_t *ptr;
> -
> -	ptr = smem_find(SMEM_SMSM_SLEEP_DELAY, sizeof(*ptr));
> -	if (ptr == NULL) {
> -		pr_err("smsm_set_sleep_duration <SM NO SLEEP_DELAY>\n");
> -		return -EIO;
> -	}
> -	if (msm_smd_debug_mask & MSM_SMSM_DEBUG)
> -		pr_info("smsm_set_sleep_duration %d -> %d\n",
> -		       *ptr, delay);
> -	*ptr = delay;
> -	return 0;
> -}
> -
> -#endif
> -
>  int smd_core_init(void)
>  {
>  	int r;
> diff --git a/arch/arm/mach-msm/smd_private.h b/arch/arm/mach-msm/smd_private.h
> index 727bfe6..702f34e 100644
> --- a/arch/arm/mach-msm/smd_private.h
> +++ b/arch/arm/mach-msm/smd_private.h
> @@ -148,8 +148,6 @@ enum smsm_state_item {
>  
>  void *smem_alloc(unsigned id, unsigned size);
>  int smsm_change_state(enum smsm_state_item item, uint32_t clear_mask, uint32_t set_mask);
> -uint32_t smsm_get_state(enum smsm_state_item item);
> -int smsm_set_sleep_duration(uint32_t delay);
>  void smsm_print_sleep_info(void);
>  
>  #define SMEM_NUM_SMD_CHANNELS        64
> -- 
> 1.7.10.4
