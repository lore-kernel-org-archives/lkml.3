Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966696AbaFRN0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 09:26:19 -0400
Received: from smtp105.biz.mail.gq1.yahoo.com ([98.137.12.180]:32613 "HELO
	smtp105.biz.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S966671AbaFRN0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 09:26:18 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: KIfffjsVM1nsDraLE9xzIEIkie4j0SnADYjkCGQWPpZ8HEb
 oFHY10aye6IB17YULVS4O.Xsl9gM0PxUNE6HHHMBkLmkj2dDRI9UvTqLUCGH
 bJuymfU38lRUpDw2TxDkQFRFi3vqroYvfCB.LSLQprqqXttlqMucc5wek33_
 y11saLo7HWwh7Y0zP_Yw9uz_eJhth_iXMaevevqrn6frvfUYak9bmw8aMWdT
 g8Js8L8GQGEyLtlfCtz26bwJWrGHDmakZpA1Q5CHwLqbGigH0KZWF2jtXKQ5
 klW_K_s4kmqEnIOTFS5CLyc3tZbdA0rEwAaOD7ltpm_vmQrJFnkNAfX9NV4r
 iS9YxvPyGECvt4_623oT9YFNiZTkrgrPt.OXMUYKpux7FfGlpPj5j54ByqmX
 J4dGLq9yyzsnNtQcb_EDr5kAKEUd4D2ZJxkKOsUuLRRS5G1qxhIDZWhk4A4c
 Ax8ThcRC2GGsdj25ZGlccc3dT8p4ksf95fN80uEKX411PJbsW_O5rxExJFek
 gTGAVgCevO4v7uNI1K_9pQg--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.105] (casey@67.180.103.242 with plain [208.71.40.208])
        by smtp105.biz.mail.gq1.yahoo.com with SMTP; 18 Jun 2014 06:26:17 -0700 PDT
Message-ID: <53A1937F.5090806@schaufler-ca.com>
Date: Wed, 18 Jun 2014 06:26:23 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Chanho Park <chanho61.park@samsung.com>
CC: james.l.morris@oracle.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] Smack: separate smackfstransmute and smackfsroot
References: <1403095304-15368-1-git-send-email-chanho61.park@samsung.com>
In-Reply-To: <1403095304-15368-1-git-send-email-chanho61.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/18/2014 5:41 AM, Chanho Park wrote:
> According to previous commit(e830b39: Smack: Add smkfstransmute mount option),
> the smackfstransmute option is the smackfsroot option + transmute option.
> I think it can be confused because the transmute option can only have "TRUE".
> Before the patch, you cannot use the smackfsroot and the smackfstransmute at
> the same time. If you use the options simultaenously, the previous option will
> be omitted. In the below example, the smackfsroot option will be omitted.
> mount -t tmpfs -o size=128M,smackfsroot=*,smackfstransmute=_ tmpfs /tmp
>
> After the patch, now you can use the smackfstransmute option like below:
> mount -t tmpfs -o size=128M,smackfsroot=*,smackfstransmute=TRUE tmpfs /tmp
>
> Signed-off-by: Chanho Park <chanho61.park@samsung.com>

Nacked-by: Casey Schaufler <casey@schaufler-ca.com>

The smackfsroot option behaves as intended.
The smackfstransmute option behaves as intended.
There is no case where you want to mark the root inode
transmuting where you do not also want to set the
Smack label of that inode. Making the smackfstransmute
option require the smackfsroot option as well would be
unnecessary and inconvenient.

> ---
>  Documentation/security/Smack.txt | 3 +++
>  security/smack/smack.h           | 2 ++
>  security/smack/smack_lsm.c       | 5 ++---
>  3 files changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/security/Smack.txt b/Documentation/security/Smack.txt
> index b6ef7e9..27290d8 100644
> --- a/Documentation/security/Smack.txt
> +++ b/Documentation/security/Smack.txt
> @@ -669,6 +669,9 @@ Smack supports some mount options:
>  	smackfsfloor=label: specifies a label to which all labels set on the
>  	filesystem must have read access. Not yet enforced.
>  
> +	smackfstransmute=TRUE: assign a transmute option for the root of the
> +	file system if it lacks the Smack extended attribute.
> +
>  These mount options apply to all file system types.
>  
>  Smack auditing
> diff --git a/security/smack/smack.h b/security/smack/smack.h
> index 020307e..d4f75e6 100644
> --- a/security/smack/smack.h
> +++ b/security/smack/smack.h
> @@ -146,6 +146,8 @@ struct smk_port_label {
>  #define SMK_FSROOT	"smackfsroot="
>  #define SMK_FSTRANS	"smackfstransmute="
>  
> +#define SMK_FSTRANS_ON	"TRUE"
> +
>  #define SMACK_CIPSO_OPTION 	"-CIPSO"
>  
>  /*
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index f2c3080..7d3f40d 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -450,9 +450,8 @@ static int smack_sb_kern_mount(struct super_block *sb, int flags, void *data)
>  			}
>  		} else if (strncmp(op, SMK_FSTRANS, strlen(SMK_FSTRANS)) == 0) {
>  			op += strlen(SMK_FSTRANS);
> -			nsp = smk_import(op, 0);
> -			if (nsp != NULL) {
> -				sp->smk_root = nsp;
> +			if (strncmp(op, SMK_FSTRANS_ON,
> +				    strlen(SMK_FSTRANS_ON)) == 0) {
>  				transmute = 1;
>  				specified = 1;
>  			}

