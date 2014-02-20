Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbaBTSft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 13:35:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322AbaBTSfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 13:35:48 -0500
Date: Thu, 20 Feb 2014 19:35:18 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org, eparis@redhat.com,
        sgrubb@redhat.com, akpm@linux-foundation.org, peterz@infradead.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 4/7] pid: modify task_tgid_nr to work without
	task->tgid.
Message-ID: <20140220183518.GA23993@redhat.com>
References: <cover.1390495874.git.rgb@redhat.com> <4c2bd4df9a53965a50c83e7ea38e0d39601a4326.1390495874.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c2bd4df9a53965a50c83e7ea38e0d39601a4326.1390495874.git.rgb@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23, Richard Guy Briggs wrote:
>
> task->tgid is an error prone construct and results in duplicate maintenance.
> Start it's demise by modifying task_tgid_nr to not use it.

Well, I disagree.

Yes I agree that ->tgid should probably die. But this change itself doesn't
help, it only makes task_tgid_nr() slower. We need to convert other users
first, then consider this change along with ->tgid removal.

Besides, this is not that simple and the patch doesn't look right:

>  static inline pid_t task_tgid_nr(struct task_struct *tsk)
>  {
> -	return tsk->tgid;
> +	return pid_nr(task_tgid(tsk));
>  }

And what protect task_tgid? This is racy.

The race is very unlikely, pid_nr() will likely hit pid == NULL if tsk
exits. But still it can use the freed/unmapped/reused memory.

And even if we add rcu_read_lock() the patch will add the semantics change,
task_tgid_nr() can return 0 if tsk has already exited. At least this should
be documented, but you also need to audit the users.

Oleg.

