Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab3IZLw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 07:52:27 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:52343 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756350Ab3IZLw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 07:52:26 -0400
Message-ID: <52441FF7.1030405@hurleysoftware.com>
Date: Thu, 26 Sep 2013 07:52:23 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, Lin Ming <minggr@gmail.com>
CC: Fengguang Wu <fengguang.wu@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Tejun Heo <tj@kernel.org>
Subject: Re: increased vmap_area_lock contentions on "n_tty: Move buffers
 into n_tty_data"
References: <20130913005133.GA32479@localhost>	<20130913010936.GA1291@localhost>	<5238767D.1080606@hurleysoftware.com>	<20130917232214.GA11390@localhost>	<5238F252.5070905@hurleysoftware.com>	<CAF1ivSbYg296oHhO0_UXwkos8Ui_1C93pUnXPzow4qLWyAa2kg@mail.gmail.com>	<5242C960.7050506@hurleysoftware.com>	<1380124944.27676.1.camel@monkey32> <87r4cc8e0q.fsf@tassilo.jf.intel.com>
In-Reply-To: <87r4cc8e0q.fsf@tassilo.jf.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2013 11:20 PM, Andi Kleen wrote:
> Lin Ming <minggr@gmail.com> writes:
>>
>> Would you like below patch?
>
> The loop body keeps rather complex state. It could easily
> get confused by parallel RCU changes.
>
> So if the list changes in parallel you may suddenly
> report very bogus values, as the va_start - prev_end
> computation may be bogus.
>
> Perhaps it's ok (may report bogus gaps), but it seems a bit risky.

I don't understand how the computed gap would be bogus; there
_was_ a list state in which that particular gap existed. The fact
that it may not exist anymore can also happen in the existing
algorithm the instant get_vmalloc_info() drops the vmap_area_lock.

OTOH, parallel list changes could cause an rcu-based get_vmalloc_info()
to over-report or under-report used memory due to parallel list
changes.

If this is a problem in practice, then usage and largest chunk
should be tracked by the allocator instead, obviating the need for
get_vmalloc_info() to traverse the vmap_area_list at all.

Regards,
Peter Hurley
