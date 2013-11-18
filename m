Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829Ab3KRQpm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 11:45:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37086 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236Ab3KRQpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 11:45:36 -0500
Date: Mon, 18 Nov 2013 17:45:33 +0100
From: Jan Kara <jack@suse.cz>
To: Lubomir Rintel <lkundrak@v3.sk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jbd: Lower severity of aborted journal from EMERG to CRIT
Message-ID: <20131118164533.GF3921@quack.suse.cz>
References: <1384527412-23349-1-git-send-email-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384527412-23349-1-git-send-email-lkundrak@v3.sk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 15-11-13 15:56:52, Lubomir Rintel wrote:
> According to Documentation/kernel-parameters.txt, KERN_EMERG is reserved for
> events that render system unusable.
> 
> This is hardly the case in case of flash memory stick hardware removal without
> umounting. Syslog is often configured to forward messages with EMERG severity
> to all logged-in terminals, often causing unnecessary noise.
  The logic behind using KERN_EMERG in that place is that the filesystem is
dead. If it was an important filesystem in your system, the whole system is
unusable. In kernel, we don't know whether the filesystem was important or
not. So KERN_EMERG isn't adequate in all the cases but KERN_CRIT is
neither. What if we made that message print also device name (it would be
more useful anyway in that case) and you could then filter out messages for
unimportant devices in syslogd?

								Honza

> 
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> ---
>  fs/jbd/journal.c  |    2 +-
>  fs/jbd2/journal.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
> index 2d04f9a..9dbc1b6 100644
> --- a/fs/jbd/journal.c
> +++ b/fs/jbd/journal.c
> @@ -605,7 +605,7 @@ out_unlock:
>  	spin_unlock(&journal->j_state_lock);
>  
>  	if (unlikely(is_journal_aborted(journal))) {
> -		printk(KERN_EMERG "journal commit I/O error\n");
> +		printk(KERN_CRIT "journal commit I/O error\n");
>  		err = -EIO;
>  	}
>  	return err;
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 5203264..2d1f53c 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -719,7 +719,7 @@ int jbd2_log_wait_commit(journal_t *journal, tid_t tid)
>  	read_unlock(&journal->j_state_lock);
>  
>  	if (unlikely(is_journal_aborted(journal))) {
> -		printk(KERN_EMERG "journal commit I/O error\n");
> +		printk(KERN_CRIT "journal commit I/O error\n");
>  		err = -EIO;
>  	}
>  	return err;
> -- 
> 1.7.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
