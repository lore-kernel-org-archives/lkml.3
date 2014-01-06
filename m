Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbaAFPGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:06:54 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:36110 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167AbaAFPGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:06:52 -0500
Message-ID: <52CAC671.4040208@gmail.com>
Date: Mon, 06 Jan 2014 07:06:25 -0800
From: John Fastabend <john.fastabend@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>
CC: Jason Wang <jasowang@redhat.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com,
        John Fastabend <john.r.fastabend@intel.com>,
        e1000-devel@lists.sourceforge.net
Subject: Re: [PATCH net 2/2] net: core: explicitly select a txq before doing
 l2 forwarding
References: <1388978467-2075-1-git-send-email-jasowang@redhat.com> <1388978467-2075-2-git-send-email-jasowang@redhat.com> <20140106124248.GB24280@hmsreliant.think-freely.org>
In-Reply-To: <20140106124248.GB24280@hmsreliant.think-freely.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2014 04:42 AM, Neil Horman wrote:
> On Mon, Jan 06, 2014 at 11:21:07AM +0800, Jason Wang wrote:
>> Currently, the tx queue were selected implicitly in ndo_dfwd_start_xmit(). The
>> will cause several issues:
>>
>> - NETIF_F_LLTX was forced for macvlan device in this case which lead extra lock
>>    contention.
>> - dev_hard_start_xmit() was called with NULL txq which bypasses the net device
>>    watchdog
>> - dev_hard_start_xmit() does not check txq everywhere which will lead a crash
>>    when tso is disabled for lower device.
>>
>> Fix this by explicitly introducing a select queue method just for l2 forwarding
>> offload (ndo_dfwd_select_queue), and introducing dfwd_direct_xmit() to do the
>> queue selecting and transmitting for l2 forwarding.
>>
>> With this fixes, NETIF_F_LLTX could be preserved for macvlan and there's no need
>> to check txq against NULL in dev_hard_start_xmit().
>>
>> In the future, it was also required for macvtap l2 forwarding support since it
>> provides a necessary synchronization method.
>>
>> Cc: John Fastabend <john.r.fastabend@intel.com>
>> Cc: Neil Horman <nhorman@tuxdriver.com>
>> Cc: e1000-devel@lists.sourceforge.net
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>
> Instead of creating another operation here to do special queue selection, why
> not just have ndo_dfwd_start_xmit include a pointer to a pointer in its argument
> list, so it can pass the txq it used back to the caller (dev_hard_start_xmit)?
> ndo_dfwd_start_xmit already knows which queue set to pick from (since their
> reserved for the device doing the transmitting).  It seems more clear to me than
> creating a new netdevice operation.
>
> As for the crash issue, I'm not sure what you mean.  Where in
> dev_hard_start_xmit would we need to check txq that we're not currently, and
> what crash results?
>
> Also, can you elaborate on what you mean by additional lock contention?  What
> contention do you see that goes above and beyond the normal locking required by
> txq access?  I suppose its extra locking above and beyond in the macvtap case,
> where you would otherwise never hit hardware, but that not the only use case,
> and I think the solution there is likely to add some code in the macvlan feature
> set handler so that NETIF_F_LLTX is cleared if you disable the hardware
> forwarding acceleration via ethtool.
>

NETIF_F_LLTX is cleared in macvlan_open() which should be used in the
macvtap case.

           if (lowerdev->features & NETIF_F_HW_L2FW_DOFFLOAD) {
                   vlan->fwd_priv =
 
lowerdev->netdev_ops->ndo_dfwd_add_station(lowerdev, dev);

                   /* If we get a NULL pointer back, or if we get an error
                    * then we should just fall through to the non 
accelerated path
                    */
                   if (IS_ERR_OR_NULL(vlan->fwd_priv)) {
                           vlan->fwd_priv = NULL;
                   } else {
                           dev->features &= ~NETIF_F_LLTX;
                           return 0;
                   }
           }

Thanks,
John


-- 
John Fastabend         Intel Corporation
