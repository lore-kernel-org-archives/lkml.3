Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736AbaEVWWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 18:22:46 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:44274 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbaEVWWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 18:22:44 -0400
Message-ID: <537E78AD.1040409@linux.vnet.ibm.com>
Date: Thu, 22 May 2014 15:22:37 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ian Munsie <imunsie@au1.ibm.com>
CC: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        scottwood <scottwood@freescale.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v4 09/11] powerpc/perf: add support for the hv 24x7 interface
References: <1394064082-6242-1-git-send-email-cody@linux.vnet.ibm.com> <1394064082-6242-10-git-send-email-cody@linux.vnet.ibm.com> <1400744950-sup-4804@delenn.ozlabs.ibm.com>
In-Reply-To: <1400744950-sup-4804@delenn.ozlabs.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052222-0320-0000-0000-000003598D7C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2014 01:19 AM, Ian Munsie wrote:
> Hi Cody,
>
> I just tried building this with gcc 4.5, which failed with the following
> warning (treated as an error):
>
> cc1: warnings being treated as errors
> arch/powerpc/perf/hv-24x7.c: In function 'single_24x7_request':
> arch/powerpc/perf/hv-24x7.c:346:1: error: the frame size of 8192 bytes is larger than 2048 bytes
> make[3]: *** [arch/powerpc/perf/hv-24x7.o] Error 1
> make[2]: *** [arch/powerpc/perf] Error 2
>
> My .config has CONFIG_FRAME_WARN=2048 (default on 64bit), but the
> alignment constraints in this function may require 8K on the stack -
> possibly a bit large?
>

Yep, it is a bit large. In other places in hv-24x7 that use similar 
firmware interfaces (with similar alignment requirements), I've used a 
kmem_cache (hv_page_cache). Testing out a patch that uses that here as well.

>
> Notably for some reason this warning no longer seems to trigger on gcc
> 4.8 (or at least somewhere between 4.5-4.8), though the assembly does
> still show it aligning the buffers.

That's a bit concerning (and might be why I didn't pick it up, using gcc 
4.9.0 over here). Looking at the gcc docs, it seems to indicate that 
alloca() and VLAs aren't counted for -Wframe-larger-than. Perhaps gcc 
decided to move locally defined structures with alignment requirements 
into that same bucket? (while size of the structures is statically 
determinable, the stack consumption due to alignment is [to some degree] 
variable).

