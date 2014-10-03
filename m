Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494AbaJCH2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 03:28:33 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:52649 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbaJCH2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 03:28:31 -0400
Message-ID: <542E501B.1010109@6wind.com>
Date: Fri, 03 Oct 2014 09:28:27 +0200
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reply-To: nicolas.dichtel@6wind.com
Organization: 6WIND
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net,
        akpm@linux-foundation.org, rui.xiang@huawei.com,
        viro@zeniv.linux.org.uk, oleg@redhat.com, gorcunov@openvz.org,
        kirill.shutemov@linux.intel.com, grant.likely@secretlab.ca,
        tytso@mit.edu, Thierry Herbelot <thierry.herbelot@6wind.com>
Subject: Re: [RFC PATCH linux 2/2] fs/proc: use a hash table for the directory
 entries
References: <20131003.150947.2179820478039260398.davem@davemloft.net>	<1412263501-6572-1-git-send-email-nicolas.dichtel@6wind.com>	<1412263501-6572-3-git-send-email-nicolas.dichtel@6wind.com>	<87h9zmpcz5.fsf@x220.int.ebiederm.org>	<20141002200639.GA3497@p183.telecom.by> <87h9zmji3q.fsf@x220.int.ebiederm.org>
In-Reply-To: <87h9zmji3q.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 02/10/2014 23:07, Eric W. Biederman a écrit :
> Alexey Dobriyan <adobriyan@gmail.com> writes:
>
>> On Thu, Oct 02, 2014 at 11:01:50AM -0700, Eric W. Biederman wrote:
>>> Nicolas Dichtel <nicolas.dichtel@6wind.com> writes:
>>>
>>>> From: Thierry Herbelot <thierry.herbelot@6wind.com>
>>>>
>>>> The current implementation for the directories in /proc is using a single
>>>> linked list. This is slow when handling directories with large numbers of
>>>> entries (eg netdevice-related entries when lots of tunnels are opened).
>>>>
>>>> This patch enables multiple linked lists. A hash based on the entry name is
>>>> used to select the linked list for one given entry.
>>>>
>>>> The speed creation of netdevices is faster as shorter linked lists must be
>>>> scanned when adding a new netdevice.
>>>
>>> Is the directory of primary concern /proc/net/dev/snmp6 ?
>>>
>>> Unless I have configured my networking stack weird by mistake that
>>> is the only directory under /proc/net that grows when we add an
>>> interface.
>>>
>>> I just want to make certain I am seeing the same things that you are
>>> seeing.
>>>
>>> I feel silly for overlooking this directory when the rest of the
>>> scalability work was done.
>>
>> Slowdown comes from "duplicate name" check:
>>
>>          for (tmp = dir->subdir; tmp; tmp = tmp->next)
>>                  if (strcmp(tmp->name, dp->name) == 0) {
>>                          WARN(1, "proc_dir_entry '%s/%s' already registered\n",
>>                                  dir->name, dp->name);
>>                          break;
>>                  }
>>
>> Removal can be made O(1) after switching to doubly-linked list.
>
> Yes.  There is the however unfortunate fact that proc directories exist
> to be used.  If we don't switch to a better data structure than a linked
> list the actual use will then opening of the files under
> /proc/net/dev/snmp6/ will become O(N^2).  Which doesn't help much
> (assuming those files are good for something).
>
> If those files aren't actually useful we should just make registering
> them a config option.  Deprecate them strongly and let only people who
> need extreme backwards compatibility enable them.
>
> Alexey do you know that those files aren't useful?  Unless we know
> otherwise we should make those files useful.
This was proposed and nacked in a first version:
http://thread.gmane.org/gmane.linux.network/285840/


Regards,
Nicolas
