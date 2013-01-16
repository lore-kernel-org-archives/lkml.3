Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab3APOVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 09:21:24 -0500
Received: from 94.43.138.210.xn.2iij.net ([210.138.43.94]:42663 "EHLO
	mail.st-paulia.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750963Ab3APOVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 09:21:23 -0500
Message-ID: <50F6B761.8070106@linux-ipv6.org>
Date: Wed, 16 Jan 2013 23:21:21 +0900
From: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Organization: USAGI Project
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Cong Wang <amwang@redhat.com>
CC: Thomas Backlund <tmb@mageia.org>, Eric Blake <eblake@redhat.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        libvirt-list@redhat.com, tgraf@suug.ch,
        David Miller <davem@davemloft.net>, libc-alpha@sourceware.org,
        schwab@suse.de, carlos@systemhalted.org,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Subject: Re: Redefinition of struct in6_addr in <netinet/in.h> and <linux/in6.h>
References: <50F2FF1B.3020708@mageia.org> <50F313A5.3020707@mageia.org>   <50F49B7E.50906@redhat.com> <50F52956.50201@mageia.org>  <1358244688.4264.7.camel@cr0> <50F53596.4070200@mageia.org> <1358316366.14898.8.camel@cr0>
In-Reply-To: <1358316366.14898.8.camel@cr0>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cong Wang wrote:
> (Cc'ing some glibc developers...)
> 
> Hello,
> 
> In glibc source file inet/netinet/in.h and kernel source file
> include/uapi/linux/in6.h, both define struct in6_addr, and both are
> visible to user applications. Thomas reported a conflict below.
> 
> So, how can we handle this? /me is wondering why we didn't see this
> before.
> 
> Thanks.
> 
> On Tue, 2013-01-15 at 12:55 +0200, Thomas Backlund wrote:
>> Cong Wang skrev 15.1.2013 12:11:
>>>
>>> Does the following patch help?
>>>
>>> $ git diff include/uapi/linux/if_bridge.h
>>> diff --git a/include/uapi/linux/if_bridge.h
>>> b/include/uapi/linux/if_bridge.h
>>> index 5db2975..653db23 100644
>>> --- a/include/uapi/linux/if_bridge.h
>>> +++ b/include/uapi/linux/if_bridge.h
>>> @@ -14,6 +14,7 @@
>>>   #define _UAPI_LINUX_IF_BRIDGE_H
>>>
>>>   #include <linux/types.h>
>>> +#include <linux/in6.h>
>>>
>>>   #define SYSFS_BRIDGE_ATTR      "bridge"
>>>   #define SYSFS_BRIDGE_FDB       "brforward"
>>>
>>
>> Well, I suggested the same fix in the beginning of the thread
>> on netdev and lkml: "if_bridge.h: include in6.h for struct in6_addr use"
>>
>> as it seemed to fix the libvirt case
>>
>> but then asked it to be ignored after I tried to build connman,
>> and hit this conflict with glibc-2.17:
>>
>> In file included from /usr/include/arpa/inet.h:22:0,
>>                   from ./include/connman/inet.h:25,
>>                   from src/connman.h:128,
>>                   from src/tethering.c:40:
>> /usr/include/netinet/in.h:35:5: error: expected identifier before 
>> numeric constant
>> /usr/include/netinet/in.h:197:8: error: redefinition of 'struct in6_addr'
>> In file included from /usr/include/linux/if_bridge.h:17:0,
>>                   from src/tethering.c:38:
>> /usr/include/linux/in6.h:30:8: note: originally defined here
>> In file included from /usr/include/arpa/inet.h:22:0,
>>                   from ./include/connman/inet.h:25,
>>                   from src/connman.h:128,
>>                   from src/tethering.c:40:
>> /usr/include/netinet/in.h:238:8: error: redefinition of 'struct 
>> sockaddr_in6'
>> In file included from /usr/include/linux/if_bridge.h:17:0,
>>                   from src/tethering.c:38:
>> /usr/include/linux/in6.h:46:8: note: originally defined here
>> In file included from /usr/include/arpa/inet.h:22:0,
>>                   from ./include/connman/inet.h:25,
>>                   from src/connman.h:128,
>>                   from src/tethering.c:40:
>> /usr/include/netinet/in.h:274:8: error: redefinition of 'struct ipv6_mreq'
>> In file included from /usr/include/linux/if_bridge.h:17:0,
>>                   from src/tethering.c:38:
>> /usr/include/linux/in6.h:54:8: note: originally defined here
>> make[1]: *** [src/src_connmand-tethering.o] Error 1
>>
>>
>> So I'm not sure it's the right one...

This is not a new issue.  In addition to this,
netinet/in.h also conflits with linux/in.h.

We might have
 #if !defined(__GLIBC__) || !defined(_NETINET_IN_H)
 :
 #endif
around those conflicting definitions in uapi/linux/in{,6}.h.

--yoshfuji
