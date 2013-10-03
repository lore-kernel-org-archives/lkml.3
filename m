Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab3JCTrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 15:47:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754927Ab3JCTri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 15:47:38 -0400
Date: Thu, 3 Oct 2013 21:48:39 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Eli Cohen <eli@dev.mellanox.co.il>
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>, Andy King <acking@vmware.com>,
        Jon Mason <jon.mason@intel.com>,
        Matt Porter <mporter@kernel.crashing.org>, linux-pci@vger.kernel.org,
        linux-mips@linux-mips.org, linuxppc-dev@lists.ozlabs.org,
        linux390@de.ibm.com, linux-s390@vger.kernel.org, x86@kernel.org,
        linux-ide@vger.kernel.org, iss_storagedev@hp.com,
        linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        linux-driver@qlogic.com,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        "VMware, Inc." <pv-drivers@vmware.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH RFC 50/77] mlx5: Update MSI/MSI-X interrupts enablement
 code
Message-ID: <20131003194837.GA27636@dhcp-26-207.brq.redhat.com>
References: <cover.1380703262.git.agordeev@redhat.com>
 <9650a7dfbcfd5f1da21f7b093665abf4b1041071.1380703263.git.agordeev@redhat.com>
 <20131003071433.GA7299@mtldesk30>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003071433.GA7299@mtldesk30>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 10:14:33AM +0300, Eli Cohen wrote:
> On Wed, Oct 02, 2013 at 12:49:06PM +0200, Alexander Gordeev wrote:
> >  
> > +	err = pci_msix_table_size(dev->pdev);
> > +	if (err < 0)
> > +		return err;
> > +
> >  	nvec = dev->caps.num_ports * num_online_cpus() + MLX5_EQ_VEC_COMP_BASE;
> >  	nvec = min_t(int, nvec, num_eqs);
> > +	nvec = min_t(int, nvec, err);
> >  	if (nvec <= MLX5_EQ_VEC_COMP_BASE)
> >  		return -ENOSPC;
> 
> Making sure we don't request more vectors then the device's is capable
> of -- looks good.
> >  
> > @@ -131,20 +136,15 @@ static int mlx5_enable_msix(struct mlx5_core_dev *dev)
> >  	for (i = 0; i < nvec; i++)
> >  		table->msix_arr[i].entry = i;
> >  
> > -retry:
> > -	table->num_comp_vectors = nvec - MLX5_EQ_VEC_COMP_BASE;
> >  	err = pci_enable_msix(dev->pdev, table->msix_arr, nvec);
> > -	if (err <= 0) {
> > +	if (err) {
> > +		kfree(table->msix_arr);
> >  		return err;
> > -	} else if (err > MLX5_EQ_VEC_COMP_BASE) {
> > -		nvec = err;
> > -		goto retry;
> >  	}
> >  
> 
> According to latest sources, pci_enable_msix() may still fail so why
> do you want to remove this code?

pci_enable_msix() may fail, but it can not return a positive number.

We first calculate how many MSI-Xs we need, adjust to what we can get,
check if that is enough and only then go for it.

> > -	mlx5_core_dbg(dev, "received %d MSI vectors out of %d requested\n", err, nvec);
> > -	kfree(table->msix_arr);
> > +	table->num_comp_vectors = nvec - MLX5_EQ_VEC_COMP_BASE;
> >  
> > -	return -ENOSPC;
> > +	return 0;
> >  }
> >  
> >  static void mlx5_disable_msix(struct mlx5_core_dev *dev)

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
