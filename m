Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101AbbAZWeI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 17:34:08 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:45621 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755466AbbAZWeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 17:34:06 -0500
Date: Mon, 26 Jan 2015 14:34:02 -0800 (PST)
Message-Id: <20150126.143402.1309886104452878553.davem@davemloft.net>
To: isubramanian@apm.com
Cc: eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        mlangsdo@redhat.com, patches@apm.com, kchudgar@apm.com
Subject: Re: [PATCH] drivers: net: xgene: fix: Out of order descriptor
 bytes read
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAKh23FmxvV82mVrHq5jv-FE+e6u6CkW+xL_a2_ULAQgP_mM2VA@mail.gmail.com>
References: <1421957007-720-1-git-send-email-isubramanian@apm.com>
	<1421967050.3471.14.camel@edumazet-glaptop2.roam.corp.google.com>
	<CAKh23FmxvV82mVrHq5jv-FE+e6u6CkW+xL_a2_ULAQgP_mM2VA@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 26 Jan 2015 14:34:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Iyappan Subramanian <isubramanian@apm.com>
Date: Mon, 26 Jan 2015 13:12:23 -0800

>>> @@ -369,6 +369,8 @@ static int xgene_enet_process_ring(struct xgene_enet_desc_ring *ring,
>>>               if (unlikely(xgene_enet_is_desc_slot_empty(raw_desc)))
>>>                       break;
>>>
>>> +             /* read fpqnum field after dataaddr field */
>>> +             smp_rmb();
>>>               if (is_rx_desc(raw_desc))
>>>                       ret = xgene_enet_rx_frame(ring, raw_desc);
>>>               else
>>
>> Reading your changelog, it looks like you need a plain rmb() here.
> 
> rmb() translates into dsb, which in arm64 serializes everything
> including instructions and thus expensive compared to dmb.
> 
> Do you see any issue with smp_rmb() (which translates into dmb) ?

smp_rmb() is not appropriate.  You're not serializing accesses between
two cpus, you're serializing the cpu with the device.
