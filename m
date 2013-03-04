Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137Ab3CDNtG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 08:49:06 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:58864 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755900Ab3CDNtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 08:49:03 -0500
Message-ID: <1362404916.4392.25.camel@falcor1>
Subject: Re: [PATCH 2/6] ima: Return INTEGRITY_FAIL if digital signature
 can't be verified
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@intel.com
Date: Mon, 04 Mar 2013 08:48:36 -0500
In-Reply-To: <1360871745-20616-3-git-send-email-vgoyal@redhat.com>
References: <1360871745-20616-1-git-send-email-vgoyal@redhat.com>
	 <1360871745-20616-3-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030413-7182-0000-0000-000005A12840
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-14 at 14:55 -0500, Vivek Goyal wrote:
> Digital signature verification happens using integrity_digsig_verify().
> Curently we set integrity to FAIL for all error codes except -EOPNOTSUPP.
> This sounds out of line.
> 
> - If appropriate kernel code is not compiled in to verify signature of
>   a file, then prractically it is a failed signature.
> 
> - For so many other possible errors we are setting the status to fail.
>   For example, -EINVAL, -ENOKEY, -ENOMEM, -EINVAL, -ENOTSUPP etc, it
>   beats me that why -EOPNOTSUPP is special.
> 
> This patch should make the semantics more consistent. That is, if digital
> signature is present in security.ima, then any error happened during
> signature processing leads to status INTEGRITY_FAIL.
> 
> AFAICS, it should not have any user visible effect on existing
> application. In some cases we will start returning INTEGRITY_FAIL
> instead of INTEGRITY_UNKNOWN. And process_measurement() will deny access
> to file both in case of INTEGRITY_UNKNOWN and INTEGRITY_FAIL.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

A number of patches in this patchset more finely differentiate return
codes, which is good.  I agree with you totally that there is no good
reason for -EOPNOTSUPP to be handled differently.  Unfortunately, the
initramfs is CPIO, which doesn't support xattrs.  With the proposed
change and 'ima_appraise_tcb' flag enabled, we wouldn't be able to boot.
I really dislike hard coding policy in the kernel.

thanks,

Mimi

> ---
>  security/integrity/ima/ima_appraise.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
> index 3710f44..6f1eeb8 100644
> --- a/security/integrity/ima/ima_appraise.c
> +++ b/security/integrity/ima/ima_appraise.c
> @@ -178,9 +178,7 @@ int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
>  					     xattr_value->digest, rc - 1,
>  					     iint->ima_xattr.digest,
>  					     IMA_DIGEST_SIZE);
> -		if (rc == -EOPNOTSUPP) {
> -			status = INTEGRITY_UNKNOWN;
> -		} else if (rc) {
> +		if (rc) {
>  			cause = "invalid-signature";
>  			status = INTEGRITY_FAIL;
>  		} else {



