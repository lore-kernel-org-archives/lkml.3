Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932790AbaFQMfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 08:35:24 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:54379 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281AbaFQMfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 08:35:22 -0400
X-AuditID: cbfee61a-b7fef6d00000200b-da-53a03608b777
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Mikko Perttunen <mperttunen@nvidia.com>
Cc: tj@kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] libahci_platform: Fail when PHY required but PHY
 support disabled
Date: Tue, 17 Jun 2014 14:33:58 +0200
Message-id: <1661226.KiZhVLZAOz@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1403006875-22556-1-git-send-email-mperttunen@nvidia.com>
References: <1403006875-22556-1-git-send-email-mperttunen@nvidia.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t9jAV0OswXBBt1vFC2O7XjEZHF51xw2
	iwdXp7FZ/Fp+lNGBxWPTqk42j97md2wenzfJBTBHcdmkpOZklqUW6dslcGW8XG9csJO34uGE
	52wNjO+5uhg5OSQETCTm/Z7NDmGLSVy4t56ti5GLQ0hgEaPEpr0fmCCcFiaJrikLGUGq2ASs
	JCa2rwKzRQS0Jbr7PjGD2MwCXhKnLp4As4UF4iV+LrvKCmKzCKhKHFj/Hsjm4OAV0JS4uIYD
	JCwq4CmxY/tKNhCbU8BN4urc2WDlQgKuEju6fjCB2LwCghI/Jt9jgRgvL7Fv/1RWCFtHYn/r
	NLYJjAKzkJTNQlI2C0nZAkbmVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjBAftMagfjygaL
	Q4wCHIxKPLwPZecHC7EmlhVX5h5ilOBgVhLhLRFfECzEm5JYWZValB9fVJqTWnyIUZqDRUmc
	90CrdaCQQHpiSWp2ampBahFMlomDU6qB8dyRa/e6WzxfSV+NF5iWEBS92mSG0O7QnqU+j2ZM
	OLz56ObAOqYlb52erbp2m+dNdZ6Slt3/p8lLj25UT3mqt2eq00bu18sZXM0FBDmMTRvbffcy
	PPZe28/LpBQarLSxi09W/nz2q8st+/2mWz1P1/FJFAg4IfZZqOP9I0anCN4Xzj0bJ+7YocRS
	nJFoqMVcVJwIAA4U9n1UAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 17, 2014 03:07:55 PM Mikko Perttunen wrote:
> ahci_platform_get_resources handles resource management for
> platform AHCI drivers, including getting a possible PHY
> from the device tree. Since not all drivers need a PHY, it
> ignores -ENODEV and -ENOSYS from devm_get_phy. However, when
> the PHY subsystem is mistakenly disabled, -ENOSYS can be
> returned even when a PHY is needed.
> 
> This patch modifies the -ENOSYS case to check if a "phys"
> device tree node exists. If it exists, then clearly the PHY
> subsystem is mistakenly disabled and the driver cannot work,
> ahci_platform_get_resources will fail and propagate the error.
> 
> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>

Acked-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

> ---
>  drivers/ata/libahci_platform.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ata/libahci_platform.c b/drivers/ata/libahci_platform.c
> index 3a5b4ed..b007758 100644
> --- a/drivers/ata/libahci_platform.c
> +++ b/drivers/ata/libahci_platform.c
> @@ -250,8 +250,13 @@ struct ahci_host_priv *ahci_platform_get_resources(struct platform_device *pdev)
>  	if (IS_ERR(hpriv->phy)) {
>  		rc = PTR_ERR(hpriv->phy);
>  		switch (rc) {
> -		case -ENODEV:
>  		case -ENOSYS:
> +			/* No PHY support. Check if PHY is required. */
> +			if (of_find_property(dev->of_node, "phys", NULL)) {
> +				dev_err(dev, "couldn't get sata-phy: ENOSYS\n");
> +				goto err_out;
> +			}
> +		case -ENODEV:
>  			/* continue normally */
>  			hpriv->phy = NULL;
>  			break;

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

