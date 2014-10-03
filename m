Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbaJCNJe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 09:09:34 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:42549 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbaJCNJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 09:09:31 -0400
Message-ID: <542EA009.4060009@6wind.com>
Date: Fri, 03 Oct 2014 15:09:29 +0200
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reply-To: nicolas.dichtel@6wind.com
Organization: 6WIND
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net,
        akpm@linux-foundation.org, adobriyan@gmail.com, rui.xiang@huawei.com,
        viro@zeniv.linux.org.uk, oleg@redhat.com, gorcunov@openvz.org,
        kirill.shutemov@linux.intel.com, grant.likely@secretlab.ca,
        tytso@mit.edu, Thierry Herbelot <thierry.herbelot@6wind.com>
Subject: Re: [RFC PATCH linux 2/2] fs/proc: use a hash table for the directory
 entries
References: <20131003.150947.2179820478039260398.davem@davemloft.net>	<1412263501-6572-1-git-send-email-nicolas.dichtel@6wind.com>	<1412263501-6572-3-git-send-email-nicolas.dichtel@6wind.com> <87h9zmpcz5.fsf@x220.int.ebiederm.org>
In-Reply-To: <87h9zmpcz5.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 02/10/2014 20:01, Eric W. Biederman a écrit :
> Nicolas Dichtel <nicolas.dichtel@6wind.com> writes:
>
>> From: Thierry Herbelot <thierry.herbelot@6wind.com>
>>
>> The current implementation for the directories in /proc is using a single
>> linked list. This is slow when handling directories with large numbers of
>> entries (eg netdevice-related entries when lots of tunnels are opened).
>>
>> This patch enables multiple linked lists. A hash based on the entry name is
>> used to select the linked list for one given entry.
>>
>> The speed creation of netdevices is faster as shorter linked lists must be
>> scanned when adding a new netdevice.
>
> Is the directory of primary concern /proc/net/dev/snmp6 ?
Yes.

>
> Unless I have configured my networking stack weird by mistake that
> is the only directory under /proc/net that grows when we add an
> interface.
>
> I just want to make certain I am seeing the same things that you are
> seeing.
>
> I feel silly for overlooking this directory when the rest of the
> scalability work was done.
>
>> Here are some numbers:
>>
>> dummy30000.batch contains 30 000 times 'link add type dummy'.
>>
>> Before the patch:
>> time ip -b dummy30000.batch
>> real    2m32.221s
>> user    0m0.380s
>> sys     2m30.610s
>>
>> After the patch:
>> time ip -b dummy30000.batch
>> real    1m57.190s
>> user    0m0.350s
>> sys     1m56.120s
>>
>> The single 'subdir' list head is replaced by a subdir hash table. The subdir
>> hash buckets are only allocated for directories. The number of hash buckets
>> is a compile-time parameter.
>
> That looks like a nice speed up.  A couple of things.
>
> With sysfs and sysctl when faced this class of challenge we used an
> rbtree instead of a hash table.  That should use less memory and scale
> better.
>
> I am concerned about a fixed sized hash table moving the location where
> we fall off a cliff but not removing the cliff itself.
>
> I suppose it would be possible to use the new fancy resizable hash
> tables but previous work on sysctl and sysfs suggests that we don't look
> up these entries sufficiently to require a hash table.  We just need a
> data structure that doesn't fall over at scale, and the rbtrees seem to
> do that very nicely.
Ok, I will have a look at it.



Thank you,
Nicolas
