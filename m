Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760581Ab3GaPp6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 11:45:58 -0400
Received: from smtp103.biz.mail.bf1.yahoo.com ([98.139.221.62]:22911 "HELO
	smtp103.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756599Ab3GaPpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 11:45:55 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: D7p6Sk0VM1n7P3Zx3WnSx4DCkRge532oK5OEhJbe4LusX0w
 QGA3te0ziUqhf0XVp7pGTyVHKWaL1aQsBy3avnPlPFD1Uz.p1a85n76rbIA3
 8ev14nyJiF2lJ1icbwRR75egIAhfdDQKkEs639.y0qKb_CZIbwvx02quJQfw
 7ma4wSykEgWPsXk55A4uAYI9vB3cTkWdBucB0tnPJsjOG6aCE.am2.iEXDkC
 nH8dSsTG.n.S7.f94FhwggYB.LvO.c3aSKsPY2tgKe9ndmkeN0Bho7u.5XRW
 t_3m_gUEypCfh0XuC48.LKMfpUy8mi5FAzUkz6McRRH6I.507jHMYb4d4riw
 iN964RJCxpKAYCQdKX7lu6HLzcIYLNVn0j1B0cTC.t788qS8T_2o2duXsl16
 EJucbFlbs8Es_G3mFWP2FyPBK4L3o6iE5dgC2uhw1eQa_WH9xkYTUj2KV0pT
 M4GsE2NA6V4hKIJs_Aorlc44BWL5YF3QTd6D8yjaAmb7AuiO_24.3SXlncdf
 Ra87cEL28N_Oi
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with )
        by smtp103.biz.mail.bf1.yahoo.com with SMTP; 31 Jul 2013 08:45:54 -0700 PDT
Message-ID: <51F93130.6040506@schaufler-ca.com>
Date: Wed, 31 Jul 2013 08:45:52 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Paul Moore <paul@paul-moore.com>
CC: LKLM <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        SE Linux <selinux@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
        John Johansen <john.johansen@canonical.com>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH v14 5/6] LSM: SO_PEERSEC configuration options
References: <51F16CFB.6040603@schaufler-ca.com> <51F16F37.6040708@schaufler-ca.com> <6712209.BXb1SVfVxH@sifl>
In-Reply-To: <6712209.BXb1SVfVxH@sifl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/30/2013 2:47 PM, Paul Moore wrote:
> On Thursday, July 25, 2013 11:32:23 AM Casey Schaufler wrote:
>> Subject: [PATCH v14 5/6] LSM: SO_PEERSEC configuration options
>>
>> Refine the handling of SO_PEERSEC to enable legacy
>> user space runtimes, Fedora in particular, when running
>> with multiple LSMs that are capable of providing information
>> using getsockopt(). This introduces an additional configuration
>> option, and requires that the default be the legacy behavior.
>>
>> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> ...
>
>> --- a/security/Kconfig
>> +++ b/security/Kconfig
>> @@ -157,17 +157,49 @@ config SECMARK_LSM
>>  	help
>>  	  The name of the LSM to use with the networking secmark
>>
>> -config SECURITY_PLAIN_CONTEXT
>> -	bool "Backward compatable contexts without lsm='value' formatting"
>> -	depends on SECURITY_SELINUX || SECURITY_SMACK
>> -	default y
>> +choice
>> +	depends on SECURITY && (SECURITY_SELINUX || SECURITY_SMACK)
>> +	prompt "Peersec LSM"
>> +	default PEERSEC_SECURITY_FIRST
>> +
>>  	help
>> -	  Without this value set security context strings will
>> -	  include the name of the lsm with which they are associated
>> -	  even if there is only one LSM that uses security contexts.
>> -	  This matches the way contexts were handled before it was
>> -	  possible to have multiple concurrent security modules.
>> -	  If you are unsure how to answer this question, answer Y.
>> +	  Select the security module that will send attribute
>> +	  information in IP header options.
>> +	  Most SELinux configurations do not take advantage
>> +	  of Netlabel, while all Smack configurations do. Unless
>> +	  there is a need to do otherwise chose Smack in preference
>> +	  to SELinux.
> I'm not hugely in love with the help text; the first sentence seems to be all 
> that is needed, the second seems unnecessary and not exactly fair to the LSMs.

I can take out the "friendly advice". What it really should say
is more on the lines of:

	If you have gotten to the point where you have to make
	this decision you should probably call it a work day, go
	home, have a nice drink and spend some time with a loved
	one. In the morning take a good hard look at your network
	configuration. You may end up with a different security
	policies being enforced with IPv4 and IPv6 communications.

>
>> +	config PEERSEC_SECURITY_FIRST
>> +		bool "First LSM providing for SO_PEERSEC"
>> +		help
>> +		  Provide the first available LSM's information with SO_PEERSEC
>> +
>> +	config PEERSEC_SECURITY_ALL
>> +		bool "Use lsm='value'lsm='value' format"
>> +		help
>> +		  Provide all available security information in SO_PEERSEC
>> +
>> +	config PEERSEC_SECURITY_SELINUX
>> +		bool "SELinux" if SECURITY_SELINUX=y
>> +		help
>> +		  Provide SELinux context with SO_PEERSEC
>> +
>> +	config PEERSEC_SECURITY_SMACK
>> +		bool "Smack" if SECURITY_SMACK=y
>> +		help
>> +		  Provide Smack labels with SO_PEERSEC
>> +
>> +endchoice
>> +
>> +config PEERSEC_LSM
>> +	string
>> +	default "smack" if PEERSEC_SECURITY_SMACK
>> +	default "selinux" if PEERSEC_SECURITY_SELINUX
>> +	default "(all)" if PEERSEC_SECURITY_ALL
>> +	default "(first)"
>> +	help
>> +	  The name of the LSM to use with Netlabel
>>
>>  config SECURITY_PATH
>>  	bool "Security hooks for pathname based access control"

