Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509AbaFPNAj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:00:39 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43735 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaFPNAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:00:38 -0400
Message-ID: <1402923474.3958.34.camel@debian>
Subject: Re: [PATCH] mm/vmscan.c: avoid recording the original scan targets
 in shrink_lruvec()
From: Chen Yucong <slaoub@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mhocko@suse.cz, hannes@cmpxchg.org, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Mon, 16 Jun 2014 20:57:54 +0800
In-Reply-To: <1402320436-22270-1-git-send-email-slaoub@gmail.com>
References: <1402320436-22270-1-git-send-email-slaoub@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-09 at 21:27 +0800, Chen Yucong wrote:
> Via https://lkml.org/lkml/2013/4/10/334 , we can find that recording the
> original scan targets introduces extra 40 bytes on the stack. This patch
> is able to avoid this situation and the call to memcpy(). At the same time,
> it does not change the relative design idea.
> 
> ratio = original_nr_file / original_nr_anon;
> 
> If (nr_file > nr_anon), then ratio = (nr_file - x) / nr_anon.
>  x = nr_file - ratio * nr_anon;
> 
> if (nr_file <= nr_anon), then ratio = nr_file / (nr_anon - x).
>  x = nr_anon - nr_file / ratio;
> 
Hi Andrew Morton,

I think the patch
 
[PATCH]
mm-vmscanc-avoid-recording-the-original-scan-targets-in-shrink_lruvec-fix.patch

which I committed should be discarded. Because It have some critical
defects.
    1) If we want to solve the divide-by-zero and unfair problems, it
needs to two variables for recording the ratios.
 
    2) For "x = nr_file - ratio * nr_anon", the "x" is likely to be a
negative number. we can assume:

      nr[LRU_ACTIVE_FILE] = 30
      nr[LRU_INACTIVE_FILE] = 30
      nr[LRU_ACTIVE_ANON] = 0
      nr[LRU_INACTIVE_ANON] = 40

      ratio = 60/40 = 3/2

When the value of (nr_reclaimed < nr_to_reclaim) become false, there are
the following results:
      nr[LRU_ACTIVE_FILE] = 15
      nr[LRU_INACTIVE_FILE] = 15
      nr[LRU_ACTIVE_ANON] = 0
      nr[LRU_INACTIVE_ANON] = 25
 
      nr_file = 30
      nr_anon = 25

      x = 30 - 25 * (3/2) = 30 - 37.5 = -7.5.

The result is too terrible. 
   
   3) This method is less accurate than the original, especially for the
qualitative difference between FILE and ANON that is very small.

thx!
cyc  
   

