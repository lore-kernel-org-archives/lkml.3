Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbaEVITk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 04:19:40 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:34521 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867AbaEVITh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 04:19:37 -0400
Content-Type: text/plain; charset=UTF-8
From: Ian Munsie <imunsie@au1.ibm.com>
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        scottwood <scottwood@freescale.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v4 09/11] powerpc/perf: add support for the hv 24x7 interface
In-reply-to: <1394064082-6242-10-git-send-email-cody@linux.vnet.ibm.com>
References: <1394064082-6242-1-git-send-email-cody@linux.vnet.ibm.com> <1394064082-6242-10-git-send-email-cody@linux.vnet.ibm.com>
Date: Thu, 22 May 2014 18:19:29 +1000
Message-Id: <1400744950-sup-4804@delenn.ozlabs.ibm.com>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052208-7014-0000-0000-000004EFF611
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cody,

I just tried building this with gcc 4.5, which failed with the following
warning (treated as an error):

cc1: warnings being treated as errors
arch/powerpc/perf/hv-24x7.c: In function 'single_24x7_request':
arch/powerpc/perf/hv-24x7.c:346:1: error: the frame size of 8192 bytes is larger than 2048 bytes
make[3]: *** [arch/powerpc/perf/hv-24x7.o] Error 1
make[2]: *** [arch/powerpc/perf] Error 2

My .config has CONFIG_FRAME_WARN=2048 (default on 64bit), but the
alignment constraints in this function may require 8K on the stack -
possibly a bit large?


Notably for some reason this warning no longer seems to trigger on gcc
4.8 (or at least somewhere between 4.5-4.8), though the assembly does
still show it aligning the buffers.


Excerpts from Cody P Schafer's message of 2014-03-06 11:01:08 +1100:
> +static unsigned long single_24x7_request(u8 domain, u32 offset, u16 ix,
<snip>
> +    /*
> +     * request_buffer and result_buffer are not required to be 4k aligned,
> +     * but are not allowed to cross any 4k boundary. Aligning them to 4k is
> +     * the simplest way to ensure that.
> +     */
> +    struct reqb {
> +        struct hv_24x7_request_buffer buf;
> +        struct hv_24x7_request req;
> +    } __packed __aligned(4096) request_buffer = {
<snip>
> +    struct resb {
> +        struct hv_24x7_data_result_buffer buf;
> +        struct hv_24x7_result res;
> +        struct hv_24x7_result_element elem;
> +        __be64 result;
> +    } __packed __aligned(4096) result_buffer = {};
<snip>


Cheers,
-Ian

