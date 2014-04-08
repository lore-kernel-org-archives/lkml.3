Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995AbaDHSyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 14:54:11 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:41760 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756894AbaDHSyG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 14:54:06 -0400
Date: Tue, 8 Apr 2014 14:53:46 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
Cc: konrad@kernel.org, xen-devel@lists.xenproject.org, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com, linux-kernel@vger.kernel.org, keir@xen.org,
        jbeulich@suse.com
Subject: Re: [Xen-devel] [XEN PATCH 1/2] hvm: Support more than 32 VCPUS when
 migrating.
Message-ID: <20140408185346.GA1678@phenom.dumpdata.com>
References: <1396859560.22845.4.camel@kazak.uk.xensource.com>
 <1396977950-8789-1-git-send-email-konrad@kernel.org>
 <1396977950-8789-2-git-send-email-konrad@kernel.org>
 <53443D88.6010202@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <53443D88.6010202@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 08:18:48PM +0200, Roger Pau Monné wrote:
> On 08/04/14 19:25, konrad@kernel.org wrote:
> > From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > 
> > When we migrate an HVM guest, by default our shared_info can
> > only hold up to 32 CPUs. As such the hypercall
> > VCPUOP_register_vcpu_info was introduced which allowed us to
> > setup per-page areas for VCPUs. This means we can boot PVHVM
> > guest with more than 32 VCPUs. During migration the per-cpu
> > structure is allocated fresh by the hypervisor (vcpu_info_mfn
> > is set to INVALID_MFN) so that the newly migrated guest
> > can do make the VCPUOP_register_vcpu_info hypercall.
> > 
> > Unfortunatly we end up triggering this condition:
> > /* Run this command on yourself or on other offline VCPUS. */
> >  if ( (v != current) && !test_bit(_VPF_down, &v->pause_flags) )
> > 
> > which means we are unable to setup the per-cpu VCPU structures
> > for running vCPUS. The Linux PV code paths make this work by
> > iterating over every vCPU with:
> > 
> >  1) is target CPU up (VCPUOP_is_up hypercall?)
> >  2) if yes, then VCPUOP_down to pause it.
> >  3) VCPUOP_register_vcpu_info
> >  4) if it was down, then VCPUOP_up to bring it back up
> > 
> > But since VCPUOP_down, VCPUOP_is_up, and VCPUOP_up are
> > not allowed on HVM guests we can't do this. This patch
> > enables this.
> 
> Hmmm, this looks like a very convoluted approach to something that could
> be solved more easily IMHO. What we do on FreeBSD is put all vCPUs into
> suspension, which means that all vCPUs except vCPU#0 will be in the
> cpususpend_handler, see:
> 
> http://svnweb.freebsd.org/base/head/sys/amd64/amd64/mp_machdep.c?revision=263878&view=markup#l1460

How do you 'suspend' them? If I remember there is a disadvantage of doing
this as you have to bring all the CPUs "offline". That in Linux means using
the stop_machine which is pretty big hammer and increases the latency for migration.

> 
> Then on resume we unblock the "suspended" CPUs, and the first thing they
> do is call cpu_ops.cpu_resume which is basically going to setup the
> vcpu_info using VCPUOP_register_vcpu_info. Not sure if something similar
> is possible under Linux, but it seems easier and doesn't require any
> Xen-side changes.
> 
> Roger.
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
