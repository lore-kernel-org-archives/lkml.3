Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936231Ab3DHXqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 19:46:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53227 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757254Ab3DHXqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 19:46:24 -0400
Date: Mon, 8 Apr 2013 16:46:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] [BZ905179] audit: omit check for uid and gid validity
 in audit rules and data
Message-Id: <20130408164622.284f48c65341396aa8dbd220@linux-foundation.org>
In-Reply-To: <1363807097-13073-1-git-send-email-rgb@redhat.com>
References: <1363807097-13073-1-git-send-email-rgb@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Mar 2013 15:18:17 -0400 Richard Guy Briggs <rgb@redhat.com> wrote:

> audit rule additions containing "-F auid!=4294967295" were failing with EINVAL.
> 
> UID_INVALID (and GID_INVALID) is actually a valid uid (gid) for setting and
> testing against audit rules.  Remove the check for invalid uid and gid when
> parsing rules and data for logging.
> 
> Revert part of ca57ec0f00c3f139c41bf6b0a5b9bcc95bbb2ad7 (2012-09-11) to fix
> this.

Eric, can you please take a look?

> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  kernel/auditfilter.c |   12 ------------
>  1 files changed, 0 insertions(+), 12 deletions(-)
> 
> diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
> index f9fc54b..457ee39 100644
> --- a/kernel/auditfilter.c
> +++ b/kernel/auditfilter.c
> @@ -360,10 +360,7 @@ static struct audit_entry *audit_rule_to_entry(struct audit_rule *rule)
>  			/* bit ops not implemented for uid comparisons */
>  			if (f->op == Audit_bitmask || f->op == Audit_bittest)
>  				goto exit_free;
> -
>  			f->uid = make_kuid(current_user_ns(), f->val);
> -			if (!uid_valid(f->uid))
> -				goto exit_free;

It concerns me that map_id_down() can return -1 on error and that this
change causes the kernel to no longer notice that error?


>  			break;
>  		case AUDIT_GID:
>  		case AUDIT_EGID:
> @@ -372,10 +369,7 @@ static struct audit_entry *audit_rule_to_entry(struct audit_rule *rule)
>  			/* bit ops not implemented for gid comparisons */
>  			if (f->op == Audit_bitmask || f->op == Audit_bittest)
>  				goto exit_free;
> -
>  			f->gid = make_kgid(current_user_ns(), f->val);
> -			if (!gid_valid(f->gid))
> -				goto exit_free;
>  			break;
>  		case AUDIT_PID:
>  		case AUDIT_PERS:
> @@ -469,10 +463,7 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
>  			/* bit ops not implemented for uid comparisons */
>  			if (f->op == Audit_bitmask || f->op == Audit_bittest)
>  				goto exit_free;
> -
>  			f->uid = make_kuid(current_user_ns(), f->val);
> -			if (!uid_valid(f->uid))
> -				goto exit_free;
>  			break;
>  		case AUDIT_GID:
>  		case AUDIT_EGID:
> @@ -482,10 +473,7 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
>  			/* bit ops not implemented for gid comparisons */
>  			if (f->op == Audit_bitmask || f->op == Audit_bittest)
>  				goto exit_free;
> -
>  			f->gid = make_kgid(current_user_ns(), f->val);
> -			if (!gid_valid(f->gid))
> -				goto exit_free;
>  			break;
>  		case AUDIT_PID:
>  		case AUDIT_PERS:

