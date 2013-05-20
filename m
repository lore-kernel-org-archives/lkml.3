Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128Ab3ETWY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 18:24:57 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:38247 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436Ab3ETWY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 18:24:56 -0400
Date: Mon, 20 May 2013 15:24:53 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Oskar Andero <oskar.andero@sonymobile.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Radovan Lekanovic <radovan.lekanovic@sonymobile.com>,
        Glauber Costa <glommer@openvz.org>, Dave Chinner <dchinner@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] mm: vmscan: add BUG_ON on illegal return values from
 scan_objects
In-Reply-To: <1369041267-26424-1-git-send-email-oskar.andero@sonymobile.com>
Message-ID: <alpine.DEB.2.02.1305201523230.12790@chino.kir.corp.google.com>
References: <1369041267-26424-1-git-send-email-oskar.andero@sonymobile.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 May 2013, Oskar Andero wrote:

> Add a BUG_ON to catch any illegal value from the shrinkers. This fixes a
> potential bug if scan_objects returns a negative other than -1, which
> would lead to undefined behaviour.
> 
> Cc: Glauber Costa <glommer@openvz.org>
> Cc: Dave Chinner <dchinner@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>
> ---
>  mm/vmscan.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 6bac41e..fbe6742 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -293,6 +293,7 @@ shrink_slab_one(struct shrinker *shrinker, struct shrink_control *shrinkctl,
>  		ret = shrinker->scan_objects(shrinker, shrinkctl);
>  		if (ret == -1)
>  			break;
> +		BUG_ON(ret < -1);
>  		freed += ret;
>  
>  		count_vm_events(SLABS_SCANNED, nr_to_scan);

Nack, this doesn't fix anything.  I can see the intention, and for that it 
might make sense to turn this into VM_BUG_ON() so that anybody debugging 
an issue related to this with CONFIG_DEBUG_VM would get the indication, 
but I don't think we need to enforce the API with BUG_ON().
