Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbaKCPbC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 10:31:02 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:59918 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbaKCPa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 10:30:59 -0500
Message-ID: <1415028656.14083.15.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] ipv4: avoid divide 0 error in tcp_incr_quickack
From: Eric Dumazet <eric.dumazet@gmail.com>
To: chenweilong <chenweilong@huawei.com>, Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>
Cc: davem@davemloft.net, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 03 Nov 2014 07:30:56 -0800
In-Reply-To: <54571335.2060709@huawei.com>
References: <1414978173-6948-1-git-send-email-chenweilong@huawei.com>
	 <1414986126.31792.43.camel@edumazet-glaptop2.roam.corp.google.com>
	 <54571335.2060709@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-03 at 13:31 +0800, chenweilong wrote:

> Hi Eric,
> 
> I check the code and find that:
> 
> 1.In function "tcp_rcv_state_process",
> the "tcp_initialize_rcv_mss" is called at "step 5: check the ACK field" when the sk->sk_state is TCP_SYN_RECV
> and there is a "tcp_validate_incoming" just before it.
> So when we call "tcp_validate_incoming", the rcv_mss may not been initialized.
> 
> 2.In function "tcp_validate_incoming",
> the "Step 1: check sequence number", according to RFC793 page 69,
> If an incoming segment is not acceptable,an acknowledgment should be sent in reply (unless the RST
> bit is set, if so drop the segment and return).
> So we may call "tcp_send_dupack" while the rcv_mss hasn't been initialized.
> 
> 3.In function "tcp_send_dupack",
> when the condition is suitable, it'll enter quick ack mode. Notice it only check the seq !
> So I think add another state check should be OK.
> 
> Any suggestion ?
> 

You did find what immediate conditions for the crash (rcv_mss = 0, state
= TCP_SYN_RCV) were.

Your patch avoids the zero divide, but leaves other issues. rcv_mss = 0
here is a sign some logic is wrong in the stack.

Given this potential zero divide had been there for years, I believe we
should take the time for a more complete fix, instead of papering over
the immediate problem.

We have been working with Neal to reproduce the issue with packetdrill,
we'll post our results when we manage to get our first crash ;)

Thanks !


