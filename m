Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428Ab3LJG62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 01:58:28 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:53175 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab3LJG6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 01:58:23 -0500
Message-ID: <52A6BB84.30706@gmail.com>
Date: Tue, 10 Dec 2013 14:58:12 +0800
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, avi.kivity@gmail.com,
        "pbonzini@redhat.com Bonzini" <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Eric Dumazet <dada1@cosmosbay.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3 07/15] KVM: MMU: introduce nulls desc
References: <20131122191429.GA13308@amt.cnet> <65EE805B-B5DB-4BD0-A057-E5FF78D96D67@linux.vnet.ibm.com> <5292EE2F.5090305@linux.vnet.ibm.com> <20131125181254.GB21858@amt.cnet> <529413C1.60302@linux.vnet.ibm.com> <20131126193148.GA18071@amt.cnet> <5297049E.3020800@linux.vnet.ibm.com> <529D83F8.7050605@linux.vnet.ibm.com> <20131205135021.GA12996@amt.cnet> <F8A4D0B5-9900-48F3-9CA3-23A5A8CC0B4B@linux.vnet.ibm.com> <20131206002244.GA29960@amt.cnet>
In-Reply-To: <20131206002244.GA29960@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2013 08:22 AM, Marcelo Tosatti wrote:
> On Thu, Dec 05, 2013 at 11:30:27PM +0800, Xiao Guangrong wrote:
>> In some cases, the lockless walker will do endless-walking on desc and
>> without rewalk, consider this case:
>>
>> there are two descs: desc1 and desc2 who is pointed by desc1->next：
>> desc1->next = desc2.
>>
>> CPU 0                                                                            CPU 1
>>
>> lockless walk on desc1
>>                                                                  deleting desc1 from the rmap
>> lockless walk on desc2 (desc1->next)
>>                                                                 delete desc2 from the rmap
>>                                                                 add desc1
>>                                                                 add desc2, then desc2->next = desc1
>>
>> lockless walk on desc1
>>                                                                delete desc2
>>                                                                delete desc1
>>                                                                add desc2
>>                                                                add desc1; the desc1->next = desc2
>> lockless walk on desc2
>>
>> ……
>>
>> Then, the walker is endlessly walking on desc1 and desc2 without any rewalk.
> 
> The counter can be local to the walker. If its more than maximum rmap
> size, break.
> 
> (but still, please consider carefully whether lockless list walking is
> really necessary or can be avoided).

Yep, Marcelo, you're right.

After thinking more, i do not have any idea to simplify this. Your approach
(lockless on the first level) seems a better solution. Will do it based on that
ways.

Thanks!


