Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbaKQVAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 16:00:17 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:56806 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbaKQVAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 16:00:15 -0500
Date: Mon, 17 Nov 2014 13:00:09 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Alan Tull <atull@opensource.altera.com>
Subject: Re: [PATCH] regulator: Ensure unique regulator debugfs directory
 names
Message-ID: <20141117210009.GA28122@roeck-us.net>
References: <1413559023-18293-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413559023-18293-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020207.546A61DE.00D3,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 3
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2014 at 08:17:03AM -0700, Guenter Roeck wrote:
> If multiple regulator devices of the same type exist in a system,
> the regulator driver assigns generic names for the regulators it
> provides, and debugfs is enabled, the regulator subsystem attempts
> to create multiple entries with the same name in the regulator debugfs
> directory. This fails for all but the first regulator, resulting in
> multiple "Failed to create debugfs directory" log entries.
> 
> To avoid the problem, prepend the debugfs directory name for a regulator
> with its parent device name if available, but only if no explicit
> regulator name was provided.
> 
> Cc: Alan Tull <atull@opensource.altera.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Hi Mark,

did you have time to look into this patch ?

Thanks,
Guenter

> ---
>  drivers/regulator/core.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index cd87c0c..92f7a53 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -3538,7 +3538,18 @@ static int add_regulator_attributes(struct regulator_dev *rdev)
>  
>  static void rdev_init_debugfs(struct regulator_dev *rdev)
>  {
> -	rdev->debugfs = debugfs_create_dir(rdev_get_name(rdev), debugfs_root);
> +	struct device *parent = rdev->dev.parent;
> +	const char *rname = rdev_get_name(rdev);
> +	char name[NAME_MAX];
> +
> +	/* Avoid duplicate debugfs directory names */
> +	if (parent && rname == rdev->desc->name) {
> +		snprintf(name, sizeof(name), "%s-%s", dev_name(parent),
> +			 rname);
> +		rname = name;
> +	}
> +
> +	rdev->debugfs = debugfs_create_dir(rname, debugfs_root);
>  	if (!rdev->debugfs) {
>  		rdev_warn(rdev, "Failed to create debugfs directory\n");
>  		return;
> -- 
> 1.9.1
> 
