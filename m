Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbbALPVW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 10:21:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47495 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbbALPVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 10:21:20 -0500
Date: Mon, 12 Jan 2015 10:21:12 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com
Subject: Re: [PATCH] TaskTracker : Simplified thread information tracker.
Message-ID: <20150112152112.GA30774@madcap2.tricolour.ca>
References: <20141007213054.GJ26201@madcap2.tricolour.ca>
 <201410102140.HHB30768.tFVJSFQOMLOOFH@I-love.SAKURA.ne.jp>
 <20141010124923.GD2966@madcap2.tricolour.ca>
 <201501042050.EEH30201.FJVtFHMQOLSFOO@I-love.SAKURA.ne.jp>
 <20150105180743.GI29998@madcap2.tricolour.ca>
 <201501121513.GAD65121.OOJQVSFFLOFMHt@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201501121513.GAD65121.OOJQVSFFLOFMHt@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/01/12, Tetsuo Handa wrote:
> Thank you for comments.
> 
> Richard Guy Briggs wrote:
> > Steve already mentioned any user-influenced fields need to be escaped,
> > so I'd recommend audit_log_untrustedstring() as being much simpler from
> > your perspective and much better tested and understood from audit
> > maintainer's perspective.  At least use the existing 'o' printf format
> > specifier instead of inventing your own.  I do acknowledge that the
> > resulting output from your function is easier to read in its raw format
> > passed from the kernel, however, it makes your code harder to maintain.
> 
> I'm not sure whether I should use audit_log_untrustedstring().
> 
> This record contains multiple user-influenced comm names. If I use
> audit_log_untrustedstring(), I would need to split this record into
> multiple records like history[0]='...' history[1]='...' history[2]='...'
> in order to avoid matching delimiters (i.e. ';', '=' and '>') used in
> this record. This would also change from "char *" in "struct task_struct"
> to array of struct { "comm name", "pid", "stamp" } in "struct task_struct".
> I don't know whether such change makes easier to maintain than now.

This will end up producing a varying number of fields.  The userspace
tools are looking for a constant number of fields per record type.

> > As for the date-stamping bits, they seem to be the majority of the code
> > in audit_update_history().  I'd just emit a number and punt that to
> > userspace for decoding.  Alternatively, I'd use an existing service in
> > the kernel to do that date formatting, or at least call a new function
> > to format that date string should a suitable one not already exist, so
> > you can remove that complexity from audit_update_history().
> 
> Since I don't know existing functions for date formatting, I split it as
> a new function. If it is acceptable, I'd like to make that function public
> and replace tomoyo_convert_time() in security/tomoyo/util.c with that
> function.

That is an improvement, but would still like to see existing functions
used or punt to userspace.

> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index 072566d..2edeba2 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -1344,6 +1354,17 @@ out:
>  	audit_log_end(ab);
>  }
>  
> +static void audit_log_history(struct audit_context *context)
> +{
> +	struct audit_buffer *ab;
> +
> +	ab = audit_log_start(context, GFP_KERNEL, AUDIT_PROCHISTORY);
> +	if (!ab)
> +		return;	/* audit_panic or being filtered */
> +	audit_log_format(ab, "history='%s'", current->comm_history);

This is where I would seperate them to:

	audit_log_format(ab, "history=");
	audit_log_untrustedstring(ab, current->comm_history);

Making sure, of course, that there are no NULLs printed from any of the
comm fields (which should be impossible due to your "if (!c) break;").

> +	audit_log_end(ab);
> +}
> +
>  static void audit_log_exit(struct audit_context *context, struct task_struct *tsk)
>  {
...
> +void audit_update_history(void)
> +		*cp++ = '\\';
> +		*cp++ = (c >> 6) + '0';
> +		*cp++ = ((c >> 3) & 7) + '0';
> +		*cp++ = (c & 7) + '0';

Is there a reason you are not using the printf 'o' octal converter?

> +	/* Append timestamp. */
> +	{
> +		struct yyyymmdd_hhmmss stamp;
> +
> +		tt_get_time(&stamp);
> +		cp += snprintf(cp, buf - cp + sizeof(buf) - 1,
> +			       ";start=%04u%02u%02u%02u%02u%02u", stamp.year,
> +			       stamp.month, stamp.day, stamp.hour, stamp.min,
> +			       stamp.sec);
> +	}

Why not just return a string?  Better yet, punt to userspace.

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
