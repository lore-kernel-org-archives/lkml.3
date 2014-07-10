Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbaGJUAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 16:00:46 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:64585 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbaGJUAo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 16:00:44 -0400
MIME-Version: 1.0
X-Originating-IP: [84.208.72.173]
In-Reply-To: <53BEB6F9.7030004@6wind.com>
References: <1404980258-30853-1-git-send-email-teg@jklm.no>
 <1404980258-30853-2-git-send-email-teg@jklm.no> <53BEB6F9.7030004@6wind.com>
From: Tom Gundersen <teg@jklm.no>
Date: Thu, 10 Jul 2014 22:00:23 +0200
Message-ID: <CAG-2HqURYBPwFXYZehOFz5XBiUAeCKhZNQduNoPVJrh=vLTZJQ@mail.gmail.com>
Subject: Re: [PATCH v7 01/33] net: add name_assign_type netdev attribute
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        David Herrmann <dh.herrmann@gmail.com>, Kay Sievers <kay@vrfy.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 5:53 PM, Nicolas Dichtel
<nicolas.dichtel@6wind.com> wrote:
> Le 10/07/2014 10:17, Tom Gundersen a écrit :
>
>> Based on a patch by David Herrmann.
>>
>> The name_assign_type attribute gives hints where the interface name of a
>> given net-device comes from. These values are currently defined:
>>    NET_NAME_ENUM:
>>      The ifname is provided by the kernel with an enumerated
>>      suffix, typically based on order of discovery. Names may
>>      be reused and unpredictable.
>>    NET_NAME_PREDICTABLE:
>>      The ifname has been assigned by the kernel in a predictable way
>>      that is guaranteed to avoid reuse and always be the same for a
>>      given device. Examples include statically created devices like
>>      the loopback device and names deduced from hardware properties
>>      (including being given explicitly by the firmware). Names
>>      depending on the order of discovery, or in any other way on the
>>      existence of other devices, must not be marked as PREDICTABLE.
>>    NET_NAME_USER:
>>      The ifname was provided by user-space during net-device setup.
>>    NET_NAME_RENAMED:
>>      The net-device has been renamed from userspace. Once this type is
>> set,
>>      it cannot change again.
>>    NET_NAME_UNKNOWN:
>>      This is an internal placeholder to indicate that we yet haven't yet
>>      categorized the name. It will not be exposed to userspace, rather
>>      -EINVAL is returned.
>>
>> The aim of these patches is to improve user-space renaming of interfaces.
>> As
>> a general rule, userspace must rename interfaces to guarantee that names
>> stay
>> the same every time a given piece of hardware appears (at boot, or when
>> attaching it). However, there are several situations where userspace
>> should
>> not perform the renaming, and that depends on both the policy of the local
>> admin, but crucially also on the nature of the current interface name.
>>
>> If an interface was created in repsonse to a userspace request, and
>> userspace
>> already provided a name, we most probably want to leave that name alone.
>> The
>> main instance of this is wifi-P2P devices created over nl80211, which
>> currently
>> have a long-standing bug where they are getting renamed by udev. We label
>> such
>> names NET_NAME_USER.
>>
>> If an interface, unbeknown to us, has already been renamed from userspace,
>> we
>> most probably want to leave also that alone. This will typically happen
>> when
>> third-party plugins (for instance to udev, but the interface is generic so
>> could
>> be from anywhere) renames the interface without informing udev about it. A
>> typical situation is when you switch root from an installer or an initrd
>> to the
>> real system and the new instance of udev does not know what happened
>> before
>> the switch. These types of problems have caused repeated issues in the
>> past. To
>> solve this, once an interface has been renamed, its name is labelled
>> NET_NAME_RENAMED.
>>
>> In many cases, the kernel is actually able to name interfaces in such a
>> way that there is no need for userspace to rename them. This is the case
>> when
>> the enumeration order of devices, or in fact any other (non-parent) device
>> on
>> the system, can not influence the name of the interface. Examples include
>> statically created devices, or any naming schemes based on hardware
>> properties
>> of the interface. In this case the admin may prefer to use the
>> kernel-provided
>> names, and to make that possible we label such names NET_NAME_PREDICTABLE.
>> We want the kernel to have tho possibilty of performing predictable
>> interface
>> naming itself (and exposing to userspace that it has), as the information
>> necessary for a proper naming scheme for a certain class of devices may
>> not
>> be exposed to userspace.
>>
>> The case where renaming is almost certainly desired, is when the kernel
>> has
>> given the interface a name using global device enumeration based on order
>> of
>> discovery (ethX, wlanY, etc). These naming schemes are labelled
>> NET_NAME_ENUM.
>>
>> Lastly, a fallback is left as NET_NAME_UNKNOWN, to indicate that a driver
>> has
>> not yet been ported. This is mostly useful as a transitionary measure,
>> allowing
>> us to label the various naming schemes bit by bit.
>>
>> Signed-off-by: Tom Gundersen <teg@jklm.no>
>> Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
>> Reviewed-by: Kay Sievers <kay@vrfy.org>
>> ---
>>   Documentation/ABI/testing/sysfs-class-net | 11 +++++++++++
>>   include/linux/netdevice.h                 |  2 ++
>>   include/uapi/linux/netdevice.h            |  6 ++++++
>>   net/core/net-sysfs.c                      | 20 ++++++++++++++++++++
>>   4 files changed, 39 insertions(+)
>>
>> diff --git a/Documentation/ABI/testing/sysfs-class-net
>> b/Documentation/ABI/testing/sysfs-class-net
>> index 416c5d5..d34280a 100644
>> --- a/Documentation/ABI/testing/sysfs-class-net
>> +++ b/Documentation/ABI/testing/sysfs-class-net
>> @@ -1,3 +1,14 @@
>> +What:          /sys/class/net/<iface>/name_assign_type
>> +Date:          July 2014
>> +KernelVersion: 3.2
>> +Contact:       netdev@vger.kernel.org
>> +Description:
>> +               Indicates the name assignment type. Possible values are:
>> +               1: enumerated by the kernel, possibly in an unpredictable
>> way
>> +               2: predictably named by the kernel
>> +               3: named by userspace
>> +               4: renamed
>> +
>>   What:         /sys/class/net/<iface>/addr_assign_type
>>   Date:         July 2010
>>   KernelVersion:        3.2
>> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>> index 66f9a04..551e187 100644
>> --- a/include/linux/netdevice.h
>> +++ b/include/linux/netdevice.h
>> @@ -1379,6 +1379,8 @@ struct net_device {
>>         struct kset             *queues_kset;
>>   #endif
>>
>> +       unsigned char           name_assign_type;
>> +
>>         bool                    uc_promisc;
>>         unsigned int            promiscuity;
>>         unsigned int            allmulti;
>> diff --git a/include/uapi/linux/netdevice.h
>> b/include/uapi/linux/netdevice.h
>> index fdfbd1c..82e630a 100644
>> --- a/include/uapi/linux/netdevice.h
>> +++ b/include/uapi/linux/netdevice.h
>> @@ -37,6 +37,12 @@
>>   #define INIT_NETDEV_GROUP     0
>>
>>
>> +/* interface name assignment types (sysfs name_assign_type attribute) */
>> +#define NET_NAME_UNKNOWN       0       /* unknown origin (not exposed to
>> userspace) */
>> +#define NET_NAME_ENUM          1       /* enumerated by kernel */
>> +#define NET_NAME_PREDICTABLE   2       /* predictably named by the kernel
>> */
>
> Nitpicking: there is spaces instead tabs between '2' and the comment.

Indeed. Fixed.

Thanks.

Tom
