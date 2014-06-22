Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751273AbaFVN5T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 09:57:19 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:37392 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbaFVN5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 09:57:18 -0400
Message-ID: <53A6E0B9.10408@gmail.com>
Date: Sun, 22 Jun 2014 16:57:13 +0300
From: Avi Kivity <avi.kivity@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, peterz@infradead.org
CC: gleb@kernel.org, pbonzini@redhat.com, eranian@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/4] kvm: Implement PEBS virtualization
References: <1401412327-14810-1-git-send-email-andi@firstfloor.org> <1401412327-14810-5-git-send-email-andi@firstfloor.org>
In-Reply-To: <1401412327-14810-5-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 05/30/2014 04:12 AM, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> PEBS (Precise Event Bases Sampling) profiling is very powerful,
> allowing improved sampling precision and much additional information,
> like address or TSX abort profiling. cycles:p and :pp uses PEBS.
>
> This patch enables PEBS profiling in KVM guests.
>
> PEBS writes profiling records to a virtual address in memory. Since
> the guest controls the virtual address space the PEBS record
> is directly delivered to the guest buffer. We set up the PEBS state
> that is works correctly.The CPU cannot handle any kinds of faults during
> these guest writes.
>
> To avoid any problems with guest pages being swapped by the host we
> pin the pages when the PEBS buffer is setup, by intercepting
> that MSR.
>
> Typically profilers only set up a single page, so pinning that is not
> a big problem. The pinning is limited to 17 pages currently (64K+1)
>
> In theory the guest can change its own page tables after the PEBS
> setup. The host has no way to track that with EPT. But if a guest
> would do that it could only crash itself. It's not expected
> that normal profilers do that.
>
>

Talking a bit with Gleb about this, I think this is impossible.

First, it's not sufficient to pin the debug store area, you also have to 
pin the guest page tables that are used to map the debug store.  But 
even if you do that, as soon as the guest fork()s, it will create a new 
pgd which the host will be free to swap out.  The processor can then 
attempt a PEBS store to an unmapped address which will fail, even though 
the guest is configured correctly.

