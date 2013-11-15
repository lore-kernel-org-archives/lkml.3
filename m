Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315Ab3KOCfH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 21:35:07 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:35457 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab3KOCe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 21:34:59 -0500
Message-ID: <5285884F.8030907@gmail.com>
Date: Thu, 14 Nov 2013 21:34:55 -0500
From: Vlad Yasevich <vyasevich@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Chang Xiangzhong <changxiangzhong@gmail.com>, nhorman@tuxdriver.com
CC: davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dreibh@simula.no, ernstgr@simula.no
Subject: Re: [PATCH] net: sctp: recover a tranport when an ack comes
References: <1384461624-17636-1-git-send-email-changxiangzhong@gmail.com>
In-Reply-To: <1384461624-17636-1-git-send-email-changxiangzhong@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2013 03:40 PM, Chang Xiangzhong wrote:
> Expected Behavior:
> When hearing an ack from a tranport/path, set its state to normal/on if it's
> in abnormal(__partial_failure__ or inactive) state.
>
> state machine of tranport->state
> Whenever a T3_RTX timer expires, then transport->error_count++.
> When (association->pf_retrans < transport->error_count < tranport->pathmaxrtx)
> 	transport->state = SCTP_PF //partial failure
>
> When a heartbeat-ack comes or conventional ack acknowledged its availability,
> 	transport->state = SCTP_ON
>
> Signed-off-by: Chang Xiangzhong <changxiangzhong@gmail.com>
> Fixes: 5aa93bcf66f ("sctp: Implement quick failover draft from tsvwg")

I don't think this is right.  The spec states:
  8.  ACKs for retransmissions do not transition a PF destination back
        to Active state, since a sender cannot disambiguate whether the
        ack was for the original transmission or the retransmission(s).


Now, the proper way to this would would be modify 
sctp_assoc_control_transport() to transition the transport state to
ACTIVE if it was PF transport that was chosen to send data.

-vlad

> ---
>   net/sctp/outqueue.c |    1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
> index 94df758..2557fa5 100644
> --- a/net/sctp/outqueue.c
> +++ b/net/sctp/outqueue.c
> @@ -1517,6 +1517,7 @@ static void sctp_check_transmitted(struct sctp_outq *q,
>   			 * active if it is not so marked.
>   			 */
>   			if ((transport->state == SCTP_INACTIVE ||
> +			     transport->state == SCTP_PF ||
>   			     transport->state == SCTP_UNCONFIRMED) &&
>   			    sctp_cmp_addr_exact(&transport->ipaddr, saddr)) {
>   				sctp_assoc_control_transport(
>

