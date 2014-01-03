Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbaACPTE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 10:19:04 -0500
Received: from smtp.citrix.com ([66.165.176.89]:8079 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568AbaACPTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 10:19:01 -0500
X-IronPort-AV: E=Sophos;i="4.95,598,1384300800"; 
   d="scan'208";a="89560902"
Message-ID: <52C6D4E3.9000701@citrix.com>
Date: Fri, 3 Jan 2014 15:18:59 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <stefano.stabellini@eu.citrix.com>,
        <mukesh.rathor@oracle.com>
Subject: Re: [PATCH v12 07/18] xen/pvh: Setup up shared_info.
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com> <1388550945-25499-8-git-send-email-konrad.wilk@oracle.com> <52C54D3C.4050101@citrix.com> <20140103143902.GB27019@phenom.dumpdata.com>
In-Reply-To: <20140103143902.GB27019@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/14 14:39, Konrad Rzeszutek Wilk wrote:
> On Thu, Jan 02, 2014 at 11:27:56AM +0000, David Vrabel wrote:
>> On 01/01/14 04:35, Konrad Rzeszutek Wilk wrote:
>>> From: Mukesh Rathor <mukesh.rathor@oracle.com>
>>>
>>> For PVHVM the shared_info structure is provided via the same way
>>> as for normal PV guests (see include/xen/interface/xen.h).
>>>
>>> That is during bootup we get 'xen_start_info' via the %esi register
>>> in startup_xen. Then later we extract the 'shared_info' from said
>>> structure (in xen_setup_shared_info) and start using it.
>>>
>>> The 'xen_setup_shared_info' is all setup to work with auto-xlat
>>> guests, but there are two functions which it calls that are not:
>>> xen_setup_mfn_list_list and xen_setup_vcpu_info_placement.
>>> This patch modifies those to work in auto-xlat mode.
>> [...]
>>> --- a/arch/x86/xen/enlighten.c
>>> +++ b/arch/x86/xen/enlighten.c
>>> @@ -1147,8 +1147,9 @@ void xen_setup_vcpu_info_placement(void)
>>>  		xen_vcpu_setup(cpu);
>>>  
>>>  	/* xen_vcpu_setup managed to place the vcpu_info within the
>>> -	   percpu area for all cpus, so make use of it */
>>> -	if (have_vcpu_info_placement) {
>>> +	 * percpu area for all cpus, so make use of it. Note that for
>>> +	 * PVH we want to use native IRQ mechanism. */
>>> +	if (have_vcpu_info_placement && !xen_pvh_domain()) {
>>>  		pv_irq_ops.save_fl = __PV_IS_CALLEE_SAVE(xen_save_fl_direct);
>>>  		pv_irq_ops.restore_fl = __PV_IS_CALLEE_SAVE(xen_restore_fl_direct);
>>>  		pv_irq_ops.irq_disable = __PV_IS_CALLEE_SAVE(xen_irq_disable_direct);
>>
>> Should this be in a separate patch: "xen/pvh: use native irq ops"?
> 
> On a second thought I think not. The reason is explained in the commit
> description:
> 
>  The 'xen_setup_shared_info' is all setup to work with auto-xlat
>  guests, but there are two functions which it calls that are not:
>  xen_setup_mfn_list_list and xen_setup_vcpu_info_placement.
>  This patch modifies those to work in auto-xlat mode.
> 
> If we move this to another patch, it is going to be mostly the same
> comment and this patch will feel unfinished.

Looking at again, this hunk be in "xen/pvh: Piggyback on PVHVM for event
channel" where we have:

+	if (!xen_feature(XENFEAT_hvm_callback_vector))
+		pv_irq_ops = xen_irq_ops;

The tests in both places need to be the same as well.

David
