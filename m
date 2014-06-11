Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbaFKCKO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 22:10:14 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:47818 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbaFKCKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 22:10:12 -0400
Message-ID: <1402452521.28433.26.camel@debian>
Subject: Re: [PATCH] mm/vmscan.c: avoid recording the original scan targets
 in shrink_lruvec()
From: Chen Yucong <slaoub@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mgorman@suse.de, mhocko@suse.cz, hannes@cmpxchg.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date: Wed, 11 Jun 2014 10:08:41 +0800
In-Reply-To: <20140610163338.5b463c5884c4c7e3f1b948e2@linux-foundation.org>
References: <1402320436-22270-1-git-send-email-slaoub@gmail.com>
	 <20140610163338.5b463c5884c4c7e3f1b948e2@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-10 at 16:33 -0700, Andrew Morton wrote:
> On Mon,  9 Jun 2014 21:27:16 +0800 Chen Yucong <slaoub@gmail.com> wrote:
> 
> > Via https://lkml.org/lkml/2013/4/10/334 , we can find that recording the
> > original scan targets introduces extra 40 bytes on the stack. This patch
> > is able to avoid this situation and the call to memcpy(). At the same time,
> > it does not change the relative design idea.
> > 
> > ratio = original_nr_file / original_nr_anon;
> > 
> > If (nr_file > nr_anon), then ratio = (nr_file - x) / nr_anon.
> >  x = nr_file - ratio * nr_anon;
> > 
> > if (nr_file <= nr_anon), then ratio = nr_file / (nr_anon - x).
> >  x = nr_anon - nr_file / ratio;
> > 
> > ...
> >
> 
> Are you sure this is an equivalent-to-before change?  If so, then I
> can't immediately see why :(
> 
The relative design idea is to keep

   ratio
	== scan_target[anon] : scan_target[file]
              == really_scanned_num[anon] : really_scanned_num[file]

The original implementation is 
   ratio 
        == (scan_target[anon] * percentage_anon) / 
           (scan_target[file] * percentage_file) 

To keep the original ratio, percentage_anon should equal to
percentage_file. In other word, we need to calculate the difference
value between percentage_anon and percentage_file, we also have to
record the original scan targets for this.

Instead, we can calculate the *ratio* at the beginning of
shrink_lruvec(). As a result, this can avoid introducing the extra 40
bytes.

In short, we have the same goal: keep the same *ratio* from beginning to
end.

thx!
cyc
 
       

