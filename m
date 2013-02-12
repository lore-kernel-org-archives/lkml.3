Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933571Ab3BLRq0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 12:46:26 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:33520 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab3BLRqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 12:46:25 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
References: <1360690488-60060-1-git-send-email-tim.gardner@canonical.com>
Date: Tue, 12 Feb 2013 09:46:19 -0800
In-Reply-To: <1360690488-60060-1-git-send-email-tim.gardner@canonical.com>
	(Tim Gardner's message of "Tue, 12 Feb 2013 10:34:47 -0700")
Message-ID: <87halhfms4.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+nV/gy+AbmNNjaffsKqfS0Jli0o1JzfAU=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 XMBrknScrpt_02 Possible Broken Spam Script
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tim Gardner <tim.gardner@canonical.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH linux-next] befs: befs_fill_super(): remove unreachable code
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Gardner <tim.gardner@canonical.com> writes:

> befs_sb->num_blocks is of base type u64 which is the same as sector_t.
> Therefore, num_blocks can never be larger then the maximum
> value of sector_t.

The analysys is wrong.  On 32bit with CONFIG_LBAF unset sector_t is an
unsigned long aka a u32, while befs_off_t is always a u64.

Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

> smatch analysis:
>
> fs/befs/linuxvfs.c:851 befs_fill_super() warn: impossible
>  condition '(befs_sb->num_blocks > ~(0)) => (0-u64max > u64max)'
>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
>  fs/befs/linuxvfs.c |    7 -------
>  1 file changed, 7 deletions(-)
>
> diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
> index 2b3bda8..2ce5705 100644
> --- a/fs/befs/linuxvfs.c
> +++ b/fs/befs/linuxvfs.c
> @@ -848,13 +848,6 @@ befs_fill_super(struct super_block *sb, void *data, int silent)
>  	if (befs_check_sb(sb) != BEFS_OK)
>  		goto unacquire_priv_sbp;
>  
> -	if( befs_sb->num_blocks > ~((sector_t)0) ) {
> -		befs_error(sb, "blocks count: %Lu "
> -			"is larger than the host can use",
> -			befs_sb->num_blocks);
> -		goto unacquire_priv_sbp;
> -	}
> -
>  	/*
>  	 * set up enough so that it can read an inode
>  	 * Fill in kernel superblock fields from private sb
