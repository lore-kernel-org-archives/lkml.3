Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610AbaKEQqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:46:53 -0500
Received: from emvm-gh1-uea08.nsa.gov ([63.239.67.9]:56934 "EHLO
	emvm-gh1-uea08.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbaKEQqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:46:51 -0500
X-Greylist: delayed 477 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Nov 2014 11:46:50 EST
X-TM-IMSS-Message-ID: <c133d0050006442e@nsa.gov>
Message-ID: <545A53A9.4060009@tycho.nsa.gov>
Date: Wed, 05 Nov 2014 11:43:21 -0500
From: Stephen Smalley <sds@tycho.nsa.gov>
Organization: National Security Agency
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>, linux-unionfs@vger.kernel.org,
        selinux@tycho.nsa.gov
CC: linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] SELinux: The copy-up operation must have read permission
 on the lower file
References: <20141105154217.2555.578.stgit@warthog.procyon.org.uk> <20141105154318.2555.7052.stgit@warthog.procyon.org.uk>
In-Reply-To: <20141105154318.2555.7052.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2014 10:43 AM, David Howells wrote:
> The copy-up operation must have read permission on the lower file for the task
> that caused the copy-up.  This helps prevent overlayfs from being used to
> access something it shouldn't.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  security/selinux/hooks.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index f43f07fdc028..57f9c641779f 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -3144,7 +3144,8 @@ static void selinux_inode_getsecid(const struct inode *inode, u32 *secid)
>  
>  static int selinux_inode_copy_up(struct dentry *src, struct dentry *dst)
>  {
> -	return 0;
> +	const struct cred *cred = current_cred();
> +	return dentry_has_perm(cred, src, FILE__OPEN | FILE__READ);
>  }

Won't this get checked anyway when overlayfs calls vfs helpers to open
the source and those vfs helpers call the security hooks and apply the
usual checks?

Or, if not, where do you check permissions for the destination?

