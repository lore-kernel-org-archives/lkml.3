Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab3EAST0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 14:19:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:44771 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517Ab3EASTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 14:19:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,590,1363158000"; 
   d="scan'208";a="329724356"
Message-ID: <51815CA3.4090807@intel.com>
Date: Wed, 01 May 2013 11:19:15 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Will Huck <will.huckk@gmail.com>
CC: Frantisek Hrbata <fhrbata@redhat.com>, hpa@zytor.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, oleg@redhat.com,
        kamaleshb@in.ibm.com, hechjie@cn.ibm.com
Subject: Re: [PATCH] x86: add phys addr validity check for /dev/mem mmap
References: <1364905733-23937-1-git-send-email-fhrbata@redhat.com> <517A0ED8.6000404@gmail.com> <20130426153502.GC3510@dhcp-26-164.brq.redhat.com> <517B777B.5020303@gmail.com> <20130427191349.GA3372@dhcp-26-164.brq.redhat.com> <517C94DA.9070002@gmail.com>
In-Reply-To: <517C94DA.9070002@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2013 08:17 PM, Will Huck wrote:
>>     PTE bits 51 - M are reserved, where M is physical address width
>> found 2)
>>     Note: step 2) is actually not needed, we can always set just the
>> 51th bit
>>     (0x8000000000000)
> 
> What's the meaning here? You trigger oops since the address is beyond
> max address cpu supported or access to a reserved page? If the answer is
> the latter, I'm think it's not right. For example, the kernel code/data
> section is reserved in memory, kernel access it will trigger oops? I
> don't think so.

I think you're confusing the original problem here with how we would
implement the solution.

/dev/mem essentially lets you create ptes with as large of a value as
you like.  You just mmap() it, and the kernel will build you a pte to
access whatever crazy offset you choose.

The problem is that on _some_ systems, you won't just get a bus error,
the kernel actually sets up some ptes which the hardware objects to (the
reserved bits in the pte), and we'll panic when the hardware sees the
ptes.  We're trying to avoid these panics by ensuring that we never
create these nasty ptes.

Those "nasty" PTEs point to memory which can not even possibly be
*addressed* on the CPUs where they upset the hardware.  In other words,
if we limit /dev/mem to *possible* memory on the system (which is sane
all by itself) we will also fix this particular problem.


