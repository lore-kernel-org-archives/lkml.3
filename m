Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbaFGVnF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 17:43:05 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:37582 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbaFGVnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 17:43:03 -0400
Date: Sat, 7 Jun 2014 14:42:59 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: =?UTF-8?Q?Manuel_Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
cc: davem@davemloft.net, jeffrey.t.kirsher@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dns_resolver: assure that dns_query() result is
 null-terminated
In-Reply-To: <1402167681-24676-1-git-send-email-manuel.schoelling@gmx.de>
Message-ID: <alpine.DEB.2.02.1406071441050.24927@chino.kir.corp.google.com>
References: <CAHQdGtTtwS_DAXx-nhVjjO3D1wksuV+5br10gX0DheHzWDD+sw@mail.gmail.com> <1402167681-24676-1-git-send-email-manuel.schoelling@gmx.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381512-1747437259-1402177381=:24927"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381512-1747437259-1402177381=:24927
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Sat, 7 Jun 2014, Manuel Schölling wrote:

> dns_query() credulously assumes that keys are null-terminated and
> returns a copy of a memory block that is off by one.

No sign-off?  Please read Documentation/SubmittingPatches.

> ---
>  net/dns_resolver/dns_query.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/dns_resolver/dns_query.c b/net/dns_resolver/dns_query.c
> index e7b6d53..84871a2 100644
> --- a/net/dns_resolver/dns_query.c
> +++ b/net/dns_resolver/dns_query.c
> @@ -145,11 +145,11 @@ int dns_query(const char *type, const char *name, size_t namelen,
>  	len = upayload->datalen;
>  
>  	ret = -ENOMEM;
> -	*_result = kmalloc(len + 1, GFP_KERNEL);
> +	*_result = kzalloc(len + 1, GFP_KERNEL);
>  	if (!*_result)
>  		goto put;
>  
> -	memcpy(*_result, upayload->data, len + 1);
> +	memcpy(*_result, upayload->data, len);
>  	if (_expiry)
>  		*_expiry = rkey->expiry;
>  

kzalloc() would be unnecessary overhead (zeroing definitely comes with a 
cost) if you're going to copy to the memory immediately afterwards.  Just 
leave the kmalloc(), do the memcpy() and explicitly zero terminate it 
_result.
--531381512-1747437259-1402177381=:24927--
