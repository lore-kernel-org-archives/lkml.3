Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519Ab3BLJxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 04:53:07 -0500
Received: from relay.parallels.com ([195.214.232.42]:52060 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263Ab3BLJxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 04:53:02 -0500
Message-ID: <511A10E0.1000604@parallels.com>
Date: Tue, 12 Feb 2013 13:52:32 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: <akpm@linux-foundation.org>, <linux-nfs@vger.kernel.org>,
        <Trond.Myklebust@netapp.com>, <linux-kernel@vger.kernel.org>,
        <devel@openvz.org>
Subject: Re: [PATCH 0/2] NFSD: fix races in service per-net resources allocation
References: <20130201111046.24066.72836.stgit@localhost.localdomain> <20130211002558.GD10161@fieldses.org> <51188D2A.4070605@parallels.com> <20130211163715.GA19342@fieldses.org> <20130211205845.GE30117@fieldses.org>
In-Reply-To: <20130211205845.GE30117@fieldses.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.29.37]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

12.02.2013 00:58, J. Bruce Fields пишет:
<snip>
>   void svc_close_net(struct svc_serv *serv, struct net *net)
>   {
> -	svc_close_list(serv, &serv->sv_tempsocks, net);
> -	svc_close_list(serv, &serv->sv_permsocks, net);
> -
> -	svc_clear_pools(serv, net);
> -	/*
> -	 * At this point the sp_sockets lists will stay empty, since
> -	 * svc_xprt_enqueue will not add new entries without taking the
> -	 * sp_lock and checking XPT_BUSY.
> -	 */
> -	svc_clear_list(serv, &serv->sv_tempsocks, net);
> -	svc_clear_list(serv, &serv->sv_permsocks, net);
> +	int closed;
> +	int delay = 0;
> +
> +again:
> +	closed = svc_close_list(serv, &serv->sv_permsocks, net);
> +	closed += svc_close_list(serv, &serv->sv_tempsocks, net);
> +	if (closed) {
> +		svc_clean_up_xprts(serv, net);
> +		msleep(delay++);
> +		goto again;
> +	}

Frankly, this hunk above makes me feel sick... :(
But I have no better idea right now...
Maybe make this hunk a bit less weird (this is from my POW only, of course), like this:

 > +	while (svc_close_list(serv, &serv->sv_permsocks, net) +
 > +	       svc_close_list(serv, &serv->sv_tempsocks, net)) {
 > +		svc_clean_up_xprts(serv, net);
 > +		msleep(delay++);
 > +	}

?

Anyway, thanks!

Acked-by: Stanislav Kinsbursky <skinsbursky@parallels.com>

-- 
Best regards,
Stanislav Kinsbursky
