Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbaF2PhX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 11:37:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbaF2PhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 11:37:22 -0400
Date: Sun, 29 Jun 2014 17:37:12 +0200
From: Mateusz Guzik <mguzik@redhat.com>
To: Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: lib/argv_split.c : should argv be kfree'ed ?
Message-ID: <20140629153711.GA16902@mguzik.redhat.com>
References: <53AF3925.7070300@gmx.de>
 <20140628220421.GA24883@mguzik.redhat.com>
 <53B02551.9040907@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53B02551.9040907@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 29, 2014 at 04:40:17PM +0200, Toralf Förster wrote:
> On 06/29/2014 12:04 AM, Mateusz Guzik wrote:
> > On Sat, Jun 28, 2014 at 11:52:37PM +0200, Toralf Förster wrote:
> >> /me wonders if this patch is needed here :
> >>
> >>
> >> diff --git a/lib/argv_split.c b/lib/argv_split.c
> >> index e927ed0..7de4cb4 100644
> >> --- a/lib/argv_split.c
> >> +++ b/lib/argv_split.c
> >> @@ -85,6 +85,7 @@ char **argv_split(gfp_t gfp, const char *str, int *argcp)
> >>                         *argv++ = argv_str;
> >>                 }
> >>         }
> >> +       kfree (argv);
> >>         *argv = NULL;
> >>
> >>         if (argcp)
> >>
> > 
> > No, see argv_free.
> > 
> Ah, understood, it is in the responsibility of the caller to avoid the memleak.
> BTW may I ask you about your opinion about this warning of cppcheck in lib/flex_array.c:
> 
>         for (part_nr = start_part; part_nr <= end_part; part_nr++) {<--- Memory leak: part
>                 part = __fa_get_part(fa, part_nr, flags);
>                 if (!part)
>                         return -ENOMEM;
>         }
>         return 0;
> 


static struct flex_array_part *
__fa_get_part(struct flex_array *fa, int part_nr, gfp_t flags)
{
        struct flex_array_part *part = fa->parts[part_nr];
        if (!part) {
                part = kmalloc(sizeof(struct flex_array_part), flags);
                if (!part)
                        return NULL;
                if (!(flags & __GFP_ZERO))
                        memset(part, FLEX_ARRAY_FREE,
                                sizeof(struct flex_array_part));
                fa->parts[part_nr] = part;

		^^^^^^^^^^^^^^^^^^^^^^^^^^
        }
        return part;
}


Allocated memory is not leaked. It is stored in 'fa' and is perfectly
reachable afterwards.

'part' in flex_array_prealloc is only used for error checking.

-- 
Mateusz Guzik
