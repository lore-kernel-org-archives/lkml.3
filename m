Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265Ab3JOOwb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 10:52:31 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:38546 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696Ab3JOOwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 10:52:30 -0400
Message-ID: <1381848748.2045.50.camel@edumazet-glaptop.roam.corp.google.com>
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
From: Eric Dumazet <eric.dumazet@gmail.com>
To: =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
Cc: Andi Kleen <andi@firstfloor.org>, Neil Horman <nhorman@tuxdriver.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Date: Tue, 15 Oct 2013 07:52:28 -0700
In-Reply-To: <1381847168.2045.45.camel@edumazet-glaptop.roam.corp.google.com>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
	 <87siw4xy9i.fsf@tassilo.jf.intel.com>
	 <20131014202528.GG26880@hmsreliant.think-freely.org>
	 <20131015091251.2345b918@b012350-ux>
	 <20131015133336.GF2592@two.firstfloor.org>
	 <20131015155615.738f03d5@b012350-ux>
	 <1381845985.2045.40.camel@edumazet-glaptop.roam.corp.google.com>
	 <20131015161528.08c19e92@b012350-ux>
	 <1381847168.2045.45.camel@edumazet-glaptop.roam.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-15 at 07:26 -0700, Eric Dumazet wrote:

> And the receiver should also do the same : (ethtool -K eth0 rx off)
> 
>     10.55%    netserver  [kernel.kallsyms]  [k]
> csum_partial_copy_generic            

I get the csum_partial() if disabling prequeue.

echo 1 >/proc/sys/net/ipv4/tcp_low_latency

    24.49%      swapper  [kernel.kallsyms]  [k]
csum_partial                        
                |
                --- csum_partial
                    skb_checksum
                    __skb_checksum_complete_head
                    __skb_checksum_complete
                    tcp_rcv_established
                    tcp_v4_do_rcv
                    tcp_v4_rcv
                    ip_local_deliver_finish
                    ip_local_deliver
                    ip_rcv_finish
                    ip_rcv

So yes, we can call csum_partial() in receive path in this case.



