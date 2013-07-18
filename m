Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab3GRCxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 22:53:16 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:33196 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab3GRCxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 22:53:12 -0400
Date: Thu, 18 Jul 2013 10:53:01 +0800
From: majianpeng <majianpeng@gmail.com>
To: balajitk <balajitk@ti.com>
Cc: cjb <cjb@laptop.org>, linux-mmc <linux-mmc@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: About omap2 mmc host  close too long irq in irqaction.
X-Priority: 3
X-GUID: 5810326C-7B21-457E-8D85-26105C6C44B9
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.90[en]
Mime-Version: 1.0
Message-ID: <201307181052572266628@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6I2rg5n032753

Hi all,
	Now i worked on omp2 and met a probelm which someplace close_irq for 3.6second. 
The kernel version is 2.6.37. I used trace to find in irq_action:omap_hsmmc_irq.
This problem occured by removed the sdcard when there are io operations.

I found the read problem is in omap_hsmmc_reset_controller_fsm.
In omap_hsmmc_reset_controller_fsm:
>static inline void omap_hsmmc_reset_controller_fsm(struct omap_hsmmc_host *host,
>                                                   unsigned long bit)
>{
>        unsigned long i = 0; 
>        unsigned long limit = (loops_per_jiffy *
>                                msecs_to_jiffies(MMC_TIMEOUT_MS));

>        OMAP_HSMMC_WRITE(host->base, SYSCTL,
>                         OMAP_HSMMC_READ(host->base, SYSCTL) | bit);

>        /*   
>         * OMAP4 ES2 and greater has an updated reset logic.
>         * Monitor a 0->1 transition first
>         */
>        if (mmc_slot(host).features & HSMMC_HAS_UPDATED_RESET) {
>                while ((!(OMAP_HSMMC_READ(host->base, SYSCTL) & bit))
>                                       && (i++ < limit))
>                        cpu_relax();
        }    
 In func, it used loops_per_jiffy  in order to avoid do many time exceed MMC_TIMEOUT_MS.
In face oops_per_jiify is like:
while(i++ < loops_per_jiffy)
	cpu_relax();
But actually, it used as follow:
>while ((!(OMAP_HSMMC_READ(host->base, SYSCTL) & bit))
>                                      && (i++ < limit))
it add some operations like: read regisger, &, &&.
So the time may exceed MMC_TIMEOUT_MS.
I used those code to test and found it's ok:
for (i = 0 ; i < 10; i++){
	if (!(OMAP_HSMMC_READ(host->base, SYSCTL) & bit))
		  break;
	j = limit/10;
	while(j--)
		cpu_relax();
}

Using this the problom can't occur.
Am i missing something?

Thanks!
Jianpeng Maÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
