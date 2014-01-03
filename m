Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbaACBfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 20:35:51 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:44618 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbaACBfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 20:35:50 -0500
Date: Thu, 2 Jan 2014 17:34:38 -0800
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org, boris.ostrovsky@oracle.com,
        stefano.stabellini@eu.citrix.com
Subject: Re: [PATCH v12 03/18] xen/pvh: Early bootup changes in PV code
 (v2).
Message-ID: <20140102173438.40612127@mantra.us.oracle.com>
In-Reply-To: <20140102183221.GD3021@pegasus.dumpdata.com>
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com>
	<1388550945-25499-4-git-send-email-konrad.wilk@oracle.com>
	<52C58691.4040502@citrix.com>
	<20140102183221.GD3021@pegasus.dumpdata.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.18.9; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jan 2014 13:32:21 -0500
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> On Thu, Jan 02, 2014 at 03:32:33PM +0000, David Vrabel wrote:
> > On 01/01/14 04:35, Konrad Rzeszutek Wilk wrote:
> > > From: Mukesh Rathor <mukesh.rathor@oracle.com>
> > > 
> > > In the bootup code for PVH we can trap cpuid via vmexit, so don't
> > > need to use emulated prefix call. We also check for vector
> > > callback early on, as it is a required feature. PVH also runs at
> > > default kernel IOPL.
> > > 
> > > Finally, pure PV settings are moved to a separate function that
> > > are only called for pure PV, ie, pv with pvmmu. They are also
> > > #ifdef with CONFIG_XEN_PVMMU.
> > [...]
> > > @@ -331,12 +333,15 @@ static void xen_cpuid(unsigned int *ax,
> > > unsigned int *bx, break;
> > >  	}
> > >  
> > > -	asm(XEN_EMULATE_PREFIX "cpuid"
> > > -		: "=a" (*ax),
> > > -		  "=b" (*bx),
> > > -		  "=c" (*cx),
> > > -		  "=d" (*dx)
> > > -		: "0" (*ax), "2" (*cx));
> > > +	if (xen_pvh_domain())
> > > +		native_cpuid(ax, bx, cx, dx);
> > > +	else
> > > +		asm(XEN_EMULATE_PREFIX "cpuid"
> > > +			: "=a" (*ax),
> > > +			"=b" (*bx),
> > > +			"=c" (*cx),
> > > +			"=d" (*dx)
> > > +			: "0" (*ax), "2" (*cx));
> > 
> > For this one off cpuid call it seems preferrable to me to use the
> > emulate prefix rather than diverge from PV.
> 
> This was before the PV cpuid was deemed OK to be used on PVH.
> Will rip this out to use the same version.

Whats wrong with using native cpuid? That is one of the benefits that
cpuid can be trapped via vmexit, and also there is talk of making PV
cpuid trap obsolete in the future. I suggest leaving it native.

Mukesh

