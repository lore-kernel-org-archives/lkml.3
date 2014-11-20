Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbaKTRpR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 12:45:17 -0500
Received: from smtp2.tech.numericable.fr ([82.216.111.38]:50231 "EHLO
	smtp2.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076AbaKTRpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 12:45:15 -0500
Message-ID: <546E2880.5070303@laposte.net>
Date: Thu, 20 Nov 2014 18:44:32 +0100
From: Barto <mister.freeman@laposte.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: "Elliott, Robert (Server Storage)" <Elliott@hp.com>,
        Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: BUG in scsi_lib.c due to a bad commit
References: <20141120060933.GA21432@infradead.org>
In-Reply-To: <20141120060933.GA21432@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrkeekgddugecutefuodetggdotefrucfrrhhofhhilhgvmecupfgfoffgtffkveetuefngfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffhfgfggfvufhfjggtgfesthekrgdttdefheenucfhrhhomhepuegrrhhtohcuoehmihhsthgvrhdrfhhrvggvmhgrnheslhgrphhoshhtvgdrnhgvtheq
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Christoph,

I tested your patch, it works, the bug is gone with your patch, it's a
good news,

I notice that my motherboard doesn't support "AHCI" mode, my motherboard
uses an ICH7 sata controler, ICH7 doesn't support AHCI if I check the
technical specifications of this controler,

it seems that my bios treats SATA devices like IDE devices ( IDE
emulation mode ), for example I can read in the bios these lines "IDE 0
channel master : "the name of Sata harddisk 1", "IDE 3 channel master :
"the name of Sata harddisk 2",

perhaps the bug only occurs when the AHCI mode is not used ?

because on archlinux forums another user has noticed that this bug only
occurs if he enables the "IDE emulation" option in the bios of his
motherboard ( a recent gigabyte motherboard : Z68P-DS3 intel for i7 CPU
), and if he chooses the "AHCI mode" instead of the "IDE emulation mode"
in his bios settings then the bug disappears, no random hangs at boot
when AHCI is enabled,

and this user has also a SATA DVD burner,

so perhaps you can reproduce this bug on your PC if you have the same
option enabled in the bios ( IDE emulation mode ) and a Sata DVD burner,
in this case you will have 20~30% of chance to trigger the bug (  random
hangs will occur approximately every 5~10 boots )


Le 20/11/2014 07:09, Christoph Hellwig a écrit :
> I
> 
> Hi Barto,
> 
> sorry for the late reply, and thanks for drilling down the exact
> conditions.
> 
> I think we have some issues with the lack of the host lock vs error
> handling, but I still don't undertand the details.
> 
> I've got a test patch for you that just adds the host lock back in a few
> places while keeing the atomic_t.  Can you try to reproduce with that
> one?
> 
> When breaking an existing setup in software it's always the softwares
> fault, btw..
> 
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 994eb08..99b77f7 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -311,16 +311,16 @@ void scsi_device_unbusy(struct scsi_device *sdev)
>  	struct scsi_target *starget = scsi_target(sdev);
>  	unsigned long flags;
>  
> +	spin_lock_irqsave(shost->host_lock, flags);
>  	atomic_dec(&shost->host_busy);
>  	if (starget->can_queue > 0)
>  		atomic_dec(&starget->target_busy);
>  
>  	if (unlikely(scsi_host_in_recovery(shost) &&
>  		     (shost->host_failed || shost->host_eh_scheduled))) {
> -		spin_lock_irqsave(shost->host_lock, flags);
>  		scsi_eh_wakeup(shost);
> -		spin_unlock_irqrestore(shost->host_lock, flags);
>  	}
> +	spin_unlock_irqrestore(shost->host_lock, flags);
>  
>  	atomic_dec(&sdev->device_busy);
>  }
> @@ -1504,6 +1504,8 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
>  	if (scsi_host_in_recovery(shost))
>  		return 0;
>  
> +	spin_lock_irq(shost->host_lock);
> +
>  	busy = atomic_inc_return(&shost->host_busy) - 1;
>  	if (atomic_read(&shost->host_blocked) > 0) {
>  		if (busy)
> @@ -1527,21 +1529,19 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
>  
>  	/* We're OK to process the command, so we can't be starved */
>  	if (!list_empty(&sdev->starved_entry)) {
> -		spin_lock_irq(shost->host_lock);
>  		if (!list_empty(&sdev->starved_entry))
>  			list_del_init(&sdev->starved_entry);
> -		spin_unlock_irq(shost->host_lock);
>  	}
>  
> +	spin_unlock_irq(shost->host_lock);
>  	return 1;
>  
>  starved:
> -	spin_lock_irq(shost->host_lock);
>  	if (list_empty(&sdev->starved_entry))
>  		list_add_tail(&sdev->starved_entry, &shost->starved_list);
> -	spin_unlock_irq(shost->host_lock);
>  out_dec:
>  	atomic_dec(&shost->host_busy);
> +	spin_unlock_irq(shost->host_lock);
>  	return 0;
>  }
>  
> 
