Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbaKCQV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 11:21:29 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:44244 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbaKCQV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 11:21:27 -0500
Date: Mon, 3 Nov 2014 08:20:10 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <jdelvare@suse.de>
Cc: Michael Ellerman <mpe@ellerman.id.au>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, neelegup@linux.vnet.ibm.com
Subject: Re: [PATCH 1/2] hwmon: (ibmpowernv) Quieten when probing finds no
 device
Message-ID: <20141103162010.GB26935@roeck-us.net>
References: <1414737923-8227-1-git-send-email-mpe@ellerman.id.au>
 <20141031104147.0381619a@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141031104147.0381619a@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020204.5457AB87.0079,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 7
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

On Fri, Oct 31, 2014 at 10:41:47AM +0100, Jean Delvare wrote:
> Hi Michael,
> 
> On Fri, 31 Oct 2014 17:45:22 +1100, Michael Ellerman wrote:
> > Because we build kernels with drivers built in for many platforms, it's
> > normal for the ibmpowernv driver to be loaded on systems that don't have
> > the appropriate hardware.
> > 
> > Currently the driver spams the log with:
> > 
> >   ibmpowernv ibmpowernv.0: Opal node 'sensors' not found
> >   ibmpowernv: Platfrom driver probe failed
> > 
> > But there is no error, this machine is not a powernv and doesn't have
> > the hardware. So change the sensors message to dev_dbg(), and only print
> > an error about the probe failing if it's not ENODEV.
> > 
> > Also fix the spelling of "Platfrom" and print the actual error value.
> > 
> > Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> > ---
> >  drivers/hwmon/ibmpowernv.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/hwmon/ibmpowernv.c b/drivers/hwmon/ibmpowernv.c
> > index d2bf2c97ae70..6a30eeea94be 100644
> > --- a/drivers/hwmon/ibmpowernv.c
> > +++ b/drivers/hwmon/ibmpowernv.c
> > @@ -181,7 +181,7 @@ static int __init populate_attr_groups(struct platform_device *pdev)
> >  
> >  	opal = of_find_node_by_path("/ibm,opal/sensors");
> >  	if (!opal) {
> > -		dev_err(&pdev->dev, "Opal node 'sensors' not found\n");
> > +		dev_dbg(&pdev->dev, "Opal node 'sensors' not found\n");
> >  		return -ENODEV;
> >  	}
> >  
> > @@ -335,7 +335,9 @@ static int __init ibmpowernv_init(void)
> >  
> >  	err = platform_driver_probe(&ibmpowernv_driver, ibmpowernv_probe);
> >  	if (err) {
> > -		pr_err("Platfrom driver probe failed\n");
> > +		if (err != -ENODEV)
> > +			pr_err("Platform driver probe failed (%d)\n", err);
> > +
> >  		goto exit_device_del;
> >  	}
> >  
> 
> Looks reasonable.
> 
> Reviewed-by: Jean Delvare <jdelvare@suse.de>
> 
Applied.

Neelesh, please base your patch on top of this one.

Thanks,
Guenter
