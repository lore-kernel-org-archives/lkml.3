Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab3ILONv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 10:13:51 -0400
Received: from mx11.netapp.com ([216.240.18.76]:61386 "EHLO mx11.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461Ab3ILONt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 10:13:49 -0400
X-IronPort-AV: E=Sophos;i="4.90,891,1371106800"; 
   d="scan'208";a="49171112"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Linux/m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Kernel size increase of +256 KiB (was: Re: RPCSEC_GSS: Share
 all credential caches on a per-transport basis)
Thread-Topic: Kernel size increase of +256 KiB (was: Re: RPCSEC_GSS: Share
 all credential caches on a per-transport basis)
Thread-Index: AQHOr7tznpOxKw98ykmpioj1Q9on0JnCmnmA
Date: Thu, 12 Sep 2013 14:13:48 +0000
Message-ID: <1378995227.3117.9.camel@leira.trondhjem.org>
References: <CAMuHMdViO7yNJ5rxvRkv5NhmW6PQY1N+HW75NwokFnGQp+nxxw@mail.gmail.com>
In-Reply-To: <CAMuHMdViO7yNJ5rxvRkv5NhmW6PQY1N+HW75NwokFnGQp+nxxw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.53.51]
Content-Type: text/plain; charset="utf-8"
Content-ID: <10F38056DFEB214288D754123D0D0BD7@hq.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8CEDwfJ012902

On Thu, 2013-09-12 at 15:24 +0200, Geert Uytterhoeven wrote:
> On Mon, Sep 9, 2013 at 6:57 PM, Linux Kernel Mailing List
> <linux-kernel@vger.kernel.org> wrote:
> > diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
> > index 5ec15bb..dc4b449 100644
> > --- a/net/sunrpc/auth_gss/auth_gss.c
> > +++ b/net/sunrpc/auth_gss/auth_gss.c
> > @@ -51,6 +51,7 @@
> >  #include <linux/sunrpc/rpc_pipe_fs.h>
> >  #include <linux/sunrpc/gss_api.h>
> >  #include <asm/uaccess.h>
> > +#include <linux/hashtable.h>
> >
> >  #include "../netns.h"
> >
> > @@ -71,6 +72,9 @@ static unsigned int gss_expired_cred_retry_delay = GSS_RETRY_EXPIRED;
> >   * using integrity (two 4-byte integers): */
> >  #define GSS_VERF_SLACK         100
> >
> > +static DEFINE_HASHTABLE(gss_auth_hash_table, 16);
> > +static DEFINE_SPINLOCK(gss_auth_hash_lock);
> 
> Today's m68k/atari-defconfig kernel no longer boots, as it became larger than
> 4 MiB.
> 
> bloat-o-meter tells me:
> 
> function                                     old     new   delta
> gss_auth_hash_table                            -  262144 +262144
> 
> Woops...

Whoops indeed. The above should have declared 16 buckets, and not 1<<16.
I fell for Sasha's subtle trap...

> Are you trying to game Tim's survey? ;-)
> (question 13 at http://www.embeddedlinuxconference.com/cgi-bin/survey.cgi)
> 
> Can this memory be allocated dynamically / only when it's used?

:-) It's declared inside a module, so that should already be the case,
however I'll send in a patch to change the above to the intended:

DEFINE_HASHTABLE(gss_auth_hash_table, 4);

Thanks Geert!

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
