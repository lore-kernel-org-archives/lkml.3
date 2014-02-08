Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435AbaBHAXH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 19:23:07 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:50755 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaBHAXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 19:23:05 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Miller <davem@davemloft.net>
Cc: eric.dumazet@gmail.com, netdev@vger.kernel.org, rientjes@google.com,
        linux-kernel@vger.kernel.org
References: <1391712162.10160.8.camel@edumazet-glaptop2.roam.corp.google.com>
	<20140206.222932.292588043950970246.davem@davemloft.net>
Date: Fri, 07 Feb 2014 16:22:56 -0800
In-Reply-To: <20140206.222932.292588043950970246.davem@davemloft.net> (David
	Miller's message of "Thu, 06 Feb 2014 22:29:32 -0800 (PST)")
Message-ID: <87y51me9lr.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+yEZ4SmBaPT3CvrLr8IDIe1SkulmR8M2E=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4789]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;David Miller <davem@davemloft.net>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] net: use __GFP_NORETRY for high order allocations
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Thu, 06 Feb 2014 10:42:42 -0800
>
>> From: Eric Dumazet <edumazet@google.com>
>> 
>> sock_alloc_send_pskb() & sk_page_frag_refill()
>> have a loop trying high order allocations to prepare
>> skb with low number of fragments as this increases performance.
>> 
>> Problem is that under memory pressure/fragmentation, this can
>> trigger OOM while the intent was only to try the high order
>> allocations, then fallback to order-0 allocations.
>> 
>> We had various reports from unexpected regressions.
>> 
>> According to David, setting __GFP_NORETRY should be fine,
>> as the asynchronous compaction is still enabled, and this
>> will prevent OOM from kicking as in :
>  ...
>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>> Acked-by: David Rientjes <rientjes@google.com>
>
> Applied, do we want this for -stable?

The first hunk goes back to 3.12 and the second hunk goes back to 3.8.

I think so.    The change is safe and this class of problem can cause an
external attack to trigger an OOM on your box, by controlling the packet
flow.

Eric
