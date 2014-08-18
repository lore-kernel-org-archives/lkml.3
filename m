Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbaHRPCG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 11:02:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742AbaHRPCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 11:02:03 -0400
Message-ID: <53F2154D.7050600@redhat.com>
Date: Mon, 18 Aug 2014 17:01:33 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Zhu Yanjun <zyjzyj2000@gmail.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, vyasevich@gmail.com,
        tuexen@fh-muenster.de, khandelwal.deepak.1987@gmail.com,
        Yue.Tao@windriver.com, alexandre.dietsch@windriver.com,
        davem@davemloft.net, Zhu Yanjun <Yanjun.Zhu@windriver.com>
Subject: Re: [PATCH 1/1] sctp: not send SCTP_PEER_ADDR_CHANGE notifications
 with failed probe
References: <1408094820-11725-1-git-send-email-Yanjun.Zhu@windriver.com> <1408094820-11725-2-git-send-email-Yanjun.Zhu@windriver.com>
In-Reply-To: <1408094820-11725-2-git-send-email-Yanjun.Zhu@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2014 11:27 AM, Zhu Yanjun wrote:
> When a failed probe comes along UNCONFIRMED path, it is not necessary
> to send SCTP_PEER_ADDR_CHANGE notification.

I do not find this in the RFC, but it seems reasonable - at least, I would
have liked to see a more elaborate commit message from you explaining why
it's okay to do; at least RFC6458 I read:

   SCTP_ADDR_UNREACHABLE:

     The address specified can no longer be reached. Any data sent
     to this address is rerouted to an alternate until this address
     becomes reachable. This notification is provided whenever an
     address *becomes* unreachable.

Given that the transport has always been in state SCTP_UNCONFIRMED, it
therefore wasn't active before and hasn't been used before, and one could
argue that it doesn't "become" "unreachable" but always has been, so we
wouldn't need to bug the user with a notification about it.

> Reported-by: DEEPAK KHANDELWAL <khandelwal.deepak.1987@gmail.com>

Nit: please write names normally: Deepak Khandelwal

> Suggested-by: Vlad Yasevich <vyasevich@gmail.com>
> Suggested-by: Michael Tuexen <tuexen@fh-muenster.de>
> Signed-off-by: Zhu Yanjun <Yanjun.Zhu@windriver.com>
> ---
>   net/sctp/associola.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> index 9de23a2..2e23f6b 100644
> --- a/net/sctp/associola.c
> +++ b/net/sctp/associola.c
> @@ -813,6 +813,7 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
>   		else {
>   			dst_release(transport->dst);
>   			transport->dst = NULL;
> +			ulp_notify = false;
>   		}
>
>   		spc_state = SCTP_ADDR_UNREACHABLE;
>
