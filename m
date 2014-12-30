Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697AbaL3RH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 12:07:58 -0500
Received: from smtp107.biz.mail.bf1.yahoo.com ([98.139.244.55]:24698 "EHLO
	smtp107.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751454AbaL3RH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 12:07:56 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Xw4izFwVM1lqx_YbjPVTIQMUcaLpAlT9H4XEqoH2DhDY8Cy
 5Fu5eQJFDm5NAzm3uywf7.ZoqCGmrP1Ta88DiRdN6IqUlcxrMrS5UuVapaen
 DGFK3VIR89f1Mw22uGHagvRMIzkIcaZZ0Df437MvpVnHRphfxO2dm1aNDTdN
 8jqkKoqBi2.QAASgpeM5OP0.ShFMduU0zxFAcmrXFzVkS.pi2Qtvk.MfmTv2
 xg56T07iYYJ9SZDoVTEkuXztJ6dtfXFTG00MBe7UEA3dHtfcwygGcE2JGTOe
 PHUSkf6IMQ0xVB8EgS4Jy5ocSqNYK_XM5QjycSPSYun_kYJH3o5GC9Jn0KAX
 fz1ObdMdRJbHHt2baJAfujWzPlFeJ74h2dDsyb2Ho1S5aZ.6RapqveiO3OCE
 LN8WskAES.htrcLFGQ6ls3cCjyFbokjZAhc.aLrQh.xn.pjl7fJXrNAGbLkS
 MMVJApAQ1A9AOZKD830tTK.6_xAzQWMjHqt4vaQlc39gE.yNIpKs.n7HkRdI
 30Hgx2ZQCUkKw8XjKsMz5kxmZcxtSQuRNvPuizjAL902qyhHHSBNjLAidd_Q
 rMJFEluZK34e6CtyPORnkS9r47HxEcRSzl._11Wfs5Mono2SjC1jb1dp15b0
 tTcnR5zIlE50p
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <54A2DBEA.2060509@schaufler-ca.com>
Date: Tue, 30 Dec 2014 09:07:54 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Zbigniew Jasinski <z.jasinski@samsung.com>
CC: James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] smack: Fix a bidirectional UDS connect check typo
References: <1419863698-29558-1-git-send-email-z.jasinski@samsung.com>
In-Reply-To: <1419863698-29558-1-git-send-email-z.jasinski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/2014 6:34 AM, Zbigniew Jasinski wrote:
> The 54e70ec5eb090193b03e69d551fa6771a5a217c4 commit introduced a
> bidirectional check that should have checked for mutual WRITE access
> between two labels. Due to a typo subject's OUT label is checked with
> object's OUT. Should be OUT to IN.
>
> Signed-off-by: Zbigniew Jasinski <z.jasinski@samsung.com>

Applied to git://git.gitorious.org/smack-next/kernel.git#smack-for-3.20

> ---
>  security/smack/smack_lsm.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index b774029..30f61f8 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -3313,7 +3313,7 @@ static int smack_unix_stream_connect(struct sock *sock,
>  
>  	if (!smack_privileged(CAP_MAC_OVERRIDE)) {
>  		skp = ssp->smk_out;
> -		okp = osp->smk_out;
> +		okp = osp->smk_in;
>  #ifdef CONFIG_AUDIT
>  		smk_ad_init_net(&ad, __func__, LSM_AUDIT_DATA_NET, &net);
>  		smk_ad_setfield_u_net_sk(&ad, other);
> @@ -3321,6 +3321,8 @@ static int smack_unix_stream_connect(struct sock *sock,
>  		rc = smk_access(skp, okp, MAY_WRITE, &ad);
>  		rc = smk_bu_note("UDS connect", skp, okp, MAY_WRITE, rc);
>  		if (rc == 0) {
> +			okp = osp->smk_out;
> +			skp = ssp->smk_in;
>  			rc = smk_access(okp, skp, MAY_WRITE, NULL);
>  			rc = smk_bu_note("UDS connect", okp, skp,
>  						MAY_WRITE, rc);

