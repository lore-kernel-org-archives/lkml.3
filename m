Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbaAFRJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 12:09:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115AbaAFRJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 12:09:07 -0500
Date: Mon, 6 Jan 2014 18:08:56 +0100
From: Mateusz Guzik <mguzik@redhat.com>
To: William Roberts <bill.c.roberts@gmail.com>
Cc: linux-audit@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        rgb@redhat.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        sds@tycho.nsa.gov, William Roberts <wroberts@tresys.com>
Subject: Re: [RFC][PATCH 3/3] audit: Audit proc cmdline value
Message-ID: <20140106170855.GA1828@mguzik.redhat.com>
References: <1389022230-24664-1-git-send-email-wroberts@tresys.com>
 <1389022230-24664-3-git-send-email-wroberts@tresys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1389022230-24664-3-git-send-email-wroberts@tresys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can't comment on the concept, but have one nit.

On Mon, Jan 06, 2014 at 07:30:30AM -0800, William Roberts wrote:
> +static void audit_log_cmdline(struct audit_buffer *ab, struct task_struct *tsk,
> +			 struct audit_context *context)
> +{
> +	int res;
> +	char *buf;
> +	char *msg = "(null)";
> +	audit_log_format(ab, " cmdline=");
> +
> +	/* Not  cached */
> +	if (!context->cmdline) {
> +		buf = kmalloc(PATH_MAX, GFP_KERNEL);
> +		if (!buf)
> +			goto out;
> +		res = get_cmdline(tsk, buf, PATH_MAX);
> +		/* Ensure NULL terminated */
> +		if (buf[res-1] != '\0')
> +			buf[res-1] = '\0';

This accesses memory below the buffer if get_cmdline returned 0, which I
believe will be the case when someone jokingly unmaps the area (all
maybe when it is swapped out but can't be swapped in due to I/O errors).

Also since you are just putting 0 in there anyway I don't see much point
in testing for it.

> +		context->cmdline = buf;
> +	}
> +	msg = context->cmdline;
> +out:
> +	audit_log_untrustedstring(ab, msg);
> +}
> +



-- 
Mateusz Guzik
