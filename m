Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758464Ab3LFSri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 13:47:38 -0500
Received: from smtp106.biz.mail.ne1.yahoo.com ([98.138.207.13]:44995 "HELO
	smtp106.biz.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753996Ab3LFSrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 13:47:36 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Dec 2013 13:47:36 EST
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: W_xvfGUVM1lSEBJ7vGBpg0bzd_2xJ9ct2l5LGOLoV3P2gjY
 1jb1q.6AEaoyTajTfZTnikSYfNFD.jlVsZXVshSafo8sMIb9koco2_9EgGd7
 ZCZGAJ5KENvSCs9dgc8UUbQ79ETp31J90a.T4P92AJ2cXg6YmriSaxQX7LTZ
 0a3xjJHN0VMtChTpUcNiRhhXzlgEJxO1xTZtZ5Mxt.maSL_fqod7QDvlSXCO
 IxkwcxGkR8mxXxlNTl7R2ydP1.QIIkSt3LUFOIikA2v31TXot.RFVnOWncRW
 ydu19Cgy2hh_hdz6YzHwG7q3uWowMxqypF2blPSFHcIieGCSUS3AmbSl9f6q
 FQ3vFOhzpUiOiUyk1FOQhUcu9gzwGDSKCWBrLOfaW40XkoHiTCCtX7WSH2qF
 caaWWbDQos2b52iU3UI.9d4BKSNPsDut_yxqxGuH5rc91AdX.uaok1vWVLzM
 EBFIgMAJCRyEyuHbpfhQS7wkK8Fbmv02vchaj0rEX1dWJwiX6t9SadbUkqvR
 j.gajzjjxLjmbYIP86Qx5zKD4fbsJIEWgEr_adRi6lPpKQsjaKQ--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.105] (casey@67.180.103.242 with )
        by smtp106.biz.mail.ne1.yahoo.com with SMTP; 06 Dec 2013 10:40:56 -0800 PST
Message-ID: <52A21A38.40802@schaufler-ca.com>
Date: Fri, 06 Dec 2013 10:40:56 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Richard Guy Briggs <rgb@redhat.com>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org
CC: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 2/3] smack: call WARN_ONCE() instead of calling audit_log_start()
References: <1382713941.2954.19.camel@flatline.rdu.redhat.com> <f18b900087454601b1431183f705f61acd4932c7.1386206544.git.rgb@redhat.com>
In-Reply-To: <f18b900087454601b1431183f705f61acd4932c7.1386206544.git.rgb@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/4/2013 6:45 PM, Richard Guy Briggs wrote:
> Remove the call to audit_log() (which call audit_log_start()) and deal with
> the errors in the caller, logging only once if the condition is met.  Calling
> audit_log_start() in this location makes buffer allocation and locking more
> complicated in the calling tree (audit_filter_user()).
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>

I'm not opposed to this change, but have you actually tried it?

> ---
>  security/smack/smack_lsm.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 8825375..185e2e7 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -3615,9 +3615,8 @@ static int smack_audit_rule_match(u32 secid, u32 field, u32 op, void *vrule,
>  	struct smack_known *skp;
>  	char *rule = vrule;
>  
> -	if (!rule) {
> -		audit_log(actx, GFP_ATOMIC, AUDIT_SELINUX_ERR,
> -			  "Smack: missing rule\n");
> +	if (unlikely(!rule)) {
> +		WARN_ONCE(1, "Smack: missing rule\n");
>  		return -ENOENT;
>  	}
>  

