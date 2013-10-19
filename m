Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360Ab3JSXrV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 19:47:21 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:33957 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab3JSXrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 19:47:19 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Mark Brown <broonie@kernel.org>
Cc: "Eric W. Biederman" <ebiederman@twitter.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>,
        Thierry Reding <thierry.reding@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20131019121548.GX2443@sirena.org.uk>
Date: Sat, 19 Oct 2013 16:47:08 -0700
In-Reply-To: <20131019121548.GX2443@sirena.org.uk> (Mark Brown's message of
	"Sat, 19 Oct 2013 13:15:48 +0100")
Message-ID: <87k3h8escj.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19bc7lyVxuPIynJqyTcLE0qTZkOpWoeEJk=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3136]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Mark Brown <broonie@kernel.org>
X-Spam-Relay-Country: 
Subject: Re: linux-next: manual merge of the userns tree
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown <broonie@kernel.org> writes:

> Today's linux-next merge of the userns tree got a conflict in
> fs/fuse/dir.c between 3c70b8eed (fuse: don't check_submounts_and_drop()
> in RCU walk) in the fuse tree and 40216baa0 (vfs: Lazily remove mounts
> on unlinked files and directories. v2) in the userns tree.
>
> I fixed it up as below and can carry as required:

The fix looks right.

However I think this conflict highlights a larger issue, as there are
several other filesystems that call check_submounts_and_drop from the
devalidate and possibly from rcu_walk today.

Miklos what problem did you run into?

Sigh.  It looks like it probably makes sense to merge
shrink_submounts_and_drop with d_invalidate, so filesystems don't even
need to think about this issue.

Eric

> diff --cc fs/fuse/dir.c
> index 0747f6e,b1cd7b7..0000000
> --- a/fs/fuse/dir.c
> +++ b/fs/fuse/dir.c
> @@@ -263,9 -259,7 +263,10 @@@ out
>   
>   invalid:
>   	ret = 0;
>  -	shrink_submounts_and_drop(entry);
>  +
> - 	if (!(flags & LOOKUP_RCU) && check_submounts_and_drop(entry) != 0)
> - 		ret = 1;
> ++	if (!(flags & LOOKUP_RCU))
> ++		shrink_submounts_and_drop(entry);
> ++
>   	goto out;
>   }
>   
