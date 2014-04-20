Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbaDTMVK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 08:21:10 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33121 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755196AbaDTMVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 08:21:03 -0400
Date: Sun, 20 Apr 2014 14:20:55 +0200
From: Borislav Petkov <bp@alien8.de>
To: micky <micky_ching@realsil.com.cn>
Cc: lkml <linux-kernel@vger.kernel.org>, Chris Ball <chris@printf.net>,
        Wei WANG <wei_wang@realsil.com.cn>
Subject: Re: rtsx_pci_sdmmc lockdep splat
Message-ID: <20140420122055.GD19667@pd.tnic>
References: <20140415174934.GD4826@pd.tnic>
 <534DE1D7.3000308@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <534DE1D7.3000308@realsil.com.cn>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Apr 16, 2014 at 09:50:15AM +0800, micky wrote:
> From: Micky Ching<micky_ching@realsil.com.cn>
> 
> To avoid dead lock, we need make sure host->lock is always acquire
> before pcr->lock. But in irq handler, we acquired pcr->lock in rtsx mfd
> driver, and sd_isr_done_transfer() is called during pcr->lock already
> acquired. Since in sd_isr_done_transfer() the only work we do is schdule
> tasklet, the cmd_tasklet and data_tasklet never conflict, so it is safe
> to remove spin_lock() here.
> 
> Signed-off-by: Micky Ching<micky_ching@realsil.com.cn>
> ---
>  drivers/mmc/host/rtsx_pci_sdmmc.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
> index 453e1d4..40695e0 100644
> --- a/drivers/mmc/host/rtsx_pci_sdmmc.c
> +++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
> @@ -108,12 +108,10 @@ static void sd_isr_done_transfer(struct platform_device *pdev)
>  {
>  	struct realtek_pci_sdmmc *host = platform_get_drvdata(pdev);
> -	spin_lock(&host->lock);
>  	if (host->cmd)
>  		tasklet_schedule(&host->cmd_tasklet);
> -	if (host->data)
> +	else if (host->data)
>  		tasklet_schedule(&host->data_tasklet);
> -	spin_unlock(&host->lock);
>  }
>  static void sd_request_timeout(unsigned long host_addr)
> -- 

Patch wouldn't apply against rc1, so I had to add it by hand, diff
below.

---
diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index 5fb994f9a653..d1d65c0d8d2e 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -109,12 +109,10 @@ static void sd_isr_done_transfer(struct platform_device *pdev)
 {
 	struct realtek_pci_sdmmc *host = platform_get_drvdata(pdev);
 
-	spin_lock(&host->lock);
 	if (host->cmd)
 		tasklet_schedule(&host->cmd_tasklet);
-	if (host->data)
+	else if (host->data)
 		tasklet_schedule(&host->data_tasklet);
-	spin_unlock(&host->lock);
 }
 
 static void sd_request_timeout(unsigned long host_addr)
--

Still needs more love:

[   95.112797] rtsx_pci_sdmmc rtsx_pci_sdmmc.0: sdmmc_get_cd: RTSX_BIPR = 0x00010000
[   95.115700] mmc0: mmc_rescan_try_freq: trying to init card at 400000 Hz
[   95.118040] mmc0: clock 0Hz busmode 2 powermode 1 cs 0 Vdd 21 width 0 timing 0
[   95.122504] rtsx_pci_sdmmc rtsx_pci_sdmmc.0: sdmmc_switch_voltage: signal_voltage = 0
[   95.139469] mmc0: clock 400000Hz busmode 2 powermode 2 cs 0 Vdd 21 width 0 timing 0
[   95.155461] mmc0: starting CMD52 arg 00000c00 flags 00000195
[   95.158617] rtsx_pci_sdmmc rtsx_pci_sdmmc.0: sd_send_cmd: SD/MMC CMD 52, arg = 0x00000c00
[   95.255497] rtsx_pci_sdmmc rtsx_pci_sdmmc.0: timeout for request
[   95.258412] ------------[ cut here ]------------
[   95.261163] WARNING: CPU: 0 PID: 3 at kernel/locking/mutex.c:698 __mutex_unlock_slowpath+0x124/0x180()
[   95.264120] DEBUG_LOCKS_WARN_ON(in_interrupt())
[   95.264222] Modules linked in: cpufreq_stats cpufreq_conservative cpufreq_powersave cpufreq_userspace binfmt_misc uinput ipv6 vfat fat rtsx_pci_sdmmc mmc_core arc4 radeon rtl8192ce snd_hda_codec_conexant snd_hda_codec_generic snd_hda_codec_hdmi snd_hda_intel rtl_pci rtlwifi snd_hda_controller snd_hda_codec mac80211 cfg80211 snd_hwdep snd_pcm drm_kms_helper pcspkr k10temp evdev snd_seq thermal thinkpad_acpi ehci_pci nvram rtsx_pci mfd_core snd_seq_device rtl8192c_common snd_timer ohci_pci ohci_hcd ehci_hcd snd battery ttm ac video button soundcore
[   95.264231] CPU: 0 PID: 3 Comm: ksoftirqd/0 Not tainted 3.15.0-rc1+ #1
[   95.264235] Hardware name: LENOVO 30515QG/30515QG, BIOS 8RET30WW (1.12 ) 09/15/2011
[   95.264246]  0000000000000009 ffff8801198f3c50 ffffffff81522644 ffff8801198f3c98
[   95.264254]  ffff8801198f3c88 ffffffff810701fc ffff8800c0ec1230 ffff8800c28b5c30
[   95.264262]  ffff8800c0ec1000 ffff8800bea267b0 0000000000000000 ffff8801198f3ce8
[   95.264264] Call Trace:
[   95.264277]  [<ffffffff81522644>] dump_stack+0x4e/0x7a
[   95.264288]  [<ffffffff810701fc>] warn_slowpath_common+0x8c/0xc0
[   95.264297]  [<ffffffff8107027c>] warn_slowpath_fmt+0x4c/0x50
[   95.264305]  [<ffffffff815294c4>] __mutex_unlock_slowpath+0x124/0x180
[   95.264311]  [<ffffffff8152952e>] mutex_unlock+0xe/0x10
[   95.264324]  [<ffffffffa0067119>] sd_finish_request+0xd9/0x1c0 [rtsx_pci_sdmmc]
[   95.264332]  [<ffffffff810751a0>] tasklet_action+0x110/0x170
[   95.264338]  [<ffffffff810756ba>] __do_softirq+0x12a/0x320
[   95.264345]  [<ffffffff810758dd>] run_ksoftirqd+0x2d/0x50
[   95.264354]  [<ffffffff8109be75>] smpboot_thread_fn+0x175/0x2b0
[   95.264363]  [<ffffffff8109bd00>] ? SyS_setgroups+0x150/0x150
[   95.264372]  [<ffffffff8109497c>] kthread+0xfc/0x120
[   95.264382]  [<ffffffff81094880>] ? kthread_create_on_node+0x1f0/0x1f0
[   95.264390]  [<ffffffff8152bfec>] ret_from_fork+0x7c/0xb0
[   95.264398]  [<ffffffff81094880>] ? kthread_create_on_node+0x1f0/0x1f0
[   95.264403] ---[ end trace e7e46e1611dc934d ]---


-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
