Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932676AbaDBRkK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 13:40:10 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:32823 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932569AbaDBRkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 13:40:08 -0400
Message-ID: <1396460387.20325.22.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH] integrity: get comm using lock to avoid race in string
 printing
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, eparis@redhat.com,
        sgrubb@redhat.com
Date: Wed, 02 Apr 2014 13:39:47 -0400
In-Reply-To: <11db0d126ef0ec7506ef5cb6f2f21c926d206436.1396455228.git.rgb@redhat.com>
References: <11db0d126ef0ec7506ef5cb6f2f21c926d206436.1396455228.git.rgb@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040217-9332-0000-0000-0000005230A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-02 at 12:19 -0400, Richard Guy Briggs wrote: 
> When task->comm is passed directly to audit_log_untrustedstring() without
> getting a copy or using the task_lock, there is a race that could happen that
> would output a NULL (\0) in the output string that would effectively truncate
> the rest of the report text after the comm= field in the audit, losing fields.
> 
> Use get_task_comm() to get a copy while acquiring the task_lock to prevent
> this and to prevent the result from being a mixture of old and new values of
> comm.
> 
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  security/integrity/integrity_audit.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/security/integrity/integrity_audit.c b/security/integrity/integrity_audit.c
> index 85253b5..11706a2 100644
> --- a/security/integrity/integrity_audit.c
> +++ b/security/integrity/integrity_audit.c
> @@ -33,6 +33,7 @@ void integrity_audit_msg(int audit_msgno, struct inode *inode,
>  			 const char *cause, int result, int audit_info)
>  {
>  	struct audit_buffer *ab;
> +	char comm[sizeof(current->comm)];
> 
>  	if (!integrity_audit_info && audit_info == 1)	/* Skip info messages */
>  		return;
> @@ -49,7 +50,7 @@ void integrity_audit_msg(int audit_msgno, struct inode *inode,
>  	audit_log_format(ab, " cause=");
>  	audit_log_string(ab, cause);
>  	audit_log_format(ab, " comm=");
> -	audit_log_untrustedstring(ab, current->comm);
> +	audit_log_untrustedstring(ab, get_task_comm(comm, current));
>  	if (fname) {
>  		audit_log_format(ab, " name=");
>  		audit_log_untrustedstring(ab, fname);

This change is already being upstreamed as commit 73a6b44 "Integrity:
Pass commname via get_task_comm()".

thanks,

Mimi

