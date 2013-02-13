Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760582Ab3BMUfm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 15:35:42 -0500
Received: from fieldses.org ([174.143.236.118]:40622 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803Ab3BMUfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 15:35:41 -0500
Date: Wed, 13 Feb 2013 15:35:28 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-fsdevel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [PATCH review 48/85] sunrpc: Update gss uid to security context
 mapping.
Message-ID: <20130213203528.GN14195@fieldses.org>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
 <1360777934-5663-48-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360777934-5663-48-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 09:51:37AM -0800, Eric W. Biederman wrote:
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> - Use from_kuid when generating the on the wire uid values.
> - Use make_kuid when reading on the wire values.
> 
> In gss_encode_v0_msg, since the uid in gss_upcall_msg is now a kuid_t
> generate the necessary uid_t value on the stack copy it into
> gss_msg->databuf where it can safely live until the message is no
> longer needed.

Apologies, I haven't been following the user namespace work.

If I understand correctly, you're expecting the id's seen in nfs
protocol messages to be the same as the id's seen in the initial user
namespace.

Why is that right, and not, say, the user namespace in which the mount
was originally performed?  (Just asking, I honestly haven't thought
about it before.)

Also:

> diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
> index afbbcfb..a360067 100644
> --- a/net/sunrpc/auth_gss/auth_gss.c
> +++ b/net/sunrpc/auth_gss/auth_gss.c
> @@ -395,8 +395,11 @@ gss_upcall_callback(struct rpc_task *task)
>  
>  static void gss_encode_v0_msg(struct gss_upcall_msg *gss_msg)
>  {
> -	gss_msg->msg.data = &gss_msg->uid;
> -	gss_msg->msg.len = sizeof(gss_msg->uid);
> +	uid_t uid = from_kuid(&init_user_ns, gss_msg->uid);
> +	memcpy(gss_msg->databuf, &uid, sizeof(uid));
> +	gss_msg->msg.data = gss_msg->databuf;
> +	gss_msg->msg.len = sizeof(uid);
> +	BUG_ON(sizeof(uid) > UPCALL_BUF_LEN);

This message is going to gssd, not to the server.  Should it be encoded
for whatever namespace gssd lives in?

--b.

>  }
>  
>  static void gss_encode_v1_msg(struct gss_upcall_msg *gss_msg,
> @@ -409,7 +412,7 @@ static void gss_encode_v1_msg(struct gss_upcall_msg *gss_msg,
>  
>  	gss_msg->msg.len = sprintf(gss_msg->databuf, "mech=%s uid=%d ",
>  				   mech->gm_name,
> -				   gss_msg->uid);
> +				   from_kuid(&init_user_ns, gss_msg->uid));
>  	p += gss_msg->msg.len;
>  	if (clnt->cl_principal) {
>  		len = sprintf(p, "target=%s ", clnt->cl_principal);
> @@ -620,7 +623,8 @@ gss_pipe_downcall(struct file *filp, const char __user *src, size_t mlen)
>  	struct gss_upcall_msg *gss_msg;
>  	struct rpc_pipe *pipe = RPC_I(filp->f_dentry->d_inode)->pipe;
>  	struct gss_cl_ctx *ctx;
> -	uid_t uid;
> +	uid_t id;
> +	kuid_t uid;
>  	ssize_t err = -EFBIG;
>  
>  	if (mlen > MSG_BUF_MAXSIZE)
> @@ -635,12 +639,18 @@ gss_pipe_downcall(struct file *filp, const char __user *src, size_t mlen)
>  		goto err;
>  
>  	end = (const void *)((char *)buf + mlen);
> -	p = simple_get_bytes(buf, end, &uid, sizeof(uid));
> +	p = simple_get_bytes(buf, end, &id, sizeof(id));
>  	if (IS_ERR(p)) {
>  		err = PTR_ERR(p);
>  		goto err;
>  	}
>  
> +	uid = make_kuid(&init_user_ns, id);
> +	if (!uid_valid(uid)) {
> +		err = -EINVAL;
> +		goto err;
> +	}
> +
>  	err = -ENOMEM;
>  	ctx = gss_alloc_context();
>  	if (ctx == NULL)
> -- 
> 1.7.5.4
> 
