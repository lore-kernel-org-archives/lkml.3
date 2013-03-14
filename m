Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab3CNSvc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 14:51:32 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:4140 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149Ab3CNSvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 14:51:31 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <51421896.6020607@broadcom.com>
Date: Thu, 14 Mar 2013 19:36:06 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221
 Thunderbird/17.0.3
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>
cc: "Eric Dumazet" <edumazet@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, brcm80211-dev-list@broadcom.com
Subject: need info: softirq warning upon free skb
X-WSS-ID: 7D5CC5053YC1950189-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Sorry to bother. Today during testing I ran into two warnings, which 
given their occurrence are fired in the same code path:
kernel/softirq.c:99:__local_bh_disable():
	WARN_ON_ONCE(in_irq());
kernel/softirq.c:160:_local_bh_enable_ip():
	WARN_ON_ONCE(in_irq() || irqs_disabled());

I have not seen those warning before, but consider them serious enough 
to look into it (although no crashing system yet). They popped up in our 
driver while freeing an skb. For this we use a utility function in our 
driver (brcm80211 wireless) as listed below. It provided a little code 
shortcut by skipping dev_kfree_skb_any(). However, circumstances seem to 
have changed for some reason. The warning occurs in 
nf_conntrack_destroy() path. Before digging deeper I decided the answer 
might be known out there. Should the comment statements in the code 
snippet below still be valid? I am more than happy to get rid of the 
function entirely if it does not make sense.

Regards,
Arend

-8<---------------------------------------------------------------
void brcmu_pkt_buf_free_skb(struct sk_buff *skb)
{
	if (!skb)
		return;
	WARN_ON(skb->next);
	if (skb->destructor)
		/* cannot kfree_skb() on hard IRQ (net/core/skbuff.c) if
		 * destructor exists
		 */
		dev_kfree_skb_any(skb);
	else
		/* can free immediately (even in_irq()) if destructor
		 * does not exist
		 */
		dev_kfree_skb(skb);
}

