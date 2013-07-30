Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817Ab3G3VrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 17:47:20 -0400
Received: from mail-gh0-f180.google.com ([209.85.160.180]:53343 "EHLO
	mail-gh0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756924Ab3G3VrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 17:47:18 -0400
From: Paul Moore <paul@paul-moore.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: LKLM <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        SE Linux <selinux@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
        John Johansen <john.johansen@canonical.com>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v14 5/6] LSM: SO_PEERSEC configuration options
Date: Tue, 30 Jul 2013 17:47:14 -0400
Message-ID: <6712209.BXb1SVfVxH@sifl>
User-Agent: KMail/4.10.5 (Linux/3.10.2-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <51F16F37.6040708@schaufler-ca.com>
References: <51F16CFB.6040603@schaufler-ca.com> <51F16F37.6040708@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 25, 2013 11:32:23 AM Casey Schaufler wrote:
> Subject: [PATCH v14 5/6] LSM: SO_PEERSEC configuration options
> 
> Refine the handling of SO_PEERSEC to enable legacy
> user space runtimes, Fedora in particular, when running
> with multiple LSMs that are capable of providing information
> using getsockopt(). This introduces an additional configuration
> option, and requires that the default be the legacy behavior.
> 
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

...

> --- a/security/Kconfig
> +++ b/security/Kconfig
> @@ -157,17 +157,49 @@ config SECMARK_LSM
>  	help
>  	  The name of the LSM to use with the networking secmark
> 
> -config SECURITY_PLAIN_CONTEXT
> -	bool "Backward compatable contexts without lsm='value' formatting"
> -	depends on SECURITY_SELINUX || SECURITY_SMACK
> -	default y
> +choice
> +	depends on SECURITY && (SECURITY_SELINUX || SECURITY_SMACK)
> +	prompt "Peersec LSM"
> +	default PEERSEC_SECURITY_FIRST
> +
>  	help
> -	  Without this value set security context strings will
> -	  include the name of the lsm with which they are associated
> -	  even if there is only one LSM that uses security contexts.
> -	  This matches the way contexts were handled before it was
> -	  possible to have multiple concurrent security modules.
> -	  If you are unsure how to answer this question, answer Y.
> +	  Select the security module that will send attribute
> +	  information in IP header options.
> +	  Most SELinux configurations do not take advantage
> +	  of Netlabel, while all Smack configurations do. Unless
> +	  there is a need to do otherwise chose Smack in preference
> +	  to SELinux.

I'm not hugely in love with the help text; the first sentence seems to be all 
that is needed, the second seems unnecessary and not exactly fair to the LSMs.

> +	config PEERSEC_SECURITY_FIRST
> +		bool "First LSM providing for SO_PEERSEC"
> +		help
> +		  Provide the first available LSM's information with SO_PEERSEC
> +
> +	config PEERSEC_SECURITY_ALL
> +		bool "Use lsm='value'lsm='value' format"
> +		help
> +		  Provide all available security information in SO_PEERSEC
> +
> +	config PEERSEC_SECURITY_SELINUX
> +		bool "SELinux" if SECURITY_SELINUX=y
> +		help
> +		  Provide SELinux context with SO_PEERSEC
> +
> +	config PEERSEC_SECURITY_SMACK
> +		bool "Smack" if SECURITY_SMACK=y
> +		help
> +		  Provide Smack labels with SO_PEERSEC
> +
> +endchoice
> +
> +config PEERSEC_LSM
> +	string
> +	default "smack" if PEERSEC_SECURITY_SMACK
> +	default "selinux" if PEERSEC_SECURITY_SELINUX
> +	default "(all)" if PEERSEC_SECURITY_ALL
> +	default "(first)"
> +	help
> +	  The name of the LSM to use with Netlabel
> 
>  config SECURITY_PATH
>  	bool "Security hooks for pathname based access control"

-- 
paul moore
www.paul-moore.com

