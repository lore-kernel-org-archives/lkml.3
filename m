Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646AbaDHSSw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 14:18:52 -0400
Received: from smtp.citrix.com ([66.165.176.89]:55793 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754579AbaDHSSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 14:18:51 -0400
X-IronPort-AV: E=Sophos;i="4.97,819,1389744000"; 
   d="scan'208";a="119195990"
Message-ID: <53443D88.6010202@citrix.com>
Date: Tue, 8 Apr 2014 20:18:48 +0200
From: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: <konrad@kernel.org>, <xen-devel@lists.xenproject.org>,
        <david.vrabel@citrix.com>, <boris.ostrovsky@oracle.com>,
        <linux-kernel@vger.kernel.org>, <keir@xen.org>, <jbeulich@suse.com>
Subject: Re: [Xen-devel] [XEN PATCH 1/2] hvm: Support more than 32 VCPUS when
 migrating.
References: <1396859560.22845.4.camel@kazak.uk.xensource.com>	<1396977950-8789-1-git-send-email-konrad@kernel.org> <1396977950-8789-2-git-send-email-konrad@kernel.org>
In-Reply-To: <1396977950-8789-2-git-send-email-konrad@kernel.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/14 19:25, konrad@kernel.org wrote:
> From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> When we migrate an HVM guest, by default our shared_info can
> only hold up to 32 CPUs. As such the hypercall
> VCPUOP_register_vcpu_info was introduced which allowed us to
> setup per-page areas for VCPUs. This means we can boot PVHVM
> guest with more than 32 VCPUs. During migration the per-cpu
> structure is allocated fresh by the hypervisor (vcpu_info_mfn
> is set to INVALID_MFN) so that the newly migrated guest
> can do make the VCPUOP_register_vcpu_info hypercall.
> 
> Unfortunatly we end up triggering this condition:
> /* Run this command on yourself or on other offline VCPUS. */
>  if ( (v != current) && !test_bit(_VPF_down, &v->pause_flags) )
> 
> which means we are unable to setup the per-cpu VCPU structures
> for running vCPUS. The Linux PV code paths make this work by
> iterating over every vCPU with:
> 
>  1) is target CPU up (VCPUOP_is_up hypercall?)
>  2) if yes, then VCPUOP_down to pause it.
>  3) VCPUOP_register_vcpu_info
>  4) if it was down, then VCPUOP_up to bring it back up
> 
> But since VCPUOP_down, VCPUOP_is_up, and VCPUOP_up are
> not allowed on HVM guests we can't do this. This patch
> enables this.

Hmmm, this looks like a very convoluted approach to something that could
be solved more easily IMHO. What we do on FreeBSD is put all vCPUs into
suspension, which means that all vCPUs except vCPU#0 will be in the
cpususpend_handler, see:

http://svnweb.freebsd.org/base/head/sys/amd64/amd64/mp_machdep.c?revision=263878&view=markup#l1460

Then on resume we unblock the "suspended" CPUs, and the first thing they
do is call cpu_ops.cpu_resume which is basically going to setup the
vcpu_info using VCPUOP_register_vcpu_info. Not sure if something similar
is possible under Linux, but it seems easier and doesn't require any
Xen-side changes.

Roger.

