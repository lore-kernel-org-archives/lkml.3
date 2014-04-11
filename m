Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbaDKV4c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 17:56:32 -0400
Received: from smtp105.biz.mail.ne1.yahoo.com ([98.138.207.12]:37819 "HELO
	smtp105.biz.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750842AbaDKV4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 17:56:31 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: gocCPfUVM1nyNftkmkr3jCl4O_.8G.3UqhNAZ0WPYNyGgZd
 esFO.IM8y.ZOHv410_qAfeYWhaNfjyM3L7IbmwTnprMGmDYsUWTuVPYL3KS6
 WvaJmo_5b2ETeIybWVdNJB51ERC3Auili2x_dewd49XJXWCVPrRkBWOVRXna
 t.cjDvapZbQA7SrPmym0hq3LOgaY9JCrtdRlRRZyKuIijDA0SnqVZIoSUVgC
 JHxzE2DEcuplPJ2vLMWmxjoLHuXTJSw.WYnLaoRz.Ns1MVwsyX3UXDWcQjB9
 ibpb7eA31txPvG.F9kdwmYBRObQveQ7Y6kCOXUqWMtaPFzniVwUwPxAZjEjL
 c2FAcbqu2yRranBWn.drhV3aVKo8p2bYCyQraFuvyXC5nVuu7d8VrwwWF4td
 e9.NbTS6cY_5B0f.jTqZXks6hUYbt3hrOGMBy6ENerpf15sjwz6ArkpXaF2g
 8KkqvUctawV2a2I1GQDJYyspj6Oe1pJOLiQU5zu89U_Fo2QaS2T5bUniV0KL
 3V2UOtyCzMazVlaW4JcwJHpjxQyxi4C_0F5SKH.omal17YZXcyKR1RDgfII6
 QbnJhuY5afQzyLmL7t_oyJQUOl8RFQKWjQniZP2dVFlzvSveTMj7mvl1h_ej
 gdPdHY9mkbg--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.105] (casey@67.180.103.242 with plain [98.138.105.25])
        by smtp105.biz.mail.ne1.yahoo.com with SMTP; 11 Apr 2014 14:49:50 -0700 PDT
Message-ID: <53486397.6040707@schaufler-ca.com>
Date: Fri, 11 Apr 2014 14:50:15 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Lukasz Pawelczyk <l.pawelczyk@partner.samsung.com>,
        James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
CC: r.krypa@samsung.com, t.swierczek@samsung.com
Subject: Re: [PATCH 3/3] Smack: adds smackfs/ptrace interface
References: <1394554026-23924-1-git-send-email-l.pawelczyk@partner.samsung.com> <1394554026-23924-4-git-send-email-l.pawelczyk@partner.samsung.com>
In-Reply-To: <1394554026-23924-4-git-send-email-l.pawelczyk@partner.samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/11/2014 9:07 AM, Lukasz Pawelczyk wrote:
> This allows to limit ptrace beyond the regular smack access rules.
> It adds a smackfs/ptrace interface that allows smack to be configured
> to require equal smack labels for PTRACE_MODE_ATTACH access.
> See the changes in Documentation/security/Smack.txt below for details.
>
> Signed-off-by: Lukasz Pawelczyk <l.pawelczyk@partner.samsung.com>
> Signed-off-by: Rafal Krypa <r.krypa@samsung.com>

Acked-by: Casey Schaufler <casey@schaufler-ca.com>

Applied to git://git.gitorious.org/smack-next/kernel.git smack-for-3.16

