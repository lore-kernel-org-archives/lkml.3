Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934129Ab3CHO1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 09:27:40 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37809 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413Ab3CHO1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 09:27:39 -0500
Date: Fri, 8 Mar 2013 09:27:20 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Xufeng Zhang <xufeng.zhang@windriver.com>
Cc: vyasevich@gmail.com, davem@davemloft.net, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sctp: don't break the loop while meeting the active_path
 so as to find the matched transport
Message-ID: <20130308142720.GA9873@hmsreliant.think-freely.org>
References: <1362728377-11025-1-git-send-email-xufeng.zhang@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362728377-11025-1-git-send-email-xufeng.zhang@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 03:39:37PM +0800, Xufeng Zhang wrote:
> sctp_assoc_lookup_tsn() function searchs which transport a certain TSN
> was sent on, if not found in the active_path transport, then go search
> all the other transports in the peer's transport_addr_list, however, we
> should continue to the next entry rather than break the loop when meet
> the active_path transport.
> 
> Signed-off-by: Xufeng Zhang <xufeng.zhang@windriver.com>
> ---
>  net/sctp/associola.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> index 43cd0dd..d2709e2 100644
> --- a/net/sctp/associola.c
> +++ b/net/sctp/associola.c
> @@ -1079,7 +1079,7 @@ struct sctp_transport *sctp_assoc_lookup_tsn(struct sctp_association *asoc,
>  			transports) {
>  
>  		if (transport == active)
> -			break;
> +			continue;
>  		list_for_each_entry(chunk, &transport->transmitted,
>  				transmitted_list) {
>  			if (key == chunk->subh.data_hdr->tsn) {
> -- 
> 1.7.0.2
> 
> 

This works, but what might be better would be if we did a move to front
heuristic in sctp_assoc_set_primary.  E.g. when we set the active_path, move the
requisite transport to the front of the transport_addr_list.  If we did that,
then we could just do one for loop in sctp_assoc_lookup_tsn and wind up
implicitly check the active path first without having to check it seprately and
skip it in the second for loop.  

Neil

