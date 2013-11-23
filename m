Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab3KWTiF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 14:38:05 -0500
Received: from mail-qe0-f50.google.com ([209.85.128.50]:60974 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab3KWTiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 14:38:02 -0500
Message-ID: <52910417.3080803@gmail.com>
Date: Sat, 23 Nov 2013 14:37:59 -0500
From: Vlad Yasevich <vyasevich@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Chang <changxiangzhong@gmail.com>, nhorman@tuxdriver.com,
        davem@davemloft.net
CC: linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sctp: set chunk->tsn_gap_acked at the end of cycle
References: <1385106589-402-1-git-send-email-changxiangzhong@gmail.com> <528F69B7.7020902@gmail.com> <528FAF50.10100@gmail.com> <528FDF52.4030500@gmail.com> <52908E04.40200@gmail.com>
In-Reply-To: <52908E04.40200@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2013 06:14 AM, Chang wrote:
> Hi,
> Could you please why a **reneged** newly acked TSN doesn't qualify the
> highest_new_tsn? What's the wrongs of doing that?
> 
> I've been thinking a few scenarios, but I couldn't figure out what's
> wrong with that.
> 

The spec is a bit conflicting on this topic.  Here is what it says

Section 7.2.4
   Miss indications SHOULD follow the HTNA (Highest TSN Newly
   Acknowledged) algorithm.  For each incoming SACK, miss indications
   are incremented only for missing TSNs prior to the highest TSN newly
   acknowledged in the SACK.  A newly acknowledged DATA chunk is one not
   previously acknowledged in a SACK.


But section 6.2.1 says:
      iii) If the SACK is missing a TSN that was previously acknowledged
           via a Gap Ack Block (e.g., the data receiver reneged on the
           data), then consider the corresponding DATA that might be
           possibly missing: Count one miss indication towards Fast
           Retransmit as described in Section 7.2.4, and if no
           retransmit timer is running for the destination address to
           which the DATA chunk was originally transmitted, then T3-rtx
           is started for that destination address.

So, the question becomes does the reneged tsn update HTNA counter?  It
has been acked by a previous SACK, but 6.2.1 says to treat as missing.

The more I look at this the more I think we should continue doing what
we are doing which is following section 6.2.1.

-vlad

