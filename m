Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab3EZGJQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 02:09:16 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:48473 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab3EZGJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 02:09:15 -0400
Message-ID: <51A1A707.9030506@colorfullife.com>
Date: Sun, 26 May 2013 08:09:11 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, hhuang@redhat.com
Subject: Re: [PATCH] ipc,sem: move restart loop to do_smart_update
References: <51978696.6040705@colorfullife.com> <20130519183250.2a82d642@annuminas.surriel.com>
In-Reply-To: <20130519183250.2a82d642@annuminas.surriel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rik,

On 05/20/2013 12:32 AM, Rik van Riel wrote:
> @@ -751,17 +744,19 @@ static int update_queue(struct sem_array *sma, int semnum, struct list_head *pt)
>   static void do_smart_update(struct sem_array *sma, struct sembuf *sops, int nsops,
>   			int otime, struct list_head *pt)
>   {
> -	int i;
> +	int i, restart;
>   
> + again:
> +	restart = 0;
>   	if (sma->complex_count || sops == NULL) {
> -		if (update_queue(sma, -1, pt))
> +		if (update_queue(sma, -1, pt, &restart))
>   			otime = 1;
>   	}
I didn't notice it immediately, this is insufficient:
Complex operations may affect all semaphores in the array.
Thus it is not sufficient to scan the per-semaphore queues of the 
semaphores that were touched by *sops, all must be scanned.

Perhaps something like:
 > +        if (update_queue(sma, -1, pt, &restart))
 > +            sops = NULL;
 >              otime = 1;
 >      }
(untested!)

Test case:
1: semop(<key>, {{1, -1, 0}, {2, 1, 0}}, 2 <unfinished ...>
2: semop(<key>, {{2, -1, 0}}, 1 <unfinished ...>
3: semop(<key>, {{1, 1, 0}}, 1)     = 0

[3] is able to run, calls do_smart_update().
The global queue is scanned and [1] is released
Without the "sops = NULL", [2] sleeps forever.

--
     Manfred

