Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982AbaKRPk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:40:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753481AbaKRPkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 10:40:25 -0500
Date: Tue, 18 Nov 2014 16:39:32 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Rik van Riel <riel@redhat.com>, Ionut Alexa <ionut.m.alexa@gmail.com>,
        Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] exit: silence a bogus static checker warning
Message-ID: <20141118153932.GA3790@redhat.com>
References: <20141118074422.GA17829@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141118074422.GA17829@mwanda>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18, Dan Carpenter wrote:
>
> Smatch complains about this:
>
> 	kernel/exit.c:543 forget_original_parent()
> 	warn: add some parenthesis here?
>
> I don't normally advocate changing the code to make the static checker
> happy but these are normally precedence bugs so I think it's ok to put
> parenthesis so it's clear the code is deliberate.

I still think that "if (!A == B)" doesn't look as a potential precedence
bug, but I won't argue.

Andrew, this fixes   exit-reparent-cleanup-the-changing-of-parent.patch
in -mm tree.

> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/kernel/exit.c b/kernel/exit.c
> index 6192422..1192d12 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -540,7 +540,7 @@ static void forget_original_parent(struct task_struct *father)
>  	list_for_each_entry(p, &father->children, sibling) {
>  		for_each_thread(p, t) {
>  			t->real_parent = reaper;
> -			BUG_ON(!t->ptrace != (t->parent == father));
> +			BUG_ON((!t->ptrace) != (t->parent == father));
>  			if (likely(!t->ptrace))
>  				t->parent = t->real_parent;
>  			if (t->pdeath_signal)

