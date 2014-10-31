Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010AbaJaElP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 00:41:15 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:32437 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbaJaElN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 00:41:13 -0400
Message-ID: <54531258.1060908@huawei.com>
Date: Fri, 31 Oct 2014 12:38:48 +0800
From: zhanghailiang <zhang.zhanghailiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Peter Feiner <pfeiner@google.com>
CC: Andrea Arcangeli <aarcange@redhat.com>, <qemu-devel@nongnu.org>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andres Lagar-Cavilla <andreslc@google.com>,
        Dave Hansen <dave@sr71.net>, Paolo Bonzini <pbonzini@redhat.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Hugh Dickins" <hughd@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Christopher Covington <cov@codeaurora.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Android Kernel Team <kernel-team@android.com>,
        "Robert Love" <rlove@google.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        "Neil Brown" <neilb@suse.de>, Mike Hommey <mh@glandium.org>,
        Taras Glek <tglek@mozilla.com>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        "Minchan Kim" <minchan@kernel.org>, Keith Packard <keithp@keithp.com>,
        "Huangpeng (Peter)" <peter.huangpeng@huawei.com>,
        Isaku Yamahata <yamahata@valinux.co.jp>,
        Anthony Liguori <anthony@codemonkey.ws>,
        "Stefan Hajnoczi" <stefanha@gmail.com>,
        Wenchao Xia <wenchaoqemu@gmail.com>,
        "Andrew Jones" <drjones@redhat.com>,
        Juan Quintela <quintela@redhat.com>
Subject: Re: [PATCH 00/17] RFC: userfault v2
References: <1412356087-16115-1-git-send-email-aarcange@redhat.com> <544E1143.1080905@huawei.com> <20141029174607.GK19606@redhat.com> <545221A4.9030606@huawei.com> <20141031022327.GA13275@google.com> <5453022D.4040801@huawei.com>
In-Reply-To: <5453022D.4040801@huawei.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.22.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/10/31 11:29, zhanghailiang wrote:
> On 2014/10/31 10:23, Peter Feiner wrote:
>> On Thu, Oct 30, 2014 at 07:31:48PM +0800, zhanghailiang wrote:
>>> On 2014/10/30 1:46, Andrea Arcangeli wrote:
>>>> On Mon, Oct 27, 2014 at 05:32:51PM +0800, zhanghailiang wrote:
>>>>> I want to confirm a question:
>>>>> Can we support distinguishing between writing and reading memory for userfault?
>>>>> That is, we can decide whether writing a page, reading a page or both trigger userfault.
>>>> Mail is going to be long enough already so I'll just assume tracking
>>>> dirty memory in userland (instead of doing it in kernel) is worthy
>>>> feature to have here.
>>
>> I'll open that can of worms :-)
>>
>>> [...]
>>> Er, maybe i didn't describe clearly. What i really need for live memory snapshot
>>> is only wrprotect fault, like kvm's dirty tracing mechanism, *only tracing write action*.
>>>
>>> So, what i need for userfault is supporting only wrprotect fault. i don't
>>> want to get notification for non present reading faults, it will influence
>>> VM's performance and the efficiency of doing snapshot.
>>
>> Given that you do care about performance Zhanghailiang, I don't think that a
>> userfault handler is a good place to track dirty memory. Every dirtying write
>> will block on the userfault handler, which is an expensively slow proposition
>> compared to an in-kernel approach.
>>
>
> Agreed, but for doing live memory snapshot (VM is running when do snapsphot),
> we have to do this (block the write action), because we have to save the page before it
> is dirtied by writing action. This is the difference, compared to pre-copy migration.
>

Again;) For snapshot, i don't use its dirty tracing ability, i just use it to block write action,
and save page, and then i will remove its write protect.

>>> Also, i think this feature will benefit for migration of ivshmem and vhost-scsi
>>> which have no dirty-page-tracing now.
>>
>> I do agree wholeheartedly with you here. Manually tracking non-guest writes
>> adds to the complexity of device emulation code. A central fault-driven means
>> for dirty tracking writes from the guest and host would be a welcome
>> simplification to implementing pre-copy migration. Indeed, that's exactly what
>> I'm working on! I'm using the softdirty bit, which was introduced recently for
>> CRIU migration, to replace the use of KVM's dirty logging and manual dirty
>> tracking by the VMM during pre-copy migration. See
>
> Great! Do you plan to issue your patches to community? I mean is your work based on
> qemu? or an independent tool (CRIU migration?) for live-migration?
> Maybe i could fix the migration problem for ivshmem in qemu now,
> based on softdirty mechanism.
>
>> Documentation/vm/soft-dirty.txt and pagemap.txt in case you aren't familiar. To
>
> I have read them cursorily, it is useful for pre-copy indeed. But it seems that
> it can not meet my need for snapshot.
>
>> make softdirty usable for live migration, I've added an API to atomically
>> test-and-clear the bit and write protect the page.
>
> How can i find the API? Is it been merged in kernel's master branch already?
>
>
> Thanks,
> zhanghailiang
>
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
>

