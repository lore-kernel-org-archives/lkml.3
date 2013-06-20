Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965320Ab3FTLCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 07:02:11 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:45561 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965156Ab3FTLCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 07:02:08 -0400
Message-ID: <51C2E12F.4000603@cogentembedded.com>
Date: Thu, 20 Jun 2013 15:02:07 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Aaron Lu <aaron.lu@intel.com>
CC: Tejun Heo <tj@kernel.org>, Matthew Garrett <mjg@redhat.com>,
        Liu Jiang <liuj97@gmail.com>, Dirk Griesbach <spamthis@freenet.de>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liu Jiang <jiang.liu@huawei.com>, Aaron Lu <aaron.lwe@gmail.com>
Subject: Re: [PATCH] libata: remove dead code from libata-acpi.c
References: <1371265368-7334-1-git-send-email-liuj97@gmail.com> <51BE6B5C.70803@intel.com> <20130617180151.GG32663@mtj.dyndns.org> <51C02571.3090100@intel.com> <51C26861.9050106@intel.com>
In-Reply-To: <51C26861.9050106@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 20-06-2013 6:26, Aaron Lu wrote:

>>>>> From: Liu Jiang <liu97@gmail.com>
>>>>>
>>>>> Commit 30dcf76acc69 "libata: migrate ACPI code over to new bindings"
>>>>> removed ACPI dock notification related code, but there's some dead
>>>>> code left, so clean up it.

[...]

> Subject: [PATCH] libata-acpi: add back ACPI based hotplug functionality

> Commit 30dcf76acc mistakenly dropped the code to register hotplug

    Please specify the summary line for this commit, the same as was 
done by Liu above (may use parens instead of quotes).

> notificaion handler for ATA port/devices, causing regression for people
> using ATA bay, as bug #59871 shows.

> Fix this by adding back the hotplug notification handler registration
> code. Since this code has to be run once and notification needs to be
> installed on every ATA port/devices handle no matter if there is actual
> device attached, we can't do this in binding time for ATA device ACPI
> handle, as the binding only occurs when a SCSI device is created, i.e.
> there is device attached. So introduced the ata_acpi_hotplug_init
> function to loop scan all ATA ACPI handles and if it is available,
> install the notification handler for it during ATA init time.

> With the ATA ACPI handle binding to SCSI device tree, it is possible now
> that when the SCSI hotplug work removes the SCSI device, the ACPI unbind
> function will find that the corresponding ACPI device has already been
> deleted by dock driver, causing a scaring message like:
> [  128.263966] scsi 4:0:0:0: Oops, 'acpi_handle' corrupt
> Fix this by waiting for SCSI hotplug task finish in our notificaion
> handler, so that the removal of ACPI device done in ACPI unbind function
> triggered by the removal of SCSI device is run earlier when ACPI device
> is still available.

> References: https://bugzilla.kernel.org/show_bug.cgi?id=59871
> Reported-and-bisected-by: Dirk Griesbach <spamthis@freenet.de>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> ---
>   drivers/ata/libata-acpi.c | 34 +++++++++++++++++++++++++++++++++-
>   drivers/ata/libata-core.c |  2 ++
>   drivers/ata/libata.h      |  2 ++
>   3 files changed, 37 insertions(+), 1 deletion(-)

> diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
> index 87f2f39..0ad54bb 100644
> --- a/drivers/ata/libata-acpi.c
> +++ b/drivers/ata/libata-acpi.c
[...]
> @@ -214,6 +216,36 @@ static const struct acpi_dock_ops ata_acpi_ap_dock_ops = {
>   	.uevent = ata_acpi_ap_uevent,
>   };
>
> +void ata_acpi_hotplug_init(struct ata_host *host)
> +{
> +	int i;
> +
> +	for (i = 0; i < host->n_ports; i++) {
> +		struct ata_port *ap = host->ports[i];
> +		acpi_handle handle;
> +		struct ata_device *dev;
> +
> +		if (!ap)
> +			continue;
> +
> +		handle = ata_ap_acpi_handle(ap);
> +		if (handle) {
> +			/* we might be on a docking station */
> +			register_hotplug_dock_device(handle,
> +					&ata_acpi_ap_dock_ops, ap);

    Please indent this line under the next character after ( above.

> +		}
> +
> +		ata_for_each_dev(dev, &ap->link, ALL) {
> +			handle = ata_dev_acpi_handle(dev);
> +			if (handle) {
> +				/* we might be on a docking station */
> +				register_hotplug_dock_device(handle,
> +						&ata_acpi_dev_dock_ops, dev);

    Same comment.

WBR, Sergei

