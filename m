Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331AbbAWJns (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 04:43:48 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:33215 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750996AbbAWJno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 04:43:44 -0500
Date: Fri, 23 Jan 2015 17:40:45 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: Chris Ball <chris@printf.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] mmc: sdhci-pxav3: fix race between runtime pm and irq
Message-ID: <20150123174045.752c6626@xhacker>
In-Reply-To: <CAPDyKFrEEN6a31edMbJAfhShm3X8Q5+FohSzOdiZ7NpXsaqKPQ@mail.gmail.com>
References: <1421844313-2851-1-git-send-email-jszhang@marvell.com>
	<CAPDyKFrEEN6a31edMbJAfhShm3X8Q5+FohSzOdiZ7NpXsaqKPQ@mail.gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-23_03:2015-01-23,2015-01-23,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1501230097
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Ulf,

On Fri, 23 Jan 2015 00:23:29 -0800
Ulf Hansson <ulf.hansson@linaro.org> wrote:

> On 21 January 2015 at 13:45, Jisheng Zhang <jszhang@marvell.com> wrote:
> > This patch is to fix a race condition that may cause an unhandled irq,
> > which results in big sdhci interrupt numbers and endless "mmc1: got irq
> > while runtime suspended" msgs before v3.15.
> >
> > Consider following scenario:
> >
> >       CPU0                            CPU1
> >                               sdhci_pxav3_runtime_suspend()
> >                                spin_lock_irqsave(&host->lock, flags);
> >  sdhci_irq()
> >   spining on the &host->lock
> >                                host->runtime_suspended = true;
> >                                spin_unlock_irqrestore(&host->lock, flags);
> >   get the &host->lock
> >   runtime_suspended is true now
> >   return IRQ_NONE;
> >
> > Fix this race by using the core sdhci.c supplied
> > sdhci_runtime_suspend_host() in runtime suspend hook which will disable
> > card interrupts. We also use the sdhci_runtime_resume_host() in the
> > runtime resume hook accordingly.
> >
> > Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
> > Cc: <stable@vger.kernel.org> # v3.9+
> > ---
> >  drivers/mmc/host/sdhci-pxav3.c | 15 ++++-----------
> >  1 file changed, 4 insertions(+), 11 deletions(-)
> >
> > diff --git a/drivers/mmc/host/sdhci-pxav3.c
> > b/drivers/mmc/host/sdhci-pxav3.c index 4de39fb..6975c51 100644
> > --- a/drivers/mmc/host/sdhci-pxav3.c
> > +++ b/drivers/mmc/host/sdhci-pxav3.c
> > @@ -460,17 +460,15 @@ static int sdhci_pxav3_runtime_suspend(struct
> > device *dev) struct sdhci_host *host = dev_get_drvdata(dev);
> >         struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
> >         struct sdhci_pxa *pxa = pltfm_host->priv;
> > -       unsigned long flags;
> > +       int ret;
> >
> > -       spin_lock_irqsave(&host->lock, flags);
> > -       host->runtime_suspended = true;
> > -       spin_unlock_irqrestore(&host->lock, flags);
> > +       ret = sdhci_runtime_suspend_host(host);
> 
> If you get an error at this point, you shouldn't continue but instead
> just return an error. Maybe even return -EBUSY.

Thanks for reviewing. What about just return "ret" if get an error here?
Even if sdhci_runtime_suspend_host() return any error in the future, we
are still safe. I'm cooking a patch to behave like this.

> 
> Now, since sdhci_runtime_suspend_host() always returns 0 (should it be
> converted to void? ), perhaps you could ignore the error completely
> and return 0, as before?

Thanks,
Jisheng
