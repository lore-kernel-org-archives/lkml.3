Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbaJBI0s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 04:26:48 -0400
Received: from fm2nodo5.polito.it ([130.192.180.14]:44843 "EHLO
	fm2nodo5.polito.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbaJBI0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 04:26:43 -0400
X-ExtScanner: Niversoft's FindAttachments (free)
Message-ID: <542D0C33.2010700@polito.it>
Date: Thu, 02 Oct 2014 10:26:27 +0200
From: Roberto Sassu <roberto.sassu@polito.it>
Organization: Politecnico di Torino
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, zohar@linux.vnet.ibm.com,
        linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [Linux-ima-devel] [PATCH v2 3/4] ima: check appraisal flag in
 the ima_file_free() hook
References: <cover.1412188590.git.d.kasatkin@samsung.com> <600aeb6a5b8eca7eb381392e142ca71484717e9c.1412188590.git.d.kasatkin@samsung.com>
In-Reply-To: <600aeb6a5b8eca7eb381392e142ca71484717e9c.1412188590.git.d.kasatkin@samsung.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-FEAS-SYSTEM-WL: 130.192.180.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2014 08:43 PM, Dmitry Kasatkin wrote:
> ima_file_free() hook is only used by appraisal module to update hash
> when file was modified. When there were no integrity checks on inode,
> S_IMA flag is not set, integrity_iint_find() returns NULL and it
> quits. When inode is only measured/audited but not appraised, iint
> is allocated and it will cause calling ima_check_last_writer() which
> unnecessarily locks i_mutex.
>
> Currently ima_file_free() checks 'iint_initialized'. But it looks that
> it is a mistake and originally 'ima_appraise' had to be used instead.
> In fact usage of 'iint_initialized' is completely unnecessary because
> S_IMA flag would not be set if iint was not allocated.
>

Hi Dmitry

sorry, I think there are two mistakes here.

First, ima_file_free() is not used by the appraisal module only
because, if a file has been written, also the IMA_MEASURED
and IMA_AUDITED flags are cleared. Your patch prevents further
measurements/audits if a file is modified.

Second, the lock of i_mutex is necessary, as it protects the
access to the fields of the 'integrity_iint_cache' structure.

My suggestion is to provide a patch that fixes the commit a756024e
of Mimi's 'next' branch. The patch should just replace the check
of 'iint_initialized' with 'ima_policy_flag'. The removal of
'iint_initialized' could be done in a separate patch.

Thanks

Roberto Sassu


> This patch uses lately introduced ima_policy_flag to test if appraisal
> was enabled by policy.
>
> With this change 'iint_initialized' is no longer used anywhere. Indeed,
> integrity cache is allocated with SLAB_PANIC and kernel will panic if
> allocation fails during kernel initialization. So this variable is
> unnecessary and thus this patch removes it.
>
> Changes in v2:
> * 'iint_initialized' removal patch merged to this patch (requested
>     by Mimi)
>
> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> ---
>   security/integrity/iint.c         | 3 ---
>   security/integrity/ima/ima_main.c | 2 +-
>   security/integrity/integrity.h    | 3 ---
>   3 files changed, 1 insertion(+), 7 deletions(-)
>
> diff --git a/security/integrity/iint.c b/security/integrity/iint.c
> index a521edf..cc3eb4d 100644
> --- a/security/integrity/iint.c
> +++ b/security/integrity/iint.c
> @@ -25,8 +25,6 @@ static struct rb_root integrity_iint_tree = RB_ROOT;
>   static DEFINE_RWLOCK(integrity_iint_lock);
>   static struct kmem_cache *iint_cache __read_mostly;
>
> -int iint_initialized;
> -
>   /*
>    * __integrity_iint_find - return the iint associated with an inode
>    */
> @@ -166,7 +164,6 @@ static int __init integrity_iintcache_init(void)
>   	iint_cache =
>   	    kmem_cache_create("iint_cache", sizeof(struct integrity_iint_cache),
>   			      0, SLAB_PANIC, init_once);
> -	iint_initialized = 1;
>   	return 0;
>   }
>   security_initcall(integrity_iintcache_init);
> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> index 62f59ec..87d7df7 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -143,7 +143,7 @@ void ima_file_free(struct file *file)
>   	struct inode *inode = file_inode(file);
>   	struct integrity_iint_cache *iint;
>
> -	if (!iint_initialized || !S_ISREG(inode->i_mode))
> +	if (!(ima_policy_flag & IMA_APPRAISE) || !S_ISREG(inode->i_mode))
>   		return;
>
>   	iint = integrity_iint_find(inode);
> diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
> index aafb468..f51ad65 100644
> --- a/security/integrity/integrity.h
> +++ b/security/integrity/integrity.h
> @@ -169,6 +169,3 @@ static inline void integrity_audit_msg(int audit_msgno, struct inode *inode,
>   {
>   }
>   #endif
> -
> -/* set during initialization */
> -extern int iint_initialized;
>

