Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab3JXQa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 12:30:59 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:57838 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798Ab3JXQa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 12:30:57 -0400
Message-ID: <52694B3F.5090008@linaro.org>
Date: Thu, 24 Oct 2013 17:30:55 +0100
From: Julien Grall <julien.grall@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: ian.campbell@citrix.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org
Subject: Re: [Xen-devel] [PATCH] xen/hvc-console: Make it work with HVM guests.
References: <1380317117-21719-1-git-send-email-konrad.wilk@oracle.com> <5245FD71.3080408@linaro.org> <20130930144513.GM3106@phenom.dumpdata.com> <5251CD98.70807@linaro.org> <20131023161518.GA28413@phenom.dumpdata.com> <526848C1.5030705@linaro.org> <20131024144921.GB29944@phenom.dumpdata.com>
In-Reply-To: <20131024144921.GB29944@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/24/2013 03:49 PM, Konrad Rzeszutek Wilk wrote:
> On Wed, Oct 23, 2013 at 11:08:01PM +0100, Julien Grall wrote:
>>
>>
>> On 10/23/2013 05:15 PM, Konrad Rzeszutek Wilk wrote:
>>> On Sun, Oct 06, 2013 at 09:52:40PM +0100, Julien Grall wrote:
>> Actually, I looked closer the code, with the new solution
>> xen_raw_printk/xen_raw_console_write can't be call on ARM during
>> early init.
>>
>> On ARM, xen_domain_type is initialized during a core initcall. So
>> it's not possible to call the function before.
>
> OK, so won't work and won't harm. That is OK I think.

I use xen_raw_printk every time to debug early code and when someone has 
an issue with Linux (for instance no log in the console), we advise them 
to use xen_raw_printk.
It's annoying for every ARM developer to modify ourself the function 
each time we need it...

I'm sure the solution "move xen call earlier" will come up in few mails, 
so there was a discussion for swiotlb few weeks ago 
(https://lkml.org/lkml/2013/8/29/609). And the final decision was to 
avoid specific Xen call in arch_setup.

So I think, for now the best solution is to call unconditionally 
dom0_write_console on ARM (32 and 64 bits).

#ifdef CONFIG_X86
if (xen_domain) {
   ...
} else if (...) {
...
}
#else
    dom0_write_console
#endif

It will avoid to carry non-upstream patch for ARM and point out every 
time developer to this patch.

Stefano, Ian, any opinion?

-- 
Julien Grall
