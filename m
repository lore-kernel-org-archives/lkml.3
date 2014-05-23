Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbaEWQA4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 12:00:56 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:41997 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbaEWQAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 12:00:53 -0400
Message-ID: <1400860851.5367.210.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: skbuff truesize incorrect.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Rick Jones <rick.jones2@hp.com>
Cc: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Jim Baxter <jim_baxter@mentor.com>, David Miller <davem@davemloft.net>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kamal@canonical.com, edumazet@google.com,
        mszeredi@suse.cz, fw@strlen.de
Date: Fri, 23 May 2014 09:00:51 -0700
In-Reply-To: <537F6CC1.2000503@hp.com>
References: <537E4AFD.20304@mentor.com>
	 <1400792295.5367.174.camel@edumazet-glaptop2.roam.corp.google.com>
	 <1400792601.5367.176.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20140522.171033.1040508444998374401.davem@davemloft.net>
	 <87ppj5vupf.fsf@nemi.mork.no> <537F0DCA.6030901@mentor.com>
	 <87vbsw4z5x.fsf@nemi.mork.no> <537F6CC1.2000503@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-23 at 08:44 -0700, Rick Jones wrote:

> If you are measuring performance with the likes of netperf, you should 
> be able to get an idea of the performance effect from the change in 
> service demand (CPU consumed per unit of work) even if the maximum 
> throughput remains capped.

This wont be enough to truly get an idea of the gains this patch brings.

Add some random drops in the equation, and instead of dropping packets,
we gently add them in the out of order queue, gently coalesce them,
gently allow SACK enabled flows to recover thanks to fast retransmits,
with no latency effect (No expensive collapse/prunes)

# nstat -az|egrep "TCPRcvCoalesce|TCPOFOQueue|TCPRcvCollapsed|Prune"
TcpExtPruneCalled               118                0.0
TcpExtRcvPruned                 0                  0.0
TcpExtOfoPruned                 0                  0.0
TcpExtTCPRcvCollapsed           1009               0.0
TcpExtTCPRcvCoalesce            857806             0.0
TcpExtTCPOFOQueue               201246             0.0

Yep, we _might_ consume some cpu cycles in the perfect case where no
packet was dropped, but this is kind of an utopia.



