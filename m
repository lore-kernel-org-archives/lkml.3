Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833AbaKIL4h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 06:56:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46746 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640AbaKIL4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 06:56:35 -0500
Message-ID: <545F566F.7010102@suse.cz>
Date: Sun, 09 Nov 2014 12:56:31 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: AL13N <alien@rmail.be>, linux-kernel@vger.kernel.org
Subject: Re: Memory leaks on atom-based boards?
References: <8bdeb6866adef7f2d34a693040c33f12.squirrel@mail.rmail.be>
In-Reply-To: <8bdeb6866adef7f2d34a693040c33f12.squirrel@mail.rmail.be>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2014 07:44 PM, AL13N wrote:
> I have several machines with the same OS and kernel (3.14.22).
> 
> 2 of those machines are both atom-based boards and they get OOM, without
> swap being used (MemAvail crawls down towards 0, even though not more
> memory is used on processes).
> 
> Specifically, this one machine, i need to reboot every 3 à 5 days.
> 
> It has 4GB RAM and 4GB swap(SSD), but:
>  - sum of all vmRSS < 500MB
>  - sum of all tmpfs < 100MB
>  - Slab is around 16MB
>  - Cache will usually crawl down towards 0 (just like MemAvail)
>  - I couldn't find another explanation for the loss of Memory
>  - I also asked
> http://serverfault.com/questions/616856/where-did-my-memory-go-on-linux-no-cache-slab-shm-ipcs
> (the other machine)
>  - This problem existed on this hardware at least from 3.12.* upwards.
> 
> I've recompiled kernel to include kmemleak (i figured it'd be some module
> that i've only got with this board), but it didn't point to anything (i
> tested also with the test module, to see if it was working).
> 
> My questions are:
>  - Is this a kernel memory leak somewhere?

Hi, this does look like a kernel memory leak. There was recently a known
one fixed by patch from https://lkml.org/lkml/2014/10/15/447 which made
it to 3.18-rc3 and should be backported to stable kernels 3.8+ soon.
You would recognize if this is the fix for you by checking the
thp_zero_page_alloc value in /proc/vmstat. Value X > 1 basically means
that X*2 MB memory is leaked.
You say in the serverfault post that 3.17.2 helped, but the fix is not
in 3.17.2... but it could be just that the circumstances changed and THP
zero pages are no longer freed and realocated.
So if you want to be sure, I would suggest trying again a version where
the problem appeared on your system, and checking the
thp_zero_page_alloc. Perhaps you'll see a >1 value even on 3.17.2, which
means some leak did occur there as well, but maybe not so severe.

>  - How can i find out what is allocating all this memory?

There's no simple way, unfortunately. Checking the kpageflags /proc file
might help. IIRC there used to be a patch in -mm tree to store who
allocated what page, but it might be bitrotten.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

