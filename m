Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbaGTCwt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 22:52:49 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:62138 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbaGTCwr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 22:52:47 -0400
MIME-Version: 1.0
In-Reply-To: <48774298-8C91-42A9-A5F2-4EAB789F356B@gmail.com>
References: <1405655009-18975-1-git-send-email-ethan.zhao@oracle.com>
	<C562D0E12CBDE44E8A0CCAB77060096701283AD344@AVMB1.qlogic.org>
	<049BCC6F-0A2E-421A-9873-0B7ED6FFB3AC@gmail.com>
	<20140719101946.GA4319@electric-eye.fr.zoreil.com>
	<CABawtvP4+B_smOyi-=vt56KuUthzHF9L059PXP4ekXA7KPk_Dw@mail.gmail.com>
	<20140719162816.GB7590@electric-eye.fr.zoreil.com>
	<48774298-8C91-42A9-A5F2-4EAB789F356B@gmail.com>
Date: Sun, 20 Jul 2014 10:52:46 +0800
Message-ID: <CABawtvPUW1-svB0-BV8YjP4cZrDLvBoN7YnYaa0sVaVbAe8GLQ@mail.gmail.com>
Subject: Re: [PATCH V3] netxen: fix ethtool rx_dropped information in ethtool get_ethtool_stats()
From: Ethan Zhao <ethan.kernel@gmail.com>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Rajesh Borundia <rajesh.borundia@qlogic.com>,
        Ethan Zhao <ethan.zhao@oracle.com>,
        Manish Chopra <manish.chopra@qlogic.com>,
        Sony Chacko <sony.chacko@qlogic.com>, netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
   Regarding the r8169 chip, there is no other data fields exported to
user via ethtool
except for those dumped from hardware statistic counters in 8169 driver.

   But for Intel 82598 NIC and its driver ixgbe, it exports not only
those fields dumped from hardware statistic counters, like:

     {"rx_missed_errors", IXGB_NETDEV_STAT(stats.rx_missed_errors)},

    also some info like following, these stats are collected from net core.

    {"rx_packets", IXGB_NETDEV_STAT(stats.rx_packets)},
    {"tx_packets", IXGB_NETDEV_STAT(stats.tx_packets)},
    {"rx_bytes", IXGB_NETDEV_STAT(stats.rx_bytes)},
    {"tx_bytes", IXGB_NETDEV_STAT(stats.tx_bytes)},
    {"rx_errors", IXGB_NETDEV_STAT(stats.rx_errors)},
    {"tx_errors", IXGB_NETDEV_STAT(stats.tx_errors)},
    {"rx_dropped", IXGB_NETDEV_STAT(stats.rx_dropped)},
    {"tx_dropped", IXGB_NETDEV_STAT(stats.tx_dropped)},


   As to netxen and its hardware.  does it have hardware statistic
counter ?  I don't care, As I know follow fields exported via ethtool
should be collected from software(net core / driver ):

    {"xmit_called", NETXEN_NIC_STAT(stats.xmitcalled)},
{"xmit_finished", NETXEN_NIC_STAT(stats.xmitfinished)},
{"rx_dropped", NETXEN_NIC_STAT(stats.rxdropped)},
{"tx_dropped", NETXEN_NIC_STAT(stats.txdropped)},
{"csummed", NETXEN_NIC_STAT(stats.csummed)},

  So fix the rx_dropped field with my patch is the right way. the
patch is not intended to dump hardware statistic counters.


Thanks,
Ethan




