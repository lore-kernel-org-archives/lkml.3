Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbaLRIfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 03:35:06 -0500
Received: from plane.gmane.org ([80.91.229.3]:46222 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048AbaLRIfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 03:35:04 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [v3 23/26] KVM: Update Posted-Interrupts Descriptor when vCPU
 is preempted
Date: Thu, 18 Dec 2014 09:32:29 +0100
Message-ID: <5492911D.3000900@redhat.com>
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com>	<1418397300-10870-24-git-send-email-feng.wu@intel.com>	<5491B924.3090200@redhat.com> <E959C4978C3B6342920538CF579893F002307C66@SHSMSX104.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: iommu@lists.linux-foundation.org, kvm@vger.kernel.org
X-Gmane-NNTP-Posting-Host: net-2-35-193-40.cust.vodafonedsl.it
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
In-Reply-To: <E959C4978C3B6342920538CF579893F002307C66@SHSMSX104.ccr.corp.intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 18/12/2014 04:15, Wu, Feng wrote:
> Thanks for your comments, Paolo!
> 
> If we use u64 new_control, we cannot use new.sn any more.
> Maybe we can change the struct pi_desc {} like this:
> 
> typedef struct pid_control{
>         u64     on      : 1,
>         sn      : 1,
>         rsvd_1  : 13,
>         ndm     : 1,
>         nv      : 8,
>         rsvd_2  : 8,
>         ndst    : 32;
> }pid_control_t;
> 
> struct pi_desc {
>         u32 pir[8];     /* Posted interrupt requested */
> 		pid_control_t control;

Probably something like this to keep the union:

typedef union pid_control {
	u64 full;
	struct {
		u64 on : 1,
		...
	} fields;
};

>         u32 rsvd[6];
> } __aligned(64);
> 
> 
> Then we can define pid_control_t new_control, old_control. And use new_control.sn = 0.
> 
> What is your opinon?

Sure.  Alternatively, keep using struct pi_desc new; just
do not zero it, nor access any field outide the control word.

Paolo

