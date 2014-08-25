Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933072AbaHYO4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 10:56:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932449AbaHYO4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 10:56:33 -0400
Date: Mon, 25 Aug 2014 16:53:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Julien Tinnes <jln@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ipc/shm: fix the historical/wrong mm->start_stack
	check
Message-ID: <20140825145341.GA3021@redhat.com>
References: <20140823144246.GA6281@redhat.com> <20140823144327.GA6299@redhat.com> <53FA23E5.5010603@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53FA23E5.5010603@colorfullife.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24, Manfred Spraul wrote:
>
> On 08/23/2014 04:43 PM, Oleg Nesterov wrote:
>> The ->start_stack check in do_shmat() looks ugly and simply wrong.
>>
>> 1. ->start_stack is only valid right after exec(), the application
>>     can switch to another stack and even unmap this area.
>>
>> 2. The reason for this check is not clear at all. The application
>>     should know what it does. And why 4 pages? And why in fact it
>>     requires 5 pages?
>>
>> 3. This wrongly assumes that the stack can only grown down.
>>
>> Personally I think we should simply kill this check, but I did not
>> dare to do this. So the patch only fixes the 1st problem (mostly to
>> avoid the usage of mm->start_stack) and ignores VM_GROWSUP.
>>
>> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Acked-by: Manfred Spraul <manfred@colorfullife.com>

Thanks!

>> +		if (vma) {
>> +			if (vma->vm_flags & VM_GROWSDOWN)
>> +				end += PAGE_SIZE * 4; /* can't overflow */
> Why is an overflow impossible?

OOPS. I swear it was not possible until I simplified this patch ;)

In fact we do not really care because do_mmap_pgoff() will fail, but
this should be fixed anyway. Either we should not check the overflows
at all, or these checks should be consistent.

I'll send v2, thanks Manfred.

Oleg.

