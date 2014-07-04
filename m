Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbaGDJdW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 05:33:22 -0400
Received: from thoth.sbs.de ([192.35.17.2]:47236 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbaGDJdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 05:33:20 -0400
Message-ID: <53B674CD.2090906@siemens.com>
Date: Fri, 04 Jul 2014 11:33:01 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>, Bandan Das <bsd@redhat.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Hu Robert <robert.hu@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Fix IRQs inject to L2 which belong to L1 since
 race
References: <1404284054-51863-1-git-send-email-wanpeng.li@linux.intel.com> <53B3CA6A.4050902@siemens.com> <jpgy4wb9g5t.fsf@redhat.com> <20140703065955.GA4236@kernel> <jpgk37u8iae.fsf@redhat.com> <20140704025250.GA2849@kernel> <53B63EF2.6000800@siemens.com>
In-Reply-To: <53B63EF2.6000800@siemens.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-04 07:43, Jan Kiszka wrote:
> All tests up to
> 307621765a are running fine here, but since a0e30e712d not much is
> completing successfully anymore:
> 
> enabling apic
> paging enabled
> cr0 = 80010011
> cr3 = 7fff000
> cr4 = 20
> PASS: test vmxon with FEATURE_CONTROL cleared
> PASS: test vmxon without FEATURE_CONTROL lock
> PASS: test enable VMX in FEATURE_CONTROL
> PASS: test FEATURE_CONTROL lock bit
> PASS: test vmxon
> FAIL: test vmptrld
> PASS: test vmclear
> init_vmcs : make_vmcs_current error
> FAIL: test vmptrst
> init_vmcs : make_vmcs_current error
> vmx_run : vmlaunch failed.
> FAIL: test vmlaunch
> FAIL: test vmlaunch
> 
> SUMMARY: 10 tests, 4 unexpected failures

Here is the reason for my failures:

000000000000010f <make_vmcs_current>:
     10f:       48 89 7c 24 f8          mov    %rdi,-0x8(%rsp)
     114:       9c                      pushfq
     115:       58                      pop    %rax
     116:       48 83 c8 41             or     $0x41,%rax
     11a:       50                      push   %rax
     11b:       9d                      popfq
     11c:       0f c7 74 24 f8          vmptrld -0x8(%rsp)
     121:       0f 96 c0                setbe  %al
     124:       0f b6 c0                movzbl %al,%eax
     127:       c3                      retq

The compiler is not aware of the fact that push/pop exists in this
function and, thus, places the vmcs parameter on the stack without
reserving the space. So the pushfq will overwrite the vmcs pointer and
let the function fail.

Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SES-DE
Corporate Competence Center Embedded Linux
