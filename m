Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbaGBJRI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 05:17:08 -0400
Received: from goliath.siemens.de ([192.35.17.28]:41788 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbaGBJRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 05:17:04 -0400
Message-ID: <53B3CDFE.20808@siemens.com>
Date: Wed, 02 Jul 2014 11:16:46 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: "Hu, Robert" <robert.hu@intel.com>,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: nVMX: Fix IRQs inject to L2 which belong to L1 since
 race
References: <1404284054-51863-1-git-send-email-wanpeng.li@linux.intel.com> <9E79D1C9A97CFD4097BCE431828FDD31983416@SHSMSX103.ccr.corp.intel.com> <53B3CADD.3000504@siemens.com> <9E79D1C9A97CFD4097BCE431828FDD3198359C@SHSMSX103.ccr.corp.intel.com>
In-Reply-To: <9E79D1C9A97CFD4097BCE431828FDD3198359C@SHSMSX103.ccr.corp.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-02 11:13, Hu, Robert wrote:
> 
>> -----Original Message-----
>> From: Jan Kiszka [mailto:jan.kiszka@siemens.com]
>> Sent: Wednesday, July 2, 2014 5:03 PM
>> To: Hu, Robert; Wanpeng Li; Paolo Bonzini; Gleb Natapov
>> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org
>> Subject: Re: [PATCH] KVM: nVMX: Fix IRQs inject to L2 which belong to L1 since
>> race
>>
>> On 2014-07-02 09:20, Hu, Robert wrote:
>>>> -----Original Message-----
>>>> From: Wanpeng Li [mailto:wanpeng.li@linux.intel.com]
>>>> Sent: Wednesday, July 2, 2014 2:54 PM
>>>> To: Paolo Bonzini; Jan Kiszka; Gleb Natapov
>>>> Cc: Hu, Robert; kvm@vger.kernel.org; linux-kernel@vger.kernel.org; Wanpeng
>> Li
>>>> Subject: [PATCH] KVM: nVMX: Fix IRQs inject to L2 which belong to L1 since
>> race
>>>>
>>>> This patch fix bug https://bugzilla.kernel.org/show_bug.cgi?id=72381
>>>>
>>>> If we didn't inject a still-pending event to L1 since nested_run_pending,
>>>> KVM_REQ_EVENT should be requested after the vmexit in order to inject the
>>>> event to L1. However, current log blindly request a KVM_REQ_EVENT even if
>>>> there is no still-pending event to L1 which blocked by nested_run_pending.
>>>> There is a race which lead to an interrupt will be injected to L2 which
>>>> belong to L1 if L0 send an interrupt to L1 during this window.
>>>>
>>>>                VCPU0                               another thread
>>>>
>>>> L1 intr not blocked on L2 first entry
>>>> vmx_vcpu_run req event
>>>> kvm check request req event
>>>> check_nested_events don't have any intr
>>>> not nested exit
>>>>                                             intr occur (8254, lapic timer
>>>> etc)
>>>> inject_pending_event now have intr
>>>> inject interrupt
>>>>
>>>> This patch fix this race by introduced a l1_events_blocked field in nested_vmx
>>>> which indicates there is still-pending event which blocked by
>>>> nested_run_pending,
>>>> and smart request a KVM_REQ_EVENT if there is a still-pending event which
>>>> blocked
>>>> by nested_run_pending.
>>>>
>>>> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
>>> Tested-by: Robert Hu<robert.hu@intel.com>
>>
>> Do you happen to have a kvm-unit-test for this race? Or how did you
>> test? Just curious, and if there is a test, it would be good to
>> integrate it.
> I just apply the patch and test the reported scenario.

Ah, sorry, missed the referenced bug report.

Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SES-DE
Corporate Competence Center Embedded Linux
