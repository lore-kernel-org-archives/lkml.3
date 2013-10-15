Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759286Ab3JOO0L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 10:26:11 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:38192 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758901Ab3JOO0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 10:26:09 -0400
Message-ID: <1381847168.2045.45.camel@edumazet-glaptop.roam.corp.google.com>
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
From: Eric Dumazet <eric.dumazet@gmail.com>
To: =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
Cc: Andi Kleen <andi@firstfloor.org>, Neil Horman <nhorman@tuxdriver.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Date: Tue, 15 Oct 2013 07:26:08 -0700
In-Reply-To: <20131015161528.08c19e92@b012350-ux>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
	 <87siw4xy9i.fsf@tassilo.jf.intel.com>
	 <20131014202528.GG26880@hmsreliant.think-freely.org>
	 <20131015091251.2345b918@b012350-ux>
	 <20131015133336.GF2592@two.firstfloor.org>
	 <20131015155615.738f03d5@b012350-ux>
	 <1381845985.2045.40.camel@edumazet-glaptop.roam.corp.google.com>
	 <20131015161528.08c19e92@b012350-ux>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-15 at 16:15 +0200, Sébastien Dugué wrote:
> Hi Eric,
> 
> On Tue, 15 Oct 2013 07:06:25 -0700
> Eric Dumazet <eric.dumazet@gmail.com> wrote:

> > But the csum cost is both for sender and receiver ?
> 
>   No, it was only on the receiver side that I noticed it.
> 

Yes, as Andi said, we do the csum while copying the data for the
sender : (I disabled hardware assist tx checksum using 'ethtool -K eth0
tx off')

    17.21%  netperf  [kernel.kallsyms]       [k]
csum_partial_copy_generic                 
            |
            --- csum_partial_copy_generic
               |          
               |--97.39%-- __libc_send
               |          
                --2.61%-- tcp_sendmsg
                          inet_sendmsg
                          sock_sendmsg
                          _sys_sendto
                          sys_sendto
                          system_call_fastpath
                          __libc_send



>   Sorry, but this is 3 years old stuff and I do not have the
> setup anymore to reproduce.

And the receiver should also do the same : (ethtool -K eth0 rx off)

    10.55%    netserver  [kernel.kallsyms]  [k]
csum_partial_copy_generic            
              |
              --- csum_partial_copy_generic
                 |          
                 |--98.24%-- __libc_recv
                 |          
                  --1.76%-- skb_copy_and_csum_datagram
                            skb_copy_and_csum_datagram_iovec
                            tcp_rcv_established
                            tcp_v4_do_rcv
                            |          
                            |--73.05%-- tcp_prequeue_process
                            |          tcp_recvmsg
                            |          inet_recvmsg
                            |          sock_recvmsg
                            |          SYSC_recvfrom
                            |          SyS_recvfrom
                            |          system_call_fastpath
                            |          __libc_recv
                            |          

So I suspect something is wrong with IPoIB.




