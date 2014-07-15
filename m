Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758413AbaGOJcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:32:24 -0400
Received: from imap.thunk.org ([74.207.234.97]:35446 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758340AbaGOJcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:32:02 -0400
Date: Tue, 15 Jul 2014 05:31:54 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs/ext4/super.c: Let 'counters' switched by SMP
Message-ID: <20140715093154.GB1451@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Chen Gang <gang.chen.5i5j@gmail.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <53C47E59.8030502@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C47E59.8030502@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 09:05:29AM +0800, Chen Gang wrote:
> When SMP is disabled, 'struct percpu_counter' has no 'counters' member,
> so need skip it when in !SMP.
> 
> The related git commit:
> 
>   "feab139 ext4: rearrange initialization to fix EXT4FS_DEBUG".
> 
> The related error (with allmodconfig under score):
> 
>     CC [M]  fs/ext4/super.o
>   fs/ext4/super.c: In function 'ext4_commit_super':
>   fs/ext4/super.c:4546:41: error: 'struct percpu_counter' has no member named 'counters'
>     if (EXT4_SB(sb)->s_freeclusters_counter.counters)
>                                            ^
>   fs/ext4/super.c:4550:39: error: 'struct percpu_counter' has no member named 'counters'
>     if (EXT4_SB(sb)->s_freeinodes_counter.counters)

Thanks for the pointing out the problem.  I though think the right way
of fixing this problem, though, instead of using the #ifdef
CONFIG_SMP, is to do this:

       if (percpu_counter_initialized(&EXT4_SB(sb)->s_freeclusters_counter))
       	  ...

I'll respin the "ext4: rearrange initialization to fix EXT4FS_DEBUG"
commit to include this fix and give you credit in the commit logs for
pointing out this issue.

Cheers,

						- Ted

