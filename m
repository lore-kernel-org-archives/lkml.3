Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782Ab3EGPor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 11:44:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796Ab3EGPoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 11:44:46 -0400
Date: Tue, 7 May 2013 11:44:35 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: viro@zeniv.linux.org.uk, eparis@redhat.com, ebiederm@xmission.com,
        sgrubb@redhat.com, akpm@linux-foundation.org, serge.hallyn@ubuntu.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com
Subject: Re: [PATCH RFC 09/48] Audit: make audit_enabled per user namespace
Message-ID: <20130507154434.GA15275@redhat.com>
References: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com>
 <1367893269-9308-10-git-send-email-gaofeng@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367893269-9308-10-git-send-email-gaofeng@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 10:20:30AM +0800, Gao feng wrote:
> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index 684599b..33e6584 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -441,7 +441,8 @@ extern int audit_filter_type(int type);
>  extern int  audit_receive_filter(int type, int pid, int seq,
>  				void *data, size_t datasz, kuid_t loginuid,
>  				u32 sessionid, u32 sid);
> -extern int audit_enabled;
> +#define audit_enabled (init_user_ns.audit.enabled)
> +#define audit_enabled_ns (ns->audit.enabled)
>  #else /* CONFIG_AUDIT */
>  static inline __printf(4, 5)
>  void audit_log(struct audit_context *ctx, gfp_t gfp_mask, int type,
> @@ -487,6 +488,7 @@ static inline void audit_set_user_ns(struct user_namespace *ns)
>  static inline void audit_free_user_ns(struct user_namespace *ns)
>  { }
>  #define audit_enabled 0
> +#define audit_enabled_ns(ns) 0

conflicting definitions here. maybe the first one should be
	#define audit_enabled_ns(ns) (ns->audit.enabled)?

> @@ -285,14 +282,15 @@ static int audit_do_config_change(char *function_name, int *to_change,
>  				  u32 sid)
>  {
>  	int allow_changes, rc = 0, old = *to_change;
> +	struct user_namespace *ns = current_user_ns();
>  
>  	/* check if we are locked */
> -	if (audit_enabled == AUDIT_LOCKED)
> +	if (ns->audit.enabled == AUDIT_LOCKED)

then you don't use the macro you introduced?

> @@ -609,7 +608,7 @@ static int audit_log_common_recv_msg(struct audit_buffer **ab, u16 msg_type,
>  	char *ctx = NULL;
>  	u32 len;
>  
> -	if (!audit_enabled) {
> +	if (!init_user_ns.audit.enabled) {
>  		*ab = NULL;
>  		return rc;
>  	}

same here

-- 
Aristeu

