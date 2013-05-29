Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966243Ab3E2Ohv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 10:37:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36364 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966104Ab3E2Ohu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 10:37:50 -0400
Date: Wed, 29 May 2013 09:37:44 -0500
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Stephen Mell <sub.atomic.fusion@gmail.com>
Cc: linux-kernel@vger.kernel.org, Serge Hallyn <serge.hallyn@canonical.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Andrew Morgan <morgan@kernel.org>
Subject: Re: securebits: add exec_inherit flag to prevent changes to process
 credentials during execve
Message-ID: <20130529143744.GB15072@sergelap>
References: <4537875.yLSqQy2YHM@pegasus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4537875.yLSqQy2YHM@pegasus>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Mell (sub.atomic.fusion@gmail.com):
> From: Stephen Mell <sub.atomic.fusion@gmail.com>
> 
> Currently, it is nearly impossible to give a capability to a non-root
> user that will stick around after the first execve.

By design capabilities are re-calculated upon every execve.  The point
here is that you're not just trusting $user with the capability, you're
trusting the program with the capability as well.  Despite what we do
for the root user, if you drop the idea that you're also trusting the
binary, and say "$user can run anything with those capabilities", then
it's no longer posix caps.

If you want to introduce a new LSM which does non-posix capabilities,
that could be interesting.  But every little tweak will likely generate
a heap of side effects that will take time to consider/discover.

The libcap-ng way of addressing this would be to have the program run as
root with a capability bounding set which only allows the capabilities
you want the user to have.

> This patch adds a
> new securebit, exec_inherit, which causes all credential modification
> logic to be skipped. This is already possible, in a hackish fashion,
> if a program reads another program into memory and jumps into it. This
> patch would allow this to be done in a more consistent and less hacky
> manner. Moreover, the sendmail exploit of old would not happen again,
> as setuid and capability bits on programs are disregarded when
> exec_inherit is active.
> Use cases include allowing non-root users to bind to low numbered ports and use chroot. The securebit could be set in a pam module.

Non-root users can do that in a private user namespace.

> Signed-off-by: Stephen Mell <sub.atomic.fusion@gmail.com>
> ---
>  include/uapi/linux/securebits.h | 12 +++++++++++-
>  security/commoncap.c            |  5 +++++
>  2 files changed, 16 insertions(+), 1 deletion(-)
> diff --git a/include/uapi/linux/securebits.h b/include/uapi/linux/securebits.h
> index 985aac9..b779489 100644
> --- a/include/uapi/linux/securebits.h
> +++ b/include/uapi/linux/securebits.h
> @@ -40,12 +40,22 @@
>  #define SECURE_KEEP_CAPS		4
>  #define SECURE_KEEP_CAPS_LOCKED		5  /* make bit-4 immutable */
>  
> +/* When set, a process retains its capabilities when performing an
> +   execve(). No modifications, such as those from suid bits or file
> +   capabilities, are made. */
> +#define SECURE_EXEC_INHERIT		6
> +#define SECURE_EXEC_INHERIT_LOCKED	7  /* make bit-6 immutable */
> +
> +#define SECBIT_EXEC_INHERIT	(issecure_mask(SECURE_EXEC_INHERIT))
> +#define SECBIT_EXEC_INHERIT_LOCKED (issecure_mask(SECURE_EXEC_INHERIT_LOCKED))
> +
>  #define SECBIT_KEEP_CAPS	(issecure_mask(SECURE_KEEP_CAPS))
>  #define SECBIT_KEEP_CAPS_LOCKED (issecure_mask(SECURE_KEEP_CAPS_LOCKED))
>  
>  #define SECURE_ALL_BITS		(issecure_mask(SECURE_NOROOT) | \
>  				 issecure_mask(SECURE_NO_SETUID_FIXUP) | \
> -				 issecure_mask(SECURE_KEEP_CAPS))
> +				 issecure_mask(SECURE_KEEP_CAPS) | \
> +				 issecure_mask(SECURE_EXEC_INHERIT))
>  #define SECURE_ALL_LOCKS	(SECURE_ALL_BITS << 1)
>  
>  #endif /* _UAPI_LINUX_SECUREBITS_H */
> diff --git a/security/commoncap.c b/security/commoncap.c
> index c44b6fe..998ee6e 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -484,6 +484,11 @@ int cap_bprm_set_creds(struct linux_binprm *bprm)
>  	int ret;
>  	kuid_t root_uid;
>  
> +	if (issecure(SECURE_EXEC_INHERIT)) {
> +		*new = *old;
> +		return 0;
> +	}
> +
>  	effective = false;
>  	ret = get_file_caps(bprm, &effective, &has_cap);
>  	if (ret < 0)
