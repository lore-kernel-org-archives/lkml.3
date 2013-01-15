Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab3AOKzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 05:55:21 -0500
Received: from mail.yrkesakademin.fi ([85.134.44.20]:23157 "EHLO
	mail.yrkesakademin.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab3AOKzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 05:55:20 -0500
Message-ID: <50F53596.4070200@mageia.org>
Date: Tue, 15 Jan 2013 12:55:18 +0200
From: Thomas Backlund <tmb@mageia.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Cong Wang <amwang@redhat.com>
CC: Thomas Backlund <tmb@mageia.org>, Eric Blake <eblake@redhat.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        libvirt-list@redhat.com, tgraf@suug.ch
Subject: Re: the patch "bridge: export multicast database via netlink" broke
 kernel 3.8 uapi
References: <50F2FF1B.3020708@mageia.org> <50F313A5.3020707@mageia.org>  <50F49B7E.50906@redhat.com> <50F52956.50201@mageia.org> <1358244688.4264.7.camel@cr0>
In-Reply-To: <1358244688.4264.7.camel@cr0>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cong Wang skrev 15.1.2013 12:11:
> On Tue, 2013-01-15 at 12:03 +0200, Thomas Backlund wrote:
>> Eric Blake skrev 15.1.2013 01:57:
>>> On 01/13/2013 01:05 PM, Thomas Backlund wrote:
>>>> Thomas Backlund skrev 13.1.2013 20:38:
>>>>> patch both inline and attached as thunderbird tends to mess up ...
>>>>
>>>>> -----
>>>>>
>>>>> if_bridge.h uses struct in6_addr ip6; but does not include the in6.h
>>>>> header.
>>>>>
>>>>> Found by trying to build libvirt and connman against 3.8-rc3 headers.
>>>>>
>>>>
>>>> Ok,
>>>> ignore this patch, it's not the correct fix as it introduces
>>>> redefinitions...
>>>>
>>>> Btw, the error that I hit that made me suggest this fix was libvirt
>>>> config check bailing out:
>>>>
>>>> config.log:/usr/include/linux/if_bridge.h:173:20: error: field 'ip6' has
>>>> incomplete type
>>>
>>> Hmm, just now noticing this thread, after independently hitting and and
>>> having to work around the same problem in libvirt:
>>> https://www.redhat.com/archives/libvir-list/2013-January/msg00930.html
>>> https://bugzilla.redhat.com/show_bug.cgi?id=895141
>>
>>
>> Yep,
>>
>> and the commit breaking uapi headers is by using "struct in6_addr ip6" is:
>>
>>
>>   From ee07c6e7a6f8a25c18f0a6b18152fbd7499245f6 Mon Sep 17 00:00:00 2001
>> From: Cong Wang <amwang@redhat.com>
>> Date: Fri, 7 Dec 2012 00:04:48 +0000
>> Subject: [PATCH] bridge: export multicast database via netlink
>
> Does the following patch help?
>
> $ git diff include/uapi/linux/if_bridge.h
> diff --git a/include/uapi/linux/if_bridge.h
> b/include/uapi/linux/if_bridge.h
> index 5db2975..653db23 100644
> --- a/include/uapi/linux/if_bridge.h
> +++ b/include/uapi/linux/if_bridge.h
> @@ -14,6 +14,7 @@
>   #define _UAPI_LINUX_IF_BRIDGE_H
>
>   #include <linux/types.h>
> +#include <linux/in6.h>
>
>   #define SYSFS_BRIDGE_ATTR      "bridge"
>   #define SYSFS_BRIDGE_FDB       "brforward"
>

Well, I suggested the same fix in the beginning of the thread
on netdev and lkml: "if_bridge.h: include in6.h for struct in6_addr use"

as it seemed to fix the libvirt case

but then asked it to be ignored after I tried to build connman,
and hit this conflict with glibc-2.17:

In file included from /usr/include/arpa/inet.h:22:0,
                  from ./include/connman/inet.h:25,
                  from src/connman.h:128,
                  from src/tethering.c:40:
/usr/include/netinet/in.h:35:5: error: expected identifier before 
numeric constant
/usr/include/netinet/in.h:197:8: error: redefinition of 'struct in6_addr'
In file included from /usr/include/linux/if_bridge.h:17:0,
                  from src/tethering.c:38:
/usr/include/linux/in6.h:30:8: note: originally defined here
In file included from /usr/include/arpa/inet.h:22:0,
                  from ./include/connman/inet.h:25,
                  from src/connman.h:128,
                  from src/tethering.c:40:
/usr/include/netinet/in.h:238:8: error: redefinition of 'struct 
sockaddr_in6'
In file included from /usr/include/linux/if_bridge.h:17:0,
                  from src/tethering.c:38:
/usr/include/linux/in6.h:46:8: note: originally defined here
In file included from /usr/include/arpa/inet.h:22:0,
                  from ./include/connman/inet.h:25,
                  from src/connman.h:128,
                  from src/tethering.c:40:
/usr/include/netinet/in.h:274:8: error: redefinition of 'struct ipv6_mreq'
In file included from /usr/include/linux/if_bridge.h:17:0,
                  from src/tethering.c:38:
/usr/include/linux/in6.h:54:8: note: originally defined here
make[1]: *** [src/src_connmand-tethering.o] Error 1


So I'm not sure it's the right one...


--
Thomas

