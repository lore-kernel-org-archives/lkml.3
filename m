Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028AbaANBhe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 20:37:34 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:61933 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbaANBhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 20:37:31 -0500
Message-ID: <52D494D2.7000908@huawei.com>
Date: Tue, 14 Jan 2014 09:37:22 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [STABLE] find missing bug fixes in a stable kernel
References: <52D3958B.1060902@huawei.com> <20140113155746.GA2432@kroah.com>
In-Reply-To: <20140113155746.GA2432@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/1/13 23:57, Greg Kroah-Hartman wrote:
> On Mon, Jan 13, 2014 at 03:28:11PM +0800, Li Zefan wrote:
>> We have several long-term and extended stable kernels, and it's possible
>> that a bug fix is in some stable versions but is missing in some other
>> versions, so I've written a script to find out those fixes.
>>
>> Take 3.4.xx and 3.2.xx for example. If a bug fix was merged into upstream
>> kernel after 3.4, and then it was backported to 3.2.xx, then it probably
>> needs to be backported to 3.4.xx.
> 
> I agree.
> 
>> The result is, there're ~430 bug fixes in 3.2.xx that probably need to be
>> backported to 3.4.xx. Given there're about 4500 commits in 3.2.xx, that
>> is ~10%, which is quite a big number for stable kernels.
> 
> That's a really big number, how am I missing so many patches for the 3.4
> kernel?  Is it because people are doing backports to 3.2 for patches
> that didn't apply to 3.4?  Or are these patches being applied that do
> not have -stable markings on them?  Or something else?
> 

I guess the biggest reason is, most people tag a patch with stable without
specifying kernel versions, and if this patch can't be applied to 3.4, it
will be dropped silently. I guess Ben has been checking this kind of patches
manually.

>> We (our team in Huawei) are going to go through the whole list to filter
>> out fixes that're applicable for 3.4.xx.
>>
>> I've attached the lists for 3.4 and 3.10.
> 
> The list format doesn't seem to make much sense, care to explain it a
> bit better?
> 

Sure.

[upstream commit]    [3.8]    [3.5]    [3.2]
961246b4ed8d e5bb683b0c24 650e61355b81 d28828aae0b1
...
84235de394d9              4e0c7c422e59(2 2)

The last lines means upstream commit 84235de394d9 were backported to 3.5 only,
and both upstream commit and stable commit appeared twice in 3.5.xx changelog.

We can find this if we look into git-log:

Revert "fs: buffer: move allocation failure loop into the allocator"

This reverts commit 4e0c7c422e59801cab17bb567e91df725d797645 which is
commit 84235de394d9775bfaa7fa9762a59d91fef0c1fc upstream.

>>
>> If a commit ID appears more than once in changelogs, it's possible that's
>> because the commit was reverted later, so I tagged this kind of commits
>> in the lists.
> 
>> [upstream commit]    [stable commit]    [occurrences]
>> 8c4f3c3fa968 874d3954a35c 2 1
> 
> I'll use this as an example, this patch was not marked for -stable
> backporting, yet it showed up in the 3.2-stable tree.  Why?
> 

Don't know. I can't trigger the bug using the repproducer in the changelog.
Checking this list may also find out some patches that needn't/shouldn't
be backported, which is also a good thing.

Most of other commits in the list were marked for stable.

> And what does the [occurrences] column mean?
> 

You can think of it as:

# git log v3.2..v3.2.61 | grep -c 8c4f3c3fa968
# git log v3.2..v3.2.61 | grep -c 874d3954a35c

This is used to help check if a fix has been reverted.

