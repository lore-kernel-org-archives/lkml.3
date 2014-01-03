Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbaACPic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 10:38:32 -0500
Received: from smtp.citrix.com ([66.165.176.89]:19679 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbaACPiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 10:38:20 -0500
X-IronPort-AV: E=Sophos;i="4.95,598,1384300800"; 
   d="scan'208";a="89567669"
Date: Fri, 3 Jan 2014 15:37:21 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: David Vrabel <david.vrabel@citrix.com>
CC: Mukesh Rathor <mukesh.rathor@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH v12 03/18] xen/pvh: Early bootup changes in PV code
 (v2).
In-Reply-To: <52C69F09.5010407@citrix.com>
Message-ID: <alpine.DEB.2.02.1401031537110.8667@kaball.uk.xensource.com>
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com> <1388550945-25499-4-git-send-email-konrad.wilk@oracle.com> <52C58691.4040502@citrix.com> <20140102183221.GD3021@pegasus.dumpdata.com> <20140102173438.40612127@mantra.us.oracle.com>
 <52C69F09.5010407@citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Jan 2014, David Vrabel wrote:
> On 03/01/14 01:34, Mukesh Rathor wrote:
> > On Thu, 2 Jan 2014 13:32:21 -0500
> > Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > 
> >> On Thu, Jan 02, 2014 at 03:32:33PM +0000, David Vrabel wrote:
> >>> On 01/01/14 04:35, Konrad Rzeszutek Wilk wrote:
> >>>> From: Mukesh Rathor <mukesh.rathor@oracle.com>
> >>>>
> >>>> In the bootup code for PVH we can trap cpuid via vmexit, so don't
> >>>> need to use emulated prefix call. We also check for vector
> >>>> callback early on, as it is a required feature. PVH also runs at
> >>>> default kernel IOPL.
> >>>>
> >>>> Finally, pure PV settings are moved to a separate function that
> >>>> are only called for pure PV, ie, pv with pvmmu. They are also
> >>>> #ifdef with CONFIG_XEN_PVMMU.
> >>> [...]
> >>>> @@ -331,12 +333,15 @@ static void xen_cpuid(unsigned int *ax,
> >>>> unsigned int *bx, break;
> >>>>  	}
> >>>>  
> >>>> -	asm(XEN_EMULATE_PREFIX "cpuid"
> >>>> -		: "=a" (*ax),
> >>>> -		  "=b" (*bx),
> >>>> -		  "=c" (*cx),
> >>>> -		  "=d" (*dx)
> >>>> -		: "0" (*ax), "2" (*cx));
> >>>> +	if (xen_pvh_domain())
> >>>> +		native_cpuid(ax, bx, cx, dx);
> >>>> +	else
> >>>> +		asm(XEN_EMULATE_PREFIX "cpuid"
> >>>> +			: "=a" (*ax),
> >>>> +			"=b" (*bx),
> >>>> +			"=c" (*cx),
> >>>> +			"=d" (*dx)
> >>>> +			: "0" (*ax), "2" (*cx));
> >>>
> >>> For this one off cpuid call it seems preferrable to me to use the
> >>> emulate prefix rather than diverge from PV.
> >>
> >> This was before the PV cpuid was deemed OK to be used on PVH.
> >> Will rip this out to use the same version.
> > 
> > Whats wrong with using native cpuid? That is one of the benefits that
> > cpuid can be trapped via vmexit, and also there is talk of making PV
> > cpuid trap obsolete in the future. I suggest leaving it native.
> 
> It should either use the PV interface or the HVM one, not a hybrid of
> the two.

I agree
