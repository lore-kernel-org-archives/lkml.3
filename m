Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbaG1XMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 19:12:24 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:47249 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaG1XMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 19:12:23 -0400
Date: Mon, 28 Jul 2014 16:12:20 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave.hansen@intel.com>
cc: Zhang Zhen <zhenzhang.zhang@huawei.com>, shaohui.zheng@intel.com,
        mgorman@suse.de, mingo@redhat.com, Linux MM <linux-mm@kvack.org>,
        linux-kernel@vger.kernel.org, wangnan0@huawei.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH] memory hotplug: update the variables after memory
 removed
In-Reply-To: <53D6685C.1060509@intel.com>
Message-ID: <alpine.DEB.2.02.1407281610340.8998@chino.kir.corp.google.com>
References: <1406550617-19556-1-git-send-email-zhenzhang.zhang@huawei.com> <53D642E5.2010305@huawei.com> <53D6685C.1060509@intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2014, Dave Hansen wrote:

> On 07/28/2014 05:32 AM, Zhang Zhen wrote:
> > -static void  update_end_of_memory_vars(u64 start, u64 size)
> > +static void  update_end_of_memory_vars(u64 start, u64 size, bool flag)
> >  {
> > -	unsigned long end_pfn = PFN_UP(start + size);
> > -
> > -	if (end_pfn > max_pfn) {
> > -		max_pfn = end_pfn;
> > -		max_low_pfn = end_pfn;
> > -		high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
> > +	unsigned long end_pfn;
> > +
> > +	if (flag) {
> > +		end_pfn = PFN_UP(start + size);
> > +		if (end_pfn > max_pfn) {
> > +			max_pfn = end_pfn;
> > +			max_low_pfn = end_pfn;
> > +			high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
> > +		}
> > +	} else {
> > +		end_pfn = PFN_UP(start);
> > +		if (end_pfn < max_pfn) {
> > +			max_pfn = end_pfn;
> > +			max_low_pfn = end_pfn;
> > +			high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
> > +		}
> >  	}
> >  }
> 
> I would really prefer not to see code like this.
> 
> This patch takes a small function that did one thing, copies-and-pastes
> its code 100%, subtly changes it, and makes it do two things.  The only
> thing to tell us what the difference between these two subtly different
> things is a variable called 'flag'.  So the variable is useless in
> trying to figure out what each version is supposed to do.
> 
> But, this fixes a pretty glaring deficiency in the memory remove code.
> 
> I would suggest making two functions.  Make it clear that one is to be
> used at remove time and the other at add time.  Maybe
> 
> 	move_end_of_memory_vars_down()
> and
> 	move_end_of_memory_vars_up()
> 

I agree, but I'm not sure the suggestion is any better than the patch.  I 
think it would be better to just figure out whether anything needs to be 
updated in the caller and then call a generic function.

So in arch_add_memory(), do

	end_pfn = PFN_UP(start + size);
	if (end_pfn > max_pfn)
		update_end_of_memory_vars(end_pfn);

and in arch_remove_memory(),

	end_pfn = PFN_UP(start);
	if (end_pfn < max_pfn)
		update_end_of_memory_vars(end_pfn);

and then update_end_of_memory_vars() becomes a three-liner.
