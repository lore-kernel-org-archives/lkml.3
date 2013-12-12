Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880Ab3LLJx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 04:53:57 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:51001 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab3LLJxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 04:53:53 -0500
Message-ID: <52A987AD.4030204@6wind.com>
Date: Thu, 12 Dec 2013 10:53:49 +0100
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reply-To: nicolas.dichtel@6wind.com
Organization: 6WIND
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, gregkh@linuxfoundation.org
CC: rostedt@goodmis.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        williams@redhat.com, linux-rt-users@vger.kernel.org, lclaudio@uudg.org
Subject: Re: [BUG] stable v3.10.16+ introduced by "ip6tnl: allow to use rtnl
 ops on fb tunnel"
References: <20131113211430.1ad3bb7d@gandalf.local.home>	<20131209002531.GB14382@kroah.com> <20131211.165331.495095016561766264.davem@davemloft.net>
In-Reply-To: <20131211.165331.495095016561766264.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 11/12/2013 22:53, David Miller a écrit :
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Date: Sun, 8 Dec 2013 16:25:31 -0800
>
>> On Wed, Nov 13, 2013 at 09:14:30PM -0500, Steven Rostedt wrote:
>>> +++ b/net/ipv6/ip6_tunnel.c
>>> @@ -1731,8 +1731,6 @@ static void __net_exit ip6_tnl_destroy_tunnels(struct ip
>>>                  }
>>>          }
>>>
>>> -       t = rtnl_dereference(ip6n->tnls_wc[0]);
>>> -       unregister_netdevice_queue(t->dev, &list);
>>>          unregister_netdevice_many(&list);
>>>   }
>>>
>>>
>>> Which, when applied to 3.10.18, fixes the bug. Was there a reason that
>>> this part of the commit wasn't backported? or was this just an oversight?
>>
>> It looks like it was left out to me as well.
>>
>> David, any objection to me making this fixup in the 3.10-stable tree?
>
> The original patch submitted told me to leave this part of the patch
> out of the backport, explaining that it wasn't necessary in older
> kernels.
Yes, and this was right (in upstream commit, I remove this part because
the fb device is deleted by the loop which check dev->rtnl_ops) , but ...

>
> Can someone please sort this out?
>
> Nicolas please provide some guidance here, thanks.
The original patch left a bug, which was fixed upstream with this commit:
1e9f3d6f1c40 ip6tnl: fix use after free of fb_tnl_dev

The problem is a bit different in 3.10.y, because there is no x-vrf support.
When ip6_tunnel.ko is unloaded, FB device is deleted by rtnl_link_unregister()
and then we try to delete it again in ip6_tnl_destroy_tunnels().
Thus the fix is different and in fact, the above patch is good.

Steven, will you submit this patch properly or should I do this?
