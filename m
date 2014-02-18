Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbaBRMXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 07:23:53 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33025 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037AbaBRMXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 07:23:52 -0500
Date: Tue, 18 Feb 2014 07:23:26 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Xufeng Zhang <xufeng.zhang@windriver.com>
Cc: vyasevich@gmail.com, davem@davemloft.net, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] sctp: Update HEARTBEAT timer immediately after user
 changed HB.interval
Message-ID: <20140218122326.GA4590@hmsreliant.think-freely.org>
References: <1392703010-6128-1-git-send-email-xufeng.zhang@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392703010-6128-1-git-send-email-xufeng.zhang@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 01:56:50PM +0800, Xufeng Zhang wrote:
> For an established association, if user has updated the HB.interval
> parameter by setsockopt(), this new heartbeat interval will not
> take effect until:
>   - the expiry of the heartbeat timer and new hearbeat is sent.
>   - DATA chunk has been sent and the transport resets the timer.
> This could not meet the requirement of the user who need to
> get HEARTBEAT sent at the specified time.
> 
> Thus, we need to update the heartbeat timer immediately after
> user has changed HB.interval.
> 
> Signed-off-by: Xufeng Zhang <xufeng.zhang@windriver.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>

> ---
>  net/sctp/socket.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 9e91d6e..699ae1e 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -2344,6 +2344,11 @@ static int sctp_apply_peer_addr_params(struct sctp_paddrparams *params,
>  			if (trans) {
>  				trans->hbinterval =
>  				    msecs_to_jiffies(params->spp_hbinterval);
> +
> +				/* Update the heartbeat timer immediately. */
> +				if (!mod_timer(&trans->hb_timer,
> +					    sctp_transport_timeout(trans)))
> +					sctp_transport_hold(trans);
>  			} else if (asoc) {
>  				asoc->hbinterval =
>  				    msecs_to_jiffies(params->spp_hbinterval);
> -- 
> 1.7.0.2
> 
> 
