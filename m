Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab3LQCYu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 21:24:50 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:50891 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751329Ab3LQCYs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 21:24:48 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jens Axboe <axboe@kernel.dk>, tomaz.solc@tablix.org,
        aaron.lu@intel.com, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] libata, freezer: avoid block device removal while system is frozen
Date: Tue, 17 Dec 2013 03:38:05 +0100
Message-ID: <2427190.pZk9AIZAjc@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131213204034.GE27070@htj.dyndns.org>
References: <20131213174932.GA27070@htj.dyndns.org> <20131213185237.GD27070@htj.dyndns.org> <20131213204034.GE27070@htj.dyndns.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 13, 2013 03:40:34 PM Tejun Heo wrote:
> Hello,
> 
> So, this is the laughable workaround that I came up with.  Seriously,
> this is tragic.  :(
> 
> Thanks.
> 
> ------- 8< -------
> Freezable kthreads and workqueues are fundamentally problematic in
> that they effectively introduce a big kernel lock widely used in the
> kernel and have already been the culprit of several deadlock
> scenarios.  This is the latest occurrence.

OK, so I'm too tired now to go through all that, but I'll look at it tomorrow.

The rule of thumb is to get rid of freezable kernel threads in the first
place if possible anyway if they are causing problems to happen.

Thanks!

> During resume, libata rescans all the ports and revalidates all
> pre-existing devices.  If it determines that a device has gone
> missing, the device is removed from the system which involves
> invalidating block device and flushing bdi while holding driver core
> layer locks.  Unfortunately, this can race with the rest of device
> resume.  Because freezable kthreads and workqueues are thawed after
> device resume is complete and block device removal depends on
> freezable workqueues and kthreads (e.g. bdi_wq, jbd2) to make
> progress, this can lead to deadlock - block device removal can't
> proceed because kthreads are frozen and kthreads can't be thawed
> because device resume is blocked behind block device removal.
> 
> 839a8e8660b6 ("writeback: replace custom worker pool implementation
> with unbound workqueue") made this particular deadlock scenario more
> visible but the underlying problem has always been there - the
> original forker task and jbd2 are freezable too.  In fact, this is
> highly likely just one of many possible deadlock scenarios given that
> freezer behaves as a big kernel lock and we don't have any debug
> mechanism around it.
> 
> I believe the right thing to do is getting rid of freezable kthreads
> and workqueues.  This is something fundamentally broken.  For now,
> implement a funny workaround in libata - just avoid doing block device
> hot[un]plug while the system is frozen.  Kernel engineering at its
> finest.  :(
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Tomaž Šolc <tomaz.solc@tablix.org>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=62801
> Link: http://lkml.kernel.org/r/20131213174932.GA27070@htj.dyndns.org
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Len Brown <len.brown@intel.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/ata/libata-scsi.c |   19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index ab58556..60a01d3 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -3872,6 +3872,25 @@ void ata_scsi_hotplug(struct work_struct *work)
>  		return;
>  	}
>  
> +	/*
> +	 * XXX - UGLY HACK
> +	 *
> +	 * The core suspend/resume path is fundamentally broken due to
> +	 * freezable kthreads and workqueue and may deadlock if a block
> +	 * device gets removed while resume is in progress.  I don't know
> +	 * what the solution is short of removing freezable kthreads and
> +	 * workqueues altogether.
> +	 *
> +	 * The following is an ugly hack to avoid kicking off device
> +	 * removal while freezer is active.  This is a joke but does avoid
> +	 * this particular deadlock scenario.
> +	 *
> +	 * https://bugzilla.kernel.org/show_bug.cgi?id=62801
> +	 * http://marc.info/?l=linux-kernel&m=138695698516487
> +	 */
> +	while (pm_freezing)
> +		msleep(100);
> +
>  	DPRINTK("ENTER\n");
>  	mutex_lock(&ap->scsi_scan_mutex);
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
