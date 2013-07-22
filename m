Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933192Ab3GVTZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 15:25:07 -0400
Received: from mout.gmx.net ([212.227.15.15]:54090 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932912Ab3GVTZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 15:25:05 -0400
Message-ID: <51ED870D.8070904@gmx.de>
Date: Mon, 22 Jul 2013 21:25:01 +0200
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Eric Paris <eparis@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] fsnotify: potential use after free
References: <20130722065327.GA14617@longonot.mountain>
In-Reply-To: <20130722065327.GA14617@longonot.mountain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:yLbRNEB11Qi5jMbSxWq7O8Pl/K5QpH74IOr2VJALqijE9HBGbjZ
 A68wHfMVj0r0PY46ALZWot2KJjq8f4oe2DXvPnOl7khpW9vhfOdtl7rg6IdiVhrycDBtE2V
 7IKZlfW0ZRvgc4syqXWhR2XBuDgUKmsTkMEabkQcj9J5XUFxHJIdn7wSPp6cJOLE4j3c5i3
 AsxJVcfjDN9Lzb2u3Dc8g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.07.2013 08:53, Dan Carpenter wrote:
> My static checker complains that if we drop the last reference then it
> would be a use after free.  I don't know if it's possible, but really
> the atomic_dec(&group->num_marks); should be done while we are holding a
> reference to "group".
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/fs/notify/mark.c b/fs/notify/mark.c
> index 923fe4a..27e357e 100644
> --- a/fs/notify/mark.c
> +++ b/fs/notify/mark.c
> @@ -262,9 +262,9 @@ int fsnotify_add_mark_locked(struct fsnotify_mark *mark,
>   err:
>   	mark->flags &= ~FSNOTIFY_MARK_FLAG_ALIVE;
>   	list_del_init(&mark->g_list);
> +	atomic_dec(&group->num_marks);
>   	fsnotify_put_group(group);
>   	mark->group = NULL;
> -	atomic_dec(&group->num_marks);
>
>   	spin_unlock(&mark->lock);
>
>

Hi Dan,

we assume that the caller already holds a reference to a group. We then
take another ref for the marks->group. This is the one that we drop in
case of error, but there is still the one held by the caller. So its 
still save to access the group and to decrement the number of marks 
since we always hold a ref to it.
However, thank you for testing.

Regards,
Lino
