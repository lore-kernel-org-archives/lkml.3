Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933230AbaLDWAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 17:00:38 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:52616 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbaLDWAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 17:00:36 -0500
Message-ID: <1417730375.5583.2.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH] KEYS: Fix stale key registration at error path
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: David Howells <dhowells@redhat.com>, David Safford <safford@us.ibm.com>,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org
Date: Thu, 04 Dec 2014 16:59:35 -0500
In-Reply-To: <1417713919-5342-1-git-send-email-tiwai@suse.de>
References: <1417713919-5342-1-git-send-email-tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120422-0033-0000-0000-000000AB3C21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-12-04 at 18:25 +0100, Takashi Iwai wrote: 
> When loading encrypted-keys module, if the last check of
> aes_get_sizes() in init_encrypted() fails, the driver just returns an
> error without unregistering its key type.  This results in the stale
> entry in the list.  In addition to memory leaks, this leads to a kernel
> crash when registering a new key type later.
> 
> This patch fixes the problem by swapping the calls of aes_get_sizes()
> and register_key_type(), and releasing resources properly at the error
> paths.
> 
> Bugzilla: https://bugzilla.opensuse.org/show_bug.cgi?id=908163
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>

Thanks!

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>

> ---
>  security/keys/encrypted-keys/encrypted.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/security/keys/encrypted-keys/encrypted.c b/security/keys/encrypted-keys/encrypted.c
> index db9675db1026..7bed4ad7cd76 100644
> --- a/security/keys/encrypted-keys/encrypted.c
> +++ b/security/keys/encrypted-keys/encrypted.c
> @@ -1017,10 +1017,13 @@ static int __init init_encrypted(void)
>  	ret = encrypted_shash_alloc();
>  	if (ret < 0)
>  		return ret;
> +	ret = aes_get_sizes();
> +	if (ret < 0)
> +		goto out;
>  	ret = register_key_type(&key_type_encrypted);
>  	if (ret < 0)
>  		goto out;
> -	return aes_get_sizes();
> +	return 0;
>  out:
>  	encrypted_shash_release();
>  	return ret;


