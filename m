Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab3DLNir (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 09:38:47 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:55191 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab3DLNiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 09:38:46 -0400
Message-ID: <51680E63.3070100@hitachi.com>
Date: Fri, 12 Apr 2013 22:38:43 +0900
From: Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC Patch 0/2] mm: Add parameters to make kernel behavior at
 memory error on dirty cache selectable
References: <51662D5B.3050001@hitachi.com> <20130411134915.GH16732@two.firstfloor.org> <1365693788-djsd2ymu-mutt-n-horiguchi@ah.jp.nec.com> <20130411181004.GK16732@two.firstfloor.org>
In-Reply-To: <20130411181004.GK16732@two.firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/12 3:10), Andi Kleen wrote:
> On Thu, Apr 11, 2013 at 11:23:08AM -0400, Naoya Horiguchi wrote:
>> On Thu, Apr 11, 2013 at 03:49:16PM +0200, Andi Kleen wrote:
>>>> As a result, if the dirty cache includes user data, the data is lost,
>>>> and data corruption occurs if an application uses old data.
>>>
>>> The application cannot use old data, the kernel code kills it if it
>>> would do that. And if it's IO data there is an EIO triggered.
>>>
>>> iirc the only concern in the past was that the application may miss
>>> the asynchronous EIO because it's cleared on any fd access. 
>>>
>>> This is a general problem not specific to memory error handling, 
>>> as these asynchronous IO errors can happen due to other reason
>>> (bad disk etc.) 
>>>
>>> If you're really concerned about this case I think the solution
>>> is to make the EIO more sticky so that there is a higher chance
>>> than it gets returned.  This will make your data much more safe,
>>> as it will cover all kinds of IO errors, not just the obscure memory
>>> errors.

I agree with Andi. We need to care both memory error and asynchronous
I/O error.

>> I'm interested in this topic, and in previous discussion, what I was said
>> is that we can't expect user applications to change their behaviors when
>> they get EIO, so globally changing EIO's stickiness is not a great approach.
> 
> Not sure. Some of the current behavior may be dubious and it may 
> be possible to change it. But would need more analysis.
> 
> I don't think we're concerned that much about "correct" applications,
> but more ones that do not check everything. So returning more
> errors should be safer.
> 
> For example you could have a sysctl that enables always stick
> IO error -- that keeps erroring until it is closed.
> 
>> I'm working on a new pagecache tag based mechanism to solve this.
>> But it needs time and more discussions.
>> So I guess Tanino-san suggests giving up on dirty pagecache errors
>> as a quick solution.
> 
> A quick solution would be enabling panic for any asynchronous IO error.
> I don't think the memory error code is the right point to hook into.

Yes. I think both short term solution and long term solution is necessary
in order to enable hwpoison feature for Linux as KVM hypervisor.

So my proposal is as follows,
  For short term solution to care both memory error and I/O error:
    - I will resend a panic knob to handle data lost related to dirty cache
      which is caused by memory error and I/O error.

  For long term solution:
    - Andi's proposal or Horiguchi-san's new pagecache tag based mechanism

Regards,
Mitsuhiro Tanino

