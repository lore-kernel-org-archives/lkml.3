Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816AbaLJJCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 04:02:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35541 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488AbaLJJCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 04:02:43 -0500
Message-ID: <1418202153.7241.6.camel@linux-0dmf.site>
Subject: Re: [V3 PATCH 4/4] scsi:stex.c Add S3/S4 support
From: Oliver Neukum <oneukum@suse.de>
To: Charles Chiou <ch1102chiou@gmail.com>
Cc: JBottomley@parallels.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, grace.chang@tw.promise.com,
        victor.p@promise.com, ed.lin@promise.com
Date: Wed, 10 Dec 2014 10:02:33 +0100
In-Reply-To: <5487A406.8060902@gmail.com>
References: <5487A406.8060902@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-10 at 09:38 +0800, Charles Chiou wrote:
>  From 91868d4afe10533b8a4496075109e411100217bb Mon Sep 17 00:00:00 2001
> From: Charles Chiou <charles.chiou@tw.promise.com>
> Date: Fri, 7 Nov 2014 10:15:18 +0800
> Subject: [PATCH 4/4] scsi:stex.c Add S3/S4 support
> 
> Add S3/S4 support, add .suspend and .resume function in pci_driver.
> 
> Pegasus need 30~40 seconds to boot up. We don't want to OS wait
> in .resume function. Create a thread to handle device boot up.
> 

> +static int stex_resume(struct pci_dev *pdev)
> +{
> +	struct st_hba *hba = pci_get_drvdata(pdev);
> +	struct hba_handshake_workstruct *hswork;
> +	int sts;
> +
> +	hba->mu_status = MU_STATE_STARTING;
> +	hswork = kzalloc(sizeof(struct hba_handshake_workstruct), GFP_KERNEL);

The system is coming back from sleep. You cannot swap or page out
as disks may still be asleep. GFP_KERNEL is automatically changed
to GFP_NOIO. It would be nice to outright use GFP_NOIO.

> +	INIT_WORK(&hswork->handshake_work, resume_handshake);

Memory allocations can fail.
I suggest you allocate the memory in suspend(). There you can just
return -ENOMEM in the error case.

	Regards
		Oliver