On Sun, Jul 20, 2014 at 8:43 AM, Ethan Zhao <ethan.kernel@gmail.com> wrote:
>
>
>> 在 2014年7月20日，上午12:28，Francois Romieu <romieu@fr.zoreil.com> 写道：
>>
>> Ethan Zhao <ethan.kernel@gmail.com> :
>>>> On Sat, Jul 19, 2014 at 6:19 PM, Francois Romieu <romieu@fr.zoreil.com> wrote:
>>>> Ethan Zhao <ethan.kernel@gmail.com> :
>> [...]
>>>> I'd rather see ethtool stats provides one of those:
>>>> 1. hardware stats only
>>>  Sounds very clear, is it done clear, if so we need other tools ?
>>> Then why net core increase dev->dropped like
>>>
>>> atomic_long_inc(&skb->dev->rx_dropped);
>>>
>>> and mess some of the info to dev. just let ifconfig report it without detail ?
>>
>> (side note: ifconfig is a bit 90ish)
>>
>> Regarding the "without details" part, I don't expect ifconfig to tell users
>> that packets are dropped at net/core/dev.c:3279 because of empty softnet_data
>> queue in enqueue_to_backlog. More to the point below.
>>
>> [...]
>>>> 2. needs works. 1. hurts any requirement where it would priviously had
>>>> been so easy to add a few lines of code in the driver and push the mess
>>>> straight from kernel to the end user application.
>>>
>>>  Maybe some guys think that is enough to mess them together while not
>>> identify the information from net core or driver. that is better than
>>> lose info /no info.
>>
>> Probably.
>>
>>> My case is user could be confused when run 'ifconfig' and 'ethtool'
>>> to this netxen device. ifconfig reports packets dropped. but ethtool
>>> says zero. does that mean it is not issue of driver forever ?
>>
>> s/driver/hardware/
>>
>> Hardware correctly delivers packets if ethtool says zero [*]
>>
>> "correctly" must be understood in the context of said hardware abilities.
>>
>> [*] Of course we don't live in a world of unicorns and it's almost
>>    unavoidable to check drivers's code to figure which stats are _really_
>>    hardware only in ethtool output.
>>
>> A part of ethtool if close to bare metal abilities - including protocol
>> offloading related ones - whereas ifconfig provides a software oriented
>> vision of layer 2 operations.
>>
>> <digressio>
>> People at QLogic have not included *any* hardware counter in their
>> netxen ethtool stats code. Nada, keud. It's a bit deceptive for a gigabit
>> ethernet card and http://www.qlogic.com/Search/Pages/Search.aspx?k=NX2031
>> gives no hint.
>> </digressio>
>>
>> I won't claim it's intuitive. However:
>>
>> $ LANG=C man ifconfig
>> [...]
>> NOTE
>>       This  program  is obsolete!  For replacement check ip addr and ip link.
>>       For statistics use ip -s link.
>>
>> $ LANG=C man ip
>> [...]
>>     -f, -family <FAMILY>
>>              Specifies the protocol family to use. The protocol family iden-
>>              tifier can be one of inet, inet6, bridge, ipx, dnet or link.  If
>>              this option is not present, the protocol family is guessed from
>>              other arguments.  If the rest of the command line does not give
>>              enough information to guess the family, ip falls back to the
>>              default one, usually inet or any.  link is a special family
>>                                                 ^^^^^^^^^^^^^^^^^^^^^^^^
>>              identifier meaning that no networking protocol is involved.
>>              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>
>> (huh, "special"...)
>>
>> $ LANG=C man ethtool
>> [...]
>>      -S --statistics
>>              Queries the specified network device for NIC- and driver-specif-
>>              ic statistics.
>>
>> Some code stands between drivers and the upper part of the topmost
>> no-networking-procol layer, whence the differing stats: they are not
>> the same thing. Users can understand it.
>>
>>> who could tell where the packets are dropped, and for what ?
>>
>> One can't always answer beyond some coarse implementation level. There is
>> no such thing as a kernel MIB for the net core internal details.
>>
>> Would you disagree that some of those - rx_dropped locations for instance -
>> are better kept in the scope of debug and trace utilities ?
>>
> Of course I disagree it is the scope of debug and trace utilities. That is not fair or the original purpose the dropped info was collected into dev - >stat, it is dev specific
>
>
>>> So I would like the name of the data fields that ethtool output is be
>>> better defined. Instead of saying is not covered by ethtool.
>>
>> I respectfully disagree.
>>
>> ethtool and ip are two different tools.
>
> you leave us without a tool to track the net core part. Would you like to hack the kernel code and rebuild just for peek the dropping packets ?
>>
>> Regarding netxen driver, I do not want more ip / ifconfig stats in
>> ethtool code. It's quite the opposite: netxen ethtool code has no
>> business duplicating those and it should instead focus on real hardware
> You are ignoring the implementation fact of many drivers' ethtool part.  You should persuade the authors of those drivers to delete those unrelated part in their ethtool code,
> More radically, and maybe you should write patches to fix them to keep their focus. That is to prove you have principle and always fight for it.
>
>
>
> Thanks,
> Ethan
>> stats.
>>
>> --
>> Ueimor
