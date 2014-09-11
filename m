Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672AbaIKOHU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:07:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754499AbaIKOHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:07:17 -0400
Message-ID: <5411AC82.4080005@redhat.com>
Date: Thu, 11 Sep 2014 16:06:58 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@kernel.org>
CC: Tang Chen <tangchen@cn.fujitsu.com>, mtosatti@redhat.com,
        nadav.amit@gmail.com, jan.kiszka@web.de, kvm@vger.kernel.org,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        guz.fnst@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 4/7] kvm, mem-hotplug: Reload L1' apic access page
 on migration in vcpu_enter_guest().
References: <1410413886-32213-1-git-send-email-tangchen@cn.fujitsu.com> <1410413886-32213-5-git-send-email-tangchen@cn.fujitsu.com> <541169AD.6060908@redhat.com> <20140911101200.GF25317@minantech.com> <54117DB4.307@redhat.com> <20140911113051.GG25317@minantech.com> <54119E01.9000908@redhat.com> <20140911135956.GC26540@minantech.com>
In-Reply-To: <20140911135956.GC26540@minantech.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 11/09/2014 15:59, Gleb Natapov ha scritto:
> 
> Suppose vmcs01->APIC_ACCESS_ADDR = 0xf000. During L2 entry
> vmcs02->APIC_ACCESS_ADDR is set to 0xf000 too (by prepare_vmcs02). Now
> 0xf000 is migrated to 0x8000, mmu notifier is called, it forces vmexit,
> but vcpu is in a guest mode so vmcs02->APIC_ACCESS_ADDR is never updated
> to 0x8000 because of "if (!is_guest_mode(vcpu))" check. So what am I
> missing here?

Right, guest mode isn't left as soon as you execute nested_vmx_vmexit,
because this isn't an L2->L1 exit.  So we need an "else" for that "if
(!is_guest_mode(vcpu))", in which case the hpa is ignored and
vmcs12->apic_access_addr is used instead?

Paolo
