Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab3KJTwf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 14:52:35 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:35127 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab3KJTw1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 14:52:27 -0500
MIME-Version: 1.0
In-Reply-To: <1383945800-12060-1-git-send-email-shuah.kh@samsung.com>
References: <1383945800-12060-1-git-send-email-shuah.kh@samsung.com>
Date: Sun, 10 Nov 2013 21:52:25 +0200
Message-ID: <CACE9dm8t0F+772uX20xRoLHOmE0knC8Z881w0Z8H2eDc-Lnx-A@mail.gmail.com>
Subject: Re: [PATCH linux-next] security/integrity: Fix build error and
 warnings when CONFIG_INTEGRITY_ASYMMETRIC_KEYS is disabled
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: james.l.morris@oracle.com, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        David Howells <dhowells@redhat.com>,
        linux-security-module@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuahkhan@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Shuah,

Thanks for the patch.

If I am correct, Mimi has fixed already this error just recently.
But it did not get into James' tree yet...

http://git.kernel.org/cgit/linux/kernel/git/zohar/linux-integrity.git/commit/?h=next-fixes&id=f60bfa151cbe2e2eb6d5eaf84a3421405e7f282a

- Dmitry


On Fri, Nov 8, 2013 at 11:23 PM, Shuah Khan <shuah.kh@samsung.com> wrote:
> Fixed both linux-next build error and warnings with the following changes
>
> - define integrity_init_keyring() only when CONFIG_INTEGRITY_ASYMMETRIC_KEYS
>   is enabled
> - move integrity_init_keyring() stub from integrity.h
> - define integrity_init_keyring() prototype as an extern when
>   CONFIG_INTEGRITY_ASYMMETRIC_KEYS
>
> linux-next build fails with the following error when CONFIG_INTEGRITY_ASYMMETRIC_KEYS
> is disabled.
>
>   CC      security/integrity/digsig.o
> security/integrity/digsig.c:70:5: error: redefinition of ‘integrity_init_keyring’
>  int integrity_init_keyring(const unsigned int id)
>      ^
> In file included from security/integrity/digsig.c:22:0:
> security/integrity/integrity.h:149:12: note: previous definition of ‘integrity_init_keyring’ was here
>  static int integrity_init_keyring(const unsigned int id)
>             ^
> security/integrity/integrity.h:149:12: warning: ‘integrity_init_keyring’ defined but not used [-Wunused-function]
> make[2]: *** [security/integrity/digsig.o] Error 1
> make[1]: *** [security/integrity] Error 2
> make: *** [security] Error 2
>
> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> ---
>  security/integrity/digsig.c    | 7 +++++++
>  security/integrity/integrity.h | 8 ++------
>  2 files changed, 9 insertions(+), 6 deletions(-)
>
> diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
> index 77ca965..28bc1a7 100644
> --- a/security/integrity/digsig.c
> +++ b/security/integrity/digsig.c
> @@ -67,6 +67,7 @@ int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
>         return -EOPNOTSUPP;
>  }
>
> +#ifdef CONFIG_INTEGRITY_ASYMMETRIC_KEYS
>  int integrity_init_keyring(const unsigned int id)
>  {
>         const struct cred *cred = current_cred();
> @@ -84,3 +85,9 @@ int integrity_init_keyring(const unsigned int id)
>                         keyring_name[id], PTR_ERR(keyring[id]));
>         return 0;
>  }
> +#else
> +int integrity_init_keyring(const unsigned int id)
> +{
> +       return 0;
> +}
> +#endif
> diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
> index b9e7c13..99ac783 100644
> --- a/security/integrity/integrity.h
> +++ b/security/integrity/integrity.h
> @@ -134,22 +134,18 @@ static inline int integrity_digsig_verify(const unsigned int id,
>
>  #endif /* CONFIG_INTEGRITY_SIGNATURE */
>
> +extern int integrity_init_keyring(const unsigned int id);
> +
>  #ifdef CONFIG_INTEGRITY_ASYMMETRIC_KEYS
>  int asymmetric_verify(struct key *keyring, const char *sig,
>                       int siglen, const char *data, int datalen);
>
> -int integrity_init_keyring(const unsigned int id);
>  #else
>  static inline int asymmetric_verify(struct key *keyring, const char *sig,
>                                     int siglen, const char *data, int datalen)
>  {
>         return -EOPNOTSUPP;
>  }
> -
> -static int integrity_init_keyring(const unsigned int id)
> -{
> -       return 0;
> -}
>  #endif
>
>  #ifdef CONFIG_INTEGRITY_AUDIT
> --
> 1.8.3.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,
Dmitry
