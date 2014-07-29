Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbaG2CF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 22:05:29 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:38228 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752061AbaG2CF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 22:05:26 -0400
Date: Tue, 29 Jul 2014 09:42:10 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: "bhelgaas@google.com" <bhelgaas@google.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] PCI: tegra: add missing cleanup in error path and
 teardown_irq
Message-ID: <20140729094210.1d599469@xhacker>
In-Reply-To: <20140728153548.GB10126@ulmo.nvidia.com>
References: <1406519142-3018-1-git-send-email-jszhang@marvell.com>
	<20140728153548.GB10126@ulmo.nvidia.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-28_04:2014-07-28,2014-07-28,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=2
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1407290028
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

On Mon, 28 Jul 2014 08:35:50 -0700
Thierry Reding <thierry.reding@gmail.com> wrote:

> On Mon, Jul 28, 2014 at 11:45:42AM +0800, Jisheng Zhang wrote:
> > We should call tegra_msi_free() to free the msi bit if
> > irq_create_mapping() fails. And we need to dispose the irq mapping
> > during irq teardown.
> 
> "MSI" and "IRQ" please.

Done in the v3 patch. Thanks for your reviewing.

> 
> > diff --git a/drivers/pci/host/pci-tegra.c b/drivers/pci/host/pci-tegra.c
> > index 083cf37..4ccc418 100644
> > --- a/drivers/pci/host/pci-tegra.c
> > +++ b/drivers/pci/host/pci-tegra.c
> > @@ -1203,8 +1203,10 @@ static int tegra_msi_setup_irq(struct msi_chip
> > *chip, struct pci_dev *pdev, return hwirq;
> >  
> >  	irq = irq_create_mapping(msi->domain, hwirq);
> > -	if (!irq)
> > +	if (!irq) {
> > +		tegra_msi_free(msi, hwirq);
> >  		return -EINVAL;
> > +	}
> >  
> >  	irq_set_msi_desc(irq, desc);
> >  
> > @@ -1222,8 +1224,10 @@ static void tegra_msi_teardown_irq(struct msi_chip
> > *chip, unsigned int irq) {
> >  	struct tegra_msi *msi = to_tegra_msi(chip);
> >  	struct irq_data *d = irq_get_irq_data(irq);
> > +	unsigned long hwirq = d->hwirq;
> 
> I don't think we need this temporary variable, d->hwirq isn't overly
> long.

irq_dispose_mapping() will clear d->hwirq as 0, so if we don't save to a temporary
variable, we will always MSI 0, this is not what we want. What do you think?

> 
> With both of the above address, this is:
> 
> Reviewed-by: Thierry Reding <treding@nvidia.com>
> Acked-by: Thierry Reding <treding@nvidia.com>

Thanks for reviewing,
Jisheng

