Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbaKCP3Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 10:29:24 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:49612 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbaKCP3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 10:29:21 -0500
Message-ID: <54579F4B.8050404@redhat.com>
Date: Mon, 03 Nov 2014 16:29:15 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, Jun Nakajima <jun.nakajima@intel.com>,
        Xinhao Xu <xinhao.xu@intel.com>, Yang Zhang <yang.z.zhang@intel.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@redhat.com>, "Nadav Har'El" <nyh@il.ibm.com>
Subject: Re: [PATCH 3.2 087/102] nEPT: Nested INVEPT
References: <lsq.1414880883.12343835@decadent.org.uk>	 <5455F35E.1040304@redhat.com> <1415022261.27313.25.camel@decadent.org.uk>
In-Reply-To: <1415022261.27313.25.camel@decadent.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2014 14:44, Ben Hutchings wrote:
>> You can just use the same scheme as your patch 88/102:
> Why is that?  Why should I not use the upstream version?

Because it makes no sense to invalidate nested EPT page tables, if the 
kernel cannot make nested EPT page tables in the first place.

I think that this "if" in your patch should always trigger, thus making
your large patch equivalent to my small patch:

+	if (!(nested_vmx_secondary_ctls_high & SECONDARY_EXEC_ENABLE_EPT) ||
+	    !(nested_vmx_ept_caps & VMX_EPT_INVEPT_BIT)) {
+		kvm_queue_exception(vcpu, UD_VECTOR);
+		return 1;
+	}

... but without looking at the entire source of vmx.c in the relatively
old 3.2 kernel, I'd rather play it safe and avoid introducing bugs in case
the above turns out not to be true.

Paolo