> ---
>  Documentation/security/Smack.txt | 10 ++++++
>  security/smack/smack.h           |  9 +++++
>  security/smack/smack_access.c    |  5 ++-
>  security/smack/smack_lsm.c       | 22 +++++++++++-
>  security/smack/smackfs.c         | 74 ++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 118 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/security/Smack.txt b/Documentation/security/Smack.txt
> index 7a2d30c..5597917 100644
> --- a/Documentation/security/Smack.txt
> +++ b/Documentation/security/Smack.txt
> @@ -204,6 +204,16 @@ onlycap
>  	these capabilities are effective at for processes with any
>  	label. The value is set by writing the desired label to the
>  	file or cleared by writing "-" to the file.
> +ptrace
> +	This is used to define the current ptrace policy
> +	0 - default: this is the policy that relies on smack access rules.
> +	    For the PTRACE_READ a subject needs to have a read access on
> +	    object. For the PTRACE_ATTACH a read-write access is required.
> +	1 - exact: this is the policy that limits PTRACE_ATTACH. Attach is
> +	    only allowed when subject's and object's labels are equal.
> +	    PTRACE_READ is not affected. Can be overriden with CAP_SYS_PTRACE.
> +	2 - draconian: this policy behaves like the 'exact' above with an
> +	    exception that it can't be overriden with CAP_SYS_PTRACE.
>  revoke-subject
>  	Writing a Smack label here sets the access to '-' for all access
>  	rules with that subject label.
> diff --git a/security/smack/smack.h b/security/smack/smack.h
> index b9dfc4e..fade085 100644
> --- a/security/smack/smack.h
> +++ b/security/smack/smack.h
> @@ -177,6 +177,14 @@ struct smk_port_label {
>  #define SMACK_CIPSO_MAXCATNUM           184     /* 23 * 8 */
>  
>  /*
> + * Ptrace rules
> + */
> +#define SMACK_PTRACE_DEFAULT	0
> +#define SMACK_PTRACE_EXACT	1
> +#define SMACK_PTRACE_DRACONIAN	2
> +#define SMACK_PTRACE_MAX	SMACK_PTRACE_DRACONIAN
> +
> +/*
>   * Flags for untraditional access modes.
>   * It shouldn't be necessary to avoid conflicts with definitions
>   * in fs.h, but do so anyway.
> @@ -245,6 +253,7 @@ extern struct smack_known *smack_net_ambient;
>  extern struct smack_known *smack_onlycap;
>  extern struct smack_known *smack_syslog_label;
>  extern const char *smack_cipso_option;
> +extern int smack_ptrace_rule;
>  
>  extern struct smack_known smack_known_floor;
>  extern struct smack_known smack_known_hat;
> diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
> index f161deb..c062e94 100644
> --- a/security/smack/smack_access.c
> +++ b/security/smack/smack_access.c
> @@ -304,7 +304,10 @@ static void smack_log_callback(struct audit_buffer *ab, void *a)
>  	audit_log_untrustedstring(ab, sad->subject);
>  	audit_log_format(ab, " object=");
>  	audit_log_untrustedstring(ab, sad->object);
> -	audit_log_format(ab, " requested=%s", sad->request);
> +	if (sad->request[0] == '\0')
> +		audit_log_format(ab, " labels_differ");
> +	else
> +		audit_log_format(ab, " requested=%s", sad->request);
>  }
>  
>  /**
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 3da13fd..1876bfc 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -178,7 +178,8 @@ static inline unsigned int smk_ptrace_mode(unsigned int mode)
>  /**
>   * smk_ptrace_rule_check - helper for ptrace access
>   * @tracer: tracer process
> - * @tracee_label: label of the process that's about to be traced
> + * @tracee_label: label of the process that's about to be traced,
> + *                the pointer must originate from smack structures
>   * @mode: ptrace attachment mode (PTRACE_MODE_*)
>   * @func: name of the function that called us, used for audit
>   *
> @@ -201,6 +202,25 @@ static int smk_ptrace_rule_check(struct task_struct *tracer, char *tracee_label,
>  	tsp = task_security(tracer);
>  	skp = smk_of_task(tsp);
>  
> +	if ((mode & PTRACE_MODE_ATTACH) &&
> +	    (smack_ptrace_rule == SMACK_PTRACE_EXACT ||
> +	     smack_ptrace_rule == SMACK_PTRACE_DRACONIAN)) {
> +		if (skp->smk_known == tracee_label)
> +			rc = 0;
> +		else if (smack_ptrace_rule == SMACK_PTRACE_DRACONIAN)
> +			rc = -EACCES;
> +		else if (capable(CAP_SYS_PTRACE))
> +			rc = 0;
> +		else
> +			rc = -EACCES;
> +
> +		if (saip)
> +			smack_log(skp->smk_known, tracee_label, 0, rc, saip);
> +
> +		return rc;
> +	}
> +
> +	/* In case of rule==SMACK_PTRACE_DEFAULT or mode==PTRACE_MODE_READ */
>  	rc = smk_tskacc(tsp, tracee_label, smk_ptrace_mode(mode), saip);
>  	return rc;
>  }
> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> index 3198cfe..177d878 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -53,6 +53,7 @@ enum smk_inos {
>  	SMK_REVOKE_SUBJ	= 18,	/* set rules with subject label to '-' */
>  	SMK_CHANGE_RULE	= 19,	/* change or add rules (long labels) */
>  	SMK_SYSLOG	= 20,	/* change syslog label) */
> +	SMK_PTRACE	= 21,	/* set ptrace rule */
>  };
>  
>  /*
> @@ -101,6 +102,15 @@ struct smack_known *smack_onlycap;
>  struct smack_known *smack_syslog_label;
>  
>  /*
> + * Ptrace current rule
> + * SMACK_PTRACE_DEFAULT    regular smack ptrace rules (/proc based)
> + * SMACK_PTRACE_EXACT      labels must match, but can be overriden with
> + *			   CAP_SYS_PTRACE
> + * SMACK_PTRACE_DRACONIAN  lables must match, CAP_SYS_PTRACE has no effect
> + */
> +int smack_ptrace_rule = SMACK_PTRACE_DEFAULT;
> +
> +/*
>   * Certain IP addresses may be designated as single label hosts.
>   * Packets are sent there unlabeled, but only from tasks that
>   * can write to the specified label.
> @@ -2244,6 +2254,68 @@ static const struct file_operations smk_syslog_ops = {
>  
>  
>  /**
> + * smk_read_ptrace - read() for /smack/ptrace
> + * @filp: file pointer, not actually used
> + * @buf: where to put the result
> + * @count: maximum to send along
> + * @ppos: where to start
> + *
> + * Returns number of bytes read or error code, as appropriate
> + */
> +static ssize_t smk_read_ptrace(struct file *filp, char __user *buf,
> +			       size_t count, loff_t *ppos)
> +{
> +	char temp[32];
> +	ssize_t rc;
> +
> +	if (*ppos != 0)
> +		return 0;
> +
> +	sprintf(temp, "%d\n", smack_ptrace_rule);
> +	rc = simple_read_from_buffer(buf, count, ppos, temp, strlen(temp));
> +	return rc;
> +}
> +
> +/**
> + * smk_write_ptrace - write() for /smack/ptrace
> + * @file: file pointer
> + * @buf: data from user space
> + * @count: bytes sent
> + * @ppos: where to start - must be 0
> + */
> +static ssize_t smk_write_ptrace(struct file *file, const char __user *buf,
> +				size_t count, loff_t *ppos)
> +{
> +	char temp[32];
> +	int i;
> +
> +	if (!smack_privileged(CAP_MAC_ADMIN))
> +		return -EPERM;
> +
> +	if (*ppos != 0 || count >= sizeof(temp) || count == 0)
> +		return -EINVAL;
> +
> +	if (copy_from_user(temp, buf, count) != 0)
> +		return -EFAULT;
> +
> +	temp[count] = '\0';
> +
> +	if (sscanf(temp, "%d", &i) != 1)
> +		return -EINVAL;
> +	if (i < SMACK_PTRACE_DEFAULT || i > SMACK_PTRACE_MAX)
> +		return -EINVAL;
> +	smack_ptrace_rule = i;
> +
> +	return count;
> +}
> +
> +static const struct file_operations smk_ptrace_ops = {
> +	.write		= smk_write_ptrace,
> +	.read		= smk_read_ptrace,
> +	.llseek		= default_llseek,
> +};
> +
> +/**
>   * smk_fill_super - fill the smackfs superblock
>   * @sb: the empty superblock
>   * @data: unused
> @@ -2296,6 +2368,8 @@ static int smk_fill_super(struct super_block *sb, void *data, int silent)
>  			"change-rule", &smk_change_rule_ops, S_IRUGO|S_IWUSR},
>  		[SMK_SYSLOG] = {
>  			"syslog", &smk_syslog_ops, S_IRUGO|S_IWUSR},
> +		[SMK_PTRACE] = {
> +			"ptrace", &smk_ptrace_ops, S_IRUGO|S_IWUSR},
>  		/* last one */
>  			{""}
>  	};

