Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab3J3AnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 20:43:19 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:40390 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab3J3AnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 20:43:18 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
References: <20131029220939.GA23060@kroah.com>
Date: Tue, 29 Oct 2013 17:39:02 -0700
In-Reply-To: <20131029220939.GA23060@kroah.com> (Greg KH's message of "Tue, 29
	Oct 2013 15:09:39 -0700")
Message-ID: <8761sflhi1.fsf@tw-ebiederman.twitter.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19Ln7GZhMXRSD8tVFToVSmn4UB5ye+yEWM=
X-SA-Exim-Connect-IP: 8.25.197.25
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0266]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg KH <gregkh@linuxfoundation.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] sysfs: move assignment to be under lock in sysfs_remove_dir()
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> writes:

> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> Linus noticed that the assignment of sd isn't protected by the lock in
> sysfs_remove_dir(), so move the assignment of the variable under the
> lock to be safe.

I don't have a strong feeling either way but how would that matter?
There is only ever one sd associated with a kobj.

And we better be under the sysfs_mutex when the assignment and and
sysfs_remove_dir are called.

> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>
> Tejun, any objection to this patch?  You consolidated the locks back in
> 2007 on this function, and nothing has changed there since then, so odds
> are it's not a problem, but nice to be safe, right?
>
>  fs/sysfs/dir.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
> index eab59de4..2609f934 100644
> --- a/fs/sysfs/dir.c
> +++ b/fs/sysfs/dir.c
> @@ -856,9 +856,10 @@ void sysfs_remove(struct sysfs_dirent *sd)
>   */
>  void sysfs_remove_dir(struct kobject *kobj)
>  {
> -	struct sysfs_dirent *sd = kobj->sd;
> +	struct sysfs_dirent *sd;
>  
>  	spin_lock(&sysfs_assoc_lock);
> +	sd = kobj->sd;
>  	kobj->sd = NULL;
>  	spin_unlock(&sysfs_assoc_lock);
>  
