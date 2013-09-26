Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab3IZRfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 13:35:37 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:48870 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751080Ab3IZRff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 13:35:35 -0400
Message-ID: <52447064.5030902@hurleysoftware.com>
Date: Thu, 26 Sep 2013 13:35:32 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Tejun Heo <tj@kernel.org>
Subject: Re: increased vmap_area_lock contentions on "n_tty: Move buffers
 into n_tty_data"
References: <20130913005133.GA32479@localhost> <20130913010936.GA1291@localhost> <5238767D.1080606@hurleysoftware.com> <20130917232214.GA11390@localhost> <5238F252.5070905@hurleysoftware.com> <20130926003315.2e81bc84.akpm@linux-foundation.org> <52441B23.7050704@hurleysoftware.com> <20130926150421.GA25545@kroah.com>
In-Reply-To: <20130926150421.GA25545@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 11:04 AM, Greg KH wrote:
> On Thu, Sep 26, 2013 at 07:31:47AM -0400, Peter Hurley wrote:
>> On 09/26/2013 03:33 AM, Andrew Morton wrote:
>>> On Tue, 17 Sep 2013 20:22:42 -0400 Peter Hurley <peter@hurleysoftware.com> wrote:
>>>
>>>> Looking over vmalloc.c, the critical section footprint of the vmap_area_lock
>>>> could definitely be reduced (even nearly eliminated), but that's a project for
>>>> another day :)
>>>
>>> 20bafb3d23d10 ("n_tty: Move buffers into n_tty_data") switched a
>>> kmalloc (which is very fast) to a vmalloc (which is very slow) without
>>> so much as mentioning it in the changelog.  This should have been
>>> picked up at review, btw.
>>>
>>> Revert that part of the patch and the problem will be solved.
>>>
>>> If we are really really worried that a ~9k kmalloc might fail or will
>>> be slow, then implement a fallback to vmalloc() if kmalloc(GFP_NOWARN)
>>> failed.  This kinda sucks, but is practical, but really should only be
>>> done if necessary - ie, if problems with using plain old kmalloc are
>>> demonstrable.
>>>
>>> Or just revert all of 20bafb3d23d10 - it was supposed to be a small
>>> performance improvement but turned out to be a significant performance
>>> loss.  Therefore zap.
>>
>> I have no particular objection to reverting the entire patch.
>
> How about just switching the call to vmalloc to kmalloc?  Yes, it's a
> larger size that is being allocated here, but we were allocating that
> much memory anyway before, so it should be the same "speed", if not
> faster than before (1 call to kmalloc instead of 3).

The allocation itself isn't performance-critical. The speed difference
between 1 kmalloc and 3 kmallocs here will be unmeasurable from any
user-space test.

And the only reason vmalloc has any measurable impact stems from the way
reads of /proc/meminfo behave (to which there are a number of appropriate
solutions).

The issue with a single large kmalloc is that it may fail where
3 separate, page-or-less kmallocs would not have.

Regards,
Peter Hurley
