Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbaA3Dlw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 22:41:52 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50241 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbaA3Dlo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 22:41:44 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Joe Perches <joe@perches.com>, "Mikulas Patocka" <mpatocka@redhat.com>
From: Sebastian Capella <sebastian.capella@linaro.org>
In-Reply-To: <1391045068.2422.30.camel@joe-AO722>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Michel Lespinasse" <walken@google.com>,
        "Shaohua Li" <shli@kernel.org>,
        "Jerome Marchand" <jmarchan@redhat.com>,
        "Joonsoo Kim" <iamjoonsoo.kim@lge.com>
References: <1391039304-3172-1-git-send-email-sebastian.capella@linaro.org>
 <1391039304-3172-2-git-send-email-sebastian.capella@linaro.org>
 <alpine.LRH.2.02.1401291956510.8304@file01.intranet.prod.int.rdu2.redhat.com>
 <1391045068.2422.30.camel@joe-AO722>
Message-ID: <20140130034137.2769.50210@capellas-linux>
User-Agent: alot/0.3.4
Subject: Re: [PATCH v4 1/2] mm: add kstrimdup function
Date: Wed, 29 Jan 2014 19:41:37 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Joe Perches (2014-01-29 17:24:28)
> Why not minimize the malloc length too?
> 
> maybe something like:
> 
> char *kstrimdup(const char *s, gfp_t gfp)
> {
>         char *buf;
>         const char *begin = skip_spaces(s);
>         size_t len = strlen(begin);
> 
>         while (len && isspace(begin[len - 1]))
>                 len--;
> 
>         buf = kmalloc_track_caller(len + 1, gfp);
>         if (!buf)
>                 return NULL;
> 
>         memcpy(buf, begin, len);
>         buf[len] = 0;
> 
>         return buf;
> }

I figured it would be mostly for small trimming, but it seems like
it could be and advantage and used more generally this way.

I have a couple of small changes to return NULL in empty string/all ws
cases and fix a buffer underrun.

How does this look?

Thanks,

Sebastian


char *kstrimdup(const char *s, gfp_t gfp)
{                                                                                
        char *buf;                                                               
        const char *begin = skip_spaces(s);                                      
        size_t len = strlen(begin);                                              

        if (len == 0)                                                            
                return NULL;                                                     
                                                                                 
        while (len > 1 && isspace(begin[len - 1]))                               
                len--;                                                           
                                                                                 
        buf = kmalloc_track_caller(len + 1, gfp);                                
        if (!buf)                                                                
                return NULL;                                                     
                                                                                 
        memcpy(buf, begin, len);                                                 
        buf[len] = '\0';                                                            
                                                                                 
        return buf;                                                              
}        



