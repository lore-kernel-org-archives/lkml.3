Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660AbaFEUjM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 16:39:12 -0400
Received: from exprod5og116.obsmtp.com ([64.18.0.147]:57050 "HELO
	exprod5og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751015AbaFEUjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 16:39:09 -0400
X-Greylist: delayed 339 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jun 2014 16:39:09 EDT
MIME-Version: 1.0
In-Reply-To: <20140605134120.GA21607@htj.dyndns.org>
References: <CACVXFVMnM6w5ZLX=S8fJHeVoEqxH2JG3Wg=GPMeoVnOpAjsvAA@mail.gmail.com>
	<CAPcyv4icNZU9s7zLYYcrFrNA_9qk4W1je42KKG+ETWqdoQu_kg@mail.gmail.com>
	<CACVXFVPHfP1VXujLx9sGt3c7ptdG1JvBQkw2JiJQsU1KwJ1zog@mail.gmail.com>
	<20140605134120.GA21607@htj.dyndns.org>
Date: Thu, 5 Jun 2014 13:33:29 -0700
Message-ID: <CAPw-ZTk7wOOYBB-XHH3=pQZk84M2xqhj0haPPCP1XJmtyWfmMg@mail.gmail.com>
Subject: Re: [Regression] commit 8a4aeec8d(libata/ahci: accommodate tag
 ordered controllers)
From: Loc Ho <lho@apm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ming Lei <ming.lei@canonical.com>, Dan Williams <dan.j.williams@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

>> >> Looks the commit 8a4aeec8d(libata/ahci: accommodate tag ordered
>> >> controllers) causes below sata failure[1] on APM AHCI controller.
>> >>
>> >> And the error does disappear after reverting the commit.
>> >
>> > Can you give some more details about the workload and the disk?  What
>> > is the APM AHCI?
>>
>> The commit causes the APM arm64 based system not bootable, and not
>> special workload, just when mounting rootfs or reading init files.
>>
>> APM AHCI:
>>       drivers/ata/ahci_xgene.c
>
> Urgh... so, the controller can't handle tags allocated in round-robin
> instead of lowest-first?  Ming, can you please test with different
> controllers / disks / ssds and see whether the problem stays with the
> controller?  Loc, can you guys please look into it so that at least
> the next revision hardware can fix the issue?
>
> Provided that the tag allocation itself isn't broken, which isn't too
> likely given the lack of bug reports on other controllers, we'll need
> to blacklist ahci_xgene somehow.  Either disable NCQ support on it or
> implement an alternative lowest-first tag allocation for it.  If this
> actually is the controller freaking out about tags allocated in a
> different order, I'm not sure how much confidence we can put in its
> NCQ implementation tho and it might be a better idea to simply plug
> NCQ support on it until we understand the details of the problem.
>
> So, something like the following?  Ming, can you please verify whether
> the following makes the machine boot again?
>
> Thanks.
>
> diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
> index 77c89bf..4950600 100644
> --- a/drivers/ata/ahci_xgene.c
> +++ b/drivers/ata/ahci_xgene.c
> @@ -302,9 +302,16 @@ static struct ata_port_operations xgene_ahci_ops = {
>         .read_id = xgene_ahci_read_id,
>  };
>
> +/*
> + * The controller seems to freak out depending on the order of tag
> + * allocation.  NCQ support is disabled until the problem is better
> + * understood.
> + *
> + * http://lkml.kernel.org/g/CACVXFVMnM6w5ZLX=S8fJHeVoEqxH2JG3Wg=GPMeoVnOpAjsvAA@mail.gmail.com
> + */
>  static const struct ata_port_info xgene_ahci_port_info = {
> -       AHCI_HFLAGS(AHCI_HFLAG_NO_PMP | AHCI_HFLAG_YES_NCQ),
> -       .flags = AHCI_FLAG_COMMON | ATA_FLAG_NCQ,
> +       AHCI_HFLAGS(AHCI_HFLAG_NO_PMP),
> +       .flags = AHCI_FLAG_COMMON,
>         .pio_mask = ATA_PIO4,
>         .udma_mask = ATA_UDMA6,
>         .port_ops = &xgene_ahci_ops,

Suman is very familiar with this and he will proposal an solution.
Please be aware that this is only an issue with previous revision of
the chip. With the latest revision in house, this is not an issue.

-Loc
