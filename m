Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab3DKQ3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 12:29:00 -0400
Received: from www.sr71.net ([198.145.64.142]:47882 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796Ab3DKQ27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 12:28:59 -0400
Message-ID: <5166E4CB.2060700@sr71.net>
Date: Thu, 11 Apr 2013 09:28:59 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: hpa@linux.intel.com, linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 4/5] break up slow_virt_to_phys()
References: <20130410233249.7FFCB63B@viggo.jf.intel.com> <20130410233254.EF273179@viggo.jf.intel.com> <20130411122944.GA27062@pd.tnic>
In-Reply-To: <20130411122944.GA27062@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2013 05:29 AM, Borislav Petkov wrote:
> On Wed, Apr 10, 2013 at 04:32:54PM -0700, Dave Hansen wrote:
>> +phys_addr_t slow_virt_to_phys(void *virt_addr)
>> +{
>> +	phys_addr_t result;
>> +	int ret;
>> +
>> +	ret = kernel_lookup_vaddr(virt_addr, &result);
>> +	BUG_ON(ret);
> 
> Isn't that BUG_ON still too harsh though? How about WARN_ON instead?
> It would still create a lot of noise so that it gets fixed without
> bringing down the system.

It's harsh for the cases where __pa()'s result never gets used directly,
like for checking against 'high_memory'.  If it gets used (like in
/dev/mem's case) the kernel really is doing something it does not intend
to do.  It's essentially reading or writing garbage.

On the other hand, I guess if we've been letting it do that bad thing
for years, we might as well continue.  We're not causing any _more_ damage.

I'm leaning toward making it a WARN_ON() at the moment. :)
