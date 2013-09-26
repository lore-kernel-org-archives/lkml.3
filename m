Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab3IZRWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 13:22:16 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:51102 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753235Ab3IZRWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 13:22:13 -0400
Message-ID: <52446D40.9040504@hurleysoftware.com>
Date: Thu, 26 Sep 2013 13:22:08 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Lin Ming <minggr@gmail.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Tejun Heo <tj@kernel.org>
Subject: Re: increased vmap_area_lock contentions on "n_tty: Move buffers
 into n_tty_data"
References: <20130913005133.GA32479@localhost> <20130913010936.GA1291@localhost> <5238767D.1080606@hurleysoftware.com> <20130917232214.GA11390@localhost> <5238F252.5070905@hurleysoftware.com> <CAF1ivSbYg296oHhO0_UXwkos8Ui_1C93pUnXPzow4qLWyAa2kg@mail.gmail.com> <5242C960.7050506@hurleysoftware.com> <1380124944.27676.1.camel@monkey32> <87r4cc8e0q.fsf@tassilo.jf.intel.com> <52441FF7.1030405@hurleysoftware.com> <20130926153208.GN18242@two.firstfloor.org>
In-Reply-To: <20130926153208.GN18242@two.firstfloor.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 11:32 AM, Andi Kleen wrote:
> On Thu, Sep 26, 2013 at 07:52:23AM -0400, Peter Hurley wrote:
>> On 09/25/2013 11:20 PM, Andi Kleen wrote:
>>> Lin Ming <minggr@gmail.com> writes:
>>>>
>>>> Would you like below patch?
>>>
>>> The loop body keeps rather complex state. It could easily
>>> get confused by parallel RCU changes.
>>>
>>> So if the list changes in parallel you may suddenly
>>> report very bogus values, as the va_start - prev_end
>>> computation may be bogus.
>>>
>>> Perhaps it's ok (may report bogus gaps), but it seems a bit risky.
>>
>> I don't understand how the computed gap would be bogus; there
>> _was_ a list state in which that particular gap existed. The fact
>
> It could change any time as you don't have an atomic view
> of vm_end / vm_start. It is valid to change the fields
> with the lock held.

va_start and va_end are constant for the lifetime of their vmap_area
(if it's accessible by traversing the vmap_area_list), so it is
not possible for an rcu-based list traversal to see different
values of these individual fields than the spin-locked version.

In addition, for the rcu-based traversal to have arrived at any given
vmap_area requires that the previous vmap_area was its adjacent
lower range at the instant in time when the list cursor was advanced;
again, this is no different than if the spin-locked version had
happened to begin at that same instant.

Regards,
Peter Hurley



