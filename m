Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964958Ab3DKU4K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:56:10 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:35287 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab3DKU4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:56:04 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Serge Hallyn <serge.hallyn@canonical.com>
References: <20130411202503.783159048@goodmis.org>
	<20130411202604.512616100@goodmis.org>
Date: Thu, 11 Apr 2013 13:55:56 -0700
In-Reply-To: <20130411202604.512616100@goodmis.org> (Steven Rostedt's message
	of "Thu, 11 Apr 2013 16:26:54 -0400")
Message-ID: <8738uwvlb7.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18tPBhVyZiSyZM52RZ8oOuFByr4gRFohzM=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Steven Rostedt <rostedt@goodmis.org>
X-Spam-Relay-Country: 
Subject: Re: [ 111/171 ] ipc: Restrict mounting the mqueue filesystem
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> 3.6.11.2 stable review patch.
> If anyone has any objections, please let me know.

Mounting only with privilege in the user namespace only dates
back to 3.8 so this is not needed in 3.6.

Not that it should do any harm.

Eric

> ------------------
>
> From: "Eric W. Biederman" <ebiederm@xmission.com>
>
> [ Upstream commit a636b702ed1805e988ad3d8ff8b52c060f8b341c ]
>
> Only allow mounting the mqueue filesystem if the caller has CAP_SYS_ADMIN
> rights over the ipc namespace.   The principle here is if you create
> or have capabilities over it you can mount it, otherwise you get to live
> with what other people have mounted.
>
> This information is not particularly sensitive and mqueue essentially
> only reports which posix messages queues exist.  Still when creating a
> restricted environment for an application to live any extra
> information may be of use to someone with sufficient creativity.  The
> historical if imperfect way this information has been restricted has
> been not to allow mounts and restricting this to ipc namespace
> creators maintains the spirit of the historical restriction.
>
> Cc: stable@vger.kernel.org
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  ipc/mqueue.c |   12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/ipc/mqueue.c b/ipc/mqueue.c
> index 9e4cf7f..f1df4bc 100644
> --- a/ipc/mqueue.c
> +++ b/ipc/mqueue.c
> @@ -331,8 +331,16 @@ static struct dentry *mqueue_mount(struct file_system_type *fs_type,
>  			 int flags, const char *dev_name,
>  			 void *data)
>  {
> -	if (!(flags & MS_KERNMOUNT))
> -		data = current->nsproxy->ipc_ns;
> +	if (!(flags & MS_KERNMOUNT)) {
> +		struct ipc_namespace *ns = current->nsproxy->ipc_ns;
> +		/* Don't allow mounting unless the caller has CAP_SYS_ADMIN
> +		 * over the ipc namespace.
> +		 */
> +		if (!ns_capable(ns->user_ns, CAP_SYS_ADMIN))
> +			return ERR_PTR(-EPERM);
> +
> +		data = ns;
> +	}
>  	return mount_ns(fs_type, flags, data, mqueue_fill_super);
>  }
